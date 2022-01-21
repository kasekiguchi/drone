function Model = Model_EulerAngle(dt,plant_or_model,initial,id)
% model class demo : quaternion model with 13 states
arguments
  dt
  plant_or_model
  initial
  id
end
type="EulerAngle_Model"; % class name
name="euler"; % print name
Setting.dim=[12,4,10];
Setting.input_channel = ["v","w"];
Setting.method = get_model_name("RPY 12"); % model dynamicsの実体名
Setting.state_list =  ["p","q","v","w"];
Setting.initial = initial;% struct('p',[0;0;0],'q',[0;0;0],'v',[0;0;0],'w',[0;0;0]);
Setting.num_list = [3,3,3,3];
Setting.dt = dt;
if strcmp(plant_or_model,"plant")
  Setting.param = getParameter("Plant"); % モデルの物理パラメータ設定
else
  Setting.param = getParameter(); % モデルの物理パラメータ設定
end
Model = {"type",type,"name",name,"param",Setting,"id",id};
end
