function u_trans_param = InputTransform_Thrust2Throttle_drone(varargin)
    % input transformation from thrust force to throttle level for
    % drone Prop. input
    u_trans_param.type = "THRUST2THROTTLE_DRONE";
    u_trans_param.name = "t2t";

    %% transmitter system
    u_trans_param.param.gain = [600; 600; 400; 120]; % serial : 500 = neutral  udp : 1100
    u_trans_param.param.th_offset = 380;             % check throttle at hovering

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
