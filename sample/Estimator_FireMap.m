function Estimator_FireMap(agent)

%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
Estimator.name="firemap";
Estimator.type="ForestFireMap";
est.D = 1;
est.map_min = [-50 -50];%[x_min y_min]
est.map_max = [50 50];%[x_min y_min]
est.name="firemap";
Estimator.param={est};
for i = 1:length(agent)
    Estimator.param{1,1}.id=i;
    agent(i).set_estimator(Estimator);
end
end
