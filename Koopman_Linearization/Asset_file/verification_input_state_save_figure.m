%% input_state()から一定入力を入れたときの出力を得る
clear
close all
tmp = matlab.desktop.editor.getActive;
cd(strcat(fileparts(tmp.Filename), '../../../')); % droneまでのフォルダパス
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);

Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);

%% model load

% filename = WhichLoadFile(tra, script, mode);
% mode.training_data = 'Kiyama_change';
% filename = 'EstimationResult_12state_2_7_Exp_sprine+zsprine+P2Pz_torque_incon_150data_vzからz算出';
% filename = '2024-11-14_Exp_Kato_code00_saddle';
% filename = '2024-11-19_Exp_Kiyama_code15_saddle'; % hermite 1118=12-14, 1119=15
% filename = '2024-12-04_Exp_Kiyama_code22_saddle'; % hermite [1; x]
% filename = '2024-12-18_Exp_Kiyama_code23_saddle_weight4';
% filename = '2024-12-10_Exp_Kiyama_code00_saddle_weight_1-00001';
% filename = '2024-12-11_Exp_Kiyama_code23_saddle_weight_1-00001';
% filename = '2024-12-19_Exp_Kiyama_code26_saddle';
% code12=without isobe, 13=with isobe, 14=一番ぽいやつ, 15=たくさん

filename = {'2024-12-19_Exp_Kiyama_code27_saddle';
            '2024-12-19_Exp_Kiyama_code27_saddle_weight3';
            '2024-12-19_Exp_Kiyama_code27_saddle_weight1';
            '2024-12-19_Exp_Kiyama_code27_saddle_weight2'};

for k = 1:length(filename)
    load(strcat(filename{k}, '.mat'), 'est');

    clear X; close all;
    N = 20;
    start_num = 1; % 単体で利用時はステップ数
    step_num = start_num + N;
    thrust = zeros(1, step_num); % m = iFlight:0.730, eachine:0.5884
    torque = zeros(3, step_num);
    
    Est = zeros(12,1);
    mode = 3; % 1:00, 2:10, 3:hermite, 0:free
    X = input_state({est.A, est.B, est.C, step_num, thrust, torque, Est}, mode);
    
    f = figure(1);
    sgtitle(strrep(filename{k}, '_', '-'));
    
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
    
            fprintf(strcat(num2str(round(max(abs(X(idx,:))), 5)), ','));
        end
        % fprintf('\n')
    end
    fprintf('\n')
    %input_state({A, B, C, step数, thrust, torque, 初期状態に使う配列, 初期状態のインデックス});
    
    % たくさんの結果を出して画像保存
    f.WindowState = 'maximized';
    saveas(1, strcat('Data/EstimationResult_fig/', filename{k}), 'jpg');
end