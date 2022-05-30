classdef DRONE_PARAM < matlab.mixin.SetGetExactNames
    % ドローンの物理パラメータ管理用クラス
    % 
    properties
        parameter % 制御モデル用パラメータ
        parameter_name % 物理パラメータの名前
        model_error % モデル誤差 : 制御対象の真値 - 制御モデル用パラメータ
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
                name
                param.mass = 0.269;% DIATONE
                param.Lx = 0.117;
                param.Ly = 0.0932;
                param.lx = 0.117/2;%0.05;
                param.ly = 0.0932/2;%0.05;
                param.jx = 0.002237568;
                param.jy = 0.002985236;
                param.jz = 0.00480374;
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
        obj.parameter_name = string(properties(obj)');
        obj.parameter_name(strcmp(obj.parameter_name,"parameter")) = [];
        obj.parameter_name(strcmp(obj.parameter_name,"parameter_name")) = [];
        obj.parameter_name(strcmp(obj.parameter_name,"model_error")) = [];
        for i = obj.parameter_name
                obj.parameter=[obj.parameter,obj.(i)];
                obj.model_error = [obj.model_error,0];
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
                if strcmp(p,"all")
                    v = obj.parameter + obj.model_error;
                else
                    v = obj.(p) + obj.model_error(strcmp(obj.parameter_name,p));
                end
            else % 制御モデルで想定している値
                if strcmp(p,"all")
                    v = obj.parameter;
                else
                    v = obj.(p);
                end
            end
        end
    end
end