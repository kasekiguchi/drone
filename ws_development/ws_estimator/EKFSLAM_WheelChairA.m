classdef EKFSLAM_WheelChairA < ESTIMATOR_CLASS
    % Extended Kalman filter
    % obj = EKF(model,param)
    %   model : 
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
    end
    
    methods
        function obj = EKFSLAM_WheelChairA(self,param)
            obj.self= self;
            model = self.model;
            %             obj.JacobianF = @(v,theta) [0,0,-v*sin(theta);0,0,v*cos(theta);0,0,0];%
            % --this state use in only EKFSLAM--
            obj.result.Est_state= STATE_CLASS(struct("state_list",["p","q","v","w"],"num_list",[2,1,1,1]));
            obj.result.Est_state.p = model.state.p;% x, y
            obj.result.Est_state.q = model.state.q;% th
            obj.result.Est_state.v = 0;% v
            obj.result.Est_state.w = 0;% W
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
            obj.constant.ZeroThreshold = 1e-3; % Under this threshold, it is zero.
            obj.constant.CluteringThreshold = 0.01; % Split a cluster using distance from next point
            obj.constant.SensorRange = 20; % Max scan range
            %------------------------------------------
%             obj.Analysis.Gram = param.Gram;
%             obj.Analysis.Gram.SaveP(obj.result.P);
        end
        
        function [result]=do(obj,param,~)
            %   param : optional
            model = obj.self.model;%ロボット事前状態
            sensor = obj.self.sensor.result;%scan data
            xh_pre = model.state.get(); %事前推定
            pre_state = [xh_pre(1),xh_pre(2),xh_pre(3)];%[x,y,theta]
            
            if isfield(obj.self.controller,'result')
                if ~isempty(obj.self.controller.result)
                    u = obj.self.controller.result.input;
                    cparamK = obj.self.model.param.K;
                    u(1) = u(1) * cparamK;
                else
                    u=[0,0];
                end
            else
                u=[0,0];
            end
            %
            measured.angles = sensor.angle - xh_pre(3);%
            if iscolumn(sensor.length)
                sensor.length = sensor.length';% Transposition
            end
            if iscolumn(measured.angles)
                measured.angles = measured.angles';% Transposition
            end
            % Convert measurements into lines %Line segment approximation
            LSA_param = PointCloudToLine(sensor.length, measured.angles, pre_state, obj.constant);
            % Conbine between measurements and map%
            obj.map_param = CombiningLines(obj.map_param, LSA_param, obj.constant);
            % Convert map into line parameters%
            line_param = LineToLineParameter(obj.map_param);
            % association between measurements and map
            %             association_info.index = correspanding wall(line_param) number index
            %            association_info.distance = wall distace
            association_info = MapAssociation(obj.map_param, line_param, pre_state, sensor.length, measured.angles, obj.constant);
            association_available_index = find(association_info.index ~= 0);%Index corresponding to the measured value
            association_available_count = length(association_available_index);%Count
            
            %observation step
            mapstate_count = 2 * size(line_param.d, 1);
            state_count = obj.n + mapstate_count;
            
            pre_Eststate = xh_pre;
            A = eye(state_count);
            A(1:3,1:5) = [1,0,-sin(pre_Eststate(3))*pre_Eststate(4)*obj.self.model.dt,cos(pre_Eststate(3))*obj.self.model.dt,0;
                0,1,cos(pre_Eststate(3))*pre_Eststate(4)*obj.self.model.dt,sin(pre_Eststate(3))*obj.self.model.dt,0;
                0,0,1,0,obj.self.model.dt];
            %             A(1:3,1:3) = obj.JacobianF(u(1),xh_pre(3)); % Euler approximation
            B = eye(state_count) .* obj.dt;
            %
            C = zeros(association_available_count, state_count);%配列用意
            Y = zeros(association_available_count, 1);%配列用意
            %             C = diag([obj.JacobianH(x,p),eye(mapstate_count)*obj.dt]);
            for i = 1:association_available_count
                curr = association_available_index(i);
                idx = association_info.index(association_available_index(i));
                angle = pre_state(3) + measured.angles(curr) - line_param.delta(idx);
                denon = line_param.d(idx) - pre_state(1) * cos(line_param.delta(idx)) - pre_state(2) * sin(line_param.delta(idx));
                % Observation value
                Y(i, 1) = (denon) / cos(angle);
                % Observation jacobi matrix
                C(i, 1) = -cos(line_param.delta(idx)) / cos(angle);%diff x position
                C(i, 2) = -sin(line_param.delta(idx)) / cos(angle);%diff y position
                C(i, 3) = denon * tan(angle) / cos(angle);%diff theta 
                C(i, 4) = 0;%diff v
                C(i, 5) = 0;%diff omega
                C(i, 6 + (idx - 1) * 2) = 1 / cos(angle);%diff map param d
                C(i, 7 + (idx - 1) * 2) = (pre_state(1) * sin(line_param.delta(idx)) - pre_state(2) * cos(line_param.delta(idx))) / cos(angle) ...
                    - denon * tan(angle) / cos(angle);% diff map param alpha
            end
            %事後状態推定のための値を格納
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
            system_noise = diag(horzcat(diag(obj.Q)', repmat(diag(obj.Map_Q)', 1, size(line_param.d, 1))));
            P_pre  = A*obj.result.P*A' + B*system_noise*B';       % 事前共分散行列
            G = (P_pre*C')/(C*P_pre*C'+ obj.R .* eye(association_available_count)); % 
            %             tmpvalue = xh_pre + G*(obj.y.get()-C*xh_pre);	% 
            tmpvalue = xh_m + G * (sensor.length(association_available_index)' - Y);% 
            obj.result.P    = (eye(state_count)-G*C)*P_pre;	% 
            
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param.d = tmpvalue(6:2:end, 1);
            line_param.delta = tmpvalue(7:2:end, 1);
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
                exist_flag = sort([1, 2, 3, 4, 5,(find(~removing_flag) - 1) * 2 + 6, (find(~removing_flag) - 1) * 2 + 7]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end
            
            obj.result.state.set_state(tmpvalue);
            obj.result.Est_state.set_state(tmpvalue);
            obj.result.G = G;
            obj.result.map_param = obj.map_param;
            obj.result.AssociationInfo = MapAssociation(obj.map_param, line_param, tmpvalue(1:3), sensor.length, measured.angles, obj.constant);
%             run('AnalysisEKFInfo');%analysis
            result=obj.result;
        end
        function show()
            
        end
        
    end
end