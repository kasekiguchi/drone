clear;clc;
cf = pwd;
close all
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive;
  cd(fileparts(tmp.Filename));
end

log = load('Data\mec_Log(10-Jan-2025_16_45_12).mat');
%% logを開く
Pn = simplifyLogger(log.log);


figure(1);
title = "RESULT";
label = ["t","p", "t","v", "t","q", "t","w"];
legend = ["x","y","z";
          "x","y","z";
          "roll","pitch","yow";
          "roll","pitch","yow"];

q = Quat2Eul(q);
hold on
triple_plot(t,p,t,v,t,q,t,w, label, legend, title)
hold off

figure(2);
title = "REFERENCE";
label = ["t","p:reference", "t","v:reference", "t","q:reference", "t","w:reference"];
legend = ["x","y","z";
          "x","y","z";
          "roll","pitch","yow";
          "roll","pitch","yow"];
triple_plot(t,ref_p,t,ref_v,t,ref_q,[],[], label, legend, title)

figure(3);
hold on
title = "xi sim";
label = ["t","z1", "t","z2", "t","z3", "t","z4"];
legend = ["z1","dz1","","";
          "z2","dz2","ddz2","dddz2";
          "z3","dz3","ddz3","dddz3";
          "z4","dz4","",""];
% triple_plot(t,[z1;NN_xi(1:2,:)],t,[z2;NN_xi(3:6,:)],t,[z3;NN_xi(7:10,:)],t,[z4;NN_xi(11:12,:)], label)
triple_plot(t,z1,t,z2,t,z3,t,z4, label,legend, title)
% triple_plot(t,NN_xi(1:2,:),t,NN_xi(3:6,:),t,NN_xi(7:10,:),t,NN_xi(11:12,:), label)
hold off
% 
% figure(4);
% hold on
% title = "xi NN";
% label = ["t","z1", "t","z2", "t","z3", "t","z4"];
% legend = ["z1","dz1","","";
%           "z2","dz2","ddz2","dddz2";
%           "z3","dz3","ddz3","dddz3";
%           "z4","dz4","",""];
% triple_plot(t,NN_xi(1:2,:),t,NN_xi(3:6,:),t,NN_xi(7:10,:),t,NN_xi(11:12,:), label,legend, title)
% hold off

figure(5);
title = [];
label = ["time [s]","position [m]", "time [s]","velocity [m/s]", "time [s]","attitude angle [rad]", "time [s]","angular velocity [rad/s]"];
legend = ["x","y","z","xr","yr","zr";
          "x","y","z","xr","yr","zr";
          "roll","pitch","yow","rollr","pitchr","yowr";
          "roll","pitch","yow","","",""];

hold on
triple_plot2(t,p,t,v,t,q,t,w,t,ref_p,t,ref_v,t,ref_q,[],[], label, legend, title)
hold off

% 2. グラフのフォーマット調整
set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
set(gcf, 'Color', 'w');    % 背景を白に設定

% 3. Figureのプロパティ設定
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定

% 4. PDFとして保存
% print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
exportgraphics(gcf, 'Data/output_figure.pdf', 'ContentType', 'vector', 'Resolution', 300);

figure(6);%入力
title = [];
label = ["time [s]","input", "time [s]","torque [Nm]", "time [s]","torque [Nm]", "time [s]","torque [Nm]"];
legend = ["total thrust","roll","pich","yow";
        "roll","","","";
        "pitch","","","";
        "yow","","",""];

hold on
create_y234_LinkedSubplots(t,input,t,input(2,:),t,input(3,:),t,input(4,:), label, legend, title)
hold off


