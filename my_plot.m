clear
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive;
  cd(fileparts(tmp.Filename));
end

log = load('Data\DATA7.mat');
%% logを開く
logger = simplifyLogger(log.log);
t = logger.t;

c=logger.controller;
z1=c.z1;
z2=c.z2;
z3=c.z3;
z4=c.z4;
NN_xi=c.xi_log;
input = c.input;
    
c = logger.plant;
q = c.q;
p = c.p;
v = c.v;
w = c.w;


c2 = logger.reference;
ref_q = c2.q;
ref_p = c2.p;
ref_v = c2.v;
% ref_w = c.w; wのリファレンスは存在しません

figure(1);
label = ["t","p", "t","v", "t","q", "t","w"];
legend = ["x","y","z";
          "x","y","z";
          "roll","pitch","yow";
          "roll","pitch","yow"];

q = Quat2Eul(q);
hold on
triple_plot(t,p,t,v,t,q,t,w, label, legend)
hold off

figure(2);
label = ["t","p:reference", "t","v:reference", "t","q:reference", "t","w:reference"];
legend = ["x","y","z";
          "x","y","z";
          "roll","pitch","yow";
          "roll","pitch","yow"];
triple_plot(t,ref_p,t,ref_v,t,ref_q,[],[], label, legend)

figure(3);
hold on
label = ["t","z1", "t","z2", "t","z3", "t","z4"];
legend = ["z1","dz1","","";
          "z2","dz2","ddz2","dddz2";
          "z3","dz3","ddz3","dddz3";
          "z4","dz4","",""];
% triple_plot(t,[z1;NN_xi(1:2,:)],t,[z2;NN_xi(3:6,:)],t,[z3;NN_xi(7:10,:)],t,[z4;NN_xi(11:12,:)], label)
triple_plot(t,z1,t,z2,t,z3,t,z4, label,legend)
% triple_plot(t,NN_xi(1:2,:),t,NN_xi(3:6,:),t,NN_xi(7:10,:),t,NN_xi(11:12,:), label)
hold off

figure(4);
hold on
label = ["t","z1", "t","z2", "t","z3", "t","z4"];
legend = ["z1","dz1","","";
          "z2","dz2","ddz2","dddz2";
          "z3","dz3","ddz3","dddz3";
          "z4","dz4","",""];
triple_plot(t,NN_xi(1:2,:),t,NN_xi(3:6,:),t,NN_xi(7:10,:),t,NN_xi(11:12,:), label,legend)
hold off

figure(5);
label = ["time [s]","position [m]", "time [s]","velocity [m/s]", "time [s]","attitude angle [rad]", "time [s]","angular velocity [rad/s]"];
legend = ["x","y","z","xr","yr","zr";
          "x","y","z","xr","yr","zr";
          "roll","pitch","yow","rollr","pitchr","yowr";
          "roll","pitch","yow","","",""];

hold on
triple_plot2(t,p,t,v,t,q,t,w,t,ref_p,t,ref_v,t,ref_q,[],[], label, legend)
hold off

% 2. グラフのフォーマット調整
set(gca, 'FontSize', 10);  % 軸のフォントサイズを調整
set(gcf, 'Color', 'w');    % 背景を白に設定

% 3. Figureのプロパティ設定
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 23, 14]);  % サイズ設定

% 4. PDFとして保存
% print(gcf, 'output_figure.pdf', '-dpdf', '-bestfit', '-r300');
exportgraphics(gcf, 'Data/output_figure.pdf', 'ContentType', 'vector', 'Resolution', 300);


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

function triple_plot(x1,y1,x2,y2,x3,y3,x4,y4,label,leg)
    % グラフを描画するためのサブプロットを作成
    
    % 1つ目のグラフ
    subplot(2, 2, 1);
    plot(x1, y1,"LineWidth",1.5);
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,:))
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    plot(x2, y2,"LineWidth",1.5);
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    plot(x3, y3,"LineWidth",1.5);
    xlabel(label(5));
    ylabel(label(6));
    legend(leg(3,:))

    subplot(2, 2, 4);
    plot(x4, y4,"LineWidth",1.5);
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,:))
end

function triple_plot2(x1,y1,x2,y2,x3,y3,x4,y4,x1r,y1r,x2r,y2r,x3r,y3r,x4r,y4r,label,leg)
    % グラフを描画するためのサブプロットを作成
    
    % 1つ目のグラフ
    subplot(2, 2, 1);
    hold on
    plot(x1, y1,"LineWidth",1.5);
    plot(x1r, y1r,"LineWidth",1.0,"Linestyle","--");
    xlabel(label(1));
    ylabel(label(2));
    legend(leg(1,:))
    hold off
    
    % 2つ目のグラフ
    subplot(2, 2, 2);
    hold on
    plot(x2, y2,"LineWidth",1.5);
    plot(x2r, y2r,"LineWidth",1.0,"Linestyle","--");
    xlabel(label(3));
    ylabel(label(4));
    legend(leg(2,:))
    hold off
    
    % 3つ目のグラフ
    subplot(2, 2, 3);
    hold on
    plot(x3, y3,"LineWidth",1.5);
    plot(x3r, y3r,"LineWidth",1.0,"Linestyle","--");
    xlabel(label(5));
    ylabel(label(6));
    legend(leg(3,:))
    hold off

    subplot(2, 2, 4);
    hold on
    plot(x4, y4,"LineWidth",1.5);
    plot(x4r, y4r,"LineWidth",1.0,"LineStyle","--");
    xlabel(label(7));
    ylabel(label(8));
    legend(leg(4,:))
    hold off
end

