%todo
% ==内の部分を修正
% 牽引のみでできるようにtakeoffの方法を変更する
%元の牽引物のログをとる必要がある。牽引物のagentを実験用に修正する必要あり
%=推定方法を変える場合==========================================================================
%-拡張質量システム：
% Model_Suspended_Load(dt,initial,id,agent,isEstLoadMass):isEstLoadMass=1
% agent.controller = HLC_SUSPENDED_LOAD(agent,Controller_HL_Suspended_Load(dt,agent));
%=============================================================================================
ts = 0; % initial time　開始時間
dt = 0.025; % sampling period　サンプリング間隔
te = 10000; % termina time　終了時間
time = TIME(ts,dt,te); %上の3つの時間をまとめる．
in_prog_func = @(app) in_prog(app); %43行目にある
post_func = @(app) post(app); %35行目にある

motive = Connector_Natnet('192.168.1.4'); % connect to Motive　実験室モーションキャプチャのIP
% motive = Connector_Natnet('192.168.120.4'); % connect to Motive　総研モーションキャプチャのIP
motive.getData([], []); % get data from Motive モーションキャプチャからのデータを入手する
rigid_num = motive.result.rigid_num;%剛体数

%各pcが担当する単機牽引の数と使用する剛体のrigidIdの計算
% numberOFpc = 2;%pcの総数
% PCId = 1;%pcの番号
% % PCId = 2;%pcの番号
% NdroneAndLoad = round(rigid_num/2);%機体と分割後の牽引物の組数
% s = NdroneAndLoad -1*mod(rigid_num,2);%牽引物の分を引く(複数牽引でなかったら引かない)
% r = mod(s,numberOFpc);
% sParPc = (s-r)/numberOFpc;%各PCでいくつの組を制御するか
% Ns = ones(1,numberOFpc)*sParPc + [ones(1,r),zeros(1,numberOFpc-r)];%各PCで制御する組を決定
% N = Ns(PCId)+1*mod(rigid_num,2);%(複数牽引でなかったら足さない)
% addIds = zeros(1,length(Ns));%機体と分割後の牽引物分+牽引物分ずらしていく
% for i = 1:length(Ns) - 1 
%     addIds(i+1) = sum(Ns(1:i+1),2);%pcごとに機体ずらす
% end
% addId = addIds(PCId);%このpcで加算するrigidのid
handlingModelNum = 1;%扱う機体数の番号を配列で連番で書く:3~5機目を扱うときhandlingModelNum = 3:5
N = length(handlingModelNum) + mod(rigid_num,2);
addId = (handlingModelNum(1) - 1)*2 + mod(rigid_num,2);
% addId=0;
% N=2;
%COMの番号指定
COMs = [3];%pc1 lenovo割り当てる順番に設定
% COMs = [5,11];%pc2 nav割り当てる順番に設定
% cableL=[0.77,0.77];
% cableL=[0.91,0.91];
cableL=[0.785,0.785];
length=cableL;

refName = {
            {"My_Case_study_trajectory",{[1,1,1]},"HL"},...
            {"My_Case_study_trajectory",{[-1,-1,1]},"HL"}
            % {"gen_ref_saddle",{"freq",13,"orig",[2;2;1],"size",[1,1,0.2]},"HL"}
            };
refPointName= {
        {struct("f",[0;0;0.5],"g",[1;0;0.5],"h",[0;0;0.5],"j",[0;1;0.5],"k",[0;0;0.5],"m",[-1;-1;0.5],"n",[0;0;0.5]),10}
                 % {struct("f",[0;0;0.5],"g",[1;0;0.5],"h",[0;0;0.5],"j",[-1;0;0.5],"k",[0;0;0.5],"m",[0;1;0.5],"n",[0;0;0.5]),10}
                 % {struct("f",[0;0;0.5],"g",[1;1;0.5],"h",[0;0;0.5],"j",[-1;-1;0.5],"k",[0;0;0.5],"m",[1;-1;0.5],"n",[0;0;0.5]),10}
                 % {struct("f",[0;0;0.5]),10}
                 % {struct("f",[0;0;0.5],"g",[0;0.7;0.5],"h",[0;0;0.5],"j",[0;0.7;0.5],"k",[0;0;0.5]),10}
                 % {struct("f",[-1;-1;0.5],"g",[0;-1;0.5],"h",[1;-1;0.5],"j",[1;0;0.5],"k",[1;1;0.5]),10},...
                 % {struct("f",[1;1;0.5],"g",[0;1;0.5],"h",[-1;1;0.5],"j",[-1;0;0.5],"k",[-1;-1;0.5]),10}
                 % {struct("f",[1;1-1.4674;0.5],"g",[0;1-1.4674;0.5],"h",[-1;1-1.4674;0.5],"j",[0;1-1.4674;0.5],"k",[1;1-1.4674;0.5]),10},...
                 % {struct("f",[1;1;0.5],"g",[0;1;0.5],"h",[-1;1;0.5],"j",[0;1;0.5],"k",[1;1;0.5]),10}
                 
                 };

