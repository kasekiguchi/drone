%% Drone 班用共通プログラム update sekiguchi
%% Initialize settings
% set path
activeFile = matlab.desktop.editor.getActive;
cd(fileparts(activeFile.Filename));
[~, activeFile] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), activeFile, 'UniformOutput', false);
close all hidden; clear all; clc;
userpath('clear');

%% general setting
N = 1; % number of agents
fExp = 0; % 1: experiment   0: numerical simulation
fMotive = 0; % 1: active
fOffline = 0; % 1: active : offline verification with saved data
fDebug = 0; % 1: active : for debug function
run("main1_setting.m");
% for mob1
% tmp = [0 0;0 10;10 10;10 0]-[5 5];
wall1 = [2 -1;2 0.5;2.5 0.5;2.5 -1];
% wall2 = [4 0;4 3;4.5 3;4.5 0];
% wall2 = [4 0;2 0.5;7 0.5;7 0];%没
room = [-2 -5;-2 4;7 4;7 -5];
room0 = [-2.5 -5.5;-2.5 4.5;7.5 4.5;7.5 -5.5];
% Env.param.Vertices = [tmp;NaN NaN;0.6*tmp]; %モビング時の障害物
Env.param.Vertices = [wall1;NaN NaN;room;NaN NaN;room0]; %Tbug時の障害物
plot(polyshape(Env.param.Vertices))
% Env.param.Vertices = [wall1;NaN NaN;wall2;NaN NaN;room]; %Tbug時の障害物(複数)
initial.p = [0,0,0]';
rs = STATE_CLASS(struct('state_list',["p","v"],'num_list',[3,3]));
run("main2_agent_setup.m");
%agent.set_model_error("ly",0.02);
% plot(polyshape(Env.param.Vertices),'FaceColor','red','FaceAlpha',0.1);
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
    ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
              ];

if (fOffline)
  logger = LOGGER("Data/Log(22_Nov_11_6).mat", ["sensor","input"]);
else
  logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);
end

%
run("main2_agent_setup.m");

%agent.set_model_error("ly",0.02);
%% main loop
run("main3_loop_setup.m");
PFH=figure();
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
      param(i).sensor.lrf = {Env};
      param(i).sensor.lidar = {};

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
      param(i).reference.covering = [];
      param(i).reference.point = {FH, [2; 0; 1], time.t, dt};
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
      param(i).controller.hlc = {time.t};
      param(i).controller.ftc = {time.t};
      param(i).controller.pid = {};
      param(i).controller.tscf = {dt, time.t};
      param(i).controller.mpc = {};

      for j = 1:length(agent(i).controller.name)
        param(i).controller.list{j} = param(i).controller.(agent(i).controller.name(j));
      end

      agent(i).do_controller(param(i).controller.list);
      if (fOffline); logger.overwrite("input", time.t, agent, i); end
    end

    if fDebug
        agent.reference.path_ref_mpc.FHPlot(Env,FH,[]);
% %       agent.reference.path_ref_mpc.FHPlot(Env,FH,[]);
%       %agent.show(["sensor", "lidar"], "FH", FH, "param", struct("fLocal", true));%false));
       %agent.show(["reference","tbug"],"FH",FH,"param",Env)
    end

    %% update state
    figure(FH)
    drawnow

    for i = 1:N                       % 状態更新
      model_param.param = agent(i).model.param;
      model_param.FH = FH;
      agent(i).do_model(model_param); % 算出した入力と推定した状態を元に状態の1ステップ予測を計算

      model_param.param = agent(i).plant.param;
      agent(i).do_plant(model_param);
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
      logger.logging(time.t, FH, agent, []);

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
%logger.plot({1,"p","per"},{1,"controller.result.z",""},{1,"input",""});
logger.plot({1,"p","er"},{1,"q","e"},{1,"input",""});
% logger.plot({1,"p","er"});
% legend("x.state", "y.state", "z.state","x.reference", "y.reference", "z.reference");
% logger.plot({1,"q","e"});
% logger.plot({1,"p","er"},{1,"inner_input",""});
%%
% logger.plot({1,"p1-p2","er"});
hold on
plot(polyshape([2 2 2.5 2.5],[0.5 -1 -1 0.5]))%一個目
% plot(polyshape([4 4 4.5 4.5],[3 0 0 3]))%二個目
xlabel('x')
ylabel('y')
legend("estimate", "reference", "obstacle");
% legend("estimate", "reference", "obstacle1","obstacle2");
hold off
% agent(1).reference.timeVarying.show(logger)


%% animation
% VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N)
% agent(1).estimator.pf.animation(logger,"target",1,"FH",figure(),"state_char","p");
agent(1).animation(logger, "target", 1:N, "opt_plot", ["sensor", "lidar"]);%安西
agent(1).animation(logger, "target", 1:N, "opt_plot", ["sensor", "lrf"]);
% agent(1).animation(logger,"target",1:N,"Env",OBJECT3D("cube",struct("cog",[2.25,-0.25,0.5],"length",[0.5,1.5,1])));
%%
logger.save();
%logger.save("AROB2022_Prop400s2","separate",true);
