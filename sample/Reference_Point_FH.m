function Reference_Point_FH(agent)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
Reference.type=["PointReference_FH"];
Reference.name=["point"];
for i = 1:length(agent)
    Reference.param=[];
    agent(i).set_reference(Reference);
end
end
