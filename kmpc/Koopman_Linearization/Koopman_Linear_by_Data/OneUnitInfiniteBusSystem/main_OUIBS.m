%% 初期化
clear
close
% データ読み込み
load('EstimationResult_OUBIS4_seedU.mat');
x0 = Data.X(:,1);
setting = Data.setting;
clear simResult

%% 観測量 とりあえず手動で選択
% F = @(x) x;
% F = @(x) [x(2);sin(x(1));cos(x(1))];
% F = @(x) [x(1);x(2);sin(x(1));cos(x(1));x(2)*cos(x(1));x(2)*sin(x(1))];
F = @(x) [x(2);sin(x(1));cos(x(1));x(2)*cos(x(1));x(2)*sin(x(1))];

%% 初期設定
% rand シード値
seed = double('T');
% seed = double('C');
% seed = double('U');
% seed = double('G');
rng(seed);
if seed == setting.RNDseed
    disp('Caution! 推定時のシード値と同じ値を使用しています')
end

% データ取得間隔 50 ms
h = setting.h;
tspan = [0 h];
% 初期状態 (x1,x2)∈[-1,1]*[-1,1]
% x = rand(2,1)*2-[1;1];
x = x0;
% データ数
K = setting.DataN;

X_des = x;
X = x;
Z = F(x);
T = 0;
U = double.empty;
Y = double.empty;

%% シミュレーション開始
for i = 1:K
    if i ~= 1
        X(:,end+1) = Y(:,end);
        X_des(:,end+1) = Y_des(:,end);
    end
    x = X(:,end);
    x_des = X_des(:,end);
    u = rand(1)*0.2-0.1;

    z = F(x);
    z = est.Ahat*z + est.Bhat*u;
    y = est.Chat*z;

    [Te,Ye] = ode45(@(t,y)OUIBS(x_des,u),tspan,x_des);

    if i==1
        Y = y;
        U = u;
        Y_des = Ye(end,:)';
    else
        Y(:,end+1) = y;
        U(end+1)=u;
        Y_des(:,end+1) = Ye(end,:)';
    end
    T(end+1) = T(end)+h;
    Z(:,end+1) = z;
    
end

%% チェック用plot
figure(1)
subplot(2,1,1)
hold on
grid on
p1 = plot(T(1:end-1),X_des(1,:));
p2 = plot(T(1:end-1),X(1,:));
subplot(2,1,2)
hold on
grid on
p3 = plot(T(1:end-1),X_des(2,:));
p4 = plot(T(1:end-1),X(2,:));
figure(2)
plot(T(1:end-1),U)


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