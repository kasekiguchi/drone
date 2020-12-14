function Reference = Reference_Time_Varying(f_name,param)
% list: 1:N etc
% f_name : functin name
% reference property をReference classのインスタンス配列として定義
clear Reference
Reference.type=["TimeVaryingReference"];
Reference.name=["timeVarying"];
Reference.param={f_name,param,"HL"};
end
