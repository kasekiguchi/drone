function u_trans_param = InputTransform_Thrust2Throttle_drone(varargin)
    % input transformation from thrust force to throttle level for
    % drone Prop. input
    u_trans_param.type = "THRUST2THROTTLE_DRONE";
    u_trans_param.name = "t2t";

    %% transmitter system
%     u_trans_param.param.gain =[200;200;200;89]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
%     u_trans_param.param.th_offset = 960;         % offset 3s[1021] 4s[900]　発掘[926]
%     u_trans_param.param.gain_SuspendedLoad =[500;500;500;150]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
%     u_trans_param.param.th_offset_SuspendedLoad = 1150;         % offset 3s[1021] 4s[900]　発掘[926]
    u_trans_param.param.gain =[250;250;250;10]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    u_trans_param.param.th_offset = 905;         % offset 3s[1021] 4s[900]　発掘[926]
    u_trans_param.param.gain_SuspendedLoad =[530;530;400;60]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    u_trans_param.param.th_offset_SuspendedLoad = 350;         % offset 3s[1021] 4s[900]　発掘[926]

%     u_trans_param.param.gain = [1000; 1000; 400; 40]; %
%     % 500 = neutral
%     u_trans_param.param.th_offset = 190;             % check throttle at hovering

    % u_trans_param.param.gain =[800;800;800;400]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.param.th_offset = 1000;         % offset 3s[1021] 4s[900]　発掘[926]
    % % u_trans_param.param.gain =[700;700;600;400];% gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400]
    % % u_trans_param.param.th_offset = 900; % offset 3s[1021] 4s[900]
    % u_trans_param.param.gain = [50; 50; 50; 100]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.param.th_offset = 580; % offset 3s[1021] 4s[900]　発掘[926] % motor推力実験と機体重量から決まるはず
end
