function Model = Model_Quat13(dt,initial,id)
% model class demo : quaternion model with 13 states
arguments
  dt
  initial
  id
end
Model.id = id;
Model.type="Quat13_Model"; % model name
Model.name="quat"; % print name
Setting.dim=[13,4,17];
Setting.input_channel = ["v","w"];
Setting.method = get_model_name("Quat 13"); % model dynamicsの実体名
Setting.state_list =  ["q","p","v","w"];
Setting.initial = initial;
Setting.num_list = [4,3,3,3];
Setting.dt = dt;
Model.param = Setting;
end