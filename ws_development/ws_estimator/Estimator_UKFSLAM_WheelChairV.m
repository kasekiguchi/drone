function Estimator = Estimator_UKFSLAM_WheelChairV(agent,Gram)

%% estimator class
Estimator.name="ukfslam_WC";
Estimator.type="UKFSLAM_WheelChairV";%propose method
UKF_param.dt = agent(1).model.dt;
%    EKF_param.Q = eye(3)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % 繧キ繧ケ繝?繝?繝弱う繧コ?シ?Model繧ッ繝ゥ繧ケ逕ア譚・?シ?
UKF_param.Q = diag([1.0, 1.0, 1.0]);
%     EKF_param.Q(3,3) = 0;
%     EKF_param.Q(6,6) = 0;%鬮倥＆譁ケ蜷代?ッ蛻?謨」縺ェ縺?
%     EKF_param.R = diag([[6.716E-5; 7.058E-5; 7.058E-5];[6.716E-5; 7.058E-5; 7.058E-5]/100]);%eye(6).*1.0E-4;%1.0e-1; % 隕ウ貂ャ繝弱う繧コ?シ?Sensor繧ッ繝ゥ繧ケ逕ア譚・?シ?
UKF_param.R = 1.0E-3;
% UKF_param.Map_Q = eye(2).*1.0E-6;
UKF_param.Map_Q =1.0E-6;
n = agent.model.dim(1);
UKF_param.dim = n;
UKF_param.P = eye(n); %
UKF_param.k = 3;%
%     EKF_param.P(1,2) = 0.1;EKF_param.P(2,1) = 0.1;
UKF_param.list=["p","q"];
%------ For Analysys---------
UKF_param.Gram = Gram;
%-------------------------------
Estimator.param=UKF_param;
% for i = 1:length(agent)
% end
disp('Execute "do" method with following parameter to operate UKF estimator.');
disp('param.estimator={{agent(i),agent(i).sensor.result.state.get(["q","p"]),[]}};')
end