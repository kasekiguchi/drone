function u_trans_param = InputTransform_Thrust2Throttle_drone(varargin)
    % input transformation from thrust force to throttle level for
    % drone Prop. input

    %% transmitter system
    %過去の遺物% u_trans_param.gain_tl =[600;600;600;20]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.gain_SuspendedLoad =[500;500;500;100]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset_SuspendedLoad = 450;         % offset 3s[1021] 4s[900]　発掘[926]
     
     % th_offset : hovering throttle
     % gain : [roll pitch yaw throttle]
     u_trans_param.th_offset    = 331;
     u_trans_param.th_offset_tl = 331;%340で飛ぶはずだけど…  %ここ変えるとテークオフとランディング中の釣り合うスロットル変わる。
     u_trans_param.gain         = [300;300;300;20];%同じく　
     u_trans_param.gain_tl      = [300;300;300;20];%機体が微振動するときは[270;270;270;20]とかに下げる．根本的には制御周期が遅い．


     %単純HL用↓ masterにマージするとき自動で切り替わるようにしないとスロットルゲインおかしくなる．
     %u_trans_param.th_offset = 331;
     %u_trans_param.th_offset_tl = 340;
     %u_trans_param.th_offset_f = 340;
     %u_trans_param.gain_tl =[600;600;600;20];
     %u_trans_param.gain_f =[600;600;600;20];
     %単純HL用↑
    
    %単機牽引用↓
    u_trans_param.th_offset     = 331;%331;%tlとfで分けている理由はtlとfで異なったコントローラー・機体質量を扱えるようにするため．
    u_trans_param.th_offset_tl  = 270;  %テークオフとランディング初期オフセット。
    u_trans_param.gain          = [300;300;300;20];%　
    u_trans_param.gain_tl       = [300;300;300;20];%　　　
end
