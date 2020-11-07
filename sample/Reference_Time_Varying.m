function Reference_Time_Varying(list,agent,f_name,param)
% list: 1:N etc
% f_name : functin name
% reference property をReference classのインスタンス配列として定義
clear Reference
Reference.type=["TimeVaryingReference"];
Reference.name=["timeVarying"];
Reference.param={f_name,param,"HL"};
for i = list
    agent(i).set_reference(Reference);
end
end
