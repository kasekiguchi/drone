function Model = Model_Suspended_Load(dt,initial,id,agent,isEstLoadMass)
arguments
  dt
  initial
  id
  agent = ""
  isEstLoadMass = 0 %牽引物質量を推定するか
end
Model.id = id;
Model.name="load"; % print name
Model.type="Suspended_Load_Model"; % model name

%Setting.projection = @(x)[x(1:18);x(19:21)/norm(x(19:21));x(22:24)-dot(x(19:21)/norm(x(19:21)),x(22:24))*x(19:21)/norm(x(19:21))];
% if ~strcmp(agent ,"plant")
% if isempty(agent.plant)
%   Setting.method = get_model_name("Load_HL"); % KF未実装
%   Setting.dim=[25,4,16];
%   Setting.num_list = [3,4,3,3,3,3,3,3];
% else
%   Setting.method = get_model_name("Load_HL"); % model dynamicsの実体名
%   Setting.dim=[24,4,21];
%   Setting.num_list = [3,3,3,3,3,3,3,3];
% end
Setting.method = get_model_name("Load_HL"); % model dynamicsの実体名
Setting.dim=[24,4,21];
Setting.num_list = [3,3,3,3,3,3,3,3];

Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL"];
Setting.initial = initial;
Setting.initial.vL = [0;0;0];
Setting.initial.pT = [0;0;-1];
Setting.initial.wL = [0;0;0];
Setting.dt = dt;
Setting.param = agent.parameter.get; % モデルの物理パラメータ設定
Setting.initial.pL = Setting.initial.p+agent.parameter.cableL*Setting.initial.pT;%+[Setting.param(17);Setting.param(18);-Setting.param(19)];%22~24

if ~isempty(agent.plant) && isEstLoadMass
  Model.name="load_mL_HL"; % print name
  Setting.method = get_model_name("Load_mL_HL"); % model dynamicsの実体名
  Setting.dim=[25,4,21];
  Setting.num_list = [3,3,3,3,3,3,3,3,1];
  Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","mL"];%paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
  Setting.initial.mL = agent.parameter.loadmass*0+0.0;
end

Model.param = Setting;
Model.parameter_name = ["m","Lx","Ly", "lx", "ly", "lz", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4", "rotor_r","Length","mL", "cableL"];
end

