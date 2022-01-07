function motive = Connector_Natnet(natnet_param)
% create NATNET_CONNECTOR instance as motive
arguments
  natnet_param.ClientIP string = "192.168.1.9"
  natnet_param.rigid_list = ""
  natnet_param.HostIP string = "192.168.1.35"
  natnet_param.yaws = 0
end

 motive=NATNET_CONNECTOR("HostIP",natnet_param.HostIP,"ClientIP",natnet_param.ClientIP,"rigid_list",natnet_param.rigid_list,'yaws',natnet_param.yaws);
end
