function parameter = LineParamToLineAndEndPoint(obj,lparam)
% lparam : line parameter = [d, alpha]
% line : [a,b,c,x,y]
% Initalise each variable
    map_size = length(lparam.d);
    parameter.a = zeros(map_size, 1);
    parameter.b = zeros(map_size, 1);
    parameter.c = zeros(map_size, 1);
    parameter.x = zeros(map_size, 2);%start point and end point
    parameter.y = zeros(map_size, 2);%start point and end point
    % Calculation of each parameter
    for i = 1:map_size
        % Calculation of inclination of line using relationship of normal vector
        delta = -1 / tan(lparam.delta(i));
        % Calculation of intersection point
        x = lparam.d(i) * cos(lparam.delta(i));
        y = lparam.d(i) * sin(lparam.delta(i));
        if abs(delta) < pi()
            % Calculatiobn of "y = ax + c"
            parameter.a(i) = delta;
            parameter.b(i) = -1;
            parameter.c(i) = y - parameter.a(i) * x;
            parameter.x(i,1) = lparam.xs(i);
            parameter.x(i,2) = lparam.xe(i);
            parameter.y(i,1) = lparam.ys(i);
            parameter.y(i,2) = lparam.ye(i);
        else
            % Calculatiobn of "x = by + c"
            parameter.a(i) = -1;
            parameter.b(i) = 1 / delta;
            parameter.c(i) = x - parameter.b(i) * y;
            parameter.x(i,1) = lparam.xs(i);
            parameter.x(i,2) = lparam.xe(i);
            parameter.y(i,1) = lparam.ys(i);
            parameter.y(i,2) = lparam.ye(i);
        end
    end
end
