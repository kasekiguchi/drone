function Estimator_feature_based_EKF(agent)
%% estimator class demo
% estimator property をEstimator classのインスタンス配列として定義
Estimator.name="feature_ekf";
Estimator.type="feature_based_EKF";
Estimator.param={struct('sigmaw',1.0E-4*ones(3,1))};%[6.716E-3; 7.058E-3; 7.058E-3])};

            % For experiment for model less
%             obj.param.sigmaw      = 1.0E-4*ones(3,1);                                % The variance vector of observation noise 
%             obj.param.sigmav      = [50;50;50;0.9E02;0.9E02;1.8E02];                 % The variance vector of system noise
%             obj.param.gamma       = 1.2;                                             % Validation region
%             obj.param.SNR         = 1.0E-3;                                          % SN ratio for initial value of posterior error covariance matrix
            
             % For experiment for using input model
%             obj.param.sigmaw      = 1.0E-4*ones(3,1);                                % The variance vector of observation noise 
%             obj.param.sigmav      = [50;50;50;6.0E01;6.0E01;6.0E01];                 % The variance vector of system noise
%             obj.param.gamma       = 1.0;                                             % Validation region
%             obj.param.SNR         = 1.0E-3;                                          % SN ratio for initial value of posterior error covariance matrix

            % For simulation  for model less
%             obj.param.sigmaw      = 1.0E-4*ones(3,1);                                % The variance vector of observation noise 
%             obj.param.sigmav      = [50;50;50;100;100;200];                          % The variance vector of system noise
%             obj.param.gamma       = 0.1;                                             % Validation region
%             obj.param.SNR         = 1.0E-5;                                          % SN ratio for initial value of posterior error covariance matrix

for i = 1:length(agent)
    agent(i).set_estimator(Estimator);
end

end
