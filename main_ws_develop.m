%% Drone 班用共通プログラム
%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');
cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
rmpath('.\experiment\');
close all hidden; clear all;clc;
userpath('clear');
warning('off', 'all');
%% general setting
N = 1; % number of agents
fExp = 0;%1：実機　それ以外：シミュレ5rーション
fMotive = 0;% Motiveを使うかどうか
fROS = 0;

fOffline = 0; % offline verification with experiment data
if fExp
    dt = 0.025; % sampling time
else
    dt = 0.1; % sampling time
    %     dt = 0.025;
    %     dt = 0.010;
    %     dt = 0.001;
end
sampling = dt;
ts=0;
if fExp
    te=1000;
else
    te=60;
end
%% initialize
initial(N) = struct;
param(N) = struct('sensor',struct,'estimator',struct,'reference',struct);
%% for sim
for i = 1:N
    %     arranged_pos = arranged_position([0,0],N,1,0);
    initial(i).p = [0;0];
    initial(i).q = [0];
    initial(i).v = [0];
    initial(i).w = [0];
end
%% generate Drone instance
% Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
%set plant model
for i = 1:N
    if fExp
    else
                        agent(i) = Drone(Model_WheelChairV(i,dt,'plant',initial,struct('noise',7.058E-5)));
%         agent(i) = Drone(Model_WheelChairA(i,dt,'plant',initial,struct('noise',4.337E-5)));
%                 agent(i) = Drone(Model_ODV(i,dt,'plant',initial,struct('noise',4.337E-5)));
%         agent(i) = Drone(Model_ODVADI(i,dt,'plant',initial,struct('noise',4.337E-5)));
    end
    %% model
    % set control model
        agent(i).set_model(Model_WheelChairV(i,dt,'model',initial ) );
%             agent(i).set_model( Model_WheelChairA(N,dt,'model',initial) );
%     agent(i).set_model(Model_ODV(N,dt,'model',initial) );
% agent(i).set_model(Model_ODVADI(N,dt,'model',initial) );
    close all
    %% set environment property
    Env = [];
    agent(i).set_property("env",Env_FloorMap_sim(i)); % 重要度マップ設定
    %% set sensors property
    agent(i).sensor=[];
    agent(i).set_property("sensor",Sensor_LiDAR(i, struct('noise',realsqrt(1.0E-3) ) )  );%LiDAR seosor
    %% set estimator property
    agent(i).estimator=[];
    Gram = GrammianAnalysis(te,ts,dt);
%             agent(i).set_property("estimator",Estimator_EKFSLAM_WheelChairV(agent(i),Gram));
%         agent(i).set_property("estimator",Estimator_EKFSLAM_WheelChair(agent(i),Gram));
%         agent(i).set_property("estimator",Estimator_EKFSLAM_ODV(agent(i)));
%     agent(i).set_property("estimator",Estimator_EKFSLAM_ODVADI(agent(i)));
    agent(i).set_property("estimator",Estimator_UKFSLAM_WheelChairV(agent(i),Gram));
%     agent(i).set_property("estimator",Estimator_UKFSLAM_WheelChairA(agent(i)));
    %% set reference property
    agent(i).reference=[];
    agent(i).set_property("reference",Reference_GlobalPlanning(agent(i).estimator));
    % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
    agent(i).set_property("reference",Reference_Point_FH()); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
    %% set controller property
    agent(i).controller=[]; 
%         agent(i).set_property("controller",Controller_LocalPlanning(i,dt));
%     agent(i).set_property( "controller", Controller_LocalPlanningForODV(i,dt) );
% agent(i).set_property( "controller", Controller_LocalPlanningForODVADI(i,dt) );
    for i = 1:N;  Controller.type="WheelChair_FF";Controller.name="WheelChair_FF";Controller.param={agent(i)}; agent(i).set_property('controller',Controller);end%
    %% set connector (global instance)
    param(i).sensor.list = cell(1,length(agent(i).sensor.name));
    param(i).reference.list = cell(1,length(agent(i).reference.name));
end
%% initialize
clc
LogData=[
    %     "reference.result.state.p",
    "estimator.result.state.p",
    "estimator.result.state.q",
%     "estimator.result.state.v",
%     "estimator.result.state.w",
%     "plant.state.v",
%     "plant.state.w",
    "estimator.result.map_param.x",
    "estimator.result.map_param.y",
%     "controller.result.Eval",
    %     "estimator.result.PreMapParam.x",
    %     "estimator.result.PreMapParam.y",
    "env.Floor.param.Vertices",
    %    "reference.result.state.xd",
    "inner_input",
    "input"
    ];
if ~isempty(agent(1).plant.state)
    LogData=["plant.state.p";LogData]; % 実制御対象の位置
    if isprop(agent(1).plant.state,'q')
        LogData=["plant.state.q";LogData]; % 実制御対象の姿勢
    end
end
% if exist('motive')==1 % motiveを利用している場合
%     LogData=[LogData;    "sensor.result.dt"]; % センサー内周期
% end
if isfield(agent(1).reference,'covering')
    LogData=[LogData;    "reference.result.region";"env.density.param.grid_density"]; % for coverage
end
logger=WSLogger(agent,size(ts:dt:te,2),LogData);
time =  Time();
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
%% main loop
%profile on
disp("while ============================")
close all;
disp('Press Enter key to start.');
FH  = figure('position',[0 0 eps eps],'menubar','none');
%%
w = waitforbuttonpress;

% try
while round(time.t,5)<=te
    %while 1 % for exp
    %%
    tic
    %         motive.getData({agent,mparam});
    %         Smotive={motive};
    Gram.UpdateT
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
        param(i).reference.GlobalPlanning = {1};
        param(i).reference.point={FH,[2;1;0.5],time.t};
        
        for j = 1:length(agent(i).reference.name)
            param(i).reference.list{j}=param(i).reference.(agent(i).reference.name(j));
        end
        agent(i).do_reference(param(i).reference.list);

        %            agent(i).do_controller(param(i).controller);
        agent(i).do_controller(cell(1,10));
        warukaku = 4;
        kakudo = (1/2)* warukaku;
        %                         %for v model
        %         if time.t<1
        %             agent(i).input = [1,pi/warukaku];
        % %         elseif time.t>10 && time.t<11
        % %             agent(i).input = [1,-pi/kakudo];
        % %         elseif time.t>30 && time.t<31
        % %             agent(i).input = [1,pi/kakudo];
        % %         elseif time.t>50 && time.t<51
        % %             agent(i).input = [1,-pi/kakudo];
        % %         elseif time.t>70 && time.t<71
        % %             agent(i).input = [1,pi/kakudo];
        % %         elseif time.t>90 && time.t<91
        % %             agent(i).input = [1,-pi/kakudo];
        %         else
        %             agent(i).input = [1,0];
        %         end
%         www = 1.1294;
%         wwa = 0.443015;
%         if time.t<1
%             agent(i).input = [1,www-0.1];
%         elseif time.t>=10 && time.t<11
%             agent(i).input = [1,-www - wwa];
%         elseif time.t>=30 && time.t<31
%             agent(i).input = [1,www + wwa];
%         elseif time.t>=40 && time.t<41
%             agent(i).input = [1,-www - wwa];
%         elseif time.t>=70 && time.t<71
%             agent(i).input = [1,pi/warukaku];
%         elseif time.t>90 && time.t<91
%             agent(i).input = [1,-pi/warukaku];
%         else
%             agent(i).input = [1,0];
%         end

% if time.t<1
%     agent(i).input = [0,0,www-0.1];
% elseif time.t>=1 && time.t<10
%     agent(i).input = [0.4272,0.9042,0];
% elseif time.t>=10 && time.t<11
%     agent(i).input = [0,0,-www - wwa];
% elseif time.t>=11 && time.t<30
%     agent(i).input = [0.9035,-0.4287,0];
% elseif time.t>=30 && time.t<31
%     agent(i).input = [0,0,www + wwa];
% elseif time.t>=31 && time.t<40
%     agent(i).input = [0.4272,0.9042,0];
% elseif time.t>=40 && time.t<41
%     agent(i).input = [0,0,-www - wwa];
% elseif time.t>=41 && time.t<70
%     agent(i).input = [0.9035,-0.4287,0];
% elseif time.t>=70 && time.t<71
%     agent(i).input = [0,pi/warukaku];
% elseif time.t>90 && time.t<91
%     agent(i).input = [0,-pi/warukaku];
% else
%     agent(i).input = [1,0,0];
% end
        
        %for a model
%                             if time.t<=0.5
%                                 agent(i).input = [1/1.2,2 * pi/kakudo];
%                             elseif time.t>0.5&&time.t<=1.1
%                                 agent(i).input = [1/1.2,-2 * pi/kakudo];
%                             elseif time.t>=10 && time.t<=10.5
%                                 agent(i).input = [0,-4 * pi/kakudo];
%                             elseif time.t>10.5 && time.t<11
%                                 agent(i).input = [0,4 * pi/kakudo];
%                             elseif time.t>=30 && time.t<=30.5
%                                 agent(i).input = [0,4 * pi/kakudo];
%                             elseif time.t>30.5 && time.t<31
%                                 agent(i).input = [0,-4 * pi/kakudo];
%                             elseif time.t>=40 && time.t<=40.5
%                                 agent(i).input = [0,-4 * pi/kakudo];
%                             elseif time.t>40.5 && time.t<41
%                                 agent(i).input = [0,4 * pi/kakudo];
%                             else
%                                 agent(i).input = [0,0];
%                             end
        
% if time.t<=0.5
%     agent(i).input = [0.4272/1.2,0.9042/1.2,2 * pi/kakudo];
% elseif time.t>0.5&&time.t<=1.1
%     agent(i).input = [0.4272/1.2,0.9042/1.2,-2 * pi/kakudo];
% elseif time.t>=10 && time.t<=10.5
%     agent(i).input = [-2*0.4272,-2*0.9042,-4 * pi/kakudo];
% elseif time.t>10.5 && time.t<11
%     agent(i).input = [2* 0.9035,2*-0.4287,4 * pi/kakudo];
% elseif time.t>=30 && time.t<=30.5
%     agent(i).input = [-2* 0.9035,-2*-0.4287,4 * pi/kakudo];
% elseif time.t>30.5 && time.t<31
%     agent(i).input = [2*0.4272,2*0.9042,-4 * pi/kakudo];
% elseif time.t>=40 && time.t<=40.5
%     agent(i).input = [-2*0.4272,-2*0.9042,-4 * pi/kakudo];
% elseif time.t>40.5 && time.t<41
%     agent(i).input = [2* 0.9035,2*-0.4287,4 * pi/kakudo];
% else
%     agent(i).input = [0,0,0];
% end
%         if time.t<=1.1
%             agent(i).input = [1/1.2,0,0];
%         else
%             agent(i).input = [0,0,0];
%         end
    end
    %agent(1).estimator.map.show
    %%
    calculation=toc;
    %time.t = time.t+ calculation; % for exp
    time.t = time.t + dt % for sim
    logger.logging(time.t,FH);
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
    % for exp
    % pause(0.9999*(sampling-calculation)); %
end
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
%% dataplot 
close all;
SaveOnOff = true;
Plots = DataPlot(logger,SaveOnOff);
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
%% Save

