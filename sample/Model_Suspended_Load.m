function Model = Model_Suspended_Load(dt,initial,id,agent)
arguments
  dt
  initial
  id
  agent = ""
end
Model.id = id;
Model.name="load"; % print name
Model.type="Suspended_Load_Model"; % model name

%Setting.projection = @(x)[x(1:18);x(19:21)/norm(x(19:21));x(22:24)-dot(x(19:21)/norm(x(19:21)),x(22:24))*x(19:21)/norm(x(19:21))];
if strcmp(agent ,"plant")
  Setting.method = get_model_name("Load"); % KF未実装
  Setting.dim=[25,4,16];
  Setting.num_list = [3,4,3,3,3,3,3,3];
else
  Setting.method = get_model_name("Load_HL"); % model dynamicsの実体名
  Setting.dim=[24,4,21];
  Setting.num_list = [3,3,3,3,3,3,3,3];
end
Setting.method%デバッグ用なのでいらなくなったら削除
Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL"];
Setting.initial = initial;
Setting.initial.vL = [0;0;0];
Setting.initial.pT = [0;0;-1];
Setting.initial.wL = [0;0;0];
Setting.dt = dt;
Setting.param = agent.parameter.get; % モデルの物理パラメータ設定
Setting.initial.pL = Setting.initial.p+agent.parameter.cableL*Setting.initial.pT;%+[Setting.param(17);Setting.param(18);-Setting.param(19)];%22~24

Model.param = Setting;
Model.parameter_name = ["m","Lx","Ly", "lx", "ly", "lz", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4", "rotor_r","Length","mL", "cableL"];
end

