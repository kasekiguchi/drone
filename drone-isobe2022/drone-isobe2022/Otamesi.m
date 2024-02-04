clc
clear all
close all
exp1 = load("EstimationResult_12state_2_4_Exp_sprine+zsprine+P2Pz_torque_incon.mat",'est');
% exp2 = load("EstimationResult_12state_2_2_Sim_cirrevsadP2Pxy_torque_incon.mat",'est');
% exp1 = load("EstimationResult_12state_2_2_Sim_cirrevsadP2Pxy_torque_incon_無駄時間あり.mat",'est');
% exp1 = load("EstimationResult_12state_2_1_Exp_sprine100__torque_incon.mat",'est');
% exp1 = load("EstimationResult_12state_12_17_ExpcirrevsadP2Pxydata_est=P2Pshape.mat",'est');
% exp1 = load("test.mat");
% exp1 = load("EstimationResult_12state_1_29_Exp_sprineandall_est=P2Pshape_torque_incon.mat");
%% 

m = 0.5884;
g = 9.81-100;
u1 = m*g;
u2 = 0;
u3 = 0;
u4 = 0;
F = @quaternions;
t = 10;

x0 = [0;0;1;0;0;0;0;0;0;0;0;0];
u = repmat([u1;u2;u3;u4],1,t);
x(:,1) = F(x0);
% exp1.est.B(3,1) = -0.0018;
for i = 1:t-1
    x(:,i+1) = exp1.est.A*x(:,i) + exp1.est.B*u(:,i);
    % U(:,i) = exp1.est.B*u(:,i);
    % x(:,i+1) = exp1.est.A*x(:,i);
    % u(1,i+1) = 0.5884*9.81+randi([-5 5])*0.1;
end

X = exp1.est.C*x;

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
% subplot(2,3,6)
% plot(1:t,U(:,:),'LineWidth',1.2)
% grid on
% xlabel('入力の計算')
