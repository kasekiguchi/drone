function motive = Connector_Natnet(HostIP)
% create NATNET_CONNECTOR instance as motive
arguments
  HostIP % motive server IP
end
[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
% ClientIP = resolvehost(hostname,"address"); % client ip
ClientIP = '192.168.1.3'; % 実験用PC
motive=NATNET_CONNECTOR("HostIP",HostIP,"ClientIP",ClientIP);%ClientIP:実験用PC,HostIP:MotivePC
end