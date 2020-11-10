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
fExp = 0;%sim=0;exp = 1
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
    te=10;
end
%% generate Drone instance
% Drone classのobjectをinstance化する．制御対象を表すplant property（Model classのインスタンス）をコンストラクタで定義する．
if fExp
    typical_Model_Lizard_exp(N,dt,'plant',25); % Lizard : for exp
else
    %typical_Model_EulerAngle(N,dt,'plant',struct('noise',7.058E-5))
%     typical_Model_Quat13(N,dt,'plant'); % unit quaternionのプラントモデル : for sim
    typical_Model_WheelChair(N,dt,'plant',struct('noise',4.337E-5));
    %typical_Model_Discrete0(N,dt,'plant') % 離散時間質点モデル : Direct controller を想定
    %typical_Model_Discrete(N,dt,'plant') % 離散時間質点モデル : PD controller などを想定
end
% set control model
% typical_Model_EulerAngle(N,dt,'model'); % オイラー角モデル
%typical_Model_Quat13(N,dt,'model') % オイラーパラメータ（unit quaternion）モデル
%typical_Model_Discrete0(N,dt,'model') % 離散時間モデル：位置＝入力 : plantが４入力モデルの時はInputTransform_REFtoHL_droneを有効にする
%typical_Model_Discrete(N,dt,'model') % 離散時間質点モデル : plantが４入力モデルの時はInputTransform_toHL_droneを有効にする
typical_Model_WheelChair(N,dt,'model');
%% set input_transform property
for i = 1:N
    if fExp%isa(agent(i).plant,"Lizard_exp")
        typical_InputTransform_Thrust2Throttle_drone(agent(i)); % 推力からスロットルに変換
    end
end
%agent.plant.espr.sendData(Pw(1,1:16));
% for quat-model plant with discrete control model
%typical_InputTransform_REFtoHL_drone(agent); % 位置指令から４つの推力に変換
%typical_InputTransform_toHL_drone(agent); % modelを使った１ステップ予測値を目標値として４つの推力に変換
% １ステップ予測値を目標とするのでゲインをあり得ないほど大きくしないとめちゃめちゃスピードが遅い結果になる．
%% set environment property
Env = [];
% fl1 = [-50,10;200,10;200,20;-50,20];
% fl2 = [-50,-10;200,-10;200,-20;-50,-20];%x譁ケ蜷代↓髟キ縺?

% fl1 = [-50,10;35,10;35,40;30,40;30,20;-50,20;-50,10];
% fl3 = [55,10;100,10;100,20;60,20;60,40;55,40;55,10];
% fl5 = [-50,-10;100,-10;100,-20;-50,-20;-50,-10;100,-10;100,-20];

% fl1 = [-50,35;50,35;50,45;-50,45];
% fl2 = [-50,-35;50,-35;50,-45;-50,-45];%x譁ケ蜷代↓髟キ縺?
% fl3 = [50,-45;55,-45;55,45;50,45];

% fl1 = [-50,20;200,20;200,25;-50,25];
% fl2 = [-50,-20;200,-20;200,-25;-50,-25];%x direction long passage

fl1 = [-10,-10;-10,20;-9,20;-9,-10;-10,-10];
fl2 = [-10,-10;20,-10;20,-9;-10,-9;-10,-10];
fl3 = [20,-10;20,20;19,20;19,-10;20,-10];
fl4 = [20,20;20,19;-10,19;-10,20;20,20];%mini square room env

% fl1 = [-10,-10;-10,50;-9,50;-9,-10;-10,-10];
% fl2 = [-10,-10;50,-10;50,-9;-10,-9;-10,-10];
% fl3 = [50,-10;50,50;49,50;49,-10;50,-10];
% fl4 = [50,50;50,49;-10,49;-10,50;50,50];% big square room env

