function Model = Model_Suspended_Load_parameter_estimation(dt,initial,id,param)
arguments
  dt
  initial
  id
  param
end
Model.id = id;
Model.type="Suspended_Load_Model"; % model name
Model.name="load_parameter_estimation"; % print name_parameter_estimation
Setting.projection = @(x)[x(1:18);x(19:21)/norm(x(19:21));x(22:24)-dot(x(19:21)/norm(x(19:21)),x(22:24))*x(19:21)/norm(x(19:21));x(25:27)];
Setting.dim=[27,4,16];
Setting.input_channel = ["f","M"];
Setting.method = get_model_name("Load_parameter_estimation"); % model dynamicsの実体名_parameter_estimation
Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","e"];
Setting.initial = initial; 
P = param;
Setting.initial.vL = [0;0;0];
Setting.initial.pT = [0;0;-1];
Setting.initial.wL = [0;0;0];
Setting.initial.e = [P.ex;P.ey;P.ez];
Setting.initial.pL = initial.p+Setting.initial.pT*P.cableL;
Setting.num_list = [3,3,3,3,3,3,3,3,3];
Setting.dt = dt;
Model.param = Setting;
Model.parameter_name = ["mass","Length","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","loadmass","cableL"];
end