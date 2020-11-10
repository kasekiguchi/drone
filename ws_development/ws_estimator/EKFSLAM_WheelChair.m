classdef EKFSLAM_WheelChair < ESTIMATOR_CLASS
   % Extended Kalman filter
    % obj = EKF(model,param)
    %   model : EKF郢ァ雋橸スョ貅ッ?ス」?ソス邵コ蜷カ?ス玖崕?スカ陟包ス。陝?スセ髮趣ス。邵コ?スョ陋サ?スカ陟包ス。郢晢ス「郢晢ソス郢晢スォ
    %   param : required field : Q,R,B,JacobianH
    %  JacobianH(x,p) : 陷?スコ陷牙クカ蟀ソ驕槫唱?スシ荳奇ソス?スョ隲。?ス。陟托スオ驍ア螢シ?スス?ス「陋ケ謔カ?シ?邵コ貊?譛ェ隰ィ?スー邵コ?スョhandle
      properties
        %state
        result%esitimated parameter
%         A
        JacobianF%
        JacobianH
%         H
        Q
        R
        dt
        n
%         y
        self
        constant%Line threadthald parameter
        map_param
        Map_Q
        Analysis%For analysis parameter
    end
    
    methods
        function obj = EKFSLAM_WheelChair(self,param)
            obj.self= self;
            model = self.model;
            obj.JacobianF = @(v,theta) [0,0,-v*sin(theta);0,0,v*cos(theta);0,0,0];%
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
            obj.constant.DistanceThreshold = 1e-3; % If the error between calculated and measured distance is under this distance, is it available calculated value
            obj.constant.ZeroThreshold = 1e-5; % Under this threshold, it is zero.
            obj.constant.CluteringThreshold = 0.1; % Split a cluster using distance from next point
            obj.constant.SensorRange = 40; % Max scan range
        end
        
        function [result]=do(obj,param,~)
            %   param : optional
            model=obj.self.model;
            sensor = obj.self.sensor.result;%scan data
            
            
            xh_pre = model.state.get(); % 闔?蜿・辯戊ャ暦スィ陞ウ?ソス ?ソス?スシ螢シ?ソス?ス・陷牙ク吮旺郢ァ鄙ォ?ソス?スョ陜」?スエ陷キ?ソス ?ソス?スシ?ソスmodel邵コ譴ァ蟲ゥ隴?スー邵コ霈費ス檎クコ?スヲ邵コ?ソス郢ァ蜿・辯戊ャ?謦ー?スシ?ソス
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
            measured.angles = sensor.angle - xh_pre(3);%隶匁サ会スス阮呻ソス?スョ隴?スケ陷キ莉」?ス堤ケァ?スシ郢晢スュ邵コ?スィ邵コ蜉ア笳?郢晢スャ郢晢スシ郢ァ?スカ郢晢スシ邵コ?スョ郢ァ?ス「郢晢スウ郢ァ?スー郢晢スォ
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
            association_info = AllMapAssociation(obj.map_param, line_param, pre_state, measured.ranges, measured.angles, obj.constant);
            association_available_index = find(association_info.index ~= 0);%Index corresponding to the measured value
            association_available_count = length(association_available_index);%Count
            
            %EKF Algorithm
            mapstate_count = 2 * size(line_param.d, 1);
            state_count = obj.n + mapstate_count;
            
            pre_Eststate = [xh_pre(1),xh_pre(2),xh_pre(3),obj.result.Est_state.v,obj.result.Est_state.w];
            A = eye(state_count);
            A(1:3,1:5) = [1,0,-sin(pre_Eststate(3))*pre_Eststate(4)*obj.self.model.dt,cos(pre_Eststate(3))*obj.self.model.dt,0;
                          0,1,cos(pre_Eststate(3))*pre_Eststate(4)*obj.self.model.dt,sin(pre_Eststate(3))*obj.self.model.dt,0;
                          0,0,1,0,obj.self.model.dt];
%             A(1:3,1:3) = obj.JacobianF(u(1),xh_pre(3)); % Euler approximation
            B = eye(state_count) .* obj.dt;
%       
            C = zeros(association_available_count, state_count);
            Y = zeros(association_available_count, 1);
