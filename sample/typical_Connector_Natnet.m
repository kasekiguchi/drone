function typical_Connector_Natnet(param)
 if isfield(param,'HostIP')
    natnet_param.HostIP = param.HostIP;
 else
    natnet_param.HostIP = '192.168.1.35';
 end
 if isfield(param,'rigid_list')
    natnet_param.rigid_list = param.rigid_list;
 end

 natnet_param.ClientIP = param.ClientIP;%'192.168.1.6';
 motive=NATNET_CONNECTOR(natnet_param);
 assignin('base',"motive",motive);
end
