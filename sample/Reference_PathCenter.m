function Reference = Reference_PathCenter(SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義

velocity = 2;%目標速度
Horizon = 1;%MPCのホライゾ

constant = struct; %定数パラメータ設定
constant.LineThreshold = 0.4; %0.3; % 点群から直線を求める時に直線に含む点の直線からの距離閾値
constant.SegmentThreshold = 0.8; %0.5 線分からの距離：線分を直線に統合するかの基準
constant.PointThreshold = 0.3; %0.2; %
constant.GroupNumberThreshold = 5; %5 クラスタを構成する最小の点数
constant.DistanceThreshold = 1e-1; %1e-1; % センサ値と計算値の許容誤差，対応付けに使用
constant.ZeroThreshold = 1e-3; % 1e-3ゼロとみなす閾値
constant.CluteringThreshold = 0.5; %0.5; % 同じクラスタとみなす最大距離 通路幅/2より大きくすると曲がり角で問題が起こる
constant.SensorRange = SensorRange; % Max scan range
constant.LineDistance = 1; %1 既存マップ端点からこれ以上離れた線分は別の線分とみなす．

%Reference={velocity,Horizon,SensorRange,agent.estimator.ukfslam.constant};
Reference={velocity,Horizon,SensorRange,constant};
%Reference={velocity};%,agent.estimator.ukfslam.constant};
end
