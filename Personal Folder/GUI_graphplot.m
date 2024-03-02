%% GUIデータ用グラフプロット
opengl software
close all 
clear all
clc;

%pdfで保存する際のファイル名----------
name = '2_26_卒論_実機_hov_f2';
folderName = '2_21_卒論_hov_f2';
%-------------------------------------

%% データのインポート
fprintf('グラフに表示するファイルを選択してください \n')
[fileName, filePath] = uigetfile('*.*');
disp(['\n選択されたファイル: ', fullfile(filePath, fileName)]);
fprintf('\n選択されたファイルを読み込んでいます \n')
load(fileName)
fprintf('\n選択されたファイルの読み込みが完了しました \n')

time = 0; %1:計算時間のグラフ、0:inner_input

if exist('log','var') == 1
    for i = find(log.Data.phase == 102,1,'first'):find(log.Data.phase == 102,1,'last')
        data.t(1,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.t(i,1);                                      %時間t
        data.phase(1,i) = log.Data.phase(i,1);                                                                      %フェーズ
        data.p(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
        data.pr(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.reference.result{i}.state.p(:,1);     %位置p_reference
        data.q(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.estimator.result{i}.state.q(:,1);      %姿勢角
        data.v(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.estimator.result{i}.state.v(:,1);      %速度
        data.w(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.estimator.result{i}.state.w(:,1);      %角速度
        data.u(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.input{i}(:,1);                         %入力
        data.error(:,i-find(log.Data.phase == 102,1,'first')+1) = data.pr(:,i-find(log.Data.phase == 102,1,'first')+1) - data.p(:,i-find(log.Data.phase == 102,1,'first')+1);                                                               %error
        if log.fExp
            data.inner(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.inner_input{i}(1,:)';          %inner_input
            inner = 1;
        else
            inner = 0;
        end
    end
    % for i = 1:size(data.u,2) %GUIの入力を各プロペラの推力に分解
    %     data.u(:,i) = T2T(data.u(1,i),data.u(2,i),data.u(3,i),data.u(4,i));
    % end
else
    for i = 1:find(logger.Data.t,1,'last')
        data.t(1,i) = logger.Data.t(i,1);                                      %時間t
        data.p(:,i) = logger.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
        data.pr(:,i) = logger.Data.agent.reference.result{i}.state.p(:,1);     %位置p_reference
        data.q(:,i) = logger.Data.agent.estimator.result{i}.state.q(:,1);      %姿勢角
        data.v(:,i) = logger.Data.agent.estimator.result{i}.state.v(:,1);      %速度
        data.w(:,i) = logger.Data.agent.estimator.result{i}.state.w(:,1);      %角速度
        data.u(:,i) = logger.Data.agent.input{i}(:,1);                         %入力
    end
end

%% 各グラフで出力
num = input('\n出力するグラフ形態を選択してください (各グラフで出力 : 0 / いっぺんに出力 : 1)：','s'); %0:各グラフで出力,1:いっぺんに出力
selection = str2double(num); %文字列を数値に変換

if selection == 0
close all

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];

columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 18; %凡例の大きさ調整

%位置p
box on %グラフの枠線が出ないときに使用
figure(1)
hold on
plot(data.t,data.p(1,:),'LineWidth',2.3,'LineStyle','-','Color',[0 0.4470 0.7410]);
xlabel('Time [s]');
ylabel('Position z [m]');
grid on
plot(data.t,data.pr(1,:),'LineWidth',2,'LineStyle','--','Color',[0 0.4470 0.7410]);
plot(data.t,data.p(2,:),'LineWidth',2.3,'LineStyle','-','Color',[0.8500 0.3250 0.0980]);
plot(data.t,data.pr(2,:),'LineWidth',2,'LineStyle','--','Color',[0.8500 0.3250 0.0980]);
plot(data.t,data.p(3,:),'LineWidth',2.3,'LineStyle','-','Color',[0.4660 0.6740 0.1880]);
plot(data.t,data.pr(3,:),'LineWidth',2,'LineStyle','--','Color',[0.4660 0.6740 0.1880]);
lgdtmp = {'$x_e$','$x_r$','$y_e$','$y_r$','$z_e$','$z_r$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax = gca;
hold off

%姿勢角q
figure(2)
colororder(newcolors)
plot(data.t,data.q(:,:),'LineWidth',2.3);
xlabel('Time [s]');
ylabel('Attitude [rad]');
grid on
lgdtmp = {'$\phi_e$','$\theta_e$','$\psi_e$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
xlim([data.t(1) data.t(end)])
ax(2) = gca;

%速度v
figure(3)
colororder(newcolors)
plot(data.t,data.v(:,:),'LineWidth',2.3);
xlabel('Time [s]');
ylabel('Velocity [m/s]');
grid on
lgdtmp = {'$v_{xe}$','$v_{ye}$','$v_{ze}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
xlim([data.t(1) data.t(end)])
ax(3) = gca;

%角速度w
figure(4)
colororder(newcolors)
plot(data.t,data.w(:,:),'LineWidth',2.3);
xlabel('Time [s]');
ylabel('Angular velocity [rad/s]');
grid on
lgdtmp = {'$\omega_{1 e}$','$\omega_{2 e}$','$\omega_{3 e}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
xlim([data.t(1) data.t(end)])
ax(4) = gca;

figure(5)
plot(data.p(1,:),data.p(2,:),'LineWidth',1);
xlabel('Position x [m]');
ylabel('Position y [m]');
grid on
hold on
plot(data.pr(1,:),data.pr(2,:),'LineStyle','--');
plot(0,0,'o','MarkerFaceColor','red','Color','red');
plot(1,1,'o','MarkerFaceColor','black','Color','black');
xlim([-0.2 1.2])
ylim([-0.2 1.2])
legend('Estimated trajectory','Target position','Initial position')
ax(5) = gca;

figure(6)
plot3(0,1,1.5,'o','MarkerFaceColor','black','MarkerSize',8)
hold on
plot3(data.p(1,:),data.p(2,:),data.p(3,:),'LineWidth',1.2,'Color',[0 0.4470 0.7410]);
grid on
plot3(data.pr(1,:),data.pr(2,:),data.pr(3,:),'LineWidth',1.2,'Color','r','LineStyle','--');
xlabel('x [m]');
ylabel('y [m]');
zlabel('z [m]');
zlim([0 max(data.p(3,:))])
legend('Initial position','FontSize',18)
ax(6) = gca;

%入力
figure(7)
plot(data.t,data.u(1,:),'LineWidth',1.5);
xlabel('Time [s]');
ylabel('Input_{thrust}');
hold on
grid on
lgdtmp = {'$thrust$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(7) = gca;

figure(8)
plot(data.t,data.u(2:4,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('Input_{torque}');
hold on
grid on
lgdtmp = {'$torque_{roll}$','$torque_{pitch}$','$torque_{yaw}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(8) = gca;

figure(9)
plot(data.t,data.u(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('Input');
hold on
grid on
lgdtmp = {'$Input_1$','$Input_2$','$Input_3$','$Input_4$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(9) = gca;

%error
figure(10)
colororder(newcolors)
plot(data.t,data.error(:,:),'LineWidth',2.3)
xlabel('Time [s]');
ylabel('Error');
grid on
lgdtmp = {'Error.x','Error.y','Error.z'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(10) = gca;

if time == 1
    figure(11)
    plot(data.t,data.te,'LineWidth',1.2)
    xlabel('Time [s]');
    ylabel('Calculation time [s]');
    yline(0.025,'Color','red','LineWidth',1.2)
    grid on
    xlim([data.t(1) data.t(end)])
    ylim([0.005 0.030])
    legend('ソルバー変更後の計算時間', '制御周期')
    ax(11) = gca;
    title('CalT time')
elseif log.fExp
    figure(11)
    plot(data.t,data.inner,'LineWidth',1.2)
    xlabel('Time [s]')
    ylabel('inner_input')
    grid on
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'1','2','3','4','5','6','7','8'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = 4;
    ax(11) = gca;
    title('Inner_input')
elseif time == 1 && log.fExp
    figure(12)
    plot(data.t,data.inner,'LineWidth',1.2)
    xlabel('Time [s]')
    ylabel('inner_input')
    grid on
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'1','2','3','4','5','6','7','8'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = 4;
    ax(12) = gca;
    title('Inner_input')
end

fontSize = 16; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize); 

else
%% いっぺんに出力
close all

newcolors = [0 0.4470 0.7410
             0.8500 0.3250 0.0980
             0.4660 0.6740 0.1880];

columnomber = 3; %凡例の並べ方調整
Fsize.lgd = 12; %凡例の大きさ調整
size = figure;
size.WindowState = 'maximized'; %表示するグラフを最大化
num = 4;

subplot(2, num, 1)
colororder(newcolors)
p1 = plot(data.t, data.p(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('p');
hold on
grid on
p2 = plot(data.t,data.pr(:,:),'LineWidth',1,'LineStyle','--');
xlim([data.t(1) data.t(end)])
lgdtmp = {'$x_e$','$y_e$','$z_e$','$x_r$','$y_r$','$z_r$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','southwest');
lgd.NumColumns = columnomber;
ax = gca;
hold off

% 姿勢角
subplot(2, num, 2)
p3 = plot(data.t, data.q(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('q');
grid on
xlim([data.t(1) data.t(end)])
lgdtmp = {'$\phi_d$','$\theta_d$','$\psi_d$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
ax(2) = gca;

% 速度
subplot(2, num, 3)
p4 = plot(data.t, data.v(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('v');
grid on
xlim([data.t(1) data.t(end)])
lgdtmp = {'$v_{xd}$','$v_{yd}$','$v_{zd}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
ax(3) = gca;

% 角速度
subplot(2, num, 4)
p5 = plot(data.t, data.w(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('w');
grid on
xlim([data.t(1) data.t(end)])
lgdtmp = {'$\omega_{1 d}$','$\omega_{2 d}$','$\omega_{3 d}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
ax(4) = gca;

% 入力
subplot(2,num,5)
plot(data.t,data.u(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('u');
grid on
lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(5) = gca;

subplot(2,num,6)
plot(data.t,data.u(1,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('Input_{thrust}');
hold on
grid on
yline(0.5884*9.81,'Color','red','LineWidth',1.2)
lgdtmp = {'$thrust$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(6) = gca;

subplot(2,num,7)
plot(data.t,data.u(2:end,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('Input_{torque}');
hold on
grid on
lgdtmp = {'$torque_{roll}$','$torque_{pitch}$','$torque_{yaw}$'};
lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
lgd.NumColumns = columnomber;
xlim([data.t(1) data.t(end)])
ax(7) = gca;

subplot(2,num,8)
if inner == 1
    plot(data.t,data.inner,'LineWidth',1.2)
    xlabel('Time [s]')
    ylabel('inner_input')
    grid on
    xlim([data.t(1) data.t(end)])
    lgdtmp = {'1','2','3','4','5','6','7','8'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','best');
    lgd.NumColumns = 4;
    ax(8) = gca;
else
    plot(data.t,data.error(:,:),'LineWidth',2.5)
    xlabel('Time [s]');
    ylabel('Error');
    grid on
    lgdtmp = {'error.x','error.y','error.z'};
    lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');
    lgd.NumColumns = columnomber;
    xlim([data.t(1) data.t(end)])
    ax(8) = gca;
end

fontSize = 16; %軸の文字の大きさの設定
set(ax,'FontSize',fontSize);

end

%% pdfで保存
%出力したグラフをpdfで保存します．保存先はGraph内です．

if selection == 0
    Num = input('\nグラフをpdfで保存しますか (保存しない : 0 / 保存する : 1)：','s'); %0:各グラフで出力,1:いっぺんに出力
    pdf = str2double(Num); %文字列を数値に変換
else
    pdf = 0;
end

if pdf == 1
    fprintf('\n凡例の位置などを調整し終わったらEnterを押してください\n');
    pause();
    mkdir(folderName);
    movefile(folderName,'Graph')
    exportgraphics(figure(1),strcat('Position_',name,'.pdf'))
    movefile(strcat('Position_',name,'.pdf'),fullfile('Graph',folderName))
  
    exportgraphics(figure(2),strcat('Attitude_',name,'.pdf'))
    movefile(strcat('Attitude_',name,'.pdf'),fullfile('Graph',folderName))
    
    exportgraphics(figure(3),strcat('velocity_',name,'.pdf'))
    movefile(strcat('velocity_',name,'.pdf'),fullfile('Graph',folderName))
    
    exportgraphics(figure(4),strcat('Angular velocity_',name,'.pdf'))
    movefile(strcat('Angular velocity_',name,'.pdf'),fullfile('Graph',folderName))

    exportgraphics(figure(5),strcat('x-y_',name,'.pdf'))
    movefile(strcat('x-y_',name,'.pdf'),fullfile('Graph',folderName))

    exportgraphics(figure(6),strcat('x-y-z_',name,'.pdf'))
    movefile(strcat('x-y-z_',name,'.pdf'),fullfile('Graph',folderName))

    exportgraphics(figure(7),strcat('thrust_',name,'.pdf'))
    movefile(strcat('thrust_',name,'.pdf'),fullfile('Graph',folderName))

    exportgraphics(figure(8),strcat('torque_',name,'.pdf'))
    movefile(strcat('torque_',name,'.pdf'),fullfile('Graph',folderName))

    exportgraphics(figure(9),strcat('input_',name,'.pdf'))
    movefile(strcat('input_',name,'.pdf'),fullfile('Graph',folderName))

    exportgraphics(figure(10),strcat('error_',name,'.pdf'))
    movefile(strcat('error_',name,'.pdf'),fullfile('Graph',folderName))

    fprintf('\n保存が完了しました\n')
end
