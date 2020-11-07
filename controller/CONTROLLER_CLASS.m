classdef (Abstract) CONTROLLER_CLASS < handle
    % このクラスの概要
    properties (Abstract)
        result
        self
    end
    
    methods (Abstract)
        result= do(obj,param);
        show(obj);
    end
end

