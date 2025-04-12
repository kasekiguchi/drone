%=====================
%牽引物の分割モデルguiは使わないすべてこのファイルで完結
%=====================
clc; clear; close all
N            = 4;%機体数
ts           = 0;%初期時刻
dt           = 0.025;%刻み時間
te           = 5+0*100/2;%シミュレーション時間
tn           = length(ts:dt:te);%mainloopで繰り返す回数
time         = TIME(ts, dt, te);%時刻のクラス
motive       = Connector_Natnet_sim(1, dt, 0); % 3rd arg is a flag for noise (1 : active )
logger       = LOGGER(1:N+1, size(ts:dt:te, 2), 0, [], []);%logをとるクラス%分割前1,分割後N個
in_prog_func = @(app) dfunc(app);%gui関連
post_func    = @(app) dfunc(app);%gui関連

%複数機牽引のplantモデルで使うファイル===========================================================
% example       : CLASS NAME / function in sample folder
% parameter     : DRONE_PARAM_COOPERATIVE_LOAD
% plant         : MODEL_CLASS / Model_Suspended_Cooperative_Load
% sensor        : DIRECT_SENSOR, MODEL_CLASS 
% estimator     : DIRECT_ESTIMATOR, MODEL_CLASS / Model_Suspended_Cooperative_Load
% reference     : TIME_VARYING_REFERENCE_SPLIT  / gen_ref_sample_cooperative_load
% controller    : CSLC / Controller_Cooperative_Load (使う必要はない)
%=============================================================================================
%Payload_Initial_State, 状態：x = [p0 Q0 v0 O0 qi wi Qi Oi]
    initial_state(1).p  = [0; 0; 0];%牽引物位置
    initial_state(1).v  = [0; 0; 0];%牽引物速度
    initial_state(1).O  = [0; 0; 0];%牽引物の角速度
    initial_state(1).wi = repmat([0; 0; 0], N, 1);%紐の角速度
    initial_state(1).Oi = repmat([0; 0; 0], N, 1);%機体の角速度
    initial_state(1).a  = [0;0;0];%牽引物加速度，状態ではないが値を取得可能
    initial_state(1).dO = [0;0;0];%牽引物角加速度，状態ではないが値を取得可能
    
    qtype = "zup"; % "eul":euler angle, "":euler parameter%元の論文がzdown
    if contains(qtype, "zup")
        initial_state(1).qi = -1 * repmat([0;0;1], N, 1);%紐の方向ベクトル
        pT_sgn              = -1;
    else
        initial_state(1).qi = 1 * repmat([0; 0; 1], N, 1);%紐の方向ベクトル
        pT_sgn              = 1;
    end
    
    if contains(qtype, "eul")
        initial_state(1).Q  = [0; 0; 0];%牽引物の姿勢
        initial_state(1).Qi = repmat([0;0;0],N,1);%機体の姿勢
    else
        initial_state(1).Q  = Eul2Quat([0;0;0*pi/180]);%牽引物の姿勢
        initial_state(1).Qi = repmat([1; 0; 0; 0], N, 1);%機体の姿勢
    end
%Generate instance of payload with quadcopters
    agent(1)            = DRONE;%機体のクラスの設定
    agent(1).id         = 1;%i = 1は複数機牽引のプラント
    agent(1).parameter  = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, qtype);%物理パラメータのクラスを設定
    %紐qiの初期角度, rho方向への傾きを設定可能
        degi                = 4;%紐qiの初期角度(deg)
        rho12               = [agent(1).parameter.rho(1:2,:);zeros(1,N)];
        rho12Unit           = rho12./vecnorm(rho12);
        pTpre               = rho12Unit*tan(degi*pi/180) + [0;0;1];%tanの中で角度指定（地面に垂直が0 deg = [0;0;-1]）syuronn_4deg 
        initial_state(1).qi = pT_sgn*reshape(pTpre./vecnorm(pTpre),[],1) ;%紐の初期角度を表す方向ベクトルzup- zdown+
    agent(1).plant      = MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype));%plantのモデルのクラスを設定
    agent(1).sensor     = DIRECT_SENSOR(agent(1),0.0);%センサークラスを設定,plantの状態をそのまま取得．sensor to capture plant position : second arg is noise
    agent(1).estimator  = DIRECT_ESTIMATOR(agent(1), struct("model", MODEL_CLASS(agent(1), Model_Suspended_Cooperative_Load(dt, initial_state(1), 1, N, qtype))));%推定のクラスを設定，plantの状態をそのまま取得
    % agent(1).reference = MY_WAY_POINT_REFERENCE(agent(1),generate_spline_curve_ref(readmatrix("waypoint.xlsx",'Sheet','takeOff_0to1m'),7,1));
    agent(1).reference  = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",8,"orig",[0;0;0.8],"size",[0.8,0.8,0.2*1]*1.2},"Cooperative",N},agent(1));%目標軌道のクラスを設定
    agent(1).controller = CSLC(agent(1), Controller_Cooperative_Load(dt, N));%コントローラのクラスを設定．単機牽引モデルで設計するので必要ない． 

