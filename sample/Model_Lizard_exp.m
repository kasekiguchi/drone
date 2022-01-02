function Model = Model_Lizard_exp(dt,~,~,conn_type,id)
    % dt : sampling time
    % isPlant : "plant"
    % conn_type : connector type : "udp" or "serial"
    % id : array of identification numbers :
    %    if conn_type is "udp", id = [124, 125, 127] means three drones with IP
    %    address "192.168.50.124", "...125", "...127" respectively.
    %    if conn_type is "serial", id = [5, 7] means two drones connected at
    %    "COM5" and "COM7"
    %evalin('base',"clear agent");
    Setting.dt = dt;
    Model.type="Lizard_exp"; % class name
    Model.name="lizard"; % print name
    Setting.conn_type = conn_type;
    if strcmp(conn_type,"udp")
        Setting.num = id;
    elseif strcmp(conn_type,"serial")
        available_ports=serialportlist("available");
        disp(strcat("Check available COM ports : ",strjoin(available_ports,',')));
        Setting.port = id;
    end
    Model.id = id;
    Model.param=Setting;
    %     assignin('base',"Plant",Model);
    %     evalin('base',"agent(Plant.id) = Drone(Plant);");
end
