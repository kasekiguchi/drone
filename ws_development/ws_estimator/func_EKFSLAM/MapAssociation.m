function parameter = MapAssociation(map, ~, state, measured_distance, measured_angle, Constant)
    % Initialize each variable
    association_size = length(measured_distance);
    parameter.index = zeros(association_size, 1);
    parameter.sign = zeros(association_size, 1);
    % Define variable about start and end point of map and laser
    x_s = map.x(:, 1);
    x_e = map.x(:, 2);
    x = state(1);
    x_m = x + Constant.SensorRange * cos(state(3) + measured_angle);
    y_s = map.y(:, 1);
    y_e = map.y(:, 2);
    y = state(2);
    y_m = y + Constant.SensorRange * sin(state(3) + measured_angle);
    % Calculation of temporary variable
    x_line = x_s - x_e;
    y_line = y_s - y_e;
    x_laser = x_m - x;
    y_laser = y_m - y;
    x_end = x - x_e;
    y_end = y - y_e;
    delta = x_laser .* y_line - x_line .* y_laser;
    % Calculation of internal ratio
    sigma = (y_end .* x_line - y_line .* x_end) ./ delta;%レーザが壁と持つ内分比
    mu = (x_laser .* y_end - x_end .* y_laser) ./ delta;%壁とレーザの内分比
    % Calculation of laser distance
    Dis = sigma .* Constant.SensorRange;
    % Change the value which fail validation to Invalid value 
    %sigmaが0より大きく1より小さい，muが0より大きく1より小さい，理論距離(dist)が0より大きくセンサレンジより小さい，理論距離と測定距離の差が閾値より小さい
    conditionRation = (sigma >= 0 & sigma <= 1 & mu >= 0 & mu <= 1 & Dis >= 0 & Dis <= Constant.SensorRange & (abs(Dis - measured_distance) < Constant.DistanceThreshold) &  measured_distance > Constant.DistanceThreshold);
    Dis(~conditionRation) = inf;
    % Searching minimum distance for each laser
    [min_dist, min_index] = min(Dis);
    inf_cond = isinf(min_dist);
    min_dist(inf_cond) = 0;
    min_index(inf_cond) = 0;
    % assign returuning value by calculated value
    parameter.index = min_index;
    parameter.distance = min_dist;
end