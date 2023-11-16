function Model= Model_Drone_Exp(dt,~,conn_type,id)
% dt : sampling time
% isPlant : "plant"
% conn_type : connector type : "udp" or "serial"
% id : array of identification numbers :
%    if conn_type is "udp", id = [124, 125, 127] means three drones with IP
%    address "192.168.50.124", "...125", "...127" respectively.
%    if conn_type is "serial", id = [5, 7] means two drones connected at
%    "COM5" and "COM7"
arguments
  dt
  ~
  conn_type
  id
end
Setting.dt = dt;
Model.id = id;
Model.type="DRONE_EXP_MODEL"; % class name
Model.name="lizard"; % print name
Setting.conn_type = conn_type;
switch conn_type
% if strcmp(conn_type,"udp")
    case "udp"
        Setting.num = id;
% elseif strcmp(conn_type,"serial")
    case "serial"
      available_ports=serialportlist("available");
      disp(strcat("Check available COM ports : ",strjoin(available_ports,',')));
      Setting.port = id;
    case "ros2"        
        Setting.param.state_list = ["p"];
        Setting.param.subName = ["p"];
        Setting.subTopic(1,:) = {'/rover_odo','geometry_msgs/Twist'};%%%%%%%%%%%%sub topic name
        Setting.pubTopic(1,:) = {'/rover_twist','geometry_msgs/Twist'};%%%%%%%%%%%%pub topic name       
        Setting.node            = ros2node("/agent_"+string(id),id);%%%%%%%%%%%%%create node
end
Model.param = Setting;
end
