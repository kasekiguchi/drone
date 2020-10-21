function Connector_Natnet_sim(N,dt,noise)
    % Connector_Natnet_sim(N,dt,num)
    % N : number of rigid body
    % dt : sampling time
    % num : on_marker_num = 4*N+num
    % noise : 1 means active
natnet_param.dt = dt;
natnet_param.rigid_num = N;
if noise ==1
    natnet_param.Flag = struct('Noise',     1);                                    % 1 : active
end

% N =3 ‚Åon maker‚ğ”CˆÓ‚Ì”C”z’u‚Éİ’è‚·‚é—á
% natnet_param.local_marker = {[ 0.075, -0.075,  0.015;-0.075, -0.075, -0.015; -0.075,  0.075,  0.015; 0.075,  0.075, -0.015],
%     [ 0.075, -0.075,  0.015;-0.075, -0.075, -0.015; -0.075,  0.075,  0.015; 0.075,  0.075, -0.015; 0.075,  0.075, -0.01; 0.07,  0.075, -0.015],
%     [ 0.075, -0.075,  0.015;-0.075, -0.075, -0.015; -0.075,  0.075,  0.015; 0.075,  0.075, -0.015; 0.075,  0.07, -0.015]};

natnet_param.sigmaw = [6.716E-5; 7.058E-5; 7.058E-5];
motive=NATNET_CONNECTOR_sim(natnet_param);
assignin('base',"motive",motive);
end
