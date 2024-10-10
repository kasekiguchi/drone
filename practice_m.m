clc
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), './'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
%%
% clear; clc
% N = 29;
% exp = load(strcat('Exp_2_4_', num2str(N), '.mat'));
% sim = load(strcat('HL_exp_', num2str(N), '.mat'));
% edata_idx = find(exp.log.Data.phase == 102, 1, "first"):find(exp.log.Data.phase==102, 1, "last");
% % sdata_idx = find(sim.log.Data.phase == 102, 1, "first"):find(sim.log.Data.phase==102, 1, "last");
% sdata_idx = 1:size(edata_idx,2);
% edata = cell2mat(arrayfun(@(N) exp.log.Data.agent.estimator.result{N}.state.get(),edata_idx,'UniformOutput',false));
% sdata = cell2mat(arrayfun(@(N) sim.log.Data.agent.estimator.result{N}.state.get(),sdata_idx,'UniformOutput',false));
% % reference xd(16,1) q(3,1) p(3,1) v(3,1)
% eref = cell2mat(arrayfun(@(N) exp.log.Data.agent.reference.result{N}.state.get(),edata_idx,'UniformOutput',false));
% sref = cell2mat(arrayfun(@(N) sim.log.Data.agent.reference.result{N}.state.get(),sdata_idx,'UniformOutput',false));
% % time 
% etime = exp.log.Data.t(edata_idx(end)+1)-exp.log.Data.t(edata_idx(1));
% stime = sim.log.Data.t(sdata_idx(end))+0.025-sim.log.Data.t(sdata_idx(1));
% 
% %%
% close all;
% figure(2); sgtitle('actual time');
% subplot(2,1,1); ylabel('exp');
% plot(edata_idx-edata_idx(1), edata(1:3,:)); hold on;
% plot(edata_idx-edata_idx(1), eref(17:19,:), '--'); hold off;
% legend("x","y","z","x.ref","y.ref","z.ref");
% subplot(2,1,2); ylabel('sim');
% plot(1:edata_idx(end)-edata_idx(1)+1, sdata(1:3,:)); hold on;
% plot(1:edata_idx(end)-edata_idx(1)+1, sref(17:19,:), '--'); hold off;
% legend("x","y","z","x.ref","y.ref","z.ref");
% 
% %% 150データの誤差を計算する　⇒　Data.X Y Uに統合
% clear; close all;
% Data.X = [];
% Data.Y = [];
% Data.U = [];
% Data.HowManyDataset = 150;
% for i = 1:150
%     disp(['Extracting: ', num2str(i),' /150'])
%     try
%         exp = load(strcat('Exp_2_4_', num2str(i), '.mat'));
%         sim = load(strcat('HL_exp_', num2str(i), '.mat'));
%         idx1 = find(exp.log.Data.phase == 102, 1, "first");
%         idx2 = min(2400, find(exp.log.Data.phase==102, 1, "last")+1);
%         edata_idx = idx1:idx2;
%         sdata_idx = 1:size(edata_idx,2);
%         edata = cell2mat(arrayfun(@(N) exp.log.Data.agent.estimator.result{N}.state.get(),edata_idx,'UniformOutput',false));
%         sdata = cell2mat(arrayfun(@(N) sim.log.Data.agent.estimator.result{N}.state.get(),sdata_idx,'UniformOutput',false));
%         Data.X = [Data.X, edata(:,1:end-1)-sdata(:,1:end-1)];
%         Data.Y = [Data.Y, edata(:,2:end)-sdata(:,2:end)];
%         edata = cell2mat(arrayfun(@(N) exp.log.Data.agent.controller.result{N}.input,edata_idx(1:end-1),'UniformOutput',false));
%         sdata = cell2mat(arrayfun(@(N) sim.log.Data.agent.controller.result{N}.input,sdata_idx(1:end-1),'UniformOutput',false));
%         Data.U = [Data.U, edata-sdata];
%     catch
%         % save('Koopman_Linearization\Integration_Dataset\Error_Data.mat', 'Data');
%         disp('warning!!')
%     end
% end

