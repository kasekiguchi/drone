classdef DRONE_PARAM_COOPERATIVE_LOAD < PARAMETER_CLASS
    % 機体の物理パラメータ管理用クラス
    % 以下のconfigurationはclass_description.pptxも参照すること．
    % T = [T1;T2;T3;T4];                  % Thrust force ：正がzb 向き
    % 前：ｘ軸，　左：y軸，　上：ｚ軸
    % motor configuration 
    % T1 : 右後，T2：右前，T3：左後，T4：左前（x-y平面の象限順）
    % T2, T3 の回転方向は軸 zb,  T1, T4 : -zb      [1,0,0,1] で 正のyaw回転

     
    properties
        g % gravity 
        N % number of agents
        m0 % load mass
        J0 % load inertia
        rho 
        li
        mi
        Ji
        pUp
        pDown
        G
        rhoc
        rhoini
    end

    methods
        function obj = DRONE_PARAM_COOPERATIVE_LOAD(name,N,type,param)
            arguments
                % 実験の時はrho,rhoini,(rhocはまだ未完成)のみ用いる
                % simの際はparamのfieldの最初からの並びが g, m0, J0, rho, li, mi, Ji,...とする（plantの複数機牽引のmodelの関数に入れる際にこの並びである必要があるため）
                name % DIATONE
                N
                type                = "struct";
                param.g             = 9.81;
                %六角柱
                param.m0            = 1.200;%分割前の牽引物
                param.J0            = [0.15;0.15;0.25];%分割前牽引物慣性モーメント
                % param.J0            = [0.35;0.47;0.45];%非対称牽引物
                % param.J0            = [0.2262;0.3434;0.4735];%非対称牽引物
                %四角柱
                % param.m0            = 3.900;%分割前の牽引物実験牽引物四角
                % param.J0            = [2^2*0.1^2;2^2*0.1^2;2*0.02^2]* 3.900/3;%非対称牽引物正方形

                param.rho           = [];%分割前の重心位置から紐がついてるところ前での距離
                param.rhoc          = zeros(3,N-1);%接続点を頂点とする図形の重心位置から接続点までの距離
                param.rhoini        = zeros(3,N-1);
                param.li            = 2*ones(N,1);%2*ones(N,1);%紐の長さ
                param.mi            = 0.800*ones(N,1)';%機体の重さ
                param.Ji            = repmat([0.082 0.082 0.1377]',1,N);%機体の慣性モーメント
                param.additional    = []; % プロパティに無いパラメータを追加する場合
            end
            %% 牽引物
            isRegularHexagon = 0;%正六角柱の牽引物にするか
            if ~isRegularHexagon && isempty(param.rho) %sim
            %*Up, *Downは牽引物の上面と下面を表す   
            %六角形
                xUp     = [-2 -1.5 0 1.5 1 0];
                yUp     = [-1 0.5 1 0.5 -0.5 -1];
                zUp     = 0.5*ones(1,6);
                pUp     = [xUp;yUp;zUp];%*0.4;%

                xDown   = [-2 -1.5 0 1.5 1 0];
                yDown   = [-1 0.5 1 0.5 -0.5 -1];
                zDown   = -0.5*ones(1,6);
                pDown   = [xDown;yDown;zDown];%*0.4;%

            %四角形
                % xUp   = [2 -2 -2 2];
                % yUp   = [2 2 -2 -2];
                % zUp   = 0.1*ones(1,4);
                % pUp   = [xUp;yUp;zUp];%
                % xDown = [2 -2 -2 2];
                % yDown = [2 2 -2 -2];
                % zDown = -0.1*ones(1,4);
                % pDown = [xDown;yDown;zDown];%

            %牽引物形状の重心の計算
                polyin  = polyshape(pUp(1,:),pUp(2,:));
                [x,y]   = centroid(polyin);%x,y平面上の重心
                G       = [x;y;0];
                rho     = pUp-G;%重心位置から接続点までの距離
            %接続点を頂点とする図形の重心位置
                polyin  = polyshape(pUp(1,1:N),pUp(2,1:N));
                [x,y]   = centroid(polyin);%x,y平面上の重心
                Gc      = [x;y;0];
                rhoc    = pUp-Gc;%接続点を頂点とする図形の重心位置から接続点までの距離
                
            %紐の接続点が牽引物の頂点と違う場合はここで設定
                %四角形
                % xUp = [2 0 -2 0];
                % yUp = [0 2 0 -2];
                % zUp = 0.1*ones(1,4);
                % rho = [xUp;yUp;zUp]-G;

                param.rho   = rho(:,1:N);
                param.rhoc  = rhoc(:,1:N);
                param.rhoini= rho(:,1:N);
                param.pUp   = pUp;
                param.pDown = pDown;
                param.G     = G;
            %plot payload shape
                xM = pUp(1,:); 
                yM = pUp(2,:); 
                zM = pUp(3,:); 
                xm = pDown(1,:); 
                ym = pDown(2,:); 
                zm = pDown(3,:); 
                
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
                xlabel('$x$ (m)','Interpreter','latex')
                ylabel('$y$ (m)','Interpreter','latex')
                zlabel('$z$ (m)','Interpreter','latex')
                
                input("Confirm the figure and press Enter.")%enter keyを押すまでプログラムを止める
                close
            elseif isempty(param.rho)
            %正六角形
                if contains(type,"zup")
                  rho0 = [0;0;1/4];
                elseif isempty(param.rho)
                  rho0 = [0;0;-1/4];
                end
              %回転行列を求める
              R = Rodrigues([0;0;1],2*pi/N);
              %牽引物の重心位置からリンクまでの距離
              param.rho = rho0+[[1;0;0],double(cellmatfun(@(A,~) A*[1;0;0], FoldList(@(A,B) A*B,cellrepmat(R,1,N-1),{eye(3)},"mat"),"mat"))];
            end
            % simの際はparamのfieldの最初からの並びが g, m0, J0, rho, li, mi, Ji,...とする（plantの複数機牽引のmodelの関数に入れる際にこの並びである必要があるため）
            obj = obj@PARAMETER_CLASS(name,type,param);
            obj.N = N;
        end
    end

end