function Model_Lizard_exp(N,dt,isPlant,conn_type,id)
% N : number of drones
% dt : sampling time
% isPlant : "plant"
% conn_type : connector type : "udp" or "serial"
% id : array of identification numbers :
%    if conn_type is "udp", id = [124, 125, 127] means three drones with IP
%    address "192.168.50.124", "...125", "...127" respectively.
%    if conn_type is "serial", id = [5, 7] means two drones connected at
%    "COM5" and "COM7"
evalin('base',"clear agent");
Setting.dt = dt;
Model.type="Lizard_exp"; % class name
Model.name="lizard"; % print name
if length(id)~= N
    error("ACSL : require id for all drones.");
end
if strcmp(conn_type,"serial")
    available_ports=serialportlist("available");
    disp(strcat("Check available COM ports : ",strjoin(available_ports,',')));
end
if strcmp(isPlant,"plant")
    for i = 1:N
        Setting.conn_type = conn_type;
        if strcmp(conn_type,"udp")
            Setting.num = id(i);
        elseif strcmp(conn_type,"serial")
            Setting.port = id(i);
        end
        Model.id = i;
        Model.param=Setting;
        assignin('base',"Plant",Model);
        evalin('base',"agent(Plant.id) = Drone(Plant);");
    end
else
    warning("ACSL : Lizard_exp cannot set as a control model.")
end
