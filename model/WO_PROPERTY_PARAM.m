classdef WO_PROPERTY_PARAM < matlab.mixin.SetGetExactNames
    % プロパティの無い（parameterにベクトルとして格納）パラメータクラス

    properties
        parameter % 制御モデル用パラメータ
        parameter_name % 物理パラメータの名前
        model_error % モデル誤差 : 制御対象の真値 - 制御モデル用パラメータ
    end

    methods
        function obj = WO_PROPERTY_PARAM(name,param)
            arguments
                name % DIATONE
                param.parameter_name = [];
                param.model_error = [];
            end
        if isempty(param.parameter_name)
            obj.parameter_name = string(properties(obj)');
            obj.parameter_name(strcmp(obj.parameter_name,"parameter")) = [];
            obj.parameter_name(strcmp(obj.parameter_name,"parameter_name")) = [];
            obj.parameter_name(strcmp(obj.parameter_name,"model_error")) = [];
        else
            obj.parameter_name = param.parameter_name;
        end
        for i = length(obj.parameter_name):-1:1
            obj.parameter(i)=obj.(obj.parameter_name(i));
            obj.model_error(i) = 0;
        end
        if ~isempty(param.model_error)
            obj.model_error = param.model_error;
        end
        end        
    end
    methods
        function v = get(obj,p,plant)
            arguments
                obj
                p = "all";
                plant = "model"
            end
            if strcmp(plant,"plant") % 制御対象の真値 : 制御モデル(parameter) + モデル誤差(model_error)
                if strcmp(p,"all") % 非推奨
                    v = obj.parameter + obj.model_error;
                else
                    for i = length(p):-1:1
                        v(i) = obj.(p(i)) + obj.model_error(strcmp(obj.parameter_name,p(i)));
                    end
                end
            else % 制御モデルで想定している値
                if strcmp(p,"all") % 非推奨
                    v = obj.parameter;
                else
                    for i = length(p):-1:1
                        v(i) = obj.(p(i));
                    end
                end
            end
        end
        function set_model_error(obj,p,v)
            for i = length(p):-1:1
                obj.model_error(strcmp(obj.parameter_name,p(i))) = v(i);
            end
        end
    end
end