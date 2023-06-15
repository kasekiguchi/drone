function model_full_name = get_model_name(sn)
    switch sn
        case "Discrete"
            model_full_name = "discrete_linear_model";
        case "Point mass"
            model_full_name = "point_mass_model";
        case "Quat 13"
            %model_full_name = "euler_parameter_thrust_force_physical_parameter_model";
            model_full_name = "euler_parameter_thrust_torque_physical_parameter_model";
        case "Quat 15"
        %model_full_name = "roll_pitch_yaw_thrust_force_physical_parameter_model";
            model_full_name = "euler_parameter_thrust_torque_physical_parameter_expand_model";
        case "Quat 17"
            model_full_name = "euler_parameter_with_motor_model";
        case "RPY 12"
            %model_full_name = "roll_pitch_yaw_thrust_force_physical_parameter_model";
            model_full_name = "roll_pitch_yaw_thrust_torque_physical_parameter_model";
        case "RPYdst"
            model_full_name = "euler_parameter_thrust_torque_physical_parameter_model_with_dst";
        case "R 18"
            model_full_name = "rotation_matrix_thrust_force_physical_parameter_model";
        case "Load"
            model_full_name = "with_load_model";
        case "Load_Euler"
            model_full_name = "euler_with_load_model";
%         "euler","euler_angle_model",12;
%         "rodrigues","rodrigues_parameter_model",12;
    end
end
