% Estimating load mass via EKF in offline
%TODO------------------------------------
% flight phase の場所を抜き取る
% %----------------------------------------
% clc
% %=========================================
% %もとのloggerの場合
% simple_log =simplifyLoggerForSingle(log);
% %simpleにした場合
% % simple_log = simple_log_EKF_load_model_mL;
% %=========================================
offlineLogger = simple_log;
% kl = find(simple_log.phase == 102);
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
% p  = simple_log.plant.p(:,kf:ke);
% q  = simple_log.plant.q(:,kf:ke);
% v  = simple_log.plant.v(:,kf:ke);
% w  = simple_log.plant.w(:,kf:ke);
% pL = simple_log.plant.pL(:,kf:ke);
% vL = simple_log.plant.vL(:,kf:ke);
% pT = simple_log.plant.pT(:,kf:ke);
% wL = simple_log.plant.wL(:,kf:ke);
input = simple_log.controller.input(:,kf:ke);

initial_state.p  = p(:,1);
initial_state.q  = q(:,1);
initial_state.v  = v(:,1);
initial_state.w  = w(:,1);
initial_state.pL = pL(:,1);
initial_state.vL = vL(:,1);
initial_state.pT = pT(:,1);
initial_state.wL = wL(:,1);
logger = LOGGER(1, tn, 0, [],[]);

agent = DRONE;
agent.parameter  = DRONE_PARAM_SUSPENDED_LOAD("DIATONE","mass",0.73,"cableL",0.46,"jx",0.06,"jy",0.06,"jz",0.06);%真値loadmass = 0.084;
agent.plant      = MODEL_CLASS(agent,Model_Suspended_Load(dtr, initial_state,1,agent,1));%id,dt,type,initial,varargin
agent.estimator  = EKF(agent, Estimator_EKF(agent,dtr,MODEL_CLASS(agent,Model_Suspended_Load(dtr, initial_state, 1,agent,1)), ["p", "q", "pL", "pT"]));%expの流用
agent.sensor     = DIRECT_SENSOR(agent, 0);
agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[2,2,0.5]},"HL"});
agent.controller = HLC_SUSPENDED_LOAD(agent,Controller_HL_Suspended_Load(dtr,agent));
agent.controller.result.input = input(:,1);

zero3 = zeros(3,1);
for i = 2:tn
    % agent.sensor.do(time, 'f');
    agent.sensor.result.state.set_state([ps(:,i);qs(:,i);zero3;zero3;pLs(:,i);zero3;pTs(:,i);zero3]);%sついているもの以外は使われない
    % agent.sensor.result = struct("p",ps(:,i), "q", qs(:,i),"pL", pLs(:,i),"pT",pTs(:,i));
    agent.estimator.do(time, 'f');
    agent.controller.result.input = input(:,i);
    % agent.plant.set_state([p(:,i);q(:,i);v(:,i);w(:,i);pL(:,i);vL(:,i);pT(:,i);wL(:,i)]);
    offlineLogger.estimator.p(:,i)=agent.estimator.result.state.p;
    offlineLogger.estimator.q(:,i)=agent.estimator.result.state.q;
    offlineLogger.estimator.v(:,i)=agent.estimator.result.state.v;
    offlineLogger.estimator.w(:,i)=agent.estimator.result.state.w;
    offlineLogger.estimator.pL(:,i)=agent.estimator.result.state.pL;
    offlineLogger.estimator.vL(:,i)=agent.estimator.result.state.vL;
    offlineLogger.estimator.pT(:,i)=agent.estimator.result.state.pT;
    offlineLogger.estimator.wL(:,i)=agent.estimator.result.state.wL;
    offlineLogger.estimator.mL(:,i)=agent.estimator.result.state.mL;

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