env_param.Vertices(:,:,1)=fl1;
env_param.Vertices(:,:,2)=fl2;
% env_param.Vertices(:,:,3)=fl3;
% env_param.Vertices(:,:,4)=fl4;
env_param.name = 'Floor';
for i=1:N;env(i).name = "Floor";env(i).type = "FloorMap_sim";env(i).param = env_param;agent(i).set_env(env(i));end
% typical_Env_2DCoverage(agent); % 鬩・蟠趣スヲ竏晢スコ?スヲ郢晄ァュ繝」郢晁挙?スィ?スュ陞ウ?
% [-2 -2.5;5.5 -2.5;5.5 3;-2 3]
Env.param.Vertices(:,:,1)=fl1;
Env.param.Vertices(:,:,2)=fl2;
% Env.param.Vertices(:,:,3)=fl3;
% Env.param.Vertices(:,:,4)=fl4;
%% set sensors property
for i = 1:N; agent(i).sensor=[]; end
%typical_Sensor_LSM9DS1(agent); % IMU sensor
% typical_Sensor_Motive(agent); % motive情報 : sim exp 共通
%typical_Sensor_Direct(agent); % 状態真値(plant.state)　：simのみ
%typical_Sensor_RangePos(agent,10); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
%typical_Sensor_RangeD(agent,2); %  半径r (第二引数) 内の重要度を計測 : sim のみ
% for i = 1:N % simのみ
%     sensor.type= "LiDAR_sim";
%     sensor.name="lrf";sensor.param=[];agent(i).set_sensor(sensor);
% end
typical_Sensor_LiDAR(agent);%LiDAR seosor
%% set estimator property
for i = 1:N; agent(i).estimator=[]; end
%typical_Estimator_LPF(agent); % lowpass filter
%typical_Estimator_AD(agent); % 後退差分近似で速度，角速度を推定
%typical_Estimator_feature_based_EKF(agent); % 特徴点ベースEKF
%typical_Estimator_PDAF(agent); % 特徴点ベースPDAF
% typical_Estimator_EKF(agent); % （剛体ベース）EKF
%typical_Estimator_Direct(agent); % Directセンサーと組み合わせて真値を利用する　：sim のみ
%for i = 1:N;agent(i).set_property("estimator",struct('type',"Map_Update",'name','map','param',[]));end % map 更新用 重要度などのmapを時間更新する
% typical_Estimator_EKFSLAM(agent)
typical_Estimator_EKFSLAM_WheelChair(agent);
%% set reference property
%typical_Reference_2DCoverage(agent,Env); % Voronoi重心
%typical_Reference_Time_Varying(agent,"gen_ref_saddle",{5,[0;0;1.5],[2,2,1]}); % 時変な目標状態

