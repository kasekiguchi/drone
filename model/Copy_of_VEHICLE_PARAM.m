classdef VEHICLE_PARAM < matlab.mixin.SetGetExactNames& dynamicprops
    % 車両モデルのパラメータ管理用クラス

    properties
        parameter % 制御モデル用パラメータ : 値ベクトル
        parameter_name % 物理パラメータの名前
        model_error % モデル誤差 = 制御対象の真値 - 制御モデル用パラメータ : 構造体
        mass % DIATONE
        Lx 
        Ly 
        lx 
        ly 
        jx 
        jy 
        jz 
        gravity
        plant_or_model = "model";
    end

    methods
        function obj = VEHICLE_PARAM(name,param)
            arguments
                name % 
                param.parameter_name = [];
                param.mass = 0.269;
                param.Lx = 0.117;
                param.Ly = 0.0932;
                param.lx = 0.117/2;%0.05;
                param.ly = 0.0932/2;%0.05;
                param.jx = 0.02237568;
                param.jy = 0.02985236;
                param.jz = 0.0480374;
                param.gravity = 9.81;
                param.additional = []; % プロパティに無いパラメータを追加する場合
                param.model_error = [];
            end
        obj.mass = param.mass;
        obj.Lx = param.Lx;
        obj.Ly = param.Ly;
        obj.lx = param.lx;
        obj.ly = param.ly;
        obj.jx = param.jx;
        obj.jy = param.jy;
        obj.jz = param.jz;
        obj.gravity = param.gravity;
        if isempty(param.parameter_name)
            obj.parameter_name = string(properties(obj)');
            obj.parameter_name(strcmp(obj.parameter_name,"parameter")) = [];
            obj.parameter_name(strcmp(obj.parameter_name,"parameter_name")) = [];
            obj.parameter_name(strcmp(obj.parameter_name,"model_error")) = [];
            obj.parameter_name(strcmp(obj.parameter_name,"plant_or_model")) = [];
        else
            obj.parameter_name = param.parameter_name;
        end
        if ~isempty(param.additional)
            fn = fieldnames(param.additional);
            for i = 1:length(fn)
                addprop(obj,fn{i});
                obj.parameter_name = [obj.parameter_name, fn{i}];
                obj.(fn{i}) = param.additional.(fn{i});
            end
        end
        for i = 1:length(obj.parameter_name)
            if isprop(obj,obj.parameter_name(i))
                if size(obj.(obj.parameter_name(i)),2) > 1
                    val = reshape(obj.(obj.parameter_name(i)),[numel(obj.(obj.parameter_name(i))),1]);
                else
                    val = obj.(obj.parameter_name(i));
                end
                obj.parameter=[obj.parameter;val];
                % TODO : 行列パラメータの扱い
            else % propertyに無いパラメータを設定する場合
                addprop(obj,parameter_name(i));
                obj.(parameter_name(i)) = param.additional.(parameter_name(i));
            end
%            obj.model_error(i) = zeros(size(obj.(obj.parameter_name(i))));
        end
        if ~isempty(param.model_error)
            obj.model_error = param.model_error;
        end
        end        
    end
    methods
        function v = get(obj,p,plant)
            % plant = model + model_error
            arguments
                obj
                p = "all";
                plant = "model"
            end
            if strcmp(plant,"plant") || strcmp(obj.plant_or_model,"plant") % 制御対象の真値 : 制御モデル(parameter) + モデル誤差(model_error)
                if strcmp(p,"all") % 非推奨
                    v = obj.parameter + obj.model_error;
                else
                    v = [];
                    for i = 1:length(p)
                        if size(obj.(p(i)),1)>1
                            val = reshape(obj.(p(i)),[1,numel(obj.(p(i)))]);
                        else
                            val = obj.(p(i));
                        end
                        if isfield(obj.model_error,p(i))
                            if size(obj.(p(i)),1)>1
                                me = reshape(obj.model_error.(p(i)),[1,numel(obj.model_error.(p(i)))]);
                            else
                                me = obj.model_error.(p(i));
                            end
                            v = [v,val + me];
                        else
                            v = [v,val];
                        end
                    end
                end
            else % 制御モデルで想定している値
                if strcmp(p,"all") % 非推奨
                    v = obj.parameter;
                else
                    v = [];
                    for i = 1:length(p)
                        v = [v,obj.(p(i))];
                    end
                end
            end
        end
        function set_model_error(obj,p,v)
            if iscell(v)
                for i = 1:length(p)
                    obj.model_error.(p(i)) = v{i};
                end
            else
                for i = 1:length(p)
                    obj.model_error.(p(i)) = v(i);
                end
            end
        end
    end
end