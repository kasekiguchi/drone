classdef VEHICLE_PARAM < matlab.mixin.SetGetExactNames& dynamicprops
    % 車両モデルのパラメータ管理用クラス

    properties
        parameter % 制御モデル用パラメータ : 値ベクトル
        parameter_name % 物理パラメータの名前
        type
        mass % DIATONE
        Lx
        Ly
        lx
        ly
        jx
        jy
        jz
        gravity
    end

    methods
        function obj = VEHICLE_PARAM(name,type,param)
            arguments
                name %
                type = "row"; % row : 列ベクトル or struct : 構造体
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
            end
            obj.type = type;
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
                obj.parameter_name(strcmp(obj.parameter_name,"type")) = [];
                obj.parameter_name(strcmp(obj.parameter_name,"parameter")) = [];
                obj.parameter_name(strcmp(obj.parameter_name,"parameter_name")) = [];
            else
                obj.parameter_name = param.parameter_name;
            end
            if ~isempty(param.additional) % propertyに無いパラメータを設定する場合
                fn = fieldnames(param.additional);
                for i = 1:length(fn)
                    addprop(obj,fn{i});
                    obj.parameter_name = [obj.parameter_name, fn{i}];
                    obj.(fn{i}) = param.additional.(fn{i});
                end
            end
            obj.update_parameter();
        end
    end
    methods
        function v = get(obj,p,type)
            arguments
                obj
                p = "all";
                type = obj.type;
            end
            if strcmp(p,"all")
                v = obj.parameter;
            else
                for i = 1:length(p)
                    if strcmp(type,"row")
                        val = obj.(p(i));
                        if ismatrix(val)
                            val = reshape(val,[1,numel(val)]);
                        end
                        v = [v,val];
                    else
                        v.(p(i))= obj.(p(i));
                    end
                end
            end
        end
        function set(obj,p,v)
            % v is struct with field p(:)
            for i = p
                obj.(i) = v.(i);
            end
            obj.update_parameter();
        end
        function update_parameter(obj)
            for i = 1:length(obj.parameter_name)
                if isprop(obj,obj.parameter_name(i))
                    if strcmp(obj.type,"row")
                        val = obj.(obj.parameter_name(i));
                        if size(val,2) > 1
                            val = reshape(val,[numel(val),1]);
                        end
                        obj.parameter=[obj.parameter;val];
                    else
                        obj.parameter.(obj.parameter_name(i)) = obj.(obj.parameter_name(i));
                    end
                else % propertyに無いパラメータ
                    error("ACSL : this is not a parameter.");
                end
            end
        end
    end
end