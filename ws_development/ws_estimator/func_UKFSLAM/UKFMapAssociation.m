function parameter = UKFMapAssociation(state,Lines, measured_distance, measured_angle, Constant,NLP)
PreMap = MapStateToLineEqu(Lines,NLP);
map.a = PreMap.a;
map.b = PreMap.b;
map.c = PreMap.c;
map.x = PreMap.x;
map.y = PreMap.y;
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
sigma = (y_end .* x_line - y_line .* x_end) ./ delta;
mu = (x_laser .* y_end - x_end .* y_laser) ./ delta;
% Calculation of laser distance
dist = sigma .* Constant.SensorRange;
% Change the value which fail validation to Invalid value
cond_1 = (sigma >= 0 & sigma <= 1 & mu >= 0 & mu <= 1 & dist >= 0 & dist <= Constant.SensorRange & (abs(dist - measured_distance) < Constant.DistanceThreshold));
dist(~cond_1) = inf;
% Searching minimum distance for each laser
[min_dist, min_index] = min(dist);
inf_cond = isinf(min_dist);
min_dist(inf_cond) = 0;
min_index(inf_cond) = 0;
% assign returuning value by calculated value
parameter.index = min_index;
parameter.distance = min_dist;
end
