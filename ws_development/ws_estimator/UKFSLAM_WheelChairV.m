classdef UKFSLAM_WheelChairV < ESTIMATOR_CLASS
    % Unscented Kalman filter
    %   model :
    %   param : required field : Q,R,B,JacobianH
    properties
        result%esitimated parameter
        Q%model noise
        R% observe noise
        dt%step time
        n%model dimention
        k%scaling parameters
        self%obj self
        constant%Line threadthald parameter
        map_param
        Map_Q
        Analysis%For analysis parameter
    end
    
    methods
        function obj = UKFSLAM_WheelChairV(self,param)
            obj.self= self;
            model = self.model;
            % --this state use in only UKFSLAM--
            obj.result.Est_state= [model.state.p;model.state.q];%x, y, theta
            %------------------------------
            obj.result.state= state_copy(model.state);
            obj.n = param.dim;%robot state dimension
            obj.Map_Q = param.Map_Q;% map variance
            obj.Q = param.Q;% model variance
            obj.R = param.R;% observation noise variance
            obj.k = param.k;
            obj.dt = model.dt; % tic time
            obj.result.P = param.P;%covariance
            obj.Analysis.P = param.P;%covariance  for differ entropy
            
            % the constant value for estimating of the map
            obj.constant = struct; %constant parameter
            obj.constant.LineThreshold = 0.1; % Under the this threshold, the error from "ax + by + c" is allowed.
            obj.constant.PointThreshold = 0.1; % Maximum distance between line and points in same cluster
            obj.constant.GroupNumberThreshold = 5; % Minimum points number which is constructed cluster
            obj.constant.DistanceThreshold = 1e-1; % If the error between calculated and measured distance is under this distance, is it available calculated value
            obj.constant.ZeroThreshold = 1e-5; % Under this threshold, it is zero.
            obj.constant.CluteringThreshold = 0.1; % Split a cluster using distance from next point
            obj.constant.SensorRange = 40; % Max scan range
            %------------------------------------------
            obj.Analysis.Gram = param.Gram;
            obj.Analysis.Gram.SaveP(obj.result.P);
        end
        
        function [result]=do(obj,param,~)
            %model: nolinear model
            model=obj.self.model;
            %sigma points of previous step 
            StateCount = length(obj.result.Est_state);
            PreXh = obj.result.Est_state;%previous estimation
            CholCov = chol(obj.result.P);%cholesky factoryzation 
            Kai = [PreXh,...
                cell2mat(arrayfun(@(i) PreXh + sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false)),...
                cell2mat(arrayfun(@(i) PreXh - sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false))];%sigma point
            weight = [obj.k/(StateCount + obj.k), 1/(2*(StateCount + obj.k))];
            
            if isfield(obj.self.controller,'result')
                if ~isempty(obj.self.controller.result)
                    u = obj.self.controller.result.input;
                else
                    u=[0,0];
                end
            else
                u=[0,0];
            end
            
            %sigma point update 
            sol = arrayfun(@(i) ode45(@(t,x) model.method(x,u,model.param),[0 obj.dt],Kai(1:obj.n,i)), 1:2*StateCount + 1);
            x = linspace(0,obj.dt,10);
            rKai = arrayfun(@(i) deval(sol(i),x), 1:2*StateCount + 1, 'UniformOutput', false);
            mKai = Kai(obj.n+1:StateCount,:);
            Kai = zeros(StateCount,2*StateCount+1);
            for i = 1:2*StateCount+1
                Kai(:,i) = [rKai{1,i}(:,end);mKai(:,i)];%Kai = sigma point;
            end
            %Pre estimation [x;y;theta;map's]%事前状態推定
            PreXh = Kai(:,1) * weight(1)+sum(Kai(:,2:end)*weight(2),2);
           
            %Previous Covariance matrix
            PreCov = weight(1) * (Kai(:,1) - PreXh) * (Kai(:,1) - PreXh)';
            for i = 2:2*StateCount+1
                PreCov = PreCov + weight(2) * (Kai(:,i) - PreXh) * (Kai(:,i) - PreXh)';
            end
            system_noise = diag(horzcat(diag(obj.Q)', repmat(diag(obj.Map_Q)', 1, (StateCount - obj.n)/2 )));
            B = eye(StateCount) .* obj.dt;%noise channel
            PreCov = PreCov + B*system_noise*B';%事前誤差共分散行列
            
            if length(PreXh) > obj.n
                PreMap = MapStateToLineEqu(PreXh(obj.n+1:end));
                obj.map_param.a = PreMap.a;
                obj.map_param.b = PreMap.b;
                obj.map_param.c = PreMap.c;
                % Projection of start and end point on the line
                MapEnd = FittingEndPoint(obj.map_param, obj.constant);
                obj.map_param.x = MapEnd.x;
                obj.map_param.y = MapEnd.y;
            end
            %
            sensor = obj.self.sensor.result;%scan data
            measured.ranges = sensor.length;
            if iscolumn(measured.ranges)
                measured.ranges = measured.ranges';% Transposition
            end
            measured.angles = sensor.angle - PreXh(3);%raser angles
            if iscolumn(measured.angles)
                measured.angles = measured.angles';% Transposition
            end
            % Convert measurements into lines %Line segment approximation
            LSA_param = PointCloudToLine(measured.ranges, measured.angles, PreXh, obj.constant);
            % Conbine between measurements and map%
            obj.map_param = CombiningLines(obj.map_param , LSA_param, obj.constant);
            line_param = LineToLineParameter(obj.map_param);

            StateCount = obj.n + 2 * length(line_param.d);%StateCount update
            %
            if length(PreCov) < StateCount
                % Appearance new line parameter
                append_count = StateCount - length(PreCov);
                max_count = length(PreCov);
                for i = 1:append_count
                    PreCov(max_count + i, max_count + i) = 1.* 1e-7;
                end
            end
             %共分散行列を再構成
            % Optimize the map%
            [obj.map_param, removing_flag] = OptimizeMap(obj.map_param, obj.constant);
            % Update estimate covariance %
            if any(removing_flag)
                exist_flag = sort([1, 2, 3,(find(~removing_flag) - 1) * 2 + 4, (find(~removing_flag) - 1) * 2 + 5]);
                PreCov = PreCov(exist_flag, exist_flag);
            end
            
            %シグマポイント再計算
            %sigma points of re calculate
            PreMh = zeros(2 * length(line_param.d),1);
            PreMh(1:2:end-1, 1) = line_param.d;
            PreMh(2:2:end, 1) = line_param.delta;
            PreXh = [PreXh(1:obj.n);PreMh(1:end)];
            CholCov = chol(PreCov);%cholesky factoryzation 
            Kai = [PreXh,...
                cell2mat(arrayfun(@(i) PreXh + sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false)),...
                cell2mat(arrayfun(@(i) PreXh - sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false))];%sigma point
            weight = [obj.k/(StateCount + obj.k), 1/(2*(StateCount + obj.k))]; 
            %再計算されたシグマポイントで対応付け
            % association between measurements and map
            %             association_info.index = correspanding wall(line_param) number index
            %            association_info.distance = wall distace
            association_info = cell(1,size(Kai,2));
            association_available_index = cell(1,size(Kai,2));
            association_available_count = cell(1,size(Kai,2));
            for i = 1:size(Kai,2)
            association_info{1,i} = UKFMapAssociation(Kai(1:obj.n,i), Kai(obj.n+1:end,i), measured.ranges, measured.angles, obj.constant,obj.map_param);
            association_available_index{1,i} = find(association_info{1,i}.index ~= 0);%Index corresponding to the measured value
            association_available_count{1,i} = length(association_available_index{1,i});%Count
            end
            %出力のシグマポイントを計算
            %sensing step
            %測定値が取れていないレーザー部分はダミーデータ0をかませる
            Ita = cell(1,size(Kai,2));
            j = 1;
            for i = 1:size(Kai,2)
            Ita{1,i} = zeros(length(measured.ranges), 1);
            for m = 1:length(measured.ranges)
                if isempty(association_available_index{1,i})
                     j = 1;
                    continue;
                elseif m ==association_available_index{1,i}(j)
                curr = association_available_index{1,i}(j);
                idx = association_info{1,i}.index(association_available_index{1,i}(j));
                angle = Kai(3,i) + measured.angles(curr) - Kai(obj.n+2*idx,i);
                denon = Kai(obj.n+2*(idx-1) + 1,i) - Kai(1,i) * cos(Kai(obj.n+2*idx,i)) - Kai(2,i) * sin(Kai(obj.n+2*idx,i));
                % Observation value
                Ita{1,i}(m,1) = (denon) / cos(angle);
                j = j+1;
                if j>length(association_available_index{1,i})
                    j = 1;
                    continue;
                end
                else
                    
                end
            end
            j = 1;
            end
            %
            %事前出力推定値
            PreYh = weight(1) * Ita{1,1};
            for i = 2:size(Kai,2)
                PreYh = PreYh + weight(2) * Ita{1,i};
            end
            %事前出力誤差共分散行列
            PreYCov = weight(1) * (Ita{1,1} - PreYh) * (Ita{1,1} - PreYh)';
             for i = 2:size(Kai,2)
                PreYCov = PreYCov + weight(2) * (Ita{1,i} - PreYh) * (Ita{1,i} - PreYh)';
             end
             %事前状態，出力誤差共分散行列
             PreXYCov = weight(1) * (Kai(:,1) - PreXh) * (Ita{1,1} - PreYh)';
             for i = 2:size(Kai,2)
                PreXYCov = PreXYCov + weight(2) * (Kai(:,i) - PreXh) * (Ita{1,i} - PreYh)';
             end
            %カルマンゲイン
            G = PreXYCov / (PreYCov + obj.R .* eye(length(measured.ranges)) );
            
            Xh = PreXh + G*(measured.ranges' - PreYh);
            obj.result.P = PreCov - G * (PreYCov + obj.R .* eye(length(measured.ranges))) * G';
            
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param.d = Xh(obj.n + 1:2:end, 1);
            line_param.delta = Xh(obj.n+1:2:end, 1);
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param_opt = LineParameterToLine(line_param, obj.constant);
            obj.map_param.a = line_param_opt.a;
            obj.map_param.b = line_param_opt.b;
            obj.map_param.c = line_param_opt.c;
            % Projection of start and end point on the line
            MapEnd = FittingEndPoint(obj.map_param, obj.constant);
            obj.map_param.x = MapEnd.x;
            obj.map_param.y = MapEnd.y;
            % Optimize the map
            [obj.map_param, removing_flag] = OptimizeMap(obj.map_param, obj.constant);
            % Update estimate covariance %
            if any(removing_flag)
                exist_flag = sort([1, 2, 3,(find(~removing_flag) - 1) * 2 + 4, (find(~removing_flag) - 1) * 2 + 5]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end
            obj.result.state.set_state(Xh);
            obj.result.Est_state = Xh;
            obj.result.G = G;
            result=obj.result;
        end
        function show()
            
        end
        
    end
end