function typical_Reference_Point_FH(agent)
%% reference class demo
% reference property ��Reference class�̃C���X�^���X�z��Ƃ��Ē�`
clear Reference
%Reference.type="PointReference";
Reference.type=["PointReference_FH"];
Reference.name=["point"];
for i = 1:length(agent)
    Reference.param=[];
    agent(i).set_reference(Reference);
end
end
