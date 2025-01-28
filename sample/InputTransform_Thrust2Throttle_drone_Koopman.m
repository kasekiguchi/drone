function u_trans_param = InputTransform_Thrust2Throttle_drone_Koopman(varargin)
    % input transformation from thrust force to throttle level for
    % drone Prop. input

    %% transmitter system
    % Kato iFlight 0128 comment out
    % u_trans_param.gain =[650;650;650;17]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset = 340;         % 325のほうがちょうどいい

    % iFlight
    % u_trans_param.gain = [300;500;300;20]; % 300;500;300;20
    % u_trans_param.th_offset = 340; %350 
    
    % u_trans_param.gain2 = [1000;1000;1000;500]; % 650 650 650 500 割といい

    % これ
    % u_trans_param.gain2 = [800;800;800;300]; % 650 650 650 500 割といい
    % u_trans_param.th_offset2 = 332.5; % 332：落ちる 
    % hovering H=20 : 800 800 800 400
    % hovering H=10~15 : 800 800 800 500 くらい

    %% Komatsu
    % u_trans_param.gain2 =[650;650;650;17]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset2 = 335;

    %% Kato Kiyama Dataset -> iFlight 0128 comment out
    % u_trans_param.gain2 = [1600;1600;1600;170];
    % u_trans_param.th_offset2 = 342;

    %% exp 0128 HLMCと同じ値にしてみた
    % iFlight
    u_trans_param.gain = [300;500;300;20]; % 300;500;300;20
    u_trans_param.th_offset = 340; %350  

    g2 = 1000; % 650
    u_trans_param.gain2 = [ones(3,1)*g2;150];
    u_trans_param.th_offset2 = 335; %340


    % gain_f
    % u_trans_param.gain2 =[1000;1000;1000;1000]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset2 = 350;  

    % u_trans_param.gain_SuspendedLoad =[500;500;500;100]; % gain : [roll pitch yaw throttle]' %不明[850;850;600;600] 4s[700;700;600;400] 複数機[700;700;600;200] 発掘[800;800;800;400]
    % u_trans_param.th_offset_SuspendedLoad = 450;         % offset 3s[1021] 4s[900]　発掘[926]
end
