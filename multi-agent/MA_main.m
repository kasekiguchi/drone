%% explanation
% For multi-agent simulation
% 実装を考えると１エージェントづつ処理を記述するべきであるが，
% シミュレーション効率を考えるとまとめて処理した方が圧倒的に高速となる．
% このファイルでは高速化を意図してマルチエージェントシミュレーションを
% まとめる例とする．

% 記号ルール
% nx-ny gridの位置を表すのにlinear indexと (row, column) subscript の2通りがある．
% 例：2x3 gridの場合
%    linear index 3 は(1,2)に対応
% linear index についてind2sub, sub2indで慣れておくこと

% linear index を使ったgrid位置を表す表記として以下を用いる
% linear index配列 には小文字を使う：p の各値がgrid上の位置
% 0,1の縦ベクトルで表現する場合は大文字：S としたとき，s = find(S) の各値がgrid上の位置
% 例 p = [3,5]'; と S = [0,0,1,0,1,0,0,0]';はどちらも2x3 grid上の(1,2)と(1,3)を表す．
% s = find(S)や S(s) = 1 などは意味を持つ
%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
cd('..');
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');
cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
%% configuration
nx = 130; % x axis grid number
ny = 130; % y axis grid number
N = nx*ny; % total grid number
Il = 30; % length of I
nx_app = 100; % 見かけ上のx辺
ny_app = 100; % 見かけ上のy辺
%% environment definition
%[E,W] = make_grid_graph(nx,ny,@(x,y)0.1*ones(size(x))); % flat weight
%[E,W] = make_grid_graph(nx,ny,@(x,y)0.01*[1:size(x,2)]'.^2.*ones(size(x)),1); % flat weight
%[E,W] = make_grid_graph(nx,ny,@(x,y)rand(size(x)),0.07); % random weight
 cx = 80;cy = 80; % biased weight
 % sum(W9,2)で割るときは0.3程度，割らないときは0.04程度が適正? 0.3でも良さそう
%  pi = 2;
%  gi = 1.3;
  pi = 1;
  gi = 0.8;
%  [E,E2,W] = make_grid_graph(nx,ny,@(x,y) gi*max(cx,nx-cx)^(pi)*gi*max(cy,ny-cy)^(pi)*(0.3+0.2*rand(size(x)))+(-abs(x-cx).^(pi)+gi*max(cx,nx-cx)^(pi)).*(-abs(y-cy).^(pi)+gi*max(cy,ny-cy)^(pi)),0.04);
 [E,E2,W] = make_grid_graph(nx,ny,0.01,0.04);
 %[i,j,v]=find(E);
%G=digraph(i,j,v); % グラフ構造は自明なので描画するメリットはなさそう．
%figure()
if find(W<0)
    disp("不適切な重み");
    map.draw_state(nx,ny,W);
else
    disp("OK");
end
%%
   L = speye(size(E)) - E/eigs(E,1);
    [V,Eig,Flag]=eigs(L',1,'smallestabs','Tolerance',1e-20); % V : alt page rank
    %[V2,Eig2,Flag2]=eigs(E'/eigs(E,1),1,'largestreal','Tolerance',1e-20);
    %map.draw_state(nx,ny,reshape(V,[nx,ny]));% V2だとAPRが負になることがある．Vの方が数値的に安定そう．符号自由度についてはVの方が悪そうなのになぜだろう？
%% 消火しない場合の燃え広がり方 (h = 0)
% 200ステップで端に行かない程度の重みがAstar でやる場合適切
% Directでやる場合はもっと早い燃え広がりでも対応可能
ken = 200; % シミュレーションステップ ke_natural
fFPosition = 6; % flag fire position
h = 0; % extinction probability
map_extra = nx * ny - nx_app * ny_app ;     %見えない部分の総セル数
W_vec = reshape(W,N,1);
map = model_init(N,Il,h,nx,ny,fFPosition,W_vec);
%%
clear logger
logger.k=zeros(1,ken);
logger.S(:,1) = map.S(:);
logger.I(:,1) = map.I(:);
logger.R(:,1) = map.R(:);
logger.U(:,1) = map.U(:);

for k = 1:ken
    map.next_step_func(0,E);% map 更新
    % log
    k
    logger.k(k)=k;
    logger.S(:,k) = map.S(:);
    logger.I(:,k) = map.I(:);
    logger.R(:,k) = map.R(:);
    logger.U(:,k) = map.U(:);
    %手動設定[飛び火＆長距離延焼]
%     if k == 23      %11:21
%         tbh1 = nx*56 + 48;
%         map.I(tbh1) =1 ;
%     end
%     if k == 42      %11:58
%         tbh2 = nx*34 + 56;
%         map.I(tbh2) =1 ;
%     end
%     if k == 50      %12:14
%         tbh3 = nx*30 + 73;
%         map.I(tbh3) =1 ;
%     end
%     if k == 68      %12:49
%         tbh4 = nx*70 + 48;
%         map.I(tbh4) =1 ;
%     end
%     if k == 74      %13:00
%         tbh5 = nx*69 + 89;
%         map.I(tbh5) =1 ;
%     end
%     if k == 87      %13:26
%         tbh6 = nx*78 + 58;
%         map.I(tbh6) =1 ;
%     end
%     if k == 89      %13:30  道路を跨いだ長距離延焼
%         ens = nx*33 + 90;
%         map.I(ens) =1 ;
%     end
%     if k == 97      %13:45
%         tbh7 = nx*39 + 47;
%         map.I(tbh7) =1 ;
%     end
%     if k == 108      %14:07
%         tbh8 = nx*81 + 50;
%         map.I(tbh8) =1 ;
%     end
%     if k == 116      %14:24
%         tbh9 = nx*24 + 95;
%         map.I(tbh9) =1 ;
%     end
%     if k == 151      %15:33
%         tbh10 = nx*25 + 85;
%         map.I(tbh10) =1 ;
%     end
%     if k == 78      %13:07
%         tbh11 = nx*54 + 56;
%         map.I(tbh11) =1 ;
%     end
%     if k == 79      %13:08
%         tbh12 = nx*64 + 64;
%         map.I(tbh12) =1 ;
%     end
%     if k == 90      %13:31
%         tbh13 = nx*71 + 70;
%         map.I(tbh13) =1 ;
%     end
%     if k == 90      %13:31
%         tbh14 = nx*70 + 81;
%         map.I(tbh14) =1 ;
%     end
%     if k == 97      %13:44
%         tbh15 = nx*78 + 65;
%         map.I(tbh15) =1 ;
%     end
end
%% graphs
% map.draw_state(nx,ny,map.loggerk(logger,10));  %loggerk内の数字は何ステップ目の状態化を表す
% nx=100, ny=100 でマップ上に表示
map.draw_state(nx,ny,W)
%% animations
% map.draw_movie(logger,nx,ny,1);
map.draw_movie(logger,nx,ny,1,"2022Feb23_Natural_Log44");    %natural_expansion 
%map.draw_movie(logger,nx,ny,1,"Extinct_alt_page_rank_random");
%M=map.draw_movie(logger,nx,ny,2);
%map.draw_movie(logger,nx,ny,1,"Extinct_APR_Astar_BiasRandom");
%%
% map.save('Logger_Feb24_Natural_Log1.mat',logger); %logger保存
%% plot
tmp1=[];
logger.I2 = logical (logger.I)
for i = 1:ken
    tmpS(i)=sum(logger.S(:,i))-map_extra; %logger(i)内にあるRの200s時(ken)の値の合計
    tmpI(i)=sum(logger.I2(:,i)); %logger(i)内にあるRの200s時(ken)の値の合計
    tmpR(i)=sum(logger.R(:,i)); %logger(i)内にあるRの200s時(ken)の値の合計
end
damage_cell = tmpR(ken)+tmpI(ken)   %被害セル数
%%
figure(1)
plot(1:ken,tmpS,'-g','LineWidth',2);
hold on 
plot(1:ken,tmpI,'-b','LineWidth',2);
plot(1:ken,tmpR,'-r','LineWidth',2);
legend('S','I','R');
xlabel('\sl Time step k','FontSize',20);
ylabel('\sl Number','FontSize',20);
set(gca,'FontSize',10);
ax = gca;
ax.Box = 'on';
xlim([0 ken]);
ylim([0 nx_app * ny_app]);
hold off
%% Monte-Carlo simulation
unum = 15; % 消火点の数（10機のUAV）
ke = 200; % シミュレーションステップ
kn = 1;% number of Monte-Carlo simulation
% 手法選択
fMethod = "WAPR"; % Weighted Alt Page Rank
% fMethod = "APR"; % Alt Page Rank
% fMethod = "Weight"; % 重み行列
% fDynamics = "Astar"; % 消火方法：A star or Direct
fDynamics = "Direct"; % 消火方法：A star or Direct
vi = 5; % 消火の必要がない部分を飛ばす距離
%map.draw_state(nx,ny,map.loggerk(logger,ke));
fFPosition = 6;
h = 0.1; % extinction probability
clear Logger

if fMethod=="WAPR"
    % 重み拡張したもの
    L = speye(size(E)) - E/eigs(E,1);   %size(E)=(n,m)のときEはn行m列 / eigs(E,1)はEの最も大きい固有値1個
    [V,Eig,Flag]=eigs(L',1,'smallestabs','Tolerance',1e-20); % V : alt page rank
    %[V2,Eig2,Flag2]=eigs(E'/eigs(E,1),1,'largestreal','Tolerance',1e-20); % V : alt page rank
    %V=V2;
    % alt page rank に従う場合
    X = V;
    Xm = min(0,min(V));% 最低のrank
    XM = max(V);% 最高のrank
elseif fMethod == "APR"
    % 重み拡張したもの
    L = speye(size(E2)) - E2;
    [V,Eig,Flag]=eigs(L',1,'smallestabs','Tolerance',1e-20); % V : alt page rank
    %[V2,Eig2,Flag2]=eigs(E'/eigs(E,1),1,'largestreal','Tolerance',1e-20); % V : alt page rank
    %V=V2;
    % alt page rank に従う場合
    X = V;
    Xm = min(0,min(V));% 最低のrank
    XM = max(V);% 最高のrank        
elseif fMethod == "Weight"
    % 重みに従う場合
    X = W;
    Xm = min(W,[],'all');
    XM = max(W,[],'all');
else
    disp("Method Error");
end
w2 = 1/((XM-Xm)/max(nx,ny))
V_mat = reshape(V,[nx,ny]);     %重みAPRグラフ表示のための正方行列化
map.draw_state(nx,ny,V_mat);    %重みAPRのグラフ表示
% map.draw_state(nx,ny,reshape(V,[nx,ny]))
%% MC simulation 時間かかる
for k = 1:kn
    k
    map = model_init(N,Il,h,nx,ny,fFPosition,W_vec);% initialize
    [K(k),Logger(k)] = Astar_SIR(N,ke,nx,ny,map,unum,E,X,Xm,Il,vi,1,w2,fDynamics); % simulation
    K(k);
end
%% %%% 違法増築1 Logデータの保存
map.save('Logger_Feb23_WAPR_Direct_unum15_vi5_h0.1_Log1.mat',Logger);
% map.save('K_Feb22_WAPR_Direct_unum15_vi5_h0.1_Log2.mat',K);
%% %%% 違法増築2 動画の生成と保存
% Logger2=map.load('Logger_APR_Astar_100_30_09_004_10_5.mat');
% K2 = map.load('K_APR_Astar_100_30_09_004_10_5.mat');
% md = map.draw_state(nx,ny,map.loggerk(Logger,10));    %nステップ目を画像出力
% M = map.draw_movie(Logger(1),nx,ny,1);    %動画を出力
% M=map.draw_movie(Logger(1),nx,ny,1,"2022Feb22_WAPR_Direct_unum15_kn30_vi5_h0.1_Log64");  %名前を付けて動画を出力
%% %%% 違法増築3 Logデータの読み込み
Logger=map.load('Logger_Feb22_WAPR_Direct_unum15_vi5_h0.1_Log40.mat');
%% plot 2
kre = K-1;
% kre = 200;    %Kの値は手動入力
tmpS2 = 0;
tmpI2 = 0;
tmpR2 = 0;
tmp2=[];
I2.I = logical (Logger.I)
for i = 1:kre
    tmpS2(i)=sum(Logger.S(:,i))-map_extra; %logger(i)内にあるRの200s時(ke)の値の合計
    tmpI2(i)=sum(I2.I(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
    tmpR2(i)=sum(Logger.R(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
end
damage_cell = tmpR2(kre)+tmpI2(kre)
%%
figure(2)
plot(1:kre,tmpS2,'-g','LineWidth',2);
hold on 
plot(1:kre,tmpI2,'-b','LineWidth',2);
plot(1:kre,tmpR2,'-r','LineWidth',2);
legend('S','I','R');
xlabel('\sl Time step k','FontSize',20);
ylabel('\sl Number','FontSize',20);
set(gca,'FontSize',10);
ax = gca;
ax.Box = 'on';
xlim([0 ke]);
ylim([0 nx_app * ny_app]);
hold off

disp('Plot ended')
%% END
%　ここまでが卒論mainプログラム
%
%%
%% local functions
%% model init
function map= model_init(N,Il,h,nx,ny,fFPosition,W_vec)
% fFPositionに応じてmap 中心から見て４象限に火災エリアの初期値配置
switch fFPosition
    case 0
        init_fx=(floor(nx/2)-5:floor(nx/2)+5)';
        init_fy=floor(ny/2)-0:floor(ny/2)+5;
    case 1
        init_fx=(floor(nx/2)+20:floor(nx/2)+30)';
        init_fy=floor(ny/2)+20:floor(ny/2)+25;
    case 2
        init_fx=(floor(nx/2)-30:floor(nx/2)-20)';
        init_fy=floor(ny/2)+20:floor(ny/2)+25;
    case 3
        init_fx=(floor(nx/2)-30:floor(nx/2)-20)';
        init_fy=floor(ny/2)-25:floor(ny/2)-20;
    case 4
        init_fx=(floor(nx/2)+20:floor(nx/2)+30)';
        init_fy=floor(ny/2)-25:floor(ny/2)-20;
    case 5
        init_fx=(floor(nx/2):floor(nx/2)+4)';
        init_fy=floor(1):floor(1)+2;
    case 6
        init_fx=50;
        init_fy=10;
end
init_I = sparse(N,1);
% r=randi(20,numel(init_fx),numel(init_fy))-10;
r=randi(1,numel(init_fx),numel(init_fy));
W_vec2 = logical(mod(W_vec,0));     %W_vecを0と1のみのlogical値に変換．これをしないと初期引火点が何時までも消火しない
% init_I(ny*(init_fx-1)+init_fy+r) = 1;   %Advice:Wを10000の行列に変換し、1にかければいいのでは？
% init_I(ny*(init_fx-1)+init_fy+r) = 1.*W_vec2(ny*(init_fx-1)+init_fy+r);   %Wを100*100の行列に変換し、1にかけてる
init_I(ny*(init_fx-1)+init_fy) = 1.*W_vec2(ny*(init_fx-1)+init_fy);
init_R = sparse(N,1);
map = SIR_model(N,Il,h);
map.init(init_I,init_R);
end
%% Astar_SIR
function [k,logger] = Astar_SIR(N,ke,nx,ny,map,unum,E,X,Xm,Il,vi,w1,w2,fDynamics)
% simulate
% [input]
% N : number of node = nx*ny
% ke : simulation max step
% nx, ny : grid size
% map : SIR_model
% unum : number of agents
% E : graph edge
% W : node weight
% fMethod : "APR" or "Weight"
% Il : length of I state
% vi : agents skip size
% p : initial position of agents
% [output] 
% k : simulation step <= ke
% logger : simulation result
logger.k=zeros(1,ke);
logger.S(:,1) = map.S(:);
logger.I(:,1) = map.I(:);
logger.R(:,1) = map.R(:);
logger.U(:,1) = map.U(:);
logger.P = sparse(N,ke);
E1 = E>0;   %E>0となる要素のみによるlogical配列
p = arranged_position([10,10],unum,2,0);
p = (p(1,:)'-1)*ny + p(2,:)';% init position indices
pt = zeros(unum,1);

k = 1;
while (k <= ke) && sum(find(map.I))
    fi= find(map.I);% 燃えているマップのインデックス
    if fDynamics=="Direct"
        tmpX = X(fi)+(Il-map.I(fi));% 燃えているマップの重要度：X = V, Wどちらでも縦ベクトルになる．
        
        % target point t 選択：重要度の高い順にtunum個選択
        tunum = min(unum,length(fi));
        u = zeros(tunum,1);% extinguish input indices
        for iu=1:tunum
            [~,I]= max(tmpX);
            u(iu) = fi(I);%
            tmpX(I)=Xm;% 選択済みのものを最低rankに設定
        end
    else % Astar
        % target point t 選択：重要度の高い順にtunum個選択
        tunum = min(unum,length(fi)); % 燃えている部分が少なくなってきたときのケア
        if k == 1
            t = zeros(tunum,1);% target position indices
            fi2 = fi;
            lt = 0;
        else
            tI = find(map.I(t) > 0);
            t = t(tI,1);% 一度注目した点は燃え尽きるまで追いかける．
            fi2 = find(map.I&~sparse(t,1,1,N,1)); % tのcellを重複して選ばないように．
            lt = length(t);
        end
        tmpX = X(fi2)+(Il-map.I(fi2));
        % 燃えているマップの重要度：燃えはじめの方が重要度が高い
        % X = V, Wどちらでも縦ベクトルになる．
        
        u = zeros(tunum,1);% extinguish input indices
        for iu=lt+1:tunum
            [~,I]= max(tmpX);
            t(iu,1) = fi2(I);%
            tmpX(I)=Xm;% 選択済みのものを最低rankに設定
        end
        
        % 対応点選択：距離が近いものから選択
        % このあたりまだまだ改善の余地あり！target pointの選択と合わせて工夫したいところ
        Dpt = zeros(tunum);
        for j = 1:tunum
            Dpt(:,j) = grid_distance(p(j),t,nx,ny);
            % distance matrix from p to t
            % i-th row : i-th t
            % j-th col : j-th p
        end
        mD = max(Dpt,[],'all')+1;% 一番遠い距離
        for i = 1:tunum
            [~,I]=min(Dpt,[],'all','linear');
            [row,col]=ind2sub([tunum,tunum],I);% 最小距離のpとtを求める：p(col)-t(row)
            pt(col) = row;% pとtの対応を記録：p(i)とt(pt(i)) が対応
            Dpt(row,:)=mD;% 選択済みの行を全て最遠に設定
            Dpt(:,col)=mD;% 選択済みの列を全て最遠に設定
        end
        
        % A star アルゴリズム (上のfor文とくっつけられるが分けたほうが見やすそう)
        for i = 1:tunum
            c=p(i);
            path = aster(c,t(pt(i)),E1,@(c,t)grid_distance(c,t,nx,ny),@(Z) performance(X,Xm,map.I,Z),w1,w2);    %cにp(i)
            logger.P(:,k) = logger.P(:,k) | sparse(path,1,1,N,1);
            u(i) = path(1);% 実際の消化点
            if length(path)>1
                p(i) = path(min(vi,find(sum(fi'==path,2),1)));% 次時刻の位置 viより近い燃えている点
            end
        end
    end
    U = sparse(u,1,1,N,1);
    map.next_step_func(U,E);% map 更新
    %k % 進捗確認
    
    % log
    logger.k(k)=k;
    logger.S(:,k) = map.S(:);
    logger.I(:,k) = map.I(:);
    logger.R(:,k) = map.R(:);
    logger.U(:,k) = map.U(:);
    k = k+1;
end
end
%% performance
function O = performance(V,minV,I,X)
% V > 1
% I : burning cell = 1
% X : focused cell = 1
N = size(V,1);
xi = find(I & X);
x = find(X);
O = 0;
for i = 1:length(x)
    if intersect(x(i),xi)
        O(i,1) = 1-V(intersect(x(i),xi));% 1 - V(x(i));
    else
        O(i,1) = 1-minV;
    end
end
end