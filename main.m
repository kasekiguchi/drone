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
%%
run("main1_setting.m");
run("main2_agent_setup.m");
agent.set_model_error("lx",-0.01);%モデル誤差与えられる

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
            if fExp ~=1 %シミュレーションのみ
                if time.t<=15
                    FH.CurrentCharacter = 't';
                else
                    FH.CurrentCharacter = 'f';%phaseをいじれる
                end
            end
            param(i).reference.covering = [];
            param(i).reference.point = {FH, [0; 0; 0], time.t};%reference.pointの目標位置を指定できる
            param(i).reference.timeVarying = {time,FH};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.agreement = {logger, N, time.t};
            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end
            agent(i).do_reference(param(i).reference.list);
            
            %仮でreferenceを変更する
%             if FH.CurrentCharacter == "f"%take off してからflightしないとだめ
%                 if fff==1
%                     xf = agent.reference.result.state.p - agent.estimator.result.state.p;
%                     fff=0;
%                 end
%             end
%             agent.reference.result.state.p = agent.reference.result.state.p + xf;
            
            %if (fOffline);exprdata.overwrite("reference",time.t,agent,i);end

            % controller
            param(i).controller.hlc = {time.t, HLParam};
%             param(i).controller.ftc = {time.t, HLParam};
%             param(i).controller.pd = {};
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
logger.plot({1,"p","er"},{1, "q", "e"},{1, "input", "e"});
% logger.plot({1,"p","er"},{1,"p1-p2","er"},{1, "q", "e"},{1, "input", "e"},{1,"inner_input",""});
% logger.plot({1,"inner_input",""});
% agent(1).reference.timeVarying.show(logger)


%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
agent(1).animation(logger,"target",1:N);

%%
%logger.save();
%% make folder&save
fsave=10;
if fsave==1
    %変更しない
    ExportFolder='C:\Users\Students\Documents\momose';%実験用pcのパス
%     ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    DataFig='data';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付
    %変更
    subfolder='exp';%sim or exp or sample
%     subfolder='sim';%sim or exp or sample
%     subfolder='sample';%sim or exp or sample
    
    ExpSimName='tanh1_2_近似';%実験,シミュレーション名
%     contents='appox_error01';%実験,シミュレーション内容
contents='FT';%実験,シミュレーション内容

    FolderNamed=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
    FolderNamef=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath
    %フォルダができてないとき
    
        mkdir(FolderNamed);
        mkdir(FolderNamef);
        addpath(genpath(ExportFolder));
    
    % save logger and agent
        logger_contents=strcat('logger_',contents);
        SaveTitle=strcat(date,'_',logger_contents);    
        eval([logger_contents '= logger;']);%loggerの名前をlogger_contentsに変更
        save(fullfile(FolderNamed, SaveTitle),logger_contents);
      
        agent_contents=strcat('agent_',contents);
        SaveTitle2=strcat(date,'_',agent_contents);
        eval([agent_contents '=agent;']);%agentの名前をagent_contentsに変更
        save(fullfile(FolderNamed, SaveTitle2),agent_contents);
    %savefig
%     SaveTitle=strcat(date,'_',ExpSimName);
%         saveas(1, fullfile(FolderName, SaveTitle ),'jpg');
    %     saveas(1, fullfile(FolderName, SaveTitle ),'fig');
    %     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'eps');
end