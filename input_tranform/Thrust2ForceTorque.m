classdef Thrust2ForceTorque < INPUT_TRANSFORM_CLASS
    % 階層型線形化入力を算出するクラス
    % 別のコントローラでone step 分予測したものをリファレンスとしてHL入力を求めるので，移動速度が遅過ぎて使えない．
    
    properties
        result
        dir
        IT % input transformation
        IIT % inverse of IT
    end
    
    methods
        function obj = Thrust2ForceTorque(self,param)
            l = getParameter("Length");
            km = getParameter("km1");
            obj.IT = [1 1 1 1;sqrt(2)*l*[-1 -1 1 1]/2; sqrt(2)*l*[1 -1 1 -1]/2; km*[1 -1 -1 1]];
            obj.IIT = inv(obj.IT);
            obj.dir = param;
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

