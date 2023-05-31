%% initialize
clear all
close all

%% flag
flg.calcFile1RMSE = 1; % file{1}に読み込んだデータのRMSEを求める
flg.ylimHold = 0; % 指定した値にylimを固定
flg.xlimHold = 1; % 指定した値にxlimを固定

%% select file to load
loadfilename{1} = ['EstimationResult_12state_5_31_normal3.mat'] %mainで書き込んだファイルの名前に逐次変更する
% loadfilename{2} = 'EstimationResult_NonlinearElementsInF.mat'
% loadfilename{3} = 'EstimationResult_quaternion12state_bilinear_plusConst.mat'

% loadfilename{1} = 'rndInitSim_bilinear_1.mat'
% loadfilename{2} = 'rndInitSim_bilinear_plusConst_1.mat'

% loadfilename{1} = '2secInitSim_12state_1.mat'
% loadfilename{1} = '2secInitSim_InputAndConst_1.mat'
% loadfilename{1} = '2secInitSim_quaternions_1.mat'

% loadfilename{2} = 'EstimationResult_12state.mat'
% loadfilename{2} = 'EstimationResult_rndP2O4_InputAndConst.mat';

WhichRef = 1; % どのファイルをリファレンスに使うか

%% plot range
%何ステップまで表示するか
%ステップ数とxlinHoldの幅を変えればグラフの長さを変えられる
stepN = 31; %検証用シミュレーションのステップ数がどれだけあるかを確認
RMSE.Posylim = 0.1^2;
RMSE.Atiylim = 0.0175^2;
% flg.ylimHoldがtrueのときのplot y範囲
if flg.ylimHold == 1
    ylimHold.p = [-1, 3];
    ylimHold.q = [-0.2, 0.8];
    ylimHold.v = [-3, 4];
    ylimHold.w = [-1.5, 2];
end
if flg.xlimHold == 1
    % xlimHold = [0, 0.5];
    xlimHold = [0,0.5];
end

%% Font size
Fsize.label = 18;
Fsize.lgd = 18;
Fsize.luler = 18;

%% load
HowmanyFile = size(loadfilename,2);
for i = 1:HowmanyFile
    file{i} = load(loadfilename{i});
    file{i}.name = loadfilename{i};
    file{i}.markerSty = ':o';
    file{i}.lgdname.p = {append('$data',num2str(i),'_x$'),append('$data',num2str(i),'_y$'),append('$data',num2str(i),'_z$')};
    file{i}.lgdname.q = {append('$data',num2str(i),'_{roll}$'),append('$data',num2str(i),'_{pitch}$'),append('$data',num2str(i),'_{yaw}$')};
    file{i}.lgdname.v = {append('$data',num2str(i),'_{vx}$'),append('$data',num2str(i),'_{vy}$'),append('$data',num2str(i),'_{vz}$')};
    file{i}.lgdname.w = {append('$data',num2str(i),'_{w1}$'),append('$data',num2str(i),'_{w2}$'),append('$data',num2str(i),'_{w3}$')};
    
    if isfield(file{i}.simResult,'initTindex')
    
    else
        file{i}.simResult.initTindex = 1;
    end

    if i == 1
        indexcheck = file{i}.simResult.initTindex
    elseif indexcheck ~= file{i}.simResult.initTindex
            disp('Caution!! 読み込んだファイルの初期状態が異なっています!!')
            dammy = input('Enterで無視して続行します');
    end
end

%%
% 凡例に特別な名前をつける時はここで指定, ない時は勝手に番号をふります

% file{1}.lgdname.p = {'$\hat{x}$','$\hat{y}$','$\hat{z}$'};
% file{1}.lgdname.q = {'$\hat{\phi}$','$\hat{\theta}$','$\hat{\psi}$'};
% file{1}.lgdname.v = {'$\hat{v_x}$','$\hat{v_y}$','$\hat{v_z}$'};
% file{1}.lgdname.w = {'$\hat{\omega_1}$','$\hat{\omega_2}$','$\hat{\omega_3}$'};

% file{1}.lgdname.q = {'$q_0$','$q_1$','$q_2$','$q_3$'};

