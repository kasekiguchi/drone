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
clear; clc; close all;
N = 129;
load(strcat('Exp_2_4_', num2str(N), '.mat')); exp = log;
load(strcat('HL_exp_1004_', num2str(N), '.mat')); sim = log;
%%
Data.X = [];
idx = 1:sim.k;
idx_start = find(exp.Data.phase == 102, 1, "first");
idx_end   = idx_start + sim.k;
expd = cell2mat(arrayfun(@(N) exp.Data.agent.estimator.result{N}.state.get(),idx_start:idx_end-1,'UniformOutput',false));
simd = cell2mat(arrayfun(@(N) sim.Data.agent.estimator.result{N}.state.get(),idx,'UniformOutput',false));

expu = cell2mat(arrayfun(@(N) exp.Data.agent.controller.result{N}.input,idx_start:idx_end-1,'UniformOutput',false));
simu = cell2mat(arrayfun(@(N) sim.Data.agent.controller.result{N}.input,idx,'UniformOutput',false));

% Data.X = [Data.X,];
%%
close all;
figure(1);
plot(idx, expd(1:3,:), '-', idx, simd(1:3,:), '--');




