classdef THRUST_DST_DRONE < handle

properties
    self
    dst
    result
end

methods

    function obj = THRUST_DST_DRONE(self, param)
        obj.self = self;
        obj.dst = param;
    end

    function u = do(obj, varargin)
        %% u = [uthr, uroll, upitch, uyaw, dst]
            i = varargin{1, 1}.k ;
            obj.result = [varargin{1, 5}.controller.result.input;obj.dst(:,i)];
            u = obj.result;
            obj.self.controller.result.input= obj.result;
    end

end
end
