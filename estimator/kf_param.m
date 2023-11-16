function param = kf_param(agent, dt, initial_state)
% function param = kf_param(agent,initial_state)
% arguments
%     agent
%     dt
%     model
%     output = ["p", "q"]
% end
arguments
    agent
    dt
    initial_state
end

param.model = MODEL_CLASS(agent,Model_Vehicle45(dt, initial_state, 1));

kf_parameter.Q =
kf_parameter.R =
kf_parameter.A =
kf_parameter.B =
kf_parameter.C =
kf_parameter.P =
param.param = kf_parameter;


% param.model = model;
% param.param = kf_param;
end