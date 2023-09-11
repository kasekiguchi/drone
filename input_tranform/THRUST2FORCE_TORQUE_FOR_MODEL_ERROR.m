classdef THRUST2FORCE_TORQUE_FOR_MODEL_ERROR < handle
    % 階層型線形化入力を算出するクラス
    % 別のコントローラでone step 分予測したものをリファレンスとしてHL入力を求めるので，移動速度が遅過ぎて使えない．
    
    properties
        result
        dir
        IT % input transformation
        IT_m % input transformation model error
        T2T2T
    end
    
    methods
        function obj = THRUST2FORCE_TORQUE_FOR_MODEL_ERROR(self)
            pname = self.parameter.parameter_name;
            parameter = self.parameter.parameter;%paramater
            model_error = self.parameter.model_error;%paramater adding model error
            fname = contains(pname,["Lx","Ly","lx","ly","km1","km2","km3","km4"]);
            for i = 1:length(fname)
                if fname(i)
                    p.(pname(i)) = parameter(i);
                    m.(pname(i)) = model_error(i);
                end
            end
            IT = [1 1 1 1;-p.ly, -p.ly, (p.Ly - p.ly), (p.Ly - p.ly); p.lx, -(p.Lx-p.lx), p.lx, -(p.Lx-p.lx); p.km1, -p.km2, -p.km3, p.km4];
            IT_m = [1 1 1 1;-m.ly, -m.ly, (m.Ly - m.ly), (m.Ly - m.ly); m.lx, -(m.Lx-m.lx), m.lx, -(m.Lx-m.lx); m.km1, -m.km2, -m.km3, m.km4];
            obj.T2T2T=IT_m/IT;
        end
        
        function u = do(obj,~,~,~,~,self,~)
            input = self.controller.result.input;
            u=obj.T2T2T*input;
            obj.result = u;
        end
    end
end

