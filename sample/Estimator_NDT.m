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
end

Estimator.model = model;
Estimator.param = [model.state.p model.state.q];

Estimator.ndt.matching_mode = "slam";    %slam or mapmatching
Estimator.ndt.mapname = "floor10_2d_1.mat";     %mapmatchingの時に使う固定マップ※中身はfixedSeg(PointCloud)である必要がある

%マップデータ名避難
%exr_0208
%exroom_0209_1
% exroom_0213_1
% floor10_2d
% floor10_2d_1
end