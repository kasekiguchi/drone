function Estimator  = Estimator_AD()
%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
Estimator = struct('LPF_T',0.05,'list',["p","q";"v","w"],'num_list',[3 3; 3 3]);
end
