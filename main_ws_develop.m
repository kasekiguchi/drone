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
fExp = 0;%1：実機　それ以外：シミュレーション
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
    te=5;
end
%% initialize
initial(N) = struct;
param(N) = struct('sensor',struct,'estimator',struct,'reference',struct);
%% for sim
for i = 1:N
%     arranged_pos = arranged_position([0,0],N,1,0);
    initial(i).p = [0;0];
    initial(i).q = [0];
end
%% generate Drone instance
% Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
%set plant model
for i = 1:N
if fExp
    else
        agent(i) = Drone(Model_WheelChairV(i,dt,'plant',struct('p',[0;0],'q',[0]),struct('noise',4.337E-5))); 
end
 %% model
    % set control model
    agent(i).set_model(Model_WheelChairV(N,dt,'model',struct('p',[0;0],'q',[0]))); % オイラー角モデル
    close all
%% set environment property
Env = [];
agent(i).set_property("env",Env_FloorMap_sim(i)); % 重要度マップ設定
%% set sensors property
agent(i).sensor=[];
agent(i).set_property("sensor",Sensor_LiDAR(i));%LiDAR seosor
%% set estimator property
agent(i).estimator=[];
Gram = GrammianAnalysis(te,ts,dt);
% agent(i).set_property("estimator",Estimator_EKFSLAM_WheelChairV(agent(i),Gram));
agent(i).set_property("estimator",Estimator_UKFSLAM_WheelChairV(agent(i),Gram));
%% set reference property
    agent(i).reference=[];
    
    % 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
    agent(i).set_property("reference",Reference_Point_FH()); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
%% set controller property
agent(i).controller=[];
for i = 1:N;  Controller.type="WheelChair_FF";Controller.name="WheelChair_FF";Controller.param={agent(i)}; agent(i).set_property('controller',Controller);end%
%% set connector (global instance)
param(i).sensor.list = cell(1,length(agent(i).sensor.name));
param(i).reference.list = cell(1,length(agent(i).reference.name));
end
%% initialize
clc
% for i = 1:N
%     % for sim
% %     plant.initial = struct('p',[0,0]','q',[0],'v',[0],'w',[0]);%WC model A
%     plant.initial = struct('p',[0,0]','q',[0]);%WC model V
%     agent(i).state.set_state(plant.initial);
%     agent(i).model.set_state(plant.initial);
%     for j = 1:length(agent(i).estimator.name)
%         if isfield(agent(i).estimator.(agent(i).estimator.name(j)),'result')
%         agent(i).estimator.(agent(i).estimator.name(j)).result.state.set_state(plant.initial);
%         end
%     end
% end
LogData=[
%     "reference.result.state.p",
    "estimator.result.state.p",
    "estimator.result.state.q",
%     "estimator.ekfslam_WC.map_param.x",
%     "estimator.ekfslam_WC.map_param.y",
%     "estimator.ekfslam_WC.result.P",
%     "estimator.ekfslam_WC.result.ErEl_Round",
%     "estimator.ekfslam_WC.result.Entropy",
% %     "estimator.ekfslam_WC.result.SingP",
%     "estimator.ekfslam_WC.result.G",
%     "env.Floor.param.Vertices",
%     "estimator.ekfslam_WC.result.PartialX",
%     "estimator.ekfslam_WC.result.PartialY",
%     "estimator.ekfslam_WC.result.PartialTheta",
%     "estimator.ekfslam_WC.result.PartialV",
%     "estimator.ekfslam_WC.result.PartialW",
%     "estimator.ekfslam_WC.result.MtoKF_KL",
%     "estimator.ekfslam_WC.result.Eig",
%     "estimator.ekfslam_WC.result.InFo",
%     "estimator.ekfslam_WC.result.Gram",
%     "estimator.ekfslam_WC.result.GramVec",
%     "estimator.ekfslam_WC.result.Obs",
%     "estimator.ekfslam_WC.result.diffy",
%     "estimator.ekfslam_WC.result.OtoKF_KL",
%     "estimator.ekfslam_WC.result.laser.ranges",
%     "estimator.ekfslam_WC.result.laser.angles",
%     "estimator.result.state.q",
%     "estimator.result.state.v",
%     "estimator.result.state.w",
%     "sensor.result.state.p",
    %     "sensor.result.state.q",
    %     "sensor.result.state.v",
    %     "sensor.result.state.w",
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

try
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
            
            Rcovering={};%{Env};
            Rpoint={FH,[1;-1;1.5]};
%             RtimeVarying={time};
            RPtoPReference = {};
            param(i).reference=arrayfun(@(k) evalin('base',strcat("R",agent(i).reference.name(k))),1:length(agent(i).reference.name),'UniformOutput',false);
            agent(i).do_reference(param(i).reference);
 
            
%            agent(i).do_controller(param(i).controller);
            agent(i).do_controller(cell(1,10));
%             warukaku = 4;
%             kakudo = (1/2)* warukaku;
%             if time.t<1
%                 agent(i).input = [1,pi/warukaku];
%             elseif time.t>10 && time.t<11
%                 agent(i).input = [1,-pi/kakudo];
%             elseif time.t>30 && time.t<31
%                 agent(i).input = [1,pi/kakudo];
%             elseif time.t>50 && time.t<51
%                 agent(i).input = [1,-pi/kakudo];
%             elseif time.t>70 && time.t<71
%                 agent(i).input = [1,pi/kakudo];
%             elseif time.t>90 && time.t<91
%                 agent(i).input = [1,-pi/kakudo];
%             else
%                 agent(i).input = [1,0];
%             end

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
        for i = 1:N % 霑・?スカ隲キ蛹コ蟲ゥ隴?スー
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
        % pause(0.9999*(sampling-calculation)); %邵イ?郢ァ?スサ郢晢スウ郢ァ?スオ郢晢スシ隲??陜」?スア陷ソ髢??スセ蜉アツー郢ァ迚吝ョ幄?包ス。陷茨ス・陷牙ク幃ュり怏?邵コ?スセ邵コ?スァ郢ァ蜻域滋邵コ荳茨スソ譏エ笆?邵コ?ス、邵コ?ス、??スシ謔滓拷隴帶コ假ス堤クコ?スァ邵コ髦ェ?ス狗クコ?邵コ蜿ー?スク?陞ウ螢ケ竊楢将譏エ笆ス邵コ貅假ス?
    end
catch ME
    % with FH
    
    for i = 1:N
        agent(i).do_plant(struct('FH',FH),"emergency");
    end
    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end
%profile viewer
%% dataplot
close all;
PlotOnOff = [1,1,0,0,0,1];
Plots = DataPlot(logger,PlotOnOff);
%%
% run('dataplot');
%% Save

