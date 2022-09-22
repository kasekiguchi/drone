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
            obj.constant = struct; %定数パラメータ設定
            obj.constant.LineThreshold = 0.1;%0.3;%0.3; %"ax + by + c"の誤差を許容する閾値
            obj.constant.PointThreshold = 0.2;%0.2; %
            obj.constant.GroupNumberThreshold = 20; % クラスタを構成する最小の点数
            obj.constant.DistanceThreshold = 1e-2;%1e-1; % センサ値と計算値の許容誤差，対応付けに使用
            obj.constant.ZeroThreshold = 1e-3; % ゼロとみなす閾値
            obj.constant.CluteringThreshold = 2;%0.5;%0.5; % 同じクラスタとみなす最大距離
            obj.constant.SensorRange = param.SensorRange; % Max scan range
            %------------------------------------------
        end
        
        function [result]=do(obj,param,~)
            %model: nolinear model
            model=obj.self.model;
            %% sigma points of previous step
            StateCount = length(obj.result.Est_state);%前ステップの状態数
            PreXh = obj.result.Est_state;%previous estimation 事前推定
            CholCov = chol(obj.result.P)';%cholesky factoryzation　コレスキー分解の複素共役転置
            Kai = [PreXh,...
                cell2mat(arrayfun(@(i) PreXh + sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false)),...
                cell2mat(arrayfun(@(i) PreXh - sqrt(StateCount + obj.k) * CholCov(:,i) , 1:StateCount , 'UniformOutput' , false))];%sigma point　上から教科書7.29~7.31の計算を行っている
            weight = [obj.k/(StateCount + obj.k), 1/(2*(StateCount + obj.k))]; %重みの計算
            if isempty(obj.self.input)
                u=[0;0];
            else
                u = obj.self.input;
            end
            
            %% sigma point update