%単機牽引モデルの設定
for i = 2:N+1
    %=DRONE==================================================================================================================
    % parameter     : DRONE_PARAM_SUSPENDED_LOAD
    % plant         : MODEL_CLASS / Model_Suspended_Load
    % sensor        : DIRECT_SENSOR
    % estimator     : EKF / Estimator_EKF
    % reference     : TIME_VARYING_REFERENCE_SPLIT / Case_study_trajectory
    % controller    : HLC_SPLIT_SUSPENDED_LOAD / Controller_HL_Suspended_Load
    %========================================================================================================================
    %=推定方法を変える場合=====================================================================================================
    % Model_Suspended_Load(dt,initial,id,agent,isEstLoadMass)
    %-牽引物質量や外乱などを推定しない： isEstLoadMass = 0 
    %-牽引物質量や外乱などを推定する　： isEstLoadMass = 1
    %========================================================================================================================
%Drone_Initial_Stat
    rho     = agent(1).parameter.rho; %牽引物上の点から紐の接続点までの距離
    R_load  = RodriguesQuaternion(initial_state(1).Q);%牽引物座標からのグローバル座標への回転行列
    initial_state(i).q  = [0; 0; 0];%機体角度
    initial_state(i).v  = [0; 0; 0];%仮想分割後の牽引物速度
    initial_state(i).w  = [0; 0; 0];%機体角速度(記録用，入力設計では用いない)
    initial_state(i).vL = [0; 0; 0];%仮想分割後の牽引物速度
    initial_state(i).pT = initial_state(1).qi(3*(i - 1)-2:3*(i-1),1);%機体から紐の接続点方向への紐の単位ベクトル
    initial_state(i).wL = [0; 0; 0];%紐の角速度
    initial_state(i).p  = initial_state(1).p + R_load*rho(:,i-1) - agent(1).parameter.li(i-1) * initial_state(i).pT;%機体の位置(pTの計算に用いる)
    initial_state(i).pL = initial_state(1).p + R_load*rho(:,i-1);%仮想分割後の牽引物の位置
%Generate instance
    agent(i)            = DRONE;%機体のクラスの設定
    agent(i).id         = i;%単機牽引のインデックスはid = 2から
    % パラメータの設定
        li = agent(1).parameter.li(i-1);%紐の長さ
        mi = agent(1).parameter.mi(i-1);%機体質量
        jx = agent(1).parameter.Ji(1,i-1);%機体慣性モーメントxx
        jy = agent(1).parameter.Ji(2,i-1);%機体慣性モーメントyy
        jz = agent(1).parameter.Ji(3,i-1);%機体慣性モーメントzz
    agent(i).parameter  = DRONE_PARAM_SUSPENDED_LOAD("DIATONE","cableL",li,"mass",mi,"loadmass",0,"jx",jx,"jy",jy,"jz",jz);%単機牽引モデルのパラメータクラス設定（複数モデルの機体と同じパラメータに設定）
    agent(i).plant      = MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i),1,agent(i)));%単機牽引モデルのプラントクラス設定id,dt,type,initial,varargin
    agent(i).sensor     = DIRECT_SENSOR(agent(i),0.0); %単機牽引モデルのクラス設定 sensor to capture plant position : second arg is noise
    agent(i).estimator  = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state(i), 1,agent(i),1)), ["p", "q", "pL", "pT"]));%単機牽引モデルの推定クラス設定（EKF）
    agent(i).controller = HLC_SPLIT_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));%単機牽引モデルのコントローラクラス設定
    agent(i).reference  = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"dammy",[],"Split",N},agent(1));%目標軌道のクラス設定
end
% take off landing の設定
run("ExpBase");

%観測値に加えるガウスノイズ
    noize_sp = normrnd(0,0.001,[3,tn])*1*0;%機体位置
    noize_sqDrone = 1*normrnd(0,0.0017,[3,tn])*1*0;%紐の接続点，degで0.1くらいの標準偏差
