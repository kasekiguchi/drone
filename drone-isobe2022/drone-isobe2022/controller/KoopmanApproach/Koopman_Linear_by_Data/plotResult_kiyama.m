%% initialize
clear all
close all

%% flag
flg.calcFile1RMSE = 1; % file{1}に読み込んだデータのRMSEを求める
flg.ylimHold = 0; % 指定した値にylimを固定
flg.xlimHold = 1; % 指定した値にxlimを固定

%% select file to load
% filename = agent.id.filename;
% a = append(filename,'.mat');
% loadfilename{1} = append(agent.id.filename,'.mat');

loadfilename{1} = 'EstimationResult_12state_6_26_circle=circle_estimation=circle.mat' ;%mainで書き込んだファイルの名前に逐次変更する
loadfilename{2} = 'EstimationResult_12state_6_26_circle=flight_estimation=circle.mat';
% loadfilename{3} = 'EstimationResult_12state_6_20_circle__test_InputandConst_ByLinear.mat';

% loadfilename{1} = 'test1.mat';
% loadfilename{2} = 'test2.mat';

WhichRef = 1; % どのファイルをリファレンスに使うか

%% plot range
%何ステップまで表示するか
%ステップ数とxlinHoldの幅を変えればグラフの長さを変えられる
% stepN = 501;
stepN = 51; %検証用シミュレーションのステップ数がどれだけあるかを確認,これを変えると出力時間が伸びる
RMSE.Posylim = 0.1^2;
RMSE.Atiylim = 0.0175^2;
% flg.ylimHoldがtrueのときのplot y範囲
if flg.ylimHold == 1
    ylimHold.p = [-1.5, 1.5];
    ylimHold.q = [-0.2, 0.8];
    ylimHold.v = [-3, 4];
    ylimHold.w = [-1.5, 2];
end
if flg.xlimHold == 1
    % xlimHold = [0, 0.5];
    xlimHold = [0,0.8];
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
    % file{i}.markerSty = ':o';
    file{i}.markerSty = '';
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

dt = file{WhichRef}.simResult.reference.T(2)-file{WhichRef}.simResult.reference.T(1);
tlength = file{1}.simResult.initTindex:file{1}.simResult.initTindex+stepN-1;

newcolors = [0 0.4470 0.7410
             1.9500 0.4250 0.1980
             0.4660 0.6740 0.1880];
%% P
newcolors = [0 0.4470 0.7410
             0.9900 0 0
             0.3660 0.6740 0.1880];

figure(1)
% Referenceをplot
colororder(newcolors)
plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.p(tlength,2)','LineWidth',2);
% Referenceの凡例をtmpに保存
% lgdtmp = {'$x_d$','$y_d$','$z_d$'};
lgdtmp = {'$z_d$','$\hat{z}_{\rm case1}$','$\hat{z}_{\rm case2}$'};
hold on
grid on
% 入力されたファイル数分ループ
for i = 1:HowmanyFile
    % i番目のファイルをplot
    if i == 1
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(2,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
    elseif i == 2
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(2,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':');
    elseif i == 3
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(3,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',1,'LineStyle','-.');
    end
%       plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(:,1:stepN),'LineWidth',2);
%     plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.p(:,1:stepN),file{i}.markerSty,'MarkerSize',6,'LineWidth',2);
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
ylabel('Position z','FontSize',Fsize.label);
hold off

%% Q
figure(2)
newcolors = [0 0.4470 0.7410
             0.9900 0 0
             0.3660 0.6740 0.1880];
colororder(newcolors)
plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.q(tlength,3)','LineWidth',1);
% if size(file{WhichRef}.simResult.reference.est.q(tlength,:)',1) == 3
%     lgdtmp = {'$\phi_d$','$\theta_d$','$\psi_d$'};
% elseif size(file{WhichRef}.simResult.reference.est.q(tlength,:)',1) == 4
%     lgdtmp = {'$q_{0,r}$','$q_{1,r}$','$q_{2,r}$','$q_{3,r}$'};
% end
lgdtmp = {'$\psi_d$','$\hat{\psi}_{\rm case1}$','$\hat{\psi}_{\rm case2}$'};
hold on
grid on
for i = 1:HowmanyFile
    if i == 1
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(3,1:stepN),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
    elseif i == 2
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(3,1:stepN),file{i}.markerSty,'MarkerSize',10,'LineWidth',3,'LineStyle',':');
    elseif i == 3
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(3,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',1,'LineStyle','-.');
    end
%     plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.q(:,1:stepN),file{i}.markerSty,'MarkerSize',6,'LineWidth',2);
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
ylabel('Attitude \psi','FontSize',Fsize.label);

hold off

%% V
figure(3)
newcolors = [0 0.4470 0.7410
             0.9900 0 0
             0.3660 0.6740 0.1880];
colororder(newcolors)
plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.v(tlength,2)','LineWidth',1);
lgdtmp = {'$v_{yd}$','$\hat{v}_{y,{\rm case1}}$','$\hat{v}_{y,{\rm case2}}$'};
hold on
grid on
for i = 1:HowmanyFile
    if i == 1
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(2,1:stepN),file{i}.markerSty,'MarkerSize',7,'LineWidth',2,'LineStyle','--');
    elseif i == 2
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(2,1:stepN),file{i}.markerSty,'MarkerSize',7,'LineWidth',3,'LineStyle',':');
    elseif i == 3
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(2,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',1,'LineStyle','-.');
    end
%     plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.v(:,1:stepN),file{i}.markerSty,'MarkerSize',6,'LineWidth',2);
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
ylabel('Velocity v_y','FontSize',Fsize.label);
lgd.NumColumns = columnomber;

hold off

%% W
figure(4)
newcolors = [0 0.4470 0.7410
             0.9900 0 0
             0.3660 0.6740 0.1880];
colororder(newcolors)
% lgd = ('$\omega_{\phi d}$','$\omega_{\theta d}$','$\omega_{\psi d}$','$\hat{\omega}_\phi$','$\hat{\omega}_\theta$','$\hat{\omega}_\psi$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
plot(file{WhichRef}.simResult.reference.T(tlength),file{WhichRef}.simResult.reference.est.w(tlength,3)','LineWidth',1);
lgdtmp = {'$\omega_{3 d}$','$\hat{\omega}_{3,{\rm case1}}$','$\hat{\omega}_{3,{\rm case2}}$'};
hold on
grid on
for i = 1:HowmanyFile
    if i == 1
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(3,1:stepN),file{i}.markerSty,'MarkerSize',7,'LineWidth',2,'LineStyle','--');
    elseif i == 2
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(3,1:stepN),file{i}.markerSty,'MarkerSize',7,'LineWidth',3,'LineStyle',':');
    elseif i == 3
        plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(3,1:stepN),file{i}.markerSty,'MarkerSize',12,'LineWidth',1,'LineStyle','-.');
    end
%     plot(file{i}.simResult.T(1:stepN) , file{i}.simResult.state.w(:,1:stepN),file{i}.markerSty,'MarkerSize',6,'LineWidth',2);
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
ylabel('Angular Velocity \omega_{3 d}','FontSize',Fsize.label);
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;

hold off
