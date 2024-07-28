function Estimator = Estimator_LPF(agent)
%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
qnum=agent.model.state.num_list(contains(agent.model.state.list,["q"]));
Estimator = struct('LPF_T',0.05,'list',["p","q"],'num_list',[3 qnum]);
end
