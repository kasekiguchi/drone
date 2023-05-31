%% Drone 班用共通プログラム update sekiguchi
%% Initialize settings 推定用データ生成プログラム
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; %clear all; %毎回clearする必要あり
clc;

% 20230129 磯部 main.m内で初期値をランダムに変化させるフラグ
flag_initrandam = 1

userpath('clear');
% warning('off', 'all');
run("main1_setting.m");
run("main2_agent_setup.m");
%agent.set_model_error("ly",0.02);
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
%% main loop
run("main3_loop_setup.m");

try
    while round(time.t, 5) <= te
        %% sensor
        %    tic
        tStart = tic;
if time.t == 9
    time.t;
end
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

            % reference
            param(i).reference.covering = [];
            param(i).reference.point = {FH, [0; 0; 0], time.t};
            param(i).reference.timeVarying = {time,FH};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end

            % controller
            param(i).controller.hlc = {time.t, HLParam};
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
        end

        %% update state
        % with FH
        figure(FH)
        drawnow
        % 20230129
        % 初期状態を変更
        if flag_initrandam==1
            % initialState.input = randi([0,100],4,1)*0.001; %randi([下限,上限],行数,列数)
            % initialState.p = randi([-1000,1000],3,1)*0.001; %例 980*0.001=0.980となり-1~1
            % initialState.p(3,1) = randi([-3000,3000])*0.001; %pzの範囲は-3~3
            % initialState.q = randi([-1750,1750],3,1)*0.001;
            % initialState.q(3,1) = 0;
            % initialState.v = randi([-10,10],3,1)*0.001;
            % initialState.w = [0;0;0];

            initialState.input = randi([0,1],4,1)*0.1; %randi([下限,上限],行数,列数)
            initialState.p = randi([-1,1],3,1); %例 980*0.001=0.980となり-1~1
            % initialState.p(3,1) = randi([-3,3]); %pzの範囲は-3~3
            initialState.q = randi([-1,1],3,1)*0.175;
            initialState.q(3,1) = 0;
            initialState.v = randi([-1,1],3,1)*0.01;
            initialState.w = [0;0;0];

            %以下のような書き方をしないと、生成される値がランダムにならない
            % initialState.input = rand(4,1)*0.1; % 0 ~ 0.1
            % initialState.p = rand(3,1)*2-1; % プラスマイナス1 cm 程度の誤差イメージ
            % initialState.p(3,1) = rand*4-1;
            % initialState.q = (rand(3,1)*10-5)*0.0175; % -5 ~ +5 deg 程度のイメージ 0.175をかけることでdegに変換してる。
            % %値の範囲を-+に調整してる
            % initialState.v = rand(3,1)*0.02-0.01; % 1 cm/s 程度の誤差イメージ
            % % initialState.w = rand(3,1)*0.175-0.0175*5; % -5 ~ +5 deg/s 程度のイメージ
            % initialState.w = [0;0;0];

            % initialState.input = rand(4,1)*0.5; 
            % initialState.p = rand(3,1)*2-1; % rand(3,1)*0.02で生成範囲を0~0.02に変更、後ろのマイナスで-0.01~0.01にしてる(イメージ:0-0.01 ~ 0.02-0.01)
            % % initialState.p(3,1) = rand*6-3;
            % initialState.q = (rand(3,1)*40-20)*0.0175; % -5 ~ +5 deg 程度のイメージ 0.175をかけることでdegに変換してる。
            % %値の範囲を-+に調整してる
            % initialState.v = rand(3,1)*0.2-0.1; % 1 cm/s 程度の誤差イメージ
            % % initialState.w = (rand(3,1)*40-20)*0.0175; % -5 ~ +5 deg/s 程度のイメージ
            % initialState.w = [0;0;0];

            % initialState.input = rand(4,1); 
            % initialState.p = rand(3,1); % rand(3,1)*0.02で生成範囲を0~0.02に変更、後ろのマイナスで-0.01~0.01にしてる(イメージ:0-0.01 ~ 0.02-0.01)
            % % initialState.p(3,1) = rand*6-3;
            % initialState.q = (rand(3,1)*10-5)*0.0175; % -5 ~ +5 deg 程度のイメージ 0.175をかけることでdegに変換してる。
            % %値の範囲を-+に調整してる
            % initialState.v = rand(3,1)*0.02-0.01; % 1 cm/s 程度の誤差イメージ
            % % initialState.w = (rand(3,1)*40-20)*0.0175; % -5 ~ +5 deg/s 程度のイメージ
            % initialState.w = [0;0;0];
            
            agent(1).model.state.p = initialState.p;
            agent(1).model.state.q = initialState.q;
            agent(1).model.state.v = initialState.v;
            agent(1).model.state.w = initialState.w;
            agent(1).plant.state.p = initialState.p;
            agent(1).plant.state.q = initialState.q;
            agent(1).plant.state.v = initialState.v;
            agent(1).plant.state.w = initialState.w;
            agent(1).estimator.result.state.p = initialState.p;
            agent(1).estimator.result.state.q = initialState.q;
            agent(1).estimator.result.state.v = initialState.v;
            agent(1).estimator.result.state.w = initialState.w;
    
            agent(1).input = initialState.input;
            flag_initrandam=0;
        end
        for i = 1:N                         % 状態更新
            model_param.param = agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算

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
clc
% plot 
% logger.plot({1,"p","re"});
% agent(1).reference.timeVarying.show(logger)

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
% agent(1).animation(logger,"target",1:N);
%%
%logger.save();

