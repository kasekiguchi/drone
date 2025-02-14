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
      Model.name="Load_mL_HL"; % print name
      Setting.method = get_model_name(Model.name); % model dynamicsの実体名
      Setting.dim=[25,4,21];
      Setting.num_list = [3,3,3,3,3,3,3,3,1];
      Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","mL"];%paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
      Setting.initial.mL = agent.parameter.loadmass*0+0.1;
  else
      % modelName = "Load_mL_cableL_HL";
      % modelName = "Load_mL_fdst_HL";
      modelName = "Load_mL_dstxy_HL";
      % modelName = "Load_mL_dstxyz_HL";
      switch modelName
          case "Load_mL_cableL_HL"
              Model.name= modelName; % print name
              Setting.method = get_model_name(Model.name); % model dynamicsの実体名
              Setting.dim=[26,4,21];
              Setting.num_list = [3,3,3,3,3,3,3,3,1,1];
              Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","mL","cableL"];%paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL = agent.parameter.loadmass*0+0;%牽引物質量
              Setting.initial.cableL = agent.parameter.cableL;%紐の長さ
          case "Load_mL_fdst_HL"
            %墜落する．loadmassも推定している為干渉するのかもしれない
              Model.name=modelName; % print name
              Setting.method = get_model_name(Model.name); % model dynamicsの実体名
              Setting.dim=[26,4,21];
              Setting.num_list = [3,3,3,3,3,3,3,3,1,1];
              Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","mL","fdst"];%paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL = agent.parameter.loadmass*0+0.5;
              Setting.initial.fdst = 0;%推力外乱初期値
          case "Load_mL_dstxy_HL"
              % 外乱推定可能
              %xyの外乱を定常外乱として考慮しているモデルを階層型線形化すればいいかも
              Model.name=modelName; % print name
              Setting.method = get_model_name(Model.name); % model dynamicsの実体名
              Setting.dim=[27,4,21];
              Setting.num_list = [3,3,3,3,3,3,3,3,1,2];
              Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","mL","dst"];%paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL = agent.parameter.loadmass*0+0;
              Setting.initial.dst = [0;0];%推力外乱初期値
          case "Load_mL_dstxyz_HL"
              %z方向の外乱推定を入れた場合は墜落する．loadmassも推定している為干渉するのかもしれない
              Model.name= modelName; % print name
              Setting.method = get_model_name(Model.name); % model dynamicsの実体名
              Setting.dim=[28,4,21];
              Setting.num_list = [3,3,3,3,3,3,3,3,1,3];
              Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL","mL","dst"];%paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL = agent.parameter.loadmass*0+0.5;
              Setting.initial.dst = [0;0;0];%推力外乱初期値
      end
  end
end

Model.param = Setting;
Model.parameter_name = ["m","Lx","Ly", "lx", "ly", "lz", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4", "rotor_r","Length","mL", "cableL","ex","ey","ez"];
end