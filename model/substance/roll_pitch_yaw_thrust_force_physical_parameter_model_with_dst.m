function dx = roll_pitch_yaw_thrust_force_physical_parameter_model_with_dst(xp,u,param)

    B = param(end-11:end)';
    dx = roll_pitch_yaw_thrust_force_physical_parameter_model(xp,u,param(1:end-12));
    dx = dx + B*u(5);
%     dist = [zeros(1,6),u(5:10)]';
%     dx = dx + B.*dist;%xyzrollpitchiyawに入れられる

