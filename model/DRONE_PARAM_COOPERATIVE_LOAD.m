classdef DRONE_PARAM_COOPERATIVE_LOAD < PARAMETER_CLASS
    % ドローンの物理パラメータ管理用クラス
    % 以下のconfigurationはclass_description.pptxも参照すること．
    % T = [T1;T2;T3;T4];                  % Thrust force ：正がzb 向き
    % 前：ｘ軸，　左：y軸，　上：ｚ軸
    % motor configuration 
    % T1 : 右後，T2：右前，T3：左後，T4：左前（x-y平面の象限順）
    % T2, T3 の回転方向は軸 zb,  T1, T4 : -zb      [1,0,0,1] で 正のyaw回転
    % tau = [(Ly - ly)*(T3+T4)-ly*(T1+T2); lx*(T1+T3)-(Lx-lx)*(T2+T4); km1*T1-km2*T2-km3*T3+km4*T4]; % Torque for body

     
    properties
        g % gravity 
        N % number of agents
        m0 % load mass
        J0 % load inertia
        rho % 
        li
        mi
        Ji
    end

    methods
        function obj = DRONE_PARAM_COOPERATIVE_LOAD(name,N,type,param)
            arguments
                % P = [g m0 j0 rho li mi ji]
                name % DIATONE
                N = 4;
                type = "struct";
                % parameters : 5 + 8*N
                param.g = 9.81;
                param.m0 = 1;
                param.J0 = [0.005;0.005;0.005];
                param.rho = [];
                param.li = 0.5*ones(N,1);
                param.mi = ones(N,1)';
                param.Ji = 0.005*repmat([1 1 1]',1,N);
                param.additional = []; % プロパティに無いパラメータを追加する場合
            end
            if isempty(param.rho)
              R = Rodrigues([0;0;1],2*pi/N);
              param.rho = [0;0;1/2]+[[1;0;0],cell2mat(cellmatfun(@(A,B) A*B, FoldList(@(A,B) A*B,cellrepmat(R,1,N-1),{eye(3)},"mat"),[1;0;0]))];
            end
            obj = obj@PARAMETER_CLASS(name,type,param);
            obj.N = N;
        end
    end

end