%% 誤差データ第二弾
% clear; clc; close all;
% N = 129;
% load(strcat('Exp_2_4_', num2str(N), '.mat')); exp = log;
% load(strcat('HL_exp_1004_', num2str(N), '.mat')); sim = log;
% %%
% clear; clc; close all;
% load("Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset.mat");
% DataNum = size(Data.X,2); clear Data;
% DataSum = 0; %DataNum = 0;
% Data.X = []; Data.Y = []; Data.U = [];
% for i = 1:150
%     clear idx idx_start idx_end
%     load(strcat('Exp_2_4_', num2str(i), '.mat')); exp = log;
%     load(strcat('HL_exp_1007_', num2str(i), '.mat')); sim = data;
%     idx = 1:size(sim.plant,2);
%     idx_start = find(exp.Data.phase == 102, 1, "first");
%     idx_end   = idx_start + idx(end);
%     fLast = find(exp.Data.phase == 102, 1, "last");
%     expd = cell2mat(arrayfun(@(N) exp.Data.agent.estimator.result{N}.state.get(),idx_start:idx_end-1,'UniformOutput',false));
%     simd = sim.plant;
% 
%     expu = cell2mat(arrayfun(@(N) exp.Data.agent.controller.result{N}.input,idx_start:idx_end-1,'UniformOutput',false));
%     simu = sim.input;
% 
%     % Data.X = [Data.X,];
%     Data.X = [Data.X, expd(:,1:end-1) - simd(:,1:end-1)];
%     Data.Y = [Data.Y, expd(:,2:end)   - simd(:,2:end)  ];
%     Data.U = [Data.U, expu(:,1:end-1) - simu(:,1:end-1)];
% 
%     fprintf('Finished ... i=%d \t', i);
%     fprintf('%d  :  %d / %d \n', size(expd(:,1:end-1) - simd(:,1:end-1),2), size(Data.X,2), DataNum);
% end
% close all;
% figure(1);
% subplot(3,1,1); plot(idx, expd(1:3,:), '-', idx, simd(1:3,:), '--'); legend('expx', 'expy', 'expz', 'simx', 'simy', 'simz');
% subplot(3,1,2); plot(idx, expu(1,:), '-', idx, simu(1,:), '--'); legend('exp.th', 'sim.th');
% subplot(3,1,3); plot(idx ,expu(2:4,:), '-', idx, simu(2:4,:), '--'); legend('exp.tr1', 'exp.tr2', 'exp.tr3', 'sim.tr1', 'sim.tr2', 'sim.tr3')

%% シミュレーションの比較
clear; close all;
j = 'sigmoid';
load(strcat('Data\HL_sim_test_1008_', j, '.mat')); sim1 = log;
load(strcat('Data\KMPC_sim_test_1008_', j, '.mat')); sim2 = log;
idx = 1:find(sim1.Data.phase == 102, 1, 'last');
data1.x = cell2mat(arrayfun(@(N) sim1.Data.agent.estimator.result{N}.state.get(),idx,'UniformOutput',false));
data1.u = cell2mat(arrayfun(@(N) sim1.Data.agent.controller.result{N}.input,idx,'UniformOutput',false));
data2.x = cell2mat(arrayfun(@(N) sim2.Data.agent.estimator.result{N}.state.get(),idx,'UniformOutput',false));
data2.u = cell2mat(arrayfun(@(N) sim2.Data.agent.controller.result{N}.input,idx,'UniformOutput',false));
r = [cell2mat(arrayfun(@(N) sim1.Data.agent.reference.result{N}.state.p,idx,'UniformOutput',false));
    cell2mat(arrayfun(@(N) sim1.Data.agent.reference.result{N}.state.q,idx,'UniformOutput',false));
    cell2mat(arrayfun(@(N) sim1.Data.agent.reference.result{N}.state.v,idx,'UniformOutput',false))];
%%
close all;
set(0,'defaultAxesFontSize',12)
set(0, 'DefaultLineLineWidth', 1.5);
% leg = {'1x', '1y', '1z', '2x', '2y', '2z'};
% leg_th = {'1th', '2th'};
% leg_tr = {'1roll', '1pitch', '1yaw', '2roll', '2pitch', '2yaw'};
leg = {'HL.x', 'HL.y', 'HL.z', 'KMPC.x', 'KMPC.y', 'KMPC.z', 'ref.x', 'ref.y', 'ref.z'};
leg_th = {'HL.thrust', 'KMPC.thrust'};
leg_tr = {'HL.roll', 'HL.pitch', 'HL.yaw', 'KMPC.roll', 'KMPC.pitch', 'KMPC.yaw'};
limits = [1 20]; % seconds
t = sim1.Data.t(1:idx(end));
figure(1); 
subplot(2,2,1); plot(t, data1.x(1:3,:), '--', t, data2.x(1:3,:), '-', t, r(1:3,:), ':'); xlim(limits); grid on; legend(leg); ylabel('position');%pos
subplot(2,2,2); plot(t, data1.x(4:6,:), '--', t, data2.x(4:6,:), '-', t, r(4:6,:), ':'); xlim(limits); grid on; legend(leg); ylabel('angle');%q
subplot(2,2,3); plot(t, data1.x(7:9,:), '--', t, data2.x(7:9,:), '-', t, r(7:9,:), ':'); xlim(limits); grid on; legend(leg); ylabel('velocity');%v
subplot(2,2,4); plot(t, data1.x(10:12,:), '--', t, data2.x(10:12,:), '-'); xlim(limits); grid on; legend(leg); ylabel('angular velocity');%w
figure(2);
subplot(1,2,1); plot(t, data1.u(1,:), '--', t, data2.u(1,:), '-'); xlim(limits); grid on; legend(leg_th); ylabel('thrust');%thrust
subplot(1,2,2); plot(t, data1.u(2:4,:), '--', t, data2.u(2:4,:), '-'); xlim(limits); grid on; legend(leg_tr); ylabel('torque');%torque




