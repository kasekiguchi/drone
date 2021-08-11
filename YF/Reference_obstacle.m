function Reference = Reference_obstacle(~,param)
%% reference class demo
% reference property をReference classのインスタンス配列として定義
clear Referenceh
Reference.type=["obstacle_input"];
Reference.name=["obstacle"];
id = param{2};
Reference.param={id,param{1}};

end
