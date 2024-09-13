%% initialize
%位置，姿勢角，速度，角速度の推定結果を表示するためのプログラム
%一つのグラフにまとめて表示される(例：位置x,y,zが一つのfigureに表示)
clear all
close all
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../')); % droneまでのフォルダパス
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);

% cd(strcat(fileparts(matlab.desktop.editor.getActive().Filename), '../../../')); % drone/のこと
%% flag
flg.ylimHold = 0; % 指定した値にylimを固定
flg.xlimHold = 1; % 指定した値にxlimを固定 0~0.8などに固定
flg.division = 0; % plotResult_division仕様にするか
flg.confirm_ref = 1; % リファレンスに設定した軌道の確認
flg.rmse = 0; % subplotにRMSE表示
flg.only_rmse = 0; % コマンドウィンドウに表示
flg.without_pos = 0; % 観測量に位置が含まれているかどうか 
% 要注意 基本は"0"
save_fig = 0;     % 1：出力したグラフをfigで保存する
flg.figtype = 0;  % 1 => figureをそれぞれ出力 / 0 => subplotで出力

startTime = 8; % flight後何秒からの推定精度検証を行うか saddle:3.39
stepnum = 0; % 0:0.5s, 1:0.8s, 2:1.5s, 3:2.0s

if ~flg.rmse && ~flg.confirm_ref; m = 2; n = 2;
else;                             m = 2; n = 3; end
%% select file to load
%出力するグラフを選択(最大で3つのデータを同一のグラフに重ねることが可能)
% 木山データ; Kiyama
% x方向データの増加; KiyamaX20
mode.code = '00';
mode.training_data = 'Kiyama';
% mode.training_data = 'KiyamaX20'; 
% mode.training_data = 'KiyamaX20fromVel';
ref_tra = 'saddle'; 
loadfilename{1} = WhichLoadFile(ref_tra, 1, mode);

loadfilename{1} = '2024-09-12_Exp_Kiyama_code11_saddle';
% loadfilename{1} = '2024-08-06_Exp_KiyamaY20_code00_saddle';
% loadfilename{1} = '2024-08-07_Exp_KiyamaY20_code08_saddle';
% % loadfilename{1} = '2024-07-14_Exp_KiyamaX20_code00_saddle';
% loadfilename{1} = '2024-09-03_Exp_Kiyama_XY_20data_code00_saddle';
% loadfilename{1} = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';

% loadfilename{1} = 'EstimationResult_2024-07-01_Exp_Kiyama_code00_optim_3_saddle_100k'; %100000回
% loadfilename{1} = 'EstimationResult_2024-07-10_Exp_Kiyama_code08_optim_2_saddle'; %90万回
% loadfilename{1} = 'EstimationResult_2024-07-10_Exp_Kiyama_code00_optim_L1norm_saddle'; %90万回 L1ノルムのみ
% loadfilename{1} = 'EstimationResult_2024-07-02_Exp_Kiyama_fromVel_code00_optim_1_saddle_100k'; %100k
% loadfilename{1} = '2024-07-12_Exp_Kiyama_code00_5times_saddle';
% loadfilename{1} = '2024-07-14_Exp_Kiyama_code08_normalize_saddle';
% loadfilename{1} = 'EstimationResult_Kiyama_reproduction';

% file2 : 別のリファレンス
% ref_tra = 'P2Py';
% loadfilename{2} = WhichLoadFile(ref_tra, 1, []);
% loadfilename{2} = 'EstimationResult_2024-05-24_Exp_Kiyama_code00_P2Px';
% loadfilename{2} = 'EstimationResult_2024-05-24_Exp_Kiyama_code00_P2Py';
% loadfilename{2} = 'EstimationResult_2024-05-27_Exp_Kiyama_code01_hovering';
% loadfilename{2} = 'EstimationResult_2024-05-27_Exp_Kiyama_code06_saddle';

WhichRef = 2; % 出力するデータの中で，どのファイルをリファレンスに使うか(基本変更しなくてよい)
if size(loadfilename,2) == 1 % fileが1つならWhichRefを変更
    WhichRef = 1;
