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
maxv = 0.04;    % 確率の上限，シミュレーションの進行に関係するパラメータであり、適当な値を入力
maptrue = 100;   % マップ直径m
meas = maptrue/100; % 縮尺換算用の関数
nx_app = 100; % 見かけ上のx辺
ny_app = 100; % 見かけ上のy辺
map_extra = nx * ny - nx_app * ny_app ;     %見えない部分の総セル数
mapd = 180;  % map difference マップ差異（風向の対応関係がマップごとに異なるため、その補正項）
build = 1;  %0で手動糸魚川、1で重み分類世田谷（秋山）、2で重み一定自動糸魚川、3で延焼調整モード（飛び火OFF）
windreal = 0;     %0で定数、1で細分化（エクセル使用）

if build == 0
    mapslope = 12;      %マップの北に対する傾き角度（例：右上が北の場合1~90）
else
    mapslope = 0;
end

%% environment definition
% % Wの生成に数時間かかるため、make_grid_graphからWのみ独立
[W] = make_grid_graph3(nx,ny,meas,build,maxv); % 推定2時間以上

%% 風向配列生成
winddata = readtable('data_ito2.csv');   % csvの読み込み

ke = 240;   % シミュレーションステップ数
firstime = 1;   % 1でExcelデータの一番上
timestage = ke/20;
csvnorm = 3;    % 使うcsv(気象情報)の何行目に風速や風向の情報が入っているかによって可変
timebase = firstime + csvnorm;

wbase(1) = {'南微西'};wbase(2) = {'南南西'};wbase(3) = {'南西微南'};wbase(4) = {'南西'};wbase(5) = {'南西微西'};wbase(6) = {'西南西'};wbase(7) = {'西微南'};wbase(8) = {'西'};
wbase(9) = {'西微北'};wbase(10) = {'西北西'};wbase(11) = {'北西微西'};wbase(12) = {'北西'};wbase(13) = {'北西微北'};wbase(14) = {'北北西'};wbase(15) = {'北微西'};wbase(16) = {'北'};
wbase(17) = {'北微東'};wbase(18) = {'北北東'};wbase(19) = {'北東微北'};wbase(20) = {'北東'};wbase(21) = {'北東微東'};wbase(22) = {'東北東'};wbase(23) = {'東微北'};wbase(24) = {'東'};
wbase(25) = {'東微南'};wbase(26) = {'東南東'};wbase(27) = {'南東微東'};wbase(28) = {'南東'};wbase(29) = {'南東微南'};wbase(30) = {'南南東'};wbase(31) = {'南微東'};wbase(32) = {'南'};

for i = 1:timestage
    wdata = table2cell(winddata(timebase+i,4));
    wind(2,i) = table2array(winddata(timebase+i,2));    % 風速の設定
    for j = 1:32
        wcheck = strcmp(wdata,wbase(j));
        if wcheck == 1
            wind(1,i) = rem(j,32)*360/32;  % 風向の設定
            break
        end
    end
    clear wdata
end

wind(1,:) = wind(1,:) + mapslope;    % マップの傾きを補正

%% 風情報
if windreal == 0
    for i = 1:timestage
        if wind(1,i) <= 180
            wind(1,i) = wind(1,i) + 360;
        end
    end
    wind1 = mean(wind(1,1:timestage)); % 平均風向
    wind2 = mean(wind(2,1:timestage));  %風速x[m/s] 無風は0.01とかに
    if build == 3
        wind1 = 0;
        wind2 = 10;
    end
    E0 = 0;
    Ee = 0;
    [E,ES,EF,E2] = make_fire_graph(nx,ny,meas,build,W,wind1,wind2,mapd,maxv);
    % % 0:南 45:南西 90:西 135:北西 180:北 225:北東 270:東 315:南東
elseif windreal == 1
    % 風情報の細分化&リアルタイム参照で使用
    clear wind1 wind2 E E2 ES EF Ee
    for i = 1:timestage
        wind1 = wind(1,i);
        wind2 = wind(2,i);
        [E,ES,EF,E2] = make_fire_graph(nx,ny,meas,build,W,wind1,wind2,mapd,maxv);
        Ee(1,i) = {ES};
        Ee(2,i) = {EF};
    %     Ee2(i) = {E2};
    end
    E0 = 1;
end


%%

 %[i,j,v]=find(E);
