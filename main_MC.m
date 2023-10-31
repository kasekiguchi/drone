% Drone 班用共通プログラム update sekiguchi
%-- 連続時間モデル　リサンプリングつき これを基に変更
opengl software
%% Initialize settings(ファイルの読み込み)
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
run("main1_setting_MC.m");
run("main2_agent_setup_MC.m");
%agent.set_model_error("ly",0.02);
%% set logger(デフォルトで取らないデータを追加で取る際に使用)
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
%% main loop(シミュレーションや実機の計算，グラフの描写，アニメーション)
    fInput = 0;
    fV = 0;
    fVcount = 1;
    fWeight = 0; % 重みを変化させる場合 TTfWeight = 1
    fFirst = 1; % 一回のみ回す場合
    fRemove = 0;    % 終了判定
    fLanding = 0;   % 着陸かどうか 目標軌道を変更する
    fLanding_comp = 0;
    fCount_landing = 0;
    fc = 0;     % 着陸したときだけx，y座標を取得
    totalT = 0;
    idx = 0;

    %-- 初期設定 controller.mと同期させる
    Params.H = 10;   %Params.H
    Params.dt = 0.07;  %Params.dt
    Params.dT = dt;
    %-- 配列サイズの定義
    Params.state_size = 12;
    Params.input_size = 4;
    Params.total_size = 16;
    % Reference.mを使えるようにする
    Params.ur = 0.5884 * 9.81 / 4 * ones(Params.input_size, 1);
%     Params.ur = 1.443 * ones(Params.input_size,1);
    xr0 = zeros(Params.state_size, Params.H);

   
    data.xr{idx+1} = 0;

    fprintf("Initial Position: %4.2f %4.2f %4.2f\n", initial.p);
    %%

run("main3_loop_setup.m");

try
    while round(time.t, 5) <= te
        tic %経過時間を測定
        idx = idx + 1; %プログラムの周回数
%         profile on
        %% sensor
        %    tic:現在の時刻を記録
        tStart = tic;
if time.t == 9
    time.t;
end
        % CurrentCharacter Check
%             fprintf("key input : %c", FH.CurrentCharacter)
        % ----------------------
        if (fOffline)
            expdata.overwrite("plant", time.t, agent, i);
            FH.CurrentCharacter = char(expdata.Data{1}.phase(offline_time));
            time.t = expdata.Data{1}.t(offline_time);
            offline_time = offline_time + 1;
        end

        if fMotive %(motiveを使用する場合)
            %motive.getData({agent,["pL"]},mparam);
            motive.getData(agent, mparam);
        end

        for i = 1:N
            % センサに関する設定
            if fMotive; param(i).sensor.motive = {}; end
            param(i).sensor.rpos = {agent};
            param(i).sensor.imu = {[]};
            param(i).sensor.direct = {};
            param(i).sensor.rdensity = {Env};
            param(i).sensor.lrf = Env;
            for j = 1:length(agent(i).sensor.name)
                param(i).sensor.list{j} = param(i).sensor.(agent(i).sensor.name(j));
            end
            agent(i).do_sensor(param(i).sensor.list);
            %if (fOffline);    expdata.overwrite("sensor",time.t,agent,i);end
        end
        
        FH.CurrentCharacter = 'f'; %fを押さずに実行できる
        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10)); %estimator関数を回す
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end

            param(i).reference.covering = [];
            param(i).reference.point = {FH, [1;1;1], time.t};  % 目標値[x, y, z]
            param(i).reference.timeVarying = {time};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list); %reference関数を回す

            % timevarygin -> generated reference
            xr = Reference(Params, time.t, agent);
            % reference from HL
%             xr = Reference(Params, time.t, X);
            % controller
            param(i).controller.mcmpc = {idx, xr};    % 入力算出 / controller.name = hlc
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
        end
%% 
        %-- データ保存
            data.xr{idx} = xr;
            data.sigma(idx) = agent.controller.result.sigma;
            data.bestcost(idx) = agent.controller.result.bestcost;
            if idx == 1
                data.param = agent.controller.result.contParam;
            end

%% 
%             data.pathJ{idx} = agent.controller.result.Evaluationtra; % - 全サンプルの評価値
%             data.sigma(idx) = agent.controller.result.sigma;
%             data.bestcost(idx) = agent.controller.result.bestcost;
            
