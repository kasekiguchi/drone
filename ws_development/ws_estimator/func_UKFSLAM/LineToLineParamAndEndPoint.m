function Param = LineToLineParamAndEndPoint(map)
    % Initialize each variable
    map_size = length(map.index);
    Param.d = zeros(map_size, 1);
    Param.delta = zeros(map_size, 1);
    Param.xs = zeros(map_size, 1);
    Param.xe = zeros(map_size, 1);
    Param.ys = zeros(map_size, 1);
    Param.ye = zeros(map_size, 1);
    for i = 1:length(map.index)
        % Calculation of distance using the formula of distance between point and line
        Param.d(i) = abs(map.c(i)) / sqrt(map.a(i) ^ 2 + map.b(i) ^ 2);
        % Calculation of angle using the formula of normal vector
        t = -map.c(i) / (map.a(i) ^ 2 + map.b(i) ^ 2);
        Param.delta(i) = atan2(t * map.b(i), t * map.a(i));
        Param.xs(i) = map.x(i,1);
        Param.xe(i) = map.x(i,2);
        Param.ys(i) = map.y(i,1);
        Param.ye(i) = map.y(i,2);
    end
end
