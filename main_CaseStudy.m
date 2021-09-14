%% Drone 班　事例研究用共通プログラム
%% Initialize settings
% set path
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');
cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
close all hidden; clear all; clc;
userpath('clear');
% warning('off', 'all');
%% general setting
fExp = 0 %1：実機　それ以外：シミュレーション
ts=0; % 初期値
if fExp
    dt = 0.025; % sampling time
    te=1000;
else
    dt = 0.1; % sampling time
    te=30;
end
sampling = dt;
%% set connector (global instance)
if fExp
    rigid_ids = [1];
    Connector_Natnet(struct('ClientIP','192.168.1.5','rigid_list',rigid_ids)); % Motive
else
    Connector_Natnet_sim(1,dt,0); % 3rd arg is a flag for noise (1 : active )
end
%% set initial state
disp("Initialize state");
param = struct('sensor',struct,'estimator',struct,'reference',struct);
if fExp
    motive.getData([],[]);
    % for exp with motive : initialize by motive info
    sstate = motive.result.rigid(rigid_ids);
    initial.p = sstate.p;
    initial.q = sstate.q;
    initial.v = [0;0;0];
    initial.w = [0;0;0];
else
    % for sim
    initial.p = [0;0;0];
    initial.q = [1;0;0;0];
    initial.v = [0;0;0];
    initial.w = [0;0;0];
end
%% generate Drone instance
% Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
if fExp
    agent = Drone(Model_Lizard_exp(dt,'plant',initial,"udp",[25])); % Lizard : for exp % 機体番号（ESPrのIP）
    agent.input = [0;0;0;0];
else
    agent = Drone(Model_EulerAngle(1,dt,'plant',initial)); % euler angleのプラントモデル : for sim
end
%% model
% set control model
agent.set_model(Model_EulerAngle(1,dt,'model',initial)); % オイラー角モデル
%     agent.set_model(Model_Quat13(1,dt,'model',initial)); % オイラーパラメータ（unit quaternion）モデル
%% set input_transform property
if fExp
    agent.input_transform=[];
    agent.set_property("input_transform",InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
end
%% set sensors property
agent.set_property("sensor",Sensor_Motive(1)); % motive情報 : sim exp 共通 % 引数はmotive上の剛体番号ではない点に注意
%% set estimator property
agent.set_property("estimator",Estimator_EKF(agent,["p","q"],[1e-5,1e-8])); % （剛体ベース）EKF
%% set reference property
rflag = 1;
ReferencePoints = [0,-1,1;2,1,1;1,2,1;0,1,1;-1,2,1;-2,1,1;0,-1,1]';
% if fExp == 1
%     agent.set_property("reference",Reference_Time_Varying("Case_study_trajectory",[-1;0;1])); % ハート形[x;y;z]永久
% else
%     agent.set_property("reference",Reference_Time_Varying("Case_study_trajectory",[0;0;0])); % ハート形[x;y;z]永久
% end

% 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
agent.set_property("reference",Reference_Point_FH()); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
%% set controller property
agent.set_property("controller",Controller_HL(dt)); % 階層型線形化
%% set logger
% デフォルトでsensor, estimator, reference,のresultと inputのログはとる
logger=Logger(agent,size(ts:dt:te,2),[]);
%% set timer
time =  Time();
time.t = ts;
%% main loop
disp("while ============================")
close all
disp('Press Enter key to start.');
FH  = figure('position',[0 0 eps eps],'menubar','none');
w = waitforbuttonpress;
try
    while round(time.t,5)<=te
        % sensor
        tic
        motive.getData(agent,[]);
        agent.do_sensor({{motive}});
        
        % estimator, reference generator, controller
        agent.do_estimator(cell(1,10));
        param.reference.timeVarying={time};
        [r,rflag]=Make_reference_points(ReferencePoints,agent,rflag);
        param.reference.point={FH,r,time.t};
        for j = 1:length(agent.reference.name)
            param.reference.list{j}=param.reference.(agent.reference.name(j));
        end
        agent.do_reference(param.reference.list);
        agent.do_controller({time.t,cell(1,9)});
        % update state
        figure(FH)
        drawnow
        model_param.param=agent.model.param;
        model_param.FH = FH;
        agent.do_model(model_param);
        
        model_param.param=agent.plant.param;
        agent.do_plant(model_param);
        
        % logging
        calculation=toc;
        
        logger.logging(time.t,FH);
        % for exp
        if fExp
            wait_time =  0.9999*(sampling-calculation);
            if wait_time <0
                wait_time
                warning("ACSL : sampling time is too short.");
            end
            time.t = time.t + calculation;
        else
            time.t = time.t + dt % for sim
        end
    end
catch ME    % for error
    agent.do_plant(struct('FH',FH),"emergency");
    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end
%%
close all
clc
logger.plot(1,["p1-p2"],["er"]);
