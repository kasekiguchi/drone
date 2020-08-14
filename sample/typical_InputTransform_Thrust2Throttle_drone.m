function typical_InputTransform_Thrust2Throttle_drone(agent,varargin)
% typical input transformation from thrust force to throttle level for
% drone Prop. input
for i = 1:length(agent)
    agent(i).input_transform=[];
end
u_trans_param.type="Thrust2Throttle_drone";
u_trans_param.name="t2t";
u_trans_param.param.gain = [3*180/pi;3*180/pi;180/pi;50];%[500/400*180/pi;0];
u_trans_param.param.th_offset = 1021;
u_trans_param.param.roll_offset = 1101;
u_trans_param.param.pitch_offset = 1101;
u_trans_param.param.yaw_offset = 1101;
for i = 1:length(agent)
    agent(i).set_input_transform(u_trans_param); 
end
end
