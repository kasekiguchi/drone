function Estimator = Estimator_LPF(agent)
%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
qnum=agent.model.state.num_list(contains(agent.model.state.list,["q"]));
Eparam = struct('LPF_T',0.05,'list',["p","q"],'num_list',[3 qnum]);
Estimator.type = "LPF";
Estimator.name = "lpf";
Estimator.param = {Eparam};
end
