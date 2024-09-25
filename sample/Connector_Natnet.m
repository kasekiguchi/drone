function motive = Connector_Natnet(HostIP)
% create NATNET_CONNECTOR instance as motive
arguments
  HostIP % motive server IP
end
[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
ClientIP = resolvehost(hostname,"address"); % client ip
   % ClientIP = '192.168.1.5';%なぶちゃん
  % ClientIP = '192.168.1.2';%粉砕
  ClientIP = '192.168.120.5';%steam
motive=NATNET_CONNECTOR("HostIP",HostIP,"ClientIP",ClientIP);
end