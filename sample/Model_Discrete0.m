function [Model,Param] = Model_Discrete0(dt, initial, id)
% 入力位置が次時刻の位置になるモデル
%% model class demo :
arguments
    dt
    initial
    id
end

Setting.dt = dt;
Model.type = "DISCRETE_MODEL"; % class name
Model.name = "discrete"; % print name
Setting.method = get_model_name("Discrete"); % model dynamicsの実体名
Setting.param.A = zeros(6);
Setting.param.B = eye(6); % x.p = u; 次の時刻にu の位置に行くモデル
Setting.dim = [6, 6, 0];
Setting.initial = initial; %struct('p', [0; 0; 0]);
Setting.state_list = ["p","q"];
Setting.num_list = [3,3];
Setting.input_channel = ["p","q"];

% if strcmp(type, "plant")
    Model.id = id;
    %Setting.initial.p = 10*rand(3,1)+[40;20;0];
    Model.param = Setting;
% else
%     Model.name = ["discrete"];
%     Model.param = Setting;
% end
% Model.parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","rotor_r"];
end