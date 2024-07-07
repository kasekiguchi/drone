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
            obj.phase = varargin{1}.phase;
            obj.flg = varargin{1}.flg;
            obj.filename = varargin{1}.filename;
            obj.flg.fExp = app.fExp;
            obj.log = app.logger;
            obj.agent = app.logger.Data.agent;

            obj = obj.decide_phase();
            obj = obj.store_data();
        end

        function [] = main_figure(obj)
            %main_figure flgに沿った内容を出力
            %   引数は不要

            % obj = obj.decide_phase();
            % obj = obj.store_data();
            calt = obj.data.logt;
            
            disp('Plotting start...');
            m = 2; n = 3;
            if obj.flg.figtype; figure(1); else subplot(m,n,1); sgtitle(strcat(strrep(obj.filename,'_','-')));end
            plot(obj.data.logt, obj.data.Est(1:3,:)); hold on; plot(obj.data.logt, obj.data.Ref(1:3, :), '--'); hold off;
            obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
            grid on; xlim([obj.data.logt(1), obj.data.logt(end)]); ylim([-inf inf]);
            
            if obj.flg.figtype; figure(2); else subplot(m,n,2); end
            plot(obj.data.logt, obj.data.Est(4:6,:)); hold on; plot(obj.data.logt, obj.data.Ref(4:6, :), '--'); hold off;
            obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
            grid on; xlim([obj.data.logt(1), obj.data.logt(end)]); ylim([-inf inf]);
            
            if obj.flg.figtype; figure(3); else subplot(m,n,3); end
            plot(obj.data.logt, obj.data.Est(7:9,:)); hold on; plot(obj.data.logt, obj.data.Ref(7:9, :), '--'); hold off;
            obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.reference", "vy.reference", "vz.reference", "Location","best");
            grid on; xlim([obj.data.logt(1), obj.data.logt(end)]); ylim([-inf inf]);
            
            if obj.flg.figtype; figure(4); else subplot(m,n,4); end
            plot(obj.data.logt, obj.data.Input(1,:), "LineWidth", 1.5);
            obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("Input (Thrust)[N]"); legend("thrust.total","Location","best");
            grid on; xlim([obj.data.logt(1), obj.data.logt(end)]); ylim([-inf inf]);
            ytickformat('%.1f');
            
            if obj.flg.figtype; figure(5); else subplot(m,n,5); end
            plot(obj.data.logt, obj.data.Input(2:4,:), "LineWidth", 1.5);
            obj.background_color(-0.1, gca, obj.log.Data.phase); 
            xlabel("Time [s]"); ylabel("obj.data.Input (Torque)[N]"); legend("torque.roll", "torque.pitch", "torque.yaw","Location","best");
            grid on; xlim([obj.data.logt(1), obj.data.logt(end)]); ylim([-inf inf]);
            ytickformat('%.3f');
            
            if obj.flg.figtype; figure(6); else subplot(m,n,6); end
            % calculation time
            plot(obj.data.logt(1:end-1), diff(calt), 'LineWidth', 1.5);
            obj.background_color(-0.1, gca, obj.log.Data.phase); 
            yline(0.025, 'Color', 'red', 'LineWidth', 1.5); hold off;
            ytickformat('%.1f');
            
            if m*n > 6
            if obj.flg.figtype; figure(8); else subplot(m,n,8); end
            plotrange = 1.5;
            if obj.flg.plotmode == 1
                InnerInput = cell2mat(arrayfun(@(N) obj.agent.inner_input{N}(:,1:4)',obj.data.start_idx:obj.data.finish_idx,'UniformOutput',false));
                plot(obj.data.logt, InnerInput); 
                obj.background_color(-0.1, gca, obj.log.Data.phase); 
                xlabel("Time [s]"); ylabel("Inner input"); legend("inner_input.roll", "inner_input.pitch", "inner_input.throttle", "inner_input.yaw","Location","best");
                grid on; xlim([obj.data.logt(1), obj.data.logt(end)]); ylim([-inf inf]);
            elseif obj.flg.plotmode == 2
                plot(obj.data.Est(1,:), obj.data.Est(2,:)); hold on; plot(obj.data.Est(1,1), obj.data.Est(2,1), '*', 'MarkerSize', 10); plot(obj.data.Est(1,end), obj.data.Est(2,end), '*', 'MarkerSize', 10); hold off;
                xlabel('$$x$$', 'Interpreter', 'latex'); ylabel('$$y$$', 'Interpreter', 'latex');
                legend('trajectory', 'start.pos', 'finish.pos', 'Location', 'best');
                grid on; xlim([-plotrange plotrange]); ylim([-plotrange plotrange]);
            elseif obj.flg.plotmode == 3
                plot3(obj.data.Est(1,:), obj.data.Est(2,:), obj.data.Est(3,:)); hold on; plot3(obj.data.Est(1,1), obj.data.Est(2,1), obj.data.Est(3,1), '*', 'MarkerSize', 10); plot3(obj.data.Est(1,end), obj.data.Est(2,end), obj.data.Est(3,end), '*', 'MarkerSize', 10); hold off;
                xlabel('$$x$$', 'Interpreter', 'latex'); ylabel('$$y$$', 'Interpreter', 'latex'); zlabel('$$z$$', 'Interpreter', 'latex');
                legend('trajectory', 'start.pos', 'finish.pos', 'Location', 'best');
                grid on; xlim([-plotrange plotrange]); ylim([-plotrange plotrange]); zlim([0 inf]);
            end
            end
            
            %
            if ~obj.flg.figtype % subplotなら
                set(gcf, "WindowState", "maximized");
                % set(gcf, "Position", [960 0 960 1000])
            end

            if obj.flg.animation; obj.make_animation(); end
        end

        function main_animation(obj)
            obj.make_animation();
        end

        function [x, xr] = main_mpc(obj, cont, plotrange)
            %main_mpc MPCの予測状態をプロットする
            % var(input)から状態を計算
            %   Z[k+1] = AZ[k] + BU[k]
            %   X[k+1] = CZ[k+1]
            % obj.agent : agent

            % fval = cell2mat(arrayfun(@(N) obj.agent.controller.result{N}.mpc.fval,...
            %             obj.data.start_idx:obj.data.finish_idx,'UniformOutput',false));
            U = cell2mat(arrayfun(@(N) obj.agent.controller.result{N}.mpc.var,...
                        obj.data.start_idx:obj.data.finish_idx,'UniformOutput',false));
            % exitflag = cell2mat(arrayfun(@(N) obj.agent.controller.result{N}.mpc.exitflag,...
            %             obj.data.start_idx:obj.data.finish_idx,'UniformOutput',false));
            Xr = cell2mat(arrayfun(@(N) obj.agent.controller.result{N}.mpc.xr(1:12,:),...
                        obj.data.start_idx:obj.data.finish_idx,'UniformOutput',false));

            A = obj.agent.controller.result{1}.setting.A;
            B = obj.agent.controller.result{1}.setting.B;
            C = obj.agent.controller.result{1}.setting.C;
            H = size(U, 1) /4;
            U = reshape(U, 4, [], size(U,2));

            X = obj.data.Est;
            idx = size(U,3) - H;

            xx = zeros(12, H, idx);
            if strcmp(cont,'Koopman')
                xr = reshape(Xr, 12, H, []);
                % X = obj.data.Est;
                F = @quaternions_all;
                for i = 1:idx
                    Z(:,1) = F(X(:,i));
                    for j = 2:H
                        Z(:,j) = A*Z(:,j-1) + B*U(:,j,i);
                    end
                    xx(:,:,i) = C*Z;
                end
                x = xx;
            elseif strcmp(cont,'HL')
                % X, xrは仮装状態用に変換してあるので再変換が必要
                Xr = reshape(Xr, 12, H, []);
                xr = zeros(size(Xr));
                Xc = cell2mat(arrayfun(@(N) obj.agent.controller.result{N}.mpc.current,...
                        obj.data.start_idx:obj.data.finish_idx,'UniformOutput',false));

                for i = 1:idx
                    Z(:,1) = Xc(:,i);
                    for j = 2:H
                        Z(:,j) = A*Z(:,j-1) + B*U(:,j,i);
                    end
                    xx(:,:,i) = Xr(:,1,i) + Z; % 実状態
                    xr(:,:,i) = Xr(:,1,i) - Xr(:,:,i);  % 実状態
                end
                x(1,:,:) = xx(3,:,:); x(7,:,:) = xx(4,:,:); x(4:6,:,:) = zeros(3,H,idx);
                x(2,:,:) = xx(7,:,:); x(8,:,:) = xx(8,:,:); x(10:12,:,:) = zeros(3,H,idx);
                x(3,:,:) = xx(1,:,:); x(9,:,:) = xx(2,:,:);
            end

            %% 確認
            % figure(11); plot(obj.data.logt(1,1:idx), reshape(xr(1,1,:), 1, []));
            % figure(12); plot(obj.data.logt(1,1:idx), reshape(xr(2,1,:), 1, []));

            %-- plot
            % plotrange = 
            figure(100)
            for i = 1:idx 
                subplot(2,2,2);
                plot(x(1,:,i), x(2,:,i), 'o', 'MarkerSize', 5, 'LineWidth', 0.5); hold on;
                plot(x(1,1,i), x(2,1,i), 'p', 'MarkerSize',10, 'LineWidth', 0.5);
                plot(xr(1,:,i),xr(2,:,i), '^', 'MarkerSize', 5, 'LineWidth', 0.5); hold off;
                xlim(plotrange(1,:)); ylim(plotrange(2,:));
                % xlim([-inf inf]); ylim([-inf inf])
                xlabel('X [m]'); ylabel('Y [m]'); grid on;
                legend('Prediction', 'Current', 'Reference', 'Location', 'best');

                txt = strcat('t:', num2str(obj.data.logt(i)));
                text(-1.05,1.05, txt, 'FontSize', 15, 'Units', 'normalized');

                subplot(2,2,4);
                plot(x(1,:,i), x(3,:,i), 'o', 'MarkerSize', 5, 'LineWidth', 0.5); hold on;
                plot(x(1,1,i), x(3,1,i), 'p', 'MarkerSize',10, 'LineWidth', 0.5); 
                plot(xr(1,:,i),xr(3,:,i), '^', 'MarkerSize', 5, 'LineWidth', 0.5); hold off;
                xlim(plotrange(1,:)); ylim(plotrange(3,:)); grid on;
                % xlim([-inf inf]); ylim([-inf inf])
                xlabel('X [m]'); ylabel('Z [m]');
                legend('Prediction', 'Current', 'Reference', 'Location', 'best');

                subplot(2,2,[1,3]);
                plot3(x(1,:,i), x(2,:,i), x(3,:,i), 'o', 'MarkerSize', 5, 'LineWidth', 0.5); hold on;
                plot3(x(1,1,i), x(2,1,i), x(3,1,i), 'p', 'MarkerSize', 5, 'LineWidth', 0.5); 
                plot3(xr(1,:,i), xr(2,:,i), xr(3,:,i), '^', 'MarkerSize', 5, 'LineWidth', 0.5); hold off;
                xlim(plotrange(1,:)); ylim(plotrange(2,:)); zlim(plotrange(3,:)); grid on;
                xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
                legend('Prediction', 'Current', 'Reference', 'Location', 'best');
                % view([1 1 0])

                pause(0.001); % なんかないと動かない
            end

        end

        function make_animation(obj)
            % flightだけも可能
            logger.p = obj.data.Est(1:3,:)';
            logger.q = obj.data.Est(4:6,:)';
            logger.u = obj.data.Input';
            logger.r = obj.data.Ref(1:3,:)';
            logger.t = obj.data.logt';
            drone = DRAW_DRONE_MOTION(logger,"target",1,"opt_plot",[]);
            if obj.flg.animation_save; anipara = struct("target",1,"opt_plot",[],"mp4",obj.flg.animation_save);
            else;                      anipara = struct("target",1,"opt_plot",[]);
            end
            drone.animation(logger, anipara);
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
                    if ~obj.flg.fExp 
                        Square_coloring([obj.data.logt(1);obj.data.logt(end)], [0.9 1.0 1.0],[],[],gca); % flight phase
                        txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];
                    else
                    Square_coloring(obj.data.logt([find(logphase == 116, 1), find(logphase == 116, 1, 'last')]),[],[],[],gca); 
                    txt = [txt(:)', {'{\color[rgb]{1.0,1.0,0.9}■} :Take off phase'}]; % take off phase
                    Square_coloring(obj.data.logt([find(logphase == 102, 1), find(logphase == 102, 1, 'last')]), [0.9 1.0 1.0],[],[],gca);
                    txt = [txt(:)', {'{\color[rgb]{0.9,1.0,1.0}■} :Flight phase'}];   % flight phase
                    Square_coloring(obj.data.logt([find(logphase == 108, 1), find(logphase == 108, 1, 'last')]), [1.0 0.9 1.0],[],[],gca); 
                    txt = [txt(:)', {'{\color[rgb]{1.0,0.9,1.0}■} :Landing phase'}];  % landing phase
                    end
            end
            text(gca().XLim(2) - (gca().XLim(2) - gca().XLim(1)) * 0.45, gca().YLim(2) + (gca().YLim(2) - gca().YLim(1)) * yoffset, txt, 'FontSize', font_size);
            xlabel("Time [s]"); ylabel("Calculation time [s]"); xlim([0 obj.data.logt(end-1)])
        end

        function [obj] = store_data(obj)
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
                obj.log.data(1,"v","r","ranget",[obj.log.Data.t(obj.data.start_idx), obj.log.Data.t(obj.data.finish_idx)])'];
            % store_result = obj.data;
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
            end
        end
    end
end