%クープマンモデルを用いて状態更新を行うプログラム
%設定した入力を印加した際に各状態が初期値からどのように変化するかを確認

clc
clear all
close all
exp1 = load(); %確認するクープマンモデルを設定

%% 
%各値の設定-------------------------------------------
m = 0.5884;
g = 9.81;
u1 = -100;
u2 = 0;
u3 = 0;
u4 = 0;
F = @quaternions;
t = 11;

x0 = [0;0;1;0;0;0;0;0;0;0;0;0];
u = repmat([u1;u2;u3;u4],1,t);
x(:,1) = F(x0);
%---------------------------------------------------

%状態更新----------------------------------------------
for i = 1:t-1
    x(:,i+1) = exp1.est.A*x(:,i) + exp1.est.B*u(:,i);
end
X = exp1.est.C*x;
%-----------------------------------------------------

size = figure;
size.WindowState = 'maximized'; %表示するグラフを最大化
subplot(2,3,1)
plot(1:t,X(1,:),'LineWidth',1.2)
grid on
subplot(2,3,2)
plot(1:t,X(2,:),'LineWidth',1.2)
grid on
subplot(2,3,3)
plot(1:t,X(3,:),'LineWidth',1.2)
grid on
subplot(2,3,4)
plot(1:t,u(1,:),'LineWidth',1.2)
grid on
hold on
xlabel('入力')
yline(u1,'Color','r','LineWidth',1.2)
subplot(2,3,5)
plot(1:t,X(9,:),'LineWidth',1.2)
grid on
xlabel('z速度')
subplot(2,3,6)
plot3(X(1,:),X(2,:),X(3,:),'LineWidth',1.2)
xlabel('x')
ylabel('y')
zlabel('z')
grid on
xlim([-0.01 0.01])
ylim([-0.01 0.01])
grid on
xlabel('入力の計算')