% 以下は常に有効にしておくこと "t" : take off, "f" : flight , "l" : landing
Reference_Point_FH(agent); % 目標状態を指定 ：上で別のreferenceを設定しているとそちらでxdが上書きされる  : sim, exp 共通
%% set controller property
for i = 1:N; agent(i).controller=[]; end
% typical_Controller_HL(agent); % 階層型線形化
%typical_Controller_MEC(agent); % Model Error Compensator  :  未実装
%for i = 1:N;  Controller.type="MPC_controller";Controller.name = "mpc";Controller.param={agent(i)}; agent(i).set_controller(Controller);end
%for i = 1:N;  Controller.type="DirectController"; Controller.name="direct";Controller.param=[];agent(i).set_controller(Controller);end% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
%for i = 1:N;  Controller.type="PDController"; Controller.name="pd";Controller.param=struct("P",-1*diag([1,1,3]),"D",-1*diag([1,1,3]));agent(i).set_controller(Controller);end% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
for i = 1:N;  Controller.type="WheelChair_FF";Controller.name="WheelChair_FF";Controller.param={agent(i)}; agent(i).set_controller(Controller);end%
% for i = 1:N;  Controller.type="DirectController_6";Controller.name="DirectController_6";Controller.param={agent(i)}; agent(i).set_controller(Controller);end% 隹コ?ス。隴弱ｇ邯セ邵コ?スォ陷茨ス・陷牙ク???スョ闖エ蜥イ?スス?スョ邵コ?スォ驕假スサ陷崎シ披?郢ァ荵斟皮ケ??郢晢スォ騾包スィ??スシ螟ょイシ隶灘姓?スス蜥イ?スス?スョ郢ァ蝣、蟲ゥ隰暦ス・陷茨ス・陷牙ク吮?堤クコ蜷カ?ス?
%% set connector (global instance)
%% set connector (global instance)
% if fExp
%     typical_Connector_Natnet(struct('ClientIP','192.168.1.5')); % Motive
% else
%     typical_Connector_Natnet_sim(N,dt,0); % 3rd arg is a flag for noise (1 : active )
% end
%LiDAR set
LiDAR = Env;
%% initialize
clc
% for sim : 隰ィ?スエ陋サ蜉ア?シ?邵コ貅キ?譎?謔?陋滂ス、
base_pos=[0 0];
kpos=ceil(sqrt(N));
cpos=floor(N/kpos);
rempos=mod(N,kpos);
[xpos,ypos]=meshgrid(1-floor(kpos/2):ceil(kpos/2),1-floor(cpos/2):ceil(cpos/2));
gap=1;
xpos=gap*xpos;
ypos=gap*ypos;
arranged_initial_pos=base_pos-[gap gap]+[reshape(xpos,[N-rempos,1]),reshape(ypos,[N-rempos,1]);(1:rempos)'*[gap,0]+[0 gap]*(ceil(cpos/2)+1)];

% motive.getData({agent,[]});
for i = 1:N
    % for exp with motive : initialize by motive info
    %     agent(i).sensor.motive.do({motive});
    %     sstate = agent(i).sensor.motive.result.state;
    %     model.initial = struct('p',sstate.p,'q',sstate.q,'v',[0;0;0],'w',[0;0;0]);
    %     agent(i).model.set_state(model.initial);
    %     agent(i).estimator.result.state.set_state(model.initial);
    
    % for sim
%     plant.initial = struct('p',[arranged_initial_pos(i,:),0]','q',[1;0;0;0],'v',[0;0;0],'w',[0;0;0]);
    plant.initial = struct('p',[0,0]','q',[0]);%WC model
    agent(i).state.set_state(plant.initial);
    agent(i).model.set_state(plant.initial);
    for j = 1:length(agent(i).estimator.name)
        if isfield(agent(i).estimator.(agent(i).estimator.name(j)),'result')
        agent(i).estimator.(agent(i).estimator.name(j)).result.state.set_state(plant.initial);
        end
    end
end
LogData=[
%     "reference.result.state.p",
    "estimator.result.state.p",
    "estimator.result.state.q",
    "estimator.ekfslam_WC.map_param.x",
    "estimator.ekfslam_WC.map_param.y",
    "estimator.ekfslam_WC.result.P",
    "estimator.ekfslam_WC.result.ErEl_Round",
    "estimator.ekfslam_WC.result.Entropy",
    "estimator.ekfslam_WC.result.SingEntropy",
%     "estimator.ekfslam_WC.result.PartialX",
%     "estimator.ekfslam_WC.result.PartialY",
%     "estimator.ekfslam_WC.result.PartialTheta",
%     "estimator.ekfslam_WC.result.PartialV",
%     "estimator.ekfslam_WC.result.PartialW",
%     "estimator.ekfslam_WC.result.MtoKF_KL",
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

% for simulation
% mparam.occlusion.cond=["time.t >=1.5 && time.t<1.6","agent(1).model.state.p(1) > 2"];
% mparam.occlusion.target={[1],[1]};
% mparam.marker_num = 20;
% mparam=[]; % without occulusion
% motive.getData({agent,mparam});

% for i = 1:N; agent(i).sensor.imu.initialize(20);end
% Smotive={motive};
SLiDAR = {LiDAR};
Srpos={agent};
Simu={[]};
Sdirect={};
Srdensity={Env};
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
        Srpos={agent};
        Simu={[]};
        Sdirect={};
        Srdensity={Env};
        for i = 1:N
            param(i).sensor=arrayfun(@(k) evalin('base',strcat("S",agent(i).sensor.name(k))),1:length(agent(i).sensor.name),'UniformOutput',false);
            agent(i).do_sensor(param(i).sensor);
        end
        %%
        for i = 1:N
%             Edirect={agent(i).sensor}; 
%             Elpf={agent(i).sensor};
%             Ead={agent(i).sensor};
%             Eekf={agent(i).model,agent(i).sensor,[]}; % for euler angle model
%             Epdaf={agent(i).model,agent(i).sensor}; % for euler angle model
%             Efeature_ekf={agent(i).model,agent(i).sensor}; % for euler angle model
%             Emap={agent(i).sensor,agent(i).env};
%             param(i).estimator=arrayfun(@(k) evalin('base',strcat("E",agent(i).estimator.name(k))),1:length(agent(i).estimator.name),'UniformOutput',false);
%            agent(i).do_estimator(param(i).estimator);
            agent(i).do_estimator(cell(1,10));
            
            Rcovering={};%{Env};
            Rpoint={FH,[1;-1;1.5]};
%             RtimeVarying={time};
            RPtoPReference = {};
            param(i).reference=arrayfun(@(k) evalin('base',strcat("R",agent(i).reference.name(k))),1:length(agent(i).reference.name),'UniformOutput',false);
            agent(i).do_reference(param(i).reference);
 
            
%            agent(i).do_controller(param(i).controller);
            agent(i).do_controller(cell(1,10));
            warukaku = 4;
            kakudo = (1/2)* warukaku;
            if time.t<1
                agent(i).input = [1,pi/warukaku];
            elseif time.t>10 && time.t<11
                agent(i).input = [1,-pi/kakudo];
            elseif time.t>30 && time.t<31
                agent(i).input = [1,pi/kakudo];
            elseif time.t>50 && time.t<51
                agent(i).input = [1,-pi/kakudo];
            elseif time.t>70 && time.t<71
                agent(i).input = [1,pi/kakudo];
            elseif time.t>90 && time.t<91
                agent(i).input = [1,-pi/kakudo];
            else
                agent(i).input = [1,0];
            end
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
%%
% logger.save();
% save('zigzag45deg.mat','logger');
%% dataplot
run('dataplot');