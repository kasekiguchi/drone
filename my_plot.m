clear;clc;
cf = pwd;
close all
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive;
  cd(fileparts(tmp.Filename));
end

log = load('Data\learning_data\data6.mat');
log = load('Data\test.mat');
%% logを開く
% Pn = simplify_MEC_Logger(log.log);

logger = simplifyLogger(log.logger(1,1));
Pn = DataStructure(logger);

logger = simplifyLogger(log.logger(1,2));

% logger = simplifyLogger(log.log);
t = logger.t;
Pa = DataStructure(logger);
Pa.delta_u = logger.controller.delta_u;


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

% figure(1);
% title = "RESULT";
% label = ["t","p", "t","v", "t","q", "t","w"];
% legend = ["x","y","z";
%           "x","y","z";
%           "roll","pitch","yow";
%           "roll","pitch","yow"];
% 
% % q = Quat2Eul(q);
% hold on
% quadruple_plot(t,Pa.p,t,Pa.v,t,Pa.q,t,Pa.w, label, legend, title)
% hold off
% 
% figure(2);
% title = "REFERENCE";
% label = ["t","p:reference", "t","v:reference", "t","q:reference", "t","w:reference"];
% legend = ["x","y","z";
%           "x","y","z";
%           "roll","pitch","yow";
%           "roll","pitch","yow"];
% quadruple_plot(t,Pa.ref_p,t,Pa.ref_v,t,Pa.ref_q,[],[], label, legend, title)
% 
% figure(3);
% hold on
% title = "xi sim";
% label = ["t","z1", "t","z2", "t","z3", "t","z4"];
% legend = ["z1","dz1","","";
%           "z2","dz2","ddz2","dddz2";
%           "z3","dz3","ddz3","dddz3";
%           "z4","dz4","",""];
% quadruple_plot(t,[z1;NN_xi(1:2,:)],t,[z2;NN_xi(3:6,:)],t,[z3;NN_xi(7:10,:)],t,[z4;NN_xi(11:12,:)], label)
% quadruple_plot(t,Pa.z1,t,Pa.z2,t,Pa.z3,t,Pa.z4, label,legend, title)
% quadruple_plot(t,NN_xi(1:2,:),t,NN_xi(3:6,:),t,NN_xi(7:10,:),t,NN_xi(11:12,:), label)
% hold off

% figure(4);
% hold on
% title = "xi NN";
% label = ["t","z1", "t","z2", "t","z3", "t","z4"];
% legend = ["z1","dz1","","";
%           "z2","dz2","ddz2","dddz2";
%           "z3","dz3","ddz3","dddz3";
%           "z4","dz4","",""];
% quadruple_plot(t,NN_xi(1:2,:),t,NN_xi(3:6,:),t,NN_xi(7:10,:),t,NN_xi(11:12,:), label,legend, title)
% hold off

% figure(5);
% title = [];
% label = ["time [s]","position [m]", "time [s]","velocity [m/s]", "time [s]","attitude angle [rad]", "time [s]","angular velocity [rad/s]"];
% legend = ["x","y","z","xr","yr","zr";
%           "x","y","z","xr","yr","zr";
%           "roll","pitch","yow","rollr","pitchr","yowr";
%           "roll","pitch","yow","","",""];
% 
% hold on
% quadruple_plot2(t,Pa.p,t,Pa.v,t,Pa.q,t,Pa.w,t,Pa.ref_p,t,Pa.ref_v,t,Pa.ref_q,[],[], label, legend, title)
% hold off
% 
% % 2. グラフのフォーマット調整
% set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
% set(gcf, 'Color', 'w');    % 背景を白に設定
% 
% % 3. Figureのプロパティ設定
% set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
% 
% % 4. PDFとして保存
% % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
% exportgraphics(gcf, 'Data/state.pdf', 'ContentType', 'vector', 'Resolution', 300);

figure(5);%detla_u
% title = "detla u";
title = "";
label = ["time [s]","total thrust [N]", "time [s]","torque roll [Nm]", "time [s]","torque pitch [Nm]", "time [s]","torque yow [Nm]"];
legend = ["total thrust","\Deltau","pich","yow";
        "u","\Deltau","","";
        "u","\Deltau","","";
        "u","\Deltau","",""];

hold on
create_y234_LinkedSubplots(t,Pa.input, Pa.delta_u, label, legend, title)
hold off

