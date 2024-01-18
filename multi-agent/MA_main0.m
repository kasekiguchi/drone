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
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');
cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
%%
close all
% TODO 
% gen_grid_weight のマップ欠損の補間
% model_init の出火点設定
% 延焼パラメータ
% 60-70 m/hour となるようにチューニング
% time_scale step/hour
% prob grid/step
% map_scale m/grid
% map_scale*time_scale*prob = 60-70

% 飛び火パラメータ
% 発生確率 ：糸魚川市のデータで初期消火無しでMCシミュレーションをやり、9-12回発生する程度の頻度
% 距離、形状：糸魚川市のデータに10m/s の風速の時の飛び火距離情報ある。左右に散るのを表現するためひし形に設定
% https://www.jstage.jst.go.jp/article/aijsaxx/62/0/62_KJ00004442864/_article/-char/ja/

% S = shaperead('20160401-建築物の外周線.shp');
% S = shaperead('building_15216.dbf');
flag.wind_average = 1;
flag.debug = 1;
flag.ns = [0.07,0.3,2.4];
flag.nf = [0.075,1.2,1.5];

% shape_opts.start_point = [0,0]; % マップ左下から見た位置 [m,m]
% shape_opts.map_size = [1,1000]; % north_dir で回転した後の start_pointからの領域 [m m]
% shape_opts.data_type = "m";
% shape_opts.north_dir = 0; % rad
% M = FIELD_MAP('data_ito.csv','flat_shape.shp',flag,[],struct("start_point",start_point,"map_size",map_size,"data_type","m","north_dir",north_dir));

shape_file = '20160401/20160401-建築物の外周線.shp';
wind_data = 'data_ito.csv';
unum = 1; % 初期の消火点の数（10機のUAV）
step_end = 240; % シミュレーションステップ
shape_opts.start_point = [670,230]; % マップ左下から見た位置 [m,m]
shape_opts.map_size = [300,300]; % north_dir で回転した後の start_pointからの領域 [m m]
shape_opts.data_type = "m";
shape_opts.north_dir = -12*(pi/180); % rad

M = FIELD_MAP(flag,shape_file,shape_opts,[]);
M.set_target();
M.setup_wind(wind_data);
M.set_gridcell_model();
% W_data = "W_building_13112.mat";
% M = FIELD_MAP('data_ito.csv','shape_share20221014/building_13112.shp',flag,W);
%%
%W = M.W;
%save("W_building_13112.mat","W");
%% Monte-Carlo simulation
% 90min =~ 30step
addFirePoint = "Regular";   % Regularで手動糸魚川，testでチューニング
addFighter = "ON3"; % OFFは増援0，ON1はざっくり上昇，ON2は糸魚川時のポンプ数に対応
kn = 1;% number of Monte-Carlo simulation
% 手法選択
% fMethod = "WAPR"; % Weighted Alt Page Rank
% fMethod = "APR"; % Alt Page Rank
fMethod = "Weight"; % 重み行列
% fDynamics = "Astar"; % 消火方法：A star or Direct
fDynamics = "Direct"; % 消火方法：A star or Direct
vi = 5; % 消火の必要がない部分を飛ばす距離
h = 0.1; %0.1 * (3/M.map_scale); % extinction probability　消火確率は0.1で設定
%map.draw_state(nx,ny,map.loggerk(logger,step_end));
if addFirePoint == "test"
    fFPosition = 0;
elseif addFirePoint == "Manual"
    prompt1 = "初期出火点(fFPosition)のx座標を設定せよ!!!";
    init_fx=input(prompt1);
    prompt2 = "初期出火点(fFPosition)をy座標を設定せよ!!!";
    init_fy=input(prompt2);
    fFPosition(1) = init_fx; fFPosition(2) = init_fy;
elseif addFirePoint == "Regular"
    fFPosition = 6;
end
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
    X = M.W;
    Xm = min(M.W,[],'all');
    XM = max(M.W,[],'all');
else
    disp("Method Error");
end
if addFighter == "OFF"
    FF = 0;
elseif addFighter == "ON1"
    FF = 1;
elseif addFighter == "ON2"
    FF = 2;
elseif addFighter == "ON3"
    FF = 3;
else
    disp("Unum Error");
end
w2 = 1/((XM-Xm)/max(M.nx,M.ny));

%% monte carlo simulation
W_vec = reshape(M.W,M.N,1);
step_end = 240; % simulation step length
for k = 1:kn
    k
    M.model_init(fFPosition,W_vec);% initialize
    M.I
    [K(k),Logger(k)] = M.Astar_SIR(step_end,h,unum,X,Xm,vi,1,w2); % simulation
    K(k);
end
%%
result = statistic_summary(Logger);
total_damage(result);
time_response(Logger,1);
R_response_MC(Logger,kn);
%frequency_map(Logger);
%flying_fire_statistic(Logger);
i = 1;
stepP = 20;%final_step(i)
figure('Position', [0 -500 1100 1000]);
M.draw_movie(Logger(1),0);% 1,"230725_風情報細分化シミュレーション");  % output movie file
%%
M.draw_state(M.loggerk(Logger,1));% 1,"230725_風情報細分化シミュレーション");  % output movie file
