function InputTransform_REFtoHL_drone(agent,varargin)
%% Input transformer
for i = 1:length(agent)
    agent(i).input_transform=[];
end
dt =agent.model.dt;
u_trans_param.type="REFtoHL_drone";
u_trans_param.name="p2hl";
u_trans_param.param.P=getParameter();
u_trans_param.param.F1=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
u_trans_param.param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
u_trans_param.param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
u_trans_param.param.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
u_trans_param.param.dt = dt;
for i = 1:length(agent)
    agent(i).set_input_transform(u_trans_param)
end
end
