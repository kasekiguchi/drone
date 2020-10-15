function typical_Estimator_AD(agent)
%% estimator class demo
% estimator property ��Estimator class�̃C���X�^���X�z��Ƃ��Ē�`
Eparam = struct('LPF_T',0.05,'list',["p","q";"v","w"],'num_list',[3 3; 3 3]);
Estimator.type = "Approximate_Differentiation";
Estimator.name = "ad";
Estimator.param = {Eparam};
for i = 1:length(agent)
    agent(i).set_estimator(Estimator);
end
end
