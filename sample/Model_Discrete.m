function [Model,Param]= Model_Discrete(dt,initial,id,type,agent)
% Point mass model
arguments
  dt
  initial
  id
  type
  agent = []
end
Model.type = type;
Model.name = "discrete";
Model.id = id;
Setting.dt = dt;
Setting.method = get_model_name("Discrete"); % model dynamicsの実体名
switch type
  %% 質点モデル
  case "PV" % point-mass force-input model
    dsys = c2d(ss([zeros(3) eye(3);zeros(3,6)],[zeros(3);eye(3)],eye(6),zeros(6,3)),dt);
    Setting.dim = [6,3,3];
    Setting.state_list = ["p","v"];
    Setting.num_list = [3,3];
    %% 質点モデル
  case "PVQ" % point-mass (force,angular-vel)-input model
    dsys = c2d(ss([zeros(3) eye(3) zeros(3);zeros(6,9)],[zeros(3,6);eye(3) zeros(3);zeros(3) eye(3)],eye(9),zeros(9,6)),dt);
    Setting.dim = [9,6,2];
    Setting.state_list = ["p","v","q"];
    Setting.num_list = [3,3,3];
  case "P" % next position = input model
    dsys.A = [zeros(3)];
    dsys.B = eye(3); % x.p = u; 次の時刻にu の位置に行くモデル
    dsys.C = eye(3);
    Setting.dim = [3, 3, 0];
    Setting.state_list = ["p"];
    Setting.num_list = [3];
  case "FREE"
    dsys.A = agent.parameter.A;
    dsys.B = agent.parameter.B;
    dsys.C = agent.parameter.C;
    fn = string(fieldnames(initial))';
    nlist = [];
    for i = fn
      nlist = [nlist, length(initial.(i))];
    end
    Setting.dim = [size(dsys.A,1),size(dsys.B,2),0];
    Setting.state_list = fn;
    Setting.num_list = nlist;    
end
%% 共通設定
Setting.param.A = dsys.A;
Setting.param.B =dsys.B;
Setting.param.C =dsys.C;
Setting.initial = initial;%struct('p',[0;0;0],'v',[0;0;0]);
Model.param = Setting;
Model.parameter_name = ["A","B"];
Param = POINT_MASS_PARAM("point","A",dsys.A,"B",dsys.B,"C",dsys.C);
end
