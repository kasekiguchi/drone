classdef (Abstract) ENV_CLASS < matlab.mixin.SetGet
    % ENV_CLASS ：環境生成用抽象クラス
    %  
    properties
        map
    end
    
    methods (Abstract)
        show()
    end
end

