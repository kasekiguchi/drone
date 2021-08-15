%% explanation
% For multi-agent simulation
% 実装を考えると１エージェントづつ処理を記述するべきであるが，
% シミュレーション効率を考えるとまとめて処理した方が圧倒的に高速となる．
% このファイルでは高速化を意図してマルチエージェントシミュレーションを
% まとめる例とする．

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
Il = 3; % length of I
h = 0.999; % extinction probability
%% environment definition
[E,W] = make_grid_graph(nx,ny,@(x,y)0.9*ones(size(x))); % flat weight 
% [E,W] = make_grid_graph(nx,ny,@(x,y)rand(size(x))); % random weight
% cx = 20;cy = 30; % biased weight
% [E,W] = make_grid_graph(nx,ny,@(x,y)(-abs(x-cx).^(1.1)+1.3*max(cx,nx-cx)^(1.1)).*(-abs(y-cy).^(1.1)+1.3*max(cy,ny-cy)^(1.1)));
% [E,W] = make_grid_graph(nx,ny,@(x,y) 1.3*max(cx,nx-cx)^(1.1)*1.3*max(cy,ny-cy)^(1.1)*rand(size(x))+(-abs(x-cx).^(1.1)+1.3*max(cx,nx-cx)^(1.1)).*(-abs(y-cy).^(1.1)+1.3*max(cy,ny-cy)^(1.1)));
%[i,j,v]=find(E);
%G=digraph(i,j,v); % グラフ構造は自明なので描画するメリットはなさそう．
%% model definition
map = SIR_model(N,Il,h);
 init_fx=(floor(nx/2)+20:floor(nx/2)+30)';
 init_fy=floor(ny/2)+20:floor(ny/2)+25;
%  init_fx=(floor(nx/2)-30:floor(nx/2)-20)';
%  init_fy=floor(ny/2)-25:floor(ny/2)-20;
% init_fx=(floor(nx/2):floor(nx/2))';
% init_fy=floor(ny/2):floor(ny/2);
init_I = zeros(N,1);
init_I(ny*(init_fx-1)+init_fy) = 1;
init_R = zeros(N,1);
map.init(init_I,init_R);
%map.draw_state(nx,ny);
%% simulation
map.draw_state(nx,ny,W);
unum = 10; % 消火点の数
ke = 50;
%% 燃えやすいセルを消していく場合
clear logger
u = zeros(N,1);%初期化
logger.k=zeros(1,ke);
logger.S(:,1) = map.S(:);
logger.I(:,1) = map.I(:);
logger.R(:,1) = map.R(:);
logger.u(:,1) = map.u(:);
for k = 1:ke
    FI= find(map.I);% 燃えているマップのインデックス
    tmpW= W(FI);% 燃えているマップの重要度
    for iu=1:unum
        [~,I]= max(tmpW,[],'all','linear');
        u(FI(I))=1;
        tmpW(I)=0;
    end
    %profile on
    map.next_step_func(u,E);
    u = zeros(N,1);%初期化
    logger.k(k)=k;
    k
    %profile viewer
    logger.S(:,k) = map.S(:);
    logger.I(:,k) = map.I(:);
    logger.R(:,k) = map.R(:);
    logger.u(:,k) = map.u(:);
end

%% Alt Page Rankが高いセルを消していく場合
clear logger
u = zeros(N,1);%初期化
logger.k=zeros(1,ke);
logger.S(:,1) = map.S(:);
logger.I(:,1) = map.I(:);
logger.R(:,1) = map.R(:);
logger.u(:,1) = map.u(:);

%D=spdiags(sum(E,2),0,N,N);

% なぜか性能が良い　：同じランクの時に数値計算誤差レベルの差でたまたま選ばれる点が良い結果を生む？
 D=sum(E,2);
 L = speye(size(E)) - E./D;
 [V,Eig]=eigs(L',1,'smallestabs'); % V : alt page rank

% 重み拡張したもの
% L = speye(size(E)) - E/eigs(E,1);
% [V,Eig]=eigs(L',1,'smallestabs'); % V : alt page rank
% わざわざL を使わなくても最大固有値で割ることで1が最大固有値であることが保証できる
% しかし，数値的にはLを使った方が良いrankが得られる．
% V, V2 に対し min(L'*V)， max(L'*V)，min(E'*V-eigs(E,1)*V)，
% max(E'*V-eigs(E,1)*V)の値をそれぞれ計算するとVの方が０に近い値が求まる．
% [V2,Eig2]=eigs(E'/eigs(E,1),1); % V : alt page rank
 %[V,Eig]=eigs(E'/eigs(E,1),1); % V : alt page rank
Eig % eigenvalue must be 0 : alt page rank は０固有値に対応した左固有ベクトル
for k = 1:ke
    FI= find(map.I);% 燃えているマップのインデックス
    tmpW = V(FI);% 燃えているマップの重要度
    for iu=1:unum
        [~,I]= max(tmpW);
        u(FI(I))=1;
        tmpW(I)=Vm;
    end
    %profile on
    map.next_step_func(u,E);
    logger.k(k)=k;
    k
    %profile viewer
    logger.S(:,k) = map.S(:);
    logger.I(:,k) = map.I(:);
    logger.R(:,k) = map.R(:);
    logger.u(:,k) = map.u(:);
    u = zeros(N,1);%初期化
end

%% graphs
map.draw_state(nx,ny);

%% animations
%map.draw_movie(logger,nx,ny,1,"Extinct_high_weighted_grid_random");
%map.draw_movie(logger,nx,ny,1,"Extinct_alt_page_rank_random");
M=map.draw_movie(logger,nx,ny,2);

%% 消火エージェント考慮


