%% プロットを試すファイル
%
close all
i = 1;
WhichRef = 1;
% **×3914
estLength = size(file{1}.simResult.state.p, 2);
T = file{1}.simResult.reference.T(1:estLength); %精度検証用サドルの時刻
X = file{1}.simResult.reference.X(:,1:estLength); %精度検証用サドルの状態 est.p, est.vと同値
U = file{1}.simResult.reference.U(:,1:estLength); %精度検証用サドルの入力
Xest = [file{1}.simResult.state.p; file{1}.simResult.state.q; file{1}.simResult.state.v; file{1}.simResult.state.w]; %推定した状態
flightIdx = file{1}.simResult.reference.startIndex; % 10.7156sからflight, idx = 602
initIdx = file{1}.simResult.initTindex; % 1
stepN = 55;

% Pest = file{1}.simResult.reference.est.p;
% 推定検証用サドルの値が保存された周期
dt = file{WhichRef}.simResult.reference.T(2)-file{WhichRef}.simResult.reference.T(1);
flightTime = flightIdx * dt; % flightになった時間 10.7156
% figTime = 11.7; % 取得したい時間 
startTime = 12.6588;
startIdx = round(startTime / dt);
tlength = initIdx+startIdx : initIdx+stepN-1+startIdx;

% Ti = linspace(0, 0.8, length(tlength));
% figure(1);
% plot(Ti,X(1,tlength),'LineWidth',2); hold on;
% plot(Ti,Xest(1,tlength), ':o', 'MarkerSize', 7, 'LineWidth', 1);

figure(2);
plot(T, X(1:3,:));


%% load experiment data
% load('Koopman_Linearization\SICE_data\experiment_9_5_saddle_estimatordata.mat')
% for i = 1:2060
%     Xexp(:, i) = [log.Data.agent.estimator.result{i}.state.p;
%         log.Data.agent.estimator.result{i}.state.q;
%         log.Data.agent.estimator.result{i}.state.v;
%         log.Data.agent.estimator.result{i}.state.w];
% end
% Texp = linspace(0, 31.724, 2060);

%%
% close all
% figure(100);
% plot(Texp, Xexp(1:3,:)); grid on;

% plot(Texp(1:end-1), Xexp(1:3,:)); grid on; hold on;
% step = 50;
% stepT = step * 0.0154;
% sT = 12.6588;
% xline(sT); xline(sT+0.9)
% % xline(11.7 + stepT); xline(12.6 + stepT);
% % xlim([0, 30])
% Texp1 = linspace(0, 0.8, 53);
% figure(101);
% % plot(Texp(round(sT/0.0154):round((sT+0.8)/0.0154)), Xexp(1, round(sT/0.0154):round((sT+0.8)/0.0154)));
% plot(Texp1, Xexp(1, round(sT/0.0154):round((sT+0.8)/0.0154)));
% ylim([0.5, 1]); xlim([0, 0.8])