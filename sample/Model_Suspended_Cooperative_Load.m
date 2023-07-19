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
if contains(type,"eul")
  Setting.dim=[12*(N+1),4*N,5 + 8*N];
  Setting.method = get_model_name("Cooperative_Load_eul",N); % model dynamicsの実体名
  Setting.num_list = [3,3,3,3,3*N,3*N,3*N,3*N];
  %Setting.projection = @(x) [x(1:12);x(13:15)/vecnorm(x(13:15));x(16:end)];
else
  Setting.dim=[13*(N+1),4*N,42];
  Setting.method = get_model_name("Cooperative_Load",N); % model dynamicsの実体名
  Setting.num_list = [3,4,3,3,3*N,3*N,4*N,3*N];
  Setting.projection = @(x) [x(1:3);x(4:7)/vecnorm(x(4:7));x(8:13);x(14:16)/vecnorm(x(14:16));x(17:19)/vecnorm(x(17:19));x(20:22)/vecnorm(x(20:22));x(23:31);x(32:35)/vecnorm(x(32:35));x(36:39)/vecnorm(x(36:39));x(40:43)/vecnorm(x(40:43));x(44:end)];
  %Setting.projection = @(x) [x(1:3);x(4:7)/vecnorm(x(4:7));x(8:13);x(14:16)/vecnorm(x(14:16));x(17:19)/vecnorm(x(17:19));x(20:22)/vecnorm(x(20:22));x(23:25)/vecnorm(x(23:25));x(26:37);x(38:41)/vecnorm(x(38:41));x(42:45)/vecnorm(x(42:45));x(46:49)/vecnorm(x(46:49));x(50:53)/vecnorm(x(50:53));x(54:end)];
end
if contains(type,"zup")
  Setting.method = "zup_"+Setting.method;
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
