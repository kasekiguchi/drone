function Reference = Reference_Time_Varying_Cooprative_Load(f_name,param)
% list: 1:N etc
% f_name : functin name
% reference property をReference classのインスタンス配列として定義
clear Reference
Reference.type=["TIME_VARYING_REFERENCE"];
Reference.name=["timeVarying"];
Reference.param={f_name,param,"HL"};
end