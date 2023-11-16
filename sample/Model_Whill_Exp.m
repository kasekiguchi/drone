function Model = Model_Whill_Exp(dt, ~, conn_type, id)
% dt : sampling time
% isPlant : "plant"
% conn_type : connector type : "udp" or "serial"
% id : array of identification numbers :
%    if conn_type is "udp", id = 124 means IP address 192.168.50.124
%    if conn_type is "serial", id = [5, 7] means two drones connected at
%    "COM5" and "COM7"
arguments
    dt
    ~
    conn_type
    id
end

% setting.id = id;
Model.type = "WHILL_EXP_MODEL"; % model name
Model.name = "whill"; % print name
setting.conn_type = conn_type;
setting.dt = dt;

switch conn_type
    case "udp"
        setting.num = id;
    case "serial"
        available_ports = serialportlist("available");
        disp(strcat("Check available COM ports : ", strjoin(available_ports, ',')));
        setting.port = id;
    case "ros"
        setting.param.state_list = ["p"];
        setting.param.subName = ["p"];
        setting.param.DomainID  = id;
        setting.subTopicName    = {'/rover_odo'};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sub topic name
        setting.pubTopicName    = {'/rover_twist'};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%pub topic name
        setting.subMsgName      = {'geometry_msgs/Twist'};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sub 型
        setting.pubMsgName      = {'geometry_msgs/Twist'};%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%pub 型
    case "ros2"        
        setting.param.state_list = ["p"];
        setting.param.subName = ["p"];
        setting.subTopic(1,:) = {'/rover_odo','geometry_msgs/Twist'};%%%%%%%%%%%%sub topic name
        setting.pubTopic(1,:) = {'/rover_twist','geometry_msgs/Twist'};%%%%%%%%%%%%pub topic name       
        setting.node            = ros2node("/agent_"+string(id),id);%%%%%%%%%%%%%create node
end

Model.param = setting;
end