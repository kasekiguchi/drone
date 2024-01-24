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

function pcdata = scanpcplot_rov(data1,data2)
    scanlidardata_b = data1.getData;
    scanlidardata_f = data2.getData;
    moving_f = rosReadCartesian(scanlidardata_f);
    moving_b = rosReadCartesian(scanlidardata_b);
    moving_pc.f = [moving_f zeros(size(moving_f,1),1)];
    moving_pc.b = [moving_b zeros(size(moving_b,1),1)];
    roi = [0.1 0.35 -0.18 0.16 -0.1 0.1];
    moving_pc.f = Pointcloud_manual_roi(moving_pc.f,roi);
    moving_pc.b = Pointcloud_manual_roi(moving_pc.b,roi);
    rot = eul2rotm(deg2rad([0 0 180]),'XYZ');
    T = [0.46 0.023 0];
    moving_pc2_m_b = tform_manual(moving_pc.b,rot,T);
    ptCloudOut = [moving_pc.f;moving_pc2_m_b];
    rot = eul2rotm(deg2rad([0 0 180]),'XYZ');
    T = [0.17 0 0];
    moving_pcm = tform_manual(ptCloudOut,rot,T);
    pcdata = pointCloud(moving_pcm);
end