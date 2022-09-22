classdef EKF_PE2 < ESTIMATOR_CLASS
   % Extended Kalman filter
    % obj = EKF(model,param)
    %   model : EKFを実装する制御対象の制御モデル
    %   param : required field : Q,R,B,JacobianH
    %  JacobianH(x,p) : 出力方程式の拡張線形化した関数のhandle
      properties
        %state
        result
        JacobianF
        JacobianH
        Q
        R
        dt
        B
        n
        JacobianFt
        JacobianHt
        Qt
        Rt
        Bt
        nt
        y
        state % model と同じ状態　cf. result.state は推定値として受け渡すよう？
        self
        time
        projection
    end
    
    methods
        function obj = EKF_PE2(self,param)
            obj.self= self;
            obj.self.input = [0;0;0;0];
            model = self.model;
            ELfile=strcat("Jacobian_",model.name);
            if ~exist(ELfile,"file")
                obj.JacobianF=ExtendedLinearization(ELfile,model);
            else
                obj.JacobianF=str2func(ELfile);
            end
            obj.result.state= state_copy(model.state);
            obj.y= state_copy(model.state);
            if isfield(param,'list')
                obj.y.list = param.list;
            else
                obj.y.list = [];
            end
            obj.JacobianH = param.JacobianH;
            obj.n = length(model.state.get());
            obj.Q = param.Q;% 分散
            obj.R = param.R;% 分散
            obj.dt = model.dt; % 刻み
            obj.B = param.B;
            obj.result.P = param.P;
            obj.JacobianFt=str2func(strcat("Jacobian_load"));
            obj.JacobianHt = param.JacobianHt;
            obj.nt = 24;
            obj.Qt = param.Qt;% 分散
            obj.Rt = param.Rt;% 分散
            obj.Bt = param.Bt;
            obj.result.Pt = param.Pt;
            obj.time = tic;
            obj.projection = @(x)[x(1:18);x(19:21)/norm(x(19:21));x(22:24)-dot(x(19:21)/norm(x(19:21)),x(22:24))*x(19:21)/norm(x(19:21))];
        end
        
        function [result]=do(obj,param,~)
            %   param : optional
            if isempty(param)
                obj.dt = toc(obj.time);
                obj.time = tic;
            else
                obj.dt = param;
            end
            model=obj.self.model;
            sensor = obj.self.sensor.result;
            x = obj.result.state.get(); % 前回時刻推定値
%            xh_pre = obj.result.state.get() + model.method(x,obj.self.input,model.param) * obj.dt;	% 事前推定%%5
             xh_pre = model.state.get(); % 事前推定 ：入力ありの場合 （modelが更新されている前提）
            if isempty(obj.y.list)
                obj.y.list=sensor.state.list; % num_listは代入してはいけない．
            end
            state_convert(sensor.state,obj.y);% sensorの値をy形式に変換
            p = model.param;
            A = eye(obj.n)+obj.JacobianF(x,p)*obj.dt; % Euler approximation
            C = obj.JacobianH(x,p);

            if norm(obj.y.q(3)-model.state.q(3)) > pi
                if obj.y.q(3) > 0
                    model.state.set_state("q",model.state.q+[0;0;2*pi]);
                else
                    model.state.set_state("q",model.state.q-[0;0;2*pi]);
                end
                xh_pre = model.state.get();
            end

            %obj.B = diag([ones(1,6)*obj.dt^2,ones(1,6)*obj.dt]); % to be check
            P_pre  = A*obj.result.P*A' + obj.B*obj.Q*obj.B';       % 事前誤差共分散行列
            G = (P_pre*C')/(C*P_pre*C'+obj.R); % カルマンゲイン更新
            P    = (eye(obj.n)-G*C)*P_pre;	% 事後誤差共分散
            tmpvalue = xh_pre + G*(obj.y.get()-C*xh_pre);	% 事後推定
            tmpvalue = model.projection(tmpvalue);
            obj.result.G = G;
            obj.result.P = P;            
            x = obj.result.state.get(["p","q","v","w","pL","vL","pT","wL"]);
            xh_pre = model.state.get(["p","q","v","w","pL","vL","pT","wL"]); % 事前推定 ：入力ありの場合 （modelが更新されている前提）
            p = obj.self.parameter.get(["mass","Length","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","loadmass","cableL","ex","ey","ez"]);
            A = eye(obj.nt)+obj.JacobianFt(x,p)*obj.dt; % Euler approximation
            C = obj.JacobianHt(x,p);
            P_pre  = A*obj.result.Pt*A' + obj.Bt*obj.Qt*obj.Bt';       % 事前誤差共分散行列
            G = (P_pre*C')/(C*P_pre*C'+obj.Rt); % カルマンゲイン更新
            P    = (eye(obj.nt)-G*C)*P_pre;	% 事後誤差共分散
            tmpvaluet = xh_pre + G*(obj.y.get()-C*xh_pre);	% 事後推定
            tmpvaluet = obj.projection(tmpvaluet);
            obj.result.Gt = G;
            obj.result.Pt = P;
            if strcmp(obj.self.reference.point.flag,'f')%||strcmp(obj.self.reference.point.flag,'h')
                obj.result.state.set_state(tmpvalue);
            else
                obj.result.state.set_state([tmpvaluet;p(1,17:18)']);
            end
            obj.result.dt = obj.dt;
            result=obj.result;
        end
        function show()
        end
    end
end

