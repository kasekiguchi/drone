function typical_InputTransform_Thrust2Throttle_drone(agent,varargin)
% typical input transformation from thrust force to throttle level for
% drone Prop. input
for i = 1:length(agent)
    agent(i).input_transform=[];
end
u_trans_param.type="Thrust2Throttle_drone";
u_trans_param.name="t2t";
u_trans_param.param.gain =[700;700;600;400];% gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400]
u_trans_param.param.th_offset = 900; % offset 3s[1021] 4s[900]
u_trans_param.param.roll_offset = 1104;
u_trans_param.param.pitch_offset = 1104;
u_trans_param.param.yaw_offset = 1104;
for i = 1:length(agent)
    agent(i).set_input_transform(u_trans_param); 
end
end
