clear;clc;
cf = pwd;
close all
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive;
  cd(fileparts(tmp.Filename));
end

log = load('Data\test.mat');


%% logを開く
flag = "sim";
% flag = "GUI";

logger = simplifyLogger(log.logger(1,1));
t = logger.t;




if flag == "sim"
    figure(5);%detla_u
    % title = "detla u";
    title = "";
    label = ["Time","Total thrust", "Time","Torque : roll", "Time","Torque : pitch", "Time","Torque : Yaw"];
    legend = ["Noninal","\Deltau","Pich","Yaw";
            "Noninal","\Deltau","","";
            "Noninal","\Deltau","","";
            "Noninal","\Deltau","",""];
    
    hold on
    create_y234_LinkedSubplots(t,logger.controller.input, logger.controller.delta_u, label, legend, title)
    hold off
    
    % 2. グラフのフォーマット調整
    set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
    set(gcf, 'Color', 'w');    % 背景を白に設定
    
    % 3. Figureのプロパティ設定
    set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
    
    % 4. PDFとして保存
    % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
    exportgraphics(gcf, 'Data/input.pdf', 'ContentType', 'vector', 'Resolution', 300);
    
    figure(8);
    hold on
    % title = "Pa state";
    title = "";
    % title = [];
    label = ["Time","Position", "Time","Velocity", "Time","Angle", "Time","Angular velocity"];
    legend = ["x","y","z","x:reference","y:reference","z:reference";
              "x","y","z","x:reference","y:reference","z:reference";
              "Roll","Pitch","Yaw","Yaw:reference","","";
              "Roll","Pitch","Yaw","","",""];
    quadruple_plot2(t,logger, label, legend, title)
    hold off
    
    % 2. グラフのフォーマット調整
    set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
    set(gcf, 'Color', 'w');    % 背景を白に設定
    
    % 3. Figureのプロパティ設定
    set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
    
    % 4. PDFとして保存
    % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
    exportgraphics(gcf, 'Data/Pa_state.pdf', 'ContentType', 'vector', 'Resolution', 300);
end
if flag == "GUI"

    figure(5);%detla_u
    % title = "detla u";
    title = "";
    label = ["Time","Total thrust", "Time","Torque : roll", "Time","Torque : pitch", "Time","Torque : Yaw"];
    legend = ["","\Deltau","Pich","Yaw";
            "","\Deltau","","";
            "","\Deltau","","";
            "","\Deltau","",""];
    
    hold on
    create_y234_LinkedSubplots_forGUI(t,logger.controller.input, label, legend, title)
    hold off
    
    % 2. グラフのフォーマット調整
    set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
    set(gcf, 'Color', 'w');    % 背景を白に設定
    
    % 3. Figureのプロパティ設定
    set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
    
    % 4. PDFとして保存
    % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
    exportgraphics(gcf, 'Data/input_GUI.pdf', 'ContentType', 'vector', 'Resolution', 300);
    
    figure(8);
    hold on
    % title = "Pa state";
    title = "";
    % title = [];
    label = ["Time","Position", "Time","Velocity", "Time","Angle", "Time","Angular velocity"];
    legend = ["x","y","z","x:reference","y:reference","z:reference";
              "x","y","z","x:reference","y:reference","z:reference";
              "Roll","Pitch","Yaw","Yaw:reference","","";
              "Roll","Pitch","Yaw","","",""];
    quadruple_plot2_forGUI(t,logger.plant, logger.reference, label, legend, title)
    hold off
    
    % 2. グラフのフォーマット調整
    set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
    set(gcf, 'Color', 'w');    % 背景を白に設定
    
    % 3. Figureのプロパティ設定
    set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
    
    % 4. PDFとして保存
    % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
    exportgraphics(gcf, 'Data/state_GUI.pdf', 'ContentType', 'vector', 'Resolution', 300);
end
 if flag == "offline"

     figure(8);
    hold on
    % title = "Pa state";
    title = "";
    % title = [];
    label = ["Time","Position", "Time","Velocity", "Time","Angle", "Time","Angular velocity"];
    legend = ["x","y","z","x:NN","y:NN","z:NN";
              "x","y","z","x:NN","y:NN","z:NN";
              "Roll","Pitch","Yaw","Roll:NN","Pitch:NN","Yaw:NN";
              "Roll","Pitch","Yaw","Roll:NN","Pitch:NN","Yaw:NN"];
    quadruple_plot2_for_offlineEST(t,logger.plant,label,legend,title)
    hold off
    
    % 2. グラフのフォーマット調整
    set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
    set(gcf, 'Color', 'w');    % 背景を白に設定
    
    % 3. Figureのプロパティ設定
    set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定
    
    % 4. PDFとして保存
    % print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
    exportgraphics(gcf, 'Data/state_offline.pdf', 'ContentType', 'vector', 'Resolution', 300);
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

function quadruple_plot2(t,logger,label,leg,title)
    % グラフを描画するためのサブプロットを作成
    

    colors1 = [0.1 0.45 0.8;  % 青 (x)
          0.85 0.35 0.2;  % オレンジ (y)
          0.9 0.7 0.2];   % 黄 (z)

