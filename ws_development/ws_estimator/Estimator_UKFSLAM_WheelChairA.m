function Estimator = Estimator_UKFSLAM_WheelChairA(agent)

%% estimator class
Estimator.name="ukfslam_WC";
Estimator.type="UKFSLAM_WheelChairA";%propose method
UKF_param.dt = agent(1).model.dt;
UKF_param.Q = diag([1, 1, 1, 1e-1, 1e-1]);
UKF_param.R = 1.0E-3;
% UKF_param.Map_Q = eye(2).*1.0E-6;
UKF_param.Map_Q =1.0E-6;
n = agent.model.dim(1);
UKF_param.dim = n;
UKF_param.P = eye(n); %
UKF_param.k = 1;%
UKF_param.NLP = 2;%Number of Line Param
%     EKF_param.P(1,2) = 0.1;EKF_param.P(2,1) = 0.1;
UKF_param.list=["p","q","v", "w"];
Estimator.param=UKF_param;
% for i = 1:length(agent)
% end
disp('Execute "do" method with following parameter to operate UKF estimator.');
disp('param.estimator={{agent(i),agent(i).sensor.result.state.get(["q","p"]),[]}};')
end