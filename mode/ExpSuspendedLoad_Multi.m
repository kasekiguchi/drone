% 複数機の単機牽引モデルを同時に飛ばすmodeファイル
% 複数機で一つの牽引物を牽引するモードと複数の単機牽引モデルを同時に飛ばすモードがあるが取得した剛体数で自動で判断する
%=TODO==========================================================================
%
%===============================================================================
ts                  = 0;                                % initial time　開始時間
dt                  = 0.025;                            % sampling period　サンプリング間隔
te                  = 10000;                            % termina time　終了時間
time                = TIME(ts,dt,te);                   % 上の3つの時間をまとめる．
in_prog_func        = @(app) in_prog(app);              % guiのプロットに関する関数
post_func           = @(app) post(app);                 % guiのプロットに関する関数
    
motive              = Connector_Natnet('192.168.1.4');  % connect to Motive　実験室モーションキャプチャのIP.総研：'192.168.120.4'
motive.getData([], []);                                 % get data from Motive モーションキャプチャからのデータを入手する
rigid_num           = motive.result.rigid_num;          % 剛体数

%各pcが担当する単機牽引の数と使用する剛体のrigidIdの計算
handlingModelNum    = 1:2;                              % 扱う機体数の番号を配列で連番で書く:3~5機目を扱うときhandlingModelNum = 3:5
N                   = length(handlingModelNum) + mod(rigid_num,2);
addId               = (handlingModelNum(1) - 1)*2 ;%+ mod(rigid_num,2);

%COMの番号指定
COMs                = [3,12];                           % pc1 lenovo割り当てる順番に設定
% COMs = [5,11];%pc2 nav割り当てる順番に設定

% 紐の長さ
% cableL=[0.77,0.77];
% cableL=[0.896,0.896];
% cableL=[0.785,0.785];
cableL              = [0.822,0.887];

% 複数の単機牽引モデルを飛ばす場合のrefernceファイルの設定
refName         = {
                    {"My_Case_study_trajectory",{[1,1,1]},"HL"},...
                    {"My_Case_study_trajectory",{[-1,-1,1]},"HL"}
                    % {"gen_ref_saddle",{"freq",13,"orig",[2;2;1],"size",[1,1,0.2]},"HL"}
                    };
refPointName    = {
                    {struct("f",[0;0;0.5],"g",[1;0;0.5],"h",[0;0;0.5],"j",[0;1;0.5],"k",[0;0;0.5],"m",[-1;-1;0.5],"n",[0;0;0.5]),10}
                   };

% クラスファイルの設定
firstId = 1;                % 複数機牽引ではない場合の最初の番号
isCoop  = mod(rigid_num,2); % 複数機牽引であるかの判別(剛体数が奇数のとき1)