%             data.state{idx} = state_data(:, 1, BestcostID);
%             data.input{idx} = u;

            state_monte = agent.estimator.result.state;
            ref_monte = agent.reference.result.state;

            %値をディスプレイに表示
%             fprintf("pos: %f %f %f \t vel: %f %f %f \t q: %f %f %f \t ref: %f %f %f \n",...
%                     state_monte.p(1), state_monte.p(2), state_monte.p(3),...
%                     state_monte.v(1), state_monte.v(2), state_monte.v(3),...
%                     state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi,...
%                     xr(1,1), xr(2,1), xr(3,1));

            fprintf("pos: %f %f %f \t u: %f %f %f %f \t q: %f %f %f \t ref: %f %f %f \n",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    agent.input(1), agent.input(2), agent.input(3), agent.input(4),...
                    state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi,...
                    xr(1,1), xr(2,1), xr(3,1));

%             fprintf("pos: %f %f %f \t u: %f %f %f %f \t ref: %f %f %f \t flag: %d",...
%                 state_monte.p(1), state_monte.p(2), state_monte.p(3),...
%                 agent.input(1), agent.input(2), agent.input(3), agent.input(4),...
%                 ref_monte.p(1), ref_monte.p(2), ref_monte.p(3), exitflag);

        %% update state(状態の更新)
        % with FH
        figure(FH)
        drawnow

        for i = 1:N                         % 状態更新
            model_param.param = agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算
            % ここでモデルの計算

            model_param.param = agent(i).plant.param;
            agent(i).do_plant(model_param);
            if agent.estimator.result.state.p(3) < 0
                error('墜落しました')
            end
        end

        % for exp
        if fExp
            %% logging
            calculation1 = toc(tStart);
            time.t = time.t + calculation1;
            logger.logging(time.t, FH, agent, []);
            calculation2 = toc(tStart);
            time.t = time.t + calculation2 - calculation1;

            %% logging
            %             calculation = toc;
            %             wait_time = 0.9999 * (sampling - calculation);
            %
            %             if wait_time < 0
            %                 wait_time
            %                 warning("ACSL : sampling time is too short.");
            %             end
            %            time.t = time.t + calculation;

            %            else
            %                pause(wait_time);  %　センサー情報取得から制御入力印加までを早く保ちつつ，周期をできるだけ一定に保つため
            % これをやるとpause中が不安定になる．どうしても一定時間にしたいならwhile でsamplingを越えるのを待つなどすればよいかも．
            % それよりは推定などで，calculationを意識した更新をしてあげた方がよい？
            %                time.t = time.t + sampling;
            %            end
        else
            logger.logging(time.t, FH, agent);

            if (fOffline)
                time.t
            else
                time.t = time.t + dt % for sim 時間の更新
            end

        end
%         fRemove = agent.controller.result.fRemove;
        if fRemove == 1 %緊急停止用
            warning("Emergency Stop!!!")
            break
        end
        calT = toc % 1ステップ（25ms）にかかる計算時間
        totalT = totalT + calT;
        
        %% 逐次プロット
%         figure(10);
%         clf
%         Tv = time.t:Params.dt:time.t+Params.dt*(Params.H-1);
%         TvC = 0:Params.dt:te;
        %% take off
%         rz = 1; % 目標
%         rz0 = 0;% スタート
%         T = 10; % かける時間
%         a = -2/T^3 * (rz-rz0);
%         b = 3/T^2 * (rz-rz0);
%         CRz = a*(TvC).^3+b*(TvC).^2+rz0;
%         plot(Tv, xr(3, :), '-', 'LineWidth', 2);hold on;
%         plot(TvC, CRz, '--', 'LineWidth', 1);
%         plot(time.t, agent.estimator.result.state.p(3), 'h', 'MarkerSize', 20);
%         hold off;
%         legend("xr.z", "h.z", "Location", "southeast");

        %% circle
%         CRx = cos(TvC/2);
%         CRy = sin(TvC/2);
% %         
% %         TvC = 0:Params.dT:te-0.025;
% %         CRx = X(1, :);
% %         CRy = X(2, :);
% 
%         plot(Tv, xr(1, :), '-', 'LineWidth', 2);hold on;
%         plot(Tv, xr(2, :), '-', 'LineWidth', 2);
% 
%         plot(TvC, CRx, '--', 'LineWidth', 1);
%         plot(TvC, CRy, '--', 'LineWidth', 1);
%         plot(time.t, agent.estimator.result.state.p(1), 'h', 'MarkerSize', 20);
%         plot(time.t, agent.estimator.result.state.p(2), '*', 'MarkerSize', 20);
%         hold off;
%         xlabel("Time [s]"); ylabel("Reference [m]");
%         legend("xr.x", "xr.y", "h.x", "h.y", "est.x", "est.y", "Location", "southeast");
% %         legend("xr.x", "xr.y", "xr.z", "est.x", "est.y", "est.z");
%         xlim([0 te]); ylim([-inf inf+0.1]); 
% 
%         fprintf("sigma: %f\n", data.sigma(idx))

        %%
        drawnow 
