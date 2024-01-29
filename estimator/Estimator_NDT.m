function Estimator = Estimator_NDT(agent, dt, model)%,mapname)
% function param = Estimator_NDT(agent,dt,initial_state,mapname)
% arguments
%     agent
%     dt
%     model
%     output = ["p", "q"]
% end
arguments
    agent
    dt
    model
    % mapname
end

Estimator.model = model;


% the constant value for estimating of the map
%初期位置set
% initial_state.rot = eul2rotm(model.state.q','XYZ');%回転行列(roll,pitch,yaw)
% NDT_param.initialtform = rigidtform3d(initial_state.rot,model.state.p);
% if strcmp(mapname,"slam")
%     NDT_param.fixedSeg = zeros(0);
% else
%     NDT_param.fixedSeg = load(mapname);
% end
% NDT_param.fixedSeg = pcread(mapname);
% Estimator.param = NDT_param;
Estimator.param = [model.state.p model.state.q];
Estimator.func = @scanpcplot_rov;
end
