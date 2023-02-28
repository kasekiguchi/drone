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
%             obj.result.u = [];
            obj.NLP = param.NLP;%Number of Line Param
            obj.constant = param.constant;
            %------------------------------------------
        
        end

        function [result]=do(obj,~,~)
            %model: nolinear model
            model=obj.self.model;
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
%             for i = 1:length(sensor.length)
%                 if sensor.length(1,i) >= 3.0
%                     sensor.length(1,i) = 0;
% %                     data.intensities(i,1) = 0;
%                 end
%             end
            measured.ranges = sensor.length;
            measured.angles = sensor.angle + PreXh(3); %laser angles.姿勢角を基準とする．絶対角
            measured.angles(sensor.length==0) = 0;
            if size(obj.EL0(:,1),(1)) ~= size(sensor.length,(2))
                if size(obj.EL0(:,1),(1)) < size(sensor.length,(2))
                    S = size(obj.EL0(:,1));
                    sensor.length = sensor.length(:,1:S(1));
                else
                    S =size(sensor.length);
                    obj.EL0 = obj.EL0(1:S(2),:);
                    obj.R = obj.R(1,1)*eye(size(obj.EL0,1));
                end
            end
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
                    EL = obj.EL0*R'; %点から壁への法線ベクトルの角 laser 
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

%             obj.result.Fisher = fisher(line_param,obj,sensor,u);
            % return values setting
            obj.result.state.set_state(Xh(1:obj.n));
            obj.result.estate = Xh;
%             obj.result.u = u;
            %obj.result.G = G;
            obj.result.map_param = obj.map_param;
            obj.result.AssociationInfo = obj.UKFMapAssociation(Xh(1:obj.n),Xh(obj.n+1:end), obj.map_param, measured.ranges,measured.angles);
            if isempty(find(obj.result.AssociationInfo.id ~= 0, 1))
                error("ACSL:somthing wrong on map assoc");
            end
%             if vecnorm(obj.result.state.p-obj.self.plant.state.p)>1
%                 %error("ACSL:estimation is fail");
%             end
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
            figure(3)
            estate = result.state.p(:,end);
            estatesquare = estate + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
