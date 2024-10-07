classdef ESTIMATE_LOAD_MASS < handle
    %牽引物の質量をEKFを用いて計算
            %運動方程式
            %mL*ddx = -mL*g +mu
            %状態：[pL;vL;mL]
            %入力：mu
            %観測値：[pL;vL;mL] mLは最小二乗解を用いて計算した値
    properties
        result
        JacobianF
        JacobianH
        Q
        R
        B
        n
        self
        g
        timer= [];
        ts = 0;
        dt
    end
    methods
        function obj = ESTIMATE_LOAD_MASS(self)
            obj.self= self;
            obj.dt = obj.self.plant.dt; % 刻み
            obj.g = self.parameter.gravity;
            ELfile="Jacobian_load_model";
            model.dim(1) = 7;%状態
            model.dim(2) = 3;%入力
            model.dim(3) = 1;%パラメータ
            model.method = str2func("load_model");
            if ~exist(ELfile,"file")
                obj.JacobianF=ExtendedLinearization(ELfile,model);
            else
                obj.JacobianF=str2func(ELfile);
            end
            obj.JacobianH = eye(7);
            obj.n = model.dim(1);
            obj.Q = blkdiag(eye(3)*1E0, eye(3)*1E0, 0*1e0);                     % システムノイズ（Modelクラス由来）B*Q*B'(Bは単位の次元を状態に合わせる，Qは標準偏差の二乗(分散))
            obj.B = blkdiag(0.5*obj.dt^2*eye(3), obj.dt*eye(3), 0*0.5*obj.dt^2);% システムノイズ（Modelクラス由来）
            obj.R = blkdiag(eye(3)*1e-10, eye(3)*1e-10, 1e0);                   %観測ノイズ
            obj.result.P        = eye(obj.n);
            obj.result.G        = zeros(obj.n, size(obj.R,2));
            obj.result.xh_pre   = [];
        end

        function result = estimate(obj,agent)%現在時刻と状態必要
          %刻み時間 
          if ~isempty(obj.timer)
            dtNow = toc(obj.timer);
            if dtNow > obj.dt
              dtNow = obj.dt;
            end
          else
            dtNow = obj.dt;
          end
          %カルマンフィルタの計算
          if ~isempty(obj.result.xh_pre)
            est     = obj.self.estimator.result.state;
            mL      = agent{end-1};
            mu      = agent{end};
            y       = [est.pL;est.vL;mL];                       % sensor output
            x       = obj.result.xh_pre;                        % estimated state at previous step
            xh_pre  = obj.update_state(x,mu);                   % Pre-estimation
            yh      = xh_pre;                                   % output estimation
            A       = eye(obj.n)+obj.JacobianF(x,obj.g)*dtNow;  % Euler approximation
            C       = obj.JacobianH;                            % observe matrix
            P_pre   = A*obj.result.P*A' + obj.B*obj.Q*obj.B';   % Predicted covariance
            G       = (P_pre*C')/(C*P_pre*C'+obj.R);            % Kalman gain
            P       = (eye(obj.n)-G*C)*P_pre;	                % Update covariance
            %save
            obj.result.xh_pre   = xh_pre + G*(y-yh);	        % Update state estimate
            obj.result.mL       = obj.result.xh_pre(end);
            obj.result.G        = G;
            obj.result.P        = P;
          else
              %一周目は初期値を代入
              est = obj.self.estimator.result.state;
              obj.result.xh_pre = [est.pL;est.vL;obj.self.parameter.loadmass];
              obj.result.mL     = obj.self.parameter.loadmass;
          end
            result      =obj.result;
            obj.timer   = tic;
        end
        
        function xNow = update_state(obj,x0,u)
            %状態更新
            [~, tmpx]   = ode15s(@(t, x) load_model(x, u, obj.g), [obj.ts obj.ts + obj.dt], x0);
            xNow        = tmpx(end,:)';
        end
    end
end