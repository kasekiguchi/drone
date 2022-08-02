classdef NULL_PARAM < matlab.mixin.SetGetExactNames
    % 物理パラメータのないモデル用

    properties
        parameter % 制御モデル用パラメータ
        parameter_name % 物理パラメータの名前
        model_error % モデル誤差 : 制御対象の真値 - 制御モデル用パラメータ
    end

    methods
        function obj = NULL_PARAM(~,~)
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
                v = [];
            else % 制御モデルで想定している値
                v = [];
            end
        end
        function set_model_error(obj,~,~)
        end
    end
end