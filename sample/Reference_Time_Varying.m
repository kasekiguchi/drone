function typical_Reference_Time_Varying(list,agent,f_name,param)
% list: 1:N etc
% f_name : functin name
% reference property ��Reference class�̃C���X�^���X�z��Ƃ��Ē�`
clear Reference
Reference.type=["TimeVaryingReference"];
Reference.name=["timeVarying"];
Reference.param={f_name,param,"HL"};
for i = list
    agent(i).set_reference(Reference);
end
end
