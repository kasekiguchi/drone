function Model= Model_Three_Vehicle(dt,initial,id)
% ノンホロ車両のモデル
arguments
  dt
  initial
  id
end
Model.type="THREE_STATE_VEHICLE_MODEL"; % class name
Model.name="three_vehicle"; % print name
Model.id = id;
Setting.dt = dt;
Setting.method = "three_state_vehicle_model"; % model dynamicsの実体名
%% 
dsys = c2d(ss([zeros(3) eye(3);zeros(3,6)],[zeros(3);eye(3)],eye(6),zeros(6,3)),dt);
Setting.dim = [6,2,1];
Setting.state_list = ["p","q"]; % [x;y;th];
Setting.num_list = [3,3];
Setting.input_channel = ["p","q"];

Setting.initial = initial;%struct('p',[0;0;0],'v',[0;0;0]);
Model.parameter_name = [];
Model.param = Setting;
end
