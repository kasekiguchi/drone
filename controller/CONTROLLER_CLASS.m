classdef (Abstract) CONTROLLER_CLASS < handle
    % ���̃N���X�̊T�v
    properties (Abstract)
        result
        self
    end
    
    methods (Abstract)
        result= do(obj,param);
        show(obj);
    end
end

