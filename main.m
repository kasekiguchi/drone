%% Drone 班用共通プログラム update sekiguchi
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
fInput = 0;
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
            param(i).reference.point = {FH, [5; 5; 5], time.t};  % 目標値[x, y, z]
            param(i).reference.timeVarying = {time};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end

            % controller 
            param(i).controller.hlc = {time.t, HLParam};    % 入力算出 / controller.name = hlc
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end
            % 強制的に入力を決定
%             if fInput == 0
%                 agent(i).input = [0.66 0.66 0.6700005 0.6700005]';
%                 fInput = 1;
%             else 
%                 agent(i).input = [0.269*9.81/4+0.0004 0.269*9.81/4+0.0004 0.269*9.81/4+0.0006 0.269*9.81/4+0.0006]';
% %             elseif time > 5. && finput == 2
% %                 agent(i).input = [0 0 0 0]';
%             end
            
            
            % MPC controller
            % ts探し
            rng(0,'twister');
            ts = 0;
%             p_monte = agent.model.state.p
            % 入力のサンプルから評価
            ref_input = [0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4 0.269 * 9.81 / 4]'; % ホバリングの目標入力
            Q_monte_x = 10000; Q_monte_y = 1; Q_monte_z = 1;
            Q_monte = [Q_monte_x 0 0; 0 Q_monte_y 0; 0 0 Q_monte_z];
            R_monte = 1;
%             fun = @(p_monte, u_monte) (p_monte - agent.reference.result.state.p)'*Q_monte*(p_monte - agent.reference.result.state.p)+(u_monte - ref_input)'*R_monte*(u_monte - ref_input); % 評価関数
            fun = @(p_monte) (p_monte - agent.reference.result.state.p)'*Q_monte*(p_monte - agent.reference.result.state.p); % 評価関数
%             Rmax = 0.269 * 9.81 / 4;  % 乱数の値の範囲
            sample = 10;   % サンプル数
            % ホバリングから±sigma%の範囲
            sigma = 0.0005;
            a = 0.269 * 9.81 / 4 - 0.269 * 9.81 / 4 * sigma;
            b = 0.269 * 9.81 / 4 + 0.269 * 9.81 / 4 * sigma;
            % 入力 u
            u1(: ,1) = (b-a).*rand(sample,1) + a;
            u2(: ,1) = (b-a).*rand(sample,1) + a;
            u3(: ,1) = (b-a).*rand(sample,1) + a;
            u4(: ,1) = (b-a).*rand(sample,1) + a;
            u = [u1 u2 u3 u4];
            Adata = zeros(sample, 4);
            for monte = 1 : sample
                [~,tmpx]=agent.model.solver(@(t,x) agent.model.method(x, u(monte, :)',agent.parameter.get()),[ts ts+dt],agent.estimator.result.state.get());
                P_monte = tmpx(end,:);  % ある入力での位置 x, y, z
%                 Adata(monte, 1:3) = arrayfun(fun, P_monte(1:3)', u(monte, :)')';  % 評価値(x, y, z)算出
                Adata(monte, 1) = fun(P_monte(1:3)');  % 評価値(x, y, z)算出
%                 Adata(monte, 2) = sum(Adata(monte, 1:3));           % 評価値をどう評価するか　/　ここでは，各成分評価値の合計
            end
%             tmpx = tmpx * 10^5;
            
            [~,min_index] = min(Adata(:, 1));   % 評価値の合計の最小値インデックス算出
            agent.input = u(min_index, :)';     % 最適な入力の取得
%             u(:, 5) = agent.model.solver(@(t,x) agent.model.method(x, u,agent.parameter.get()),[ts ts+dt],agent.estimator.result.state.get());
            % 算出
%             Xdata(:, 5) = arrayfun(fun, u1(:), u2(:), u3(:), u4(:));               % 評価関数
%             % Adata(Adata(:, 2)==0, :) = []; % 制約なし
%             [~,min_index] = min(Xdata(:, 2));   % 最小値算出
%             u = Xdata(min_index, 1) % 入力の取得
        end
        
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
% plot p:position, er:roll/pitch/yaw, 
logger.plot({1,"p", "er"});
% agent(1).reference.timeVarying.show(logger)

%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1);
%%
% logger.save();
