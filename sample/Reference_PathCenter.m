function Reference = Reference_PathCenter(agent,SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義

velocity = 0.25;%目標速度
% Horizon = 5;%MPCのホライゾ

% Reference={velocity,Horizon,SensorRange,agent.estimator.ukfslam.constant};
Reference={velocity};%,agent.estimator.ukfslam.constant};
end
