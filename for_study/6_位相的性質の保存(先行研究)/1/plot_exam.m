%% 論文検証
% 「軌道の位相的性質を保証する非線形動的システム学習」
%% 
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
%% 定義
ts = 0;
dt = 0.03;
t_sim_max = 30; % データセット用に1000ステップ
% t_sim_max = 300; % 描画が完全になる
te = t_sim_max - dt;
tspan = ts:dt:te;
numPart = 24; % 円の分割数
numPart2 = 48;
r1 = 2; % 大きい円の半径
r2 = 0.001; % 小さい円の半径
r3 = 2.9;
r4 = 0.005;
state = {};
%% シミュレーション・描画
% データに使用する点(破線)
figure(1)
hold on

for i = 1:numPart
    % 初期点角度(0からスタート)
    theta = (i*2*pi/numPart) - (2*pi/numPart);
    x0_1 = r1*[cos(theta);sin(theta)];
    [T1,X1] = ode45(@odefcn,tspan,x0_1);
    state{1,i} = X1;
    plot(X1(:,1),X1(:,2),'--r')
    if i==1||i==7||i==13||i==19
        x0_2 = r2*[cos(theta);sin(theta)];
        [T2,X2] = ode45(@odefcn,tspan,x0_2);
        state{2,i} = X2;
        plot(X2(:,1),X2(:,2),'--r')
        plot(x0_2(1),x0_2(2),'-ok','MarkerSize',5)
    end
    plot(x0_1(1),x0_1(2),'-ok','MarkerSize',5)
end

grid on
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off

%% 任意の点からの描画
% リミットサイクルの確認(実線)
figure(2)
hold on

for i = 1:numPart2
    % 初期点角度(0からスタート)
    theta = (i*2*pi/numPart2) - (2*pi/numPart2);
    x0_3 = r3*[cos(theta);sin(theta)];
    [T3,X3] = ode45(@odefcn,tspan,x0_3);
    plot(X3(:,1),X3(:,2),'-b')
    if i==1||i==18||i==24||i==44
        x0_4 = r4*[cos(theta);sin(theta)];
        [T4,X4] = ode45(@odefcn,tspan,x0_4);
        plot(X4(:,1),X4(:,2),'-b')
    end
end

grid on
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off

%% 図1+図2を1枚に重ねて描画
figure(3)
hold on

for i = 1:numPart
    % 初期点角度(0からスタート)
    theta = (i*2*pi/numPart) - (2*pi/numPart);
    x0_1 = r1*[cos(theta);sin(theta)];
    [T1,X1] = ode45(@odefcn,tspan,x0_1);
    state{1,i} = X1;
    plot(X1(:,1),X1(:,2),'--r')
    if i==1||i==7||i==13||i==19
        x0_2 = r2*[cos(theta);sin(theta)];
        [T2,X2] = ode45(@odefcn,tspan,x0_2);
        state{2,i} = X2;
        plot(X2(:,1),X2(:,2),'--r')
        plot(x0_2(1),x0_2(2),'-ok','MarkerSize',5)
    end
    plot(x0_1(1),x0_1(2),'-ok','MarkerSize',5)
end
for i = 1:numPart2
    % 初期点角度(0からスタート)
    theta = (i*2*pi/numPart2) - (2*pi/numPart2);
    x0_3 = r3*[cos(theta);sin(theta)];
    [T3,X3] = ode45(@odefcn,tspan,x0_3);
    plot(X3(:,1),X3(:,2),'-b')
    if i==1||i==18||i==24||i==44
        x0_4 = r4*[cos(theta);sin(theta)];
        [T4,X4] = ode45(@odefcn,tspan,x0_4);
        plot(X4(:,1),X4(:,2),'-b')
    end
end
grid on
xlim([-2 2])
ylim([-2 2])
pbaspect([1 1 1])
hold off



