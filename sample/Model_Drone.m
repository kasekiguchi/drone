function Model = Model_Drone(id,dt,type,initial,varargin)
% 離散モデルとは状態数が合わないため改めて害鳥追跡用に作成
% 引数はエージェント番号，サンプリング時間，モデルかプラントか，初期値
% 返し値はモデルの型や名前，次元数などの情報
%% model class demo : Discrete time model
% "Discrete";
if ~isempty(varargin)
    Setting = varargin{1};
end
Setting.dt = dt;
Setting.param.A =eye(3);
Setting.param.B = eye(3);
Model.type="Discrete_Model"; % class name
Model.name="tracebirds_drone"; % print name
Setting.dim = [3,0,0];
Setting.method = get_model_name("Discrete"); % model dynamicsの実体名
Setting.initial = initial;%struct('p',[0;0;0]);
Setting.state_list = ["p"];
Setting.num_list = [3];
Setting.input_channel = ["p"];
if strcmp(type,"plant")
        Model.id = id;
%         Setting.initial.p = 10*rand(3,1)+[40;20;0];
        Model.param=Setting;
%         assignin('base',"Plant",Model);
%         evalin('base',"agent(Plant.id) = Drone(Plant)");
else
%         Model.name=["dog"];
        Model.param=Setting;
%         assignin('base',"Model",Model);
%         model_set_str=strcat("agent(",string(i),").set_model(Model)");
%         evalin('base',model_set_str);      
end
