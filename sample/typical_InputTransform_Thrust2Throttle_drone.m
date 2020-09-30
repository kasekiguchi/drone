function typical_InputTransform_Thrust2Throttle_drone(agent,varargin)
% typical input transformation from thrust force to throttle level for
% drone Prop. input
for i = 1:length(agent)
    agent(i).input_transform=[];
end
u_trans_param.type="Thrust2Throttle_drone";
u_trans_param.name="t2t";
u_trans_param.param.gain =[700;700;10;450];% %[100;100;50;0];%[1*180/pi;0.5*180/pi;0*180/pi;10];%[500/400*180/pi;0]; % to takashiba ここのゲインいじってみて
u_trans_param.param.th_offset = 1000; % 推力が足りない場合ここ変えるのもあり、大きくしすぎると危険
%u_trans_param.param.th_offset = 1021;
% u_trans_param.param.roll_offset = 1500;
% u_trans_param.param.pitch_offset = 1200;
% u_trans_param.param.yaw_offset = 1500;
u_trans_param.param.roll_offset = 1104;
u_trans_param.param.pitch_offset = 1104;
u_trans_param.param.yaw_offset = 1104;
for i = 1:length(agent)
    agent(i).set_input_transform(u_trans_param); 
end
end
