function Estimator_LPF(agent)
%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
qnum=agent(1).model.state.num_list(contains(agent(1).model.state.list,["q"]));
Eparam = struct('LPF_T',0.05,'list',["p","q"],'num_list',[3 qnum]);
Estimator.type = "LPF";
Estimator.name = "lpf";
Estimator.param = {Eparam};
for i = 1:length(agent)
    agent(i).set_estimator(Estimator);
end
end
