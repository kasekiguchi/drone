classdef POINT_MASS_PARAM < PARAMETER_CLASS
    % 質点モデルの物理パラメータ管理用クラス

    properties
        A
        B
        C
        D

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
        function obj = POINT_MASS_PARAM(name,type,param)
            arguments
                name
                type = "struct";            
                param.additional = []; % プロパティに無いパラメータを追加する場合
                param.A = [zeros(3) eye(3);zeros(3,6)]; % 次の時刻に入力の位置に行くモデル
                param.B = [zeros(3);eye(3)];
                param.C = [eye(3),zeros(3)];
                param.D = zeros(3);

                % param.mass = 0.5884;
                param.mass = 0.640; %2024/1/15計量、機体+battery
                param.Lx = 0.16;
                param.Ly = 0.16;
                param.lx = 0.16/2;%0.05;
                param.ly = 0.16/2;%0.05;
                param.jx = 0.06;
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
                param.rotor_r = 0.0392;
            end
            obj = obj@PARAMETER_CLASS(name,type,param);
        end        
    end
end