classdef UKF2DSLAM < ESTIMATOR_CLASS
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
        map_param % id, a,b,c, x,y
        Map_Q
        NLP%Number of Line Params
        EL0 % 原点位置でのレーザーの単位円上の位置 R^(Nx2)
    end
    
    methods
        function obj = UKF2DSLAM(self,param)
            obj.self= self;
            model = self.model;
            % --this state use in only UKFSLAM--
            obj.result.estate= model.state.get();%x, y, theta,v
            %------------------------------
            obj.result.state= state_copy(model.state);
            obj.n = param.dim;%robot state dimension
            obj.Map_Q = param.Map_Q;% map variance
            obj.Q = param.Q;% model variance
            obj.EL0 = [cos(self.sensor.lrf.angle_range'),sin(self.sensor.lrf.angle_range')];
            obj.R = param.R*eye(size(obj.EL0,1));% observation noise variance
            obj.k = param.k;
            obj.dt = model.dt; % tic time
            obj.result.P = param.P;%covariance
            obj.NLP = param.NLP;%Number of Line Param
            
            % the constant value for estimating of the map
            obj.constant = struct; %定数パラメータ設定
            obj.constant.LineThreshold = 0.1;%0.3;%0.3; %"ax + by + c"の誤差を許容する閾値
            obj.constant.PointThreshold = 0.2;%0.2; %
            obj.constant.GroupNumberThreshold = 5; % クラスタを構成する最小の点数
            obj.constant.DistanceThreshold = 1e-2;%1e-1; % センサ値と計算値の許容誤差，対応付けに使用
            obj.constant.ZeroThreshold = 1e-3; % ゼロとみなす閾値
            obj.constant.CluteringThreshold = 0.5;%0.5; % 同じクラスタとみなす最大距離 通路幅/2より大きくすると曲がり角で問題が起こる
            obj.constant.SensorRange = param.SensorRange; % Max scan range
            obj.constant.LineDistance = 0.1; % 既存マップ端点からこれ以上離れた線分は別の線分とみなす．
            %------------------------------------------
        end
        
        function [result]=do(obj,~,~)
            %model: nolinear model
            model=obj.self.model;
            %% sigma points of previous step
            sn = length(obj.result.estate);%前ステップの状態数
            PreXh = obj.result.estate;%previous estimation 事前推定
            CholCov = chol(obj.result.P)';%cholesky factoryzation　コレスキー分解の複素共役転置
%             Kai = [PreXh,...
%                 cell2mat(arrayfun(@(i) PreXh + sqrt(sn + obj.k) .* CholCov(:,i) , 1:sn , 'UniformOutput' , false)),...
%                 cell2mat(arrayfun(@(i) PreXh - sqrt(sn + obj.k) .* CholCov(:,i) , 1:sn , 'UniformOutput' , false))];%sigma point
%             weight = [1-sn/(sn*obj.k^2), 1/( 2*(sn*obj.k^2) )];
obj.k = 2*sn;
            Kai = [PreXh,...
                cell2mat(arrayfun(@(i) PreXh + sqrt(sn + obj.k) * CholCov(:,i) , 1:sn , 'UniformOutput' , false)),...
                cell2mat(arrayfun(@(i) PreXh - sqrt(sn + obj.k) * CholCov(:,i) , 1:sn , 'UniformOutput' , false))];%sigma point　上から教科書7.29~7.31の計算を行っている
            weight = [obj.k/(sn + obj.k), 1/(2*(sn + obj.k))]; %重みの計算
            if isempty(obj.self.input)
                u=zeros(model.dim(2),1);
            else
                u = obj.self.input;
            end
            
            %% sigma point update
          sol = arrayfun(@(i) ode45(@(t,x) model.method(x,u,model.param), [0 obj.dt], Kai(1:obj.n,i)), 1:2*sn+1);
           x = linspace(0,obj.dt,10);
           rKai = arrayfun(@(i) deval(sol(i),x), 1:2*sn + 1, 'UniformOutput', false);%ロボットのシグマポイント（モデルで動きを出したやつ）
           mKai = Kai(obj.n+1:end,:);%マップのシグマポイント
           Kai = zeros(sn,2*sn+1);
           for i = 1:2*sn+1
               Kai(:,i) = [rKai{1,i}(:,end);mKai(:,i)];%Kai = sigma point;
           end
