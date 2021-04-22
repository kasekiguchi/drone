function EndPoint = SigmaLineParamToEndPoint(SigmaPoint,Map,RobotStateNum,Constant)
%Map : マップ状態の平均が入ってる構造体
Mean.d = SigmaPoint(RobotStateNum+1:2:end,1);
Mean.alpha = SigmaPoint(RobotStateNum+2:2:end,1);
MapSize = (size(SigmaPoint,1) - RobotStateNum)/2;
EndPoint = cell(MapSize,1);%EndPoint.x , EndPoint.y
Rotate = @(theta) [cos(theta),-sin(theta);sin(theta),cos(theta)];%原点中心の回転行列
for j = 1:size(SigmaPoint,2)
% Initalise each variable`
parameter.a = zeros(MapSize, 1);
parameter.b = zeros(MapSize, 1);
parameter.c = zeros(MapSize, 1);
parameter.x = zeros(MapSize, 2);%start point and end point
parameter.y = zeros(MapSize, 2);%start point and end point
% Calculation of each parameter
for i = 1:MapSize
    %map param for end point caluculation
    After.d = SigmaPoint(2*i-1 + RobotStateNum,j);
    After.alpha = SigmaPoint(2*i + RobotStateNum,j);
    DiffAlpha = After.alpha - Mean.alpha(i);
    % Calculation of inclination of line using relationship of normal vector
    delta = -1 / tan(SigmaPoint(2*i,j));
    % Calculation of intersection point
    x = SigmaPoint(2*i-1,j) * cos(SigmaPoint(2*i,j));
    y = SigmaPoint(2*i-1,j) * sin(SigmaPoint(2*i,j));
    if abs(delta) < pi()
        % Calculatiobn of "y = ax + c"
        parameter.a(i) = delta;
        parameter.b(i) = -1;
        parameter.c(i) = y - parameter.a(i) * x;
        parameter.x(i,:) = Map.x(i,:);
        parameter.y(i,:) = Map.y(i,:);
    else
        % Calculatiobn of "x = by + c"
        parameter.a(i) = -1;
        parameter.b(i) = 1 / delta;
        parameter.c(i) = x - parameter.b(i) * y;
        parameter.x(i,:) = Map.x(i,:);
        parameter.y(i,:) = Map.y(i,:);
    end
    %Mapの端点を元のマップとの変化量から計算しフィッティング
    tmp = [Map.x(i,:);Map.y(i,:)];
    EndParam = Rotate(DiffAlpha) * tmp;
    disa = [After.d*cos(After.alpha);After.d*sin(After.alpha)];%distance before
    disb = [Mean.d(i)*cos(After.alpha);Mean.d(i)*sin(After.alpha)];%distance after
%     Dis = disa - disb;
    EndParam = EndParam + (disa - disb);
    parameter.x(i,:) = EndParam(1,:);
    parameter.y(i,:) = EndParam(2,:);
end
% parameter = FittingEndPoint(parameter,Constant);
EndPoint{j,1}.x = parameter.x;
EndPoint{j,1}.y = parameter.y;
end
end
