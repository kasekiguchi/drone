function Reference = Reference_PathCenter(SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
%Reference.type=["TrackWpointPathForMPC"];
Reference.name=["path_ref_mpc"];
Reference.type=["PATH_REFERENCE"];

velocity = 1;%目標速度
w_velocity = 0.7;%曲がるときの目標角速度
convjudgeV = 0.5;%収束判断　% 0.5
convjudgeW = 0.5;%収束判断　
Horizon = 3;%MPCのホライゾ

            constant = struct; %定数パラメータ設定
            constant.LineThreshold = 0.1;%0.3;%0.3; %"ax + by + c"の誤差を許容する閾値
            constant.PointThreshold = 0.2;%0.2; %
            constant.GroupNumberThreshold = 5; % クラスタを構成する最小の点数
            constant.DistanceThreshold = 1e-2;%1e-1; % センサ値と計算値の許容誤差，対応付けに使用
            constant.ZeroThreshold = 1e-3; % ゼロとみなす閾値
            constant.CluteringThreshold = 0.5;%0.5; % 同じクラスタとみなす最大距離 通路幅/2より大きくすると曲がり角で問題が起こる
            constant.SensorRange = SensorRange; % Max scan range
            constant.LineDistance = 0.1; % 既存マップ端点からこれ以上離れた線分は別の線分とみなす．

Reference.param={velocity,Horizon,SensorRange,constant};
end
