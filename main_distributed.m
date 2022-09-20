%% Drone 班用共通プログラム update sekiguchi
%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
run("setting.m");
run("setup_agent.m");
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
%% set timer
time = TIME();
time.t = ts;
%%
% 引数に取れるのは以下のみ
% time, motive, FH　や定数　などグローバル情報
% agent 自体はagentの各プロパティ内でselfとしてhandleを保持しているのでdo methodに引数として渡す必要は無い．

% % for simulation
% mparam.occlusion.cond=["time.t >=1.5 && time.t<1.6","agent(1).model.state.p(1) > 2"];
% mparam.occlusion.target={[1],[1]};
% mparam.marker_num = 20;
mparam = [];    % without occulusion

%% main loop
run("main_loop_setup.m");

try
    tStart = tic;
    while round(time.t, 5) <= te
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

        %% estimator, reference generator, controller
            % estimator
            if fExp
                if exist("tEstimator(i)","var")
                    dte = toc(tEstimator(i));
                else
                    dte = 0;
                end
                tEstimator(i) = tic;
            else
                dte = dt;
            end
            model_param.dt = dte;
            agent(i).do_model(model_param);% EKF のために更新することが必要
            agent(i).do_estimator({dte,dte});
            %if (fOffline);exprdata.overwrite("estimator",time.t,agent,i);end

            % reference
            param(i).reference.covering = [];
            param(i).reference.point = {FH, [2; 1; 1], time.t};
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
            HLParam.dt = dte;% あくまで推定結果を元に入力を算出するため
            param(i).controller.hlc = {time.t, HLParam};
            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end
            agent(i).do_controller(param(i).controller.list);
            %if (fOffline); expudata.overwrite("input",time.t,agent,i);end

            figure(FH)
            drawnow
            model_param.FH = FH;
            model_param.param = agent(i).plant.param;
            agent(i).do_plant(model_param);
        end


        %% update state
        if fExp
            delta_t = toc(tStart);
            %% logging
            time.t = time.t + delta_t;
            logger.logging(time.t, FH, agent, []);
            tStart = tic;
        else % simulation
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
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
%%
% agent(1).reference.timeVarying.show(logger)
%logger.plot({1,"sensor.imu.result.state.q",""},{1,"sensor.imu.result.state.w",""},{1,"sensor.imu.result.state.a",""});
%logger.plot({1,"p","e"},{1,"q","s"},"row_col",[2,1]);
%tmp=plot(logger.data("t","","",'time',[1 2]),logger.data(1,"reference.result.state.xd","e",'time',[1 2]));
%tmp=plot(logger.data("t","","",'time',[1 2]),logger.data(1,"input","",'time',[1 2]));
%logger.data(1,"state.p","e","time",[0 3])
%logger.plot({1,"p1-p2-p3","er"},{1,"input",""})
%logger.plot({1,"p1-p2-p3","es"},'fig_num',2);
%logger.plot({1,"p","e"})
%plot(logger.data("t","",""),sum(logger.data(1,"input",""),2))
logger.plot({1, "p", "er"},{1, "q", "e"},{1, "input", "e"}, 'fig_num', 3)
%%
%logger.save();
