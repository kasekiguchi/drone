%% input_state()から一定入力を入れたときの出力を得る
clear
close all
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../')); % droneまでのフォルダパス
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
% filename = '2024-07-14_Exp_KiyamaX20_code00_saddle';
% filename = '2024-08-06_Exp_KiyamaY20_code00_saddle';
filename = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';
% filename = '2024-09-11_Exp_Kiyama_code10_saddle';
% filename = '2024-11-14_Exp_Kato_code00_saddle';
load(strcat(filename, '.mat'), 'est');

% Input_file = 'Input_X20_result.mat';
Input_file = 'Input_Kiyama_result.mat';
% Input_file = 'Input_Y20_result.mat';

% Est_file = 'Est_X20_result.mat';
Est_file = 'Est_Kiyama_result.mat';
% Est_file = 'Est_Y20_result.mat';

load(Input_file);
load(Est_file);

%input_state({A, B, C, step数, thrust, torque, 初期状態に使う配列, 初期状態のインデックス});

%% A行列にxyzの位置を加えた拡張係数行列とする
% if strcmp(filename, '2024-09-11_Exp_Kiyama_code10_saddle') == 1
%     A_1 = [eye(3), zeros(3), eye(3)*0.025, zeros(3, size(est.A,1)-6)];
%     A_2 = [zeros(size(est.A,2), 3), est.A];
%     est.A = [A_1; A_2];
%     est.B = [zeros(3, 4); est.B];
%     est.C = blkdiag(eye(3), est.C);
% end
%% Nおきに入力(input_result)を入れたときの時間発展を計算する
% 1, 0などの簡単な入力以外で試すときに使う
% 修士論文中間発表資料に出力した図あり
Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);
ylimsetting = [-inf inf];
close all
count = 0;
N = 200;
f = figure(10);
for i = 1:size(input_result,2)-N
    N = round((size(input_result,2)-N) / N);
    m = 6; n = 6;
    if rem(i-1, N) == 0
        count = count + 1;
        start_num = i;
        step_num = start_num + N;
        thrust = input_result(1, start_num:step_num); % 0.5884 * 9.81 * 1e3
        torque = input_result(2:4,start_num:step_num);
        X = input_state({est.A, est.B, est.C, step_num-start_num+1, thrust, torque, Est_result(:,start_num)},0);

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

%% 普通に使いたいとき
% thrust，torqueの値を設定する
% thrust = ones(1, xx);
% torque = zeros(3, xx);
mode = 0; % 0:free, 1:00; 2:10

clear X
N = 100;
start_num = 1; % 単体で利用時はステップ数
step_num = start_num + N;
thrust = zeros(1, step_num) + 0.5884 * 9.81; % iFlight:0.730, eachine:0.5884
torque = zeros(3, step_num);
% thrust = input_result(1, start_num:step_num); % 0.5884 * 9.81 * 1e3
% torque = input_result(2:4,start_num:step_num);

Est = zeros(12,1);
% Est = Est_result(:, start_num);
mode = 0; % 1:00, 2:10, 0:free
X = input_state({est.A, est.B, est.C, step_num, thrust, torque, Est}, mode);

% 位置含まないモデルのとき
% p = [0;0;0];
% for i = 2:step_num+1
%     p(:,i) = p(:,i-1) + 0.025 * X(4:6,i-1); 
% end
% X = [p; X];


% plot
% step_num = step_num-start_num+1;
Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);
ylimsetting = [-0.1 0.1; -0.1 0.1; -0.1 0.1];
% ylimsetting = [0 1.5; -0.15 0; -25 0];

figure(1);
sgtitle('Exp.Kiyama.Dataset, code00');
% sgtitle(strcat(mode.training_data, ';;thrust:', num2str(thrust), ';;torque: [', num2str(torque(1)), ', ',num2str(torque(2)), ', ', num2str(torque(3)), ']'));
% subplot(2,3,1);
% plot(0:10,X(1:3,:)); grid on;
% xlabel('Step'); ylabel('$$x, y, z$$', 'Interpreter', 'latex');

