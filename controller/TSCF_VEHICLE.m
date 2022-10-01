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
            % param (optional) : 構造体：物理パラメータP，ゲインF1-F4
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            p = model.state.p(1:2);
            r = ref.state.p(1:2);
            if isprop(ref.state,'v')
                Vr = ref.state.v(1:2);
            else
                Vr = [0;0];
            end
            th = model.state.q(3);
            e = [cos(th);sin(th)];
            ep = [-sin(th);cos(th)];
            dp = r - p;
            u1=obj.F1*(Vr+dp)'*e;
            u2=obj.F2*(Vr+dp)'*ep/(u1+obj.eps);

            obj.result.input = [u1*e;0;0;0;u2];
            obj.self.input = obj.result.input;
            result = obj.result;
        end
        function show(obj)
            obj.result
        end
    end
end

