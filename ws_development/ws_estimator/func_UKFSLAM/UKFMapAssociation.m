function parameter = UKFMapAssociation(state,Lines,EndPoint, measured_distance, measured_angle, Constant,NLP)
% state : ビークルの(事前)推定状態 : global
% Lines : mapの(事前)推定値 : global
% EndPoint : line 端点座標
% measured_distance : レーザー計測距離
% measured_angle : レーザー照射角度 : 絶対座標にしてある．
% Constant :各種定数
% NLP : number of line parameter

PreMap = MapStateToLineEqu(Lines,NLP);
map.a = PreMap.a;
map.b = PreMap.b;
map.c = PreMap.c;
map.x = EndPoint.x;
map.y = EndPoint.y;
% Initialize each variable
association_size = length(measured_distance);
parameter.index = zeros(association_size, 1);
%parameter.sign = zeros(association_size, 1);
% Define variable about start and end point of map and laser
Xs = map.x(:, 1);
Xe = map.x(:, 2);
Rx = state(1);
%Xm = Rx + Constant.SensorRange * cos(state(3) + measured_angle);
Xm = Rx + Constant.SensorRange * cos(measured_angle);
Ys = map.y(:, 1);
Ye = map.y(:, 2);   
Ry = state(2);
%Ym = Ry + Constant.SensorRange * sin(state(3) + measured_angle);
Ym = Ry + Constant.SensorRange * sin(measured_angle);
% Calculation of temporary variable
x_line = Xs - Xe;
y_line = Ys - Ye;
x_laser = Xm - Rx;
y_laser = Ym - Ry;
x_end = Rx - Xe;
y_end = Ry - Ye;