%             estatesquare =  polyshape( estatesquare');
%             estatesquare =  rotate(estatesquare,180 * result.state.q(end) / pi, result.state.p(:,end)');
%             plot(estatesquare,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);
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
            grid on
%             plot(p(1),p(2),'ro');
%             quiver(p(1),p(2),cos(th),sin(th),'Color','r');
            xlabel("$x$ [m]","Interpreter","latex");
            ylabel("$y$ [m]","Interpreter","latex");
            legend('wall');
            xlim([-4 8])
            ylim([-4 8])
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

        function evFim = fisher(param,obj,sensor,u)
            param.phi = sensor.angle;
            param.dis = param.d;
            RangeGain = 10;
            SensorRange = obj.constant.SensorRange;
            NoiseR = 1e-2;
            X = [obj.result.estate;u(1,1)];
            if isempty(obj.result.u)
                a = 0;
            else
                a = (u(1,1)-obj.result.u(1,1))/obj.dt;
            end
            U = [a;u(2,1)];
            param.dt = obj.dt;
            t1 = param.phi;
            t2 = param.alpha;
            [~,tth]=min(abs(t1-t2),[],2);
            
            H = (param.dis(:) - X(1,1).*cos(param.alpha(:)) - X(2,1).*sin(param.alpha(:)))./cos(param.phi(tth)' - param.alpha(:) + X(3,1));%observation
        %     RangeLogic = H<SensorRange;
            RangeLogic = (tanh(RangeGain*(SensorRange - H))+1)/2;%センサレンジの考慮 zeta
%             FIM_ObserbSubAOmegaRungeKutta_a = obj.FIM_OBSERBSUBAOMEGARUNGEKUTTA(X(1,1), X(2,1), X(3,1), X(4,1),U(2,1),U(1,1),param.dt, param.dis(1), param.alpha(1), param.phi(1));
            Fim = RangeLogic(1) * obj.FIM_ObserbSubAOmegaRungeKutta(X(1,1), X(2,1), X(3,1), X(4,1),U(2,1),U(1,1),param.dt, param.dis(1), param.alpha(1), param.phi(1));
            obFim = RangeLogic(1) * obj.FIM_Observe(X(1,1), X(2,1), X(3,1), param.dis(1), param.alpha(1), param.phi(1));
            for i = 2:length(param.dis)
                Fim = Fim + RangeLogic(i) * obj.FIM_ObserbSubAOmegaRungeKutta(X(1,1), X(2,1), X(3,1), X(4,1),U(2,1),U(1,1),param.dt, param.dis(i), param.alpha(i), param.phi(i));
                obFim = obFim + RangeLogic(i) * obj.FIM_Observe(X(1,1), X(2,1), X(3,1), param.dis(i), param.alpha(i), param.phi(i));
            end
        %     Fim = (1/(2*NoiseR+diag([1,1])))*Fim;
            Fim = (Fim+1e-2*eye(2))/(2*NoiseR);%観測値差分のFisher情報行列計算
            %obFim = (1/(NoiseR))*([obFim + [1e-2,1e-2,1e-2;1e-2,1e-2,1e-2;1e-2,1e-2,1e-2]]);%観測値のFisher情報行列
            obFim = (1/(NoiseR))*(obFim + 1e-2*eye(3));%観測値のFisher情報行列
            InvFim = [Fim(2,2) -Fim(1,2); -Fim(2,1), Fim(1,1)]/(det(Fim));%逆行列の計算
        %     InvFim = inv(Fim);
            InvobFim = inv(obFim);
            evFim(1,1) = trace(InvobFim)*trace(InvFim);%評価値計算
        end

        function APP = FIM_ObserbSubAOmegaRungeKutta(self,x,y,theta,v,omega,a,t,d1,alpha1,phi1)
            %FIM_OBSERBSUBAOMEGARUNGEKUTTA
            %    APP = FIM_OBSERBSUBAOMEGARUNGEKUTTA(X,Y,THETA,V,OMEGA,A,T,D1,ALPHA1,PHI1)
%             APP = FIM_ObserbSubAOmegaRungeKutta(x,y,theta,v,omega,a,t,d1,alpha1,phi1)
            
            %    This function was generated by the Symbolic Math Toolbox version 8.7.
            %    13-Dec-2021 19:35:13
            
            t2 = cos(alpha1);
            t3 = sin(alpha1);
            t4 = cos(theta);
            t5 = sin(theta);
            t6 = a+v;
            t7 = omega.*t;
            t8 = omega+theta;
            t13 = -alpha1;
            t14 = -d1;
            t15 = a./2.0;
            t16 = omega./2.0;
            t9 = cos(t8);
            t10 = t4.*v;
            t11 = sin(t8);
            t12 = t5.*v;
            t17 = t15+v;
            t18 = t16+theta;
            t23 = phi1+t7+t13+theta;
            t19 = cos(t18);
            t20 = sin(t18);
            t21 = t6.*t9;
            t22 = t6.*t11;
            t26 = cos(t23);
            t27 = sin(t23);
            t24 = t19.*4.0;
            t25 = t20.*4.0;
            t28 = 1.0./t26;
            t30 = t17.*t20.*2.0;
            t34 = t17.*t19.*2.0;
            t29 = t28.^2;
            t31 = t17.*t25;
            t32 = t4+t9+t24;
            t33 = t5+t11+t25;
            t35 = t17.*t24;
            t38 = t21+t34;
            t39 = t22+t30;
            t36 = (t.*t3.*t33)./6.0;
            t37 = (t.*t2.*t32)./6.0;
            t40 = t10+t21+t35;
            t41 = t12+t22+t31;
            t42 = (t.*t3.*t38)./6.0;
            t43 = (t.*t2.*t39)./6.0;
            t44 = -t43;
            t45 = (t.*t40)./6.0;
            t46 = (t.*t41)./6.0;
            t51 = t36+t37;
            t47 = t46+y;
            t48 = t45+x;
            t52 = t42+t44;
            t49 = t2.*t48;
            t50 = t3.*t47;
            t53 = t28.*t52;
            t54 = t14+t49+t50;
            t55 = t.*t27.*t29.*t54;
            t56 = t53+t55;
            t57 = t28.*t51.*t56;
            APP = [t29.*t51.^2,t57;t57,t56.^2];
        end
        function PP = FIM_Observe(self,x,y,theta,d,alpha,phi)
            %FIM_OBSERVE
            %    PP = FIM_OBSERVE(X,Y,THETA,D,ALPHA,PHI)
            
            %    This function was generated by the Symbolic Math Toolbox version 8.6.
            %    16-Nov-2021 18:17:45
            
            t2 = cos(alpha);
            t3 = sin(alpha);
            t6 = -alpha;
            t7 = -d;
            t4 = t2.*x;
            t5 = t3.*y;
            t8 = phi+t6+theta;
            t9 = cos(t8);
            t10 = sin(t8);
            t13 = t4+t5+t7;
            t11 = 1.0./t9.^2;
            t12 = 1.0./t9.^3;
            t14 = t2.*t3.*t11;
            t15 = t2.*t10.*t12.*t13;
            t16 = t3.*t10.*t12.*t13;
            PP = [t2.^2.*t11,t14,t15;t14,t3.^2.*t11,t16;t15,t16,t10.^2.*t11.^2.*t13.^2];
        end
        function eval = GetobjectiveFimEval(obj,x)
            % モデル予測制御の評価値を計算するプログラム
            params = obj.param;
            NoiseR = obj.NoiseR;
            SensorRange = obj.SensorRange;
            RangeGain= obj.RangeGain;
            %-- MPCで用いる予測状態 Xと予測入力 Uを設定
            X = x(1:params.state_size, :);
            U = x(params.state_size+1:params.state_size+params.input_size, :);
            % S = x(params.total_size+1:end,:);
            %-- 状態及び入力に対する目標状態や目標入力との誤差を計算
            tildeX = X - params.Xr;
            %     tildeU = U - params.Ur;
            tildeU = U;
            %
            evFim = zeros(1,params.H);
            evObFim = zeros(1,params.H);
            for j = 1:params.H
                t1 = params.phi;
                t2 = params.alpha;
                [~,tth]=min(abs(t1-t2),[],2);
                
                H = (params.dis(:) - X(1,j).*cos(params.alpha(:)) - X(2,j).*sin(params.alpha(:)))./cos(params.phi(tth)' - params.alpha(:) + X(3,j));%observation 
            %     RangeLogic = H<SensorRange;
                RangeLogic = (tanh(RangeGain*(SensorRange - H))+1)/2;
            %     Fim = RangeLogic(1) * FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j),U(2,j),params.dt, params.dis(1), params.alpha(1), params.phi(1));
                Fim = RangeLogic(1) * obj.FIM_ObserbSubAOmegaRungeKutta(X(1,j), X(2,j), X(3,j),X(4,j),U(2,j),U(1,j),params.dt, params.dis(1), params.alpha(1), params.phi(1));
                ObFim = RangeLogic(1) * obj.FIM_Observe(X(1,j), X(2,j), X(3,j), params.dis(1), params.alpha(1), params.phi(1));
                for i = 2:length(params.dis)
                    Fim = Fim + RangeLogic(i) * obj.FIM_ObserbSubAOmegaRungeKutta(X(1,j), X(2,j), X(3,j),X(4,j),U(2,j),U(1,j),params.dt, params.dis(i), params.alpha(i), params.phi(i));
            %         Fim = Fim + RangeLogic(i) * FIM_Ob    serbSub(X(1,j), X(2,j), X(3,j), X(4,j),U(2,j),params.dt, params.dis(i), params.alpha(i), params.phi(i));
                    ObFim = ObFim + RangeLogic(i) * obj.FIM_Observe(X(1,j), X(2,j), X(3,j), params.dis(i), params.alpha(i), params.phi(i));
                end
                Fim = (1/(2*NoiseR))*(Fim+1e-2*eye(2));
                ObFim = (1/(NoiseR))*(ObFim + 1e-2*eye(3));%[ObFim + [1e-2,1e-2,1e-2;1e-2,1e-2,1e-2;1e-2,1e-2,1e-2]]);
                InvFim = [Fim(2,2) -Fim(1,2); -Fim(2,1), Fim(1,1)]/(det(Fim));
                InvObFim = inv(ObFim);
            %     evFim(1,j) = max(eig(InvFim));
            evFim(1,j) = trace(InvObFim)*trace(InvFim);
            %evObFim(1,j) = trace(InvObFim);
            end
            %-- 状態及び入力のステージコストを計算
            stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
            stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
            % stageSlack = arrayfun(@(L) S(:, L)' * params.WoS * S(:,L), 1:params.H);
            eval.stageevFim = evFim* params.T *evFim';
            %-- 状態の終端コストを計算
            eval.terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
            %-- 評価値計算
            eval.StageState = sum(stageState);
            eval.StageInput = sum(stageInput);
            % eval.StageSlack = sum(stageSlack);
            eval.stageeObFim = 1;%evObFim* params.T * evObFim';
        end
    end
end