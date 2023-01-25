function motive = Connector_Natnet(natnet_param)
% create NATNET_CONNECTOR instance as motive
arguments
  natnet_param.ClientIP char = '192.168.1.8' % 9 : 関口デスクトップ
  natnet_param.HostIP char = '192.168.1.6'
end

 motive=NATNET_CONNECTOR("HostIP",natnet_param.HostIP,"ClientIP",natnet_param.ClientIP);
end
