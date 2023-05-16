# 被覆制御

2022/05/13

## シミュレーションをする場合

### 必須設定項目
Env = DensityMap_sim(Env_2DCoverage); % 重要度マップ設定
agent(i).set_property("sensor",Sensor_Direct()); % 状態真値(plant.state)　：simのみ
agent(i).set_property("sensor",Sensor_RangePos(i,1)); % 半径r (第二引数) 内の他エージェントの位置を計測 : sim のみ
agent(i).set_property("sensor",Sensor_RangeD(1)); %  半径r (第二引数) 内の重要度を計測 : sim のみ
agent(i).set_property("estimator",struct('type',"MAP_UPDATE",'name','map','param',Env)); % map 更新用 重要度などのmapを時間更新する
agent(i).set_property("reference",Reference_2DCoverage(agent(i),Env)); % Voronoi重心

%VORONOI_BARYCENTER.draw_movie(logger, N, Env,1:N) : プロット用

### チューニングパラメータ
N : 台数
dt : 刻み時間 (刻み時間を粗くするときはコントローラゲイン(F2,F3)を下げた方がいい )
arranged_pos = arranged_position([0, 0], N, 1, 0); : 初期配置 ()
