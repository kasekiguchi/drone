function Model = Model_Suspended_Cooperative_Load(dt,initial,id,N,type)
arguments
  dt
  initial
  id = 0
  N = 4
  type = "eul"
end
Model.id = id;
Model.type="Suspended_Cooperative_Load_Model"; % model name
% Setting.input_channel = ["f","M"];
if strcmp(type,"eul")
  Setting.dim=[12*(N+1),4*N,5 + 8*N];
  Setting.method = get_model_name("Cooperative_Load_eul",N); % model dynamicsの実体名
  Setting.num_list = [3,3,3,3,3*N,3*N,3*N,3*N];
else
  Setting.dim=[13*(N+1),4*N,42];
  Setting.method = get_model_name("Cooperative_Load",N); % model dynamicsの実体名
  Setting.num_list = [3,4,3,3,3*N,3*N,4*N,3*N];
end
Model.name=Setting.method; % print name
% x = [p0 Q0 v0 O0 qi wi Qi Oi]
Setting.state_list =  ["p","Q","v","O","qi","wi","Qi","Oi"];
Setting.qlist = ["Q","Qi"];
Setting.initial = initial;
% Setting.type="compact"; % unit quaternionr
Setting.dt = dt;
Model.param = Setting;
% P = [g m0 j0 rho li mi ji]
% [g, m0, j01, j02, j03, rho1_1, rho1_2, rho1_3, rho2_1, rho2_2, rho2_3, rho3_1, rho3_2, rho3_3, rho4_1, rho4_2, rho4_3, li1, li2, li3, li4, mi1, mi2, mi3, mi4, ji1_1, ji1_2, ji1_3, ji2_1, ji2_2, ji2_3, ji3_1, ji3_2, ji3_3, ji4_1, ji4_2, ji4_3]
%Model.parameter_name = ["g","m0","j01","j02","j03","rho1_1","rho1_2","rho1_3","rho2_1","rho2_2","rho2_3","rho3_1","rho3_2","rho3_3","rho4_1","rho4_2","rho4_3","li1","li2","li3","li4","mi1","mi2","mi3","mi4","ji1_1","ji1_2","ji1_3","ji2_1","ji2_2","ji2_3","ji3_1","ji3_2","ji3_3","ji4_1","ji4_2","ji4_3"];
Model.parameter_name =  ["g","m0","J0","rho","li","mi","Ji"];
end
