function typical_Estimator_Direct(agent)

%% estimator class demo
% estimator property ��Estimator class�̃C���X�^���X�z��Ƃ��Ē�`
Estimator.name="direct";
Estimator.type="DirectEstimator";
Estimator.param=[];
for i = 1:length(agent)
    agent(i).set_estimator(Estimator);
end
end
