%%グラフ生成用のプログラム
close all
%%
ceilig_sensor = 1;%天井接地検知用のセンサーを用いているかどうか 0 or 1
T = logger.Data.t(1:logger.k);
time_ceiling_sensor = 0;
%% 12月実験用
for plot_i = 1:logger.k%グラフのプロット
        VL(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.VL_length;
end
%% 電圧，電流，回転数(234)
name_class = ["current";"voltage";"rpm"];
name_legend = ["current [A]";"voltage [V]";"morter speed [rpm]"];
for name_i = 1:length(name_class)
    figure(name_i+1)
    hold on
    for plot_i = 1:logger.k%グラフのプロット
        Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.ros2.(name_class(name_i));
    end
    plot(T(1:logger.k),Y/100,'LineWidth',1)
%     txt = {''};
%     if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%         Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%         txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
%     end
%     if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%         Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%         txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
%     end
%     if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%         Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
%         txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
%     end
% 
%     if length([find(VL > 60, 1), find(VL < 60, 1, 'last')]) == 2%12月実験用
%         Square_coloring(logger.Data.t([find(VL < 60, 1), find(VL < 60, 1, 'last')]), 'g'); % landing phase
%     end

%     if ceilig_sensor == 1 %接地時間の範囲のプロット
%         logger.Data.agent.sensor.result{1, 1}.switch
%         for plot_i = 1:logger.k
%             VL(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.switch;
%         end
%         if length([find( VL == 1, 1), find(VL == 1, 1, 'last')]) == 2
%             Square_coloring(logger.Data.t([find(VL < 60, 1), find(VL > 65, 1, 'last')]), 'y'); % landing phase
%         end
%     end

    legend('morter 1','morter 2','morter 3','morter 4')
    xlabel('time [s]')
    ylabel(name_legend(name_i))
    hold off
end
%% 電力(5)
figure(5)
clear T
T = logger.Data.t(1:logger.k);
hold on
for plot_i = 1:logger.k%グラフのプロット
    Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.ros2.voltage.*logger.Data.agent.sensor.result{1, plot_i}.ros2.current;
end
plot(T(1:logger.k),Y/100,'LineWidth',1)
% txt = {''};
% if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%     txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
% end
% if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%     txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
% end
% if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
% end
if length([find(VL > 60, 1), find(VL < 60, 1, 'last')]) == 2%12月実験用
    Square_coloring(logger.Data.t([find(VL < 60, 1), find(VL < 60, 1, 'last')]), 'g'); % landing phase
end
legend('morter 1','morter 2','morter 3','morter 4')
xlabel('time [s]')
ylabel('power [W]')
hold off
%% z throttle　sr(6)
clear T
T = logger.Data.t(1:logger.k);
figure(6)
name_class = ["ceiling";"reference";"sensor";"throttle"];
%name_class = ["ceiling";"sensor";"throttle"];
hold on
plot([0 53],[3 3],"LineStyle","--",'LineWidth',1.5,'Color',[0.15,0.15,0.15])
Y=[];
for plot_i = 1:logger.k%グラフのプロット
    Y(plot_i,1) = logger.Data.agent.reference.result{1, plot_i}.state.p(3); 
    Y(plot_i,2) = logger.Data.agent.sensor.result{1, plot_i}.state.p(3);
    Y(plot_i,3) = logger.Data.agent.inner_input{1, plot_i}(3);
end
plot(T(1:logger.k),Y(:,1),'LineWidth',4,'Color',[0.39,0.83,0.07])
plot(T(1:logger.k),Y(:,2),'LineWidth',2.5,'Color',[0.85,0.33,0.10])
ylim([0 3])
xlabel('time [s]')
ylabel('z [m]')
clear txt
txt = {''};
% if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%     txt = {txt{:}, '{\color[rgb]{1.00,1.00,0.00}■} :Take off phase'};
% end
% if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%     txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :Flight phase'};
% end
% if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%     Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [0.0,1.0,1.0]); % landing phase
%     txt = {txt{:}, '{\color[rgb]{0.0,1.0,1.0}■} :Landing phase'};
% end
% XLim = get(gca, 'XLim');
% YLim = get(gca, 'YLim');
% 
% if length([find(Y(:,2) > 2.93, 1), find(Y(:,2) > 2.93, 1, 'last')]) == 2%12月実験用
%     margin = 0.002*(YLim(2)-YLim(1));
%     Square_coloring(logger.Data.t([find(Y(:,2) > 2.93, 1), find(Y(:,2) > 2.93, 1, 'last')]), '1.00,0.70,1.00'); % landing phase
% %     rectangle('Position',[T(find(Y(:,2) > 2.93, 1)) margin T(find(Y(:,2)>2.93,1,'last'))-T(find(Y(:,2)>2.93,1)) ylimit(2)-2*margin],'EdgeColor','r')
%     txt = {txt{:}, '{\color[rgb]{1.00,0.70,1.00}■} : on ceiling phase'};
% end
% text(XLim(2),YLim(2), txt)
yyaxis right
plot(T(1:logger.k),Y(:,3),'LineWidth',1.5,'Color',[0.00,0.45,0.74])
ylabel('inner input')
legend(name_class)
legend('Location','best')
hold off
%%