%           sol = arrayfun(@(i) ode45(@(t,x) model.method(x,u,model.param), [0 obj.dt], Kai(1:obj.n,i)), 1:2*StateCount+1);
%            x = linspace(0,obj.dt,10);
%            rKai = arrayfun(@(i) deval(sol(i),x), 1:2*StateCount + 1, 'UniformOutput', false);%ロボットのシグマポイント（モデルで動きを出したやつ）
%            mKai = Kai(obj.n+1:end,:);%マップのシグマポイント
% %           Kai = zeros(StateCount,2*StateCount+1);
%            for i = 1:2*StateCount+1
%                aKai(:,i) = [rKai{1,i}(:,end);mKai(:,i)];%Kai = sigma point;
%            end
            sol = arrayfun(@(i) ode45(@(t,x) model.method(x,u,model.param), [0 obj.dt], Kai(1:obj.n,i)), 1:2*StateCount+1);
            tmp = [sol.stats];
            tmp = [tmp.nsteps]+1;
            tmpid = arrayfun(@(i) sum(tmp(1:i)),1:length(tmp));
            tmp = [sol.y];
            Kai(1:obj.n,:) = tmp(1:obj.n,tmpid);
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
            
            %---センサ情報の処理-------------------------------------------------------------%
            %SLAM algorithm
            sensor = obj.self.sensor.result;%scan data
            measured.ranges = sensor.length;
            if iscolumn(measured.ranges)
                measured.ranges = measured.ranges';% Transposition
            end
            measured.angles = sensor.angle + PreXh(3) * (sensor.length~=0);%laser angles.姿勢角を基準とする．絶対角
            if iscolumn(measured.angles)
                measured.angles = measured.angles';% Transposition
            end
            % Convert measurements into lines %Line segment approximation%観測値をクラスタリングしてマップパラメータを作り出す
            LSA_param = UKFPointCloudToLine(measured.ranges, measured.angles, PreXh, obj.constant);
            %LSA_param = UKFPointCloudToLine(measured.ranges, measured.angles, [PreXh(1:2);0], obj.constant);
            % Conbine between measurements and map%前時刻までのマップと観測値を組み合わせる．組み合わさらなかったら新しいマップとして足す．
            % x, y が全て０のLSA_paramを削除 UKFCombiningLinesで使っているフィールドだけ削除
            tmpid=sum([LSA_param.x,LSA_param.y],2)==0; 
            LSA_param.x(tmpid,:) = [];
            LSA_param.y(tmpid,:) = [];
            LSA_param.a(tmpid,:) = [];
            LSA_param.b(tmpid,:) = [];
            LSA_param.c(tmpid,:) = [];
            LSA_param.index(tmpid,:) = [];
            obj.map_param = UKFCombiningLines(obj.map_param , LSA_param, obj.constant);%既存の地図との統合
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
            line_param = LineToLineParamAndEndPoint(obj.map_param);%dalpha
            %-----------------------------------------------------------------%
            
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
            association_available_index = find((association_info.index ~= 0)&(sensor.length~=0));%Index corresponding to the measured value
            association_available_count = length(association_available_index);%Count
            %出力のシグマポイントを計算
            %sensing step
            %測定値が取れていないレーザー部分はダミーデータ0をかませる
            
            Ita = cell(1,size(Kai,2));
            for i = 1:size(Kai,2)%i:シグマポイントの数
                line_param.d = Kai(obj.n + 1:obj.NLP:end,i);
                line_param.delta = Kai(obj.n + 2:obj.NLP:end,i);
                Ita{1,i} = zeros(association_available_count,1);
                for m = 1:association_available_count%m:レーザの番号
                    curr = association_available_index(1,m);
                    idx = association_info.index(1,association_available_index(1,m)); % どの壁に対応づけられているか
                    angle = Kai(3,i) + sensor.angle(curr) - line_param.delta(idx); % measured.anglesを絶対角にしているのでKai(3,i)は不要
                    %angle = measured.angles(curr) - line_param.delta(idx); % measured.anglesを絶対角にしているのでKai(3,i)は不要
                    %angle = sign(measured.ranges(curr))*(measured.angles(curr) - line_param.delta(idx)); % measured.anglesを絶対角にしているのでKai(3,i)は不要                   
                    denon = line_param.d(idx) - Kai(1,i) * cos(line_param.delta(idx)) - Kai(2,i) * sin(line_param.delta(idx));% 車両から直線までの距離
                    % Observation value Ita : denon = Ita * cos(angle)
                    Ita{1,i}(m,1) = (denon) / cos(angle);
                end
            end

            
            %事前出力推定値
            PreYh = weight(1) .* Ita{1,1}(:);
            for i = 2:size(Kai,2) % TODO : for 文なくす．
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
            %Xh = PreXh + G * (measured.ranges(association_available_index)' - PreYh);
            Xh = PreXh + G * (sensor.length(association_available_index)' - PreYh);
            obj.result.P = PreCov - G * (PreYCov + obj.R .* eye(association_available_count)) * G';
            
            %---事後処理------------------------------------------------%
            %マップパラメータを格納
            line_param.d = Xh(obj.n+1:obj.NLP:end,1);
            line_param.delta = Xh(obj.n+2:obj.NLP:end,1);
            % % 直線の方程式 "ax + by + c = 0"に変換
            line_param_opt = LineParamToLineAndEndPoint(line_param);
            obj.map_param.a = line_param_opt.a;
            obj.map_param.b = line_param_opt.b;
            obj.map_param.c = line_param_opt.c;
            % sekiguchi 追加
            obj.map_param.x = line_param_opt.x; 
            obj.map_param.y = line_param_opt.y;
            % 端点を線上に射影
            MapEnd = FittingEndPoint(obj.map_param, obj.constant);
            obj.map_param.x = MapEnd.x;
            obj.map_param.y = MapEnd.y;
            [obj.map_param,RegistFlag] = UKFOptimizeMap(obj.map_param, obj.constant);
            line_param = LineToLineParamAndEndPoint(obj.map_param);%lineparam d and delta and endpoint is calculated
                        
            EstMh = zeros(obj.NLP * length(line_param.d),1);
            EstMh(1:obj.NLP:end, 1) = line_param.d;
            EstMh(2:obj.NLP:end, 1) = line_param.delta;
            Xh = [Xh(1:obj.n);EstMh(1:end)];
            
            %共分散行列のサイズを調整
            if any(RegistFlag)
                exist_flag = sort([1, 2, 3, 4,(find(~RegistFlag) - 1) * 2 + 5, (find(~RegistFlag) - 1) * 2 + 6]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end
            %-------------------------------------------------------------%

            % 同一直線を統合
            ABC = [obj.map_param.a,obj.map_param.b,obj.map_param.c];
            X = obj.map_param.x;
            Y = obj.map_param.y;
            %[~,ia,ic] = uniquetol(ABC,'ByRows',true);
            [~,ia,ic] = uniquetol(sign(ABC(:,3)).*ABC./vecnorm(ABC(:,1:2),2,2),'ByRows',true);
            obj.map_param.index = obj.map_param.index(ia,:);
            obj.map_param.a = obj.map_param.a(ia);
            obj.map_param.b = obj.map_param.b(ia);
            obj.map_param.c = obj.map_param.c(ia);
            obj.map_param.x = obj.map_param.x(ia,:);
            obj.map_param.y = obj.map_param.y(ia,:);
            for i = 1:length(ia)
                did = find(ic==i); % duplicated ids
                obj.map_param.x(i,1) = min(X(did,:),[],'all');
                obj.map_param.x(i,2) = max(X(did,:),[],'all');
                if obj.map_param.a(i)*obj.map_param.b(i) > 0 % 右下がり
                    obj.map_param.y(i,1) = max(Y(did,:),[],'all');
                    obj.map_param.y(i,2) = min(Y(did,:),[],'all');
                else % 右上がり
                    obj.map_param.y(i,1) = min(Y(did,:),[],'all');
                    obj.map_param.y(i,2) = max(Y(did,:),[],'all');
                end
            end


            % return values setting
            obj.result.state.set_state(Xh);
            obj.result.Est_state = Xh;
            %obj.result.G = G;
            obj.result.map_param = obj.map_param;
            obj.result.AssociationInfo = UKFMapAssociation(Xh(1:obj.n),Xh(obj.n+1:end), obj.map_param, measured.ranges,measured.angles, obj.constant,obj.NLP);
            result=obj.result;
        end
        function show(obj,result)
            arguments
                obj
                result = []
            end
            if isempty(result)
                result = obj.result;
            end
            l = obj.map_param;
            l = obj.point2line(l.x,l.y);
            p = result.state.p;
            th = result.state.q;
            plot(l.x,l.y);
            hold on            
            plot(p(1),p(2),'ro');
            quiver(p(1),p(2),cos(th),sin(th),'Color','r');  
            hold off
        end
        function l = point2line(obj,Px,Py)
            % Px = [xs,xe],  Py = [ys,ye]
            % return l = struct(x,y)
            % plot(x,y) : line plot from (xs,ys) to (xe,ye)
            x = [Px,NaN(size(Px,1),1)];
            y = [Py,NaN(size(Py,1),1)];
            l.x = reshape(x',numel(x),1);
            l.y = reshape(y',numel(y),1);
        end
    end
end