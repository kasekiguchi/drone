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
                N = 6;%修正必要modeの値と同じにする
                type = "struct";
                % parameters : 5 + 8*N
                param.g = 9.81;
                param.m0 = 1.200;%分割前のペイロード
                % param.J0 = [0.15;0.15;0.25];%分割前ペイロード慣性モーメント
                % param.J0 = [0.2262;0.3434;0.4735];%非対称牽引物
                % param.J0 = [0.2262;0.3434;0.4735];%非対称牽引物
                param.J0 = [0.35;0.47;0.45];%非対称牽引物
                param.rho = [];%分割前の重心位置から紐がついてるところ前での距離
                param.li = 2*ones(N,1);%紐の長さ
                param.mi = 0.800*ones(N,1)';%ドローンの重さ
%                 param.Ji = repmat([0.082 0.0845 0.1377]',1,N);
                param.Ji = repmat([0.082 0.082 0.1377]',1,N);%ドローンの慣性モーメント
                param.additional = []; % プロパティに無いパラメータを追加する場合
            end
            if contains(type,"zup")
              rho0 = [0;0;1/4];
              rho0 = [0;0;1/2];
            else
              rho0 = [0;0;-1/4];
            end
            %非対称牽引物
                % x1 = [-1 -1 0 1 1 0];
                % y1 = [-1 1/2 1 1/2 -1/2 -1];
                x1 = [-2 -1.5 0 1.5 1 0];
                y1 = [-1 0.5 1 0.5 -0.5 -1];
                z1 = ones(1,6);
                p = [x1;y1;z1];
                polyin = polyshape(x1,y1);
                [x,y] = centroid(polyin);
                G = [x;y;0.5];
                param.rho = p-G;
            if isempty(param.rho)
              R = Rodrigues([0;0;1],2*pi/N);%回転行列を求める
              %ペイロードの重心位置からリンクまでの距離
              param.rho = rho0+[[1;0;0],double(cellmatfun(@(A,~) A*[1;0;0], FoldList(@(A,B) A*B,cellrepmat(R,1,N-1),{eye(3)},"mat"),"mat"))];
            end
            obj = obj@PARAMETER_CLASS(name,type,param);
            obj.N = N;
        end
    end

end