function Model = Model_PestBirds(id,dt,type,initial,varargin)
% 害鳥用のモデル
% 引数はエージェント番号，サンプリング時間，モデルかプラントか，初期値
% 返し値はモデルの型や名前，次元数などの情報
%% model class demo : quaternion model with 7 states
if ~isempty(varargin)
    Setting = varargin{1};
end
Model.type="PestBirds_Model"; % class name
%Model.name="euler"; % print name
Setting.param.A = eye(3);
Setting.dim=[3,2,0];
Setting.input_channel = ["p","q"];
Setting.method = get_model_name("PestBirds"); % model dynamicsの実体名
Setting.state_list =  ["p","q"];
Setting.initial = initial;
Setting.num_list = [3,4];
Setting.dt = dt;
if strcmp(type,"plant")
        Model.id = id;
%         Setting.initial.p = [0;0;0];
%         Setting.param = getParameter("Plant"); % モデルの物理パラメータ設定
        Setting.param.K = 1;
        Model.param=Setting;
%         assignin('base',"Plant",Model);
%         evalin('base',"agent(Plant.id) = Drone(Plant)");
else
%         Setting.param = getParameter(); % モデルの物理パラメータ設定
        Setting.param.K = 0.1;
        Model.param=Setting;
%         assignin('base',"Model",Model);
%         model_set_str=strcat("agent(",string(i),").set_model(Model)");
%         evalin('base',model_set_str);
end