% 2. グラフのフォーマット調整
set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
set(gcf, 'Color', 'w');    % 背景を白に設定

% 3. Figureのプロパティ設定
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定

% 4. PDFとして保存
% print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
exportgraphics(gcf, 'Data/delta_u.pdf', 'ContentType', 'vector', 'Resolution', 300);


% figure(6);%入力
% % title = "total input";
% title = "";
% label = ["time [s]","input", "time [s]","torque [Nm]", "time [s]","torque [Nm]", "time [s]","torque [Nm]"];
% legend = ["total thrust","roll","pich","yow";
%         "roll","","","";
%         "pitch","","","";
%         "yow","","",""];
% 
% hold on
% create_y234_LinkedSubplots(t,Pa.input(1,:),t,Pa.input(2,:),t,Pa.input(3,:),t,Pa.input(4,:), label, legend, title)
% hold off
% 
% % 2. グラフのフォーマット調整
% set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
% set(gcf, 'Color', 'w');    % 背景を白に設定
% 
% % 3. Figureのプロパティ設定
% set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
% 
% % 4. PDFとして保存
% % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
exportgraphics(gcf, 'Data/input.pdf', 'ContentType', 'vector', 'Resolution', 300);

% figure(7);
% hold on
% title = "Pn state";
% % title = [];
% label = ["t","p", "t","v", "t","q", "t","w"];
% legend = ["x","y","z";
%           "x","y","z";
%           "roll","pitch","yow";
%           "roll","pitch","yow"];
% quadruple_plot2(t,Pn, label, legend, title)
% hold off
% 
% % 2. グラフのフォーマット調整
% set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
% set(gcf, 'Color', 'w');    % 背景を白に設定
% 
% % 3. Figureのプロパティ設定
% set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
% 
% % 4. PDFとして保存
% % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
% exportgraphics(gcf, 'Data/Pn_state.pdf', 'ContentType', 'vector', 'Resolution', 300);

figure(8);
hold on
% title = "Pa state";
title = "";
% title = [];
label = ["t","p", "t","v", "t","q", "t","w"];
legend = ["x","y","z","x:ref","y:ref","z:ref";
          "x","y","z","x:ref","y:ref","z:ref";
          "roll","pitch","yow","yow:ref","","";
          "roll","pitch","yow","","",""];
quadruple_plot2(t,Pa, label, legend, title)
hold off

% 2. グラフのフォーマット調整
set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
set(gcf, 'Color', 'w');    % 背景を白に設定

% 3. Figureのプロパティ設定
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定

% 4. PDFとして保存
% print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
exportgraphics(gcf, 'Data/Pa_state.pdf', 'ContentType', 'vector', 'Resolution', 300);

% figure(9);
% title = [];
% label = ["time [s]","position [m]", "time [s]","velocity [m/s]", "time [s]","attitude angle [rad]", "time [s]","angular velocity [rad/s]"];
% legend = ["x","y","z","Pn:x","Pn:yr","Pn:zr","xr","yr","zr";
%           "vx","vy","vz","Pn:vx","Pn:vy","Pn:vz","xr","yr","zr";
%           "roll","pitch","yow","Pn:roll","Pn:pitch","Pn:yow","rollr","pitchr","yowr";
%           "roll","pitch","yow","Pn:roll","Pn:pitch","Pn:yow","","",""];
% 
% hold on
% quadruple_plot3(t,Pa,Pn,label,legend,title)
% hold off
% 
% % 2. グラフのフォーマット調整
% set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
% set(gcf, 'Color', 'w');    % 背景を白に設定
% 
% % 3. Figureのプロパティ設定
% set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
% 
% % 4. PDFとして保存
% % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
% exportgraphics(gcf, 'Data/state.pdf', 'ContentType', 'vector', 'Resolution', 300);

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

function quadruple_plot(x1,y1,x2,y2,x3,y3,x4,y4,label,leg,title)
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

