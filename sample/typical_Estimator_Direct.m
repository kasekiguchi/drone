function typical_Estimator_Direct(agent)
%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
Estimator.name="direct";
Estimator.type="DirectEstimator";
Estimator.param=[];
for i = 1:length(agent)
    agent(i).set_estimator(Estimator);
end
end
