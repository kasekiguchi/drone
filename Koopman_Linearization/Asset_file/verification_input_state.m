%% input_state()から一定入力を入れたときの出力を得る
clear
close all
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../')); % droneまでのフォルダパス
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);

%% model load
clear;
tra = 'saddle';
script = [];
mode.code = '00';
mode.training_data = 'Kiyama';
% mode.training_data = 'Kiyama_fromeVel';
% mode.training_data = 'KiyamaX20';
% mode.training_data = 'KiyamaX20fromVel';

% filename = WhichLoadFile(tra, script, mode);
% mode.training_data = 'Kiyama_change';
% filename = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';
% filename = '2024-11-14_Exp_Kato_code00_saddle';
% filename = '2024-11-19_Exp_Kiyama_code15_saddle'; % hermite 1118=12-14, 1119=15
% filename = '2024-12-04_Exp_Kiyama_code22_saddle'; % hermite [1; x]
% filename = '2024-12-18_Exp_Kiyama_code23_saddle_weight4';
% filename = '2024-12-10_Exp_Kiyama_code00_saddle_weight_1-00001';
% filename = '2024-12-11_Exp_Kiyama_code23_saddle_weight_1-00001';
filename = '2024-12-20_Exp_Kiyama_code22_saddle_weight2';
% code12=without isobe, 13=with isobe, 14=一番ぽいやつ, 15=たくさん
load(strcat(filename, '.mat'), 'est');

% extract code number
codenum = cell2mat(extractBetween(filename, 'code', '_saddle'));

% Input_file = 'Input_X20_result.mat';
Input_file = 'Input_Kiyama_result.mat';
% Input_file = 'Input_Y20_result.mat';

% Est_file = 'Est_X20_result.mat';
Est_file = 'Est_Kiyama_result.mat';
% Est_file = 'Est_Y20_result.mat';

load(Input_file);
load(Est_file);

% 普通に使いたいとき
% thrust，torqueの値を設定する
% thrust = ones(1, xx);
% torque = zeros(3, xx);

clear X; close all;
N = 20;
start_num = 1; % 単体で利用時はステップ数
step_num = start_num + N;
thrust = zeros(1, step_num); % m = iFlight:0.730, eachine:0.5884
torque = zeros(3, step_num);
% thrust = input_result(1, start_num:step_num); % 0.5884 * 9.81 * 1e3
% torque = input_result(2:4,start_num:step_num);

Est = zeros(12,1);
% Est = [-0.0249 0.0105 1.0006 -0.0084 -0.0330 -0.0030 -0.0895 0.0299 -0.0009 -0.0321 -0.1606 -0.0195]';
mode = 3; % 1:00, 2:10, 3:hermite, 0:free
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

% ylimsetting = [0 1.5; -0.15 0; -25 0];

f = figure(1);
sgtitle(strrep(filename, '_', '-'));
% sgtitle(strcat(mode.training_data, ';;thrust:', num2str(thrust), ';;torque: [', num2str(torque(1)), ', ',num2str(torque(2)), ', ', num2str(torque(3)), ']'));
% subplot(2,3,1);
% plot(0:10,X(1:3,:)); grid on;
% xlabel('Step'); ylabel('$$x, y, z$$', 'Interpreter', 'latex');

label_x = {'x', 'y', 'z', 'q.roll', 'q.pitch', 'q.yaw', 'vx', 'vy', 'vz', 'vq.roll', 'vq.pitch', 'vq.yaw'};
ylimsetting = [-0.1 0.1; -0.05 0.05; -0.1 0.1; -0.05 0.05];

format long
ii = 4; jj = 3; arr = 1:ii*jj; idx = 0;
for i = 1:ii
    for j = 1:jj
        idx = idx + 1;
        subplot(ii,jj,idx);
        plot(0:step_num,X(idx,:)); grid on; ylim(ylimsetting(i,:)); xlim([-inf inf]);
        text(0.2, 0.1, num2str(round(max(abs(X(idx,:))), 5)), 'Units', 'normalized', 'FontSize', 10);
        xlabel('Step'); ylabel(label_x{idx});
        
        % subplot(ii,jj,i*j-1);
        % plot(0:step_num,X(2,:)); grid on; ylim(ylimsetting(2,:)); xlim([-inf inf]);
        % text(0.2, 0.1, num2str(round(max(abs(X(2,:))),5)), 'Units', 'normalized', 'FontSize', 10);
        % xlabel('Step'); ylabel('$$y$$', 'Interpreter', 'latex');
        % 
        % subplot(ii,jj,i*);
        % plot(0:step_num,X(3,:)); grid on; ylim(ylimsetting(3,:)); xlim([-inf inf]);
        % text(0.2, 0.1, num2str(round(max(abs(X(3,:))),5)), 'Units', 'normalized', 'FontSize', 10);
        % xlabel('Step'); ylabel('$$z$$', 'Interpreter', 'latex');
        
        % fprintf(strcat(label_x{idx}, ':', num2str(round(max(abs(X(idx,:))), 5)), ','));
        fprintf(strcat(num2str(round(max(abs(X(idx,:))), 5)), ','));
    end
    % fprintf('\n')
end
fprintf('\n')
%input_state({A, B, C, step数, thrust, torque, 初期状態に使う配列, 初期状態のインデックス});

