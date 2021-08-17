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
% 例 p = [3,5]'; と S = [0,0,1,0,1,0,0,0]';はどちらも2x3grid上の(1,2)と(1,3)を表す．
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
nx = 100; % x axis grid number
ny = 100; % y axis grid number
N = nx*ny; % total grid number
Il = 30; % length of I
h = 0.999; % extinction probability
%% environment definition
%[E,W] = make_grid_graph(nx,ny,@(x,y)0.1*ones(size(x))); % flat weight
% [E,W] = make_grid_graph(nx,ny,@(x,y)rand(size(x)),0.07); % random weight
cx = 80;cy = 80; % biased weight
[E,W] = make_grid_graph(nx,ny,@(x,y) 1.3*max(cx,nx-cx)^(1.1)*1.3*max(cy,ny-cy)^(1.1)*(0.6+0.4*rand(size(x)))+(-abs(x-cx).^(1.1)+1.3*max(cx,nx-cx)^(1.1)).*(-abs(y-cy).^(1.1)+1.3*max(cy,ny-cy)^(1.1)),0.04);
%[i,j,v]=find(E);
%G=digraph(i,j,v); % グラフ構造は自明なので描画するメリットはなさそう．
%% simulation setting
%map.draw_state(nx,ny,W);
unum = 10; % 消火点の数
ke = 200; % シミュレーションステップ
% 手法選択
fMethod = "APR"; % Alt Page Rank
%fMethod = "Weight"; % 重み行列
map = model_init(N,Il,h,nx,ny,fFPosition);
%% Targetを直接消火
clear logger
logger.k=zeros(1,ke);
logger.S(:,1) = map.S(:);
logger.I(:,1) = map.I(:);
logger.R(:,1) = map.R(:);
logger.U(:,1) = map.U(:);

