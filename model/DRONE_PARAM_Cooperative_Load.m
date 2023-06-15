classdef DRONE_PARAM_Cooperative_Load < PARAMETER_CLASS
    % ドローンの物理パラメータ管理用クラス
    % 以下のconfigurationはclass_description.pptxも参照すること．
    % T = [T1;T2;T3;T4];                  % Thrust force ：正がzb 向き
    % 前：ｘ軸，　左：y軸，　上：ｚ軸
    % motor configuration 
    % T1 : 右後，T2：右前，T3：左後，T4：左前（x-y平面の象限順）
    % T2, T3 の回転方向は軸 zb,  T1, T4 : -zb      [1,0,0,1] で 正のyaw回転
    % tau = [(Ly - ly)*(T3+T4)-ly*(T1+T2); lx*(T1+T3)-(Lx-lx)*(T2+T4); km1*T1-km2*T2-km3*T3+km4*T4]; % Torque for body

     
    properties
        g % DIATONE
        m0 
        j01 
        j02 
        j03 
        rho1_1 
        rho1_2 
        rho1_3 
        rho2_1 
        rho2_2 
        rho2_3 
        rho3_1 
        rho3_2 
        rho3_3 
        rho4_1
        rho4_2
        rho4_3
        li1
        li2
        li3
        li4
        mi1
        mi2
        mi3
        mi4
        ji1_1
        ji1_2
        ji1_3
        ji2_1
        ji2_2
        ji2_3
        ji3_1
        ji3_2
        ji3_3
        ji4_1
        ji4_2
        ji4_3

        % T = k*w^2
        % T : thrust , w : angular velocity of rotor
        % M = km * T = km* k * w^2
        % M : zb moment  ：そのため普通の意味でのロータ定数とは違う
    end

    methods
        function obj = DRONE_PARAM(name,type,param)
            arguments
                % P = [g m0 j0 rho li mi ji]
                name % DIATONE
                type = "row";
                param.g = 9.81;
                param.m0 = m0;
                param.j01 = 0.005
                param.j02 = 0.005
                param.j03 = 0.005                
                param.rho1_1 = 1
                param.rho1_2 = 1
                param.rho1_3 = -1
                param.rho2_1 = 1
                param.rho2_2 = -1
                param.rho2_3 = -1
                param.rho3_1 = -1
                param.rho3_2 = -1
                param.rho3_3 = -1
                param.rho4_1 = -1
                param.rho4_2 = 1
                param.rho4_3 = -1
                param.li1 = 0.5
                param.li2 = 0.5
                param.li3 = 0.5
                param.li4 = 0.5
                param.mi1 = 1
                param.mi2 = 1
                param.mi3 = 1
                param.mi4 = 1
                param.ji1_1 = 0.005
                param.ji1_2 = 0.005
                param.ji1_3 = 0.005
                param.ji2_1 = 0.005
                param.ji2_2 = 0.005
                param.ji2_3 = 0.005
                param.ji3_1 = 0.005
                param.ji3_2 = 0.005
                param.ji3_3 = 0.005
                param.ji4_1 = 0.005
                param.ji4_2 = 0.005
                param.ji4_3 = 0.005

                param.additional = []; % プロパティに無いパラメータを追加する場合
            end
            obj = obj@PARAMETER_CLASS(name,type,param);
        end
    end

end