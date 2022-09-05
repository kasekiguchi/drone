classdef DRONE_PARAM < matlab.mixin.SetGetExactNames& dynamicprops
    % ドローンの物理パラメータ管理用クラス
    % 以下のconfigurationはclass_description.pptxも参照すること．
    % T = [T1;T2;T3;T4];                  % Thrust force ：正がzb 向き
    % 前：ｘ軸，　左：y軸，　上：ｚ軸
    % motor configuration 
    % T1 : 右後，T2：右前，T3：左後，T4：左前（x-y平面の象限順）
    % T2, T3 の回転方向は軸 zb,  T1, T4 : -zb      [1,0,0,1] で 正のyaw回転
    % tau = [(Ly - ly)*(T3+T4)-ly*(T1+T2); lx*(T1+T3)-(Lx-lx)*(T2+T4); km1*T1-km2*T2-km3*T3+km4*T4]; % Torque for body

    properties
        parameter % 制御モデル用パラメータ : 値ベクトル
        parameter_name % 物理パラメータの名前
        model_error % モデル誤差 : 制御対象の真値 - 制御モデル用パラメータ : 構造体
        mass % DIATONE
        Lx 
        Ly 
        lx 
        ly 
        jx 
        jy 
        jz 
        gravity 
        km1 
        km2 
        km3 
        km4 
        k1 
        k2
        k3
        k4
        rotor_r
        % T = k*w^2
        % T : thrust , w : angular velocity of rotor
        % M = km * T = km* k * w^2
        % M : zb moment  ：そのため普通の意味でのロータ定数とは違う
    end

    methods
        function obj = DRONE_PARAM(name,param)
            arguments
                name % DIATONE
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
                param.km1 = 0.0301; % ロータ定数
                param.km2 = 0.0301; % ロータ定数
                param.km3 = 0.0301; % ロータ定数
                param.km4 = 0.0301; % ロータ定数
                param.k1 = 0.000008;          % 推力定数
                param.k2 = 0.000008;          % 推力定数
                param.k3 = 0.000008;          % 推力定数
                param.k4 = 0.000008;          % 推力定数
                param.rotor_r = 0.0392;
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
        obj.km1 = param.km1;
        obj.km2 = param.km2;
        obj.km3 = param.km3;
        obj.km4 = param.km4;
        obj.k1 = param.k1;
        obj.k2 = param.k2;
        obj.k3 = param.k3;
        obj.k4 = param.k4;
        obj.rotor_r = param.rotor_r;
        
        if isempty(param.parameter_name)
            obj.parameter_name = string(properties(obj)');
            obj.parameter_name(strcmp(obj.parameter_name,"parameter")) = [];
            obj.parameter_name(strcmp(obj.parameter_name,"parameter_name")) = [];
            obj.parameter_name(strcmp(obj.parameter_name,"model_error")) = [];
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
                obj.parameter=[obj.parameter,obj.(obj.parameter_name(i))];
%                 obj.parameter=[obj.parameter;obj.(obj.parameter_name(i))];
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
            arguments
                obj
                p = "all";
                plant = "model"
            end
            if strcmp(plant,"model") 
                if strcmp(p,"all")
                    p = obj.parameter_name;
                end
                
                    v = [];
                    for i = 1:length(p)
                        if isfield(obj.model_error,p(i))
                            v = [v,obj.(p(i)) + obj.model_error.(p(i))];
                        else
                            v = [v,obj.(p(i))];
                        end
                    end
            else % 制御モデルで想定している値: 真値(parameter) + モデル誤差(model_error)
                if strcmp(p,"all") % 非推奨
                    v = obj.parameter;
                else
                    v = [];
                    for i = 1:length(p)
%                         v = [v,obj.(p(i))_];
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