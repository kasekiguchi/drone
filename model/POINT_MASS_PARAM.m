classdef POINT_MASS_PARAM < matlab.mixin.SetGetExactNames
    % 質点モデルの物理パラメータ管理用クラス

    properties
        parameter % 制御モデル用パラメータ
        parameter_name % 物理パラメータの名前
        model_error % モデル誤差 : 制御対象の真値 - 制御モデル用パラメータ
        A
        B
        C
        D
    end

    methods
        function obj = POINT_MASS_PARAM(name,param)
            arguments
                name
                param.parameter_name = [];
                param.model_error = [];
                param.A = [zeros(3) eye(3);zeros(3,6)]; % 次の時刻に入力の位置に行くモデル
                param.B = [zeros(3);eye(3)];
                param.C = [eye(3),zeros(3)];
                param.D = zeros(3);
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
            obj.(obj.parameter_name(i)) = param.(obj.parameter_name(i));
            obj.model_error.(obj.parameter_name(i)) = 0;
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
                for i = length(p):-1:1
                    v.(p(i)) = obj.(p(i)) + obj.model_error.(p(i));
                end
            else % 制御モデルで想定している値
                for i = length(p):-1:1
                    v.(p(i)) = obj.(p(i));
                end
            end
        end
        function set_model_error(obj,p,v)
            for i = length(p):-1:1
                obj.model_error.(p(i)) = v.(p(i));
            end
        end
    end
end