end
disp(loadfilename{1});
%% グラフの保存
% "現在のフォルダー"をmainGUIの階層したか確認
if save_fig && flg.figtype % Graphフォルダ内に保存 .figで保存
    name = strcat(loadfilename{1},'_3point39s'); %ファイル名
%     folderName = loadfilename{1}; 
    cd('./Koopman_Linearization/Figure_output/');
    folderName = loadfilename{1}; %フォルダ名
    if isfolder(folderName); save_fig = 0; 
        warning('Stop saving figure because exist same name folder'); % すでにフォルダーがある場合は保存をやめる
    else; mkdir(folderName) %新規フォルダ作成
    end
end

%% plot range
%何ステップまで表示するか
%ステップ数とxlinHoldの幅を変えればグラフの長さを変えられる
% stepN = 121; %検証用シミュレーションのステップ数がどれだけあるかを確認,これを変えると出力時間が伸びる
RMSE.Posylim = 0.1^2;
RMSE.Atiylim = 0.0175^2;

% stepnum = 3; %ステップ数，xの範囲を設定 default: 1
if stepnum == 0
    stepN = 31;
    if flg.xlimHold == 1
        xlimHold = [0,0.5];
    end
    xmax = 0.5;
elseif stepnum == 1
    stepN = 55;
    if flg.xlimHold == 1
        xlimHold = [0,0.8];
    end
    xmax = 0.8;
elseif stepnum == 2
    stepN = 91;
    if flg.xlimHold == 1
        xlimHold = [0,1.5];
    end
    xmax = 1.5;
else
    stepN = 121;
    if flg.xlimHold == 1
        xlimHold = [0,2];
    end
    xmax = 2;
end

% flg.ylimHoldがtrueのときのplot y範囲
if flg.ylimHold == 1
    ylimHold.p = [-1.5, 1.5];
    ylimHold.q = [-0.2, 0.8];
    ylimHold.v = [-3, 4];
    ylimHold.w = [-1.5, 2];
end

%% Font size(グラフの軸ラベルや凡例の大きさを調整できる)
Fsize.label = 18;
Fsize.lgd = 18;
Fsize.luler = 18;

%% load(基本いじる必要は無い)
HowmanyFile = size(loadfilename,2);
for i = 1:HowmanyFile
file{i} = load(loadfilename{i});
file{i}.name = loadfilename{i};
file{i}.lgdname.p = {append('$data',num2str(i),'_x$'),append('$data',num2str(i),'_y$'),append('$data',num2str(i),'_z$')};
file{i}.lgdname.q = {append('$data',num2str(i),'_{roll}$'),append('$data',num2str(i),'_{pitch}$'),append('$data',num2str(i),'_{yaw}$')};
file{i}.lgdname.v = {append('$data',num2str(i),'_{vx}$'),append('$data',num2str(i),'_{vy}$'),append('$data',num2str(i),'_{vz}$')};
file{i}.lgdname.w = {append('$data',num2str(i),'_{w1}$'),append('$data',num2str(i),'_{w2}$'),append('$data',num2str(i),'_{w3}$')};

if ~isfield(file{i}.simResult,'initTindex')
    file{i}.simResult.initTindex = 1;
end

if i == 1
    indexcheck = file{i}.simResult.initTindex
elseif indexcheck ~= file{i}.simResult.initTindex
        disp('Caution!! 読み込んだファイルの初期状態が異なっています!!')
        dammy = input('Enterで無視して続行します');
end
end

