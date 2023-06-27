classdef plot_telemetry 
    %PLOT_TELEMETRY このクラスの概要をここに記述
    %   詳細説明をここに記述
%     tel  =  plot_telemetry(); %コマンドウィンドに打ち込んで定義する
%     tel.plot_cvr(logger);     %電圧・電流・回転数をプロット
%     tel.plot_w(logger);       %電力をプロット
%     tel.plot_ave(logger);     %電圧・電流・回転数の平均地をプロット
    properties
    end
    
    methods
        function obj = plot_telemetry()
        end
        
        function plot_cvr(~,logger)
            T = logger.Data.t(1:logger.k);
            name_class = ["current";"voltage";"rpm"];
            name_legend = ["current [A]";"voltage [V]";"morter speed [rpm]"];
            for name_i = 1:length(name_class)
                figure(name_i+1)
                hold on
                for plot_i = 1:logger.k%グラフのプロット
                    Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.rostwo.(name_class(name_i));
                end
                plot(T(1:logger.k),Y/100,'LineWidth',1)
                %% phaseのプロット
%                 txt = {''};
%                 if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%                     Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%                     txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
%                 end
%                 if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%                     Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%                     txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
%                 end
%                 if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%                     Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
%                     txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
%                 end
                %% 凡例，軸ラベルのプロット
                legend('morter 1','morter 2','morter 3','morter 4')
                xlabel('time [s]')
                ylabel(name_legend(name_i))
                legend('Location','best')
                ax = gca;
                ax.FontSize = 15;
                hold off
            end
        end

        function plot_w(~,logger)
            figure(5)
            clear T
            T = logger.Data.t(1:logger.k);
            hold on
            for plot_i = 1:logger.k%グラフのプロット
                Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.rostwo.voltage.*logger.Data.agent.sensor.result{1, plot_i}.rostwo.current;
            end
            plot(T(1:logger.k),Y/10000,'LineWidth',1)
            %% phaseのプロット
%             txt = {''};
%             if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%                 Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%                 txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
%             end
%             if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%                 Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%                 txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
%             end
%             if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%                 Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
%                 txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
%             end
            %% 凡例，軸ラベルのプロット
            legend('morter 1','morter 2','morter 3','morter 4')
            xlabel('time [s]')
            ylabel('power [W]')
            legend('Location','best')
            ax = gca;
            ax.FontSize = 15;
            hold off
        end

        function plot_ave(~,logger)
            clear Y
            T = logger.Data.t(1:logger.k);
            name_class = ["voltage";"current";"rpm"];
            name_legend = ["voltage [V]";"current [A]";"morter speed [rpm]"];
            for name_i = 1:length(name_class)
                figure(name_i+1)
                hold on
                for plot_i = 1:logger.k%グラフのプロット
                    Y(plot_i,:) = logger.Data.agent.sensor.result{1, plot_i}.rostwo.(name_class(name_i));%
                end
                Y_ave = mean(Y,2);
                plot(T(1:logger.k),Y_ave,'LineWidth',1)
                txt = {''};
             %% phaseのプロット
%                 txt = {''};
%                 if length([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]) == 2%フェーズのプロット
%                     Square_coloring(logger.Data.t([find(logger.Data.phase == 116, 1), find(logger.Data.phase == 116, 1, 'last')]),[1.00,1.00,0.00]); % take off phase
%                     txt = {txt{:}, '{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'};
%                 end
%                 if length([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]) == 2
%                     Square_coloring(logger.Data.t([find(logger.Data.phase == 102, 1), find(logger.Data.phase == 102, 1, 'last')]), [0.0,1.0,1.0]); % flight phase
%                     txt = {txt{:}, '{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'};
%                 end
%                 if length([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]) == 2
%                     Square_coloring(logger.Data.t([find(logger.Data.phase == 108, 1), find(logger.Data.phase == 108, 1, 'last')]), [1.0,0.7,1.0]); % landing phase
%                     txt = {txt{:}, '{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'};
%                 end
            %% 凡例，軸ラベルのプロット
                xlabel('time [s]')
                ylabel(name_legend(name_i))
                ax = gca;
                ax.FontSize = 15;
                hold off
            end
        end
    end
end