subplot(1,3,1);
plot(0:step_num,X(1,:)); grid on; ylim(ylimsetting(1,:)); xlim([-inf inf]);
xlabel('Step'); ylabel('$$x$$', 'Interpreter', 'latex');

subplot(1,3,2);
plot(0:step_num,X(2,:)); grid on; ylim(ylimsetting(2,:)); xlim([-inf inf]);
xlabel('Step'); ylabel('$$y$$', 'Interpreter', 'latex');

subplot(1,3,3);
plot(0:step_num,X(3,:)); grid on; ylim(ylimsetting(3,:)); xlim([-inf inf]);
xlabel('Step'); ylabel('$$z$$', 'Interpreter', 'latex');

%% グラフを重ねる
close all
filename = '2024-09-11_Exp_Kiyama_code10_saddle';
log1=load(strcat(filename, '.mat'), 'est');
Est1 = zeros(9,1);
% filename = '2024-10-31_Exp_Kiyama_code10_normalize_saddle';
% log2=load(strcat(filename, '.mat'), 'est');
% Est2 = zeros(9,1); % 位置含まないモデル：zeros(9,1), 通常：zeros(12,1)
filename = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';
log3=load(strcat(filename, '.mat'), 'est');
Est3 = zeros(12,1);

clear X
N = 100;
start_num = 1; % 単体で利用時はステップ数
step_num = start_num + N;
thrust = 0.5884 * 9.81065 * ones(1, step_num);  
% thrust = zeros(1, step_num);
torque = zeros(3, step_num);
% thrust = input_result(1, start_num:step_num); % 0.5884 * 9.81 * 1e3
% torque = input_result(2:4,start_num:step_num);

X1 = input_state({log1.est.A, log1.est.B, log1.est.C, step_num, thrust, torque, Est1},2);
% X2 = input_state({log2.est.A, log2.est.B, log2.est.C, step_num, thrust, torque, Est2},2);
X3 = input_state({log3.est.A, log3.est.B, log3.est.C, step_num, thrust, torque, Est3},1);

% 位置含まないモデルのとき
init = [0;0;0];
X1 = without_position(init, step_num, X1);
% X2 = without_position(init, step_num, X2);
% X3 = without_position(init, step_num, X3);

Fontsize = 15;  
set(0,'defaultAxesFontSize',25);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',2);
set(0,'defaultLineMarkerSize',15);
ylimsetting = [-inf inf; -inf inf; -inf inf];
% ylimsetting = [0 1.5; -0.15 0; -25 0];
legendlist = {'NoIncludePosition', 'IncludePosition'}; % 位置ありと位置なしの比較
% legendlist = {'Without-Standardization', 'With-Standardization'};
% legendlist = {'Without-Standardization', 'With-Standardization', 'Previous'};
state = [1:3]';
figure(1);
subplot(1,3,1);
plot(0:step_num,X1(1,:)); hold on; 
% plot(0:step_num,X2(1,:)); 
plot(0:step_num,X3(1,:));
hold off;
grid on; ylim(ylimsetting(1,:)); xlim([-inf inf]);
xlabel('Step'); ylabel('$$x$$', 'Interpreter', 'latex'); legend(legendlist, 'Location','best');

subplot(1,3,2);
plot(0:step_num,X1(2,:)); hold on; 
% plot(0:step_num,X2(2,:)); 
plot(0:step_num,X3(2,:)); 
hold off; 
grid on; ylim(ylimsetting(2,:)); xlim([-inf inf]);
xlabel('Step'); ylabel('$$y$$', 'Interpreter', 'latex'); %legend('NoIncludePosition', 'IncludePosition');

subplot(1,3,3);
plot(0:step_num,X1(3,:)); hold on; 
% plot(0:step_num,X2(3,:)); 
plot(0:step_num,X3(3,:)); 
hold off; 
grid on; ylim(ylimsetting(3,:)); xlim([-inf inf]);
xlabel('Step'); ylabel('$$z$$', 'Interpreter', 'latex'); %legend('NoIncludePosition', 'IncludePosition');

