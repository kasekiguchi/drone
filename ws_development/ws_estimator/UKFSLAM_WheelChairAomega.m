classdef UKFSLAM_WheelChairAomega < ESTIMATOR_CLASS
    % Unscented Kalman filter
    %  State: Robot State,x,y,theta
    %   model :
    %   param :
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
        NLP%Number of Line Params
    end
    
    methods
        function obj = UKFSLAM_WheelChairAomega(self,param)
            obj.self= self;
            model = self.model;
            % --this state use in only UKFSLAM--
            obj.result.Est_state= [model.state.p;model.state.q;model.state.v];%x, y, theta,v
            %------------------------------
            obj.result.state= state_copy(model.state);
            obj.n = param.dim;%robot state dimension
            obj.Map_Q = param.Map_Q;% map variance
            obj.Q = param.Q;% model variance
            obj.R = param.R;% observation noise variance
            obj.k = param.k;
            obj.dt = model.dt; % tic time
            obj.result.P = param.P;%covariance
            obj.NLP = param.NLP;%Number of Line Param
            
            % the constant value for estimating of the map
            obj.constant = struct; %constant parameter
            obj.constant.LineThreshold = 0.3; % Under the this threshold, the error from "ax + by + c" is allowed.
            obj.constant.PointThreshold = 0.1; % Maximum distance between line and points in same cluster
            obj.constant.GroupNumberThreshold = 5; % Minimum points number which is constructed cluster
            obj.constant.DistanceThreshold = 1e-1; % If the error between calculated and measured distance is under this distance, is it available calculated value
            obj.constant.ZeroThreshold = 1e-3; % Under this threshold, it is zero.
            obj.constant.CluteringThreshold = 0.5; % Split a cluster using distance from next point
            obj.constant.SensorRange = param.SensorRange; % Max scan range
            %------------------------------------------
        end
        
        function [result]=do(obj,param,~)
            %model: nolinear model
            model=obj.self.model;
            %% sigma points of previous step
            StateCount = length(obj.result.Est_state);%前ステップの状態数
            PreXh = obj.result.Est_state;%previous estimation
            CholCov = chol(obj.result.P)';%cholesky factoryzation
            Kai = [PreXh,...
                cell2mat(arrayfun(@(i) PreXh + sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false)),...
                cell2mat(arrayfun(@(i) PreXh - sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false))];%sigma point
            weight = [obj.k/(StateCount + obj.k), 1/(2*(StateCount + obj.k))];
            if isempty(obj.self.input)
                u=[0;0];
            else
                u = obj.self.input;
            end
            
            %% sigma point update
            sol = arrayfun(@(i) ode45(@(t,x) model.method(x,u,model.param), [0 obj.dt], Kai(1:obj.n,i)), 1:2*StateCount+1);
            x = linspace(0,obj.dt,10);
            rKai = arrayfun(@(i) deval(sol(i),x), 1:2*StateCount + 1, 'UniformOutput', false);%ロボットのシグマポイント（モデルで動きを出したやつ）
            mKai = Kai(obj.n+1:end,:);%マップのシグマポイント
            Kai = zeros(StateCount,2*StateCount+1);
            for i = 1:2*StateCount+1
                Kai(:,i) = [rKai{1,i}(:,end);mKai(:,i)];%Kai = sigma point;
            end
            %Pre estimation [x;y;theta;map's]%事前状態推定
            PreXh = weight(1) .* Kai(:,1);
            for i = 2:size(Kai,2)
                PreXh = PreXh + weight(2) .*Kai(:,i);
            end
            %Previous Covariance matrix
            PreCov = weight(1) .* (Kai(:,1) - PreXh) * (Kai(:,1) - PreXh)';
            for i = 2:size(Kai,2)
                PreCov = PreCov + weight(2) .* (Kai(:,i) - PreXh) * (Kai(:,i) - PreXh)';
            end
            system_noise = diag(horzcat(diag(obj.Q)', repmat(diag(obj.Map_Q)', [1, (StateCount - obj.n)]) ) );
            B = eye(StateCount) .* obj.dt;%noise channel
            PreCov = PreCov + B * system_noise * B';%事前誤差共分散行列
            %PreCovの次元数は，ロボットの次元数 + 前時刻のマップパラメータの数に対応
            obj.result.PreXh = PreXh;
            
            %マップについての更新
            %SLAM algorithm
            sensor = obj.self.sensor.result;%scan data
            measured.ranges = sensor.length;
            if iscolumn(measured.ranges)
                measured.ranges = measured.ranges';% Transposition
            end
            measured.angles = sensor.angle - PreXh(3);%raser angles.姿勢角を基準とする．
            if iscolumn(measured.angles)
                measured.angles = measured.angles';% Transposition
            end
            % Convert measurements into lines %Line segment approximation%観測値をクラスタリングしてマップパラメータを作り出す
            LSA_param = UKFPointCloudToLine(measured.ranges, measured.angles, PreXh(1:3), obj.constant);
            % Conbine between measurements and map%前時刻までのマップと観測値を組み合わせる．組み合わさらなかったら新しいマップとして足す．
            obj.map_param = UKFCombiningLines(obj.map_param , LSA_param, obj.constant);%
            %For Verification
            obj.result.PreMapParam.x = obj.map_param.x;
            obj.result.PreMapParam.y = obj.map_param.y;
            %StateCount update
            StateCount = obj.n + obj.NLP * length(obj.map_param.a);
            %map_paramに対応したPreCovにする．
            if length(PreCov) < StateCount
                % Appearance new line parameter
                append_count = StateCount - length(PreCov);
                max_count = length(PreCov);
                for i = 1:append_count
                    PreCov(max_count + i, max_count + i) = 1.* 1.0E-6;%PreCovの数が足りなければ足す
                end
            end
            
            % Optimize the map%
            [obj.map_param, RegistFlag] = UKFOptimizeMap(obj.map_param, obj.constant);%ここですぐ減らされている．
            %convert to Line parameter that consisted from d and delta
            line_param = LineToLineParamAndEndPoint(obj.map_param);
            
            %共分散行列を再構成
            % Update estimate covariance %
            if any(RegistFlag)
                exist_flag = sort([1, 2, 3, 4, (find(~RegistFlag) - 1) * 2 + 5, (find(~RegistFlag) - 1) * 2 + 6]);
                PreCov = PreCov(exist_flag, exist_flag);
            end
            
            %UKF Algorithm
            %シグマポイント再計算
            % re calculate of sigma points
            StateCount = obj.n + obj.NLP * length(line_param.d);
            PreMh = zeros(obj.NLP * length(line_param.d),1);
            PreMh(1:obj.NLP:end, 1) = line_param.d;
            PreMh(2:obj.NLP:end, 1) = line_param.delta;
            PreXh = [PreXh(1:obj.n);PreMh(1:end)];
            CholCov = chol(PreCov)';%cholesky factoryzation
            
            if length(CholCov)~= length(PreXh)
                disp('error');
            end
            
            Kai = [PreXh,...
                cell2mat(arrayfun(@(i) PreXh + sqrt(StateCount + obj.k) .* CholCov(:,i) , 1:StateCount , 'UniformOutput' , false)),...
                cell2mat(arrayfun(@(i) PreXh - sqrt(StateCount + obj.k) .* CholCov(:,i) , 1:StateCount , 'UniformOutput' , false))];%sigma point
            weight = [obj.k/(StateCount + obj.k), 1/( 2*(StateCount + obj.k) )];
            %再計算されたシグマポイントのマップパラメータごとのマップ端点を計算
            EndPoint = SigmaLineParamToEndPoint(Kai,obj.map_param,obj.n,obj.constant);
            
            %事前状態推定値を用いてマップと対応付け
            % association between measurements and map
            % association_info.index = correspanding wall(line_param) number index
            % association_info.distance = wall distace
            association_info = UKFMapAssociation(PreXh(1:obj.n),PreMh(1:end), EndPoint{1,1}, measured.ranges,measured.angles, obj.constant,obj.NLP);
            association_available_index = find(association_info.index ~= 0);%Index corresponding to the measured value
            association_available_count = length(association_available_index);%Count
            %出力のシグマポイントを計算
            %sensing step
            %測定値が取れていないレーザー部分はダミーデータ0をかませる
            
            Ita = cell(1,size(Kai,2));
            for i = 1:size(Kai,2)%i:シグマポイントの数
                tmp_angles = sensor.angle - Kai(3,1);
                if iscolumn(tmp_angles)
                    tmp_angles = tmp_angles';% Transposition
                end
                line_param.d = Kai(obj.n + 1:obj.NLP:end,i);
                line_param.delta = Kai(obj.n + 2:obj.NLP:end,i);
                Ita{1,i} = zeros(association_available_count,1);
                for m = 1:association_available_count%m:レーザの番号
                    curr = association_available_index(1,m);
                    idx = association_info.index(1,association_available_index(1,m));
                    angle = Kai(3,i) + tmp_angles(curr) - line_param.delta(idx);
                    denon = line_param.d(idx) - Kai(1,i) * cos(line_param.delta(idx)) - Kai(2,i) * sin(line_param.delta(idx));
                    % Observation value
                    Ita{1,i}(m,1) = (denon) / cos(angle);
                end
            end
            %事前出力推定値
            PreYh = weight(1) .* Ita{1,1}(:);
            for i = 2:size(Kai,2)
                PreYh = PreYh + weight(2) .* Ita{1,i}(:);
            end
            %事前出力誤差共分散行列
            PreYCov = weight(1) .* (Ita{1,1}(:) - PreYh) * (Ita{1,1}(:) - PreYh)';
            for i = 2:size(Kai,2)
                PreYCov = PreYCov + weight(2) .* (Ita{1,i}(:) - PreYh) * (Ita{1,i}(:) - PreYh)';
            end
            %事前状態，出力誤差共分散行列
            PreXYCov = weight(1) .* (Kai(:,1) - PreXh) * (Ita{1,1}(:) - PreYh)';
            for i = 2:size(Kai,2)
                PreXYCov = PreXYCov + weight(2) .* (Kai(:,i) - PreXh) * (Ita{1,i}(:) - PreYh)';
            end
            %カルマンゲイン
            G = PreXYCov /( PreYCov + obj.R .* eye(association_available_count) );
            Xh = PreXh + G * (measured.ranges(association_available_index)' - PreYh);
            obj.result.P = PreCov - G * (PreYCov + obj.R .* eye(association_available_count)) * G';
            
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param.d = Xh(obj.n+1:obj.NLP:end,1);
            line_param.delta = Xh(obj.n+2:obj.NLP:end,1);
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param_opt = LineParamToLineAndEndPoint(line_param);
            obj.map_param.a = line_param_opt.a;
            obj.map_param.b = line_param_opt.b;
            obj.map_param.c = line_param_opt.c;
            % Projection of start and end point on the line
            MapEnd = FittingEndPoint(obj.map_param, obj.constant);
            obj.map_param.x = MapEnd.x;
            obj.map_param.y = MapEnd.y;
            [obj.map_param,RegistFlag] = UKFOptimizeMap(obj.map_param, obj.constant);
            line_param = LineToLineParamAndEndPoint(obj.map_param);%lineparam d and delta and endpoint is calculated
            
            MapEnd.x = obj.map_param.x;
            MapEnd.y = obj.map_param.y;
            
            EstMh = zeros(obj.NLP * length(line_param.d),1);
            EstMh(1:obj.NLP:end, 1) = line_param.d;
            EstMh(2:obj.NLP:end, 1) = line_param.delta;
            Xh = [Xh(1:obj.n);EstMh(1:end)];
            
            if any(RegistFlag)
                exist_flag = sort([1, 2, 3, 4,(find(~RegistFlag) - 1) * 2 + 5, (find(~RegistFlag) - 1) * 2 + 6]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end
            
            if length(obj.result.P) ~= length(Xh)
                disp('error');
            end
            
            % return values setting
            obj.result.state.set_state(Xh);
            obj.result.Est_state = Xh;
            obj.result.G = G;
            obj.result.map_param = obj.map_param;
            obj.result.AssociationInfo = UKFMapAssociation(Xh(1:obj.n),Xh(obj.n+1:end), MapEnd, measured.ranges,measured.angles, obj.constant,obj.NLP);
            result=obj.result;
        end
        function show()
            
        end
        
    end
end