function quadruple_plot2(t,Pa,label,leg,title)
    % グラフを描画するためのサブプロットを作成
    
    % 1つ目のグラフ
    subplot(2, 2, 1);
    hold on
    plot(t, Pa.p,"LineWidth",1.5);
    plot(t, Pa.ref_p,"LineWidth",1.5,"Linestyle","--");
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,:))
    grid on;
    hold off
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    hold on
    plot(t, Pa.v,"LineWidth",1.5);
    plot(t, Pa.ref_v,"LineWidth",1.5,"Linestyle","--");
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    grid on;
    hold off
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    hold on
    plot(t, Pa.q,"LineWidth",1.5);
    plot(t, Pa.ref_q(3,:),"LineWidth",1.5,"Linestyle","--");
    xlabel(label(5));
    ylabel(label(6));
    % ylim([-pi pi]);
    legend(leg(3,:))
    grid on;
    hold off

    subplot(2, 2, 4);
    hold on
    plot(t, Pa.w,"LineWidth",1.5);
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,:))
    grid on;
    hold off

    sgtitle(title);
end

function quadruple_plot3(t,Pa,Pn,label,leg,title)
    % グラフを描画するためのサブプロットを作成
    
    % 1つ目のグラフ
    subplot(2, 2, 1);
    hold on
    plot(t, Pa.p,"LineWidth",1.5);
    plot(t, Pn.p,"LineWidth",1.0);
    % plot(t, Pa.ref_p,"LineWidth",1.5,"Linestyle","--");
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,:))
    grid on;
    hold off
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    hold on
    plot(t, Pa.q,"LineWidth",1.5);
    plot(t, Pn.q,"LineWidth",1.0);
    % plot(t, Pa.ref_q,"LineWidth",1.5,"Linestyle","--");
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    grid on;
    hold off
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    hold on
    plot(t, Pa.v,"LineWidth",1.5);
    plot(t, Pn.v,"LineWidth",1.0);
    % plot(t, Pa.ref_v,"LineWidth",1.5,"Linestyle","--");
    xlabel(label(5));
    ylabel(label(6));
    legend(leg(3,:))
    grid on;
    hold off

    subplot(2, 2, 4);
    hold on
    plot(t, Pa.w,"LineWidth",1.5);
    plot(t, Pn.w,"LineWidth",1.0);
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,:))
    grid on;
    hold off

    sgtitle(title);
end

function create_y234_LinkedSubplots(t, u, delta_u, label, leg, title)
    % サンプルデータの作成（データが渡されている場合は省略可能）
    
    % 2×2のサブプロットを作成
    ax1 = subplot(2, 2, 1);  % 左上
    hold on;
    plot(t, u(1,:), 'LineWidth', 1.5);
    plot(t, delta_u(1,:), 'LineWidth', 1.5);
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,1:2));
    grid on;
    hold off;
    axis tight;

    ax2 = subplot(2, 2, 2);  % 右上
    hold on;
    plot(t, u(2,:), 'LineWidth', 1.5);
    plot(t, delta_u(2,:), 'LineWidth', 1.5);
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,1:2));
    grid on;
    hold off;
    axis tight;

    ax3 = subplot(2, 2, 3);  % 左下
    hold on;
    plot(t, u(3,:), 'LineWidth', 1.5);
    plot(t, delta_u(3,:), 'LineWidth', 1.5);
    xlabel(label(5));
    ylabel(label(6));
    legend(leg(3,1:2));
    grid on;
    hold off;
    axis tight;

    ax4 = subplot(2, 2, 4);  % 右下
    hold on;
    plot(t, u(4,:), 'LineWidth', 1.5);
    plot(t, delta_u(4,:), 'LineWidth', 1.5);
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,1:2));
    grid on;
    hold off;
    axis tight;

    % 軸をリンクさせる（右上、左下、右下）
    linkaxes([ax2, ax3, ax4], 'y');

    sgtitle(title);

end

function Pn = simplify_MEC_Logger(log)

    newLog.t = log.Data.t(1:log.k);    
    newLog.phase = log.Data.phase;
    newLog.k = log.k;
    newLog.fExp = log.fExp;
    
    % p = log.Data.agent.plant.result{1, 1}.state.p{1, i};
    % q = log.Data.agent.plant.result{1, 1}.state.q;
    % v = log.Data.agent.plant.result{1, 1}.state.v;
    % w = log.Data.agent.plant.result{1, 1}.state.w;
    for i = 1:newLog.k
        Pn.p(:,i) = log.Data.agent.controller.result{1, i}.plant_.p;
        Pn.q(:,i) = log.Data.agent.controller.result{1, i}.plant_.q;
        Pn.v(:,i) = log.Data.agent.controller.result{1, i}.plant_.v;
        Pn.w(:,i) = log.Data.agent.controller.result{1, i}.plant_.w;
        Pn.delta_u(:,i) = log.Data.agent.controller.result{1, i}.plant_.delta_u;
    end