%             sol = arrayfun(@(i) ode45(@(t,x) model.method(x,u,model.param), [0 obj.dt], Kai(1:obj.n,i)), 1:2*sn+1);
%             tmp = [sol.stats];
%             tmp = [tmp.nsteps]+1;
%             tmpid = arrayfun(@(i) sum(tmp(1:i)),1:length(tmp));
%             tmp = [sol.y];
%             Kai(1:obj.n,:) = tmp(1:obj.n,tmpid);
            PreXh = weight(1) .* Kai(:,1);
            for i = 2:size(Kai,2)
                PreXh = PreXh + weight(2) .*Kai(:,i);
            end
            %Previous Covariance matrix
            PreCov = weight(1) .* (Kai(:,1) - PreXh) * (Kai(:,1) - PreXh)';
            for i = 2:size(Kai,2)
                PreCov = PreCov + weight(2) .* (Kai(:,i) - PreXh) * (Kai(:,i) - PreXh)';
            end
            % system noise : propertyに追加しMapが増えたら更新する方が良い．
            system_noise = diag(horzcat(diag(obj.Q)', repmat(diag(obj.Map_Q)', [1, (sn - obj.n)]) ) );
            B = eye(sn) .* obj.dt;%noise channel
            PreCov = PreCov + B * system_noise * B';%事前誤差共分散行列
            %PreCovの次元数は，ロボットの次元数 + 前時刻のマップパラメータの数に対応
            obj.result.PreXh = PreXh;
            
            %---センサ情報の処理-------------------------------------------------------------%
            % SLAM algorithm
            sensor = obj.self.sensor.result;%scan data
            measured.ranges = sensor.length;
            measured.angles = sensor.angle + obj.result.estate(3);%laser angles.姿勢角を基準とする．絶対角
            measured.angles(sensor.length==0) = 0;
            % Convert measurements into lines %Line segment approximation%観測値をクラスタリングしてマップパラメータを作り出す
            %LSA_param = obj.UKFPointCloudToLine(measured.ranges, measured.angles, PreXh);
            LSA_param = obj.UKFPointCloudToLine(measured.ranges, measured.angles, obj.result.estate);
            % Conbine between measurements and map%前時刻までのマップと観測値を組み合わせる．組み合わさらなかったら新しいマップとして足す．
            obj.map_param = obj.UKFCombiningLines(LSA_param);%既存の地図との統合
            % sn update
            sn = obj.n + obj.NLP * length(obj.map_param.a);

            %map_paramに対応したPreCovにする．
            if length(PreCov) < sn
                % Appearance new line parameter
                appendN = sn - length(PreCov);
                maxN = length(PreCov);
                for i = 1:appendN
                    PreCov(maxN + i, maxN + i) = 1.0E-1;%PreCovの数が足りなければ足す
                end
            end
            
            % Optimize the map%
            [obj.map_param, RegistFlag] = obj.UKFOptimizeMap();%ここですぐ減らされている．
            %convert to Line parameter that consists of d and delta
            line_param = obj.LineToLineParamAndEndPoint();%
            %-----------------------------------------------------------------%
            
            %共分散行列を再構成
            % Update estimate covariance %
            if any(RegistFlag)
                exist_flag = sort([1:obj.n, (find(~RegistFlag) - 1) * 2 + obj.n + 1, (find(~RegistFlag) - 1) * 2 + obj.n + 2]);
                PreCov = PreCov(exist_flag, exist_flag);
            end
            
            %UKF Algorithm
            %シグマポイント再計算
            % re calculate of sigma points
            sn = obj.n + obj.NLP * length(line_param.d);
            PreMh = zeros(obj.NLP * length(line_param.d),1);
            PreMh(1:obj.NLP:end, 1) = line_param.d;
            PreMh(2:obj.NLP:end, 1) = line_param.delta;
            PreXh = [PreXh(1:obj.n);PreMh(1:end)];
            CholCov = chol(PreCov)';%cholesky factoryzation
            
            if length(CholCov)~= length(PreXh)
                disp('error');
            end
