function u_trans_param = InputTransform_Thrust2Throttle_drone_KMPC(varargin)
    % input transformation from thrust force to throttle level for
    % drone Prop. input

    %% transmitter system
    u_trans_param.gain =[650;650;650;17]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    u_trans_param.th_offset = 340;         % offset 3s[1021] 4s[900]　発掘[926]
    
    u_trans_param.gain2 =[500;500;500;400]; %hov,p2p[800,800,800,500]
    u_trans_param.th_offset2 = 332.5; %hov,p2p332.5

    % u_trans_param.gain_SuspendedLoad =[500;500;500;100]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset_SuspendedLoad = 450;         % offset 3s[1021] 4s[900]　発掘[926]
end
