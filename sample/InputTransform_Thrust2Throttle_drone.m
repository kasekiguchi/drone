function u_trans_param = InputTransform_Thrust2Throttle_drone(varargin)
    % input transformation from thrust force to throttle level for
    % drone Prop. input

    %% transmitter system
    %4 cells
    % u_trans_param.gain =[600;600;600;20];%[600;600;600;20]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset = 500;         % offset 3s[1021] 4s[900]　発掘[926]
    %6 cells
    % u_trans_param.gain =[500;500;500;20]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset = 230;
    %牽引物体ドローン用
    % u_trans_param.gain_SuspendedLoad =[500;500;500;100]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset_SuspendedLoad = 450;         % offset 3s[1021] 4s[900]　発掘[926]

     %6 cells(EL)バッテリーとの兼ね合いで調整が必要
    u_trans_param.gain =[300;300;300;20];%[600;600;600;20]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.gain =[800;800;800;20];%EL ifilightのHLでも使用
     % u_trans_param.th_offset = 230;         % offset 3s[1021] 4s[900]　発掘[926]
    u_trans_param.th_offset = 330;   %iflight用
end