%             
%             Kai = [PreXh,...
%                 cell2mat(arrayfun(@(i) PreXh + sqrt(sn*obj.k^2) .* CholCov(:,i) , 1:sn , 'UniformOutput' , false)),...
%                 cell2mat(arrayfun(@(i) PreXh - sqrt(sn*obj.k^2) .* CholCov(:,i) , 1:sn , 'UniformOutput' , false))];%sigma point
%             weight = [1 - sn/(sn*obj.k^2), 1/( 2*(sn*obj.k^2) )];
obj.k = 100*sn;
    Kai = [PreXh,...
    cell2mat(arrayfun(@(i) PreXh + sqrt(sn + obj.k) .* CholCov(:,i) , 1:sn , 'UniformOutput' , false)),...
    cell2mat(arrayfun(@(i) PreXh - sqrt(sn + obj.k) .* CholCov(:,i) , 1:sn , 'UniformOutput' , false))];%sigma point
    weight = [obj.k/(sn + obj.k), 1/( 2*(sn + obj.k) )];
            %再計算されたシグマポイントのマップパラメータごとのマップ端点を計算
            EndPoint = obj.SigmaLineParamToEndPoint(Kai);
            
            %事前状態推定値を用いてマップと対応付け
            % assoc between measurements and map
            % assoc.id = correspanding wall(line_param) number id
            % assoc.distance = wall distace
            assoc = obj.UKFMapAssociation(PreXh(1:obj.n),PreMh(1:end), EndPoint{1,1}, measured.ranges,measured.angles);
            associd = find((assoc.id ~= 0));%&(sensor.length >= 1e-4));%(sensor.length~=0));%Index corresponding to the measured value
            assocN = length(associd);%Count
            %出力のシグマポイントを計算
            %sensing step
            %測定値が取れていないレーザー部分はダミーデータ0をかませる
            
%             Ita = cell(1,size(Kai,2));
%             for i = 1:size(Kai,2)%i:シグマポイントの数
%                 line_param.d = Kai(obj.n + 1:obj.NLP:end,i);
%                 line_param.delta = Kai(obj.n + 2:obj.NLP:end,i);
%                 Ita{1,i} = zeros(assocN,1);
%                 for m = 1:assocN%m:レーザの番号
%                     curr = associd(1,m);
%                     idx = assoc.id(1,curr); % どの壁に対応づけられているか
%                     angle = Kai(3,i) + sensor.angle(curr) - line_param.delta(idx); % measured.anglesを絶対角にしているのでKai(3,i)は不要
%                     %angle = measured.angles(curr) - line_param.delta(idx); % measured.anglesを絶対角にしているのでKai(3,i)は不要
%                     %angle = sign(measured.ranges(curr))*(measured.angles(curr) - line_param.delta(idx)); % measured.anglesを絶対角にしているのでKai(3,i)は不要                   
%                     denon = line_param.d(idx) - Kai(1,i) * cos(line_param.delta(idx)) - Kai(2,i) * sin(line_param.delta(idx));% 車両から直線までの距離
%                     % Observation value Ita : denon = Ita * cos(angle)
%                     Ita{1,i}(m,1) = (denon) / cos(angle);
%                 end
%             end

