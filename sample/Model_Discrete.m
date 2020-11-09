function Model_Discrete(N,dt,type,initial,varargin)
% 質量１の質点モデル：力入力
if ~isempty(varargin)
    Setting = varargin{1};
end
Setting.dt = dt;
Model.type="Discrete_Model"; % class name
Model.name="discrete"; % print name
Setting.method = get_model_name("Discrete"); % model dynamicsの実体名
dsys = c2d(ss([zeros(3) eye(3);zeros(3,6)],[zeros(3);eye(3)],eye(6),zeros(6,3)),dt);
Setting.param.A = dsys.A;
Setting.param.B =dsys.B;
Setting.dim = [6,3,0];
Setting.initial = initial;%struct('p',[0;0;0],'v',[0;0;0]);
Setting.state_list = ["p","v"];
Setting.num_list = [3,3];
Setting.input_channel = ["v"];
%Setting.param.A = [zeros(3)];
%Setting.param.B =eye(3);% x.p = u; 次の時刻にu の位置に行くモデル
%Setting.dim = [3,3,0];
% Setting.initial = struct('p',[0;0;0]);
% Setting.state_list = ["p"];
% Setting.num_list = [3];
% Setting.input_channel = ["p"];
if strcmp(type,"plant")
    for i = 1:N
    Model.id = i;
   %Setting.initial.p = 10*rand(3,1)+[40;20;0];
    Model.param=Setting;
    assignin('base',"Plant",Model);
    evalin('base',"agent(Plant.id) = Drone(Plant)");
    end
else
for i = 1:N
    Model.name=["discrete"];
    Model.param=Setting;
    assignin('base',"Model",Model);
    model_set_str=strcat("agent(",string(i),").set_model(Model)");
    evalin('base',model_set_str);
end

end
