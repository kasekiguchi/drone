function L = LineParamToLineAndEndPoint(DA)
% DA : line L = [d, alpha]
% line : [a,b,c,x,y]
% Initalise each variable
map_size = length(DA.d);
% Calculation of each L
    for i = 1:map_size
        % Calculation of inclination of line using relationship of normal vector
        delta = -1 / tan(DA.delta(i));
        % Calculation of intersection point
        x = DA.d(i) * cos(DA.delta(i));
        y = DA.d(i) * sin(DA.delta(i));
        if abs(delta) < pi()
            % Calculatiobn of "y = ax + c"
            L.a(i,1) = delta;
            L.b(i,1) = -1;
            L.c(i,1) = y - L.a(i) * x;
        else
            % Calculatiobn of "x = by + c"
            L.a(i,1) = -1;
            L.b(i,1) = 1 / delta;
            L.c(i,1) = x - L.b(i) * y;
        end
    end
end
