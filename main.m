%% Drone 班用共通プログラム
%% Initialize settings
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; clear ; clc;
userpath('clear');
% warning('off', 'all');
 
%% general setting
N = 1; % number of agents
fExp = 0 % 1：実機　それ以外：シミュレーション
fMotive = 1 % Motiveを使うかどうか
fOffline = 0; % offline verification with experient data
fDebug = 0;

run("main1_setting.m");

% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [% agentのメンバー関係以外のデータ
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

if (fOffline)
    logger = LOGGER("Data/Log(21-Aug-2022_06_16_24).mat", ["sensor", "estimator"]);
else
    logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
end

%f
run("main2_agent_setup.m");
if fExp~=1
    for i = 1:N
        ratio = 0.7;
% agent.set_model_error("lx",0.0585*(ratio-0.6));%0.0585 %0.06くらいでFT=FB 
% agent.set_model_error("ly",0.0466*(ratio-0.6));%0.0466
% agent.set_model_error("mass",0.269*ratio);%0.269
% agent(i).set_model_error("jx", 0.02237568*ratio);%0.02237568;
% agent.set_model_error("jy", 0.02985236*ratio);%0.02985236;
% agent.set_model_error("jz",0.0480374*ratio);%0.0480374;
% agent.set_model_error("km1",0.0301*ratio);%0.0301
% agent.set_model_error("km2",0.0301*ratio);%0.0301
% agent.set_model_error("km3",0.0301*ratio);%0.0301
% agent.set_model_error("km4",0.0301*ratio);%0.0301
% agent.set_model_error("k1",-100000000);%0.000008
% agent.set_model_error("k2",0.05);%0.000008
% agent.set_model_error("k3",0.05);%0.000008
% agent.set_model_error("k4",0.05);%0.000008
agent(i).set_model_error("B",[zeros(1,6),[0,0,1],[1,1,0]]);%only sim , add disturbance [x,y,z]m/s^2, [roll, pitch, yaw]rad/s^2
    end
end
%% main loop
run("main3_loop_setup.m");

try

    while round(time.t, 5) <= te
        %% sensor
        %    tic
        tStart = tic;

        if (fOffline)
            logger.overwrite("plant", time.t, agent, i);
            FH.CurrentCharacter = char(logger.Data.phase(offline_time));
            time.t = logger.Data.t(offline_time);
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
            param(i).sensor.lrf = {Env.param};

            for j = 1:length(agent(i).sensor.name)
                param(i).sensor.list{j} = param(i).sensor.(agent(i).sensor.name(j));
            end

            agent(i).do_sensor(param(i).sensor.list);
            if (fOffline); logger.overwrite("sensor", time.t, agent, i); end
        end

        %% estimator, reference generator, controller
        for i = 1:N
            % estimator
            agent(i).do_estimator(cell(1, 10));
            if (fOffline); logger.overwrite("estimator", time.t, agent, i); end

            % reference
%             FH.CurrentCharacter = 'f';
            % if fExp~=1
            %     if time.t<=5
            %         FH.CurrentCharacter = 't';
            %     else
            %         FH.CurrentCharacter = 'f';
            %     end
            % end
            param(i).reference.covering = [];
            param(i).reference.point = {FH, [0; 0; 0], time.t, dt};
            param(i).reference.timeVarying = {time, FH};
            param(i).reference.tvLoad = {time};
            param(i).reference.wall = {1};
            param(i).reference.tbug = {};
            param(i).reference.path_ref_mpc = {1};
            param(i).reference.agreement = {logger, N, time.t};

            for j = 1:length(agent(i).reference.name)
                param(i).reference.list{j} = param(i).reference.(agent(i).reference.name(j));
            end

            agent(i).do_reference(param(i).reference.list);
            if (fOffline); logger.overwrite("reference", time.t, agent, i); end
            
            % controller
            param(i).controller.hlc = {time.t,te};
            param(i).controller.ftc = {time.t,te};
            param(i).controller.pid = {};
            param(i).controller.tscf = {time.t};
            param(i).controller.mpc = {};


            for j = 1:length(agent(i).controller.name)
                param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
            end

            agent(i).do_controller(param(i).controller.list);
            if (fOffline); logger.overwrite("input", time.t, agent, i); end
        end

        if fDebug
            agent.reference.path_ref_mpc.FHPlot(Env,FH,[]);
        end
        %% update state
        figure(FH)
        drawnow


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
            logger.logging(time.t, FH, agent, []);

            if (fOffline)
                time.t
            else
                time.t = time.t + dt % for sim
            end

        end
        for i = 1:N % 状態更新
            model_param.param = agent(i).model.param;
            model_param.FH = FH;
            agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算

            %          agent(i).input = agent(i).input - [0.1;0.01;0;0]; % 定常外乱
            model_param.param = agent(i).plant.param;
            agent(i).do_plant(model_param);
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
% logger.plot({1,"p","per"},{1,"controller.result.z",""},{1,"input",""});
% logger.plot({1,"p1:2","pe"},{1,"p","per"},{1,"q","pe"},{1,"v","pe"},{1,"input",""},"fig_num",5,"row_col",[2,3]);
% logger.plot({1,"p","per"},"fig_num",2);
% logger.plot({1,"input",""},"fig_num",3);
% logger.plot({1,"p1-p2","er"},{1,"p1:2","er"},{1,"p","er"},{1,"v","e"},{1,"q","e"},{1,"w","e"},{1,"input",""},"fig_num",4,"row_col",[2,4]);
logger.plot({1,"p","erp"},{1,"v","ep"},{1,"q","ep"},{1,"w","ep"},{1,"input",""},"fig_num",4,"row_col",[2,3]);
% logger.plot({1,"p","er"},{1,"v","e"},{1,"q","se"},{1,"w","e"},{1,"input",""},"fig_num",4,"row_col",[2,3]);
% agent(1).reference.timeVarying.show(logger)


%% animation
%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
%agent(1).estimator.pf.animation(logger,"target",1,"FH"
% ,figure(),"state_char","p");
agent(1).animation(logger, "target", 1:N);
%%
%logger.save();
%logger.save("AROB2022_Prop400s2","separate",true);

%% make folder&save
fsave=10;
if fsave==1
    %変更しない
%     ExportFolder='C:\Users\Students\Documents\momose';%実験用pcのパス
    ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    DataFig='data';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付
%変更==============================================================================
%     subfolder='exp';%sim or exp or sample
    subfolder='sim';%sim or exp or sample
%     subfolder='sample';%sim or exp or sample
    
    ExpSimName='ifacFin';%実験,シミュレーション名
%     contents='appox_error01';%実験,シミュレーション内容
% contents='ft_jy_002';%実験,シミュレーション内容
contents='saddle2_LS';%実験,シミュレーション内容
% contents='FT_jxy150';%実験,シミュレーション内容
%======================================================================================
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