function motive = Connector_Natnet(HostIP)
% create NATNET_CONNECTOR instance as motive
arguments
<<<<<<< HEAD
  natnet_param.ClientIP char = '192.168.100.99' % 9 : 関口デスクトップ
  natnet_param.HostIP char = '192.168.100.131'
=======
  HostIP % motive server IP
>>>>>>> master
end
[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
ClientIP = resolvehost(hostname,"address"); % client ip
motive=NATNET_CONNECTOR("HostIP",HostIP,"ClientIP",ClientIP);
end