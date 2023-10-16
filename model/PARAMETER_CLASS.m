classdef (Abstract) PARAMETER_CLASS < matlab.mixin.SetGetExactNames& dynamicprops
    % Model parameter class

    properties
        parameter % 制御モデル用パラメータ : 値ベクトル
        parameter_name % 物理パラメータの名前
        parameter_raw
        type
    end

    methods
        function obj = PARAMETER_CLASS(name,type,param)
            arguments
                name %
                type = "row"; % row : 列ベクトル or struct : 構造体
                param = [];
            end
            obj.type = type;
            if ~isempty(param)
                fn = fieldnames(param);
                fn(fn=="type") = [];
                fn(fn=="parameter") = [];
                fn(fn=="parameter_name") = [];     
                fn(fn=="additional") = [];  
                obj.parameter_name = string(fn);
                for i = 1:length(fn)
                    obj.(fn{i}) = param.(fn{i});
                end
                obj.parameter_raw = param;
            end
            if ~isempty(param.additional) % propertyに無いパラメータを設定する場合
                fn = fieldnames(param.additional);
                obj.parameter_name = [obj.parameter_name; string(fn)];
                for i = 1:length(fn)
                    addprop(obj,fn{i});
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
              if strcmp(type, "row")
                v = obj.parameter;
              else
                v = obj.parameter_raw;
              end
            else
                for i = 1:length(p)
                    if strcmp(type,"row")
                        val = obj.(p(i));
                        if ismatrix(val)
                            val = reshape(val,[1,numel(val)]);
                        end
                        if exist("v","var")
                            v = [v,val];
                        else
                            v = val;
                        end
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
          obj.parameter=[];
            for i = 1:length(obj.parameter_name)
                if isprop(obj,obj.parameter_name(i))
                    % if strcmp(obj.type,"row")
                        val = obj.(obj.parameter_name(i));
                        if size(val,1) > 1
                            val = reshape(val,[1,numel(val)]);
                        end
                        obj.parameter=[obj.parameter, val];
                    % else
                    %     obj.parameter.(obj.parameter_name(i)) = obj.(obj.parameter_name(i));
                    % end
                else % propertyに無いパラメータ
                    error("ACSL : this is not a parameter.");
                end
            end
        end
    end
end