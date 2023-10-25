function Reference = Reference_PathCenter(agent,SensorRange)
%% reference class demo
% reference property をReference classのインスタンス配列として定義

velocity = 0.1;%目標速度
Horizon = 5;%MPCのホライゾ

Reference={velocity,Horizon,SensorRange,agent.estimator.ukfslam.constant};
end
