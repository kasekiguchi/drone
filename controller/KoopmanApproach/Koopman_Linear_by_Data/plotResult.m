%% initialize
close all

%% Font size setting
Fsize.label = 18;
Fsize.lgd = 18;
Fsize.luler = 18;

%% P
figure(1)
p1 = plot(simResult.T , simResult.state.p,'LineWidth',2);
hold on
grid on
p2 = plot(Data.T(1:simResult.state.N),Data.est.p(1:simResult.state.N,:)','--','LineWidth',1);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Position','FontSize',Fsize.label);
lgd = legend('$\hat{x}$','$\hat{y}$','$\hat{z}$','$x_d$','$y_d$','$z_d$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off


%% Q
figure(2)
p1 = plot(simResult.T , simResult.state.q,'LineWidth',2);
hold on
grid on
p2 = plot(Data.T(1:simResult.state.N),Data.est.q(1:simResult.state.N,:)','--','LineWidth',1);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Attitude','FontSize',Fsize.label);
if size(simResult.state.q,1)==3
    lgd = legend('$\hat{\phi}$','$\hat{\theta}$','$\hat{\psi}$','$\phi_d$','$\theta_d$','$\psi_d$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
else
        lgd = legend('$q_0$','$q_1$','$q_2$','$q_3$','$q_{0{\rm d}}$','$q_{1{\rm d}}$','$q_{2{\rm d}}$','$q_{3{\rm d}}$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
end
lgd.NumColumns = 2;
hold off

%% V
figure(3)
p1 = plot(simResult.T , simResult.state.v,'LineWidth',2);
hold on
grid on
p2 = plot(Data.T(1:simResult.state.N),Data.est.v(1:simResult.state.N,:)','--','LineWidth',1);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Velosity','FontSize',Fsize.label);
lgd = legend('$\hat{v}_x$','$\hat{v}_y$','$\hat{v}_z$','$v_{xd}$','$v_{yd}$','$v_{zd}$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off

%% W
figure(4)
p1 = plot(simResult.T , simResult.state.w,'LineWidth',2);
hold on
grid on
p2 = plot(Data.T(1:simResult.state.N),Data.est.w(1:simResult.state.N,:)','--','LineWidth',1);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Angular Velosity','FontSize',Fsize.label);
lgd = legend('$\hat{\omega}_\phi$','$\hat{\omega}_\theta$','$\hat{\omega}_\psi$','$\omega_{\phi d}$','$\omega_{\theta d}$','$\omega_{\psi d}$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off