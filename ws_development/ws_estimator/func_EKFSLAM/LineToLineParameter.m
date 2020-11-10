function parameter = LineToLineParameter(map, Constant)
    % Initialize each variable
    map_size = length(map.index);
    parameter.d = zeros(map_size, 1);
    parameter.delta = zeros(map_size, 1);
    for i = 1:length(map.index)
        % Calculation of distance using the formula of distance between point and line
        parameter.d(i) = abs(map.c(i)) / sqrt(map.a(i) ^ 2 + map.b(i) ^ 2);
        % Calculation of angle using the formula of normal vector
        t = -map.c(i) / (map.a(i) ^ 2 + map.b(i) ^ 2);
        parameter.delta(i) = atan2(t * map.b(i), t * map.a(i));
    end
end