function Pn = simplifyLogger(log)

        newLog.t = log.Data.t(1:log.k);    
        newLog.phase = log.Data.phase;
        newLog.k = log.k;
        newLog.fExp = log.fExp;
        
        % p = log.Data.agent.plant.result{1, 1}.state.p{1, i};
        % q = log.Data.agent.plant.result{1, 1}.state.q;
        % v = log.Data.agent.plant.result{1, 1}.state.v;
        % w = log.Data.agent.plant.result{1, 1}.state.w;
        for i = 1:newLog.k
            Pn.p(:,i) = log.Data.agent.plant.result{1, i}.state.p;
            Pn.q(:,i) = log.Data.agent.plant.result{1, i}.state.q;
            Pn.v(:,i) = log.Data.agent.plant.result{1, i}.state.v;
            Pn.w(:,i) = log.Data.agent.plant.result{1, i}.state.w;
        end
end

function triple_plot(x1,y1,x2,y2,x3,y3,x4,y4,label,leg,title)
    % グラフを描画するためのサブプロットを作成
    
    % 1つ目のグラフ
    subplot(2, 2, 1);
    plot(x1, y1,"LineWidth",1.5);
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,:))
    grid on;
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    plot(x2, y2,"LineWidth",1.5);
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    grid on;
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    plot(x3, y3,"LineWidth",1.5);
    xlabel(label(5));
    ylabel(label(6));
    legend(leg(3,:))
    grid on;

    subplot(2, 2, 4);
    plot(x4, y4,"LineWidth",1.5);
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,:))
    grid on;

    sgtitle(title)
end

function triple_plot2(x1,y1,x2,y2,x3,y3,x4,y4,x1r,y1r,x2r,y2r,x3r,y3r,x4r,y4r,label,leg,title)
    % グラフを描画するためのサブプロットを作成
    
    % 1つ目のグラフ
    subplot(2, 2, 1);
    hold on
    plot(x1, y1,"LineWidth",1.5);
    plot(x1r, y1r,"LineWidth",1.0,"Linestyle","--");
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,:))
    grid on;
    hold off
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    hold on
    plot(x2, y2,"LineWidth",1.5);
    plot(x2r, y2r,"LineWidth",1.0,"Linestyle","--");
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    grid on;
    hold off
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    hold on
    plot(x3, y3,"LineWidth",1.5);
    plot(x3r, y3r,"LineWidth",1.0,"Linestyle","--");
    xlabel(label(5));
    ylabel(label(6));
    legend(leg(3,:))
    grid on;
    hold off

    subplot(2, 2, 4);
    hold on
    plot(x4, y4,"LineWidth",1.5);
    plot(x4r, y4r,"LineWidth",1.0,"LineStyle","--");
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,:))
    grid on;
    hold off

    sgtitle(title);

end

function create_y234_LinkedSubplots(x1, y1, x2, y2, x3, y3, x4, y4, label, leg, title)
    % サンプルデータの作成（データが渡されている場合は省略可能）
    
    % 2×2のサブプロットを作成
    ax1 = subplot(2, 2, 1);  % 左上
    hold on;
    plot(x1, y1, 'LineWidth', 1.5);
    xlabel(label(1));
    ylabel(label(2));
    legend(leg{1});
    grid on;
    hold off;
    axis tight;

    ax2 = subplot(2, 2, 2);  % 右上
    hold on;
    plot(x2, y2, 'LineWidth', 1.5);
    xlabel(label(3));
    ylabel(label(4));
    legend(leg{2});
    grid on;
    hold off;
    axis tight;

    ax3 = subplot(2, 2, 3);  % 左下
    hold on;
    plot(x3, y3, 'LineWidth', 1.5);
    xlabel(label(5));
    ylabel(label(6));
    legend(leg{3});
    grid on;
    hold off;
    axis tight;

    ax4 = subplot(2, 2, 4);  % 右下
    hold on;
    plot(x4, y4, 'LineWidth', 1.5);
    xlabel(label(7));
    ylabel(label(8));
    legend(leg{4});
    grid on;
    hold off;
    axis tight;

    % 軸をリンクさせる（右上、左下、右下）
    linkaxes([ax2, ax3, ax4], 'y');

    sgtitle(title);

end