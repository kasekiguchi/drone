classdef UKF2DSLAM < handle
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
        model
    end

    methods
        function obj = UKF2DSLAM(self,param)
            obj.self= self;
            model = param.model;
            obj.model = model;
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
            obj.constant = param.constant;
            %------------------------------------------
        end

        function [result]=do(obj,~,~)
            %model: nolinear model
            model=obj.model;
            %% sigma points of previous step
            sn = length(obj.result.estate);%前ステップの状態数
            PreXh = obj.result.estate;%previous estimation 事前推定
            CholCov = chol(obj.result.P)';%cholesky factoryzation　コレスキー分解の複素共役転置

            obj.k = 3*sn;
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
            tmp = [sol.stats];
            tmp = [tmp.nsteps]+1;
            tmpid = arrayfun(@(i) sum(tmp(1:i)),1:length(tmp));
            tmp = [sol.y];
            Kai(1:obj.n,:) = tmp(1:obj.n,tmpid);
            PreXh = weight(1) .* Kai(:,1);
            for i = 2:size(Kai,2)
                PreXh = PreXh + weight(2) .*Kai(:,i);
            end
            %Previous Covariance matrix
            PreCov = weight(1) .* (Kai(:,1) - PreXh) * (Kai(:,1) - PreXh)';
            for i = 2:size(Kai,2)
                PreCov = PreCov + weight(2) .* (Kai(:,i) - PreXh) * (Kai(:,i) - PreXh)';
            end
            obj.result.PreXh = PreXh;

            %---センサ情報の処理-------------------------------------------------------------%
            % SLAM algorithm
            sensor = obj.self.sensor.result;%scan data
            measured.ranges = sensor.length;
            measured.angles = sensor.angle + PreXh(3); %laser angles.姿勢角を基準とする．絶対角
            measured.angles(sensor.length==0) = 0;
            % Convert measurements into lines %Line segment approximation%観測値をクラスタリングしてマップパラメータを作り出す           
            LSA_param = PC2LDA(measured.ranges, measured.angles, PreXh, obj.constant);

            % Conbine between measurements and map%前時刻までのマップと観測値を組み合わせる．組み合わさらなかったら新しいマップとして足す．
            obj.map_param = obj.UKFCombiningLines(LSA_param,PreXh);%既存の地図との統合
            % sn update
            sn = obj.n + obj.NLP * length(obj.map_param.a);

            %map_paramに対応したPreCovにする．
            if length(PreCov) < sn
                % Appearance new line parameter
                appendN = sn - length(PreCov);
                maxN = length(PreCov);
                for i = 1:appendN
                    PreCov(maxN + i, maxN + i) = 1.0E-6;%PreCovの数が足りなければ足す
                end
            end

            % Optimize the map%
            [map_param, RegistFlag] = obj.UKFOptimizeMap();%ここですぐ減らされている．
            %convert to Line parameter that consists of d and delta
            %line_param = obj.LineToLineParamAndEndPoint();%
            line_param = L2DA(map_param);%
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
            PreMh(2:obj.NLP:end, 1) = line_param.alpha;
            PreXh = [PreXh(1:obj.n);PreMh(1:end)];
            CholCov = chol(PreCov)';%cholesky factoryzation

            if length(CholCov)~= length(PreXh)
                disp('error');
            end

            obj.k = 3*sn;
            Kai = [PreXh,...
                cell2mat(arrayfun(@(i) PreXh + sqrt(sn + obj.k) .* CholCov(:,i) , 1:sn , 'UniformOutput' , false)),...
                cell2mat(arrayfun(@(i) PreXh - sqrt(sn + obj.k) .* CholCov(:,i) , 1:sn , 'UniformOutput' , false))];%sigma point
            weight = [obj.k/(sn + obj.k), 1/( 2*(sn + obj.k) )];
 
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
                d = Kai(obj.n+1:obj.NLP:end,i); % 原点から壁までの距離
                alpha = Kai(obj.n+2:obj.NLP:end,i); % 原点から壁への法線ベクトルの角度
                W = DA2L(d,alpha); % wall line R^(mx3)
                Wd= (-W*[Kai(1:2,i);1])'; % vehicle to wall distance R^(1xm) : 向きあり
%                angle = sensor.angle + th; % レーザー照射角度（絶対角）
                Perp=W(:,1:2); % 壁の法線単位ベクトル
                T = EL*Perp'; % R^(Nxm) : レーザーの向きと壁法線との内積
                T(T<=1e-4&T>=-1e-4) = nan; % T<=0 から緩和
                Lhat=Wd./T;% R^(Nxm) % lij = dj/cos(ai) : vehicle　からwall j への距離dj, レーザーi とwall法線の角度aiより レーザーiのwalljへの距離lij cos(aj) = di
                Lhat(Lhat<=1e-4) = nan; % 正のもののみが意味を持つ
                [L(:,i),I] = min(Lhat,[],2); % R^(Nx1) : レーザー計測距離
                L(isnan(L(:,i)),i) = 0;
                L(sensor.length==0,i) = 0; % レーザー情報が無いレーザーは０
                L = max(L,sensor.length'); % line 情報(a,b,c)だけから判断しているので途切れる壁をこのままでは考慮していないので
                % sensor値で上書きしているので厳密ではない: TODO                
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

            %カルマンゲイン
            G = PreXYCov /( PreYCov + obj.R );
            Xh = PreXh + G * (sensor.length' - PreYh);
            obj.result.P = PreCov - G * (PreYCov + obj.R) * G';

            %---事後処理------------------------------------------------%
            %マップパラメータを格納
            line_d = Xh(obj.n+1:obj.NLP:end,1);
            line_alpha = Xh(obj.n+2:obj.NLP:end,1);
            % 直線の方程式 "ax + by + c = 0"に変換
            obj.map_param = DA2L(line_d,line_alpha,"struct");
            % 端点を線上に射影
            MapEnd = P2L_projection(map_param,obj.map_param);
            obj.map_param.x = MapEnd.x;
            obj.map_param.y = MapEnd.y;
            [obj.map_param,RegistFlag] = obj.UKFOptimizeMap();
            line_param = L2DA(obj.map_param);%

            EstMh = zeros(obj.NLP * length(line_param.d),1);
            EstMh(1:obj.NLP:end, 1) = line_param.d;
            EstMh(2:obj.NLP:end, 1) = line_param.alpha;
            Xh = [Xh(1:obj.n);EstMh(1:end)];

            %共分散行列のサイズを調整
            if any(RegistFlag)
                exist_flag = sort([1:obj.n, (find(~RegistFlag) - 1) * 2 + obj.n + 1, (find(~RegistFlag) - 1) * 2 + obj.n + 2]);
                obj.result.P = obj.result.P(exist_flag, exist_flag);
            end

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
                %error("ACSL:estimation is fail");
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