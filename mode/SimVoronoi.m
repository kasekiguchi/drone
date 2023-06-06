ts = 0;
dt = 0.025;
te = 10;
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);
post_func = @(app) post(app);

N = 3;

logger = LOGGER(1:N, size(ts:dt:te, 2), 0, [],[]);
env = DensityMap_sim(Env_2DCoverage); % Weighted 2D map : 重要度マップ設定
arranged_pos = arranged_position([0, 0], N, 1, 0);

for i = 1:N
  agent(i) = DRONE;
  agent(i).id = i;
  initial_state(i).p = arranged_pos(:, i);
  initial_state(i).v = [0; 0; 0];
  [M,P]=Model_Discrete(dt,initial_state(i),1,"P");
  agent(i).controller = DirectController(agent(i),[]);% 次時刻に入力の位置に移動するモデル用：目標位置を直接入力とする
  %[M,P]=Model_Discrete(dt,initial_state(i),1,"PV");
  %agent(i).controller = PID_CONTROLLER(agent(i),Controller_PID(dt).param); % not work for drone
  agent(i).plant = MODEL_CLASS(agent(i),M); % 離散時間質点モデル : PD controller などを想定
  agent(i).model = MODEL_CLASS(agent(i),M);
  agent(i).parameter = P;
  agent(i).sensor.direct = DIRECT_SENSOR(agent(i),Sensor_Direct(0.0).param); % 状態真値(plant.state)　：simのみ % 入力はノイズの大きさ
  agent(i).sensor.rpos = RANGE_POS_SIM(agent(i),Sensor_RangePos(i,'r',4).param); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
  agent(i).sensor.rdensity = RANGE_DENSITY_SIM(agent(i),Sensor_RangeD('r',2).param); %  半径r (第二引数) 内の重要度を計測 : sim のみ
  agent(i).sensor.do = @sensor_do;
  agent(i).estimator = DIRECT_ESTIMATOR(agent(i),Estimator_Direct().param); % Directセンサーと組み合わせて真値を利用する　：sim のみ
  agent(i).reference = VORONOI_BARYCENTER(agent(i),Reference_2DCoverage(agent(i),env,'void',0).param); % Voronoi重心
end
%% local function
function result = sensor_do(varargin)
sensor = varargin{5}(varargin{6}).sensor;
result = sensor.direct.do(varargin);
result = merge_result(result,sensor.rpos.do(varargin));
result = merge_result(result,sensor.rdensity.do(varargin));
varargin{5}(varargin{6}).sensor.result = result;
end

function in_prog(app) % in progress procedure
app.env.show(app.UIAxes);
VORONOI_BARYCENTER.show_k(app.logger, app.env,"span",1:app.N,"ax",app.UIAxes,"clear",false);
end
function post(app) % post procedure
VORONOI_BARYCENTER.draw_movie(app.logger, app.env,1:app.N,app.UIAxes);
end
