%% input_state()から一定入力を入れたときの出力を得る
clear
close all
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../')); % droneまでのフォルダパス
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);

%% model load
clear
tra = 'saddle';
script = [];
mode.code = '00';
mode.training_data = 'Kiyama';
% mode.training_data = 'Kiyama_fromeVel';
% mode.training_data = 'KiyamaX20';
% mode.training_data = 'KiyamaX20fromVel';

% filename = WhichLoadFile(tra, script, mode);
% mode.training_data = 'Kiyama_change';
% filename = 'EstimationResult_2024-06-10_Exp_KiyamaX20_code00_saddle_again';
% filename = 'EstimationResult_2024-06-11_Exp_Kiyama_fromVel_code00_saddle';
% filename = 'EstimationResult_2024-06-14_Exp_Kiyama_fromVel_normalize_code00_saddle';
% filename = 'EstimationResult_2024-06-14_Exp_Kiyama_fromVel_code07_saddle';
% filename = 'EstimationResult_2024-07-12_Exp_Kiyama_code08_optim_x0_estsaddle';
filename = '2024-07-12_Exp_Kiyama_code08_5times_saddle';
% filename = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';
load(strcat(filename, '.mat'), 'est');

%%
clear X
step_num = 10;
thrust = 0.5884 * 9.81065; % 0.5884 * 9.81 * 1e3
torque = [0; 0; 0];
X = input_state({est.A, est.B, est.C, step_num, thrust, torque});

% plot
Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);
ylimsetting = [-1e-0 1e-0];

figure(1);
sgtitle(strcat(mode.training_data, ';;thrust:', num2str(thrust), ';;torque: [', num2str(torque(1)), ', ',num2str(torque(2)), ', ', num2str(torque(3)), ']'));
% subplot(2,3,1);
% plot(0:10,X(1:3,:)); grid on;
% xlabel('Step'); ylabel('$$x, y, z$$', 'Interpreter', 'latex');

subplot(1,3,1);
plot(0:step_num,X(1,:)); grid on; ylim(ylimsetting);
xlabel('Step'); ylabel('$$x$$', 'Interpreter', 'latex');

subplot(1,3,2);
plot(0:step_num,X(2,:)); grid on; ylim(ylimsetting);
xlabel('Step'); ylabel('$$y$$', 'Interpreter', 'latex');

subplot(1,3,3);
plot(0:step_num,X(3,:)); grid on; ylim(ylimsetting);
xlabel('Step'); ylabel('$$z$$', 'Interpreter', 'latex');


%% 可制御性
clc
Co = ctrb(est.A,est.B);
Ob = obsv(est.A,est.C);
fprintf(strcat(string(datetime('now'), 'MM-dd_hh:mm:ss'), '\n'));
fprintf('state num: %d \n', size(est.A,1));
fprintf('ctrb rank: %d \n', rank(Co));
fprintf('obsv rank: %d \n', rank(Ob));

% 不可制御の落ちた状態の時間発展
% n = null(Co);
% % z = nx
% z(:,1) = zeros(size(est.A,1),1);
% for i = 2:100
%     z(:,i) = n * z(:,i-1);
% end

%%
% close all
% A = [1 0; 0 1];
% B = [1; 0];
% x = [0;0];
% u = 0.1;
% 
% t(1,1) = 0;
% 
% for i = 1:10
%     x(:,i+1) = A * x(:,i) + B * u; 
%     t(1,i+1) = t(1,i) + 1;
% end
% 
% plot(t, x(1,:), '-'); hold on;
% plot(t, x(2,:), '--'); legend('x', 'y');s