%G=digraph(i,j,v); % グラフ構造は自明なので描画するメリットはなさそう．
%figure()
if find(W<0)
    disp("不適切な重み");
    map.draw_state(nx,ny,W);
else
    disp("OK");
end

%% 情報保存
savefile = '240101_世田谷100m.mat';
save(savefile);
%% 情報読み込み
loadfile = '231121_糸魚川_E(細分化).mat';
load(loadfile);
%% Page-RankやAlt-Page-Rankを用いるのに利用する(つまり単純なWeightでは使わない)
   L = speye(size(E)) - E/eigs(E,1);
    [V,Eig,Flag]=eigs(L',1,'smallestabs','Tolerance',1e-20); % V : alt page rank
   L = sparse(L);
    %[V2,Eig2,Flag2]=eigs(E'/eigs(E,1),1,'largestreal','Tolerance',1e-20);
    %map.draw_state(nx,ny,reshape(V,[nx,ny]));% V2だとAPRが負になることがある．Vの方が数値的に安定そう．符号自由度についてはVの方が悪そうなのになぜだろう？

%% 手動入力飛び火(卒論で利用)
% clear logger
% logger.k=zeros(1,ken);
% logger.S(:,1) = map.S(:);
% logger.I(:,1) = map.I(:);
% logger.R(:,1) = map.R(:);
% logger.U(:,1) = map.U(:);
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

%% Monte-Carlo simulation
% 90min =~ 30step
unum = 6; % 初期の消火点の数（10機のUAV）
addFirePoint = "RegularAuto";   % Regularで手動糸魚川，testでチューニング
addFighter = "ON3"; % OFFは増援0，ON1はざっくり上昇，ON2は糸魚川時のポンプ数に対応
% ke = 300; % シミュレーションステップ
kn = 500;% number of Monte-Carlo simulation
% 手法選択
% fMethod = "WAPR"; % Weighted Alt Page Rank
% fMethod = "APR"; % Alt Page Rank
fMethod = "Weight"; % 重み行列
% fDynamics = "Astar"; % 消火方法：A star or Direct
fDynamics = "Direct"; % 消火方法：A star or Direct
vi = 5; % 消火の必要がない部分を飛ばす距離
if build == 3
    ke = 40;
    h = 0;
    addFirePoint = "test";
else
    h = 0.1 * (3/meas); % extinction probability　消火確率は0.1で設定
end
%map.draw_state(nx,ny,map.loggerk(logger,ke));
if addFirePoint == "test"
    fFPosition = 0;
elseif addFirePoint == "Manual"
    prompt1 = "初期出火点(fFPosition)のx座標を設定せよ!!!";
    init_fx=input(prompt1);
    prompt2 = "初期出火点(fFPosition)をy座標を設定せよ!!!";
    init_fy=input(prompt2);
    fFPosition(1) = init_fx; fFPosition(2) = init_fy;
elseif addFirePoint == "Regular"    %手動糸魚川の初期出火点
    fFPosition = 6;
elseif addFirePoint == "RegularAuto"    %重み一定
    fFPosition = 7;
end
W_vec = reshape(W,N,1);
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
w2 = 1/((XM-Xm)/max(nx,ny));
map = model_init(N,Il,h,nx,ny,fFPosition,W_vec);
figure('Position', [0 -500 1100 1000]);
map.draw_state(nx,ny,W)
% V_mat = reshape(V,[nx,ny]);     %重みAPRグラフ表示のための正方行列化
% map.draw_state(nx,ny,V_mat);    %重みAPRのグラフ表示
% map.draw_state(nx,ny,reshape(V,[nx,ny]))
%% MC simulation 時間かかる
for k = 1:kn
    k
    map = model_init(N,Il,h,nx,ny,fFPosition,W_vec);% initialize
    [K(k),Logger(k)] = Astar_SIR(N,ke,nx,ny,map,unum,FF,E0,E,Ee,ES,EF,X,Xm,Il,vi,1,w2,fDynamics); % simulation
    K(k);
end
%% %%% 違法増築1 Logデータの保存
% map.save('231204_Log500[240s]風細分化_M糸_Regular_ON3_W_Direct_h0.1.mat',Logger);
% map.save('K_Feb22_WAPR_Direct_unum15_vi5_h0.1_Log2.mat',K);
%% %%% 違法増築2 動画の生成と保存
% 事前必用準備：plot 2の実行
i = 277;
stepP = 20;%final_step(i)
figure('Position', [0 -500 900 1000]);
% Logger2=map.load('Logger_APR_Astar_100_30_09_004_10_5.mat');
% K2 = map.load('K_APR_Astar_100_30_09_004_10_5.mat');
md = map.draw_state(nx,ny,map.loggerk(Logger(i),stepP));    %nステップ目を画像出力
% M = map.draw_movie(Logger(1),nx,ny,0);    %動画を出力
% M=map.draw_movie(Logger(53),nx,ny,1,"230725_風情報細分化シミュレーション");  %名前を付けて動画を出力
%% %%% 違法増築3 Logデータの読み込み
Logger=map.load('230728_Log200[400s]_手動糸魚川_W_Direct_8st_h0.1_糸魚川300風細分化(32).mat');
%% plot 1　いろいろな統計データの出力項
% 消失セル数の算出
clear xi
for xi = 1:kn
    kre = size(Logger(xi).I);
    kre = kre(1,2);  %シミュレーションの最終ステップ数
    tmpS2 = 0;
    tmpI2 = 0;
    tmpR2 = 0;
    I2.I = logical (Logger(xi).I);
    for i = 1:kre
%         if kre > 200
%             kre = 200;
%         end
        tmpS2(i)=sum(Logger(xi).S(:,i))-map_extra; %logger(i)内にあるRの200s時(ke)の値の合計
        tmpI2(i)=sum(I2.I(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
        tmpR2(i)=sum(Logger(xi).R(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
    end
    final_step(xi,1) = kre;
    damage_all(xi,1) = tmpR2(kre)+tmpI2(kre);
%     figure('Position', [0 -500 1100 1000]);
%     md = map.draw_state(nx,ny,map.loggerk(Logger(xi),final_step(xi)));
end
damage_ave = round(mean(damage_all))

%% plot2
% 総被害グリッド数を計測
clear i xi

figure('Position', [0 -500 1100 1000]);
hold on
yline(damage_ave,'-r','LineWidth',3)
bar(damage_all);
hold off
%% plot3
% 特定のLOGのS,I,R遷移を出力
xi =   3   %Logの番号
kre2 = size(Logger(xi).I); kre2 = kre2(1,2);  %シミュレーションの最終ステップ数
tmpS3 = 0;
tmpI3 = 0;
tmpR3 = 0;
I2.I = logical (Logger(xi).I);
for i = 1:kre2
    tmpS3(i)=sum(Logger(xi).S(:,i))-map_extra; %logger(i)内にあるRの200s時(ke)の値の合計
    tmpI3(i)=sum(I2.I(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
    tmpR3(i)=sum(Logger(xi).R(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
end
damage_cell = tmpR3(kre2)+tmpI3(kre2)

figure(2)
plot(1:kre2,tmpS3,'-g','LineWidth',2);  %Iだけならコメントアウト
hold on 
plot(1:kre2,tmpI3,'-b','LineWidth',2);
plot(1:kre2,tmpR3,'-r','LineWidth',2);  %Iだけならコメントアウト
legend('S','I','R');  %Iだけならコメントアウト
% legend('I');        %Iだけならコメント解除
xlabel('\sl Time step k','FontSize',20);
ylabel('\sl Number','FontSize',20);
set(gca,'FontSize',10);
ax = gca;
ax.Box = 'on';
xlim([0 kre2]);
ylim([0 nx_app * ny_app * 1.0]);
hold off

disp('Plot ended')
%% plot4
% R遷移の総数
figure('Position', [0 -500 1100 1000]);
hold on 
clear xi kre
for xi = 1:kn   % nx:nx とすれば特定の回のみを見ることが出来る
    kre = size(Logger(xi).I);
    kre = kre(1,2);  %シミュレーションの最終ステップ数
    tmpR4 = 0;
    I2.I = logical (Logger(xi).I);
    for i = 1:kre
        tmpR4(i)=sum(Logger(xi).R(:,i)); %logger(i)内にあるRの200s時(ke)の値の合計
    end
    plot(1:kre,tmpR4,'-r','LineWidth',2);
%     md = map.draw_state(nx,ny,map.loggerk(Logger(xi),final_step(xi)));

end
Ftime = [10 25 35 70 85 100 120 200];
Fdame = [30 70 140 720 900 1105 1413 1841];
% Fpf = polyfit(Ftime,Fdame,4);
% x2 = 0:.1:200;
% y2 = polyval(Fpf,x2);
plot(Ftime,Fdame,'o','MarkerSize',10,'MarkerEdgeColor','b','LineWidth',2);
xlabel('\sl Time step k','FontSize',20);
ylabel('\sl Number','FontSize',20);
set(gca,'FontSize',10);
ax = gca;
ax.Box = 'on';
xlim([0 200]);
ylim([0 3000]);
hold off

%% plot5
% 飛び火の数を計測
% Logger(i).UFで(飛び火したグリッド,何ステップ目)が分かる
% [Q,R] = quorem(sym(7589),sym(130)) でQに商，Rに余り  座標(x, y) = (Q + 1, R)
% InitExting 初期消火が成功した場合の足切り
clear i xi flyP flyP1 flyP2
xi = 1; InitExting = 20;
for i = 1:kn
    flyP(i) = nnz(Logger(i).UF);
    flyP1(i,1) = flyP(i);
    if size(Logger(i).R,2) >= InitExting
        flyP2(xi,1) = flyP(i);
        flyP2(xi,2) = i;
        xi = xi + 1;
    end
end
flyPave = mean(flyP2(:,1))

figure('Position', [0 -500 1100 1000]);
hold on
% yline(flyPave,'-r','LineWidth',3)
bar(damage_all,'FaceColor',"#EDB120");
colororder({'k'})
yyaxis right
plot(flyP,"red",'LineWidth',1.5);
hold off

%% plot6
% 重み合計
% 事前必用準備：plot 2の実行
clear xi kre
InitExting = 20;    % 初期消火が成功した場合の足切り
BurnResult = 0; BurnResult2 = 0; BurnResultw = 0; BurnResult2w = 0;
for xi = 1:kn
    clear Rsigma
    Rsigma = Logger(xi).R;
    for sumW = 1:final_step(xi)-1
        Rsigma(:,1) = [];
    end
    if size(Logger(xi).R,2) >= InitExting
        BurnResultw =  BurnResultw + reshape((Rsigma),[nx,ny]);
    end
    BurnResult =  BurnResult + reshape((Rsigma),[nx,ny]);
end

clear xi kre i j
for xi = 1:kn
    clear Isigma Isigma2
    Isigma = logical(Logger(xi).I);
    for sumW = 1:final_step(xi)-1
        Isigma(:,1) = [];
    end
    if size(Logger(xi).I,2) >= InitExting
        BurnResult2w =  BurnResult2w + reshape((Isigma),[nx,ny]);
    end
    BurnResult2 =  BurnResult2 + reshape((Isigma),[nx,ny]);
end

BR0 = BurnResult + BurnResult2;
for i = 1:size(BR0,1)
    for j = 1:size(BR0,2)
        if BR0(i,j) == 0
                BR0(i,j) = BR0(i,j) - kn/5;
        end
    end
end

BR = BurnResultw + BurnResult2w;
max(BR,[],"all")
for i = 1:size(BR,1)
    for j = 1:size(BR,2)
        if BR(i,j) == 0
            BR(i,j) = BR(i,j) - kn/5;
        elseif BR(i,j) <= 0    % 特定の頻度以下を省く場合にON
            BR(i,j) = 0 - kn/5;
        end
    end
end

% figure('Position', [0 -500 1100 1000]);
% map.draw_state(nx,ny,BurnResult)
% figure('Position', [0 -500 1100 1000]);
% map.draw_state(nx,ny,BR0)
figure('Position', [0 -500 1100 1000]);
hold on
map.draw_state(nx,ny,BR)

c = colorbar;
c.TicksMode = "manual";
w = c.Ticks;
k = 25;
c.Ticks(1,1) = 1;
for i = 2:kn/k
    c.Ticks(1,i) = k * (i-1);
end

hold off



%% END
%
%%
%% local functions
%% model init
function map= model_init(N,Il,h,nx,ny,fFPosition,W_vec)
% fFPositionに応じてmap 中心から見て４象限に火災エリアの初期値配置
if numel(fFPosition) == 1
    switch fFPosition
        case 0  % build=3の場合に使用　延焼確認
            init_fx=50;
            init_fy=1;
        case 6 % 手動糸魚川
            init_fx=50;
            init_fy=11;
        case 7
            init_fx=54;
            init_fy=10;
        case 8
            init_fx=28;
            init_fy=8;
        case 9 % 世田谷500m南西
            init_fx=17;
            init_fy=3;
        case 10 % 世田谷500m南東
            init_fx=71;
            init_fy=2;
        case 11 % 世田谷500m北東
            init_fx=91;
            init_fy=92;
        case 12 % 世田谷500m北東中
            init_fx=66;
            init_fy=86;
        case 13 % 世田谷500m北東下
            init_fx=62;
            init_fy=66;
        case 14 % 世田谷300m北東下
            init_fx=35;
            init_fy=42;
        case 15 % 世田谷300m北東
            init_fx=85;
            init_fy=85;
        case 16 % 世田谷300m北東中
            init_fx=42;
            init_fy=77;
    end
elseif numel(fFPosition) == 2
    init_fx = fFPosition(1);
    init_fy = fFPosition(2);
else
    disp("初期出火点が不明ですぞ!");
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
function [k,logger] = Astar_SIR(N,ke,nx,ny,map,unum,FF,E0,E,Ee,ES,EF,X,Xm,Il,vi,w1,w2,fDynamics)
% simulate
% [input]
% N : number of node = nx*ny
% ke : simulation max step
% nx, ny : grid size
% map : SIR_model
% unum : number of agents
% FF : 消防隊の消火ノズル状況
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
p = arranged_position([10,10],unum,2,0);
p = (p(1,:)'-1)*ny + p(2,:)';% init position indices
pt = zeros(unum,1);

k = 1;
while (k <= ke) && sum(find(map.I))
    Eenum = ceil(k/20);
    if E0 == 0
        E1 = E>0;
    else
        E1 = Ee{Eenum}>0;   %E>0となる要素のみによるlogical配列
    end
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

    if E0 ~= 0
        if k <= 20 && k > 0
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});% map 更新
        elseif k <= 40 && k >= 21
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 60 && k >= 41
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 80 && k >= 61
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 100 && k >= 81
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 120 && k >= 101
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 140 && k >= 121
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 160 && k >= 141
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 180 && k >= 161
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 200 && k >= 181
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 220 && k >= 201
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 240 && k >= 221
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 260 && k >= 241
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 280 && k >= 261
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 300 && k >= 281
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 320 && k >= 301
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 340 && k >= 321
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 360 && k >= 341
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 380 && k >= 361
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        elseif k <= 400 && k >= 381
            map.next_step_func(U,Ee{1,Eenum},Ee{2,Eenum});
        end
    elseif Ee == 0
%         map.next_step_func(U,E);% map 更新
        map.next_step_func(U,ES,EF);
    end
    
    % log
    logger.k(k)=k;
    logger.S(:,k) = map.S(:);
    logger.I(:,k) = map.I(:);
    logger.R(:,k) = map.R(:);
    logger.U(:,k) = map.U(:);
    logger.UF(:,k) = map.v2(:); % 飛び火の発生回数の保存 Logger(i).UFで確認
    k = k+1;

    if FF == 0
        unum = 0;
    elseif FF ==1       % 糸魚川火災の詳細Ver
        if k == 20
            unum = unum + 10;
        elseif  k == 40
            unum = unum + 10;
        elseif  k == 60
            unum = unum + 10;
        elseif  k == 120
            unum = unum + 5;
        end
    elseif FF ==2       % 糸魚川火災の詳細Ver2.0
        if k == 3
            unum = unum + 5;
        elseif k == 10
            unum = unum + 5;
        elseif k == 20
            unum = unum + 10;
        elseif  k == 30
            unum = unum + 10;
        elseif  k == 40
            unum = unum + 15;
        elseif  k == 60
            unum = unum + 15;
        elseif  k == 120
            unum = unum + 15;
        end
    elseif FF ==3       % 糸魚川火災の詳細Ver3.0
        if k == 9
            unum = unum + 16;
        elseif k == 25
            unum = unum + 7;
        elseif k == 33
            unum = unum + 19;
        elseif  k == 42
            unum = unum + 4;
        elseif  k == 69
            unum = unum + 3;
        elseif  k == 120
            unum = unum + 12;
        end
    end
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