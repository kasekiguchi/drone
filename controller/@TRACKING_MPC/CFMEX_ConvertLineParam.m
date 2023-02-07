function parameter = CFMEX_ConvertLineParam(obj)
MapStruct = obj.self.estimator.result.map_param;
    % Initialize each variable
    map_size = length(MapStruct.a);
    parameter.d = zeros(map_size, 1);
    parameter.delta = zeros(map_size, 1);
    for i = 1:length(MapStruct.a)
        % Calculation of distance using the formula of distance between point and line
        parameter.d(i) = abs(MapStruct.c(i)) / sqrt(MapStruct.a(i) ^ 2 + MapStruct.b(i) ^ 2);
        % Calculation of angle using the formula of normal vector
        t = -MapStruct.c(i) / (MapStruct.a(i) ^ 2 + MapStruct.b(i) ^ 2);
        parameter.delta(i) = atan2(t * MapStruct.b(i), t * MapStruct.a(i));
    end
end
