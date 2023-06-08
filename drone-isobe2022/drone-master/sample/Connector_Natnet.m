function motive = Connector_Natnet(natnet_param)
% create NATNET_CONNECTOR instance as motive
arguments
  natnet_param.ClientIP char = '192.168.100.142' % 9 : 関口デスクトップ
  natnet_param.HostIP char = '192.168.100.131'%粉砕のIP
end

 motive=NATNET_CONNECTOR("HostIP",natnet_param.HostIP,"ClientIP",natnet_param.ClientIP);
end