%% 比較するデータ数を可変にしたい
clear; close all;
init = [0;0;0];
P = [0.5884 0.16	0.16 0.08 0.08 0.06	0.06 0.06 9.81 0.0301 0.0301 0.0301	0.0301 8.0e-06 8.0e-06 8.0e-06 8.0e-06];
filename{1} = '2024-09-11_Exp_Kiyama_code10_saddle';
filename{2} = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';
% filename{3} = '2024-10-31_Exp_Kiyama_code10_normalize_saddle';
filename{3} = @roll_pitch_yaw_thrust_torque_physical_parameter_model;
Estnum = [9 12 12];
withoutp = [1 0 0];
nonlinear = [0 0 1];
log = {size(filename,2)};
X = {size(filename,2)};

N = 100;
start_num = 1; % 単体で利用時はステップ数
step_num = start_num + N;
% thrust = 0.5884 * 9.81065 * ones(1, step_num);  
thrust = zeros(1, step_num);
torque = zeros(3, step_num);

Fontsize = 15;  
set(0,'defaultAxesFontSize',25);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',2);
set(0,'defaultLineMarkerSize',15);
ylimsetting = [-inf inf; -inf inf; -inf inf];
% ylimsetting = [0 1.5; -0.15 0; -25 0];
% legendlist = {'NoIncludePosition', 'IncludePosition'}; % 位置ありと位置なしの比較
% legendlist = {'Without-Standardization', 'With-Standardization'};
% legendlist = {'Without-Standardization', 'Previous', 'With-Standardization'};
legendlist = {'NoIncludePosition', 'IncludePosition', 'Non-linear'};

figure(1);
for i = 1:size(filename,2)
    Est{i} = zeros(Estnum(i),1);
    if nonlinear(i) == 1
        X{i} = nonlinear_equ(Est{i}, step_num, filename{i}, [thrust; torque], P); %非線形モデル
    else
        log{i} = load(strcat(filename{i}, '.mat'), 'est');
        % 位置無しモデル
        if withoutp(i) == 1
            X{i} = input_state({log{i}.est.A, log{i}.est.B, log{i}.est.C, step_num, thrust, torque, Est{i}},2);
            X{i} = without_position(init, step_num, X{i});   
        else
            X{i} = input_state({log{i}.est.A, log{i}.est.B, log{i}.est.C, step_num, thrust, torque, Est{i}},1);
        end
    end
    % plot
    subplot(1,3,1);
    plot(0:step_num,X{i}(1,:)); hold on; 
    grid on; ylim(ylimsetting(1,:)); xlim([-inf inf]);
    xlabel('Step'); ylabel('$$x$$', 'Interpreter', 'latex'); legend(legendlist, 'Location','best');

    subplot(1,3,2);
    plot(0:step_num,X{i}(2,:)); hold on;
    grid on; ylim(ylimsetting(2,:)); xlim([-inf inf]);
    xlabel('Step'); ylabel('$$y$$', 'Interpreter', 'latex'); %legend(legendlist, 'Location','best');

    subplot(1,3,3);
    plot(0:step_num,X{i}(3,:)); hold on;
    grid on; ylim(ylimsetting(3,:)); xlim([-inf inf]);
    xlabel('Step'); ylabel('$$z$$', 'Interpreter', 'latex'); %legend(legendlist, 'Location','best');
end
hold off; 

%% 部分の行列抜き出し
A3 = log3.est.A(7:9,7:9);
B3 = log3.est.B(7:9,:); % 昨年度

A2 = log2.est.A(4:6,4:6);
B2 = log2.est.B(4:6,:); % あり

A1 = log1.est.A(4:6,4:6);
B1 = log1.est.B(4:6,:); % 無し
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


function X = without_position(init, step_num, X)
    p(:,1) = init;
    for i = 2:step_num+1
        p(:,i) = p(:,i-1) + 0.025 * X(4:6,i-1); 
    end
    X = [p; X];
end

function p = nonlinear_equ(init, step_num, plant, u, P)
    p(:,1) = init;
    for i = 1:step_num
        [~,tmpx] = ode15s(@(t,x) plant(p(:,i),u(:,i),P),[0 0.025],p(:,i));
        p(:,i+1) = tmpx(end,:)';
    end
end