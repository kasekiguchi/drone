clear all;
clc;
test_1 = ros2node("/test_1",30);
test_2 = ros2node("/test_2",30);
pause(3);
subscan = ros2subscriber(test_1,"/scan");
% subsensor = ros2subscriber(test_2,"/sensor_state")
% global pos
% global orient
% pause(3)
% disp(pos)
% disp(orient)
% scandata = receive(subscan,2)
% ros2("node","list","DomainID",30);
% ros2("topic","list","DomainID",30);
Pubcmd_vel = ros2publisher(test_2,"/cmd_vel","geometry_msgs/Twist");
cmd_msg = ros2message("geometry_msgs/Twist");
cmd_msg.linear.x = 0.1; 
cmd_msg.angular.z = 0.1;
send(Pubcmd_vel,cmd_msg);
pasue(5)
cmd_msg.linear.x = -0.1; 
cmd_msg.angular.z = -0.1;
send(Pubcmd_vel,cmd_msg);
run(ros1_clear);