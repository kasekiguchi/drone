function motive = Connector_Natnet(HostIP)
% create NATNET_CONNECTOR instance as motive
arguments
  HostIP % motive server IP
end
[~,hostname] = system('hostname');
hostname = string(strtrim(hostname));
% ClientIP = resolvehost(hostname,"address"); % client ip 1系統以外もあると誤認識が起こる
ClientIP = '192.168.1.2'; % 実験用PC
%% ipconfigから取得
% [~, cmdout] = system('ipconfig');
% ipidx = strfind(cmdout, '192.168.1.');
% ClientIP = cmdout(ipidx:ipidx+10);
%%
motive=NATNET_CONNECTOR("HostIP",HostIP,"ClientIP",ClientIP);%ClientIP:実験用PC,HostIP:MotivePC
end