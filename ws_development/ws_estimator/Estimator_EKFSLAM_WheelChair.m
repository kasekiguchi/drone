function Estimator = Estimator_EKFSLAM_WheelChair(agent,range)

%% estimator class
Estimator.name="ekfslam_WC";
Estimator.type="EKFSLAM_WheelChairAOmega";%propose method
EKF_param.Q = diag([1.0, 1.0, 1, 1e-1]);
% Estimator.type="EKFSLAM_WheelChairA";%propose method
% EKF_param.Q = diag([1.0, 1.0, 1, 1, 1]);
% Estimator.type="CmpEKFSLAM_WheelChair";%the compare method as 3 state
EKF_param.dt = agent(1).model.dt;
%    EKF_param.Q = eye(3)*7.058E-5;%.*[50;50;50;1E04;1E04;1E04];%1.0e-1; % 繧キ繧ケ繝?繝?繝弱う繧コ?シ?Model繧ッ繝ゥ繧ケ逕ア譚・?シ?
%     EKF_param.Q(3,3) = 0;
%     EKF_param.Q(6,6) = 0;
%     EKF_param.R = diag([[6.716E-5; 7.058E-5; 7.058E-5];[6.716E-5; 7.058E-5; 7.058E-5]/100]);%eye(6).*1.0E-4;%1.0e-1; % 隕ウ貂ャ繝弱う繧コ?シ?Sensor繧ッ繝ゥ繧ケ逕ア譚・?シ?
EKF_param.R = 1.0E-3;
EKF_param.Map_Q = eye(2).*1.0E-6;
n = agent(1).model.dim(1);
EKF_param.P = eye(n); % 
EKF_param.range = range;
%     EKF_param.P(1,2) = 0.1;EKF_param.P(2,1) = 0.1;
EKF_param.list=["p","v"];
Estimator.param=EKF_param;
disp('Execute "do" method with following parameter to operate EKF estimator.');
disp('param.estimator={{agent(i),agent(i).sensor.result.state.get(["q","p"]),[]}};')
end