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
filename = '2024-07-14_Exp_KiyamaX20_code00_saddle';
% filename = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';
load(strcat(filename, '.mat'), 'est');

Input_file = 'Input_X20_result.mat';
% Input_file = 'Input_Kiyama_result.mat';

Est_file = 'Est_X20_result.mat';
% Est_file = 'Est_Kiyama_result.mat';

load(Input_file);
load(Est_file);

%%
Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);
ylimsetting = [-inf inf];
close all
count = 0;
f = figure(10);
for i = 1:size(input_result,2)-200
    N = round((size(input_result,2)-200) / 200);
    m = 3; n = 3;
    if rem(i-1, 200) == 0
        count = count + 1;
        start_num = i;
        step_num = start_num + 200;
        thrust = input_result(1, start_num:step_num); % 0.5884 * 9.81 * 1e3
        torque = input_result(2:4,start_num:step_num);
        X = input_state({est.A, est.B, est.C, step_num-start_num+1, thrust, torque, Est_result, start_num});

        subplot(m,n,count);
        % title(strcat(num2str(start_num), "~~", num2str(step_num)));
        plot(start_num:step_num+1,X(1,:)); grid on; hold on; 
        plot(start_num:step_num+1,X(2,:)); plot(start_num:step_num+1,X(3,:)); hold off;
        xlim([start_num step_num]); ylim(ylimsetting);
        xlabel('Step'); ylabel('$$x$$', 'Interpreter', 'latex');
    end
end
subplot(m,n,m*n); plot(0:10, 0.1*[0:10], 0:10, 0.1*[0:10], 0:10, 0.1*[0:10]); legend('X', 'Y', 'Z');
sgtitle(strcat(strrep(filename, '_', ' '), "--", strrep(Input_file, '_', ' ')))
f.WindowState = "maximized";

%%
clear X
start_num = 1200;
step_num = start_num + 200;
thrust = input_result(1, start_num:step_num); % 0.5884 * 9.81 * 1e3
torque = input_result(2:4,start_num:step_num);
X = input_state({est.A, est.B, est.C, step_num-start_num+1, thrust, torque});

% plot
step_num = step_num-start_num+1;
Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);
ylimsetting = [-inf inf];

figure(1);
% sgtitle(strcat(mode.training_data, ';;thrust:', num2str(thrust), ';;torque: [', num2str(torque(1)), ', ',num2str(torque(2)), ', ', num2str(torque(3)), ']'));
% subplot(2,3,1);
% plot(0:10,X(1:3,:)); grid on;
% xlabel('Step'); ylabel('$$x, y, z$$', 'Interpreter', 'latex');

subplot(1,3,1);
plot(0:step_num,X(1,:)); grid on; ylim(ylimsetting); xlim([-inf inf]);
xlabel('Step'); ylabel('$$x$$', 'Interpreter', 'latex');

subplot(1,3,2);
plot(0:step_num,X(2,:)); grid on; ylim(ylimsetting); xlim([-inf inf]);
xlabel('Step'); ylabel('$$y$$', 'Interpreter', 'latex');

subplot(1,3,3);
plot(0:step_num,X(3,:)); grid on; ylim(ylimsetting); xlim([-inf inf]);
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




