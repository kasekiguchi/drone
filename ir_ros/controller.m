clear all;
clc;
Cmd_vel = ros2node("/cmd",30);
Cmd_vel_pub = ros2publisher(Cmd_vel,"cmd_vel");
pause(3);
Cmd_vel_msg = ros2message("geometry_msgs/Twist");
Cmd_vel_msg.linear.x = 0.0;
Cmd_vel_msg.angular.z = 0.0;
send(Cmd_vel_pub,Cmd_vel_msg);
while(1)
    prompt = "w = straight,a = left turn, d = right turn,x = back,q = stop,s = break";
    k = input(prompt,"s"); 
    if k == 'w'
        Cmd_vel_msg.linear.x = Cmd_vel_msg.linear.x + 0.01;
        send(Cmd_vel_pub,Cmd_vel_msg);
    elseif k == 'a'
        Cmd_vel_msg.angular.z = Cmd_vel_msg.angular.z + 0.1;
        send(Cmd_vel_pub,Cmd_vel_msg);
    elseif k == 'd'
        Cmd_vel_msg.angular.z = Cmd_vel_msg.angular.z - 0.1;
        send(Cmd_vel_pub,Cmd_vel_msg);
    elseif k == 'x'
        Cmd_vel_msg.linear.x = Cmd_vel_msg.linear.x  - 0.01;
        send(Cmd_vel_pub,Cmd_vel_msg);
    elseif k == 's'
        Cmd_vel_msg.linear.x = 0.0; 
        Cmd_vel_msg.angular.z = 0.0;
        send(Cmd_vel_pub,Cmd_vel_msg);
        break;
    elseif k == 'q' 
        Cmd_vel_msg.linear.x = 0.0; 
        Cmd_vel_msg.angular.z = 0.0;
        send(Cmd_vel_pub,Cmd_vel_msg);
    end

    
    
end

clear Cmd_vel;
clear Cmd_vel_msg;