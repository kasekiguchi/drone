classdef(Abstract) INPUT_TRANSFORM_CLASS < handle
    
    properties (Abstract)
        result
    end
    
    methods (Abstract)
        result = do(obj,param);
    end
end

