function parameter = MapStateToLineEqu(MapParam)
    MapNum = length(MapParam)/2;%because MapParam has 2 param
    Mapdis = MapParam(1:2:end-1);
    Mapdelta = MapParam(2:2:end);
    % Initalise each variables
    parameter.a = zeros(MapNum, 1);
    parameter.b = zeros(MapNum, 1);
    parameter.c = zeros(MapNum, 1);
    % Calculation of each parameter
    for i = 1:MapNum
        % Calculation of inclination of line using relationship of normal vector
        delta = -1 / tan(Mapdelta(i));
        % Calculation of intersection point
        x = Mapdis(i) * cos(Mapdelta(i));
        y = Mapdis(i) * sin(Mapdelta(i));
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
