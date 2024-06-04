classdef DRONE_PARAM_SUSPENDED_LOAD < matlab.mixin.SetGetExactNames
    % ドローンの物理パラメータ管理用クラス
    % 以下のconfigurationはclass_description.pptxも参照すること．
    % T = [T1;T2;T3;T4];                  % Thrust force ：正がzb 向き
    % 前：ｘ軸，　左：y軸，　上：ｚ軸
    % motor configuration 
    % T1 : 右後，T2：右前，T3：左後，T4：左前（x-y平面の象限順）
    % T2, T3 の回転方向は軸 zb,  T1, T4 : -zb      [1,0,0,1] で 正のyaw回転
    % tau = [(Ly - ly)*(T3+T4)-ly*(T1+T2); lx*(T1+T3)-(Lx-lx)*(T2+T4); km1*T1-km2*T2-km3*T3+km4*T4]; % Torque for body

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
        Length
        loadmass
        cableL
        % ex
        % ey
        % ez
        % T = k*w^2
        % T : thrust , w : angular velocity of rotor
        % M = km * T = km* k * w^2
        % M : zb moment  ：そのため普通の意味でのロータ定数とは違う
    end

    methods
        function obj = DRONE_PARAM_SUSPENDED_LOAD(name,param)
            arguments
                name % DIATONE
                param.parameter_name = [];
                % param.mass = 0.5236;
                % param.Lx = 0.195;
                % param.Ly = 0.195;
                % param.lx = 0.195/2;%0.05;
                % param.ly = 0.195/2;%0.05;
                % param.jx = 0.02237568;
                % param.jy = 0.02985236;
                % param.jz = 0.0480374;
                % param.gravity = 9.81;
                % param.km1 = 0.0301; % ロータ定数
                % param.km2 = 0.0301; % ロータ定数
                % param.km3 = 0.0301; % ロータ定数
                % param.km4 = 0.0301; % ロータ定数
                % param.k1 = 0.000008;          % 推力定数
                % param.k2 = 0.000008;          % 推力定数
                % param.k3 = 0.000008;          % 推力定数
                % param.k4 = 0.000008;          % 推力定数
                % param.rotor_r = 0.0392;
                % param.Length = 0.075;
                % param.loadmass = 0.0556;
                % param.cableL = 0.46;
                % % param.ex = 0.0735417984963207;
                % % param.ey = 0.0628671906594029;
                % % param.ez = 0.037;
                % param.model_error = [];

                %% 6セル from momose 
                % param.mass = 0.699;
                % param.Lx = 0.16;
                % param.Ly = 0.16;
                % param.lx = 0.08;%0.05;
                % param.ly = 0.08;%0.05;
                % param.jx = 0.06;
                % param.jy = 0.06;
                % param.jz = 0.06;
                % param.gravity = 9.81;
                % param.km1 = 0.0301; % ロータ定数
                % param.km2 = 0.0301; % ロータ定数
                % param.km3 = 0.0301; % ロータ定数
                % param.km4 = 0.0301; % ロータ定数
                % param.k1 = 0.000008;          % 推力定数
                % param.k2 = 0.000008;          % 推力定数
                % param.k3 = 0.000008;          % 推力定数
                % param.k4 = 0.000008;          % 推力定数
                % param.rotor_r = 0.0392;
                % param.Length = 0.08;
                % param.loadmass = 0.0695;
                % param.cableL = 0.49;
                % % param.ex = 0.0735417984963207;
                % %param.ey = 0.0628671906594029;
                % param.ex = 0.0;%何かシミュレーション結果変わる
                % param.ey = 0.0;
                % param.ez = 0.037;
                % param.additional = []; % プロパティに無いパラメータを追加する場合
                % param.model_error = [];

                %% 4セル from miyake
                param.mass = 0.6323;
                param.Lx = 0.16;
                param.Ly = 0.16;
                param.lx = 0.16/2;%0.05;
                param.ly = 0.16/2;%0.05;
                % param.jx = 0.02985236;%慣性モーメント
                % param.jy = 0.02985236;
                % param.jz = 0.0480374;
                param.jx = 0.06;%慣性モーメント
                param.jy = 0.06;
                param.jz = 0.06;
                param.gravity = 9.81;
                param.km1 = 0.0301; % ロータ定数
                param.km2 = 0.0301; % ロータ定数
                param.km3 = 0.0301; % ロータ定数
                param.km4 = 0.0301; % ロータ定数
                param.k1 = 0.000008;          % 推力定数
                param.k2 = 0.000008;          % 推力定数
                param.k3 = 0.000008;          % 推力定数
                param.k4 = 0.000008;          % 推力定数
                param.rotor_r = 0.0392; %シミュレーションでは少なくともアニメーションに使ってる
                param.Length = 0.08;%シミュレーションでは関係なさそう
                param.loadmass = 0.0695;
                param.cableL = 0.49;
                % param.ex = 0.0735417984963207;
                % param.ey = 0.0628671906594029;
                param.ex = 0.0;%何かシミュレーション結果変わる
                param.ey = 0.0;
                param.ez = 0.037;
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
        obj.Length = param.Length;
        obj.loadmass = param.loadmass;
        obj.cableL = param.cableL;
        % obj.ex = param.ex;
        % obj.ey = param.ey;
        % obj.ez = param.ez;
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
