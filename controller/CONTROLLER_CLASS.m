classdef (Abstract) CONTROLLER_CLASS < handle
    % ‚±‚ÌƒNƒ‰ƒX‚ÌŠT—v
    properties (Abstract)
        result
        self
    end
    
    methods (Abstract)
        result= do(obj,param);
        show(obj);
    end
end

