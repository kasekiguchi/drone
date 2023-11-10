function Model= Model_Three_Vehicle(dt,initial,id)
% ノンホロ車両のモデル
arguments
  dt
  initial
  id
end
Model.type="THREE_STATE_VEHICLE_MODEL"; % class name
Model.name="vehicle"; % print name
Model.id = id;
Setting.dt = dt;
Setting.method = "three_state_vehicle_model"; % model dynamicsの実体名
Setting.dim = [6,2,1];
Setting.state_list = ["p","q"]; % [x;y;z;roll;pitch;yaw];
Setting.num_list = [3,3];


Setting.initial = initial;%struct('p',[0;0;0],'v',[0;0;0]);
Model.parameter_name = [];
Model.param = Setting;
end
