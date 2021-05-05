function Reference = Reference_GlobalPlanning(EstInfo)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Reference
%Reference.type="PointReference";
Reference.type=["GlobalPlanning"];
Reference.name=["GlobalPlanning"];
EstName = EstInfo.name;
EstProp = string(properties(EstInfo.(EstName)));
FindIdx = contains(EstProp,'map');
MapInfo = EstInfo.(EstName).(EstProp(FindIdx));
%for i = 1:length(agent)
    Reference.param=[MapInfo];
   % agent(i).set_reference(Reference);
%end
end
