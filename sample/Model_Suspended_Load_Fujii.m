function Model = Model_Suspended_Load_Fujii(dt,initial,id)
arguments
  dt
  initial
  id = 0
end
type="Suspended_Load_Fujii"; % model name
name="Suspended_Load_Fujii"; % print name
Setting.projection = @(x)[x(1:18);x(19:21)/norm(x(19:21));x(22:24)-dot(x(19:21)/norm(x(19:21)),x(22:24))*x(19:21)/norm(x(19:21))];
Setting.dim=[24,4,19];
Setting.method = get_model_name("Load_Euler"); % model dynamicsの実体名
Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL"];
Setting.initial = initial; %struct('p',[0;0;0],'q',[1;0;0;0],'v',[0;0;0],'w',[0;0;0],"pL",[0;0;0],"vL",[0;0;0],"pT",[0;0;-1],"wL",[0;0;0]);
Setting.initial.pL = [0;0;0];
Setting.initial.vL = [0;0;0];
Setting.initial.pT = [0;0;-1];
Setting.initial.wL = [0;0;0];
%Setting.initial.pL = Setting.initial.p+getParameter_withload("L")*Setting.initial.pT;
% Setting.initial.pL = Setting.initial.p+0.5*Setting.initial.pT;
Setting.num_list = [3,3,3,3,3,3,3,3];
% Setting.type="compact"; % unit quaternionr
Setting.dt = dt;
Setting.param = getParameter_withload_Fujii; % モデルの物理パラメータ設定
Setting.initial.pL = Setting.initial.p+Setting.param(16)*Setting.initial.pT+[Setting.param(17);Setting.param(18);-Setting.param(19)];

if strcmp(type,"plant")
        Setting.param = getParameter_withload("Plant"); % モデルの物理パラメータ設定
end
% Model = {"type",type,"name",name,"param",Setting,"id",id};
Model.id = id;
Model.type="with_load_model_Fujii"; % model name
Model.name = "Suspended_Load_Model_Fujii";
Model.param = Setting;
Model.parameter_name =  ["g","m0","J0","rho","li","mi","Ji"];
end