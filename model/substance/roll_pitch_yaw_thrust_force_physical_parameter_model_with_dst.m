function dx = roll_pitch_yaw_thrust_force_physical_parameter_model_with_dst(xp,u,param)

    B = param(end-1,end);
    dx = roll_pitch_yaw_thrust_force_physical_parameter_model(xp,u,param);
    dx = dx + B*u(5);
