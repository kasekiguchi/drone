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
ke = 300; % シミュレーションステップ
fFPosition = 6; % flag fire position
h = 0; % extinction probability
W_vec = reshape(W,N,1);
map = model_init(N,Il,h,nx,ny,fFPosition,W_vec);
%%
clear logger
logger.k=zeros(1,ke);
logger.S(:,1) = map.S(:);
logger.I(:,1) = map.I(:);
logger.R(:,1) = map.R(:);
logger.U(:,1) = map.U(:);

for k = 1:ke
    map.next_step_func(0,E);% map 更新
    k
    % log
    logger.k(k)=k;
    logger.S(:,k) = map.S(:);
    logger.I(:,k) = map.I(:);
    logger.R(:,k) = map.R(:);
    logger.U(:,k) = map.U(:);
end
%% graphs
%map.draw_state(nx,ny,map.loggerk(logger,1));
% nx = 100; %実際のマップ上での表示範囲
% ny = 100; %実際のマップ上での表示範囲
map.draw_state(nx,ny,W);
%% animations

 map.draw_movie(logger,nx,ny,1,"2021Dec13_延焼_3-4セル拡張版_微風Ver2");    %natural_expansion
%map.draw_movie(logger,nx,ny,1,"Extinct_alt_page_rank_random");
%M=map.draw_movie(logger,nx,ny,2);
%map.draw_movie(logger,nx,ny,1,"Extinct_APR_Astar_BiasRandom");
%map.draw_movie(logger,nx,ny,1,"Extinct_Weight_Astar_BiasRandom");

%% Monte-Carlo simulation
unum = 10; % 消火点の数
ke = 300; % シミュレーションステップ
kn = 100;% number of Monte-Carlo simulation
% 手法選択
fMethod = "WAPR"; % Weighted Alt Page Rank
%fMethod = "APR"; % Alt Page Rank
%fMethod = "Weight"; % 重み行列
fDynamics = "Astar"; % 消火方法：A star or Direct
%fDynamics = "Direct"; % 消火方法：A star or Direct
vi = 5; % 消火の必要がない部分を飛ばす距離
%map.draw_state(nx,ny,map.loggerk(logger,ke));
fFPosition = 0;
h = 0.9;
clear Logger

if fMethod=="WAPR"
    % 重み拡張したもの
    L = speye(size(E)) - E/eigs(E,1);
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
else
    % 重みに従う場合
    X = W;
    Xm = min(W,[],'all');
    XM = max(W,[],'all');
end
w2 = 1/((XM-Xm)/max(nx,ny))
%% MC simulation
for k = 1:kn
    k;
    map = model_init(N,Il,h,nx,ny,fFPosition,W_vec);% initialize
    [K(k),Logger(k)] = Astar_SIR(N,ke,nxr,nyr,map,unum,E,X,Xm,Il,vi,1,w2,fDynamics); % simulation
    K(k)
end
%%
tmp=[];
for i = 1:100
tmp(i)=sum(Logger(i).R(:,end));
end
sum(tmp)/100
sum(K>300)
%% MCの平均時間遷移グラフ
log = Logger3;
logk = K3;
ke = 300;
for i = 1:ke
    I = find(logk>i);
    II = find(logk<=i);
    tmpS(i) = 0;
    tmpR(i) = 0;
    tmpU(i) = 0;
    for j = II
        log(j).S(:,i) = log(j).S(:,i-1);
        log(j).R(:,i) = log(j).R(:,i-1);
        log(j).U(:,i) = log(j).U(:,i-1);
    end
    for j = 1:100
        tmpS(i)=tmpS(i)+sum(log(j).S(:,i));
        tmpR(i)=tmpR(i)+sum(log(j).R(:,i));
        tmpU(i)=tmpU(i)+sum(log(j).U(:,i));
    end
    tmpS(i) = tmpS(i)/100;
    tmpR(i) = tmpR(i)/100;
    tmpU(i) = tmpU(i)/100;
    tmpI(i)=10000-tmpS(i)-tmpR(i);
end
%%
% tmpS= sum(logger.S);
% tmpR= sum(logger.R);
% tmpI= 10000-tmpS-tmpR;
%%
plot(1:ke,tmpS,'--g','LineWidth',5);
hold on 
plot(1:ke,tmpI,'-.r','LineWidth',5);
plot(1:ke,tmpR,'Color',[0.2 0.2 0.2],'LineWidth',5);
legend('N','F','E');
 xlabel('\sl Time step k','FontSize',25);
            ylabel('\sl Number','FontSize',25);
            set(gca,'FontSize',20);
            ax = gca;
            ax.Box = 'on';
hold off
%%
sum(K>300)
SIR_model.save('Logger_APR_ver0_Astar_100_30_09_004_10_5_1_w2.mat',Logger);
SIR_model.save('K_APR_ver0_Astar_100_30_09_004_10_5_1_w2.mat',K);
% SIR_model.save('Logger_APR_Astar_100_30_09_004_10_5.mat',Logger);
% SIR_model.save('K_APR_Astar_100_30_09_004_10_5.mat',K);
%%
Logger1=SIR_model.load('Logger_WAPR_ver0_Astar_100_30_09_004_10_5_1_w2.mat');
K1 = SIR_model.load('K_WAPR_ver0_Astar_100_30_09_004_10_5_1_w2.mat');
Logger2=SIR_model.load('Logger_W_ver0_Astar_100_30_09_004_10_5_1_w2.mat');
K2 = SIR_model.load('K_W_ver0_Astar_100_30_09_004_10_5_1_w2.mat');
Logger3=SIR_model.load('Logger_APR_ver0_Astar_100_30_09_004_10_5_1_w2.mat');
K3 = SIR_model.load('K_APR_ver0_Astar_100_30_09_004_10_5_1_w2.mat');
%M=SIR_model.draw_movie(Logger(2),nx,ny,2);
%tt=SIR_model.load('Logger_APR_Astar_100_30_09_004_10_5.mat')
%%
map.draw_state(nx,ny,reshape(V,[nx,ny]))
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
init_I(ny*(init_fx-1)+init_fy+r) = 1.*W_vec2(ny*(init_fx-1)+init_fy+r);   %Advice:Wを10000の行列に変換し、1にかければいいのでは？
% init_I(ny*(init_fx-1)+init_fy+r) = 1;   %Advice:Wを10000の行列に変換し、1にかければいいのでは？
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
E1 = E>0;
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
            path = aster(p(i),t(pt(i)),E1,@(c,t)grid_distance(c,t,nx,ny),@(Z) performance(X,Xm,map.I,Z),w1,w2);
            % path : A starで求めたp(i)からt(pt(i))へのpathのインデックス配列
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