file{1}.lgdname.p = {'$\hat{x}_{\rm case1}$','$\hat{y}_{\rm case1}$','$\hat{z}_{\rm case1}$'};
file{1}.lgdname.q = {'$\hat{\phi}_{\rm case1}$','$\hat{\theta}_{\rm case1}$','$\hat{\psi}_{\rm case1}$'};
file{1}.lgdname.v = {'$\hat{v}_{x,{\rm case1}}$','$\hat{v}_{y,{\rm case1}}$','$\hat{v}_{z,{\rm case1}}$'};
file{1}.lgdname.w = {'$\hat{\omega}_{1,{\rm case1}}$','$\hat{\omega}_{2,{\rm case1}}$','$\hat{\omega}_{3,{\rm case1}}$'};
file{2}.lgdname.p = {'$\hat{x}_{\rm case2}$','$\hat{y}_{\rm case2}$','$\hat{z}_{\rm case2}$'};
file{2}.lgdname.q = {'$\hat{\phi}_{\rm case2}$','$\hat{\theta}_{\rm case2}$','$\hat{\psi}_{\rm case2}$'};
file{2}.lgdname.v = {'$\hat{v}_{x,{\rm case2}}$','$\hat{v}_{y,{\rm case2}}$','$\hat{v}_{z,{\rm case2}}$'};
file{2}.lgdname.w = {'$\hat{\omega}_{1,{\rm case2}}$','$\hat{\omega}_{2,{\rm case2}}$','$\hat{\omega}_{3,{\rm case2}}$'};
file{3}.lgdname.p = {'$\hat{x}_{\rm case3}$','$\hat{y}_{\rm case3}$','$\hat{z}_{\rm case3}$'};
file{3}.lgdname.q = {'$\hat{\phi}_{\rm case3}$','$\hat{\theta}_{\rm case3}$','$\hat{\psi}_{\rm case3}$'};
file{3}.lgdname.v = {'$\hat{v}_{x,{\rm case3}}$','$\hat{v}_{y,{\rm case3}}$','$\hat{v}_{z,{\rm case3}}$'};
file{3}.lgdname.w = {'$\hat{\omega}_{1,{\rm case3}}$','$\hat{\omega}_{2,{\rm case3}}$','$\hat{\omega}_{3,{\rm case3}}$'};

columnomber = size(file,2)+1;

% マーカーに特別なものをつける時はここで指定，ない時は':o'になります
file{2}.markerSty = ':s';
file{3}.markerSty = ':*';

dt = file{WhichRef}.simResult.reference.T(2)-file{WhichRef}.simResult.reference.T(1);
tlength = file{1}.simResult.initTindex:file{1}.simResult.initTindex+stepN-1


%% P
figure(1)
% Referenceをplot
plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.p(tlength,:)','LineWidth',2);
% Referenceの凡例をtmpに保存
lgdtmp = {'$x_d$','$y_d$','$z_d$'};
hold on
grid on
% 入力されたファイル数分ループ
for i = 1:HowmanyFile
    % i番目のファイルをplot
    plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(:,1:stepN),file{i}.markerSty,'MarkerSize',6,'LineWidth',2);
    % file{i}に凡例が保存されている場合実行
    if isfield(file{i},'lgdname')
        if isfield(file{i}.lgdname,'p')
            % file{i}の凡例名をtmpに保存
            lgdtmp = [lgdtmp,file{i}.lgdname.p];
        end
    end
end
% xlim, ylimの設定
if flg.xlimHold == 1
    if ~isfield(xlimHold,'p')
        xlim(xlimHold);
    else
        xlim(xlimHold.p);
    end
end
if flg.ylimHold == 1
    if ~isfield(ylimHold,'p')
        ylim(ylimHold);
    else
        ylim(ylimHold.p);
    end