% シグマポイントに対応した出力予測値：各予測位置からのレーザー長さ
th = 0;
EL = obj.EL0;
for i = 1:size(Kai,2)
% convert line parameter to line 
if th~=Kai(3,i)
th = Kai(3,i);
R = [cos(th),-sin(th);sin(th),cos(th)];
EL = obj.EL0*R'; % laser 方向単位ベクトル（絶対座標）in R^(Nx2)
end
d = Kai(obj.n+1:obj.NLP:end,i);
alpha = Kai(obj.n+2:obj.NLP:end,i);
W = DA2L(d,alpha); % wall line R^(mx3)
Wd= (-W*[Kai(1:2,i);1])'; % vehicle to wall distance R^(1xm)
%angle = sensor.angle + th; % レーザー照射角度（絶対角）
Perp=W(:,1:2);
T = EL*Perp'; % R^(Nxm)
T(T<=0.1) = nan; % T<=0 から緩和
Lhat=Wd./T;% R^(Nxm) % lij = dj/cos(ai) : vehicle　からwall j への距離dj, レーザーi とwall法線の角度aiより レーザーiのwalljへの距離lij cos(aj) = di
[L(:,i),I] = min(Lhat,[],2); % R^(Nx1) : レーザー計測距離
L(isnan(L(:,i)),i) = 0;
L(sensor.length==0,i) = 0; % レーザー情報が無いレーザーは０
%[L(:,i),I] = min(Lhat,[],2); % R^(Nx1) : レーザー計測距離
if i == 1
            PreYh = weight(1) .* L(:,1);
%     assoc
else
    PreYh = PreYh + weight(2) .* L(:,i);
end
end
            %事前出力誤差共分散行列
            PreYCov = weight(1) .* (L(:,1) - PreYh) * (L(:,1) - PreYh)';
            for i = 2:size(Kai,2)
                PreYCov = PreYCov + weight(2) .* (L(:,i) - PreYh) * (L(:,i) - PreYh)';
            end
            %事前状態，出力誤差共分散行列
            PreXYCov = weight(1) .* (Kai(:,1) - PreXh) * (L(:,1) - PreYh)';
            for i = 2:size(Kai,2)
                PreXYCov = PreXYCov + weight(2) .* (Kai(:,i) - PreXh) * (L(:,i) - PreYh)';
            end

            