%             C = diag([obj.JacobianH(x,p),eye(mapstate_count)*obj.dt]);
            for i = 1:association_available_count
                curr = association_available_index(i);
                idx = association_info.index(association_available_index(i));
                angle = pre_state(3) + measured.angles(curr) - line_param.delta(idx);
                denon = line_param.d(idx) - pre_state(1) * cos(line_param.delta(idx)) - pre_state(2) * sin(line_param.delta(idx));
                % Observation value
                Y(i, 1) = (denon) / cos(angle);
                % Observation jacobi matrix
                C(i, 1) = -cos(line_param.delta(idx)) / cos(angle);
                C(i, 2) = -sin(line_param.delta(idx)) / cos(angle);
                C(i, 3) = denon * tan(angle) / cos(angle);
                C(i, 4) = 0;
                C(i, 5) = 0;
                C(i, 6 + (idx - 1) * 2) = 1 / cos(angle);
                C(i, 7 + (idx - 1) * 2) = (pre_state(1) * sin(line_param.delta(idx)) - pre_state(2) * cos(line_param.delta(idx))) / cos(angle) ...
                                            - denon * tan(angle) / cos(angle);
            end
            
            %郢晄ァュ繝」郢晏干?ス定惺?スォ郢ァ竏壺螺闔?蜿・辯戊滋蝓滂スク?スャ陋滂ス、
            xh_m = zeros(state_count,1);
            xh_m(1:obj.n,1) = pre_Eststate';
            xh_m(obj.n+1:2:end, 1) = line_param.d;
            xh_m(obj.n+2:2:end, 1) = line_param.delta;
            %髫ア?ス、陝セ?スョ陷茨スア陋サ?ソス隰ィ?ス」髯ヲ謔滂ソス蜉ア?ソス?スョ郢ァ?スオ郢ァ?ス、郢ァ?スコ陞溽判蟲ゥ?ソス?スシ蝓溽悛邵コ蜉ア?シ樣こ螢シ?ソス邵コ蠕娯旺邵コ?ス」邵コ貅倪?堤クコ?ソス)
            if length(obj.result.P) < state_count
                % Appearance new line parameter
                append_count = state_count - length(obj.result.P);
                max_count = length(obj.result.P);
                for i = 1:append_count
                    obj.result.P(max_count + i, max_count + i) = 1.* 1e-7;
                end
            end
            %%%for analysis%%%%%%%%%%
            obj.Analysis.P = obj.result.P;
            %%%%%%%%%%%%%%%%%
            system_noise = diag(horzcat(diag(obj.Q)', repmat(diag(obj.Map_Q)', 1, size(line_param.d, 1))));
            P_pre  = A*obj.result.P*A' + B*system_noise*B';       % 闔?蜿・辯暮坡?ス、陝セ?スョ陷茨スア陋サ?ソス隰ィ?ス」髯ヲ謔滂ソス?ソス
            G = (P_pre*C')/(C*P_pre*C'+ obj.R .* eye(association_available_count)); % 郢ァ?スォ郢晢スォ郢晄ァュホヲ郢ァ?スイ郢ァ?ス、郢晢スウ隴厄スエ隴?スー
%             tmpvalue = xh_pre + G*(obj.y.get()-C*xh_pre);	% 闔?蜿・?スセ譴ァ閠ウ陞ウ?ソス
            tmpvalue = xh_m + G * (measured.ranges(association_available_index)' - Y);% 闔?蜿・?スセ譴ァ閠ウ陞ウ?ソス
            obj.result.P    = (eye(state_count)-G*C)*P_pre;	% 闔?蜿・?スセ迹夲スェ?ス、陝セ?スョ陷茨スア陋サ?ソス隰ィ?ス」
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param.d = tmpvalue(6:2:end, 1);
            line_param.delta = tmpvalue(7:2:end, 1);
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param_opt = LineParameterToLine(line_param, obj.constant);
            obj.map_param.a = line_param_opt.a;
            obj.map_param.b = line_param_opt.b;
            obj.map_param.c = line_param_opt.c;
            % Projection of start and end point on the line
            point_opt = FittingEndPoint(obj.map_param, obj.constant);
            obj.map_param.x = point_opt.x;
            obj.map_param.y = point_opt.y;
             % Optimize the map%郢晄ァュ繝」郢晏干?ソス?スョ邵コ蜷カ?ス願惺蛹サ?ス冗クコ?ソス
            [obj.map_param, removing_flag] = OptimizeMap(obj.map_param, obj.constant);
            % Update estimate covariance %
            if any(removing_flag)
                exist_flag = sort([1, 2, 3, 4, 5,(find(~removing_flag) - 1) * 2 + 6, (find(~removing_flag) - 1) * 2 + 7]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end
            obj.result.state.set_state(tmpvalue);
            obj.result.Est_state.set_state(tmpvalue);
            obj.result.G = G;
            %%%%To express EKF information%%%%%%%
            [ErEl_Round] = CalcErrorEllipse(obj.result.P);%Error circle calculation
            obj.result.ErEl_Round = ErEl_Round;
            obj.result.Entropy = Calc_entropy(obj.result.P);
            [~,tmpS,~] = svd(obj.result.P);
            obj.result.SingEntropy = Calc_entropy(tmpS);
%             TmpDifferEntIndex(1) =  find(association_info.index ==1,1);
%             TmpDifferEntIndex(2) =  find(association_info.index ==2,1);
%             [PartialX,PartialY,PartialTheta,PartialV,PartialW] = differ_entropy(state_count,obj.dt,obj.Q,obj.Map_Q,obj.R,obj.Analysis.P,TmpDifferEntIndex,association_info,line_param,measured,tmpvalue);
%             obj.result.PartialX = PartialX;
%             obj.result.PartialY = PartialY;
%             obj.result.PartialTheta = PartialTheta;
%             obj.result.PartialV = PartialV;
%             obj.result.PartialW = PartialW;
            obj.Analysis.P = obj.result.P;
%             obj.result.
%             [modeltoKFKL] = Kallback_Leibra(obj.result.P(1:5,1:5),tmpvalue(1:5,1),system_noise(1:5,1:5),pre_Eststate');
%             obj.result.MtoKF_KL = modeltoKFKL;% Kallback_Leibra divergence of model and KF probability
%             [obsetvetoKFKL] = Kallback_Leibra(obj.result.P(1:5,1:5),tmpvalue(1:5,1),system_noise(1:5,1:5),pre_Eststate');
%             obj.result.OtoKF_KL = obsetvetoKFKL;% Kallback_Leibra divergence of observation and KF probability
            %%%%%%%%%%%%%%%%%%%
            result=obj.result;
        end
        function show()
            
        end
        
    end
end