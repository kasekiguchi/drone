%% general setting
N = 1; % number of agents
fExp = 0 % 1：実機　それ以外：シミュレーション
fMotive = 1; % Motiveを使うかどうか
fOffline = 0; % offline verification with experiment data

if fExp
    dt = 0.025; % sampling time
else
    dt = 0.025; % sampling time (plantとmodelが違う場合0.025くらいの方が確実)
end

sampling = dt;
ts = 0;

if fExp
    te = 10000;
else
    te = 17;
end

%% generate environment
Env = DensityMap_sim(Env_2DCoverage); % 重要度マップ設定
%% set connector (global instance)
if fMotive
    if fExp
        %rigid_ids = [1,2];
        %motive = Connector_Natnet('ClientIP', '192.168.1.9', 'rigid_list', rigid_ids); % Motive
        %[COMs,rigid_ids,motive] = build_MASystem_with_motive('192.168.1.6')
        %% set connector (global instance)
        rigid_ids = [1];
        motive = Connector_Natnet('ClientIP', '192.168.1.5'); % Motive 7 : hara
        COMs = "COM21";
        %[COMs,rigid_ids,motive,initial_yaw_angles] = build_MASystem_with_motive('192.168.1.6'); % set ClientIP
        N = length(COMs);
        motive.getData([], []);
    else
        rigid_ids = 1:N;
        motive = Connector_Natnet_sim(N, dt, 0);              % 3rd arg is a flag for noise (1 : active )
        %motive = Connector_Natnet_sim(2*N,dt,0); % for suspended load
    end
end

%% initialize
disp("Initialize state");
initial(N) = struct;
param(N) = struct('sensor', struct, 'estimator', struct, 'reference', struct);

if fExp
    if exist('motive', 'var') == 1; motive.getData([], []); end

    for i = 1:N
        % for exp with motive : initialize by motive info
        if exist('motive', 'var') == 1
            sstate = motive.result.rigid(rigid_ids(i));
            initial(i).p = sstate.p;
            initial(i).q = sstate.q;
            initial(i).v = [0; 0; 0];
            initial(i).w = [0; 0; 0];
        else % とりあえず用
            arranged_pos = arranged_position([0, 0], N, 1, 0);
            initial(i).p = arranged_pos(:, i);
            initial(i).q = [1; 0; 0; 0];
            initial(i).v = [0; 0; 0];
            initial(i).w = [0; 0; 0];
        end

    end

else

    if (fOffline)
        %%
        expdata = DATA_EMULATOR("isobe_HLonly_Log(18-Dec-2020_12_17_35)"); % 空の場合最新のデータ
    end

    %% for sim
    for i = 1:N

        if (fOffline)
            initial(i).p = expdata.Data{1}.agent{1, expdata.si, i}.state.p;
            initial(i).q = expdata.Data{1}.agent{1, expdata.si, i}.state.q;
            initial(i).v = [0; 0; 0];
            initial(i).w = [0; 0; 0];
        else
            arranged_pos = arranged_position([0, 0], N, 1, 0);
            initial(i).p = arranged_pos(:, i);
            initial(i).q = [1; 0; 0; 0];
            initial(i).v = [0; 0; 0];
            initial(i).w = [0; 0; 0];
        end

    end

end
