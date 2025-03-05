
clear;clc;
cf = pwd;
close all
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive;
  cd(fileparts(tmp.Filename));
end



log = load('Data\test_30.mat');
log_ = load('Data\test_30_nominal.mat');
%% logを開く
% Pn = simplify_MEC_Logger(log.log);

logger = simplifyLogger(log.logger(1,2));

% logger = simplifyLogger(log.log);
t = logger.t;
Pa = DataStructure(logger);
Pa.delta_u = logger.controller.delta_u;

logger = simplifyLogger(log_.logger(1,2));

Pa_ = DataStructure(logger);

delta_p = Pa.ref_p - Pa.p;
delta_p_ = Pa_.ref_p - Pa_.p;
L = length(delta_p_);
data_range = 600:1200;

disp("#############################")
fprintf("x:MEC : %f \n",sum(abs(delta_p(1,data_range)))/L)
fprintf("x:nom : %f \n",sum(abs(delta_p_(1,data_range)))/L)
fprintf("y:MEC : %f \n",sum(abs(delta_p(2,data_range)))/L)
fprintf("y:nom : %f \n",sum(abs(delta_p_(2,data_range)))/L)
fprintf("z:MEC : %f \n",sum(abs(delta_p(3,data_range)))/L)
fprintf("z:nom : %f \n",sum(abs(delta_p_(3,data_range)))/L)
disp("#############################")
fprintf("x : %f \n",(sum(abs(delta_p(1,data_range)))-sum(abs(delta_p_(1,data_range))))/sum(abs(delta_p_(1,data_range))))
fprintf("y : %f \n",(sum(abs(delta_p(2,data_range)))-sum(abs(delta_p_(2,data_range))))/sum(abs(delta_p_(2,data_range))))
fprintf("z : %f \n",(sum(abs(delta_p(3,data_range)))-sum(abs(delta_p_(3,data_range))))/sum(abs(delta_p_(3,data_range))))
disp("#############################")

mean_z = mean(Pa.p(3,400*2/10:end));
fprintf("mean:z : %f \n",mean_z)

figure(1);

title = "";
label = ["time [s]","x [m]", "time [s]","y [m]", "time [s]","z [m]"];
legend = ["MEC", "nominal";
          "MEC", "nominal";
          "MEC", "nominal"];

create_y234_LinkedSubplots(t,delta_p, delta_p_, label, legend, title, data_range)

% 2. グラフのフォーマット調整
set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
set(gcf, 'Color', 'w');    % 背景を白に設定

% 3. Figureのプロパティ設定
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定

% 4. PDFとして保存
exportgraphics(gcf, 'Data/delta_p.pdf', 'ContentType', 'vector', 'Resolution', 300);

function data = DataStructure(logger)
    c=logger.controller;
    data.z1=c.z1;
    data.z2=c.z2;
    data.z3=c.z3;
    data.z4=c.z4;
    % NN_xi=c.xi_log;
    data.input = c.input;
        
    c = logger.plant;
    data.q = c.q;
    data.p = c.p;
    data.v = c.v;
    data.w = c.w;
    
    c2 = logger.reference;
    data.ref_q = c2.q;
    data.ref_p = c2.p;
    data.ref_v = c2.v;
    % ref_w = c.w; wのリファレンスは存在しません
end

function create_y234_LinkedSubplots(t, delta_p, delta_p_, label, leg, title, data_range)
    % サンプルデータの作成（データが渡されている場合は省略可能）
    
    % 2×2のサブプロットを作成
    ax1 = subplot(2, 2, 1);  % 左上
    hold on;
    plot(t(data_range), delta_p(1,data_range), 'LineWidth', 1.5);
    plot(t(data_range), delta_p_(1,data_range), 'LineWidth', 1.5);
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,1:2));
    grid on;
    hold off;
    axis tight;

    ax2 = subplot(2, 2, 2);  % 右上
    hold on;
    plot(t(data_range), delta_p(2,data_range), 'LineWidth', 1.5);
    plot(t(data_range), delta_p_(2,data_range), 'LineWidth', 1.5);
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,1:2));
    grid on;
    hold off;
    axis tight;

    ax3 = subplot(2, 2, 3);  % 左下
    hold on;
    plot(t(data_range), delta_p(3,data_range), 'LineWidth', 1.5);
    plot(t(data_range), delta_p_(3,data_range), 'LineWidth', 1.5);
    xlabel(label(5));
    ylabel(label(6));
    legend(leg(3,1:2));
    grid on;
    hold off;
    axis tight;



    % 軸をリンクさせる（右上、左下、右下）
    % linkaxes([ax2, ax3], 'y');

    sgtitle(title);

end
