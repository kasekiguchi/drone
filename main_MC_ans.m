%% Drone 班用共通プログラム update sekiguchi
%-- 連続時間モデル　リサンプリングつき これを基に変更
%% Initialize settings
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
run("main1_setting.m");
run("main2_agent_setup_class.m");
%agent.set_model_error("ly",0.02);
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
%% main loop
    fInput = 0;
    fV = 0;
    fVcount = 1;
    fWeight = 0; % 重みを変化させる場合 fWeight = 1
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
    Params.dt = 0.1;  %Params.dt
    %-- 配列サイズの定義
    Params.state_size = 12;
    Params.input_size = 4;
    Params.total_size = 16;
    % Reference.mを使えるようにする
    Params.ur = 0.269 * 9.81 / 4 * ones(Params.input_size, 1);
    xr0 = zeros(Params.state_size, Params.H);

run("main3_loop_setup.m");

try
    while round(time.t, 5) <= te
        tic
        idx = idx + 1;
        %% sensor
        %    tic
        tStart = tic;
if time.t == 9
    time.t;
end
        % CurrentCharacter Check
            fprintf("key input : %c", FH.CurrentCharacter)
        % ----------------------
        if (fOffline)
            expdata.overwrite("plant", time.t, agent, i);
            FH.CurrentCharacter = char(expdata.Data{1}.phase(offline_time));
            time.t = expdata.Data{1}.t(offline_time);
            offline_time = offline_time + 1;
        end

        if fMotive
            %motive.getData({agent,["pL"]},mparam);
            motive.getData(agent, mparam);
        end

        for i = 1:N
            % sensor
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
        

        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end

            xr = Reference(Params, time);
            xr_save(:, idx) = xr(1:3, 1); % xr: referenceの保存
%             xr(3, end) = xr(3, end) + 0.01;
            param(i).reference.covering = [];
            param(i).reference.point = {FH, xr(1:3, 1), time.t};  % 目標値[x, y, z]
            param(i).reference.timeVarying = {time};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);

            param(i).controller.mcmpc = {idx, xr};    % 入力算出 / controller.name = hlc
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
        end

        %-- データ保存
%             data.pathJ{idx} = agent.controller.result.Evaluationtra; % - 全サンプルの評価値
%             data.sigma(idx) = agent.controller.result.sigma;
%             data.bestcost(idx) = agent.controller.result.bestcost;
%             data.state{idx} = state_data(:, 1, BestcostID);
%             data.input{idx} = u;
            state_monte = agent.estimator.result.state;
            ref_monte = agent.reference.result.state;
            fprintf("pos: %f %f %f \t vel: %f %f %f \t q: %f %f %f \t ref: %f %f %f \n",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                    state_monte.q(1)*180/pi, state_monte.q(2)*180/pi, state_monte.q(3)*180/pi,...
                    ref_monte.p(1), ref_monte.p(2), ref_monte.p(3));

        %% update state
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
                time.t = time.t + dt % for sim
            end

        end
        if fRemove == 1
            break
        end
        calT = toc % 1ステップ（25ms）にかかる計算時間
        totalT = totalT + calT;
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
% clc
% calculate time
fprintf("%f秒\n", totalT)
% plot p:position, e:estimate, r:reference, 
% figure(1)
Fontsize = 15;  timeMax = te;
logger.plot({1,"p", "er"},  "fig_num",1); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
logger.plot({1,"v", "e"},   "fig_num",2); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Velocity [m/s]"); legend("x.vel", "y.vel", "z.vel");
logger.plot({1,"q", "p"},   "fig_num",3); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw");
logger.plot({1,"w", "p"},   "fig_num",4); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Angular velocity [rad/s]"); legend("roll.vel", "pitch.vel", "yaw.vel");
logger.plot({1,"input", ""},"fig_num",5); %set(gca,'FontSize',Fontsize);  grid on; title(""); ylabel("Input"); 
%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);
% agent(1).animation(logger,"gif", 1);

%%
size_best = length(logger.Data.t);
for i= 1:size_best
    Edata(:, i) = logger.Data.agent.estimator.result{1,i}.state.p;
    Rdata(:, i) = logger.Data.agent.reference.result{1,i}.state.p;
    diff(:, i) = logger.Data.agent.estimator.result{1,i}.state.p - logger.Data.agent.reference.result{1,i}.state.p;
end
figure(11); plot(logger.Data.t(1:size_best,:), Edata, 'LineWidth', 2); xlabel("Time[s]"); ylabel("coodinates [m]");set(gca,'FontSize',Fontsize); grid on;
ylim([-inf, inf+1.0]); xlim([0 inf]); hold on;
plot(logger.Data.t(1:size_best,:), Rdata, '--', 'LineWidth', 2);
hold off;

%% plot reference
% figure(12); plot(logger.Data.t(1:size_best,:), Edata, 'LineWidth', 2); xlabel("Time[s]"); ylabel("coodinates [m]");set(gca,'FontSize',Fontsize); grid on;
% ylim([-inf, inf+1.0]); xlim([0 inf]); hold on;
% rz_R = 0.05; % 目標
% rz0_R = 1;% スタート
% T_R = 10; % かける時間
% Tv_R = 0:0.01:T_R;
% StartT_R = 0;
% a_R = -2/T_R^3 * (rz_R-rz0_R);
% b_R = 3/T_R^2 * (rz_R-rz0_R);
% syms t real
% z_R = a_R*(t-StartT_R)^3+b_R*(t-StartT_R)^2+rz0_R;
% Z_R = subs(z_R, t, Tv_R);
% plot(Tv_R, Z_R, 'LineWidth', 2, 'LineStyle', '--'); 
% legend("x.state", "y.state", "z.state", "z.reference");
% hold off;

%% plot reference xr_save
figure(12); 
plot(logger.Data.t(1:size_best,:), Edata, 'LineWidth', 2); xlabel("Time[s]"); ylabel("coodinates [m]");set(gca,'FontSize',Fontsize); grid on;
ylim([-inf, inf+1.0]); xlim([0 inf]); hold on;
plot(logger.Data.t(1:size_best,:), xr_save, 'LineWidth', 2, 'LineStyle', '--');
legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference");
hold off;
%%
% logger.save();