function ros=Connector_ROS(param)
    % Connector_ROS(N,dt,topic)
    % N : number of rigid body
    % dt : sampling time
    % num : on_marker_num = 4*N+num
    % noise : 1 means active
%ros_param.dt = dt;

ros_param.ROSHostIP =  param.HostIP;
ros_param.ROSClinetIP = ;
ros_param.rigid_num = N;
ros_param.subTopic = param.subTopic;
ros_param.subName = param.subName;
%ros_param.pubTopic = ['/input'];
%ros_param.pubName = ["u"];
ros=ROS_CONNECTOR(ros_param);
end