% 重み拡張したもの
L = speye(size(E)) - E/eigs(E,1);
%[V,Eig,Flag]=eigs(L',1,'smallestabs','Tolerance',1e-20); % V : alt page rank
[V,Eig,Flag]=eigs(L',1,'smallestabs'); % V : alt page rank
% わざわざL を使わなくても最大固有値で割ることで1が最大固有値であることが保証できる
% しかし，数値的にはLを使った方が良いrankが得られる．
% V, V2 に対し min(L'*V)， max(L'*V)，min(E'*V-eigs(E,1)*V)，
% max(E'*V-eigs(E,1)*V)の値をそれぞれ計算するとVの方が０に近い値が求まる．
[V2,Eig2,Flag2]=eigs(E'/eigs(E,1),1,'largestreal','Tolerance',1e-20); % V : alt page rank
%[V,Eig]=eigs(E'/eigs(E,1),1); % V : alt page rank
Eig % eigenvalue must be 0 : alt page rank は０固有値に対応した左固有ベクトル
1-Eig2

% if abs(Eig) > abs(1-Eig2)% 精度の良い方を採用 Case
% 4など初期火災位置によって結果が違うので，それには対応できない．．．
%  %   V = V2;
%     disp("E'/eigs(E,1)を採用");
%     pause(0.5);
% end
V=V2;
if fMethod=="APR"
    % alt page rank に従う場合
    X = V;
    Xm = min(V);% 最低のrank
else
    % 重みに従う場合
    X = W;
    Xm = min(W,[],'all');
end

for k = 1:ke
    fi= find(map.I);% 燃えているマップのインデックス
    tmpX = X(fi)+(Il-map.I(fi));% 燃えているマップの重要度：X = V, Wどちらでも縦ベクトルになる．
    
    % target point t 選択：重要度の高い順にtunum個選択
    tunum = min(unum,length(fi));
    u = zeros(tunum,1);% extinguish input indices
    for iu=1:tunum
        [~,I]= max(tmpX);
        u(iu) = fi(I);%
        tmpX(I)=Xm;% 選択済みのものを最低rankに設定
    end
    
    %profile on
    U = sparse(u,1,1,N,1);
    map.next_step_func(U,E);% map 更新
    k % 進捗確認
    %profile viewer
    
    % log
    logger.k(k)=k;
    logger.S(:,k) = map.S(:);
    logger.I(:,k) = map.I(:);
    logger.R(:,k) = map.R(:);
    logger.U(:,k) = map.U(:);
end
%% graphs
map.draw_state(nx,ny,map.loggerk(logger,5));
%% animations
%map.draw_movie(logger,nx,ny,1,"Extinct_high_weighted_grid_random");
%map.draw_movie(logger,nx,ny,1,"Extinct_alt_page_rank_random");
M=map.draw_movie(logger,nx,ny,2);
%map.draw_movie(logger,nx,ny,1,"Extinct_APR_Astar_BiasRandom");
%map.draw_movie(logger,nx,ny,1,"Extinct_Weight_Astar_BiasRandom");

%% Simulation setting
unum = 10; % 消火点の数
ke = 200; % シミュレーションステップ
% 手法選択
fMethod = "APR"; % Alt Page Rank
%fMethod = "Weight"; % 重み行列
vi = 5; % 消火の必要がない部分を飛ばす距離
%map.draw_state(nx,ny,map.loggerk(logger,ke));
fFPosition = 0;
clear Logger
for k = 1:100   
    map = model_init(N,Il,h,nx,ny,fFPosition);
    [K(k),Logger(k)] = Astar_SIR(N,ke,nx,ny,map,unum,E,W,fMethod,Il,vi);
end
%% model init
function map = model_init(N,Il,h,nx,ny,fFPosition)
% fFPositionに応じてmap 中心から見て４象限に火災エリアの初期値配置
map = SIR_model(N,Il,h);
switch fFPosition
    case 0
        init_fx=(floor(nx/2)-5:floor(nx/2)+5)';
        init_fy=floor(ny/2)-0:floor(ny/2)+5;
    case 1
        init_fx=(floor(nx/2)+20:floor(nx/2)+30)';% Case 4 : V better
        init_fy=floor(ny/2)+20:floor(ny/2)+25;
    case 2
        init_fx=(floor(nx/2)-30:floor(nx/2)-20)';% Case 4 : V better
        init_fy=floor(ny/2)+20:floor(ny/2)+25;
    case 3
        init_fx=(floor(nx/2)-30:floor(nx/2)-20)';% Case 4 : V2 better
        init_fy=floor(ny/2)-25:floor(ny/2)-20;
    case 4
        init_fx=(floor(nx/2)+20:floor(nx/2)+30)';% Case 4 : V better
        init_fy=floor(ny/2)-25:floor(ny/2)-20;
end
init_I = zeros(N,1);
init_I(ny*(init_fx-1)+init_fy) = 1;
init_R = zeros(N,1);
map.init(init_I,init_R);
end
%% 消火エージェント考慮
function [k,logger] = Astar_SIR(N,ke,nx,ny,map,unum,E,W,fMethod,Il,vi)
logger.k=zeros(1,ke);
logger.S(:,1) = map.S(:);
logger.I(:,1) = map.I(:);
logger.R(:,1) = map.R(:);
logger.U(:,1) = map.U(:);
logger.P = sparse(N,ke);
p = arranged_position([10,10],unum,2,0);
p = (p(1,:)'-1)*ny + p(2,:)';% init position indices
E1 = E>0;
pt = zeros(unum,1);

% 重み拡張したもの
L = speye(size(E)) - E/eigs(E,1);
[V,Eig,Flag]=eigs(L',1,'smallestabs','Tolerance',1e-20); % V : alt page rank
[V2,Eig2,Flag2]=eigs(E'/eigs(E,1),1,'largestreal','Tolerance',1e-20); % V : alt page rank
%V=V2;
if fMethod=="APR"
    % alt page rank に従う場合
    X = V;
    Xm = min(V);% 最低のrank
else
    % 重みに従う場合
    X = W;
    Xm = min(W,[],'all');
end
k = 1;
while (k <= ke) & sum(find(map.I))
    fi= find(map.I);% 燃えているマップのインデックス
    
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
        path = aster(p(i),t(pt(i)),E1,@(c,t)grid_distance(c,t,nx,ny),@(Z) performance(X,Xm,map.I,Z),1,1);
        % path : A starで求めたp(i)からt(pt(i))へのpathのインデックス配列
        logger.P(:,k) = logger.P(:,k) | sparse(path,1,1,N,1);
        u(i) = path(1);% 実際の消化点
        if length(path)>1
            p(i) = path(min(vi,find(sum(fi'==path,2),1)));% 次時刻の位置 viより近い燃えている点
        end
    end
    
    U = sparse(u,1,1,N,1);
    map.next_step_func(U,E);% map 更新
    k % 進捗確認
    
    % log
    logger.k(k)=k;
    logger.S(:,k) = map.S(:);
    logger.I(:,k) = map.I(:);
    logger.R(:,k) = map.R(:);
    logger.U(:,k) = map.U(:);
    k = k+1;
end
end
%% local function
function O = performance(V,minV,I,X)
% V > 1
% I : burning cell = 1
% X : focused cell = 1
N = size(V,1);
xi = find(I & X);
x = find(X);
for i = 1:length(x)
    if intersect(x(i),xi)
        O(i,1)=  1-V(intersect(x(i),xi));
    else
        O(i,1)=1-minV;
    end
end
end