%% 任意の時間からの推定を行う
try
F = @quaternions_all; % 読み込んだデータと観測量を合わせる
% 実験データがreferenceになっている場合、dtは時刻によって様々に変化する
% dt = file{WhichRef}.simResult.reference.T(2)-file{WhichRef}.simResult.reference.T(1);
dt = diff(file{WhichRef}.simResult.reference.T);
% startTimeを超えたインデックスからstepNステップ
startIdx = find(file{WhichRef}.simResult.reference.T>=startTime, 1, 'first');
tlength = file{WhichRef}.simResult.initTindex + startIdx:file{WhichRef}.simResult.initTindex+stepN-1 + startIdx;
simResult.Z(:,startIdx) = F(file{WhichRef}.simResult.reference.X(:,startIdx)); %検証用データの初期値を観測量に通して次元を合わせてる
simResult.Xhat(:,startIdx) = file{WhichRef}.simResult.reference.X(:,startIdx);
for j = startIdx:startIdx+stepN
    simResult.Z(:,j+1) = file{1}.est.A * simResult.Z(:,j) + file{1}.est.B * file{WhichRef}.simResult.U(:,j); 
    if flg.without_pos
        dt = file{WhichRef}.simResult.reference.T(j+1) - file{WhichRef}.simResult.reference.T(j);
        simResult.Xhat(4:end,j+1) = file{1}.est.C * simResult.Z(:,j+1);
        simResult.Xhat(1:3,j+1) = simResult.Xhat(1:3,j) + dt * simResult.Xhat(7:9,j+1);
    else
        simResult.Xhat(:,j+1) = file{1}.est.C * simResult.Z(:,j+1);
    end
end
% simResult.Xhat = file{1}.est.C * simResult.Z;

% 読み込んだ情報(file{i}.simResult.state)の書き換え 
if size(file{1}.Data.X,1)==13
    file{1}.simResult.state.p = simResult.Xhat(1:3,:);
    file{1}.simResult.state.q = simResult.Xhat(4:7,:);
    file{1}.simResult.state.v = simResult.Xhat(8:10,:);
    file{1}.simResult.state.w = simResult.Xhat(11:13,:);
else
    file{1}.simResult.state.p = simResult.Xhat(1:3,:);
    file{1}.simResult.state.q = simResult.Xhat(4:6,:);
    file{1}.simResult.state.v = simResult.Xhat(7:9,:);
    file{1}.simResult.state.w = simResult.Xhat(10:12,:);
end
catch
    open("quaternions_all.m");
    error('Number of observales is different.');
end
%% 時間の設定 [0, 0.8]等の time[sec]を設定できるようにする
if ~flg.xlimHold
    timeRange = file{WhichRef}.simResult.reference.T(tlength);
else
    timeRange = linspace(0, xmax, stepN);
    % timeRange = file{WhichRef}.simResult.reference.T(tlength) - startTime;
end
%%
% 凡例に特別な名前をつける時はここで指定, ない時は勝手に番号をふります
file{1}.lgdname.p = {'$\hat{x}_{\rm case1}$','$\hat{y}_{\rm case1}$','$\hat{z}_{\rm case1}$'};
file{1}.lgdname.q = {'$\hat{\phi}_{\rm case1}$','$\hat{\theta}_{\rm case1}$','$\hat{\psi}_{\rm case1}$'};
file{1}.lgdname.v = {'$\hat{v}_{x,{\rm case1}}$','$\hat{v}_{y,{\rm case1}}$','$\hat{v}_{z,{\rm case1}}$'};
file{1}.lgdname.w = {'$\hat{\omega}_{1,{\rm case1}}$','$\hat{\omega}_{2,{\rm case1}}$','$\hat{\omega}_{3,{\rm case1}}$'};

columnomber = size(file,2)+1;

% マーカーに特別なものをつける時はここで指定
file{1}.markerSty = ':o'; % 点線と丸印

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880]; %グラフの色指定

