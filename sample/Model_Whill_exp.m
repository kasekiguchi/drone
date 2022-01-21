function Model = Model_Whill_exp(dt,~,~,conn_type,id)
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
  ~
  conn_type
  id 
end
type="Whill_exp"; % class name
name="whill"; % print name
Setting.conn_type = conn_type;
Setting.dt = dt;

switch conn_type
  case "udp"
    Setting.num = id;
  case "serial"
    available_ports=serialportlist("available");
    disp(strcat("Check available COM ports : ",strjoin(available_ports,',')));
    Setting.port = id;
  case "ros"
    Setting.param.state_list = ["p"];
    Setting.param.num_list = [3,3];
    Setting.param.subTopic = ["/mavros/local_position/pose"];
    Setting.param.subName = ["p"];
    Setting.param.ROSHostIP = id;
end
Model = {"type",type,"name",name,"param",Setting,"id",id};
end
