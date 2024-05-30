function Estimator = Estimator_Suspended_Load(rigid_num)

%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
% すべての機体で同一設定
Estimator.name="for_load";
Estimator.type="FOR_LOAD";
Estimator.rigid_num=rigid_num;
end
