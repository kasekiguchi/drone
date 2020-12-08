function Controller_MEC()
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
%Controller.type="DirectController";
Controller.type="MEC";
Controller.name="mec";
Controller.param={""};
for i = 1:length(agent)
    agent(i).set_controller(Controller);
end

end
