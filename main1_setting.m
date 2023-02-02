if fExp
    dt = 0.025; % sampling time
else
    %dt = 0.025; % sampling time (plantとmodelが違う場合0.025くらいの方が確実)
    dt = 0.025; % sampling time (plantとmodelが違う場合0.025くらいの方が確実)
end

sampling = dt;
ts = 0;

if fExp
    te = 10000;
else
%     te = 5;%enviroment用
%     te = 5;%simple用
    te = 3.5;%reverce用
%     te = 1.8;
end

%% set connector (global instance)
if fMotive

    if fExp
        %rigid_ids = [1,2];
        %motive = Connector_Natnet('ClientIP', '192.168.1.9', 'rigid_list', rigid_ids); % Motive
        %[COMs,rigid_ids,motive] = build_MASystem_with_motive('192.168.1.6')
        %% set connector (global instance)
        rigid_ids = [1];
        motive = Connector_Natnet('ClientIP', '192.168.1.9'); % Motive 7 : hara
        COMs = "COM21";
        %[COMs,rigid_ids,motive,initial_state_yaw_angles] = build_MASystem_with_motive('192.168.1.6'); % set ClientIP
        N = length(COMs);
        motive.getData([], []);
    else
        rigid_ids = 1:N;
        motive = Connector_Natnet_sim(N, dt, 0);              % 3rd arg is a flag for noise (1 : active )
        %motive = Connector_Natnet_sim(2*N,dt,0); % for suspended load
    end

end

