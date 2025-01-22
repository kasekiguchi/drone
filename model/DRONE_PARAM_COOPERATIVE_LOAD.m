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
        pUp
        pDown
        G
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
            if contains(type,"zup")&&isempty(param.rho)
              rho0 = [0;0;1/4];
              rho0 = [0;0;1/2];
            elseif isempty(param.rho)
              rho0 = [0;0;-1/4];
            end
            if isempty(param.rho)&& 1
            %非対称牽引物
                %上面
                % xUp = [-2 -1.5 0 1.5 1 0];
                % yUp = [-1 0.5 1 0.5 -0.5 -1];
                xUp = [-2 -1.5  1.5  0];
                yUp = [-1 0.5 0.5  -1];
                zUp = 0.5*ones(1,4);
                pUp = [xUp;yUp;zUp]*0.4;
                %下面
                xDown = [-2 -1.5  1.5  0];
                yDown = [-1 0.5 0.5  -1];
                zDown = -0.5*ones(1,4);
                pDown = [xDown;yDown;zDown]*0.4;
                %重心の計算
                polyin = polyshape(xUp,yUp);
                [x,y] = centroid(polyin);
                G = [x;y;0];
                % 重心から接続点までの距離
                rho = pUp-G;

                % param.rho = [rho(:,1),rho(:,3),rho(:,4),rho(:,5)];
                param.rho = rho(:,1:N);
                param.pUp = pUp;
                param.pDown = pDown;
                param.G=G;

                %plot payload shape
                  xM = pUp(1,:) - G(1);
                  yM = pUp(2,:) - G(2);
                  zM = pUp(3,:) - G(3);
                  xm = pDown(1,:) - G(1);
                  ym = pDown(2,:) - G(2);
                  zm = pDown(3,:) - G(3);
                  
                  % plot
                  fill3(xm,ym,zm,"cyan");%上面
                  hold on
                  fill3(xM,yM,zM,"cyan");%下面
                  surf([xm,xm(1);xM,xM(1)],[ym,ym(1);yM,yM(1)],[zm,zm(1);zM,zM(1)]);%側面
                  hold off
                  daspect([1,1,1])
                  grid minor
                  set(gca,"TickLabelInterpreter","latex","fontsize",10)
                  xlabel('$x$ (m)','Interpreter','latex',"FontSize",18)
                  ylabel('$y$ (m)','Interpreter','latex',"FontSize",18)
                  zlabel('$z$ (m)','Interpreter','latex',"FontSize",18)
                  input("Confirm the figure and press Enter.")
                  close
            end
                
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