end
% tmpに保存された凡例を表示
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Position','FontSize',Fsize.label);
hold off
% flg. calcFile1RMSE==trueならば rmseを算出
if flg.calcFile1RMSE
    RMSE.P.eachStep = (file{1}.simResult.state.p(:,1:stepN)-file{1}.simResult.reference.est.p(1:stepN,:)').^2;
    RMSE.P.all  = rms(file{1}.simResult.state.p(:,1:stepN)-file{1}.simResult.reference.est.p(1:stepN,:)','all');
    haven = rms(file{1}.simResult.state.p(:,1:stepN)-file{1}.simResult.reference.est.p(1:stepN,:)',2);
    RMSE.P.x = haven(1,:);
    RMSE.P.y = haven(2,:);
    RMSE.P.z = haven(3,:);
    disp('RMSE.P =')
    disp(RMSE.P)
end

%% Q
figure(2)
plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.q(tlength,:)','LineWidth',2);
if size(file{WhichRef}.simResult.reference.est.q(tlength,:)',1) == 3
    lgdtmp = {'$\phi_d$','$\theta_d$','$\psi_d$'};
elseif size(file{WhichRef}.simResult.reference.est.q(tlength,:)',1) == 4
    lgdtmp = {'$q_{0,r}$','$q_{1,r}$','$q_{2,r}$','$q_{3,r}$'};
end
hold on
grid on
for i = 1:HowmanyFile
    plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(:,1:stepN),file{i}.markerSty,'MarkerSize',6,'LineWidth',2);
    if isfield(file{i},'lgdname')
        if isfield(file{i}.lgdname,'q')
            lgdtmp = [lgdtmp,file{i}.lgdname.q];
        end
    end
end
if flg.xlimHold == 1
    if ~isfield(xlimHold,'q')
        xlim(xlimHold);
    else
        xlim(xlimHold.p);
    end
end
if flg.ylimHold == 1
    if ~isfield(ylimHold,'q')
        ylim(ylimHold);
    else
        ylim(ylimHold.q);
    end
end
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Attitude','FontSize',Fsize.label);

hold off
% rmseの算出
if flg.calcFile1RMSE
    RMSE.Q.eachStep = (file{1}.simResult.state.q(:,1:stepN)-file{1}.simResult.reference.est.p(1:stepN,:)').^2;
    RMSE.Q.all  = rms(file{1}.simResult.state.q(:,1:stepN)-file{1}.simResult.reference.est.p(1:stepN,:)','all');
    haven = rms(file{1}.simResult.state.q(:,1:stepN)-file{1}.simResult.reference.est.p(1:stepN,:)',2);
    RMSE.Q.x = haven(1,:);
    RMSE.Q.y = haven(2,:);
    RMSE.Q.z = haven(3,:);
    disp('RMSE.Q =')
    disp(RMSE.Q)
end

%% V
figure(3)
plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.v(tlength,:)','LineWidth',2);
lgdtmp = {'$v_{xd}$','$v_{yd}$','$v_{zd}$'};
hold on
grid on
for i = 1:HowmanyFile
    plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(:,1:stepN),file{i}.markerSty,'MarkerSize',6,'LineWidth',2);
    if isfield(file{i},'lgdname')
        if isfield(file{i}.lgdname,'v')
            lgdtmp = [lgdtmp,file{i}.lgdname.v];
        end
    end
end
if flg.xlimHold == 1
    if ~isfield(xlimHold,'v')
        xlim(xlimHold);
    else
        xlim(xlimHold.v);
    end
end
if flg.ylimHold == 1
    if ~isfield(ylimHold,'v')
        ylim(ylimHold);
    else
        ylim(ylimHold.v);
    end
end
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Velocity','FontSize',Fsize.label);
lgd.NumColumns = columnomber;

hold off
% rmseの算出
if flg.calcFile1RMSE
    RMSE.V.eachStep = (file{1}.simResult.state.v(:,1:stepN)-file{1}.simResult.reference.est.v(1:stepN,:)').^2;
    RMSE.V.all  = rms(file{1}.simResult.state.v(:,1:stepN)-file{1}.simResult.reference.est.v(1:stepN,:)','all');
    haven = rms(file{1}.simResult.state.v(:,1:stepN)-file{1}.simResult.reference.est.v(1:stepN,:)',2);
    RMSE.V.x = haven(1,:);
    RMSE.V.y = haven(2,:);
    RMSE.V.z = haven(3,:);
    disp('RMSE.V =')
    disp(RMSE.V)
end

%% W
figure(4)
% lgd = ('$\omega_{\phi d}$','$\omega_{\theta d}$','$\omega_{\psi d}$','$\hat{\omega}_\phi$','$\hat{\omega}_\theta$','$\hat{\omega}_\psi$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.w(tlength,:)','LineWidth',2);
lgdtmp = {'$\omega_{1 d}$','$\omega_{2 d}$','$\omega_{3 d}$'};
hold on
grid on
for i = 1:HowmanyFile
    plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(:,1:stepN),file{i}.markerSty,'MarkerSize',6,'LineWidth',2);
    if isfield(file{i},'lgdname')
        if isfield(file{i}.lgdname,'w')
            lgdtmp = [lgdtmp,file{i}.lgdname.w];
        end
    end
end
if flg.xlimHold == 1
    if ~isfield(xlimHold,'w')
        xlim(xlimHold);
    else
        xlim(xlimHold.w);
    end
end
if flg.ylimHold == 1
    if ~isfield(ylimHold,'w')
        ylim(ylimHold);
    else
        ylim(ylimHold.w);
    end
end
set(gca,'FontSize',Fsize.luler);
xlabel('time [sec]','FontSize',Fsize.label);
ylabel('Angular Velocity','FontSize',Fsize.label);
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;

hold off

% rmseの算出
if flg.calcFile1RMSE
    RMSE.W.eachStep = (file{1}.simResult.state.w(:,1:stepN)-file{1}.simResult.reference.est.w(1:stepN,:)').^2;
    RMSE.W.all  = rms(file{1}.simResult.state.w(:,1:stepN)-file{1}.simResult.reference.est.w(1:stepN,:)','all');
    haven = rms(file{1}.simResult.state.w(:,1:stepN)-file{1}.simResult.reference.est.w(1:stepN,:)',2);
    RMSE.W.x = haven(1,:);
    RMSE.W.y = haven(2,:);
    RMSE.W.z = haven(3,:);
    disp('RMSE.W =')
    disp(RMSE.W)
end

%% RSE 各ステップにおける誤差二乗のプロット
% if flg.calcFile1RMSE
%     figure(5)
%     p1 = plot(0:stepN-1,RMSE.P.eachStep','.','MarkerSize',15);
%     set(gca,'FontSize',Fsize.luler);
%     xlim([0, stepN-1])
%     ylim([0, RMSE.Posylim])
%     grid on
%     xlabel('Step','FontSize',Fsize.label);
%     ylabel('Position RSE','FontSize',Fsize.label);
%     lgd = legend('$(\hat{x}-x_d)^2$','$(\hat{y}-y_d)^2$','$(\hat{z}-z_d)^2$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
% 
%     figure(6)
%     p1 = plot(0:stepN-1,RMSE.Q.eachStep','.','MarkerSize',15);
%     set(gca,'FontSize',Fsize.luler);
%     xlim([0, stepN-1])
%     ylim([0, RMSE.Atiylim])
%     grid on
%     xlabel('Step','FontSize',Fsize.label);
%     ylabel('Atitiude RSE','FontSize',Fsize.label);
%     lgd = legend('$(\hat{\phi}-\phi_d)^2$','$(\hat{\theta}-\theta_d)^2$','$(\hat{\psi}-\psi_d)^2$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
% 
%     figure(7)
%     p1 = plot(0:stepN-1,RMSE.V.eachStep','.','MarkerSize',15);
%     set(gca,'FontSize',Fsize.luler);
%     xlim([0, stepN-1])
%     ylim([0, RMSE.Posylim])
%     grid on
%     xlabel('Step','FontSize',Fsize.label);
%     ylabel('Velocity RSE','FontSize',Fsize.label);
%     lgd = legend('$(\hat{v_x}-v_{xd})^2$','$(\hat{v_y}-v_{yd})^2$','$(\hat{v_z}-v_{zd})^2$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
% 
%     figure(8)
%     p1 = plot(0:stepN-1,RMSE.W.eachStep','.','MarkerSize',15);
%     set(gca,'FontSize',Fsize.luler);
%     xlim([0, stepN-1])
%     ylim([0, RMSE.Atiylim])
%     grid on
%     xlabel('Step','FontSize',Fsize.label);
%     ylabel('Angular Velocity RSE','FontSize',Fsize.label);
%     lgd = legend('($\hat{\omega}_\theta-\omega_{\theta d})^2$','$(\hat{\omega}_\phi-\omega_{\phi d})^2$','$(\hat{\omega}_\psi-\omega_{\psi d})^2$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
% end