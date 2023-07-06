function Reference = Reference_Time_Varying_Cooperative_Load(f_name,param)
% list: 1:N etc
% f_name : functin name
% reference property をReference classのインスタンス配列として定義
clear Reference
Reference.type=["TIME_VARYING_REFERENCE_COOPERATIVE"];
Reference.name=["gen_ref_saddle"];
Reference.param={f_name,param,"HL"};
end