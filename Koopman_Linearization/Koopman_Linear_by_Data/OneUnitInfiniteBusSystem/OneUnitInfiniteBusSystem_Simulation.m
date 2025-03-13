%% OneUnitInfiniteBusSystem_Simulation
% 一機無限大母線系統と呼ばれる電力システムモデルのシミュレーション
%% 初期化
close all
clear
%データ保存先ファイル名
FileName = 'OUIBSResult_seedT.mat';
%データ保存用,現在のファイルパスを取得,保存先を指定
activeFile = matlab.desktop.editor.getActive;
nowFolder = fileparts(activeFile.Filename);
targetpath=append(nowFolder,'\',FileName);

%% 初期設定
% rand シード値
seed = double('T');
% seed = double('C');
% seed = double('U');
rng(seed);

% データ取得間隔 50 ms
h = 0.05;
tspan = [0 h];
% 初期状態 (x1,x2)∈[-1,1]*[-1,1]
% x = rand(2,1)*2-[1;1];
x = [0.5;0]
% データ数
K = 10^3;

X = x;
T = 0;
U = double.empty;
Y = double.empty;

%% シミュレーション開始
for i = 1:K
    if i ~= 1
        X(:,end+1) = Y(:,end);
    end
    x = X(:,end);
    u = rand(1)*0.2-0.1;
    [Te,Ye] = ode45(@(t,y)OUIBS(x,u),tspan,x);
    if i==1
        Y = Ye(end,:)';
        U = u;
    else
        Y(:,end+1)=Ye(end,:)';
        U(end+1)=u;
    end
    T(end+1) = T(end)+Te(end);
    
end

%% save
data.setting.RNDseed = seed;
data.setting.h = h;
data.setting.DataN = K;
data.X = X;
data.Y = Y;
data.T = T;
data.U = U;
save(targetpath,"data")

%% チェック用plot
figure(1)
subplot(2,1,1)
plot(T(1:end-1),X(1,:))
subplot(2,1,2)
plot(T(1:end-1),X(2,:))

figure(2)
plot(T(1:end-1),U)

%% ode45 微分方程式
function dydt = OUIBS(x,u)
% 非線形ダイナミクス
D = 0.05;
P = 0.07;
B = 0.7;

% 状態設定
delta = x(1);
omega = x(2);

ddelta = omega;
domega = -D*omega-B*sin(delta)+P+u;

dydt = [ddelta;domega];
end

