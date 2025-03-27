
%% Initialize
tmp = matlab.desktop.editor.getActive;
dir = fileparts(tmp.Filename);
if ~contains(path,dir)
    cd(erase(dir,'\mode'));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear ; clc;
userpath('clear');
end
clear; close all; clc;


%% ドローンの状態の実験値から学習済みのNNによるdelta_uを評価

plot_data_distribution = 0;

exp_data = load("Data/OriginalData/exp_4_MEC/6_Log(13-Mar-2025_16_13_39).mat");
F = find(exp_data.log.Data.phase==102); %flight_index

NNMEC = importNetworkFromONNX("NN_MODEL\MECNN_model.onnx");
NNMEC.Initialized
layer = inputLayer([12 1], "SC");
NNMEC = addInputLayer(NNMEC,layer);

%%%%%%%%%%%%%%
coef = 2035;
%%%%%%%%%%%%%%

delta_u = zeros(4,F(end)-F(1)-coef+1);
xa_ = zeros(12,F(end)-F(1)-coef+1);
xn_ = zeros(12,F(end)-F(1)-coef+1);
t = 0:0.025:0.025*(F(end)-F(1)-coef);

for i = 1:F(end)-F(1)-coef
    fprintf("%d / %d \n", i, F(end)-F(1)-coef)
    xa = exp_data.log.Data.agent.estimator.result{1,i+F(1)}.state;
    xa = [xa.p; xa.q; xa.v; xa.w];
    xa_(:,i) = xa;

    xa_pre = exp_data.log.Data.agent.estimator.result{1,i+F(1)-1}.state;
    xa_pre = [xa_pre.p; xa_pre.q; xa_pre.v; xa_pre.w];
    input = exp_data.log.Data.agent.controller.result{1,i+F(1)-1}.input;
    parameter = DRONE_PARAM("DIATONE").parameter;

    xn = xa_pre + 0.025*roll_pitch_yaw_thrust_torque_physical_parameter_model(xa_pre, input, parameter);
    xn_(:,i) = xn;

    delta_u_ = cast(predict(NNMEC, (xa-xn)), "double");
    delta_u(:,i) = delta_u_';

end

figure(1);%detla_u
% title = "detla u";
title = "";
label = ["Time","Total thrust", "Time","Torque : roll", "Time","Torque : pitch", "Time","Torque : Yaw"];
legend = ["","\Deltau","Pich","Yaw";
        "","\Deltau","","";
        "","\Deltau","","";
        "","\Deltau","",""];

hold on
quadruple_LinkedSubplots(t, delta_u, label, legend, title)
hold off

% 2. グラフのフォーマット調整
set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
set(gcf, 'Color', 'w');    % 背景を白に設定

% 3. Figureのプロパティ設定
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定

% 4. PDFとして保存
% print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
exportgraphics(gcf, 'Data/input_4_NNMEC.pdf', 'ContentType', 'vector', 'Resolution', 300);




% サブプロットの設定


if plot_data_distribution == 1
% フォルダのパスを指定
folderPath = 'Data/learning_data/MEC_exp/';
% フォルダ内の .mat ファイルを取得
fileList = dir(fullfile(folderPath, '*.mat'));
q = [];
p = [];
v = [];
w = [];
for i = 1:length(fileList)
    fileName = fullfile(folderPath, fileList(i).name);
    fprintf('Loading: %s\n', fileName); % 読み込むファイルを表示
    log = load(fileName);
    p = cat(2, p, log.p);
    q = cat(2, q, log.q);
    v = cat(2, v, log.v);
    w = cat(2, w, log.w);
end

x = [p;q;v;w];

figure;
for i = 1:12
    subplot(4, 3, i);
    histogram(x(i, :));
    xlabel('x');

    
    % % xa, xn の値を表示
    % text(min(xa(i,:)), max(xn(i,:)), sprintf('xa: %s\nxn: %s', ...
    %     mat2str(xa(i,:)), mat2str(xn(i,:))), 'FontSize', 8, 'VerticalAlignment', 'top');
end
end

function quadruple_LinkedSubplots(t, delta_u, label, leg, title)
    % サンプルデータの作成（データが渡されている場合は省略可能）
    
    % 2×2のサブプロットを作成
    ax1 = subplot(2, 2, 1);  % 左上
    hold on;
    plot(t, delta_u(1,:), 'LineWidth', 1.5);
    xlabel(label(1));
    ylabel(label(2));
    % legend(leg(1,1:2));
    % legend(leg(1,1:2), "Interpreter","latex" );
    grid on;
    hold off;
    axis tight;

    ax2 = subplot(2, 2, 2);  % 右上
    hold on;
    plot(t, delta_u(2,:), 'LineWidth', 1.5);
    xlabel(label(3));
    ylabel(label(4));
    % legend(leg(2,1:2));
    grid on;
    hold off;
    axis tight;

    ax3 = subplot(2, 2, 3);  % 左下
    hold on;
    plot(t, delta_u(3,:), 'LineWidth', 1.5);
    xlabel(label(5));
    ylabel(label(6));
    % legend(leg(3,1:2));
    grid on;
    hold off;
    axis tight;

    ax4 = subplot(2, 2, 4);  % 右下
    hold on;
    plot(t, delta_u(4,:), 'LineWidth', 1.5);
    xlabel(label(7));
    ylabel(label(8));
    % legend(leg(4,1:2));
    grid on;
    hold off;
    axis tight;

    % 軸をリンクさせる（右上、左下、右下）
    linkaxes([ax2, ax3, ax4], 'y');

    sgtitle(title);

end

function newLog = simplifyLogger(log)
        % name = ['new_', inputname(1)];
        newLog.t = log.Data.t(1:log.k);    
        newLog.phase = log.Data.phase;
        newLog.k = log.k;
        newLog.fExp = log.fExp;
        
        fieldcell = fieldnames(log.Data.agent);
        j = 1;
        tic
        for i = 1:length(fieldcell)
            if ~isequal(fieldcell{i},'controller')&&~isequal(fieldcell{i},'input')&&~isequal(fieldcell{i},'inner_input')
                fields{j} = fieldcell{i};
                j = j+1;
            end
        end
        %状態の格納
        for i = 1:length(fields)
            F = fields{i};%Flowing phase
            for i2 = 1:newLog.k
                states = log.Data.agent.(fields{i}).result{1, i2}.state.list;
                for i3 = 1:length(states)
                    S = states(i3);%State
                    if S ~= "xd"
                        newLog.(F).(S)(:,i2) = log.Data.agent.(F).result{1, i2}.state.(S);
                    end
                end
            end
        end
        %入力の格納
        for j = 1:newLog.k
            fieldcell2 = fieldnames(log.Data.agent.controller.result{1, j});
            for j2 = 1:length(fieldcell2)
                S = fieldcell2{j2};%State         
                    newLog.controller.(S)(:,j) = log.Data.agent.controller.result{1, j}.(S);
            end
        end
        
        if log.fExp
            for j3 = 1:newLog.k
                newLog.inner_input(:,j3) = log.Data.agent.inner_input{1, j3}';
            end
        end
        toc
        whos 'newLog'

        
end