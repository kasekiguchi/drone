function Param = LineToLineParamAndEndPoint(obj)
% 関口チェック済み
map = obj.map_param;

sc = sign(map.c);
map.a(sc~=0) = sc(sc~=0).*map.a(sc~=0);
map.b(sc~=0) = sc(sc~=0).*map.b(sc~=0);
map.c(sc~=0) = sc(sc~=0).*map.c(sc~=0);
lab = sqrt(map.a.^2+map.b.^2);
Param.d = -(map.c)./lab; % readme.md : 2
Param.delta = atan2(map.b,map.a); % readme.md : 1
        Param.xs = map.x(:,1);
        Param.xe = map.x(:,2);
        Param.ys = map.y(:,1);
        Param.ye = map.y(:,2);
%     % Initialize each variable
%     map_size = length(map.id);
%     Param.d = zeros(map_size, 1);
%     Param.delta = zeros(map_size, 1);
%     Param.xs = zeros(map_size, 1);
%     Param.xe = zeros(map_size, 1);
%     Param.ys = zeros(map_size, 1);
%     Param.ye = zeros(map_size, 1);
%     for i = 1:size(map.id,1)
%         % Calculation of distance using the formula of distance between point and line
%         Param.d(i) = abs(map.c(i)) / sqrt(map.a(i) ^ 2 + map.b(i) ^ 2);
%         % Calculation of angle using the formula of normal vector
%         t = -map.c(i) / (map.a(i) ^ 2 + map.b(i) ^ 2);
%         Param.delta(i) = atan2(t * map.b(i), t * map.a(i));
%         Param.xs(i) = map.x(i,1);
%         Param.xe(i) = map.x(i,2);
%         Param.ys(i) = map.y(i,1);
%         Param.ye(i) = map.y(i,2);
%     end
end
