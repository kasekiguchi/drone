classdef FIGURE_EXP
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
        function obj = FIGURE_EXP(app, varargin)
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

            obj.data.m = varargin{1}.fignum(1); obj.data.n = varargin{1}.fignum(2);

            if app.fExp ~= 1
                obj.flg.plotmode = 2;
            end

            obj = obj.decide_phase();
            obj = obj.store_data();
            % obj = obj.store_data_takeoff();
        end

        function obj = master_plot(obj)
            calt = obj.data.logt;
            % plot_title = strcat(strrep(obj.filename,'_','-'));
            xrange_max = obj.data.logt(end);
            % xrange_max = obj.data.logt(end);
            set(0,'defaultAxesFontSize', 20)
            set(0, 'DefaultLineLineWidth', 1.5);
            
            disp('Plotting start...');
            obj.data.f(1) = figure(1);
            plot(obj.data.logt, obj.data.Est(1:3,:), "LineWidth", 1.5); hold on; plot(obj.data.logt, obj.data.Ref(1:3, :), '--', "LineWidth", 1.5); hold off;
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]); %obj.data.logt(end)
            ylim([-inf inf])

            obj.data.f(2) = figure(2);
            plot(obj.data.logt, obj.data.Est(4:6,:), "LineWidth", 1.5); hold on; plot(obj.data.logt, obj.data.Ref(4:6, :), '--', "LineWidth", 1.5); hold off;
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]);
            ylim([-inf inf])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end 
            
            obj.data.f(3) = figure(3);
            plot(obj.data.logt, obj.data.Est(7:9,:), "LineWidth", 1.5); hold on; plot(obj.data.logt, obj.data.Ref(7:9, :), '--', "LineWidth", 1.5); hold off;
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.reference", "vy.reference", "vz.reference", "Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]); 
            ylim([-inf inf])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end

            obj.data.f(4) = figure(4);
            plot(obj.data.logt, obj.data.Est(10:12,:), "LineWidth", 1.5); hold on; plot(obj.data.logt, obj.data.Ref(10:12, :), '--', "LineWidth", 1.5); hold off;
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Angular velocity [m/s]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]); 
            ylim([-inf inf])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            
            obj.data.f(5) = figure(5);
            plot(obj.data.logt, obj.data.Input(1,:), "LineWidth", 1.5);
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Input (Thrust)[N]"); legend("thrust.total","Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]);
            ylim([-inf inf])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            ytickformat('%.3f');
            
            obj.data.f(6) = figure(6);
            plot(obj.data.logt, obj.data.Input(2:4,:), "LineWidth", 1.5);
            % obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Input (Torque)[N]"); legend("torque.roll", "torque.pitch", "torque.yaw","Location","best");
            grid on; xlim([obj.data.logt(1), xrange_max]);
            ylim([-inf inf])% if isempty(obj.data.yrange); ylim([-inf inf]); else; ylim(obj.data.yrange,:); end
            ytickformat('%.3f');
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
            obj.data.logt = obj.log.data(0,"t",[],"ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)]); 
            if obj.flg.timerange; obj.data.logt = obj.data.logt - obj.data.logt(1); end

            obj.data.Est = [obj.log.data(1,"p","e","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
                    obj.log.data(1,"q","e","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
                    obj.log.data(1,"v","e","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
                    obj.log.data(1,"w","e","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])'];
            obj.data.Sen = [obj.log.data(1,"p","s","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
                    obj.log.data(1,"q","s","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])'];
            obj.data.Input = obj.log.data(1,"input",[],"ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
            
            obj.data.Ref = [obj.log.data(1,"p","r","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
                zeros(size(obj.data.Est(1:3,:)));
                obj.log.data(1,"v","r","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])';
                zeros(size(obj.data.Est(1:3,:)));];
            % store_result = obj.data;

        end

        function obj = store_data_takeoff(obj)
            obj.data.calt =  cell2mat(arrayfun(@(N) obj.log.Data.agent.controller.result{N}.mpc.calt,...
                            find(obj.log.Data.phase(2:end)==116,1,'first')+1:find(obj.log.Data.phase(2:end)==116, 1, 'last')+1,'UniformOutput',false));
        end

        function obj = decide_phase(obj)
            switch obj.phase
                case 1
                    obj.data.start_idx = find(obj.log.Data.phase==102,1,'first');
                    obj.data.finish_idx = find(obj.log.Data.phase==102,1,'last')-1;
                    % takeoff_start = 0;
                    % takeoff_finish = 0;
                case 2
                    obj.data.start_idx = 1;
                    obj.data.finish_idx = find(obj.log.Data.phase==0,1,'first')-1;
                    % takeoff_start = find(obj.log.Data.phase==116,1,'first');
                    % takeoff_finish = find(obj.log.Data.phase==116,1,'last');
                case 3 % flight後任意の時間で切る
                    obj.data.start_idx = find(obj.log.Data.phase==102,1,'first');
                    obj.data.finish_idx = obj.data.start_idx+obj.data.time_idx;
                    if obj.data.finish_idx > find(obj.log.Data.phase==102,1,'last')-1
                        obj.data.finish_idx = find(obj.log.Data.phase==102,1,'last')-1;
                    end
            end
        end

        function show(obj)
            obj.data
        end
    end
end