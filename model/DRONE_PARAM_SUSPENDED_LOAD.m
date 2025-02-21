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
        parameter       % 制御モデル用パラメータ
        parameter_name  % 物理パラメータの名前
        model_error     % モデル誤差 : 制御対象の真値 - 制御モデル用パラメータ
        mass            % 機体質量
        Lx              % 機体x方向長さ
        Ly              % 機体y方向長さ
        lx              % 機体重心からロータまでのx方向長さ
        ly              % 機体重心からロータまでのy方向長さ
        jx              % x軸回りの機体の慣性モーメント
        jy              % y軸回りの機体の慣性モーメント
        jz              % z軸回りの機体の慣性モーメント
        gravity         % 重力加速度
        km1             % 1つめのロータのロータ定数
        km2             % 2つめのロータのロータ定数
        km3             % 3つめのロータのロータ定数
        km4             % 4つめのロータのロータ定数
        k1              % 1つめのロータの推力定数
        k2              % 2つめのロータの推力定数
        k3              % 3つめのロータの推力定数
        k4              % 4つめのロータの推力定数
        rotor_r         % ロータの半径
        loadmass        % 牽引物質量
        cableL          % 紐の長さ
        ex              % 機体への紐の接続点のx方向位置 (通常のモデルでは使わない)
        ey              % 機体への紐の接続点のy方向位置 (通常のモデルでは使わない)
        ez              % 機体への紐の接続点のz方向位置 (通常のモデルでは使わない)
        % T = k*w^2
        % T : thrust , w : angular velocity of rotor
        % M = km * T = km* k * w^2
        % M : zb moment  ：そのため普通の意味でのロータ定数とは違う
    end

    methods
        function obj = DRONE_PARAM_SUSPENDED_LOAD(name,param)
            % 現在のモデルでは[mass, jx, jy, jz, gravity, loadmass, cableL]のみしか使われていない．
            % 機体の長さLx, Lyは条件分岐で使われる
            arguments
                %
                name % DIATONE
                param.parameter_name    = [];
                param.mass              = 0.800;
                param.Lx                = 0.195;
                param.Ly                = 0.195;
                param.lx                = 0.195/2;
                param.ly                = 0.195/2;
                param.jx                = 0.0820;
                param.jy                = 0.0820;
                param.jz                = 0.1377;
                param.gravity           = 9.81;
                param.km1               = 0.0301;
                param.km2               = 0.0301;
                param.km3               = 0.0301;
                param.km4               = 0.0301;
                param.k1                = 0.000008;
                param.k2                = 0.000008;
                param.k3                = 0.000008;
                param.k4                = 0.000008;
                param.rotor_r           = 0.0392;
                param.loadmass          = 0.200;
                param.cableL            = 1;
                param.ex                = 0;
                param.ey                = 0;
                param.ez                = 0;
                param.model_error       = [];
            end
        obj.mass        = param.mass;
        obj.Lx          = param.Lx;
        obj.Ly          = param.Ly;
        obj.lx          = param.lx;
        obj.ly          = param.ly;
        obj.jx          = param.jx;
        obj.jy          = param.jy;
        obj.jz          = param.jz;
        obj.gravity     = param.gravity;
        obj.km1         = param.km1;
        obj.km2         = param.km2;    
        obj.km3         = param.km3;    
        obj.km4         = param.km4;
        obj.k1          = param.k1;
        obj.k2          = param.k2;
        obj.k3          = param.k3;
        obj.k4          = param.k4;
        obj.rotor_r     = param.rotor_r;
        obj.loadmass    = param.loadmass;
        obj.cableL      = param.cableL;
        obj.ex          = param.ex;
        obj.ey          = param.ey;
        obj.ez          = param.ez;
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
