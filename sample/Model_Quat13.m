function Model = Model_Quat13(dt,plant_or_model,initial,id)
% model class demo : quaternion model with 13 states
arguments
  dt
  plant_or_model
  initial
  id
end
type="Quat13_Model"; % class name
name="quat"; % print name
Setting.dim=[13,4,10];
Setting.input_channel = ["v","w"];
Setting.method = get_model_name("Quat 13"); % model dynamicsの実体名
Setting.state_list =  ["q","p","v","w"];
Setting.initial = initial;
Setting.num_list = [4,3,3,3];
Setting.dt = dt;
if strcmp(plant_or_model,"plant")
  Setting.param = getParameter("Plant"); % モデルの物理パラメータ設定
else
  Setting.param = getParameter(); % モデルの物理パラメータ設定
end
Model = {"type",type,"name",name,"param",Setting,"id",id};
end