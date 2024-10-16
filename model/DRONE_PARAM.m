classdef DRONE_PARAM < PARAMETER_CLASS
    % ドローンの物理パラメータ管理用クラス
    % 以下のconfigurationはclass_description.pptxも参照すること．
    % T = [T1;T2;T3;T4];                  % Thrust force ：正がzb 向き
    % 前：ｘ軸，　左：y軸，　上：ｚ軸
    % motor configuration 
    % T1 : 右後，T2：右前，T3：左後，T4：左前（x-y平面の象限順）
    % T2, T3 の回転方向は軸 zb,  T1, T4 : -zb      [1,0,0,1] で 正のyaw回転
    % tau = [(Ly - ly)*(T3+T4)-ly*(T1+T2); lx*(T1+T3)-(Lx-lx)*(T2+T4); km1*T1-km2*T2-km3*T3+km4*T4]; % Torque for body

    properties
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
        function obj = DRONE_PARAM(name,type,param)
            arguments
                name % DIATONE
                type = "row";
                % param.mass = 0.5884;
                % param.mass = 0.640; %2024/1/15計量、機体+battery
                param.mass = 0.730; %iflight+6cell
                % param.Lx = 0.16;
                % param.Ly = 0.16;
                % param.lx = 0.16/2;%0.05;
                % param.ly = 0.16/2;%0.05;
                % param.jx = 0.06;
                % param.jy = 0.06;
                % param.jz = 0.06;
                param.Lx = 0.175;
                param.Ly = 0.175;
                param.lx = 0.175/2;%0.05;
                param.ly = 0.175/2;%0.05;
                param.jx = 0.085;
                param.jy = 0.085;
                param.jz = 0.085;
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
            end
            obj = obj@PARAMETER_CLASS(name,type,param);
        end
    end

end