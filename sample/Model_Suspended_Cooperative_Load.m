function Model = Model_Suspended_Cooperative_Load(dt,initial,id)
arguments
  dt
  initial
  id = 0
end
Model.id = id;
type="Suspended_Load_Model"; % model name
name="Cooperative_Load"; % print name
Setting.dim=[65,16,8];
Setting.input_channel = ["f","M"];
Setting.method = get_model_name("Load"); % model dynamicsの実体名
Setting.state_list =  ["dx0","dr0","ddx0","do0","dqi","dwi","dri","doi"];
Setting.initial = initial; 
Setting.num_list = [3,4,3,3,12,12,16,12];
% Setting.type="compact"; % unit quaternionr
Setting.dt = dt;
Model.param = Setting;
% [g, m0, j01, j02, j03, rho1_1, rho1_2, rho1_3, rho2_1, rho2_2, rho2_3, rho3_1, rho3_2, rho3_3, rho4_1, rho4_2, rho4_3, li1, li2, li3, li4, mi1, mi2, mi3, mi4, ji1_1, ji1_2, ji1_3, ji2_1, ji2_2, ji2_3, ji3_1, ji3_2, ji3_3, ji4_1, ji4_2, ji4_3]
Model.parameter_name = ["g","m0","j01","j02","j03","rho1_1","rho1_2","rho1_3","rho2_1","rho2_2","rho2_3","rho3_1","rho3_2","rho3_3","rho4_1","rho4_2","rho4_3","li1","li2","li3","li4","mi1","mi2","mi3","mi4","ji1_1","ji1_2","ji1_3","ji2_1","ji2_2","ji2_3","ji3_1","ji3_2","ji3_3","ji4_1","ji4_2","ji4_3"];
end