% delta = x_laser .* y_line - x_line .* y_laser;
% % Calculation of internal ratio
% sigma = (y_end .* x_line - y_line .* x_end) ./ delta;%レーザが壁と持つ内分比
% mu = (x_laser .* y_end - x_end .* y_laser) ./ delta;%壁とレーザの内分比
% % Calculation of laser distance
% Dis = sigma .* Constant.SensorRange;
% %Calculation
% DisStart = sqrt((Xs - Rx).^2 + (Ys - Ry).^2);
% DisEnd = sqrt((Xe - Rx).^2 + (Ye - Ry).^2);
% MaxDisP = max([DisStart,DisEnd]')';%遠い方の端点との距離を計算
% % Change the value which fail validation to Invalid value
% %sigmaが0より大きく1より小さい，muが0より大きく1より小さい，
% %理論距離(dist)が0より大きくセンサレンジより小さい，
% %理論距離と測定距離の差が閾値より小さい
% %遠いほうの端点よりも距離が近い
% conditionRation = (sigma > 0 & sigma < 1 & mu > 0 & mu < 1 ...
%     & Dis >= 0 & Dis <= Constant.SensorRange & (abs(Dis - measured_distance) < Constant.DistanceThreshold)...
%     &  measured_distance > Constant.DistanceThreshold);
% Dis(~conditionRation) = inf;
% % Searching minimum distance for each laser
% 
% 
% [min_dist, min_index] = min(Dis);
% inf_cond = isinf(min_dist);
% min_dist(inf_cond) = 0;
% min_index(inf_cond) = 0;
% %condition re calculate
% Ts = atan2(Ys - Ry,Xs -Rx);% - state(3);%reference point as front of robot for theta start point 
% Te = atan2(Ye - Ry,Xe -Rx);% - state(3);%theta end point
% TJudge = abs(Ts - Te) < pi;%レーザの始点と終点の角度がpi以上大きいかを判断，大きい場合はチェックルールが変わる．
% [~,Tsidx] = min(abs(Ts - measured_angle),[],2);%ロボットと端点の始点の直線に最も近い角度を持つレーザのインデックス
% [~,Teidx] = min(abs(Te - measured_angle),[],2);%ロボットと端点の終点の直線に最も近い角度を持つレーザのインデックス
% [Tmin,~] = min([Tsidx,Teidx],[],2);%小さい方のインデックス
% [Tmax,~] = max([Tsidx,Teidx],[],2);%デカい方のインデックス
% %各直線に対応付けされたレーザを表示
% %---対応付けされている直線を表示---%
% Elements = nonzeros(min_index);
% ei = 1;
% Estock = [];
% while ei <length(Elements)
%     stock = min(Elements);
%     Elements = Elements(stock ~= Elements);
%     Estock = [Estock,stock];
% end
% %-------------------------------%
% for ci = 1:length(Estock)
%     FTidx = find(min_index==Estock(ci));%壁に対応付けされたレーザのインデックス
%     if TJudge(ci) == false
%         Overidx = find(Tmin(ci)<FTidx & Tmax(ci)>FTidx);%条件に合わないレーザの探索
%         min_index(Overidx) = 0;%条件に合わないレーザをはじく
% %         FF = find(0>FTidx & FTidx<Tmin(ci) | Tmax(ci)>FTidx & FTidx<length(measured_angle));
%     else
%         Overidx = find(0>FTidx & FTidx<Tmin(ci) | Tmax(ci)>FTidx & FTidx<length(measured_angle));
%         min_index(Overidx) = 0;%
% %         FF = find(FTidx>Tmin(ci) & Tmax(ci)>FTidx);%条件を満たすものはとおす，満たさないものはfalseにする
%     end
% end
% % assign returuning value by calculated value

% 線分終点から見た位置
x2 = x_end; % ロボット位置
y2 = y_end;
x1 = Xm - Xe; % 何にも当たらなかった時のレーザー端点位置
y1 = Ym - Ye;
x3 = x_line; % 線分始点の位置
y3 = y_line;
% sigma = 壁までの距離/レーザーレンジ ：1:2=1-k:kの内分点が3までの直線上にあるための条件として以下の解sigma = k
% solve(det([(k*x1+(1-k)*x2),(k*y1+(1-k)*y2);x3 y3])==0,k)
tmp= (x1.*y3 - x3.*y1 - x2.*y3 + x3.*y2); 
tmp(abs(tmp)<=1e-5) = Inf;
sigma = -(x2.*y3 - x3.*y2)./tmp;
sigma(sigma<=0|sigma>=1) = Inf;

% ロボットから見た位置
x2 = Xe - Rx; % 終点
y2 = Ye - Ry;
x1 = Xs - Rx; % 始点
y1 = Ys - Ry;
x3 = Xm - Rx; % レーザー終点
y3 = Ym - Ry;
% sigma = 壁までの距離/レーザーレンジ ：1:2=1-k:kの内分点が3までの直線上にあるための条件として以下の解sigma = k
% solve(det([(k*x1+(1-k)*x2),(k*y1+(1-k)*y2);x3 y3])==0,k)
tmp= (x1.*y3 - x3.*y1 - x2.*y3 + x3.*y2); 
tmp(abs(tmp)<=1e-5) = Inf;
sigma2 = -(x2.*y3 - x3.*y2)./tmp;
sigma2(sigma2<=0|sigma2>=1) = Inf;

%(sigma.*x1+(1-sigma).*x2).*x3+(sigma.*y1+(1-sigma).*y2).*y3 <= 0
%tmpid=sigma.*((x1-x2).*x3+(y1-y2).*y3)+x2+y2 <=0;
sigma(sigma2==Inf) = Inf;
Dis = sigma .* Constant.SensorRange;
[min_dist2, min_index2] = min(Dis);
del_ids=min_dist2 < 1e-3 | min_dist2==Inf | min_dist2 > Constant.SensorRange;
min_index2(del_ids)=0;
min_dist2(del_ids) =0;
parameter.index = min_index2;
parameter.distance = min_dist2;
% % Initialize each variable
% association_size = length(measured_distance);
% parameter.index = zeros(association_size, 1);
% parameter.sign = zeros(association_size, 1);
% % Define variable about start and end point of map and laser
% Xs = map.x(:, 1);%start
% Xe = map.x(:, 2);%end
% Rx = state(1);%Robot x
% Xm = Rx + Constant.SensorRange * cos(state(3) + measured_angle);
% Ys = map.y(:, 1);
% Ye = map.y(:, 2);
% Ry = state(2);
% Ym = Ry + Constant.SensorRange * sin(state(3) + measured_angle);
%
% % Calculation of temporary variable
% % a = (Ry - Ym)./(Rx - Xm);
% % b =1;
% % c = Ry - a*Rx;
% % Yp = (a.*map.c - map.a.*c)./(map.a*b - a.*map.b);
% % Xp = (map.c./map.a) + (map.b./map.a).*Yp;
% x_line = Xs - Xe;
% y_line = Ys - Ye;
% x_laser = Xm - Rx;
% y_laser = Ym - Ry;
% x_end = Rx - Xe;
% y_end = Ry - Ye;
% delta = x_laser .* y_line - x_line .* y_laser;
% % Calculation of internal ratio
% % sigma = CalcDistance(Xp,Yp,Rx,Ry)./(CalcDistance(Xp,Yp,Rx,Ry)+CalcDistance(Xm,Ym,Xp,Yp));
% % mu = CalcDistance(Xp,Yp,Xe,Ye)./(CalcDistance(Xp,Yp,Xe,Ye)+CalcDistance(Xp,Yp,Xs,Ys));
% sigma = (y_end .* x_line - y_line .* x_end) ./ delta;
% mu = (x_laser .* y_end - x_end .* y_laser) ./ delta;
% % Calculation of laser distance
% dist = sigma .* Constant.SensorRange;
% % Change the value which fail validation to Invalid value
% cond_1 = (sigma >= 0 & sigma <= 1 & mu >= 0 & mu <= 1 & dist >= 0 & dist <= Constant.SensorRange & (abs(dist - measured_distance) < Constant.DistanceThreshold));
% dist(~cond_1) = inf;
% % Searching minimum distance for each laser
% [min_dist, min_index] = min(dist);
% inf_cond = isinf(min_dist);
% min_dist(inf_cond) = 0;
% min_index(inf_cond) = 0;
% % assign returuning value by calculated value
% parameter.index = min_index;
% parameter.distance = min_dist;
end
% function Dis = CalcDistance(x1,y1,x2,y2)
% %calculate Euclidean distance
% Dis = sqrt( (x1-x2).^2 + (y1-y2).^2);
% end