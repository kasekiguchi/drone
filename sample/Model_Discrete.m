function [Model,Param]= Model_Discrete(dt,initial,id)
% 質量１の質点モデル：力入力
arguments
  dt
  initial
  id
end
Model.type="DISCRETE_MODEL"; % class name
Model.name="discrete"; % print name
Model.id = id;
Setting.dt = dt;
Setting.method = get_model_name("Discrete"); % model dynamicsの実体名
%% 質点モデル
dsys = c2d(ss([zeros(3) eye(3);zeros(3,6)],[zeros(3);eye(3)],eye(6),zeros(6,3)),dt);
Setting.dim = [6,3,3];
Setting.state_list = ["p","v"];
Setting.num_list = [3,3];
Setting.input_channel = ["v"];
%% 質点モデル
dsys = c2d(ss([zeros(3) eye(3) zeros(3);zeros(6,9)],[zeros(3,6);eye(3) zeros(3);zeros(3) eye(3)],eye(9),zeros(9,6)),dt);
Setting.dim = [9,6,2];
Setting.state_list = ["p","v","q"];
Setting.num_list = [3,3,3];
Setting.input_channel = ["v","q"];

%% 共通設定
Setting.param.A = dsys.A;
Setting.param.B =dsys.B;
Setting.param.C =dsys.C;
Setting.initial = initial;%struct('p',[0;0;0],'v',[0;0;0]);
Model.param = Setting;
Model.parameter_name = ["A","B"];
Param = POINT_MASS_PARAM("point","A",dsys.A,"B",dsys.B,"C",dsys.C);
end