%             %事前出力推定値
%             PreYh = weight(1) .* Ita{1,1}(:);
%             for i = 2:size(Kai,2) % TODO : for 文なくす．
%                 PreYh = PreYh + weight(2) .* Ita{1,i}(:);
%             end
%             %事前出力誤差共分散行列
%             PreYCov = weight(1) .* (Ita{1,1}(:) - PreYh) * (Ita{1,1}(:) - PreYh)';
%             for i = 2:size(Kai,2)
%                 PreYCov = PreYCov + weight(2) .* (Ita{1,i}(:) - PreYh) * (Ita{1,i}(:) - PreYh)';
%             end
%             %事前状態，出力誤差共分散行列
%             PreXYCov = weight(1) .* (Kai(:,1) - PreXh) * (Ita{1,1}(:) - PreYh)';
%             for i = 2:size(Kai,2)
%                 PreXYCov = PreXYCov + weight(2) .* (Kai(:,i) - PreXh) * (Ita{1,i}(:) - PreYh)';
%             end
            %カルマンゲイン
            G = PreXYCov /( PreYCov + obj.R );
            Xh = PreXh + G * (sensor.length' - PreYh);
            obj.result.P = PreCov - G * (PreYCov + obj.R) * G';
            
            %---事後処理------------------------------------------------%
            %マップパラメータを格納
            line_param.d = Xh(obj.n+1:obj.NLP:end,1);
            line_param.delta = Xh(obj.n+2:obj.NLP:end,1);
            % % 直線の方程式 "ax + by + c = 0"に変換
            line_param_opt = obj.LineParamToLineAndEndPoint(line_param);
            obj.map_param.a = line_param_opt.a;
            obj.map_param.b = line_param_opt.b;
            obj.map_param.c = line_param_opt.c;
            % sekiguchi 追加
            obj.map_param.x = line_param_opt.x; 
            obj.map_param.y = line_param_opt.y;
            % 端点を線上に射影
            MapEnd = obj.FittingEndPoint();
            obj.map_param.x = MapEnd.x;
            obj.map_param.y = MapEnd.y;
            [obj.map_param,RegistFlag] = obj.UKFOptimizeMap();
            line_param = obj.LineToLineParamAndEndPoint();%lineparam d and delta and endpoint is calculated
                        
            EstMh = zeros(obj.NLP * length(line_param.d),1);
            EstMh(1:obj.NLP:end, 1) = line_param.d;
            EstMh(2:obj.NLP:end, 1) = line_param.delta;
            Xh = [Xh(1:obj.n);EstMh(1:end)];
            
            %共分散行列のサイズを調整
            if any(RegistFlag)
                exist_flag = sort([1:obj.n, (find(~RegistFlag) - 1) * 2 + obj.n + 1, (find(~RegistFlag) - 1) * 2 + obj.n + 2]);                
                %exist_flag = sort([1, 2, 3, 4,(find(~RegistFlag) - 1) * 2 + 5, (find(~RegistFlag) - 1) * 2 + 6]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end
            %-------------------------------------------------------------%

            % 同一直線を統合
%             ABC = [obj.map_param.a,obj.map_param.b,obj.map_param.c];
%             X = obj.map_param.x;
%             Y = obj.map_param.y;
%             %[~,ia,ic] = uniquetol(ABC,'ByRows',true);
%             [~,ia,ic] = uniquetol(sign(ABC(:,3)).*ABC./vecnorm(ABC(:,1:2),2,2),'ByRows',true);
%             if size(ia,1) ~= size(obj.map_param.id,1)
%                 ia
%             end
%             obj.map_param.id = obj.map_param.id(ia,:);
%             obj.map_param.a = obj.map_param.a(ia);
%             obj.map_param.b = obj.map_param.b(ia);
%             obj.map_param.c = obj.map_param.c(ia);
%             obj.map_param.x = obj.map_param.x(ia,:);
%             obj.map_param.y = obj.map_param.y(ia,:);
%             for i = 1:length(ia)
%                 did = find(ic==i); % duplicated ids
%                 obj.map_param.x(i,1) = min(X(did,:),[],'all');
%                 obj.map_param.x(i,2) = max(X(did,:),[],'all');
%                 if obj.map_param.a(i)*obj.map_param.b(i) > 0 % 右下がり
%                     obj.map_param.y(i,1) = max(Y(did,:),[],'all');
%                     obj.map_param.y(i,2) = min(Y(did,:),[],'all');
%                 else % 右上がり
%                     obj.map_param.y(i,1) = min(Y(did,:),[],'all');
%                     obj.map_param.y(i,2) = max(Y(did,:),[],'all');
%                 end
%             end


            % return values setting
            obj.result.state.set_state(Xh(1:obj.n));
            obj.result.estate = Xh;
            %obj.result.G = G;
            obj.result.map_param = obj.map_param;
            obj.result.AssociationInfo = obj.UKFMapAssociation(Xh(1:obj.n),Xh(obj.n+1:end), obj.map_param, measured.ranges,measured.angles);
            if isempty(find(obj.result.AssociationInfo.id ~= 0, 1))
                error("ACSL:somthing wrong on map assoc");
            end
            if vecnorm(obj.result.state.p-obj.self.plant.state.p)>1
                error("ACSL:estimation is fail");
            end
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
            estate = result.state.p(:,end);
            estatesquare = estate + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
            estatesquare =  polyshape( estatesquare');
            estatesquare =  rotate(estatesquare,180 * result.state.q(end) / pi, result.state.p(:,end)');
            plot(estatesquare,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);
            Ewall = result.map_param;
            Ewallx = reshape([Ewall.x,NaN(size(Ewall.x,1),1)]',3*size(Ewall.x,1),1);
            Ewally = reshape([Ewall.y,NaN(size(Ewall.y,1),1)]',3*size(Ewall.y,1),1);
            plot(Ewallx,Ewally,'g-');

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