% たくさんの結果を出して画像保存
% f.WindowState = 'maximized';
% saveas(1, strcat('Data/EstimationResult_fig/', filename{k}), 'jpg');

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

%% 比較するデータ数を可変にしたい
clear; close all;
init = [0;0;0];
P = [0.5884 0.16	0.16 0.08 0.08 0.06	0.06 0.06 9.81 0.0301 0.0301 0.0301	0.0301 8.0e-06 8.0e-06 8.0e-06 8.0e-06];
% filename{1} = '2024-11-14_Exp_Kato_code00_saddle';
filename{1} = '2024-12-04_Exp_Kiyama_code22_saddle';
% filename{2} = '2024-11-19_Exp_Kiyama_code15_saddle_4';
filename{2} = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';
% filename{3} = '2024-10-31_Exp_Kiyama_code10_normalize_saddle';
filename{3} = @roll_pitch_yaw_thrust_torque_physical_parameter_model;
Estnum = [12 12 12];
withoutp = [0 0 0];
nonlinear = [0 0 1];
modef = [3 1 0];
log = {size(filename,2)};
X = {size(filename,2)};

N = 20;
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
% ylimsetting = [-inf inf; -inf inf; -inf inf];
ylimsetting = [-0.1 0.1; -0.1 0.1; -1.5 0.1];
% legendlist = {'NoIncludePosition', 'IncludePosition'}; % 位置ありと位置なしの比較
% legendlist = {'Without-Standardization', 'With-Standardization'};
% legendlist = {'Without-Standardization', 'Previous', 'With-Standardization'};
legendlist = {'hermite', 'previous', 'Non-linear'};
color = [0.00,0.45,0.74; 0.85,0.33,0.10; 0.93,0.69,0.13];
testfontsize = 20;
tmp = [0.05 0.05];

figure(1);
for i = 1:size(filename,2)
    Est{i} = zeros(Estnum(i),1);
    if nonlinear(i) == 1
        X{i} = nonlinear_equ(Est{i}, step_num, filename{i}, [thrust; torque], P); %非線形モデル
    else
        log{i} = load(strcat(filename{i}, '.mat'), 'est');
        [log{i}.est.A, log{i}.est.B, log{i}.est.C] = AB_transfer(log{i}.est.A, log{i}.est.B, log{i}.est.C, 0.025, 0.025);
        % 位置無しモデル
        if withoutp(i) == 1
            X{i} = input_state({log{i}.est.A, log{i}.est.B, log{i}.est.C, step_num, thrust, torque, Est{i}},2);
            X{i} = without_position(init, step_num, X{i});   
        else
            X{i} = input_state({log{i}.est.A, log{i}.est.B, log{i}.est.C, step_num, thrust, torque, Est{i}},modef(i));
        end
    end
    % plot
    subplot(1,3,1);
    plot(0:step_num,X{i}(1,:)); hold on; 
    grid on; ylim(ylimsetting(1,:)); xlim([-inf inf]);
    text(tmp(1), tmp(2)+(i-1)*tmp(2), strcat('max:',legendlist{i},'=',num2str(max(abs(X{i}(1,:))))), 'Units', 'normalized', 'Color', color(i,:), 'FontSize', testfontsize);
    xlabel('Step'); ylabel('$$x$$', 'Interpreter', 'latex'); legend(legendlist, 'Location','best');

    subplot(1,3,2);
    plot(0:step_num,X{i}(2,:)); hold on;
    grid on; ylim(ylimsetting(2,:)); xlim([-inf inf]);
    text(tmp(1), tmp(2)+(i-1)*tmp(2), strcat('max:',legendlist{i},'=',num2str(max(abs(X{i}(2,:))))), 'Units', 'normalized', 'Color', color(i,:), 'FontSize', testfontsize);
    xlabel('Step'); ylabel('$$y$$', 'Interpreter', 'latex'); %legend(legendlist, 'Location','best');

    subplot(1,3,3);
    plot(0:step_num,X{i}(3,:)); hold on;
    grid on; ylim(ylimsetting(3,:)); xlim([-inf inf]);
    text(tmp(1), tmp(2)+(i-1)*tmp(2), strcat('max:',legendlist{i},'=',num2str(max(abs(X{i}(3,:))))), 'Units', 'normalized', 'Color', color(i,:), 'FontSize', testfontsize);
    xlabel('Step'); ylabel('$$z$$', 'Interpreter', 'latex'); %legend(legendlist, 'Location','best');
end
text(tmp(1), tmp(2)+(i)*tmp(2), strcat('Free fall (0.025s)','=',num2str(1/2*9.81*(0.025*N)^2)), 'Units', 'normalized', 'Color', 'black', 'FontSize', testfontsize);
hold off; 
if isa(filename{3}, 'char') 
    sgtitle(strrep(strcat(':', filename{1}, ',', filename{2}, ',', filename{3}), '_', '-'));
else
    sgtitle(strrep(strcat(':', filename{1}, ',  :previous', ',  :Nonlinear'), '_', '-'));
end

%% 部分の行列抜き出し
clear re
legendlist
re.x1(:,1) = zeros(12,1); re.x2(:,1) = zeros(12,1);
for j = 1:10-1
re.x1(:,j+1) = log{1}.est.C * log{1}.est.A*quaternions_all([re.x1(:,j); zeros(4,1)]);
re.x2(:,j+1) = log{2}.est.C * log{2}.est.A*observables_isobe(re.x2(:,j));
end
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