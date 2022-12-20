classdef NULL_PARAM < PARAMETER_CLASS
    % 物理パラメータのないモデル用

    properties
    end

    methods
        function obj = NULL_PARAM(name,type,param)
            arguments
                name
                type = "row";            
                param.additional = []; % プロパティに無いパラメータを追加する場合
            end
            obj = obj@PARAMETER_CLASS(name,type,param);
        end
    end
end