%% Importing data
% 結合されたデータを読み込む
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '/../'));
%%
clear
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset.mat');
% load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset_AddXdirection.mat');
% X = Data.X;
% Y = Data.Y;
% U = Data.U;

%% データセットがどういう割合のデータなのか算出する
close all
% T = 1:size(Data.X,2);

% figure(1);
% subplot(2,2,1); plot(T, Data.X(1:3,:), 'LineWidth', 1.5); 
% xlabel('Dataset', 'FontSize', 15); ylabel("Datasets position", 'FontSize', 15)
% legend("$$x$$", "$$y$$", "$$z$$", "Interpreter", "latex",'FontSize', 15)
% 
% subplot(2,2,2); plot(T, Data.X(1,:), 'Color', "#0072BD", 'LineWidth', 1.5); 
% xlabel('Dataset', 'FontSize', 15); ylabel("X", 'FontSize', 15); ylim([-1.5 1.5])
% subplot(2,2,3); plot(T, Data.X(2,:), 'Color', "#D95319", 'LineWidth', 1.5); 
% xlabel('Dataset', 'FontSize', 15); ylabel("Y", 'FontSize', 15)
% subplot(2,2,4); plot(T, Data.X(3,:), 'Color', "#EDB120", 'LineWidth', 1.5); 
% xlabel('Dataset', 'FontSize', 15); ylabel("Z", 'FontSize', 15)

% figure(2);
% subplot(1,3,1); histogram(X(1,:)); ylabel('X');
% subplot(1,3,2); histogram(X(2,:)); ylabel('Y');
% subplot(1,3,3); histogram(X(3,:)); ylabel('Z');

figure(3);
pd = fitdist(X(1,:)', 'Normal');
subplot(1,3,1); histfit(X(1,:), 100); ylabel('X'); hold on; 
text(0.6, 0.8, strcat('mu=', num2str(pd.mu)), 'Units', 'normalized');
text(0.6, 0.75, strcat('sigma=', num2str(pd.sigma)), 'Units', 'normalized')
xline(pd.mu, 'Color', 'green'); 
xline(pd.mu+pd.sigma*3,'Color','red'); xline(pd.mu-pd.sigma*3,'Color','red');
xline(pd.mu+pd.sigma*2,'Color','red'); xline(pd.mu-pd.sigma*2,'Color','red');
xline(pd.mu+pd.sigma*1,'Color','red'); xline(pd.mu-pd.sigma*1,'Color','red');
PD.x = pd;

pd = fitdist(X(2,:)', 'Normal');
subplot(1,3,2); histfit(X(2,:), 100); ylabel('Y');
text(0.6, 0.8, strcat('mu=', num2str(pd.mu)), 'Units', 'normalized');
text(0.6, 0.75, strcat('sigma=', num2str(pd.sigma)), 'Units', 'normalized')
xline(pd.mu, 'Color', 'green'); 
xline(pd.mu+pd.sigma*3,'Color','red'); xline(pd.mu-pd.sigma*3,'Color','red');
xline(pd.mu+pd.sigma*2,'Color','red'); xline(pd.mu-pd.sigma*2,'Color','red');
xline(pd.mu+pd.sigma*1,'Color','red'); xline(pd.mu-pd.sigma*1,'Color','red');
PD.y = pd;

pd = fitdist(X(3,:)', 'Normal');
subplot(1,3,3); histfit(X(3,:), 100); ylabel('Z');
text(0.6, 0.8, strcat('mu=', num2str(pd.mu)), 'Units', 'normalized');
text(0.6, 0.75, strcat('sigma=', num2str(pd.sigma)), 'Units', 'normalized')
xline(pd.mu, 'Color', 'green'); 
xline(pd.mu+pd.sigma*3,'Color','red'); xline(pd.mu-pd.sigma*3,'Color','red');
xline(pd.mu+pd.sigma*2,'Color','red'); xline(pd.mu-pd.sigma*2,'Color','red');
xline(pd.mu+pd.sigma*1,'Color','red'); xline(pd.mu-pd.sigma*1,'Color','red');
PD.z = pd;

%% 正負に分割　⇒　中央値を求める
% Xplus_idx = find(X(1,:)>=0); Xminus_idx = find(X(1,:)<0);
% Yplus_idx = find(X(2,:)>=0); Yminus_idx = find(X(2,:)<0);
% 
% Xplus_median = median(X(1,Xplus_idx)); Xminus_median = median(X(1,Xminus_idx));
% Yplus_median = median(X(2,Yplus_idx)); Yminus_median = median(X(2,Yminus_idx));
% 
% result_median = [Xplus_median Xminus_median Yplus_median Yminus_median]

%% 座標の総移動距離の比較
% error = Y(1:3,:) - X(1:3,:);
% all_dis = sum(error,2)'

%%
% close(3)
[xds, yds] = datastats(X(1,:)', Y(2,:)'); % なんかの統計データ
normalization_data = zscore(X, [], 2);

T = 1:size(Data.X,2);

figure(10);
subplot(1,3,1); histogram(normalization_data(1,:))
subplot(1,3,2); histogram(normalization_data(2,:))
subplot(1,3,3); histogram(normalization_data(3,:))
