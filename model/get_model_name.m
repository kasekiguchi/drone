function model_full_name = get_model_name(sn)
    switch sn
        case "Discrete"
            model_full_name = "discrete_linear_model";
        case "Point mass"
            model_full_name = "point_mass_model";
        case "Quat 13"
            model_full_name = "euler_parameter_thrust_force_physical_parameter_model";
        case "Quat 17"
            model_full_name = "euler_parameter_with_motor_model";
        case "RPY 12"
            model_full_name = "roll_pitch_yaw_thrust_force_physical_parameter_model";
        case "R 18"
            model_full_name = "rotation_matrix_thrust_force_physical_parameter_model";
        case "Load"
            model_full_name = "with_load_model";
        case "Load_Euler"
            model_full_name = "euler_with_load_model";
%         "euler","euler_angle_model",12;
%         "rodrigues","rodrigues_parameter_model",12;
        case "Cooperative_Load"
            model_full_name = "cable_suspended_rigid_body_with_4_drones";
    end
end
