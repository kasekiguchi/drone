function u_trans_param = InputTransform_Thrust2Throttle_drone(varargin)
    % input transformation from thrust force to throttle level for
    % drone Prop. input

    %% transmitter system
    u_trans_param.gain_tl =[600;600;600;20]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset_tl = 245;         % offset 3s[1021] 4s[900]　発掘[926]
     u_trans_param.th_offset_tl = 346;%252  %ここ変えると出だし変わる。
    u_trans_param.gain_f =[600;600;600;20];    
    % u_trans_param.th_offset_f = 260;%牽引物込み
    u_trans_param.th_offset_f = 326;%330;%牽引物込み267 フライトしたときに345→364に変化しているので何とかする必要ある。

    % u_trans_param.gain_SuspendedLoad =[500;500;500;100]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset_SuspendedLoad = 450;         % offset 3s[1021] 4s[900]　発掘[926]
end
