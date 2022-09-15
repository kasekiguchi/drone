clear all;
clc;
%% 
% SLAM data use 
test_1 = ros2node("/test_1",30);
test_2 = ros2node("/test_2",30);
%%
pause(3);
Pubcmd_vel = ros2publisher(test_2,"/cmd_vel","geometry_msgs/Twist");
cmd_msg = ros2message("geometry_msgs/Twist");
cmd_msg.linear.x = 0.00;
cmd_msg.angular.z = 0.00;
send(Pubcmd_vel,cmd_msg);


% cmd_msg.linear.x = 0.0;
% cmd_msg.angular.z = 0.0;
% send(Pubcmd_vel,cmd_msg);
% run("ros1_clear");