clc
% main loop
% ~ doは各クラスで現在時刻の計算を行う
for tc = 1:tn
    for i = 1:N+1
        if i == 1
            %複数機牽引
                agent(1).sensor.do(time, 'f');
                agent(1).estimator.do(time, 'f');
                agent(1).reference.do(time, 'f',agent(1)); 
                agent(1).controller.result.Qeul = Quat2Eul(agent(1).estimator.result.state.Q);%牽引物の角度をquotからeulにするのみ使用
                input = zeros(4*N,1);
        else
            %単機牽引モデルに用いるsensor値
                sensor1 = agent(1).sensor.result.state;%複数機モデルから機体と接続点の位置を計測
                %分割前牽引物
                    sp      = sensor1.p;
                    sR      = RodriguesQuaternion(sensor1.Q);%回転行列
                %分割後牽引物
                    spL     = sp + sR*rho(:,i-1) + noize_sp(:,tc);%分割後の質量重心位置
                    spT     = sensor1.qi(3*i-5:3*i-3,1);%分割後の紐の方向ベクトル
                %機体
                    spDrone = spL - agent(1).parameter.li(i-1)*spT;
                    sqDrone = Quat2Eul(sensor1.Qi(4*i-7:4*i-4,1))+noize_sqDrone(:,tc);
                % 単機牽引モデルで用いるセンサー値を設定
                    agent(i).sensor.result.state.set_state("p",spDrone,"q",sqDrone,"pL",spL,"pT",spT);

            %単機牽引モデルの状態を推定
                agent(i).estimator.do(time, 'f');

            %単機牽引モデルの目標軌道
                agent(i).reference.do(time, 'f',agent(1));

            %単機牽引モデルの入力
                agent(i).controller.do(time, 'f',0,0,agent(i),i);
                input(4*(i-1)-3:4*(i-1),1)  = agent(i).controller.result.input;% agent(1)に入れる入力

            %単機牽引モデルのplantの真値
                load        = agent(1).estimator.result.state;%推定をしていない
                %分割前牽引物
                    p_load      = load.p;%牽引物位置
                    R_load      = RodriguesQuaternion(load.Q);%回転行列
                    dR_load     = R_load*Skew(load.O);%回転行列の微分
                    wi_load     = load.wi(3*i-5:3*i-3,1);%分割前のagent(i)の紐の角速度ベクトル
                %分割後牽引物
                    pL_agent    = p_load + R_load * rho(:,i-1);%分割後の質量重心位置
                    vL_agent    = load.v + dR_load * rho(:,i-1);%分割後の質量重心速度
                    pT_agent    = load.qi(3*i-5:3*i-3,1);%分割後の紐の方向ベクトル
                    dpT_agent   = Skew(wi_load)*pT_agent;%分割後の紐の角速度ベクトル
                %機体
                    p_agent     = p_load + R_load * rho(:,i-1) - agent(1).parameter.li(i-1)*pT_agent;%位置
                    v_agent     = load.v + dR_load * rho(:,i-1)- agent(1).parameter.li(i-1)*dpT_agent;%速度
                    q_agent     = Quat2Eul(load.Qi(4*i-7:4*i-4,1));%角度
                    w_agent     = load.Oi(3*i-5:3*i-3,1);%角速度
                %単機牽引の真値を設定
                    agent(i).plant.state.set_state("pL",pL_agent,"vL",vL_agent);
                    agent(i).plant.state.set_state("pT",pT_agent,"wL",wi_load);
                    agent(i).plant.state.set_state("p",p_agent,"v",v_agent);
                    agent(i).plant.state.set_state("q",q_agent,"w",w_agent);
                %複数牽引モデルの状態をそのまま単機牽引モデルに入れる場合(検証用)
                % agent(i).estimator.result.state.set_state("pL",pL_agent,"vL",vL_agent);
                % agent(i).estimator.result.state.set_state("pT",pT_agent,"wL",wi_load);
                % agent(i).estimator.result.state.set_state("p",p_agent,"v",v_agent);
                % agent(i).estimator.result.state.set_state("q",q_agent,"w",w_agent);
        end
    end
    %単機牽引で求めた入力を複数機牽引のplantに入れる
        agent(1).controller.result.input = input;
        agent(1).plant.do(time, 'f');%複数機牽引のplantを更新する
    
    %log current time reult
        logger.logging(time, 'f', agent);

    %現在時刻の表示と時刻の更新
        disp(time.t)
        time.t = time.t + time.dt;
end
disp(time.t - time.dt)
%% plot
% close all
run("DataPlot.m")
%% movie
mov = DRAW_COOPERATIVE_DRONES(logger, "self", agent, "target", 1:N);
% mov.animation(logger, 'target', 1:N, "gif",1,"lims",[-4 4;-4 4;0 7],"ntimes",5);%dataフォルダに保存される
mov.animation(logger, 'target', 1:N,"lims",[-4 4;-4 4;0 7]*1,"ntimes",5);%保存されない

%% function
function dfunc(app)
app.logger.plot({1, "p", "er"}, "ax", app.UIAxes, "xrange", [app.time.ts, app.time.t]);
app.logger.plot({1, "q", "e"}, "ax", app.UIAxes2, "xrange", [app.time.ts, app.time.t]);
app.logger.plot({1, "input", ""}, "ax", app.UIAxes3, "xrange", [app.time.ts, app.time.t]);
end
