function dx = euler_parameter_thrust_force_physical_parameter_model_with_dst(xp,u,param)

    B = param(end-11:end)';
    dx = euler_parameter_thrust_force_physical_parameter_model(xp,u,param);
%     dx = dx + B*u(5);
    dist = [zeros(6,1);u(5:10)];
    dx = dx + dist;%xyzrollpitchiyawに入れられる