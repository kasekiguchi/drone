function Reference_Time_Varying_Suspended_Load(list,agent,f_name,param)
% list: 1:N etc
% f_name : functin name
% reference property ��Reference class�̃C���X�^���X�z��Ƃ��Ē�`
clear Reference
Reference.type=["TimeVaryingReferenceSuspendedLoad"];
Reference.name=["tvLoad"];
Reference.param={f_name,param,"HL"};
for i = list
    agent(i).set_reference(Reference);
end
end
