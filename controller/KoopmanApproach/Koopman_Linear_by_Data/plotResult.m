%% initialize
close all

stepN = 50;
dt = simResult.reference.T(2)-simResult.reference.T(1);
tlength = 0:dt:dt*(stepN-1);

%% Font size setting
Fsize.label = 18;
Fsize.lgd = 18;
Fsize.luler = 18;

%% P
figure(1)
p2 = plot(tlength,simResult.reference.est.p(1:stepN,:)','LineWidth',2);
hold on
grid on
p1 = plot(tlength , simResult.state.p(:,1:stepN),':o','MarkerSize',6,'LineWidth',2);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Position','FontSize',Fsize.label);
lgd = legend('$x_d$','$y_d$','$z_d$','$\hat{x}$','$\hat{y}$','$\hat{z}$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off
% rmseの算出
RMSE.P.eachStep = (simResult.state.p(:,1:stepN)-simResult.reference.est.p(1:stepN,:)').^2;
RMSE.P.all  = rms(simResult.state.p(:,1:stepN)-simResult.reference.est.p(1:stepN,:)','all');
haven = rms(simResult.state.p(:,1:stepN)-simResult.reference.est.p(1:stepN,:)',2);
RMSE.P.x = haven(1,:);
RMSE.P.y = haven(2,:);
RMSE.P.z = haven(3,:);
disp('RMSE.P =')
disp(RMSE.P)

%% Q
figure(2)
p2 = plot(tlength,simResult.reference.est.q(1:stepN,:)','LineWidth',2);
hold on
grid on
p1 = plot(tlength , simResult.state.q(:,1:stepN),':o','MarkerSize',6,'LineWidth',2);
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Attitude','FontSize',Fsize.label);
if size(simResult.state.q,1)==3
    lgd = legend('$\phi_d$','$\theta_d$','$\psi_d$','$\hat{\phi}$','$\hat{\theta}$','$\hat{\psi}$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
else
        lgd = legend('$q_{0{\rm d}}$','$q_{1{\rm d}}$','$q_{2{\rm d}}$','$q_{3{\rm d}}$','$q_0$','$q_1$','$q_2$','$q_3$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
end
lgd.NumColumns = 2;
hold off
% rmseの算出
RMSE.Q.eachStep = (simResult.state.q(:,1:stepN)-simResult.reference.est.q(1:stepN,:)').^2;
RMSE.Q.all  = rms(simResult.state.q(:,1:stepN)-simResult.reference.est.q(1:stepN,:)','all');
haven = rms(simResult.state.q(:,1:stepN)-simResult.reference.est.q(1:stepN,:)',2);
RMSE.Q.x = haven(1,:);
RMSE.Q.y = haven(2,:);
RMSE.Q.z = haven(3,:);
disp('RMSE.Q =')
disp(RMSE.Q)

%% V
figure(3)
p2 = plot(tlength,simResult.reference.est.v(1:stepN,:)','LineWidth',2);
hold on
grid on
p1 = plot(tlength , simResult.state.v(:,1:stepN),':o','MarkerSize',6,'LineWidth',2);set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Velosity','FontSize',Fsize.label);
lgd = legend('$v_{xd}$','$v_{yd}$','$v_{zd}$','$\hat{v}_x$','$\hat{v}_y$','$\hat{v}_z$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off
% rmseの算出
RMSE.V.eachStep = (simResult.state.v(:,1:stepN)-simResult.reference.est.v(1:stepN,:)').^2;
RMSE.V.all  = rms(simResult.state.v(:,1:stepN)-simResult.reference.est.v(1:stepN,:)','all');
haven = rms(simResult.state.v(:,1:stepN)-simResult.reference.est.v(1:stepN,:)',2);
RMSE.V.x = haven(1,:);
RMSE.V.y = haven(2,:);
RMSE.V.z = haven(3,:);
disp('RMSE.V =')
disp(RMSE.V)

%% W
figure(4)
p2 = plot(tlength,simResult.reference.est.w(1:stepN,:)','LineWidth',2);
hold on
grid on
p1 = plot(tlength , simResult.state.w(:,1:stepN),':o','MarkerSize',6,'LineWidth',2);set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Angular Velosity','FontSize',Fsize.label);
lgd = legend('$\omega_{\phi d}$','$\omega_{\theta d}$','$\omega_{\psi d}$','$\hat{\omega}_\phi$','$\hat{\omega}_\theta$','$\hat{\omega}_\psi$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = 2;
hold off
% rmseの算出
RMSE.W.eachStep = (simResult.state.w(:,1:stepN)-simResult.reference.est.w(1:stepN,:)').^2;
RMSE.W.all  = rms(simResult.state.w(:,1:stepN)-simResult.reference.est.w(1:stepN,:)','all');
haven = rms(simResult.state.w(:,1:stepN)-simResult.reference.est.w(1:stepN,:)',2);
RMSE.W.x = haven(1,:);
RMSE.W.y = haven(2,:);
RMSE.W.z = haven(3,:);
disp('RMSE.W =')
disp(RMSE.W)