%% initialize
close all

stepN = 31;
dt = simResult.reference.T(2)-simResult.reference.T(1);
tlength = 0:dt:dt*(stepN-1);

%% Font size setting
Fsize.label = 18;
Fsize.lgd = 18;
Fsize.luler = 18;

%% P
figure(1)
p1 = plot(tlength , simResult.state.p(:,1:stepN),'LineWidth',2);
hold on
grid on
p2 = plot(tlength,simResult.reference.est.p(1:stepN,:)','--','LineWidth',1);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Position','FontSize',Fsize.label);
lgd = legend('$\hat{x}$','$\hat{y}$','$\hat{z}$','$x_d$','$y_d$','$z_d$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off


%% Q
figure(2)
p1 = plot(tlength , simResult.state.q(:,1:stepN),'LineWidth',2);
hold on
grid on
p2 = plot(tlength,simResult.reference.est.q(1:stepN,:)','--','LineWidth',1);
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
p1 = plot(tlength , simResult.state.v(:,1:stepN),'LineWidth',2);
hold on
grid on
p2 = plot(tlength,simResult.reference.est.v(1:stepN,:)','--','LineWidth',1);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Velosity','FontSize',Fsize.label);
lgd = legend('$\hat{v}_x$','$\hat{v}_y$','$\hat{v}_z$','$v_{xd}$','$v_{yd}$','$v_{zd}$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off

%% W
figure(4)
p1 = plot(tlength , simResult.state.w(:,1:stepN),'LineWidth',2);
hold on
grid on
p2 = plot(tlength,simResult.reference.est.w(1:stepN,:)','--','LineWidth',1);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Angular Velosity','FontSize',Fsize.label);
lgd = legend('$\hat{\omega}_\phi$','$\hat{\omega}_\theta$','$\hat{\omega}_\psi$','$\omega_{\phi d}$','$\omega_{\theta d}$','$\omega_{\psi d}$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off