% 複数機牽引の場合の牽引物の設定
% agentの番号は1が牽引物，それ以降は機体，紐の接続点の順番に交互に定義される
if isCoop == 1
    firstId = 2;
    COMs            = ["",COMs];                            % プロポのcom番号
    rigids          = motive.result.rigid.p;                % 位置の剛体情報を取得
    eul             = Quat2Eul(motive.result.rigid(1).q);   % 牽引物の角度を取得しクオータニオンからオイラー角に変換
    rho             = zeros(3,N-1);
    % 牽引物の剛体位置から各紐の接続点までの方向ベクトルを計算
    for i = 1:N-1
        rho(:,i)    = motive.result.rigid(1+2*i+addId).p - motive.result.rigid(1).p;
        disp("rho "+num2str(i)+" :"+num2str(rho(:,i)')) % rhoの計算結果を描画
    end
    
    %紐の接続点が頂点の図形の中心の場合(平面を仮定)
    % pLs = zeros(3,N-1);
    % for i = 1:N-1
    %     pLs(:,i) = motive.result.rigid(1+2*i+addId).p;
    % end
    % polyin = polyshape(pLs(1,1:N),pLs(2:N));
    % [x,y] = centroid(polyin);
    % G = [x;y;motive.result.rigid(1).p(3)];
    % deltaG = G - motive.result.rigid(1).p;
    % % 重心から接続点までの距離とdeltaGとrho1rho2の内積
    % dotDeltaG = [rho(1:2,1)';rho(1:2,2)']*deltaG ;
    % rho = pLs-G;%図形重心からのrhoに変更
    % agent(1).parameter = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, "zup","rho",rho,"G",G,"dotDeltaG",dotDeltaG);
    

    % 牽引物のagentを設定．必要なものはセンサー値のみなのでそれ以外は共通プログラムと辻褄が合うように空の配列などを設定
    agent(1)            = DRONE; 
    agent(1).parameter  = DRONE_PARAM_COOPERATIVE_LOAD("DIATONE", N, "zup","rho",rho);      %rhoや機体数の情報を設定
    agent(1).plant      = struct("do",@(varargin)[], "arming" ,[],"stop",[]);
    agent(1).plant.connector.serial = [];

    % 推定は行わない
    agent(1).estimator.do               = @(varargin)[];
    agent(1).estimator.result.state     = STATE_CLASS(struct('state_list', ["p", "q"], "num_list", [3, 3]));
    agent(1).estimator.result.state.p   = motive.result.rigid(1).p ;
    agent(1).estimator.result.state.q   = eul;
    agent(1).estimator.model.name       = [];

    % MOTIVEから位置と角度を取得する
    agent(1).sensor                     = MOTIVE(agent(1), Sensor_Motive(1,eul(3), motive)); 

    % 複数機牽引の場合の牽引物の目標位置
    agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_sample_cooperative_load",{"freq",12,"orig",[0;0;0.7],"size",[0.8,0.8,0.2*0]*0},"Cooperative",N},agent(1));
    % agent(1).reference = TIME_VARYING_REFERENCE_SPLIT(agent(1),{"gen_ref_saddle",{"freq",12,"orig",[0;0;0.8],"size",[0.7,0.7,0.2]},"HL",N},agent(1));
    % agent(1).reference = MY_POINT_REFERENCE(agent(1),refPointName{1});%縦ベクトルで書く,

    % コントローラは単機モデルで設計するのでここでは行わない
    agent(1).controller.do              = @(varargin)[];
    agent(1).controller.result.input    = [0;0;0;0];

    % 入力のプロポの値への変換も単機モデルでするのでここで行わない
    agent(1).input_transform            = struct("do",@(varargin)[], "result",[]);

    plot_and_close(rigid_num,agent);%Motive入れ替わり対策グラフ．plot_and_close.mで設定してる
end

% 単機牽引モデルのクラスの設定
% firstIdは複数の単機牽引モデルの場合は1, 複数機による牽引の場合は2から始まる．
for i = firstId:N
    agentNumber                 = (2*i-firstId +addId)/2                    % 剛体idのチェック
    sstate                      = motive.result.rigid(2*i-firstId +addId);  % 機体の位置と角度を取得
    initial_state.p             = sstate.p;                                 % 機体の初期位置
    initial_state.q             = sstate.q;                                 % 機体の初期角度
    eul                         = Quat2Eul(initial_state.q);                % クオータニオンからオイラー角に変更
    initial_state.v             = [0; 0; 0];                                % 機体の初期速度
    initial_state.w             = [0; 0; 0];                                % 機体の初期角加速度
    initial_state.pL            = [0; 0; 0];                                % 牽引物の初期位置
    initial_state.pT            = [0; 0; 0];                                % 紐の方向の初期位置
        
    agent(i)                    = DRONE; % モデルクラスファイルを設定このクラスのプロパティに以下のものを設定
    agent(i).id                 = i; %機体ののidを代入．これを単機牽引モデルのidとする．
    agent(i).parameter          = DRONE_PARAM_SUSPENDED_LOAD("DIATONE");
    agent(i).parameter.set("cableL",cableL(i - firstId + 1));
    agent(i).plant              = DRONE_EXP_MODEL(agent(i),Model_Drone_Exp(dt, initial_state, "serial", COMs(i))); %プロポ有線　プロポとの接続
     
    %　推定の設定：機体の位置と角度，牽引物の位置，紐の単位方向ベクトルを観測値として用いる
    agent(i).estimator          = EKF(agent(i), Estimator_EKF(agent(i),dt,MODEL_CLASS(agent(i),Model_Suspended_Load(dt, initial_state, i,agent(i),1)),  ["p", "q", "pL", "pT"]));

    % sensor [2*i-firstId, 2*i-(firstId-1)],firstId=1 or 2:機体1，牽引物1,機体2，牽引物2...の順番の場合,[i,i+N]：機体...,牽引物...
    % 各組ごとにmotiveから全ての剛体情報を持ってきているので重くなる原因になるかも?2組4剛体だったら問題ないと思う．各組毎に剛体情報更新するので精度はいいと思う
    agent(i).sensor.motive      = MOTIVE(agent(i), Sensor_Motive(2*i-firstId +addId,eul(3), motive));    %機体の情報のクラス，機体のidを入れる
    agent(i).sensor.forload     = FOR_LOAD(agent(i), Estimator_Suspended_Load(2*i-(firstId-1)+addId));  %牽引物の情報のクラス，牽引物のidを入れる
    agent(i).sensor.do          = @sensor_do;
   
    % referenceの設定
    %複数機による牽引の場合の位置はagent(1)で設定した位置からrhoずらした値とする．それ以外はagent(1)と同様
    if isCoop
        agent(i).reference      = TIME_VARYING_REFERENCE_SPLIT(agent(i),{"dammy",[],"Split",N},agent(1));
    % 複数の単機モデルの場合
    else
        % agent(i).reference    = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",12,"orig",[0;0;1],"size",[1,1,0.2]},"HL"});
        % agent(i).reference    = MY_WAY_POINT_REFERENCE(agent,way_point_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15d3'),5,1));
        agent(i).reference      = MY_POINT_REFERENCE(agent(i),refPointName{i});%縦ベクトルで書く,
        % agent(i).reference    = TIME_VARYING_REFERENCE(agent(i),refName{i});
        % agent(i).reference    = TIME_VARYING_REFERENCE_SUSPENDEDLOAD(agent(i),refName{i});
    end
    % コントローラの設定，初期入力は機体と牽引物質量が釣り合う推力のみでトルクは全て0
    % 複数の単機牽引モデルではHLC_SUSPENDED_LOADでもいいかも
    agent(i).controller         = HLC_SPLIT_SUSPENDED_LOAD(agent(i),Controller_HL_Suspended_Load(dt,agent(i)));
    
    % 設計した入力をプロポの値に変換
    agent(i).input_transform    = THRUST2THROTTLE_DRONE(agent(i),InputTransform_Thrust2Throttle_drone()); 
end

%log
logger = LOGGER(1:N, size(ts:dt:te, 2), 1, [],[]);

% take off landing の設定
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
% 刻み時間描画
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
%miyake削除
% function key_press_callback(~, event, fig)
% % Enterキーが押された場合にFigureを閉じる
%     if strcmp(event.Key, 'return')
%         close(fig);
%     end
%miyake削除↑
% end