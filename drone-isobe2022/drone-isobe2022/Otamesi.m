%% initialize
clear all
close all

% % データの準備
% x = 1:10;
% y = rand(1, 10);
% 
% % グラフの描画
% plot(x, y)
% hold on
% 
% % 縦線を引く時刻
% targetTime = 5;
% 
% % 縦線を描画
% line([targetTime targetTime], ylim, 'Color', 'red', 'LineStyle', '--')
% 
% % グラフの装飾
% xlabel('時刻')
% ylabel('値')
% title('時刻に縦線を引くグラフ')
% legend('データ', '縦線')
% hold off


%% データのインポート
% load("experiment_6_20_circle_estimaterdata.mat") %読み込むデータファイルの設定
load("experiment_6_20_circle_2.mat")
disp('load finished')

for i = find(log.Data.phase == 102,1,'first'):find(log.Data.phase == 108,1,'first')
    data.t(1,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.t(i,1);                                     
    data.u1(:,i-find(log.Data.phase == 102,1,'first')+1) = log.Data.agent.input{i}(:,1);
end

for i = find(log.Data.t > 18,1,'first'):find(log.Data.phase == 108,1,'first')
    data.t1(1,i-find(log.Data.t > 18,1,'first')+1) = log.Data.t(i,1);         
    data.p(:,i-find(log.Data.t > 18,1,'first')+1) = log.Data.agent.estimator.result{i}.state.p(:,1);      %位置p
    data.u2(:,i-find(log.Data.t > 18,1,'first')+1) = log.Data.agent.input{i}(:,1);
end

%入力
figure(1)
plot(data.t,data.u1(:,:),'LineWidth',1);
hold on
targetTime = 18;
line([targetTime targetTime],ylim, 'Color', 'red', 'LineStyle', '--');
xlabel('Time [s]');
ylabel('u');
grid on
% lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
% lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');

%入力
figure(2)
plot(data.t1,data.u2(:,:),'LineWidth',1);
xlabel('Time [s]');
ylabel('u');
grid on
% lgdtmp = {'$u_1$','$u_2$','$u_3$','$u_4$'};
% lgd = legend(lgdtmp,'FontSize',Fsize.lgd,'Interpreter','latex','Location','northwest');

figure(3)
plot(data.p(1,:),data.p(2,:));
grid on