%         profile viewer
    end

catch ME % for error
    % with FH
    for i = 1:N
        agent(i).do_plant(struct('FH', FH), "emergency");
    end

    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end

%profile viewer
%%
close all

% size_best = size(data.bestcost, 2);
Edata = logger.data(1, "p", "e")';
Rdata = logger.data(1, "p", "r")';
% Diff = Edata - Rdata;

fprintf("%f秒\n", totalT)
Fontsize = 15;  timeMax = te;
% logger.plot({1,"p", "er"},  "fig_num",1); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
% logger.plot({1,"v", "e"},   "fig_num",2); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Velocity [m/s]"); legend("x.vel", "y.vel", "z.vel");
% logger.plot({1,"q", "p"},   "fig_num",3); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw");
% logger.plot({1,"w", "p"},   "fig_num",4); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Angular velocity [rad/s]"); legend("roll.vel", "pitch.vel", "yaw.vel");
% logger.plot({1,"input", ""},"fig_num",5); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Input"); 
logger.plot({1,"p","er"},{1,"v","e"},{1,"q","p"},{1,"w","p"},{1,"input",""},{1, "p1-p2-p3", "er"}, "fig_num",1,"row_col",[2,3]);

%% graphの出力
set(0, 'defaultLineLineWidth', 1.5);
size_best = size(data.bestcost, 2);
Edata = logger.data(1, "p", "e")';
Rdata = logger.data(1, "p", "r")';
Rdata = zeros(12, size_best-1);
for R = 1:size_best-1
    Rdata(:, R) = data.xr{R}(1:12, 1);
end
Vdata = logger.data(1, "v", "e")';
Qdata = logger.data(1, "q", "e")';
Idata = logger.data(1,"input",[])';
logt = logger.data('t',[],[]);
% Diff = Edata - Rdata(1:3, :);
xmax = te;
close all

% position
figure(1); plot(logt, Edata, 'LineWidth', 2); hold on; plot(logt, Rdata(1:3, end-1), '--'); hold off;
xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
grid on; xlim([0 xmax]); ylim([-inf inf+0.5]);
% atiitude
figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, end-1), '--'); hold off;
xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference");
grid on; xlim([0 xmax]); ylim([-inf inf]);
% velocity
figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, end-1), '--'); hold off;
xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref");
grid on; xlim([0 xmax]); ylim([-inf inf]);
% input
figure(4); plot(logt, Idata); 
xlabel("Time [s]"); ylabel("Input"); legend("u1", "u2", "u3", "u4");
% grid on; xlim([0 xmax]); ylim([-inf inf]);
grid on; xlim([0 xmax]); ylim([-inf inf]);

% % position
% figure(1); plot(logt, Edata, 'LineWidth', 2); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
% xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
% grid on; title("Time change of Position"); xlim([0 xmax]); ylim([-inf inf+0.5]);
% % atiitude
% figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--'); hold off;
% xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference");
% grid on; title("Time change of Atiitude"); xlim([0 xmax]); ylim([-inf inf]);
% % velocity
% figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
% xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref");
% grid on; title("Time change of Velocity"); xlim([0 xmax]); ylim([-inf inf]);
% % input
% figure(4); plot(logt, Idata); 
% xlabel("Time [s]"); ylabel("Input");
% grid on; title("Time change of Input"); xlim([0 xmax]); ylim([-inf inf]);
%% Difference of Pos
% figure(7);
% plot(logger.data('t', [], [])', Diff, 'LineWidth', 2);
% legend("$$x_\mathrm{diff}$$", "$$y_\mathrm{diff}$$", "$$z_\mathrm{diff}$$", 'Interpreter', 'latex', 'Location', 'southeast');
% set(gca,'FontSize',15);  grid on; title(""); ylabel("Difference of Position [m]"); xlabel("time [s]"); xlim([0 10])

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);

%%
% logger.save();