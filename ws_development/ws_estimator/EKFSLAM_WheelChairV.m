classdef EKFSLAM_WheelChairV < ESTIMATOR_CLASS
    % Extended Kalman filter
    % obj = EKF(model,param)
    %   model : EKF郢ァ雋橸スョ貅ッ?ス」?ソス邵コ蜷カ?ス玖崕?スカ陟包ス。陝?スセ髮趣ス。邵コ?スョ陋サ?スカ陟包ス。郢晢ス「郢晢ソス郢晢スォ
    %   param : required field : Q,R,B,JacobianH
    properties
        result%esitimated parameter
        Q
        R
        dt
        n
        self
        constant%Line threadthald parameter
        map_param
        Map_Q
        Analysis%For analysis parameter
        JacobianF
    end
    
    methods
        function obj = EKFSLAM_WheelChairV(self,param)
            obj.self= self;
            model = self.model;
            obj.JacobianF = @(v,theta) [1,0,-v*sin(theta);0,1,v*cos(theta);0,0,1];%
            % --this state use in only EKFSLAM--
            obj.result.Est_state= STATE_CLASS(struct("state_list",["p","q"],"num_list",[2,1]));
            obj.result.Est_state.p = model.state.p;% x, y
            obj.result.Est_state.q = model.state.q;% th
            %------------------------------
            obj.result.state= state_copy(model.state);
            obj.n = length(obj.result.Est_state.get());
            obj.Map_Q = param.Map_Q;% map variance
            obj.Q = param.Q;% model variance
            obj.R = param.R;% observation noise variance
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
            %   param : optional
            model=obj.self.model;
            sensor = obj.self.sensor.result;%scan data
            xh_pre = model.state.get(); %事前推定
            pre_state = [xh_pre(1),xh_pre(2),xh_pre(3)];%[x,y,theta]
            
            if isfield(obj.self.controller,'result')
                if ~isempty(obj.self.controller.result)
                    u = obj.self.controller.result.input;
                    cparamK = obj.self.model.param.K;
                    u(1) = u(1)*cparamK;
                else
                    u=[0,0];
                end
            else
                u=[0,0];
            end
            %
            measured.ranges = sensor.length;
            measured.angles = sensor.angle - xh_pre(3);%
            if iscolumn(measured.ranges)
                measured.ranges = measured.ranges';% Transposition
            end
            if iscolumn(measured.angles)
                measured.angles = measured.angles';% Transposition
            end
            % Convert measurements into lines %Line segment approximation
            LSA_param = PointCloudToLine(measured.ranges, measured.angles, pre_state, obj.constant);
            % Conbine between measurements and map%雋ゑスャ陞ウ螢シ?ソス?ス、邵コ?スィ郢晄ァュ繝」郢晏干?ス帝お?ソス邵コ?スソ陷キ蛹サ?ス冗クコ蟶呻ス?
            obj.map_param = CombiningLines(obj.map_param, LSA_param, obj.constant);
            % Convert map into line parameters%郢ァ?スー郢晢スュ郢晢スシ郢晁?湖晁?趣スァ隶灘生縲帝囎荵昶螺驍ア螢シ?ソス邵コ?スョ郢昜サ」ホ帷ケ晢ス。郢晢スシ郢ァ?スソ
            line_param = LineToLineParameter(obj.map_param);
            % association between measurements and map
            %             association_info.index = correspanding wall(line_param) number index
            %            association_info.distance = wall distace
            association_info = MapAssociation(obj.map_param, line_param, pre_state, measured.ranges, measured.angles, obj.constant);
            association_available_index = find(association_info.index ~= 0);%Index corresponding to the measured value
            association_available_count = length(association_available_index);%Count
            
            %EKF Algorithm
            mapstate_count = 2 * size(line_param.d, 1);
            state_count = obj.n + mapstate_count;
            
            pre_Eststate = [xh_pre(1),xh_pre(2),xh_pre(3)];
            A = eye(state_count);
            A(1:3,1:3) = obj.JacobianF(u(1),pre_Eststate(3));
            B = eye(state_count) .* obj.dt;
            %
            C = zeros(length(measured.angles), state_count);
            Y = zeros(length(measured.angles), 1);
            for i = 1:length(measured.angles)
                if i == association_available_index(i)
                    curr = association_available_index(i);
                    idx = association_info.index(association_available_index(i));
                    angle = pre_state(3) + measured.angles(curr) - line_param.delta(idx);
                    denon = line_param.d(idx) - pre_state(1) * cos(line_param.delta(idx)) - pre_state(2) * sin(line_param.delta(idx));
                    % Observation value
                    Y(i, 1) = (denon) / cos(angle);
                    % Observation jacobi matrix
                    C(i, 1) = -cos(line_param.delta(idx)) / cos(angle);%x位置に関わる
                    C(i, 2) = -sin(line_param.delta(idx)) / cos(angle);%y位置に関わる
                    C(i, 3) = denon * tan(angle) / cos(angle);%姿勢角thetaに関わる
                    C(i, 4 + (idx - 1) * 2) = 1 / cos(angle);%マップの距離dに関わる
                    C(i, 5 + (idx - 1) * 2) = (pre_state(1) * sin(line_param.delta(idx)) - pre_state(2) * cos(line_param.delta(idx))) / cos(angle) ...
                        - denon * tan(angle) / cos(angle);%マップの角度alphaに関わる．
                else
                    
                end
            end
            %
            xh_m = zeros(state_count,1);
            xh_m(1:obj.n,1) = pre_Eststate';
            xh_m(obj.n+1:2:end, 1) = line_param.d;
            xh_m(obj.n+2:2:end, 1) = line_param.delta;
            %
            if length(obj.result.P) < state_count
                % Appearance new line parameter
                append_count = state_count - length(obj.result.P);
                max_count = length(obj.result.P);
                for i = 1:append_count
                    obj.result.P(max_count + i, max_count + i) = 1.* 1e-7;
                end
            end
            %%%for analysis%%%%%%%%%%
            obj.Analysis.PrevCov = obj.result.P;
            %%%%%%%%%%%%%%%%%
            %predictiive step
            system_noise = diag(horzcat(diag(obj.Q)', repmat(diag(obj.Map_Q)', 1, size(line_param.d, 1))));
            P_pre  = A*obj.result.P*A' + B*system_noise*B';       %
            %%%
            %%%%%%%%%correlation coefficient
            %             r = cos(2*(pre_Eststate(3) - (pi/4)));
            % %             r = sign(r);
            % %             [~,sigma] = corrcov(P_pre);
            %             sigmaxy = sqrt(P_pre(1,1)) * sqrt(P_pre(2,2)) * r;
            %             P_pre(1,2) = (sigmaxy);
            %             P_pre(2,1) = (sigmaxy);
            %%%%%%%%%%%%%%%%%%%%%
            %observe step
            G = (P_pre*C')/(C*P_pre*C'+ obj.R .* eye( length(measured.ranges) ) ); %
            %             tmpvalue = xh_pre + G*(obj.y.get()-C*xh_pre);	%
            tmpvalue = xh_m + G * (measured.ranges' - Y);%
            obj.result.P    = (eye(state_count)-G*C)*P_pre;	%
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param.d = tmpvalue(4:2:end, 1);
            line_param.delta = tmpvalue(5:2:end, 1);
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param_opt = LineParameterToLine(line_param, obj.constant);
            obj.map_param.a = line_param_opt.a;
            obj.map_param.b = line_param_opt.b;
            obj.map_param.c = line_param_opt.c;
            % Projection of start and end point on the line
            point_opt = FittingEndPoint(obj.map_param, obj.constant);
            obj.map_param.x = point_opt.x;
            obj.map_param.y = point_opt.y;
            % Optimize the map%
            [obj.map_param, removing_flag] = OptimizeMap(obj.map_param, obj.constant);
            % Update estimate covariance %
            if any(removing_flag)
                exist_flag = sort([1, 2, 3,(find(~removing_flag) - 1) * 2 + 4, (find(~removing_flag) - 1) * 2 + 5]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end
            obj.result.state.set_state(tmpvalue);
            obj.result.Est_state.set_state(tmpvalue);
            obj.result.G = G;
            obj.result.map_param.x = obj.map_param.x;
            obj.result.map_param.y = obj.map_param.y;
            %             run('AnalysisEKFInfo');%analysis
            result=obj.result;
        end
        function show()
            
        end
        
    end
end