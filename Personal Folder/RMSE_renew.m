%% RMSE(二乗平均平方根誤差)を求めるプログラム
close all hidden;
clear all;
clc;
%% 読み込み
load('2_8_mpc_立体_発表資料.mat')

for i = find(log.Data.phase == 102,1,'first'):find(log.Data.phase == 102,1,'last')
    data.t(1,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.t(i,1);                                      %時間t
    data.phase(1,i) = log.Data.phase(i,1);                                                               %フェーズ
    data.p(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
    data.pr(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.reference.result{i}.state.p(:,1);     %位置p_reference
end

%% 位置のRMSE
clc

x = sqrt(sum((data.pr(1,:)-data.p(1,:)).^2)/size(data.p,2));

y = sqrt(sum((data.pr(2,:)-data.p(2,:)).^2)/size(data.p,2));

z = sqrt(sum((data.pr(3,:)-data.p(3,:)).^2)/size(data.p,2));


%  %% 姿勢角のRMSE
% 
% for j = 1:3
%     for i = 1:HowmanyFile
%         if j == 1
%             phi_t = file{WhichRef}.simResult.reference.est.q(tlength,1)';
%             phi_r(i,:) = file{i}.simResult.state.q(1,1:stepN);
%             phi(1,i) = sqrt(sum((phi_r(i,:)-phi_t).^2)/length);
%         elseif j == 2
%             theta_t = file{WhichRef}.simResult.reference.est.q(tlength,2)';
%             theta_r(i,:) = file{i}.simResult.state.q(2,1:stepN);
%             theta(1,i) = sqrt(sum((theta_r(i,:)-theta_t).^2)/length);
%         else
%             psi_t = file{WhichRef}.simResult.reference.est.q(tlength,3)';
%             psi_r(i,:) = file{i}.simResult.state.q(3,1:stepN);
%             psi(1,i) = sqrt(sum((psi_r(i,:)-psi_t).^2)/length);
%         end
% 
%     end
% end
% 
% %% 速度のRMSE
% 
% for j = 1:3
%     for i = 1:HowmanyFile
%         if j == 1
%             vx_t = file{WhichRef}.simResult.reference.est.v(tlength,1)';
%             vx_r(i,:) = file{i}.simResult.state.v(1,1:stepN);
%             vx(1,i) = sqrt(sum((vx_r(i,:)-vx_t).^2)/length);
%         elseif j == 2
%             vy_t = file{WhichRef}.simResult.reference.est.v(tlength,2)';
%             vy_r(i,:) = file{i}.simResult.state.v(2,1:stepN);
%             vy(1,i) = sqrt(sum((vy_r(i,:)-vy_t).^2)/length);
%         else
%             vz_t = file{WhichRef}.simResult.reference.est.v(tlength,3)';
%             vz_r(i,:) = file{i}.simResult.state.v(3,1:stepN);
%             vz(1,i) = sqrt(sum((vz_r(i,:)-vz_t).^2)/length);
%         end
% 
%     end
% end
% 
% %% 角速度のRMSE
% 
% for j = 1:3
%     for i = 1:HowmanyFile
%         if j == 1
%             wphi_t = file{WhichRef}.simResult.reference.est.w(tlength,1)';
%             wphi_r(i,:) = file{i}.simResult.state.w(1,1:stepN);
%             wphi(1,i) = sqrt(sum((wphi_r(i,:)-wphi_t).^2)/length);
%         elseif j == 2
%             wtheta_t = file{WhichRef}.simResult.reference.est.w(tlength,2)';
%             wtheta_r(i,:) = file{i}.simResult.state.w(2,1:stepN);
%             wtheta(1,i) = sqrt(sum((wtheta_r(i,:)-wtheta_t).^2)/length);
%         else
%             wpsi_t = file{WhichRef}.simResult.reference.est.w(tlength,3)';
%             wpsi_r(i,:) = file{i}.simResult.state.w(3,1:stepN);
%             wpsi(1,i) = sqrt(sum((wpsi_r(i,:)-wpsi_t).^2)/length);
%         end
% 
%     end
% end

%% 表示

 disp('＜位置p＞')
disp([' x_case1: ' num2str(x)])
disp([' y_case1: ' num2str(y)])
disp([' z_case1: ' num2str(z)])

% if HowmanyFile == 1
%     disp('＜位置p＞')
%     disp([' x_case1: ' num2str(x(1,1))])
%     disp([' y_case1: ' num2str(y(1,1))])
%     disp([' z_case1: ' num2str(z(1,1))])
%     disp('-----------------------------')
%     disp('＜姿勢角q＞')
%     disp(['  phi_case1: ' num2str(phi(1,1))])
%     disp(['theta_case1: ' num2str(theta(1,1))])
%     disp(['  psi_case1: ' num2str(psi(1,1))])
%     disp('-----------------------------')
%     disp('＜速度v＞')
%     disp([' vx_case1: ' num2str(vx(1,1))])
%     disp([' vy_case1: ' num2str(vy(1,1))])
%     disp([' vz_case1: ' num2str(vz(1,1))])
%     disp('-----------------------------')
%     disp('＜角速度w＞')
%     disp(['  wphi_case1: ' num2str(wphi(1,1))])
%     disp(['wtheta_case1: ' num2str(wtheta(1,1))])
%     disp(['  wpsi_case1: ' num2str(wpsi(1,1))])
% elseif HowmanyFile == 2
%     disp('＜位置p＞')
%     disp([' x_case1: ' num2str(x(1,1))])
%     disp([' x_case2: ' num2str(x(1,2))])
%     disp([' y_case1: ' num2str(y(1,1))])
%     disp([' y_case2: ' num2str(y(1,2))])
%     disp([' z_case1: ' num2str(z(1,1))])
%     disp([' z_case2: ' num2str(z(1,2))])
%     disp('-----------------------------')
%     disp('＜姿勢角q＞')
%     disp(['  phi_case1: ' num2str(phi(1,1))])
%     disp(['  phi_case2: ' num2str(phi(1,2))])
%     disp(['theta_case1: ' num2str(theta(1,1))])
%     disp(['theta_case2: ' num2str(theta(1,2))])
%     disp(['  psi_case1: ' num2str(psi(1,1))])
%     disp(['  psi_case2: ' num2str(psi(1,2))])
%     disp('-----------------------------')
%     disp('＜速度v＞')
%     disp([' vx_case1: ' num2str(vx(1,1))])
%     disp([' vx_case2: ' num2str(vx(1,2))])
%     disp([' vy_case1: ' num2str(vy(1,1))])
%     disp([' vy_case2: ' num2str(vy(1,2))])
%     disp([' vz_case1: ' num2str(vz(1,1))])
%     disp([' vz_case2: ' num2str(vz(1,2))])
%     disp('-----------------------------')
%     disp('＜角速度w＞')
%     disp(['  wphi_case1: ' num2str(wphi(1,1))])
%     disp(['  wphi_case2: ' num2str(wphi(1,2))])
%     disp(['wtheta_case1: ' num2str(wtheta(1,1))])
%     disp(['wtheta_case2: ' num2str(wtheta(1,2))])
%     disp(['  wpsi_case1: ' num2str(wpsi(1,1))])
%     disp(['  wpsi_case2: ' num2str(wpsi(1,2))])
% elseif HowmanyFile == 3
%     disp('＜位置p＞')
%     disp([' x_case1: ' num2str(x(1,1))])
%     disp([' x_case2: ' num2str(x(1,2))])
%     disp([' x_case3: ' num2str(x(1,3))])
%     disp([' y_case1: ' num2str(y(1,1))])
%     disp([' y_case2: ' num2str(y(1,2))])
%     disp([' y_case3: ' num2str(y(1,3))])
%     disp([' z_case1: ' num2str(z(1,1))])
%     disp([' z_case2: ' num2str(z(1,2))])
%     disp([' z_case3: ' num2str(z(1,3))])
%     disp('-----------------------------')
%     disp('＜姿勢角q＞')
%     disp(['  phi_case1: ' num2str(phi(1,1))])
%     disp(['  phi_case2: ' num2str(phi(1,2))])
%     disp(['  phi_case3: ' num2str(phi(1,3))])
%     disp(['theta_case1: ' num2str(theta(1,1))])
%     disp(['theta_case2: ' num2str(theta(1,2))])
%     disp(['theta_case3: ' num2str(theta(1,3))])
%     disp(['  psi_case1: ' num2str(psi(1,1))])
%     disp(['  psi_case2: ' num2str(psi(1,2))])
%     disp(['  psi_case3: ' num2str(psi(1,3))])
%     disp('-----------------------------')
%     disp('＜速度v＞')
%     disp([' vx_case1: ' num2str(vx(1,1))])
%     disp([' vx_case2: ' num2str(vx(1,2))])
%     disp([' vx_case3: ' num2str(vx(1,3))])
%     disp([' vy_case1: ' num2str(vy(1,1))])
%     disp([' vy_case2: ' num2str(vy(1,2))])
%     disp([' vy_case3: ' num2str(vy(1,3))])
%     disp([' vz_case1: ' num2str(vz(1,1))])
%     disp([' vz_case2: ' num2str(vz(1,2))])
%     disp([' vz_case3: ' num2str(vz(1,3))])
%     disp('-----------------------------')
%     disp('＜角速度w＞')
%     disp(['  wphi_case1: ' num2str(wphi(1,1))])
%     disp(['  wphi_case2: ' num2str(wphi(1,2))])
%     disp(['  wphi_case3: ' num2str(wphi(1,3))])
%     disp(['wtheta_case1: ' num2str(wtheta(1,1))])
%     disp(['wtheta_case2: ' num2str(wtheta(1,2))])
%     disp(['wtheta_case3: ' num2str(wtheta(1,3))])
%     disp(['  wpsi_case1: ' num2str(wpsi(1,1))])
%     disp(['  wpsi_case2: ' num2str(wpsi(1,2))])
%     disp(['  wpsi_case3: ' num2str(wpsi(1,3))])
% elseif HowmanyFile == 4
%     disp('＜位置p＞')
%     disp([' x_case1: ' num2str(x(1,1))])
%     disp([' x_case2: ' num2str(x(1,2))])
%     disp([' x_case3: ' num2str(x(1,3))])
%     disp([' x_case4: ' num2str(x(1,4))])
%     disp([' y_case1: ' num2str(y(1,1))])
%     disp([' y_case2: ' num2str(y(1,2))])
%     disp([' y_case3: ' num2str(y(1,3))])
%     disp([' y_case4: ' num2str(y(1,4))])
%     disp([' z_case1: ' num2str(z(1,1))])
%     disp([' z_case2: ' num2str(z(1,2))])
%     disp([' z_case3: ' num2str(z(1,3))])
%     disp([' z_case4: ' num2str(z(1,4))])
%     disp('-----------------------------')
%     disp('＜姿勢角q＞')
%     disp(['  phi_case1: ' num2str(phi(1,1))])
%     disp(['  phi_case2: ' num2str(phi(1,2))])
%     disp(['  phi_case3: ' num2str(phi(1,3))])
%     disp(['  phi_case4: ' num2str(phi(1,4))])
%     disp(['theta_case1: ' num2str(theta(1,1))])
%     disp(['theta_case2: ' num2str(theta(1,2))])
%     disp(['theta_case3: ' num2str(theta(1,3))])
%     disp(['theta_case4: ' num2str(theta(1,4))])
%     disp(['  psi_case1: ' num2str(psi(1,1))])
%     disp(['  psi_case2: ' num2str(psi(1,2))])
%     disp(['  psi_case3: ' num2str(psi(1,3))])
%     disp(['  psi_case4: ' num2str(psi(1,4))])
%     disp('-----------------------------')
%     disp('＜速度v＞')
%     disp([' vx_case1: ' num2str(vx(1,1))])
%     disp([' vx_case2: ' num2str(vx(1,2))])
%     disp([' vx_case3: ' num2str(vx(1,3))])
%     disp([' vx_case4: ' num2str(vx(1,4))])
%     disp([' vy_case1: ' num2str(vy(1,1))])
%     disp([' vy_case2: ' num2str(vy(1,2))])
%     disp([' vy_case3: ' num2str(vy(1,3))])
%     disp([' vy_case4: ' num2str(vy(1,4))])
%     disp([' vz_case1: ' num2str(vz(1,1))])
%     disp([' vz_case2: ' num2str(vz(1,2))])
%     disp([' vz_case3: ' num2str(vz(1,3))])
%     disp([' vz_case4: ' num2str(vz(1,4))])
%     disp('-----------------------------')
%     disp('＜角速度w＞')
%     disp(['  wphi_case1: ' num2str(wphi(1,1))])
%     disp(['  wphi_case2: ' num2str(wphi(1,2))])
%     disp(['  wphi_case3: ' num2str(wphi(1,3))])
%     disp(['  wphi_case4: ' num2str(wphi(1,4))])
%     disp(['wtheta_case1: ' num2str(wtheta(1,1))])
%     disp(['wtheta_case2: ' num2str(wtheta(1,2))])
%     disp(['wtheta_case3: ' num2str(wtheta(1,3))])
%     disp(['wtheta_case4: ' num2str(wtheta(1,4))])
%     disp(['  wpsi_case1: ' num2str(wpsi(1,1))])
%     disp(['  wpsi_case2: ' num2str(wpsi(1,2))])
%     disp(['  wpsi_case3: ' num2str(wpsi(1,3))])
%     disp(['  wpsi_case4: ' num2str(wpsi(1,4))])
% else
%     disp('＜位置p＞')
%     disp([' x_case1: ' num2str(x(1,1))])
%     disp([' x_case2: ' num2str(x(1,2))])
%     disp([' x_case3: ' num2str(x(1,3))])
%     disp([' x_case4: ' num2str(x(1,4))])
%     disp([' x_case5: ' num2str(x(1,5))])
%     disp([' y_case1: ' num2str(y(1,1))])
%     disp([' y_case2: ' num2str(y(1,2))])
%     disp([' y_case3: ' num2str(y(1,3))])
%     disp([' y_case4: ' num2str(y(1,4))])
%     disp([' y_case5: ' num2str(y(1,5))])
%     disp([' z_case1: ' num2str(z(1,1))])
%     disp([' z_case2: ' num2str(z(1,2))])
%     disp([' z_case3: ' num2str(z(1,3))])
%     disp([' z_case4: ' num2str(z(1,4))])
%     disp([' z_case5: ' num2str(z(1,5))])
%     disp('-----------------------------')
%     disp('＜姿勢角q＞')
%     disp(['  phi_case1: ' num2str(phi(1,1))])
%     disp(['  phi_case2: ' num2str(phi(1,2))])
%     disp(['  phi_case3: ' num2str(phi(1,3))])
%     disp(['  phi_case4: ' num2str(phi(1,4))])
%     disp(['  phi_case5: ' num2str(phi(1,5))])
%     disp(['theta_case1: ' num2str(theta(1,1))])
%     disp(['theta_case2: ' num2str(theta(1,2))])
%     disp(['theta_case3: ' num2str(theta(1,3))])
%     disp(['theta_case4: ' num2str(theta(1,4))])
%     disp(['theta_case5: ' num2str(theta(1,5))])
%     disp(['  psi_case1: ' num2str(psi(1,1))])
%     disp(['  psi_case2: ' num2str(psi(1,2))])
%     disp(['  psi_case3: ' num2str(psi(1,3))])
%     disp(['  psi_case4: ' num2str(psi(1,4))])
%     disp(['  psi_case5: ' num2str(psi(1,5))])
%     disp('-----------------------------')
%     disp('＜速度v＞')
%     disp([' vx_case1: ' num2str(vx(1,1))])
%     disp([' vx_case2: ' num2str(vx(1,2))])
%     disp([' vx_case3: ' num2str(vx(1,3))])
%     disp([' vx_case4: ' num2str(vx(1,4))])
%     disp([' vx_case5: ' num2str(vx(1,5))])
%     disp([' vy_case1: ' num2str(vy(1,1))])
%     disp([' vy_case2: ' num2str(vy(1,2))])
%     disp([' vy_case3: ' num2str(vy(1,3))])
%     disp([' vy_case4: ' num2str(vy(1,4))])
%     disp([' vy_case5: ' num2str(vy(1,5))])
%     disp([' vz_case1: ' num2str(vz(1,1))])
%     disp([' vz_case2: ' num2str(vz(1,2))])
%     disp([' vz_case3: ' num2str(vz(1,3))])
%     disp([' vz_case4: ' num2str(vz(1,4))])
%     disp([' vz_case5: ' num2str(vz(1,5))])
%     disp('-----------------------------')
%     disp('＜角速度w＞')
%     disp(['  wphi_case1: ' num2str(wphi(1,1))])
%     disp(['  wphi_case2: ' num2str(wphi(1,2))])
%     disp(['  wphi_case3: ' num2str(wphi(1,3))])
%     disp(['  wphi_case4: ' num2str(wphi(1,4))])
%     disp(['  wphi_case5: ' num2str(wphi(1,5))])
%     disp(['wtheta_case1: ' num2str(wtheta(1,1))])
%     disp(['wtheta_case2: ' num2str(wtheta(1,2))])
%     disp(['wtheta_case3: ' num2str(wtheta(1,3))])
%     disp(['wtheta_case4: ' num2str(wtheta(1,4))])
%     disp(['wtheta_case5: ' num2str(wtheta(1,5))])
%     disp(['  wpsi_case1: ' num2str(wpsi(1,1))])
%     disp(['  wpsi_case2: ' num2str(wpsi(1,2))])
%     disp(['  wpsi_case3: ' num2str(wpsi(1,3))])
%     disp(['  wpsi_case4: ' num2str(wpsi(1,4))])
%     disp(['  wpsi_case5: ' num2str(wpsi(1,5))])
% end
