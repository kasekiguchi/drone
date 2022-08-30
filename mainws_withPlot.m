%% Drone 班用共通プログラム
%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
rmpath('.\experiment\');
close all hidden; clear all;clc;
userpath('clear');
warning('off', 'all');
%%
%% general setting
N = 1; % number of agents
fExp = 1;%1：実機　それ以外：シミュレーション
fMotive = 0;% Motiveを使うかどうか
fROS = 1;

fOffline = 0; % offline verification with experiment data
if fExp
    dt = 0.025; % sampling time
else
    dt = 0.1; % sampling time
end
sampling = dt;
ts=0;
if fExp
    te=1000;
else
    te=1500;
end
%% initialize
initial(N) = struct;
param(N) = struct('sensor',struct,'estimator',struct,'reference',struct);
%% for sim
for i = 1:N
    %     arranged_pos = arranged_position([0,0],N,1,0);
        initial(i).p = [14;1];%四角経路
%     initial(i).p = [0;0];%直進経路
    initial(i).q = [pi/2];
    initial(i).v = [0];
    initial(i).w = [0];
end
%% generate Drone instance
% Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
%set plant model
for i = 1:N
    if fExp
        agent(i) = Drone(Model_Whill_exp(dt,'plant',initial(i),param,"ros",30)); % Lizard : for exp % 機体番号（ESPrのIP
    else
<<<<<<< HEAD
        agent(i) = Drone(Model_WheelChairA(i,dt,'plant',initial,struct('noise',struct('value',4.337E-5,'seed',5))));%加速度次元車両モデル
    end
    %% model
    % set control model
    agent(i).set_model(Model_WheelChairA(i,dt,'model',initial) );
=======
        agent(i) = DRONE(Model_WheelChairA(i,dt,'plant',initial,struct('noise',struct('value',4.337E-5,'seed',5))));%加速度次元車両モデル
    end
    %% model
    % set control model
            agent(i).set_model(Model_WheelChairA(i,dt,'model',initial) );
>>>>>>> 832e8c9c3a2760a8db1152f80634ac20f522c2e2
    close all
    %% set environment property
        Env = [];
        agent(i).set_property("env",Env_FloorMap_sim_circle(i)); %四角経路
        %% set ROS2 property
        if fROS
            agent(i).set_property("sensor",Sensor_ROS(struct('DomainID',30)));
        else
            SensorRange = 20;
            agent(i).set_property("sensor",Sensor_LiDAR(i, SensorRange,struct('noise',1.0E-3 ) )  );%LiDAR seosor
        end
        %% set estimator property
        agent(i).estimator=[];
%         agent(i).set_property("estimator",Estimator_UKFSLAM_WheelExp(agent(i),SensorRange))
        agent(i).set_property("estimator",Estimator_UKFSLAM_WheelChairA(agent(i),SensorRange));%加速度次元入力モデルのukfslam車両も全方向も可
        %% set reference property
        agent(i).reference=[];
        velocity = 0.5;%目標速度
        w_velocity = 0.7;%曲がるときの目標角速度
        
        WayPoint = [0,0,0,0];%目標位置の初期値
        convjudgeV = 1.0;%収束判断　
        convjudgeW = 0.5;%収束判断　
        Holizon = 3;%MPCのホライゾ
        agent(i).set_property("reference",Reference_TrackWpointPathForMPC(WayPoint,velocity,w_velocity,convjudgeV,convjudgeW,initial,Holizon));
        % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
        agent(i).set_property("reference",Reference_Point_FH()); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
        %% set controller property
        agent(i).controller=[]; 
        agent(i).set_property("controller",Controller_TrackingMPC(i,dt,Holizon));%MPCコントローラ
     
        %% set connector (global instance)
        param(i).sensor.list = cell(1,length(agent(i).sensor.name));
        param(i).reference.list = cewxawll(1,length(agent(i).reference.name));
    
<<<<<<< HEAD
=======
    WayPoint = [0,0,0,0];%目標位置の初期値
    convjudgeV = 1.0;%収束判断　
    convjudgeW = 0.5;%収束判断　
    Holizon = 3;%MPCのホライゾン数
    agent(i).set_property("reference",Reference_TrackWpointPathForMPC(WayPoint,velocity,w_velocity,convjudgeV,convjudgeW,initial,Holizon));
    % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
    agent(i).set_property("reference",Reference_Point_FH()); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
    %% set controller property
    agent(i).controller=[]; 
    agent(i).set_property("controller",Controller_TrackingMPC(i,dt,Holizon));%MPCコントローラ
    %% set connector (global instance)
    param(i).sensor.list = cell(1,length(agent(i).sensor.name));
    param(i).reference.list = cell(1,length(agent(i).reference.name));
>>>>>>> 832e8c9c3a2760a8db1152f80634ac20f522c2e2
end
%%
% load('C:\Users\kasek\Documents\GitHub\drone\ws_Saves\2022_08_17\12_23_35\Logger12_23_35.mat');
% id = 4122;
% agent.plant.state.set_state(logger.Data.agent{id,25}.state.get());
% agent.estimator.result.state.set_state( ...
%     "p",logger.Data.agent{id,2} ...
%     "q",logger.Data.agent{id,3} ...
%     "v",logger.Data.agent{id,4});
% agent.estimator.ukfslam_WC.(einitial);

%% initialize
clc
LogData=[
        "reference.result.state.p",
    "estimator.result.state.p",
    "estimator.result.state.q",
    "estimator.result.state.v",
%     "estimator.result.state.w",
    "plant.state.v",
%     "plant.state.w",
    "estimator.result.map_param.x",
    "estimator.result.map_param.y",
    "estimator.result.P",
    "estimator.result.AssociationInfo.index",
    "estimator.result.AssociationInfo.distance",
%     "reference.result.state.xd",
    "controller.result.fval",
    "controller.result.exitflag",
    "controller.result.eachfval",
    "sensor.result.sensor_points",
    "sensor.result.angle",
    "sensor.result.length",
%         "controller.result.Eval",
%         "estimator.result.PreMapParam.x",
%         "estimator.result.PreMapParam.y",
    "env.Floor.param.Vertices",
    %    "reference.result.state.xd",
%     "inner_input",
    "input"
    ];
SubFunc = [
%     "ContEval",
%     "TrajectoryErrorDis",
%     "ObserbSubFIM",
    ];
if ~isempty(agent(1).plant.state)
    LogData=["plant.state.p";LogData]; % 実制御対象の位置
    if isprop(agent(1).plant.state,'q')
        LogData=["plant.state.q";LogData]; % 実制御対象の姿勢
    end
end
%logger=WSLogger(agent,size(ts:dt:te,2),LogData,SubFunc);
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
LogData = [     % agentのメンバー関係以外のデータ
    "env_vertices"
        ];
LogAgentData = [% 下のLOGGER コンストラクタで設定している対象agentに共通するdefault以外のデータ
            ];

logger = LOGGER(1:N, size(ts:dt:te, 2), fExp, LogData, LogAgentData);

time =  TIME();
time.t = ts;
%%  各種do methodの引数設定
% 引数に取れるのは以下のみ
% time, motive, FH　や定数　などグローバル情報
% agent 自体はagentの各プロパティ内でselfとしてhandleを保持しているのでdo methodに引数として渡す必要は無い．

SLiDAR = {Env};
for i = 1:N
    param(i).sensor=arrayfun(@(k) evalin('base',strcat("S",agent(i).sensor.name(k))),1:length(agent(i).sensor.name),'UniformOutput',false);
    agent(i).do_sensor(param(i).sensor);
end
%% 続きから
% time.t = time.t - dt;
% logger.overwrite("plant", time.t, agent, 1);
% logger.overwrite("estimator", time.t, agent, 1);
% logger.overwrite("sensor", time.t, agent, 1);
% logger.overwrite("reference", time.t, agent, 1);
% logger.overwrite("controller", time.t, agent, 1);
% logger.overwrite("input", time.t, agent, 1);
%% main loop
%profile on
disp("while ============================")
close all;
disp('Press Enter key to start.');
FH  = figure('position',[0 0 eps eps],'menubar','none');
%
 w = waitforbuttonpress;
NowResult = figure;
tic
% tryf
while round(time.t,5)<=te
    %while 1 % for exp
    %%
    Srpos={agent};
    Simu={[]};
    Sdirect={};
    for i = 1:N
        param(i).sensor=arrayfun(@(k) evalin('base',strcat("S",agent(i).sensor.name(k))),1:length(agent(i).sensor.name),'UniformOutput',false);
        agent(i).do_sensor(param(i).sensor);
    end
    %%
    for i = 1:N
        agent(i).do_estimator(cell(1,10));
        
        %Referance Setting
%         param(i).reference.GlobalPlanning = {1};
        param(i).reference.TrackingWaypointPath = {1};
        param(i).reference.TrackWpointPathForMPC = {1};
        param(i).reference.point={FH,[2;1;0.5],time.t};
        
        for j = 1:length(agent(i).reference.name)
            param(i).reference.list{j}=param(i).reference.(agent(i).reference.name(j));
        end
        agent(i).do_reference(param(i).reference.list);

        %            agent(i).do_controller(param(i).controller);
        agent(i).do_controller(cell(1,10));
    end
    %agent(1).estimator.map.show
    %%
    
    logger.logging(time.t,FH, agent, Env.param.Vertices);
    %time.t = time.t+ calculation; % for exp
    time.t = time.t + dt % for sim
    doSubFuncFlag = true;
    %logger.logging(time.t,FH,doSubFuncFlag);
    %%
    % with FH
    figure(FH)
    drawnow
    for i = 1:N %
        model_param.param=agent(i).model.param;
        %             model_param.param.B = Model.param.param.B .*0.95;%モデルとの違い
        model_param.FH = FH;
        plant_param.param =agent(i).plant.param;
        plant_param.param.t = time.t;
        if ~isa(agent(i).plant,"Lizard_exp")        % Thrust2Throttle邵コ?スァ邵コ?スッinput_transform闕ウ鄙ォ縲知odel邵コ?スョ隴厄スエ隴?スー郢ァ蛛オ?シ?邵コ?スヲ邵コ?郢ァ?
            agent(i).do_model(model_param);
        end
        
        agent(i).do_plant(plant_param);
    end
    %---now result plot---%
     NowResultPlot(agent,NowResult);
     drawnow
    %---------------------%
    % for exp
    % pause(0.9999*(sampling-calculation)); %
end
calculation=toc;
% catch ME
%     % with FH
%
%     for i = 1:N
%         agent(i).do_plant(struct('FH',FH),"emergency");
%     end
%     warning('ACSL : Emergency stop! Check the connection.');
%     rethrow(ME);
% end
%profile viewer
%% dataplot 自作
close all;
SaveOnOff = false; %trueでデータをはく
Plots = DataPlot(logger,SaveOnOff);
%%
%disp(calculation);
figure()
logger.plot({1,"p1:2","er"});
%%
logger.save()
%% Run class Saves
% In this section we have created a txt file that writhed out the class names you used
% Proptype = properties(agent);
Proptype = ["model","sensor","controller","estimator","reference","env","plant"];
RunNames = arrayfun(@(N) agent.(Proptype(N)).name , 1:length(Proptype),'UniformOutput',false);
fileID = fopen('RunNames.txt','w');
StringSet = '%s ';
for Propidx = 1:length(Proptype)
    LongProp = length(Proptype(Propidx));
    LongRun  = length(RunNames{Propidx});
    CharSet = repmat(StringSet,[1 LongProp+LongRun]);
    fprintf(fileID,append(CharSet,'\n'),Proptype(Propidx),RunNames{Propidx});
end
fclose(fileID);
movefile('RunNames.txt',Plots.SaveDateStr);
% run('dataplot');
%% Local function
function [] = NowResultPlot(agent,NowResult)
    figure(NowResult)
    clf(NowResult)
    grid on
    axis equal
    hold on
    
MapIdx = size(agent.env.Floor.param.Vertices,3);
for ei = 1:MapIdx
    tmpenv(ei) = polyshape(agent.env.Floor.param.Vertices(:,:,ei));
end
p_Area = union(tmpenv(:));
%plantFinalState
PlantFinalState = agent.plant.state.p(:,end);
PlantFinalStatesquare = PlantFinalState + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
PlantFinalStatesquare =  polyshape( PlantFinalStatesquare');
PlantFinalStatesquare =  rotate(PlantFinalStatesquare,180 * agent.plant.state.q(end) / pi, agent.plant.state.p(:,end)');
PlotFinalPlant = plot(PlantFinalStatesquare,'FaceColor',[0.5020,0.5020,0.5020],'FaceAlpha',0.5);
%modelFinalState
EstFinalState = agent.estimator.result.state.p(:,end);
EstFinalStatesquare = EstFinalState + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
EstFinalStatesquare =  polyshape( EstFinalStatesquare');
EstFinalStatesquare =  rotate(EstFinalStatesquare,180 * agent.estimator.result.state.q(end) / pi, agent.estimator.result.state.p(:,end)');
PlotFinalEst = plot(EstFinalStatesquare,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);
%reference state
RefState = agent.reference.result.state.p(1:3,:);
Ref = plot(RefState(1,:),RefState(2,:),'ro','LineWidth',1);
Wall = plot(p_Area,'FaceColor','blue','FaceAlpha',0.5);

fWall = agent.reference.result.focusedLine;
plot(fWall(:,1),fWall(:,2),'r-');
O = agent.reference.result.O;
plot(O(1),O(2),'r*');
quiver(RefState(1,:),RefState(2,:),2*cos(RefState(3,:)),2*sin(RefState(3,:)));
xlim([PlantFinalState(1)-10, PlantFinalState(1)+10]);ylim([PlantFinalState(2)-10,PlantFinalState(2)+10])
% pbaspect([20 20 1])
hold off
end