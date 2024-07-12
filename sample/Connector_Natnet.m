function motive = Connector_Natnet(HostIP)
% create NATNET_CONNECTOR instance as motive
arguments
  HostIP % motive server IP
end
[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
ClientIP = resolvehost(hostname,"address"); % client ip
ClientIP = '192.168.1.3'; % client ip
motive=NATNET_CONNECTOR("HostIP",HostIP,"ClientIP",ClientIP);
end