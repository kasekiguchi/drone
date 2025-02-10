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
        rhoc
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
                %六角中
                param.m0 = 1.200;%分割前のペイロード
                % param.J0 = [0.35;0.47;0.45];%非対称牽引物
                %四角中
                % param.m0 = 3.900;%分割前のペイロード実験牽引物四角
                % param.J0 = [2^2*0.1^2;2^2*0.1^2;2*0.02^2]* 3.900/3;%非対称牽引物正方形
                
                param.J0 = [0.15;0.15;0.25];%分割前ペイロード慣性モーメント
                % param.J0 = [0.2262;0.3434;0.4735];%非対称牽引物
                % param.J0 = [0.2262;0.3434;0.4735];%非対称牽引物

                param.rho = [];%分割前の重心位置から紐がついてるところ前での距離
                param.li = 2*ones(N,1);%2*ones(N,1);%紐の長さ
                param.mi = 0.800*ones(N,1)';%ドローンの重さ
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
            %% 非対称牽引物
                %*Up, *Downは牽引物の上面と下面を表す   
                %六角形
                xUp = [-2 -1.5 0 1.5 1 0];
                yUp = [-1 0.5 1 0.5 -0.5 -1];
                zUp = 0.5*ones(1,6);
                pUp = [xUp;yUp;zUp]*0.5;%

                xDown = [-2 -1.5 0 1.5 1 0];
                yDown = [-1 0.5 1 0.5 -0.5 -1];
                zDown = -0.5*ones(1,6);
                pDown = [xDown;yDown;zDown]*0.5;%

                %四角形
                % xUp = [2 -2 -2 2];
                % yUp = [2 2 -2 -2];
                % zUp = 0.1*ones(1,4);
                % pUp = [xUp;yUp;zUp];%
                % xDown = [2 -2 -2 2];
                % yDown = [2 2 -2 -2];
                % zDown = -0.1*ones(1,4);
                % pDown = [xDown;yDown;zDown];%

                %重心の計算
                polyin = polyshape(pUp(1,:),pUp(2,:));
                [x,y] = centroid(polyin);
                G = [x;y;0];
                rho = pUp-G;%重心位置から接続点までの距離
                %接続点を頂点とする図形の重心位置
                polyin = polyshape(pUp(1,1:N),pUp(2,1:N));
                [x,y] = centroid(polyin);
                Gc = [x;y;0];
                rhoc = pUp-Gc;%接続点を頂点とする図形の重心位置から接続点までの距離
                
                %紐の接続点が牽引物の頂点と違う場合はここで設定
                % xUp = [2 0 -2 0];
                % yUp = [0 2 0 -2];
                % zUp = 0.1*ones(1,4);
                % rho = [xUp;yUp;zUp]-G;

                param.rho = rho(:,1:N);
                param.rhoc = rhoc(:,1:N);
                param.pUp = pUp;
                param.pDown = pDown;
                param.G=G;
                %plot payload shape
                  xM = pUp(1,:); %- G(1);
                  yM = pUp(2,:); %- G(2);
                  zM = pUp(3,:); %- G(3);
                  xm = pDown(1,:); % - G(1);
                  ym = pDown(2,:); % - G(2);
                  zm = pDown(3,:); % - G(3);
                  
                  % plot
                  % plot3(0,0,0,"MarkerSize",10,"Marker","*","Color","red")%重心位置
                  % plot3(Gc(1)-G(1),Gc(2)-G(2),Gc(3)-G(3),"MarkerSize",10,"Marker","*","Color","blue")%重心位置

                  % plot3(Gc(1),Gc(2),Gc(3),"MarkerSize",10,"Marker","*","Color","blue")%重心位置
                  plot3(G(1),G(2),G(3),"MarkerSize",10,"Marker","*","Color","red")%重心位置
                  hold on
                  fill3(xm,ym,zm,"cyan","FaceAlpha",0.5);%下面
                  fill3(xM,yM,zM,"cyan","FaceAlpha",0.5);%上面
                  surf([xm,xm(1);xM,xM(1)],[ym,ym(1);yM,yM(1)],[zm,zm(1);zM,zM(1)],"FaceAlpha",0.5);%側面
                  hold off
                  legend("COG","Interpreter","latex")
                  xlim([min(xM),max(xM)])
                  ylim([min(yM),max(yM)])
                  zlim([min(zm),max(zM)])
                  daspect([1,1,1])
                  grid on
                  grid minor
                  set(gca,"TickLabelInterpreter","latex","fontsize",16)
                  xlabel('$x$ (m)','Interpreter','latex')%,"FontSize",18)
                  ylabel('$y$ (m)','Interpreter','latex')%,"FontSize",18)
                  zlabel('$z$ (m)','Interpreter','latex')%,"FontSize",18)
                  %%
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