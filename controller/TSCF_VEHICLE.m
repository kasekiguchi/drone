classdef TSCF_VEHICLE < CONTROLLER_CLASS
    % 車両の時間軸状態制御形での制御
    properties
        self
        result
        F1
        F2
        eps = 0.001;
    end
    
    methods
        function obj = TSCF_VEHICLE(self,param)
            obj.self = self;
            obj.F1 = param.F1;
            obj.F2 = param.F2;
        end
        
        function result=do(obj,param,~)
            % param.strans : 状態変換
            % param.rtrans : リファレンス変換
            model = obj.self.estimator.result;
            ref = obj.self.reference.result(:,end); % MPC reference に対応するため
            [p,v,th] = param.strans(model.state);
            [rp,rv,rth] = param.rtrans(ref.state);

            e = [cos(th);sin(th)];
            ep = [-sin(th);cos(th)];
            dp = r - p;
            u1=obj.F1*(Vr+dp)'*e;
            u2=obj.F2*(Vr+dp)'*ep/(u1+obj.eps);

            obj.result.input(1) = u1*e; % 速度 or 加速度
            obj.result.input(end) = u2; % 角速度 or 各加速度

            obj.self.input = obj.result.input;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

