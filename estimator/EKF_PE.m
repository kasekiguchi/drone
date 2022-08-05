classdef EKF_PE < ESTIMATOR_CLASS
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
        y
        state % model と同じ状態　cf. result.state は推定値として受け渡すよう？
        self
    end
    
    methods
        function obj = EKF_PE(self,param)
            obj.self= self;
            obj.self.input = [0;0;0;0];
            model = self.model;
            ELfile=strcat("Jacobian_","load_parameter_estimation");
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
            obj.n = 27;
            obj.Q = param.Q;% 分散
            obj.R = param.R;% 分散
            obj.dt = model.dt; % 刻み
            obj.B = param.B;
            obj.result.P = param.P;
            obj.result.e = [0;0;0];
        end
        
        function [result]=do(obj,param,sensor)
            %   param : optional
            if ~isempty(param) obj.dt = param; end
            model=obj.self.model;
            if nargin == 2
                sensor = obj.self.sensor.result;
            end
            x = [obj.result.state.get(["p","q","v","w","pL","vL","pT","wL"]);obj.result.e]; % 前回時刻推定値
%            xh_pre = obj.result.state.get() + model.method(x,obj.self.input,model.param) * obj.dt;	% 事前推定%%5
             xh_pre = [model.state.get(["p","q","v","w","pL","vL","pT","wL"]);obj.result.e]; % 事前推定 ：入力ありの場合 （modelが更新されている前提）
            if isempty(obj.y.list)
                obj.y.list=sensor.state.list; % num_listは代入してはいけない．
            end
            state_convert(sensor.state,obj.y);% sensorの値をy形式に変換
            p = obj.self.parameter.get(["mass","Length","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","loadmass","cableL"]);
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
            projection = @(x)[x(1:18);x(19:21)/norm(x(19:21));x(22:24)-dot(x(19:21)/norm(x(19:21)),x(22:24))*x(19:21)/norm(x(19:21));x(25:27)];
            tmpvalue = projection(tmpvalue);
            obj.result.state.set_state(tmpvalue(1:24,1));
            obj.result.e = tmpvalue(25:27,1);
            obj.result.G = G;
            obj.result.P = P;
            obj.result.dt = obj.dt;
            result=obj.result;
        end
        function show()
        end
    end
end

