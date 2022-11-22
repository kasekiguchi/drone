%% P
figure(1)
p1 = plot(simResult.T , simResult.Xhat(1:3,:),'LineWidth',2);
hold on
grid on
p2 = plot(Data.T,Data.X(1:3,:),'--','LineWidth',1);
xlabel('time [sec]','FontSize',12);
ylabel('Position','FontSize',12);
lgd = legend('$\hat{x}$','$\hat{y}$','$\hat{z}$','$x_d$','$y_d$','$z_d$','FontSize',18,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
set(gca,'FontSize',14);
hold off


%% Q
figure(2)
p1 = plot(simResult.T , simResult.Xhat(4:6,:),'LineWidth',2);
hold on
grid on
p2 = plot(Data.T,Data.X(4:6,:),'--','LineWidth',1);
xlabel('time [sec]','FontSize',12);
ylabel('Attitude','FontSize',12);
lgd = legend('$\hat{\phi}$','$\hat{\theta}$','$\hat{\psi}$','$\phi_d$','$\theta_d$','$\psi_d$','FontSize',18,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
set(gca,'FontSize',14);
hold off

%% V
figure(3)
p1 = plot(simResult.T , simResult.Xhat(7:9,:),'LineWidth',2);
hold on
grid on
p2 = plot(Data.T,Data.X(7:9,:),'--','LineWidth',1);
xlabel('time [sec]','FontSize',12);
ylabel('Velosity','FontSize',12);
lgd = legend('$\hat{v}_x$','$\hat{v}_y$','$\hat{v}_z$','$v_{xd}$','$v_{yd}$','$v_{zd}$','FontSize',18,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
set(gca,'FontSize',14);
hold off

%% W
figure(4)
p1 = plot(simResult.T , simResult.Xhat(10:12,:),'LineWidth',2);
hold on
grid on
p2 = plot(Data.T,Data.X(10:12,:),'--','LineWidth',1);
xlabel('time [sec]','FontSize',12);
ylabel('Angular Velosity','FontSize',12);
lgd = legend('$\hat{\omega}_\phi$','$\hat{\omega}_\theta$','$\hat{\omega}_\psi$','$\omega_{\phi d}$','$\omega_{\theta d}$','$\omega_{\psi d}$','FontSize',18,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
set(gca,'FontSize',14);
hold off