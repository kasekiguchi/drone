classdef THRUST2FORCE_TORQUE < handle
    % 階層型線形化入力を算出するクラス
    % 別のコントローラでone step 分予測したものをリファレンスとしてHL入力を求めるので，移動速度が遅過ぎて使えない．
    
    properties
        result
        dir
        IT % input transformation
        IIT % inverse of IT
    end
    
    methods
        function obj = THRUST2FORCE_TORQUE(self,param)
            Lx = self.parameter.Lx;
            Ly = self.parameter.Ly;
            lx = self.parameter.lx;
            ly = self.parameter.ly;
            km1 = self.parameter.km1;           
            km2 = self.parameter.km2;           
            km3 = self.parameter.km3;           
            km4 = self.parameter.km4;           
            obj.IT = [1 1 1 1;-ly, -ly, (Ly - ly), (Ly - ly); lx, -(Lx-lx), lx, -(Lx-lx); km1, -km2, -km3, km4];
            obj.IIT = inv(obj.IT);
%             obj.dir = param;
            obj.dir = 1;
        end
        
        function u = do(obj,input,~)
            if obj.dir == 1
                u = obj.IT*input;
            else
                u = obj.IIT*input;
            end
            obj.result = u;
        end
    end
end