%% Calculate RMSE
i = 1;
% rmse関数でも大丈夫．rmse(予測値, 観測値, 2) = [3*1](=x,y,z)
rmse_func = @(x) sqrt(sum(x.^2, 2)/stepN);
% position
error_p = file{i}.simResult.state.p(:,tlength) - file{WhichRef}.simResult.reference.est.p(tlength,:)';
result.p.rmse = rmse(file{i}.simResult.state.p(:,tlength), file{WhichRef}.simResult.reference.est.p(tlength,:)', 2);
% velocity
error_v = file{i}.simResult.state.v(:,tlength) - file{WhichRef}.simResult.reference.est.v(tlength,:)';
result.v.rmse = rmse(file{i}.simResult.state.v(:,tlength), file{WhichRef}.simResult.reference.est.v(tlength,:)',2);
% attitude
error_q = file{i}.simResult.state.q(:,tlength) - file{WhichRef}.simResult.reference.est.q(tlength,:)';
result.q.rmse = rmse(file{i}.simResult.state.q(:,tlength), file{WhichRef}.simResult.reference.est.q(tlength,:)',2);
% angular velocity
error_w = file{i}.simResult.state.w(:,tlength) - file{WhichRef}.simResult.reference.est.w(tlength,:)';
result.w.rmse = rmse(file{i}.simResult.state.w(:,tlength), file{WhichRef}.simResult.reference.est.w(tlength,:)',2);

% result.p.rmse = rmse_func(error_p);
% result.v.rmse = rmse_func(error_v); 
% result.q.rmse = rmse_func(error_q);
% result.w.rmse = rmse_func(error_w);

% result_rmse = get_rmse(file{1}, tlength);

% file{1}.simResult.state.p
% file{WhichRef}.simResult.reference.est.p
%%
% plot(timeRange, error_p);
%%
Co = ctrb(file{1}.est.A,file{1}.est.B);
Ob = obsv(file{1}.est.A,file{1}.est.C);
fprintf("file: %s \n", strcat(strrep(loadfilename{1},'EstimationResult_2024-','')));
fprintf("Number of Observables: %d \n", size(simResult.Z(:,1),1));
fprintf("Number of Control rank: %d \n", rank(Co));
fprintf("Estimation begin time: %.4f \n", startTime);
fprintf("Estimation time: %.2f \n", xmax);
fprintf("Position RMSE : x=%.4f, y=%.4f, z=%.4f \n", result.p.rmse(1), result.p.rmse(2), result.p.rmse(3));
fprintf("Velocity RMSE : vx=%.4f, vy=%.4f, vz=%.4f \n", result.v.rmse(1), result.v.rmse(2), result.v.rmse(3));
fprintf("Attitude RMSE : roll=%.4f, pitch=%.4f, yaw=%.4f \n", result.q.rmse(1), result.q.rmse(2), result.q.rmse(3));
fprintf("Attitude angular vel. RMSE : roll=%.4f, pitch=%.4f, yaw=%.4f \n", result.w.rmse(1), result.w.rmse(2), result.w.rmse(3));

fprintf("====================================\n");
result.p.mape = mape(file{i}.simResult.state.p(:,tlength), file{WhichRef}.simResult.reference.est.p(tlength,:)',2);
fprintf("Position MAPE : x=%.4f, y=%.4f, z=%.4f \n", result.p.mape(1), result.p.mape(2), result.p.mape(3))

disp(["p_max: "+ num2str(round(max(error_p, [], 2)',5))]);
disp(["v_max: "+ num2str(round(max(error_v, [], 2)',5))]);
disp(["q_max: "+ num2str(round(max(error_q, [], 2)',5))]);
disp(["w_max: "+ num2str(round(max(error_w, [], 2)',5))]);
if flg.only_rmse
    % dammy
    fprintf("Excel RMSE.P: %.4f %.4f %.4f \n", result.p.rmse(1), result.p.rmse(2), result.p.rmse(3));
else
if ~flg.division % plotResult
i = 1;
%% P
% strrep _を "【空白】"に置換
fig_title = strcat(strrep(loadfilename{1},'_',' '),'==startTime : ',num2str(startTime), 's==', ref_tra);
% fig_title = '';
if flg.figtype; figure(1);
else; fig = figure(1); sgtitle(fig_title); subplot(m,n,1); end 
% Referenceをplot
colororder(newcolors)
plot(timeRange, file{WhichRef}.simResult.reference.est.p(tlength,:)','LineWidth',2); % 精度検証用データ
% Referenceの凡例をtmpに保存
lgdtmp = {'$x_d$','$y_d$','$z_d$'};
hold on
grid on
% 推定したA, B, Cを使った状態推定の結果
% 入力されたファイル数分ループ
plot(timeRange, file{1}.simResult.state.p(:,tlength),file{i}.markerSty,'MarkerSize',7,'LineWidth',1,'LineStyle','--');
% file{i}に凡例が保存されている場合実行
if isfield(file{1},'lgdname')
    if isfield(file{1}.lgdname,'p')
        % file{i}の凡例名をtmpに保存
        lgdtmp = [lgdtmp,file{1}.lgdname.p];
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
ylabel('Position [m]','FontSize',Fsize.label);
hold off

if save_fig && flg.figtype
    cd(folderName)
    savefig(strcat('Position_',name));
    saveas(1,strcat('Position_',name,'.jpg'));
end

%% Q
if flg.figtype; figure(2);
else; subplot(m,n,2); end
colororder(newcolors)
plot(timeRange, file{WhichRef}.simResult.reference.est.q(tlength,:)','LineWidth',2);
if size(file{WhichRef}.simResult.reference.est.q(tlength,:)',1) == 3
    lgdtmp = {'$\phi_d$','$\theta_d$','$\psi_d$'};
elseif size(file{WhichRef}.simResult.reference.est.q(tlength,:)',1) == 4
    lgdtmp = {'$q_{0,r}$','$q_{1,r}$','$q_{2,r}$','$q_{3,r}$'};
end
hold on
grid on

plot(timeRange , file{i}.simResult.state.q(:,tlength),file{i}.markerSty,'MarkerSize',7,'LineWidth',1,'LineStyle','--');

if isfield(file{i},'lgdname')
    if isfield(file{i}.lgdname,'q')
        lgdtmp = [lgdtmp,file{i}.lgdname.q];
    end
end

if flg.xlimHold == 1
    if ~isfield(xlimHold,'q')
        xlim(xlimHold);
    else
        xlim(xlimHold.q); % xlimHold.pになっていた
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
ylabel('Attitude [rad]','FontSize',Fsize.label);
hold off

if save_fig && flg.figtype
    savefig(strcat('Attitude_',name));
    saveas(2,strcat('Attitude_',name,'.jpg'));
end

%% V
if flg.figtype; figure(3);
else; subplot(m,n,3); end
colororder(newcolors)
plot(timeRange, file{WhichRef}.simResult.reference.est.v(tlength,:)','LineWidth',2);
lgdtmp = {'$v_{xd}$','$v_{yd}$','$v_{zd}$'};
hold on
grid on

plot(timeRange , file{i}.simResult.state.v(:,tlength),file{i}.markerSty,'MarkerSize',7,'LineWidth',1,'LineStyle','--');

if isfield(file{i},'lgdname')
    if isfield(file{i}.lgdname,'v')
        lgdtmp = [lgdtmp,file{i}.lgdname.v];
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
ylabel('Velocity [m/s]','FontSize',Fsize.label);
lgd.NumColumns = columnomber;
hold off

if save_fig && flg.figtype
    savefig(strcat('Velocity_',name));
    saveas(3,strcat('Velocity_',name,'.jpg'));
end

%% W
if flg.figtype; figure(4);
else; subplot(m,n,4); end
colororder(newcolors)
% lgd = ('$\omega_{\phi d}$','$\omega_{\theta d}$','$\omega_{\psi d}$','$\hat{\omega}_\phi$','$\hat{\omega}_\theta$','$\hat{\omega}_\psi$','FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
plot(timeRange, file{WhichRef}.simResult.reference.est.w(tlength,:)','LineWidth',2);
lgdtmp = {'$\omega_{1 d}$','$\omega_{2 d}$','$\omega_{3 d}$'};
hold on
grid on
plot(timeRange, file{i}.simResult.state.w(:,tlength),file{i}.markerSty,'MarkerSize',7,'LineWidth',1,'LineStyle','--');

if isfield(file{i},'lgdname')
    if isfield(file{i}.lgdname,'w')
        lgdtmp = [lgdtmp,file{i}.lgdname.w];
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
ylabel('Angular Velocity [rad/s]','FontSize',Fsize.label);
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
hold off

if save_fig && flg.figtype
    savefig(strcat('Angular velocity_',name));
    saveas(4,strcat('Angular velocity_',name,'.jpg'));
end

%% referenceの確認
if flg.confirm_ref
    if flg.figtype; figure(5);
    else; subplot(m, n, 5); end
    plot(file{WhichRef}.simResult.reference.T, file{WhichRef}.simResult.reference.X(1:3,:), 'LineWidth', 2); hold on;
    xregion(startTime, startTime + xmax, FaceColor="b",EdgeColor=[0.4 0 0.7]);
    legend('x', 'y', 'z', 'verification range', 'Location', 'southeast', 'FontSize', 12); grid on;
    xlabel('Time [s]', 'FontSize', 15);
    ylabel('Position [m]', 'FontSize', 15);
    % daspect([1 1 1]);

    subplot(m, n, 6);
    plot3(file{WhichRef}.simResult.reference.X(1,:), file{WhichRef}.simResult.reference.X(2,:), file{WhichRef}.simResult.reference.X(3,:), '--', 'LineWidth', 2);
    xlabel('$$x$$', 'Interpreter', 'latex', 'FontSize', 25);
    ylabel('$$y$$', 'Interpreter', 'latex', 'FontSize', 25);
    zlabel('$$z$$', 'Interpreter', 'latex', 'FontSize', 25);
    grid on; hold on;
    % daspect([1 1 1]);

    % figure(11);
    plot3(file{WhichRef}.simResult.reference.X(1,tlength), file{WhichRef}.simResult.reference.X(2,tlength), file{WhichRef}.simResult.reference.X(3,tlength), 'LineWidth', 2, 'Color', 'red');
    xlabel('$$x$$', 'Interpreter', 'latex', 'FontSize', 25);
    ylabel('$$y$$', 'Interpreter', 'latex', 'FontSize', 25);
    zlabel('$$z$$', 'Interpreter', 'latex', 'FontSize', 25);
    hold off;
end

%% RMSE
if ~flg.figtype && flg.rmse; subplot(m,n,6)
FS = 12;
text(0.05,0.9,strcat('RMSE.p = ', num2str(result.p.rmse,3)),'FontSize',FS, 'Units','normalized');
text(0.05,0.6,strcat('RMSE.v = ', num2str(result.v.rmse,3)),'FontSize',FS, 'Units','normalized');
text(0.05,0.3,strcat('RMSE.q = ', num2str(result.q.rmse,3)),'FontSize',FS, 'Units','normalized');
text(0.4, 0.9,strcat('MAX.p = ', num2str(result.p.max,3)),'FontSize',FS, 'Units','normalized');
text(0.4, 0.6,strcat('MAX.v = ', num2str(result.v.max,3)),'FontSize',FS, 'Units','normalized');
text(0.4, 0.3,strcat('MAX.q = ', num2str(result.q.max,3)),'FontSize',FS, 'Units','normalized');
text(0.75, 0.9,strcat('MIN.p = ', num2str(result.p.min,3)),'FontSize',FS, 'Units','normalized');
text(0.75, 0.6,strcat('MIN.v = ', num2str(result.v.min,3)),'FontSize',FS, 'Units','normalized');
text(0.75, 0.3,strcat('MIN.q = ', num2str(result.q.min,3)),'FontSize',FS, 'Units','normalized');
end
%%
if ~flg.figtype; fig.WindowState = 'maximized'; end

else % plotResult_division

for graph_num = 1:3 % 1 = x, 2 = y, 3 = z
    figure(graph_num)
    colororder(newcolors)
    plot(timeRange,file{WhichRef}.simResult.reference.est.p(tlength,graph_num)','LineWidth',2);
    hold on
    grid on
    if graph_num == 1
        plot(timeRange , file{i}.simResult.state.p(graph_num,tlength),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$x_{d}$','$\hat{x}_{case1}$','$\hat{x}_{\rm case2}$','$\hat{x}_{\rm case3}$','$\hat{x}_{\rm case4}$','$\hat{x}_{\rm case5}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
        ylabel('Position x [m]','FontSize',Fsize.label,'Interpreter','latex');
    elseif graph_num == 2
        plot(timeRange , file{i}.simResult.state.p(graph_num,tlength),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$y_{d}$','$\hat{y}_{case1}$','$\hat{y}_{\rm case2}$','$\hat{y}_{\rm case3}$','$\hat{y}_{\rm case4}$','$\hat{y}_{\rm case5}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
        ylabel('Position y [m]','FontSize',Fsize.label,'Interpreter','latex');
    elseif graph_num == 3
        plot(timeRange , file{i}.simResult.state.p(graph_num,tlength),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$z_{d}$','$\hat{z}_{case1}$','$\hat{z}_{\rm case2}$','$\hat{z}_{\rm case3}$','$\hat{z}_{\rm case4}$','$\hat{z}_{\rm case5}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
        ylabel('Position z [m]','FontSize',Fsize.label,'Interpreter','latex');
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
        if ~isfield(ylimHold,'p') % ylimHold.pがなかったら
            ylim(ylimHold);
        else
            ylim(ylimHold.p1);
        end
    end
    hold off
end

%% Q
for graph_num = 1:3 
    figure(graph_num + 3)
    colororder(newcolors)
    plot(timeRange,file{WhichRef}.simResult.reference.est.q(tlength,graph_num)','LineWidth',2);
    hold on
    grid on
    if graph_num == 1
        plot(timeRange , file{i}.simResult.state.q(graph_num,tlength),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$\phi_d$','$\hat{\phi}_{\rm case1}$','$\hat{\phi}_{\rm case2}$','$\hat{\phi}_{\rm case3}$','$\hat{\phi}_{\rm case4}$','$\hat{\phi}_{\rm case5}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
        ylabel('Attitude $\phi$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
    elseif graph_num == 2
        plot(timeRange , file{i}.simResult.state.q(graph_num,tlength),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$\theta_d$','$\hat{\theta}_{\rm case1}$','$\hat{\theta}_{\rm case2}$','$\hat{\theta}_{\rm case3}$','$\hat{\theta}_{\rm case4}$','$\hat{\theta}_{\rm case5}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
        ylabel('Attitude $\theta$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
    elseif graph_num == 3
        plot(timeRange , file{i}.simResult.state.q(graph_num,tlength),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$\psi_d$','$\hat{\psi}_{\rm case1}$','$\hat{\psi}_{\rm case2}$','$\hat{\psi}_{\rm case3}$','$\hat{\psi}_{\rm case4}$','$\hat{\psi}_{\rm case5}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
        ylabel('Attitude $\psi$ [rad]','FontSize',Fsize.label,'Interpreter','latex');
    end
    % xlim, ylimの設定
    if flg.xlimHold == 1
        if ~isfield(xlimHold,'q')
            xlim(xlimHold);
        else
            xlim(xlimHold.q);
        end
    end
    if flg.ylimHold == 1
        if ~isfield(ylimHold,'q')
            ylim(ylimHold);
        else
            ylim(ylimHold.q);
        end
    end
    hold off
end

%% v
for graph_num = 1:3 
    figure(graph_num + 6)
    colororder(newcolors)
    plot(timeRange,file{WhichRef}.simResult.reference.est.v(tlength,graph_num)','LineWidth',2);
    hold on
    grid on
    if graph_num == 1
        plot(timeRange , file{i}.simResult.state.v(graph_num,tlength),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$v_{xd}$','$\hat{v}_{x,{\rm case1}}$','$\hat{v}_{x,{\rm case2}}$','$\hat{v}_{x,{\rm case3}}$','$\hat{v}_{x,{\rm case4}}$','$\hat{v}_{x,{\rm case5}}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label);
        ylabel('Velocity $v_x$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
    elseif graph_num == 2
        plot(timeRange , file{i}.simResult.state.v(graph_num,tlength),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$v_{yd}$','$\hat{v}_{y,{\rm case1}}$','$\hat{v}_{y,{\rm case2}}$','$\hat{v}_{y,{\rm case3}}$','$\hat{v}_{y,{\rm case4}}$','$\hat{v}_{y,{\rm case5}}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label);
        ylabel('Velocity $v_y$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
    elseif graph_num == 3
        plot(timeRange , file{i}.simResult.state.v(graph_num,tlength),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$v_{zd}$','$\hat{v}_{z,{\rm case1}}$','$\hat{v}_{z,{\rm case2}}$','$\hat{v}_{z,{\rm case3}}$','$\hat{v}_{z,{\rm case4}}$','$\hat{v}_{z,{\rm case5}}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
        ylabel('Velocity $v_z$ [m/s]','FontSize',Fsize.label,'Interpreter','latex');
    end
    % xlim, ylimの設定
    if flg.xlimHold == 1
        if ~isfield(xlimHold,'q')
            xlim(xlimHold);
        else
            xlim(xlimHold.q);
        end
    end
    if flg.ylimHold == 1
        if ~isfield(ylimHold,'q')
            ylim(ylimHold);
        else
            ylim(ylimHold.q);
        end
    end
    hold off
end

%% w
for graph_num = 1:3 
    figure(graph_num + 9)
    colororder(newcolors)
    plot(timeRange,file{WhichRef}.simResult.reference.est.w(tlength,graph_num)','LineWidth',2);
    hold on
    grid on
    if graph_num == 1
        plot(timeRange , file{i}.simResult.state.w(graph_num,tlength),file{i}.markerSty,'MarkerSize',8,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$\omega_{1 d}$','$\hat{\omega}_{1,{\rm case1}}$','$\hat{\omega}_{1,{\rm case2}}$','$\hat{\omega}_{1,{\rm case3}}$','$\hat{\omega}_{1,{\rm case4}}$','$\hat{\omega}_{1,{\rm case5}}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label);
        ylabel('Angular Velocity $\omega_{1 d}$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
    elseif graph_num == 2
        plot(timeRange , file{i}.simResult.state.w(graph_num,tlength),file{i}.markerSty,'MarkerSize',10,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$\omega_{2 d}$','$\hat{\omega}_{2,{\rm case1}}$','$\hat{\omega}_{2,{\rm case2}}$','$\hat{\omega}_{2,{\rm case3}}$','$\hat{\omega}_{2,{\rm case4}}$','$\hat{\omega}_{2,{\rm case5}}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label);
        ylabel('Angular Velocity $\omega_{2 d}$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
    elseif graph_num == 3
        plot(timeRange , file{i}.simResult.state.w(graph_num,tlength),file{i}.markerSty,'MarkerSize',12,'LineWidth',2,'LineStyle','--');
        lgdtmp = {'$\omega_{3 d}$','$\hat{\omega}_{3,{\rm case1}}$','$\hat{\omega}_{3,{\rm case2}}$','$\hat{\omega}_{3,{\rm case3}}$','$\hat{\omega}_{3,{\rm case4}}$','$\hat{\omega}_{3,{\rm case5}}$'};
        lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
        lgd.NumColumns = columnomber;
        set(gca,'FontSize',Fsize.luler);
        xlabel('time [sec]','FontSize',Fsize.label,'Interpreter','latex');
        ylabel('Angular Velocity $\omega_{3 d}$ [rad/s]','FontSize',Fsize.label,'Interpreter','latex');
    end
    % xlim, ylimの設定
    if flg.xlimHold == 1
        if ~isfield(xlimHold,'q')
            xlim(xlimHold);
        else
            xlim(xlimHold.q);
        end
    end
    if flg.ylimHold == 1
        if ~isfield(ylimHold,'q')
            ylim(ylimHold);
        else
            ylim(ylimHold.q);
        end
    end
    hold off
end
end % flg.divisionのif

end % flg.only_rmse

