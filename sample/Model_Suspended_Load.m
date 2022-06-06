function Model = Model_Suspended_Load(dt,initial,id)
arguments
  dt
  initial
  id = 0
end
Model.id = id;
Model.type="Suspended_Load_Model"; % model name
Model.name="load"; % print name
Setting.projection = @(x)[x(1:18);x(19:21)/norm(x(19:21));x(22:24)-dot(x(19:21)/norm(x(19:21)),x(22:24))*x(19:21)/norm(x(19:21))];
Setting.dim=[24,4,19];
Setting.input_channel = ["f","M"];
Setting.method = get_model_name("Load"); % model dynamicsの実体名
Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL"];
Setting.initial = initial; %struct('p',[0;0;0],'q',[1;0;0;0],'v',[0;0;0],'w',[0;0;0],"pL",[0;0;0],"vL",[0;0;0],"pT",[0;0;-1],"wL",[0;0;0]);
Setting.initial.pL = initial.p;
Setting.initial.vL = [0;0;0];
Setting.initial.pT = [0;0;-1];
Setting.initial.wL = [0;0;0];
Setting.num_list = [3,3,3,3,3,3,3,3];
Setting.dt = dt;
Model.param = Setting;
end
