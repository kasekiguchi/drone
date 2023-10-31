function Reference_Time_Varying_With_Load(agent,f_name,param)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
Reference.type=["TimeVaryingReferenceE"];
Reference.name=["timeVarying"];
Reference.param={{f_name,param,"HL"}};
for i = 1:length(agent)
    agent(i).set_reference(Reference);
end
end