isCoop = mod(rigid_num,2);
firstId = 1;
if isCoop == 1
    %実験用に修正する必要あり
    firstId = 2;
    COMs = ["",COMs];
    rigids = motive.result.rigid.p;
    eul = Quat2Eul(motive.result.rigid(1).q);
    %fot 文でrhoを計算
    rho = zeros(3,N-1);
    for i = 1:N-1
        rho(:,i) = motive.result.rigid(1+2*i+addId).p - motive.result.rigid(1).p;
    end
    rho
    agent(1) = DRONE; %DRONE.m
    agent(1).parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, "zup","rho",rho);
    agent(1).plant = struct("do",@(varargin)[], "arming" ,[],"stop",[]);
    agent(1).plant.connector.serial = [];

    agent(1).estimator.do = @(varargin)[];
    agent(1).estimator.result.state = STATE_CLASS(struct('state_list', ["p", "q"], "num_list", [3, 3]));
    agent(1).estimator.result.state.p = motive.result.rigid(1).p ;
    agent(1).estimator.result.state.q = eul;
    agent(1).estimator.model.name=[];

    agent(1).sensor = MOTIVE(agent(1), Sensor_Motive(1,eul(3), motive));%機体の情報のクラス，機体のidを入れる
    agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",12,"orig",[0;0;0.8],"size",[0.8,0.8,0.2]},"Cooperative",N},agent(1));
    % agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_saddle",{"freq",12,"orig",[0;0;0.8],"size",[0.7,0.7,0.2]},"HL",N},agent(1));
    % agent(1).reference = MY_POINT_REFERENCE(agent(1),refPointName{1});%縦ベクトルで書く,
    
    agent(1).controller.do = @(varargin)[];
    agent(1).controller.result.input=[];
    
    agent(1).input_transform = struct("do",@(varargin)[], "result",[]);
end

for i = firstId:N
    agentNumber = (2*i-firstId +addId)/2
    sstate = motive.result.rigid(2*i-firstId +addId); %なんか使われていない
    initial_state.p = sstate.p; %初期位置の取得
    initial_state.q = sstate.q; %初期角度の取得
    eul = Quat2Eul(initial_state.q);
    initial_state.v = [0; 0; 0]; %初期速度の取得
    initial_state.w = [0; 0; 0]; %初期角加速度の取得
    
    agent(i) = DRONE; %対象をドローンにしている？ DRONE.m
    agent(i).id = i;
    agent(i).parameter = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");
    agent(i).parameter.set("cableL",cableL(i - firstId + 1));
    agent(i).parameter.set("Length",length(i - firstId + 1));
    agent(i).plant = DRONE_EXP_MODEL(agent(i),Model_Drone_Exp(dt, initial_state, "serial", COMs(i))); %プロポ有線　プロポとの接続
    agent(i).estimator = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state, i,agent(i),1)),  ["p", "q", "pL", "pT"]));
    
    %sensor [2*i-firstId, 2*i-(firstId-1)],firstId=1 or 2:機体1，牽引物1,機体2，牽引物2...の順番の場合,[i,i+N]：機体...,牽引物...
    %各組ごとにmotiveから全ての剛体情報を持ってきているので重くなる原因になるかも?2組4剛体だったら問題ないと思う．各組毎に剛体情報更新するので精度はいいと思う
    agent(i).sensor.motive = MOTIVE(agent(i), Sensor_Motive(2*i-firstId +addId,eul(3), motive));%機体の情報のクラス，機体のidを入れる
    agent(i).sensor.forload = FOR_LOAD(agent(i), Estimator_Suspended_Load(2*i-(firstId-1)+addId));%牽引物の情報のクラス，牽引物のidを入れる
    agent(i).sensor.do = @sensor_do;
    
    agent(i).input_transform = THRUST2THROTTLE_DRONE(agent(i),InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
    
    if isCoop
        agent(i).reference = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"dammy",[],"Split",N},agent(1));
    else
        % agent(i).reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",12,"orig",[0;0;1],"size",[1,1,0.2]},"HL"});
        % agent(i).reference = MY_WAY_POINT_REFERENCE(agent,way_point_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15d3'),5,1));
        agent(i).reference = MY_POINT_REFERENCE(agent(i),refPointName{i});%縦ベクトルで書く,
        % agent(i).reference = TIME_VARYING_REFERENCE(agent(i),refName{i});
        % agent(i).reference = TIME_VARYING_REFERENCE_SUSPENDEDLOAD(agent(i),refName{i});
    end
    agent(i).controller = HLC_SPLIT_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
    agent(i).controller.result.input = [(agent(i).parameter.loadmass*0+agent(i).parameter.mass)*agent(i).parameter.gravity;0;0;0];
end

logger = LOGGER(1:N, size(ts:dt:te, 2), 1, [],[]);%logger
% logger = LOGGER(1:N-firstId+1, size(ts:dt:te, 2), 1, [],[]);%logger

run("ExpBase");
%% functions
function result = sensor_do(varargin)
    result_motive = varargin{5}.sensor.motive.do(varargin);
    result_forload = varargin{5}.sensor.forload.do(varargin);
    result_forload.state.p =  result_motive.state.p;
    result_forload.state.q =  result_motive.state.q;
    varargin{5}.sensor.result = result_forload;
    result=result_forload;
end
function result = controller_do(varargin)
    controller = varargin{5}.controller;
    result = controller.hlc.do(varargin);
    result = merge_result(result,controller.load.do(varargin));
    varargin{5}.controller.result = result;
end

function post(app)
app.logger.plot({1, "q", "s"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({2, "sensor.result.state.pL", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({2, "estimator.result.state.pL", "esr"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({2, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);

% app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({2, "p", "er"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "v", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({2, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes5,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);
dt = diff(app.logger.Data.t(1:find(app.logger.Data.phase==0,1,'first')-1));
t = app.logger.data(0,'t',[]);
figure(100)
plot(t(1:end-1),dt);
hold on
yline(0.025,"LineWidth",0.5)
ylim([0 0.05])
hold off
end
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
% app.Label_2_2p.Text = ["estimator : " + app.agent(2).estimator.result.state.get()];
end