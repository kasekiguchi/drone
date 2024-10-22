% Estimating load mass via EKF in offline
%TODO------------------------------------
%機体の正確な質量を計測
%----------------------------------------
clc
%=========================================
%もとのloggerの場合
% clear simple_log
if ~exist("simple_log","var")
    simple_log =simplifyLoggerForSingle(log);
end
%simpleにした場合
% simple_log = simple_log_EKF_load_model_mL;
%=========================================
offlineLogger = simple_log;
kf = find(simple_log.phase == 102,1,"first");%take off:116,flight:102
ke = find(simple_log.phase == 102,1,"last");%take off:116,flight:102
% kf = kl(1);
% ke = kl(end);

t = simple_log.t(kf:ke);
offlineLogger.t = t;
dtr = 0.025;
dt = [0;diff(t)];
tn = length(t);
time = TIME(t(1),dtr,t(end));%timeを修正

ps  = simple_log.sensor.p(:,kf:ke);
qs  = simple_log.sensor.q(:,kf:ke);
if size(qs,1) == 4
    qs = Quat2Eul(qs);
end
pLs = simple_log.sensor.pL(:,kf:ke);
pTs = simple_log.sensor.pT(:,kf:ke);
p  = simple_log.estimator.p(:,kf:ke);
q  = simple_log.estimator.q(:,kf:ke);
v  = simple_log.estimator.v(:,kf:ke);
w  = simple_log.estimator.w(:,kf:ke);
pL = simple_log.estimator.pL(:,kf:ke);
vL = simple_log.estimator.vL(:,kf:ke);
pT = simple_log.estimator.pT(:,kf:ke);
wL = simple_log.estimator.wL(:,kf:ke);
input = simple_log.controller.input(:,kf:ke);

offlineLogger.reference.p = simple_log.reference.p(:,kf:ke);
offlineLogger.controller.input=simple_log.controller.input(:,kf:ke);

initial_state=[];
initial_state.p  = p(:,1);
initial_state.q  = q(:,1);
initial_state.v  = v(:,1);
initial_state.w  = w(:,1);
initial_state.pL = pL(:,1);
initial_state.vL = vL(:,1);
initial_state.pT = pT(:,1);
initial_state.wL = wL(:,1);

agent = DRONE;
agent.parameter  = DRONE_PARAM_SUSPENDED_LOAD("DIATONE","mass",0.745,"cableL",0.46,"jx",0.06,"jy",0.06,"jz",0.06);%真値loadmass = 0.0864;機体の質量が10g変化するだけでも結果が変わる
agent.plant      = MODEL_CLASS(agent,Model_Suspended_Load(dtr, initial_state,1,agent,0));%id,dt,type,initial,varargin
agent.estimator  = EKF(agent, Estimator_EKF(agent,dtr,MODEL_CLASS(agent,Model_Suspended_Load(dtr, initial_state, 1,agent,1)), ["p", "q", "pL", "pT"]));%expの流用
agent.sensor     = DIRECT_SENSOR(agent, 0);
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
agent.controller = HLC_SUSPENDED_LOAD(agent,Controller_HL_Suspended_Load(dtr,agent));
agent.controller.result.input = input(:,1);

zero3 = zeros(3,1);
g = [0;0;-9.81];
mi = agent.parameter.mass;
vL_pre = initial_state.vL;
vdro_pre = initial_state.v;
estimate_load_mass = ESTIMATE_LOAD_MASS(agent);
for i = 2:tn
    % agent.sensor.do(time, 'f');
    agent.sensor.result.state.set_state([ps(:,i);qs(:,i);zero3;zero3;pLs(:,i);zero3;pTs(:,i);zero3]);%sついているもの以外は使われない
    agent.estimator.do(time, 'f');
    agent.controller.result.input = input(:,i);
    offlineLogger.estimator.p(:,i)=agent.estimator.result.state.p;
    offlineLogger.estimator.q(:,i)=agent.estimator.result.state.q;
    offlineLogger.estimator.v(:,i)=agent.estimator.result.state.v;
    offlineLogger.estimator.w(:,i)=agent.estimator.result.state.w;
    offlineLogger.estimator.pL(:,i)=agent.estimator.result.state.pL;
    offlineLogger.estimator.vL(:,i)=agent.estimator.result.state.vL;
    offlineLogger.estimator.pT(:,i)=agent.estimator.result.state.pT;
    offlineLogger.estimator.wL(:,i)=agent.estimator.result.state.wL;
    offlineLogger.estimator.mL(:,i)=agent.estimator.result.state.mL;

    % %最小二乗解で求める
    Ri      = eul2rotm(qs(:,i)');
    vdro    = agent.estimator.result.state.v;
    vL      = agent.estimator.result.state.vL;
    ui      = Ri*[0;0;input(1,i-1)];%推力,離散時間なので現在時刻まで同じ入力が入ると仮定
    aidrn   = (vdro - vdro_pre)/dt(i); %機体加速度%前時刻の運動方程式から加速度求めてもいいかも
    ai      = (vL - vL_pre)/dt(i);%牽引物加速度
    mui     = mi*aidrn - mi*g - ui;                 %ドローン座標系からの張力
    mui     = -mui;%分割後の牽引物系から張力
    vL_pre = vL;
    vdro_pre = vdro;
    %分割後質量推定 mLi*ai = mLi*g + mui
    A    = ai - g;
    AtA  = A'*A;
    mLi  = (AtA\A')*mui;%分割後質量
    % offlineLogger.estimator.mL(:,i) = mLi;
    % 
    time.t = t(i);
    time.dt = dt(i);
    mLi =agent.estimator.result.state.mL;
    elm = estimate_load_mass.estimate(time,mLi,mui);
    offlineLogger.estimator.mL(:,i) = elm.mL;

    disp(t(i))
    time.t = t(i);
    time.dt = dt(i);
    % time.t = time.t + time.dt;
end
disp(time.t)
%reference軌道など描画必要な変数は後でloggerに代入する．
%%
run("DataPlotForSingle")
% plot(offlineLogger.t,offlineLogger.estimator.mL)
% yline(0.0864)
%% make folder&save
if 0
%TODO------------------------
%plotに必要なところだけ抜き取ったファイルを作成するプログラムを追加する．
%------------------------
    %変更しない
    % ExportFolder='A:\Work2024\momose';%実験用pcのパス
    % % ExportFolder='C:\Users\acsl_students\Documents\students\workspace2024\momose';%実験用pcのパス
    ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    % ExportFolder='C:\Users\81809\OneDrive\ドキュメント\GitHub\drone\Data';
    % ExportFolder='Data';%github内
    DataFig='data';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付
%変更==============================================================================
    % date2 = "2024_1007";%日付が変わってしまった場合は自分で変更
    subfolder='sim';%sim or exp
    ExpSimName='coop4drone';%実験,シミュレーション名
    % contents='FT_apx_max';%実験,シミュレーション内容
    contents='EKF';%実験,シミュレーション内容
%======================================================================================
    FolderNamed=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
    FolderNamef=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath
    FolderNamel=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'simpleLog');%保存先のpath
    %フォルダができてないとき
    if ~exist(FolderNamed,"dir")
        mkdir(FolderNamed);
        mkdir(FolderNamef);
        mkdir(FolderNamel);
        addpath(genpath(ExportFolder));
    end
    % simple logger name
    simpleLoggerContents = strcat('simple_',loggerContents);
    simpleSaveTitle=strcat(date,'_',simpleLoggerContents);
    eval([simpleLoggerContents,'= offlineLogger;']);
    save(fullfile(FolderNamel, simpleSaveTitle),simpleLoggerContents);
end