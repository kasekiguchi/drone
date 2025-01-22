classdef FIGURE_EXP_master
    %FIGURE_EXP 結果をプロット、アニメーションを描画する
    %   main_figure() : flgに沿った内容を出力
    %   main_animation() : アニメーションのみを出力(flg.animationは関係なし)
    %   main_mpc() : MPCの予測状態を出力
    %   引数：app = struct(logger, fExp)
    %         varargin = struct(phase, flg, filename)

    properties
        % figtype = 0; % 0:subplot
        % savefig = 0;
        % animation_save = 0;
        % animation = 0;
        % timerange = 1;
        % plotmode = 3; % 1:inner_input, 2:xy, 3:xyz
        flg
        phase
        log
        filename
        data
        agent
    end

    methods
        function obj = FIGURE_EXP_master(app, varargin)
            %FIGURE_EXP 引数をもとにデータ範囲、データの結合を行う
            %   コンストラクタ実行さえすれば全ての関数を使用可能
            %   obj.data.fignumがあるので出力にはからなずobjを含ませる
            obj.phase = varargin{1}.phase;
            obj.flg = varargin{1}.flg;
            obj.filename = varargin{1}.filename;
            obj.flg.fExp = app.fExp;
            obj.flg.mpc = 0;
            obj.log = app.logger;
            obj.agent = app.logger.Data.agent;
            obj.data.fignum = 1;
            obj.data.time_idx = varargin{1}.time_idx;
            obj.data.yrange = varargin{1}.yrange;
            obj.data.name = varargin{2}.model;

            if app.fExp ~= 1
                obj.flg.plotmode = 2;
            end

            obj = obj.decide_phase();
            obj = obj.store_data();
            % obj = obj.store_data_takeoff();
        end

        function [obj] = main_figure(obj)
            %main_figure flgに沿った内容を出力
            %   引数は不要

            % obj = obj.decide_phase();
            % obj = obj.store_data();
            calt = obj.data.logt;
            % plot_title = strcat(strrep(obj.filename,'_','-'));
            plot_title = strcat(strrep(obj.data.name,'_','-'));
            xrange_max = obj.data.logt(end);
            % xrange_max = obj.data.logt(end);
            set(0,'defaultAxesFontSize', 20)
            set(0, 'DefaultLineLineWidth', 1.5);
            
            disp('Plotting start...');
            m = 2; n = 3;
            if obj.flg.figtype; figure(obj.data.fignum); else subplot(m,n,1); sgtitle(plot_title);end
            plot(obj.data.logt, obj.data.Est(1:3,:), "LineWidth", 1.5); hold on; plot(obj.data.logt, obj.data.Ref(1:3, :), '--', "LineWidth", 1.5); hold off;
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]); %obj.data.logt(end)
            ylim([-0.1 0.7])
            obj.data.fignum = obj.data.fignum+1;

            if obj.flg.figtype; figure(obj.data.fignum); else subplot(m,n,2); end
            plot(obj.data.logt, obj.data.Est(4:6,:), "LineWidth", 1.5); hold on; plot(obj.data.logt, obj.data.Ref(4:6, :), '--', "LineWidth", 1.5); hold off;
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]);
            ylim([-0.1 0.1])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end 
            obj.data.fignum = obj.data.fignum+1;
            
            if obj.flg.figtype; figure(obj.data.fignum); else subplot(m,n,3); end
            plot(obj.data.logt, obj.data.Est(7:9,:), "LineWidth", 1.5); hold on; plot(obj.data.logt, obj.data.Ref(7:9, :), '--', "LineWidth", 1.5); hold off;
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.reference", "vy.reference", "vz.reference", "Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]); 
            ylim([-0.2 0.2])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            obj.data.fignum = obj.data.fignum+1;

            if obj.flg.figtype; figure(obj.data.fignum); else subplot(m,n,4); end
            plot(obj.data.logt, obj.data.Est(10:12,:), "LineWidth", 1.5); hold on; plot(obj.data.logt, obj.data.Ref(10:12, :), '--', "LineWidth", 1.5); hold off;
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Angular velocity [m/s]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]); 
            ylim([-0.2 0.2])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            obj.data.fignum = obj.data.fignum+1;
            
            if obj.flg.figtype; figure(obj.data.fignum); else subplot(m,n,5); end
            plot(obj.data.logt, obj.data.Input(1,:), "LineWidth", 1.5);
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Input (Thrust)[N]"); legend("thrust.total","Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]);
            ylim([5.7 5.9])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            ytickformat('%.3f');
            obj.data.fignum = obj.data.fignum+1;
            
            if obj.flg.figtype; figure(obj.data.fignum); else subplot(m,n,6); end
            plot(obj.data.logt, obj.data.Input(2:4,:), "LineWidth", 1.5);
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Input (Torque)[N]"); legend("torque.roll", "torque.pitch", "torque.yaw","Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]);
            ylim([-0.1 0.1])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            ytickformat('%.3f');
            obj.data.fignum = obj.data.fignum+1;
            % 
            % if obj.flg.figtype; figure(obj.data.fignum); else subplot(m,n,6); end
            % % calculation time
            % plot(obj.data.logt(1:end-1), diff(calt), 'LineWidth', 1.5);
            % % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            % yline(0.025, '--', 'Color', 'red', 'LineWidth', 1.5); hold off;
            % ytickformat('%.3f'); xlim([0 xrange_max]); grid on;
            % xlabel("Time [s]"); ylabel("Calculation time [s]"); legend("calculation time", "control time","Location","best");
            % ylim([0 0.025])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            % obj.data.fignum = obj.data.fignum+1;
            % 
            % if m*n > 6
            % if obj.flg.figtype; figure(obj.data.fignum); else subplot(m,n,8); end
            % plotrange = 1.5;
            % if obj.flg.plotmode == 1
            %     InnerInput = cell2mat(arrayfun(@(N) obj.agent.inner_input{N}(:,1:4)',obj.data.start_idx:obj.data.finish_idx,'UniformOutput',false));
            %     plot(obj.data.logt, InnerInput); 
            %     % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            %     xlabel("Time [s]"); ylabel("Inner input"); legend("inner_input.roll", "inner_input.pitch", "inner_input.throttle", "inner_input.yaw","Location","best");
            %     grid on; xlim([obj.data.logt(1), obj.data.logt(end)]);
            %     ylim([-inf inf])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            % elseif obj.flg.plotmode == 2
            %     plot(obj.data.Est(1,:), obj.data.Est(2,:)); hold on; plot(obj.data.Est(1,1), obj.data.Est(2,1), '*', 'MarkerSize', 10); plot(obj.data.Est(1,end), obj.data.Est(2,end), '*', 'MarkerSize', 10); hold off;
            %     xlabel('$$x$$', 'Interpreter', 'latex'); ylabel('$$y$$', 'Interpreter', 'latex');
            %     legend('trajectory', 'start.pos', 'finish.pos', 'Location', 'best');
            %     grid on; xlim([-plotrange plotrange]); ylim([-plotrange plotrange]);
            % elseif obj.flg.plotmode == 3
            %     plot3(obj.data.Est(1,:), obj.data.Est(2,:), obj.data.Est(3,:)); hold on; plot3(obj.data.Est(1,1), obj.data.Est(2,1), obj.data.Est(3,1), '*', 'MarkerSize', 10); plot3(obj.data.Est(1,end), obj.data.Est(2,end), obj.data.Est(3,end), '*', 'MarkerSize', 10); hold off;
            %     xlabel('$$x$$', 'Interpreter', 'latex'); ylabel('$$y$$', 'Interpreter', 'latex'); zlabel('$$z$$', 'Interpreter', 'latex');
            %     legend('trajectory', 'start.pos', 'finish.pos', 'Location', 'best');
            %     grid on; xlim([-plotrange plotrange]); ylim([-plotrange plotrange]); zlim([0 inf]);
            % end
            % end
            obj.data.fignum = obj.data.fignum+1;
            
            %
            if ~obj.flg.figtype % subplotなら
                set(gcf, "WindowState", "maximized");
                % set(gcf, "Position", [960 0 960 1000])
            end

            if obj.flg.animation; obj.make_animation(); end
        end

        function background_color(obj, yoffset, gca, logphase)
            txt = {''};
            font_size = 10;
            % yoffset = -0.1;
            switch obj.phase
                case 1 %flight
                    % Square_coloring(obj.log.Data.t([find(obj.log.Data.phase == 102, 1), find(obj.log.Data.phase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],gca); % flight phase
                    Square_coloring([obj.data.logt(1);obj.data.logt(end)], [0.9 1.0 1.0],[],[],gca); % flight phase
                    txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];
                case 2 %all time
                    % if ~obj.flg.fExp 
                    % Square_coloring([obj.data.logt(1);obj.data.logt(end)], [0.9 1.0 1.0],[],[],gca); % flight phase
                    % txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];
                    % else
                    Square_coloring(obj.data.logt([find(logphase == 116, 1), find(logphase == 116, 1, 'last')]),[],[],[],gca); 
                    txt = [txt(:)', {'{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'}]; % take off phase
                    Square_coloring(obj.data.logt([find(logphase == 102, 1), find(logphase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],gca);
                    txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];   % flight phase
                    Square_coloring(obj.data.logt([find(logphase == 108, 1), find(logphase == 108, 1, 'last')]), [1.0 0.9 1.0],[],[],gca); 
                    txt = [txt(:)', {'{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'}];  % landing phase
                    % end
                case 3 %takeoff
                    Square_coloring(obj.data.logt([find(logphase == 116, 1), find(logphase == 116, 1, 'last')]),[],[],[],gca); 
                    txt = [txt(:)', {'{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'}]; % take off phase
            end
            text(gca().XLim(2) - (gca().XLim(2) - gca().XLim(1)) * 0.45, gca().YLim(2) + (gca().YLim(2) - gca().YLim(1)) * yoffset, txt, 'FontSize', font_size);
            xlabel("Time [s]"); ylabel("Calculation time [s]"); xlim([0 obj.data.logt(end-1)])
        end

        function obj = store_data(obj)
            disp('Storing data...');
            % obj.data.logt = obj.log.data(0,"t",[],"ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)]); 
            % if obj.flg.timerange; obj.data.logt = obj.data.logt - obj.data.logt(1); end
            % 
            % obj.data.Est = [obj.log.data(1,"p","e","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
            %         obj.log.data(1,"q","e","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
            %         obj.log.data(1,"v","e","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
            %         obj.log.data(1,"w","e","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])'];
            % obj.data.Sen = [obj.log.data(1,"p","s","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
            %         obj.log.data(1,"q","s","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])'];
            % obj.data.Input = obj.log.data(1,"input",[],"ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
            % 
            % obj.data.Ref = [obj.log.data(1,"p","r","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
            %     zeros(size(obj.data.Est(1:3,:)));
            %     obj.log.data(1,"v","r","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])'];

            range = obj.data.start_idx:obj.data.finish_idx;
            obj.data.logt = obj.log.Data.param.t(range);
            if obj.flg.timerange; obj.data.logt = obj.data.logt - obj.data.logt(1); end % t=0~に変換
            obj.data.Est = cell2mat(arrayfun(@(N) obj.agent.estimator.result{N}.state.get(),range,'UniformOutput',false));
            obj.data.Ref = [cell2mat(arrayfun(@(N) obj.agent.reference.result{N}.state.p,range,'UniformOutput',false));
                            zeros(size(obj.data.Est(1:3,:)));
                            cell2mat(arrayfun(@(N) obj.agent.reference.result{N}.state.v,range,'UniformOutput',false));
                            zeros(size(obj.data.Est(1:3,:)))];
            obj.data.Sen = zeros(size(obj.data.Est(1:3,:)));
            obj.data.Input = cell2mat(arrayfun(@(N) obj.agent.input{N},range,'UniformOutput',false));
        end

        function obj = store_data_takeoff(obj)
            obj.data.calt =  cell2mat(arrayfun(@(N) obj.log.Data.agent.controller.result{N}.mpc.calt,...
                            find(obj.log.Data.phase(2:end)==116,1,'first')+1:find(obj.log.Data.phase(2:end)==116, 1, 'last')+1,'UniformOutput',false));
        end

        function obj = decide_phase(obj)
            phase = obj.log.Data.param.phase;
            switch obj.phase
                case 1
                    obj.data.start_idx = find(phase==102,1,'first');
                    obj.data.finish_idx = find(phase==102,1,'last')-1;
                    % takeoff_start = 0;
                    % takeoff_finish = 0;
                case 2
                    obj.data.start_idx = 1;
                    obj.data.finish_idx = find(phase==0,1,'first')-1;
                    % takeoff_start = find(obj.log.Data.phase==116,1,'first');
                    % takeoff_finish = find(obj.log.Data.phase==116,1,'last');
                case 3 % flight後任意の時間で切る
                    obj.data.start_idx = find(phase==102,1,'first');
                    obj.data.finish_idx = obj.data.start_idx+obj.data.time_idx;
                    if obj.data.finish_idx > find(phase==102,1,'last')-1
                        obj.data.finish_idx = find(phase==102,1,'last')-1;
                    end
            end
        end

        function show(obj)
            obj.data
        end
    end
end