end

% clear;clc;
% cf = pwd;
% close all
% if contains(mfilename('fullpath'),"mainGUI")
%   cd(fileparts(mfilename('fullpath')));
% else
%   tmp = matlab.desktop.editor.getActive;
%   cd(fileparts(tmp.Filename));
% end
% 
% log = load('Data\test.mat');
% %% logを開く
% % Pn = simplify_MEC_Logger(log.log);
% logger = simplifyLogger(log.logger(1,1));
% 
% % logger = simplifyLogger(log.log);
% t = logger.t;
% 
% c=logger.controller;
% z1=c.z1;
% z2=c.z2;
% z3=c.z3;
% z4=c.z4;
% % NN_xi=c.xi_log;
% input = c.input;
% 
% c = logger.plant;
% q = c.q;
% p = c.p;
% v = c.v;
% w = c.w;
% 
% c2 = logger.reference;
% ref_q = c2.q;
% ref_p = c2.p;
% ref_v = c2.v;
% % ref_w = c.w; wのリファレンスは存在しません
% 
% figure(1);
% title = "RESULT";
% label = ["t","p", "t","v", "t","q", "t","w"];
% legend = ["x","y","z";
%           "x","y","z";
%           "roll","pitch","yow";
%           "roll","pitch","yow"];
% 
% % q = Quat2Eul(q);
% hold on
% quadruple_plot(t,p,t,v,t,q,t,w, label, legend, title)
% hold off
% 
% figure(2);
% title = "REFERENCE";
% label = ["t","p:reference", "t","v:reference", "t","q:reference", "t","w:reference"];
% legend = ["x","y","z";
%           "x","y","z";
%           "roll","pitch","yow";
%           "roll","pitch","yow"];
% quadruple_plot(t,ref_p,t,ref_v,t,ref_q,[],[], label, legend, title)
% 
% figure(3);
% hold on
% title = "xi sim";
% label = ["t","z1", "t","z2", "t","z3", "t","z4"];
% legend = ["z1","dz1","","";
%           "z2","dz2","ddz2","dddz2";
%           "z3","dz3","ddz3","dddz3";
%           "z4","dz4","",""];
% % quadruple_plot(t,[z1;NN_xi(1:2,:)],t,[z2;NN_xi(3:6,:)],t,[z3;NN_xi(7:10,:)],t,[z4;NN_xi(11:12,:)], label)
% quadruple_plot(t,z1,t,z2,t,z3,t,z4, label,legend, title)
% % quadruple_plot(t,NN_xi(1:2,:),t,NN_xi(3:6,:),t,NN_xi(7:10,:),t,NN_xi(11:12,:), label)
% hold off
% 
% % figure(4);
% % hold on
% % title = "xi NN";
% % label = ["t","z1", "t","z2", "t","z3", "t","z4"];
% % legend = ["z1","dz1","","";
% %           "z2","dz2","ddz2","dddz2";
% %           "z3","dz3","ddz3","dddz3";
% %           "z4","dz4","",""];
% % quadruple_plot(t,NN_xi(1:2,:),t,NN_xi(3:6,:),t,NN_xi(7:10,:),t,NN_xi(11:12,:), label,legend, title)
% % hold off
% 
% figure(5);
% title = [];
% label = ["time [s]","position [m]", "time [s]","velocity [m/s]", "time [s]","attitude angle [rad]", "time [s]","angular velocity [rad/s]"];
% legend = ["x","y","z","xr","yr","zr";
%           "x","y","z","xr","yr","zr";
%           "roll","pitch","yow","rollr","pitchr","yowr";
%           "roll","pitch","yow","","",""];
% 
% hold on
% quadruple_plot2(t,p,t,v,t,q,t,w,t,ref_p,t,ref_v,t,ref_q,[],[], label, legend, title)
% hold off
% 
% % 2. グラフのフォーマット調整
% set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
% set(gcf, 'Color', 'w');    % 背景を白に設定
% 
% % 3. Figureのプロパティ設定
% set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
% 
% % 4. PDFとして保存
% % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
% exportgraphics(gcf, 'Data/state.pdf', 'ContentType', 'vector', 'Resolution', 300);
% 
% figure(6);%入力
% title = [];
% label = ["time [s]","input", "time [s]","torque [Nm]", "time [s]","torque [Nm]", "time [s]","torque [Nm]"];
% legend = ["total thrust","roll","pich","yow";
%         "roll","","","";
%         "pitch","","","";
%         "yow","","",""];
% 
% hold on
% create_y234_LinkedSubplots(t,input,t,input(2,:),t,input(3,:),t,input(4,:), label, legend, title)
% hold off
% 
% % 2. グラフのフォーマット調整
% set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
% set(gcf, 'Color', 'w');    % 背景を白に設定
% 
% % 3. Figureのプロパティ設定
% set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
% 
% % 4. PDFとして保存
% % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
% exportgraphics(gcf, 'Data/input.pdf', 'ContentType', 'vector', 'Resolution', 300);
% 
% figure(7);
% hold on
% % title = "Pn state";
% title = [];
% label = ["t","p", "t","q", "t","v", "t","w"];
% legend = ["x","y","z";
%           "x","y","z";
%           "roll","pitch","yow";
%           "roll","pitch","yow"];
% quadruple_plot(t,Pn.p,t,Pn.v,t,Pn.q,t,Pn.w, label, legend, title)
% hold off
% 
% % 2. グラフのフォーマット調整
% set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
% set(gcf, 'Color', 'w');    % 背景を白に設定
% 
% % 3. Figureのプロパティ設定
% set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
% 
% % 4. PDFとして保存
% % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
% exportgraphics(gcf, 'Data/Pn_state.pdf', 'ContentType', 'vector', 'Resolution', 300);
% 
% function newLog = simplifyLogger(log)
%         % name = ['new_', inputname(1)];
%         newLog.t = log.Data.t(1:log.k);    
%         newLog.phase = log.Data.phase;
%         newLog.k = log.k;
%         newLog.fExp = log.fExp;
% 
%         fieldcell = fieldnames(log.Data.agent);
%         j = 1;
%         tic
%         for i = 1:length(fieldcell)
%             if ~isequal(fieldcell{i},'controller')&&~isequal(fieldcell{i},'input')&&~isequal(fieldcell{i},'inner_input')
%                 fields{j} = fieldcell{i};
%                 j = j+1;
%             end
%         end
%         %状態の格納
%         for i = 1:length(fields)
%             F = fields{i};%Flowing phase
%             for i2 = 1:newLog.k
%                 states = log.Data.agent.(fields{i}).result{1, i2}.state.list;
%                 for i3 = 1:length(states)
%                     S = states(i3);%State
%                     if S ~= "xd"
%                         newLog.(F).(S)(:,i2) = log.Data.agent.(F).result{1, i2}.state.(S);
%                     end
%                 end
%             end
%         end
%         %入力の格納
%         for j = 1:newLog.k
%             fieldcell2 = fieldnames(log.Data.agent.controller.result{1, j});
%             for j2 = 1:length(fieldcell2)
%                 S = fieldcell2{j2};%State         
%                     newLog.controller.(S)(:,j) = log.Data.agent.controller.result{1, j}.(S);
%             end
%         end
%         if log.fExp
%             for j3 = 1:newLog.k
%                 newLog.inner_input(:,j3) = log.Data.agent.inner_input{1, j3}';
%             end
%         end
%         toc
%         whos 'newLog'
% 
% 
% end
% 
% function quadruple_plot(x1,y1,x2,y2,x3,y3,x4,y4,label,leg,title)
%     % グラフを描画するためのサブプロットを作成
% 
%     % 1つ目のグラフ
%     subplot(2, 2, 1);
%     plot(x1, y1,"LineWidth",1.5);
%     xlabel(label(1));
%     ylabel(label(2));
%     legend(leg(1,:))
%     grid on;
% 
%     % 2つ目のグラフ
%     subplot(2, 2, 2);
%     plot(x2, y2,"LineWidth",1.5);
%     xlabel(label(3));
%     ylabel(label(4));
%     legend(leg(2,:))
%     grid on;
% 
%     % 3つ目のグラフ
%     subplot(2, 2, 3);
%     plot(x3, y3,"LineWidth",1.5);
%     xlabel(label(5));
%     ylabel(label(6));
%     legend(leg(3,:))
%     grid on;
% 
%     subplot(2, 2, 4);
%     plot(x4, y4,"LineWidth",1.5);
%     xlabel(label(7));
%     ylabel(label(8));
%     legend(leg(4,:))
%     grid on;
% 
%     sgtitle(title)
% end
% 
% function quadruple_plot2(x1,y1,x2,y2,x3,y3,x4,y4,x1r,y1r,x2r,y2r,x3r,y3r,x4r,y4r,label,leg,title)
%     % グラフを描画するためのサブプロットを作成
% 
%     % 1つ目のグラフ
%     subplot(2, 2, 1);
%     hold on
%     plot(x1, y1,"LineWidth",1.5);
%     plot(x1r, y1r,"LineWidth",1.0,"Linestyle","--");
%     xlabel(label(1));
%     ylabel(label(2));
%     legend(leg(1,:))
%     grid on;
%     hold off
% 
%     % 2つ目のグラフ
%     subplot(2, 2, 2);
%     hold on
%     plot(x2, y2,"LineWidth",1.5);
%     plot(x2r, y2r,"LineWidth",1.0,"Linestyle","--");
%     xlabel(label(3));
%     ylabel(label(4));
%     legend(leg(2,:))
%     grid on;
%     hold off
% 
%     % 3つ目のグラフ
%     subplot(2, 2, 3);
%     hold on
%     plot(x3, y3,"LineWidth",1.5);
%     plot(x3r, y3r,"LineWidth",1.0,"Linestyle","--");
%     xlabel(label(5));
%     ylabel(label(6));
%     legend(leg(3,:))
%     grid on;
%     hold off
% 
%     subplot(2, 2, 4);
%     hold on
%     plot(x4, y4,"LineWidth",1.5);
%     plot(x4r, y4r,"LineWidth",1.0,"LineStyle","--");
%     xlabel(label(7));
%     ylabel(label(8));
%     legend(leg(4,:))
%     grid on;
%     hold off
% 
%     sgtitle(title);
% 
% end
% 
% function create_y234_LinkedSubplots(x1, y1, x2, y2, x3, y3, x4, y4, label, leg, title)
%     % サンプルデータの作成（データが渡されている場合は省略可能）
% 
%     % 2×2のサブプロットを作成
%     ax1 = subplot(2, 2, 1);  % 左上
%     hold on;
%     plot(x1, y1, 'LineWidth', 1.5);
%     xlabel(label(1));
%     ylabel(label(2));
%     legend(leg{1});
%     grid on;
%     hold off;
%     axis tight;
% 
%     ax2 = subplot(2, 2, 2);  % 右上
%     hold on;
%     plot(x2, y2, 'LineWidth', 1.5);
%     xlabel(label(3));
%     ylabel(label(4));
%     legend(leg{2});
%     grid on;
%     hold off;
%     axis tight;
% 
%     ax3 = subplot(2, 2, 3);  % 左下
%     hold on;
%     plot(x3, y3, 'LineWidth', 1.5);
%     xlabel(label(5));
%     ylabel(label(6));
%     legend(leg{3});
%     grid on;
%     hold off;
%     axis tight;
% 
%     ax4 = subplot(2, 2, 4);  % 右下
%     hold on;
%     plot(x4, y4, 'LineWidth', 1.5);
%     xlabel(label(7));
%     ylabel(label(8));
%     legend(leg{4});
%     grid on;
%     hold off;
%     axis tight;
% 
%     % 軸をリンクさせる（右上、左下、右下）
%     linkaxes([ax2, ax3, ax4], 'y');
% 
%     sgtitle(title);
% 
% end
% 
% function Pn = simplify_MEC_Logger(log)
% 
%     newLog.t = log.Data.t(1:log.k);    
%     newLog.phase = log.Data.phase;
%     newLog.k = log.k;
%     newLog.fExp = log.fExp;
% 
%     % p = log.Data.agent.plant.result{1, 1}.state.p{1, i};
%     % q = log.Data.agent.plant.result{1, 1}.state.q;
%     % v = log.Data.agent.plant.result{1, 1}.state.v;
%     % w = log.Data.agent.plant.result{1, 1}.state.w;
%     for i = 1:newLog.k
%         Pn.p(:,i) = log.Data.agent.controller.result{1, i}.plant_.p;
%         Pn.q(:,i) = log.Data.agent.controller.result{1, i}.plant_.q;
%         Pn.v(:,i) = log.Data.agent.controller.result{1, i}.plant_.v;
%         Pn.w(:,i) = log.Data.agent.controller.result{1, i}.plant_.w;
%         Pn.delta_u(:,i) = log.Data.agent.controller.result{1, i}.plant_.delta_u;
%     end
% end
