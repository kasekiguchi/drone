function u_trans_param = InputTransform_Thrust2Throttle_drone(varargin)
    % input transformation from thrust force to throttle level for
    % drone Prop. input

    %% transmitter system
%     u_trans_param.gain = [600; 600; 400; 120]; % serial : 500 = neutral  udp : 1100
%     u_trans_param.th_offset = 380;             % check throttle at hovering
%     u_trans_param.gain =[200;200;200;89]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
%     u_trans_param.th_offset = 960;         % offset 3s[1021] 4s[900]　発掘[926]
%     u_trans_param.gain_SuspendedLoad =[500;500;500;150]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
%     u_trans_param.th_offset_SuspendedLoad = 1150;         % offset 3s[1021] 4s[900]　発掘[926]
    u_trans_param.gain =[600;600;600;150]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    u_trans_param.th_offset = 270;         % offset 3s[1021] 4s[900]　発掘[926]
    u_trans_param.gain_SuspendedLoad =[500;500;500;100]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    u_trans_param.th_offset_SuspendedLoad = 450;         % offset 3s[1021] 4s[900]　発掘[926]

%     u_trans_param.gain = [1000; 1000; 400; 40]; %
%     % 500 = neutral
%     u_trans_param.th_offset = 190;             % check throttle at hovering

    % u_trans_param.gain =[800;800;800;400]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset = 1000;         % offset 3s[1021] 4s[900]　発掘[926]
    % % u_trans_param.gain =[700;700;600;400];% gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400]
    % % u_trans_param.th_offset = 900; % offset 3s[1021] 4s[900]
    % u_trans_param.gain = [50; 50; 50; 100]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset = 580; % offset 3s[1021] 4s[900]　発掘[926] % motor推力実験と機体重量から決まるはず
end
