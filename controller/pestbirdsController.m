classdef pestbirdsController <CONTROLLER_CLASS   
%     害鳥追跡用のコントローラ
%     referenceとして渡された状態を返す
%     質点モデルで参照点に次時刻に行く時に利用
    properties
        self
        result
        param
    end
    methods
        function obj = pestbirdsController(self,~)
             obj.self = self;
        end
        
        function u = do(obj,~)
            xd=obj.self.reference.result.state;
            obj.result.input = xd.u;
            
            obj.self.input = obj.result.input;
            u = obj.result;
        end
        function show(obj)
            obj.result;
        end
    end
end

