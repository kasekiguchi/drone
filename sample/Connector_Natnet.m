function motive = Connector_Natnet(HostIP)
% create NATNET_CONNECTOR instance as motive
% motiveとmatlabを接続する
arguments
  HostIP % motive server IP
end
[~,hostname]    = system('hostname');               % motiveのPC
hostname        = string(strtrim(hostname));        % motiveのPC
ClientIP        = resolvehost(hostname,"address");  % client ip (matlabのPC) この関数だとうまくIPが取れないことがある
ClientIP        = '192.168.1.3';                    % client ipなぶちゃん
% ClientIP      = '192.168.1.2';                    % client ip粉砕
% ClientIP      = '192.168.1.6';                    % client ipチハ
ClientIP      = '192.168.1.10';                    % client ipチハ
% NATNET_CONNECTORクラスでmotiveから情報を取ってくるnatnet.pファイルを設定
motive=NATNET_CONNECTOR("HostIP",HostIP,"ClientIP",ClientIP); 
end