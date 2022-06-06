function Model = Model_Suspended_Load(dt,initial,id,param)
arguments
  dt
  initial
  id
  param
end
Model.id = id;
Model.type="Suspended_Load_Model"; % model name
Model.name="load"; % print name
Setting.projection = @(x)[x(1:18);x(19:21)/norm(x(19:21));x(22:24)-dot(x(19:21)/norm(x(19:21)),x(22:24))*x(19:21)/norm(x(19:21))];
Setting.dim=[24,4,19];
Setting.input_channel = ["f","M"];
Setting.method = get_model_name("Load"); % model dynamicsの実体名
Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL"];
Setting.initial = initial; 
P = param;
Setting.initial.vL = [0;0;0];
Setting.initial.pT = [0;0;-1];
Setting.initial.wL = [0;0;0];
Setting.initial.pL = initial.p+[P.ex;P.ey;-P.ez]+Setting.initial.pT*P.cableL;
Setting.num_list = [3,3,3,3,3,3,3,3];
Setting.dt = dt;
Model.param = Setting;
Model.parameter_name = ["mass","Length","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","loadmass","cableL","ex","ey","ez"];
end