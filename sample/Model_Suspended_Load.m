function Model = Model_Suspended_Load(dt,initial,id,agent,isEstLoadMass)
arguments
  dt
  initial
  id
  agent = ""
  isEstLoadMass = 0 %牽引物質量を推定するか
end         
Model.id                = id;                                       %牽引物番号
Model.name              = "load"; % print name          
Model.type              = "Suspended_Load_Model";                   % model name
%plantのモデル
Setting.method          = get_model_name("Load_HL");                % model dynamicsの実体名(状態方程式の関数ファイルを設定)
Setting.dim             = [24,4,21];                                %それぞれ状態、入力、物理パラメータの数
Setting.num_list        = [3,3,3,3,3,3,3,3];                        % 状態のベクトルの次元(それぞれ3次元)
Setting.state_list      = ["p","q","v","w","pL","vL","pT","wL"];    % 状態の種類
Setting.initial         = initial;                                  %状態の初期値
% 紐の方向ベクトルの初期値が定義されていない場合
if ~isfield(Setting.initial,"p")
    Setting.initial.p   = Setting.initial.pL - agent.parameter.cableL*Setting.initial.pT;
    Setting.initial.v   = [0; 0; 0];
end
Setting.initial.vL      = [0;0;0];                                  % 牽引物速度exp用
Setting.initial.wL      = [0;0;0];                                  % 紐の角速度exp用
Setting.dt              = dt;                                       % 刻み時間
Setting.param           = agent.parameter.get;                      % モデルの物理パラメータ設定

% EKFで使うモデルがplantと異なる場合の設定isEstLoadMassの値とmodelnameによって変更
if ~isempty(agent.plant) && isEstLoadMass
      modelName = "Load_mL_HL";
      % modelName = "Load_mL_cableL_HL";
      % modelName = "Load_mL_fdst_HL";
      modelName = "Load_mL_dstxy_HL";
      % modelName = "Load_mL_dstxyz_HL";
      switch modelName
          % 牽引物質量推定
          case "Load_mL_HL"
              Model.name              = modelName;                                          % print name
              Setting.method          = get_model_name(Model.name);                         % model dynamicsの実体名
              Setting.dim             = [25,4,21];      
              Setting.num_list        = [3,3,3,3,3,3,3,3,1];        
              Setting.state_list      = ["p","q","v","w","pL","vL","pT","wL","mL"];         % paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL      = agent.parameter.loadmass*0+0;                       % 初期牽引物質量
          % 牽引物質量と紐の長さを推定       
          case "Load_mL_cableL_HL"      
              Model.name              = modelName;                                          % print name
              Setting.method          = get_model_name(Model.name);                         % model dynamicsの実体名
              Setting.dim             = [26,4,21];
              Setting.num_list        = [3,3,3,3,3,3,3,3,1,1];
              Setting.state_list      = ["p","q","v","w","pL","vL","pT","wL","mL","cableL"];% paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL      = agent.parameter.loadmass*0+0;                       % 初期牽引物質量
              Setting.initial.cableL  = agent.parameter.cableL;                             % 初期紐の長さ
          % 牽引物質量と推力外乱%墜落する．loadmassも推定している為干渉するのかもしれない       
          case "Load_mL_fdst_HL"        
              Model.name              = modelName; % print name     
              Setting.method          = get_model_name(Model.name);                         % model dynamicsの実体名
              Setting.dim             = [26,4,21];      
              Setting.num_list        = [3,3,3,3,3,3,3,3,1,1];
              Setting.state_list      = ["p","q","v","w","pL","vL","pT","wL","mL","fdst"];  % paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL      = agent.parameter.loadmass*0+0.5;                     % 初期牽引物質量
              Setting.initial.fdst    = 0;                                                  % 推力外乱初期値
          % 牽引物にかかるx,y方向の外乱推定
          case "Load_mL_dstxy_HL"
              % 外乱推定可能
              %xyの外乱を定常外乱として考慮しているモデルを階層型線形化すればいいかも
              Model.name              = modelName;                                          % print name
              Setting.method          = get_model_name(Model.name);                         % model dynamicsの実体名
              Setting.dim             = [27,4,21];
              Setting.num_list        = [3,3,3,3,3,3,3,3,1,2];
              Setting.state_list      = ["p","q","v","w","pL","vL","pT","wL","mL","dst"];   % paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL      = agent.parameter.loadmass*0+0;%初期牽引物質量
              Setting.initial.dst     = [0;0];%外乱初期値
          % 牽引物にかかるx,y,z方向の外乱推定
          case "Load_mL_dstxyz_HL"
              %z方向の外乱推定を入れた場合は墜落する．loadmassも推定している為干渉するのかもしれない
              Model.name              = modelName;                                          % print name
              Setting.method          = get_model_name(Model.name);                         % model dynamicsの実体名
              Setting.dim             = [28,4,21];
              Setting.num_list        = [3,3,3,3,3,3,3,3,1,3];
              Setting.state_list      = ["p","q","v","w","pL","vL","pT","wL","mL","dst"];   % paramのmLはモデルではmLDummyの変数に入れられモデルには使われない
              Setting.initial.mL      = agent.parameter.loadmass*0+0.5;                     % 初期牽引物質量
              Setting.initial.dst     = [0;0;0];                                            % 外乱初期値
      end
end

Model.param = Setting;
Model.parameter_name = ["m","Lx","Ly", "lx", "ly", "lz", "jx", "jy", "jz", "gravity", "km1", "km2", "km3", "km4", "k1", "k2", "k3", "k4", "rotor_r","mL", "cableL","ex","ey","ez"];
end