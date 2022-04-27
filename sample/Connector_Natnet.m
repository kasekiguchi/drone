function motive = Connector_Natnet(natnet_param)
% create NATNET_CONNECTOR instance as motive
arguments
  natnet_param.ClientIP char = '192.168.1.9'
  natnet_param.HostIP char = '192.168.1.35'
end

 motive=NATNET_CONNECTOR("HostIP",natnet_param.HostIP,"ClientIP",natnet_param.ClientIP);
end
