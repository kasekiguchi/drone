classdef UKFSLAM_WheelChairV_test < ESTIMATOR_CLASS
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
        Analysis%For analysis parameter
    end
    
    methods
        function obj = UKFSLAM_WheelChairV_test(self,param)
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
            obj.NLP = param.NLP;%Number of Line Param
            
            % the constant value for estimating of the map
            obj.constant = struct; %constant parameter
            obj.constant.LineThreshold = 0.3; % Under the this threshold, the error from "ax + by + c" is allowed.
            obj.constant.PointThreshold = 0.1; % Maximum distance between line and points in same cluster
            obj.constant.GroupNumberThreshold = 5; % Minimum points number which is constructed cluster
            obj.constant.DistanceThreshold = 1e-1; % If the error between calculated and measured distance is under this distance, is it available calculated value
            obj.constant.ZeroThreshold = 1e-3; % Under this threshold, it is zero.
            obj.constant.CluteringThreshold = 0.1; % Split a cluster using distance from next point
            obj.constant.SensorRange = 40; % Max scan range
            %------------------------------------------
            obj.Analysis.Gram = param.Gram;
            obj.Analysis.Gram.SaveP(obj.result.P);
        end
        
        function [result]=do(obj,param,~)
            %model: nolinear model
            model=obj.self.model;
            %% sigma points of previous step
            StateCount = length(obj.result.Est_state);%前ステップの状態数
            SigmaNum = 2*StateCount + 1;
            PreXh = obj.result.Est_state;%previous estimation
            Ps = chol(obj.result.P)' * sqrt(StateCount + obj.k); %cholesky factoryzation
            Kai = [PreXh, repvec(PreXh,StateCount)+Ps, repvec(PreXh,StateCount)-Ps]; %シグマポイント生成
            %             Kai = [PreXh,...
            %                 cell2mat(arrayfun(@(i) PreXh + sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false)),...
            %                 cell2mat(arrayfun(@(i) PreXh - sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false))];%sigma point
            %             weight = [obj.k/(StateCount + obj.k), 1/(2*(StateCount + obj.k))];
            
            
            if isempty(obj.self.input)
                u=[0,0];
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
            
            %--サンプルにあった計算補正--%
            Base = repvec(Kai(:,1), SigmaNum);          % set first transformed sample as the base
            delta = dfunc(Base, Kai);     % compute correct residual
            Kai = Base - delta;                  % offset ys from base according to correct residual
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Pre estimation [x;y;theta;map's]%事前状態推定
            % Calculate predicted observation mean
            idx = 2:SigmaNum;
            PreXh = (2*obj.k*Kai(:,1) + sum(Kai(:,idx),2)) / (2*(StateCount + obj.k));
            
            % Calculate new unscented covariance
            dKai = Kai - repvec(PreXh,SigmaNum);
            PreCov  = (2*obj.k*dKai(:,1)*dKai(:,1)' + dKai(:,idx)*dKai(:,idx)') / (2*(StateCount + obj.k));
            % Note: if x is a matrix of column vectors, then x*x' produces the sum of outer-products.
            
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
            [obj.map_param, RemovingFlag] = UKFOptimizeMap(obj.map_param, obj.constant);%ここですぐ減らされている．
            %線分パラメータに変換
            line_param = LineToLineParamAndEndPoint(obj.map_param);
            
            %共分散行列を再構成
            % Update estimate covariance %
            if any(RemovingFlag)
                exist_flag = sort([1, 2, 3,(find(~RemovingFlag) - 1) * 2 + 4, (find(~RemovingFlag) - 1) * 2 + 5]);
                PreCov = PreCov(exist_flag, exist_flag);
            end
            
            %UKF Algorithm
            %シグマポイント再計算
            % re calculate of sigma points
            % Create samples
            
            StateCount = size(PreCov,2);
            SigmaNum = 2*StateCount + 1;
            PreMh = zeros(obj.NLP * length(line_param.d),1);
            PreMh(1:obj.NLP:end, 1) = line_param.d;
            PreMh(2:obj.NLP:end, 1) = line_param.delta;
            PreXh = [PreXh(1:obj.n);PreMh(1:end)];
            %事前状態推定値を用いてマップと対応付け
            % association between measurements and map
            %association_info.index = correspanding wall(line_param) number index
            %association_info.distance = wall distace
            %再計算されたシグマポイントのマップパラメータごとのマップ端点を計算
            EndPoint = SigmaLineParamToEndPoint(PreXh,obj.map_param,obj.n,obj.constant);
            association_info = UKFMapAssociation(PreXh(1:obj.n),PreMh(1:end), EndPoint{1,1}, measured.ranges,measured.angles, obj.constant,obj.NLP);
            association_available_index = find(association_info.index ~= 0);%Index corresponding to the measured value
            association_available_count = length(association_available_index);%Count
            
            
            for m = 1:association_available_count
                Ps = chol(PreCov)' * sqrt(StateCount + obj.k);%cholesky factoryzation
                Kai = [PreXh, repvec(PreXh,StateCount)+Ps, repvec(PreXh,StateCount)-Ps];%sigma point

                %出力のシグマポイントを計算
                %sensing step
                zs = zeros(size(Kai,2),1);
                for i = 1:size(Kai,2)%i:シグマポイントの数
                    tmp_angles = sensor.angle - Kai(3,i);
                    if iscolumn(tmp_angles)
                        tmp_angles = tmp_angles';% Transposition
                    end
                    line_param.d = Kai(obj.n + 1:obj.NLP:end,i);
                    line_param.delta = Kai(obj.n + 2:obj.NLP:end,i);
                    curr = association_available_index(1,m);
                    idx = association_info.index(1,association_available_index(1,m));
                    angle = Kai(3,i) + tmp_angles(curr) - line_param.delta(idx);
                    denon = line_param.d(idx) - Kai(1,i) * cos(line_param.delta(idx)) - Kai(2,i) * sin(line_param.delta(idx));
                    % Observation value
                    zs(i,1) = (denon) / cos(angle);
                end
                % Transform samples according to function 'zfunc' to obtain the predicted observation samples
                % if isempty(dzfunc), dzfunc = @default_dfunc; end
                % zs = feval(zfunc, ss, varargin{:}); % compute (possibly discontinuous) transform
                zz = repvec(measured.ranges(association_available_index(1,m)),SigmaNum);
                dz = observediff(zz,zs); % compute correct residual
                zs = zz - dz;               % offset zs from z according to correct residual
                
                % Calculate predicted observation mean
                zm = (obj.k*zs(:,1) + 0.5*sum(zs(:,2:end), 2)) / (StateCount + obj.k);
                
                % Calculate observation covariance and the state-observation correlation matrix
                dx = Kai - repvec(PreXh,SigmaNum);
                dz = zs - repvec(zm,SigmaNum);
                Pxz = (2*obj.k*dx(:,1)*dz(:,1)' + dx(:,2:end)*dz(:,2:end)') / (2*(StateCount + obj.k));
                Pzz = (2*obj.k*dz(:,1)*dz(:,1)' + dz(:,2:end)*dz(:,2:end)') / (2*(StateCount + obj.k));
                %カルマンゲイン
                % Compute Kalman gain
                S = Pzz + obj.R .* eye(size(Kai,2));
                Sc  = chol(S);  % note: S = Sc'*Sc
                Sci = inv(Sc);  % note: inv(S) = Sci*Sci'
                Wc = Pxz * Sci;
                W  = Wc * Sci';
                % Perform update
                PreXh = PreXh + W*(measured.ranges(association_available_index(1,m))' - zm);
                PreCov = PreCov - Wc*Wc';
            end
            Xh = PreXh;
            obj.result.P = PreCov;
            
            %Convert line parameter into line equation "ax + by + c = 0"
            line_param.d = Xh(obj.n+1:obj.NLP:end, 1);
            line_param.delta = Xh(obj.n+2:obj.NLP:end, 1);
            % Convert line parameter into line equation "ax + by + c = 0"
            line_param_opt = LineParamToLineAndEndPoint(line_param);
            obj.map_param.a = line_param_opt.a;
            obj.map_param.b = line_param_opt.b;
            obj.map_param.c = line_param_opt.c;
            %             obj.map_param.x = line_param_opt.x;
            %             obj.map_param.y = line_param_opt.y;
            % Projection of start and end point on the line
            MapEnd = FittingEndPoint(obj.map_param, obj.constant);
            obj.map_param.x = MapEnd.x;
            obj.map_param.y = MapEnd.y;
            %
            [obj.map_param, ~,RemovingFlag] = UKFOptimizeMap(obj.map_param, obj.constant);
            line_param = LineToLineParamAndEndPoint(obj.map_param);
            
            
            EstMh = zeros(obj.NLP * length(line_param.d),1);
            EstMh(1:obj.NLP:end, 1) = line_param.d;
            EstMh(2:obj.NLP:end, 1) = line_param.delta;
            %             EstMh(3:obj.NLP:end, 1) = line_param.xs;
            %             EstMh(4:obj.NLP:end, 1) = line_param.xe;
            %             EstMh(5:obj.NLP:end, 1) = line_param.ys;
            %             EstMh(6:obj.NLP:end, 1) = line_param.ye;
            Xh = [Xh(1:obj.n);EstMh(1:end)];
            
            if any(RemovingFlag)
                exist_flag = sort([1, 2, 3,(find(~RemovingFlag) - 1) * 2 + 4, (find(~RemovingFlag) - 1) * 2 + 5]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end
            
            if length(obj.result.P) ~= length(Xh)
                disp('error');
            end
            
            
            % return values setting
            obj.result.state.set_state(Xh);
            obj.result.Est_state = Xh;
%             obj.result.G = W;
            obj.result.map_param = obj.map_param;
            obj.result.AssociationInfo = association_info;
            result=obj.result;
        end
        function show()
            
        end
    end
end

function dx = dfunc(y1, y2)
dx = y1 - y2;
dx(3,:) = pi_to_pi(dx(3,:));
end

function angle = pi_to_pi(angle)

%function angle = pi_to_pi(angle)
% Input: array of angles.
% Output: normalised angles.
% Tim Bailey 2000, modified 2005.

% Note: either rem or mod will work correctly
%angle = mod(angle, 2*pi); % mod() is very slow for some versions of MatLab (not a builtin function)
%angle = rem(angle, 2*pi); % rem() is typically builtin

twopi = 2*pi;
angle = angle - twopi*fix(angle/twopi); % this is a stripped-down version of rem(angle, 2*pi)

i = find(angle > pi);
angle(i) = angle(i) - twopi;

i = find(angle < -pi);
angle(i) = angle(i) + twopi;
end

function x = repvec(x,N)
x = x(:, ones(1,N));
end

function dz = observediff(z1, z2)
dz = z1-z2;
% dz(2,:) = pi_to_pi(dz(2,:));
end