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

Setting.method = get_model_name("Load_HL"); % model dynamicsの実体名
Setting.dim=[24,4,21];
Setting.num_list = [3,3,3,3,3,3,3,3];
% if ~isempty(agent.plant)
% Setting.method = get_model_name("Load_ex_ey_ez"); % model dynamicsの実体名
% Setting.dim=[24,4,21];
% Setting.num_list = [3,3,3,3,3,3,3,3];
% end

Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL"];
Setting.initial = initial;
if ~isfield(Setting.initial,"pT")
    Setting.initial.pT = [0;0;-1];
    Setting.initial.pL = Setting.initial.p+agent.parameter.cableL*Setting.initial.pT;%+[Setting.param(17);Setting.param(18);-Setting.param(19)];%22~24
end
Setting.initial.vL = [0;0;0];
Setting.initial.wL = [0;0;0];
Setting.dt = dt;
Setting.param = agent.parameter.get; % モデルの物理パラメータ設定

if ~isempty(agent.plant) && isEstLoadMass
  if isEstLoadMass == 1
      Model.name="load_mL_HL"; % print name
      Setting.method = get_model_name("Load_mL_HL"); % model dynamicsの実体名
      Setting.dim=[25,4,21];
      Setting.num_list = [3,3,3,3,3,3,3,3,1];
      Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","mL"];%paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
      Setting.initial.mL = agent.parameter.loadmass*0+0.1*0;
  else
      Model.name="load_mL_fdst_HL"; % print name
      Setting.method = get_model_name("Load_mL_fdst_HL"); % model dynamicsの実体名
      Setting.dim=[26,4,21];
      Setting.num_list = [3,3,3,3,3,3,3,3,1,1];
      Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","mL","fdst"];%paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
      Setting.initial.mL = agent.parameter.loadmass*0+0;
  end
end

Model.param = Setting;
Model.parameter_name = ["m","Lx","Ly", "lx", "ly", "lz", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4", "rotor_r","Length","mL", "cableL","ex","ey","ez"];
end