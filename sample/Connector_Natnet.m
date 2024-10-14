function motive = Connector_Natnet(HostIP)
% create NATNET_CONNECTOR instance as motive
arguments
  HostIP % motive server IP
end
[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
% ClientIP = resolvehost(hostname,"address"); % client ip
% ClientIP = '192.168.1.5'; % PC 実験室
ClientIP = '192.168.120.3'; % PC 総研
motive=NATNET_CONNECTOR("HostIP",HostIP,"ClientIP",ClientIP);%ClientIP:実験用PC,HostIP:MotivePC
end