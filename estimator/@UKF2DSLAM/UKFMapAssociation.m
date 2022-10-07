function parameter = UKFMapAssociation(obj,state,Lines,EndPoint, L, La)
% state : ビークルの(事前)推定状態 : global
% Lines : mapの(事前)推定値 : global
% EndPoint : line 端点座標
% L : レーザー計測距離
% La : レーザー照射角度 : 絶対座標にしてある．
% C :各種定数
% NLP : number of line parameter
% TODO : min_dist ~= min_dist2 による違いを探る
C = obj.constant;
NLP = obj.NLP;
PreMap = obj.MapStateToLineEqu(Lines,NLP);
map.a = PreMap.a;
map.b = PreMap.b;
map.c = PreMap.c;
map.x = EndPoint.x;
map.y = EndPoint.y;
% Initialize each variable
association_size = length(L);
parameter.index = zeros(association_size, 1);
%parameter.sign = zeros(association_size, 1);
% Define variable about start and end point of map and laser
Xs = map.x(:, 1);
Xe = map.x(:, 2);
Rx = state(1);
%Xm = Rx + C.SensorRange * cos(state(3) + La);
Xm = Rx + C.SensorRange * cos(La).*(La~=0);
Ys = map.y(:, 1);
Ye = map.y(:, 2);   
Ry = state(2);
%Ym = Ry + C.SensorRange * sin(state(3) + La);
Ym = Ry + C.SensorRange * sin(La).*(La~=0);
% Calculation of temporary variable
x_line = Xs - Xe;
y_line = Ys - Ye;
x_laser = Xm - Rx;
y_laser = Ym - Ry;
x_end = Rx - Xe;
y_end = Ry - Ye;

delta = x_laser .* y_line - x_line .* y_laser;
% Calculation of internal ratio
sigma = (y_end .* x_line - y_line .* x_end) ./ delta;%レーザが壁と持つ内分比
mu = (x_laser .* y_end - x_end .* y_laser) ./ delta;%壁とレーザの内分比
% Calculation of laser distance
Dis = sigma .* C.SensorRange;
%Calculation
DisStart = sqrt((Xs - Rx).^2 + (Ys - Ry).^2);
DisEnd = sqrt((Xe - Rx).^2 + (Ye - Ry).^2);
MaxDisP = max([DisStart,DisEnd]')';%遠い方の端点との距離を計算
% Change the value which fail validation to Invalid value
%sigmaが0より大きく1より小さい，muが0より大きく1より小さい，
%理論距離(dist)が0より大きくセンサレンジより小さい，
%理論距離と測定距離の差が閾値より小さい
%遠いほうの端点よりも距離が近い
conditionRation = (sigma > 0 & sigma < 1 & mu > 0 & mu < 1 ...
    & Dis >= 0 & Dis <= C.SensorRange & (abs(Dis - L) < C.DistanceThreshold)...
    &  L > C.DistanceThreshold);
Dis(~conditionRation) = inf;
% Searching minimum distance for each laser

[min_dist, min_index] = min(Dis);
inf_cond = isinf(min_dist);
min_dist(inf_cond) = 0;
min_index(inf_cond) = 0;
%condition re calculate
Ts = atan2(Ys - Ry,Xs -Rx);% - state(3);%reference point as front of robot for theta start point 
Te = atan2(Ye - Ry,Xe -Rx);% - state(3);%theta end point
TJudge = abs(Ts - Te) < pi;%レーザの始点と終点の角度がpi以上大きいかを判断，大きい場合はチェックルールが変わる．
[~,Tsidx] = min(abs(Ts - La),[],2);%ロボットと端点の始点の直線に最も近い角度を持つレーザのインデックス
[~,Teidx] = min(abs(Te - La),[],2);%ロボットと端点の終点の直線に最も近い角度を持つレーザのインデックス
[Tmin,~] = min([Tsidx,Teidx],[],2);%小さい方のインデックス
[Tmax,~] = max([Tsidx,Teidx],[],2);%デカい方のインデックス
%各直線に対応付けされたレーザを表示
%---対応付けされている直線を表示---%
Elements = nonzeros(min_index);
ei = 1;
Estock = [];
while ei <length(Elements)
    stock = min(Elements);
    Elements = Elements(stock ~= Elements);
    Estock = [Estock,stock];
end
%-------------------------------%
for ci = 1:length(Estock)
    FTidx = find(min_index==Estock(ci));%壁に対応付けされたレーザのインデックス
    if TJudge(ci) == false
        Overidx = Tmin(ci)<FTidx & Tmax(ci)>FTidx;%条件に合わないレーザの探索
        min_index(Overidx) = 0;%条件に合わないレーザをはじく
    else
        Overidx = 0>FTidx & FTidx<Tmin(ci) | Tmax(ci)>FTidx & FTidx<length(La);
        min_index(Overidx) = 0;%
    end
end
% assign returuning value by calculated value

% 以下のやり方だとx1-x2線分の内分になることは決まるが，原点-x3線分の中に入るかわからないので
% ２か所から適用することで両線分の内分である場合のみを抽出
% 線分終点から見た位置
x2 = Rx - Xe; % ロボット位置
y2 = Ry - Ye;
x1 = Xm - Xe; % 何にも当たらなかった時のレーザー端点位置
y1 = Ym - Ye;
x3 = Xs - Xe; % 線分始点の位置
y3 = Ys - Ye;
% sigma = 壁までの距離/レーザーレンジ ：1:2=1-k:kの内分点が3までの直線上にあるための条件として以下の解sigma = k
% solve(det([(k*x1+(1-k)*x2),(k*y1+(1-k)*y2);x3 y3])==0,k)
tmp= (x1.*y3 - x3.*y1 - x2.*y3 + x3.*y2); 
tmp(abs(tmp)<=1e-5) = Inf;
sigma = -(x2.*y3 - x3.*y2)./tmp;
sigma(sigma<=0|sigma>=1) = Inf;
sigma1 = sigma;
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
Dis = sigma .* C.SensorRange;
[min_dist2, min_index2] = min(Dis);
%del_ids=min_dist2 < 1e-3 | min_dist2==Inf | min_dist2 > C.SensorRange;
del_ids = min_dist2 ==Inf;
min_index2(del_ids)=0;
min_dist2(del_ids) =0;
parameter.id = min_index2;
parameter.d = min_dist2;
end
