function parameter = LineParameterToLine(line_parameter, Constant)
    % Initalise each variable`
    map_size = length(line_parameter.d);
    parameter.a = zeros(map_size, 1);
    parameter.b = zeros(map_size, 1);
    parameter.c = zeros(map_size, 1);
    % Calculation of each parameter
    for i = 1:map_size
        % Calculation of inclination of line using relationship of normal vector
        delta = -1 / tan(line_parameter.delta(i));
        % Calculation of intersection point
        x = line_parameter.d(i) * cos(line_parameter.delta(i));
        y = line_parameter.d(i) * sin(line_parameter.delta(i));
        if abs(delta) < pi()
            % Calculatiobn of "y = ax + c"
            parameter.a(i) = delta;
            parameter.b(i) = -1;
            parameter.c(i) = y - parameter.a(i) * x;
        else
            % Calculatiobn of "x = by + c"
            parameter.a(i) = -1;
            parameter.b(i) = 1 / delta;
            parameter.c(i) = x - parameter.b(i) * y;
        end
    end
end
