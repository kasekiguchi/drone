function typical_Estimator_PDAF(agent)
%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
Estimator.name="pdaf";
Estimator.type="PDAF";
Estimator.param={struct('sigmaw',1.0E-4*ones(3,1))};%[6.716E-3; 7.058E-3; 7.058E-3])};
for i = 1:length(agent)
    agent(i).set_estimator(Estimator);
end
end
