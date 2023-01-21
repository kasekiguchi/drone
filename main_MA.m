%% Drone 班用共通プログラム : 害鳥追跡シミュレーション
%% Initialize settings
% set path
activefile = matlab.desktop.editor.getActive;
cd(fileparts(activefile.Filename));
[~, activefile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activefile, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
%% general setting
N = 2; % number of total units
Nb = 6; % number of birds
fExp = 0 % 実機フラグ
fMotive = 1 % Motiveを使うかどうか
fOffline = 0; % offline verification with experiment data

run("main1_bird_setting.m");
run("main1_setting.m");
run("main2_bird_setup.m");
run("main2_agent_setup.m");
run("main2_bird_setup2.m");
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
    ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
    ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
logger_bird = LOGGER(1:Nb, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
%% main loop
run("main3_loop_setup.m");
% try
    while round(time.t, 5) <= te
        %% sensor
        %    tic
        tStart = tic;
        if time.t == 9
            time.t;
        end

        if fMotive
            %motive.getData({agent,["pL"]},mparam);
            motive.getData(agent, mparam);
            if Nb ~= 0
                motive_bird.getData(bird, bparam);
            end
        end

        for i = 1:N
            % sensor
            if fMotive; param(i).sensor.motive = {}; end
            param(i).sensor.rpos = {agent};
            param(i).sensor.imu = {[]};
            param(i).sensor.direct = {};
            param(i).sensor.bounding = {time};
            param(i).sensor.rcoverage_3D = {N,Nb};
            param(i).sensor.rdensity = {Env};
            param(i).sensor.lrf = Env;
            for j = 1:length(agent(i).sensor.name)
                param(i).sensor.list{j} = param(i).sensor.(agent(i).sensor.name(j));
            end
            agent(i).do_sensor(param(i).sensor.list);
%             agent(i).sensor.bounding.show(agent(1))
            %if (fOffline);    expdata.overwrite("sensor",time.t,agent,i);end
        end

        for i = 1:Nb
            % sensor
            if fMotive; param_bird(i).sensor.motive = {}; end
            param_bird(i).sensor.rpos_bird = {bird};
            param_bird(i).sensor.imu = {[]};
            param_bird(i).sensor.direct = {};
            param_bird(i).sensor.bounding = {time};
            param_bird(i).sensor.rcoverage_bird_3D = {N,Nb};
            param_bird(i).sensor.rdensity = {Env};
            param_bird(i).sensor.lrf = Env;
            for j = 1:length(bird(i).sensor.name)
                param_bird(i).sensor.list{j} = param_bird(i).sensor.(bird(i).sensor.name(j));
            end
            bird(i).do_sensor(param_bird(i).sensor.list);
%             agent(i).sensor.bounding.show(agent(1))
            %if (fOffline);    expdata.overwrite("sensor",time.t,agent,i);end
        end

        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end

            % reference
            param(i).reference.covering = [];
            param(i).reference.covering_3D = {N,Nb,initial_state};
            param(i).reference.birdmove = {time,N,Nb};
            param(i).reference.point = {FH, [2; 1; 1], time.t,dt};
            param(i).reference.timeVarying = {time,FH};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.tbug = {};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end

            % controller
            param(i).controller.hlc = {time.t};
            param(i).controller.pd = {};
            param(i).controller.tscf = {time.t};
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
            agent(i).input = min(max(agent(i).input,-5),5);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
        end

        for i = 1:Nb
            % estimator
            bird(i).do_estimator(cell(1, 10));
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end

            % reference
            param_bird(i).reference.covering = [];
            param_bird(i).reference.covering_3D = {N,Nb};
            param_bird(i).reference.birdmove = {time,N,Nb,initial_bird_state};
            param_bird(i).reference.point = {FH, [2; 1; 1], time.t,dt};
            param_bird(i).reference.timeVarying = {time,FH};
            param_bird(i).reference.tvLoad = {time};
            param_bird(i).reference.wall = {1};
            param_bird(i).reference.tbug = {};
            param_bird(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(bird(i).reference.name)
                param_bird(i).reference.list{j} = param_bird(i).reference.(bird(i).reference.name(j));
            end
            bird(i).do_reference(param_bird(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end

            % controller
            param_bird(i).controller.hlc = {time.t};
            param_bird(i).controller.pd = {};
            param_bird(i).controller.tscf = {time.t};
            for j = 1:length(bird(i).controller.name)
                param_bird(i).controller.list{j} = param_bird(i).controller.(bird(i).controller.name(j));
            end
            bird(i).do_controller(param_bird(i).controller.list);
            bird(i).input = min(max(bird(i).input,-3),3);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
        end

        %% update state
        figure(FH)
        drawnow

        for i = 1:N                         % 状態更新
            model_param.param = agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算

                      agent(i).input = agent(i).input - [0.1;0.01;0;0]; % 定常外乱
            model_param.param = agent(i).plant.param;
            agent(i).do_plant(model_param);
        end

        for i = 1:Nb                        % 状態更新
            model_bird_param.param = bird(i).model.param;
            model_bird_param.FH = FH;
            bird(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算

                      bird(i).input = bird(i).input - [0.1;0.01;0;0]; % 定常外乱
            model_bird_param.param = bird(i).plant.param;
            bird(i).do_plant(model_param);
        end

        % for exp
        if fExp
            %% logging
            logger.logging(time.t, FH, agent, []);
            calculation1 = toc(tStart);
            time.t = time.t + calculation1;

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
            logger_bird.logging(time.t, FH, bird);
            time.t = time.t + dt
        end

    end

% catch ME % for error
%     % with FH
%     for i = 1:N
%         agent(i).do_plant(struct('FH', FH), "emergency");
%     end
% 
%     warning('ACSL : Emergency stop! Check the connection.');
%     rethrow(ME);
% end

%profile viewer
%%
close all
clc
% plot
%logger.plot({1,"p","per"},{1,"controller.result.z",""},{1,"input",""});
logger.plot({1,"q","e"},{2,"q","e"},"fig_num",2,"row_col",[1 2]);
logger_bird.plot({1,"q","e"},{2,"q","e"},{3,"q","e"},{4,"q","e"},{5,"q","e"},{6,"q","e"},"fig_num",3,"row_col",[2 3]);
% agent(1).reference.timeVarying.show(logger)
% bird(1).plot_fig(logger,logger_bird);


%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
%agent(1).estimator.pf.animation(logger,"target",1,"FH",figure(),"state_char","p");
% agent(1).animation(logger,"target",1:N,"Motive_ref",1);
bird(1).animation(logger,logger_bird,"drone",1:N,"bird",1:Nb,"Motive_ref",1,"mp4",0);
% agent(1).sensor.bounding.movie(logger);
