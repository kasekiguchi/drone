function Estimator = Estimator_UKFSLAM_WheelExp(agent,SensorRange)

%% estimator class
Estimator.name = "ukfslam";
Estimator.type = "UKFSLAM_WheelExp";
Ukf_param.dt = agent(1).model.dt;
Ukf_param.dim = agent.model.dim(1);
Ukf_param.P = eye(Ukf_param.dim);
Ukf_param.k = 800;
Ukf_param.NLP = 2;%Number of Line Param
Ukf_param.SensorRange = SensorRange;%センサレンジを呼び出し
Ukf_param.list=["p","q","v"];
Estimator.param=Ukf_param;

end