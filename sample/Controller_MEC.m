function Controller_MEC(agent)
%% controller class demo (1) : construct
% controller property ��Controller class�̃C���X�^���X�z��Ƃ��Ē�`
%Controller.type="DirectController";
Controller.type="MEC";
Controller.name="mec";
Controller.param={""};
for i = 1:length(agent)
    agent(i).set_controller(Controller);
end

end