colors2 = [0.3 0.55 0.75;  % 落ち着いた青
            0.8 0.45 0.3;   % 落ち着いたオレンジ
            0.8 0.7 0.4];   % 落ち着いた黄

    % 1つ目のグラフ
    subplot(2, 2, 1);
    hold on
    for i =1:3
    plot(t, logger.estimator.p(i,:),"LineWidth",1.5, "Color",colors1(i,:));
    end
    for i =1:3
    plot(t, logger.reference.p(i,:),"LineWidth",1.5,"Linestyle","--", "Color",colors2(i,:));
    end
    xlabel(label(1));
    ylabel(label(2));
    ylim([-3,3])
    legend(leg(1,:))
    grid on;
    hold off
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    hold on
    for i =1:3
    plot(t, logger.estimator.v(i,:),"LineWidth",1.5, "Color",colors1(i,:));
    end
    for i =1:3
    plot(t, logger.reference.v(i,:),"LineWidth",1.5,"Linestyle","--", "Color",colors2(i,:));
    end
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    grid on;
    hold off
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    hold on
    for i =1:3
    plot(t, logger.estimator.q(i,:),"LineWidth",1.5, "Color",colors1(i,:));
    end

    plot(t, logger.reference.q(3,:),"LineWidth",1.5,"Linestyle","--", "Color",colors2(i,:));
    xlabel(label(5));
    ylabel(label(6));
    % ylim([-pi pi]);
    legend(leg(3,:))
    grid on;
    hold off

    subplot(2, 2, 4);
    hold on
    for i =1:3
    plot(t, logger.estimator.w(i,:),"LineWidth",1.5, "Color",colors1(i,:));
    end
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,:))
    grid on;
    hold off

    sgtitle(title);
end

function quadruple_plot2_for_offlineEST(t,plant,label,leg,title)
    % グラフを描画するためのサブプロットを作成
    
    % 1つ目のグラフ
    subplot(2, 2, 1);
    hold on
    plot(t, plant.p,"LineWidth",1.5);
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,:))
    grid on;
    hold off
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    hold on
    plot(t, plant.v,"LineWidth",1.5);
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    grid on;
    hold off
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    hold on
    plot(t, plant.q,"LineWidth",1.5);
    xlabel(label(5));
    ylabel(label(6));
    % ylim([-pi pi]);
    legend(leg(3,:))
    grid on;
    hold off

    subplot(2, 2, 4);
    hold on
    plot(t, plant.w,"LineWidth",1.5);
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,:))
    grid on;
    hold off

    sgtitle(title);
end

function quadruple_plot2_forGUI(t,state,reference,label,leg,title)
    % グラフを描画するためのサブプロットを作成
    
    % 1つ目のグラフ
    subplot(2, 2, 1);
    hold on
    plot(t, state.p,"LineWidth",1.5);
    plot(t, reference.p,"LineWidth",1.5,"Linestyle","--");
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,:))
    grid on;
    hold off
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    hold on
    plot(t, state.v,"LineWidth",1.5);
    plot(t, reference.v,"LineWidth",1.5,"Linestyle","--");
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    grid on;
    hold off
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    hold on
    plot(t, quat2eul(state.q'),"LineWidth",1.5);
    plot(t, reference.q(3,:),"LineWidth",1.5,"Linestyle","--");
    xlabel(label(5));
    ylabel(label(6));
    % ylim([-pi pi]);
    legend(leg(3,:))
    grid on;
    hold off

    subplot(2, 2, 4);
    hold on
    plot(t, state.w,"LineWidth",1.5);
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
    ylabel(label(2));legend(leg(1,1:2));
    % legend(leg(1,1:2), "Interpreter","latex" );
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

function create_y234_LinkedSubplots_forGUI(t, u, label, leg, title)
    % サンプルデータの作成（データが渡されている場合は省略可能）
    
    % 2×2のサブプロットを作成
    ax1 = subplot(2, 2, 1);  % 左上
    hold on;
    plot(t, u(1,:), 'LineWidth', 1.5);
    xlabel(label(1));
    ylabel(label(2));
    % legend(leg(1,1:2));
    % legend(leg(1,1:2), "Interpreter","latex" );
    grid on;
    hold off;
    axis tight;

    ax2 = subplot(2, 2, 2);  % 右上
    hold on;
    plot(t, u(2,:), 'LineWidth', 1.5);
    xlabel(label(3));
    ylabel(label(4));
    % legend(leg(2,1:2));
    grid on;
    hold off;
    axis tight;

    ax3 = subplot(2, 2, 3);  % 左下
    hold on;
    plot(t, u(3,:), 'LineWidth', 1.5);
    xlabel(label(5));
    ylabel(label(6));
    % legend(leg(3,1:2));
    grid on;
    hold off;
    axis tight;

    ax4 = subplot(2, 2, 4);  % 右下
    hold on;
    plot(t, u(4,:), 'LineWidth', 1.5);
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
