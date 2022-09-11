function parameter = UKFPointCloudToLine(LaserDis, LaserAngle, State, Constant)
% 点群データをクラスタリングして直線の方程式に変換する関数
% レーザセンサのデータ形式としてレンジ外のものは0値を出すと仮定
% 論文の3.2.1および3.2.2に該当
% LaserDis : LaserAngle に対応した距離
% LaserAngle : 絶対座標で表したLaser照射角度
% State : 状態
% Constant : 各種定数
% [output] parameter は以下のフィールドを持つ
% a,b,c : 直線のパラメータ 
% x, y : 各行[始点, 終点] のx, y 座標
% index : 各行[始点, 終点] のレーザーindex

D = LaserDis;
A = LaserAngle;
S = State;
C = Constant;

% 以下10程度のデータで確認してみること
%D = [3:0.1:3.2,4:0.1:4.3,2.8:0.1:3];
Dn = circshift(D,-1);
dD = Dn - D; % 要素i はD(i+1) - D(i), 最後だけ D(1) - D(end)
gids = abs(dD) > C.CluteringThreshold; % gap indices
zids = D==0; % zero indices

cids = find(~(gids | zids));% 次の点とつながるインデックス：連続している塊がクラスタ
cnids = circshift(cids,-1);
cpids = circshift(cids,1);
eids = cids(find((cnids - cids)~=1))+1; % クラスタ終わりインデックス 
tmp = (cids - cpids);
sids = cids(find(tmp~=1)); % クラスタ始めインデックス
fLoop = 0;
if tmp(sids(1)) == 1 - length(D)% ループしているか判別 : true でループ
    fLoop = 1;
    sids(1) = [];
    eids(end) = [];
    eids = circshift(eids,-1);
end
Lc = eids - sids + 1; % クラスタ長さ
if fLoop
    Lc(end) = length(D) + Lc(end);
end

% クラスタを構成する最小点群数以下のクラスタを削除
tmpid=find(Lc<C.GroupNumberThreshold);
sids(tmpid) = [];
eids(tmpid) = [];
Lc(tmpid) = [];

% クラスタ毎に直線を求める
d = C.GroupNumberThreshold;
k = 1;
lc = []; % lineがどのクラスタに属するか
for i = 1:length(Lc)
    s0 = sids(i);
    e0 = eids(i);
    if s0 > e0 % loopしている場合
        XY = ([D(s0:end),D(1:e0)].*[cos([A(s0:end),A(1:e0)]);sin([A(s0:end),A(1:e0)])])';
    else
        XY = (D(s0:e0).*[cos(A(s0:e0));sin(A(s0:e0))])';
    end
    s = 1;
    e = Lc(i); % s0 + e = e0 % 以降eは固定

    % あたりを付ける
%     xy = XY([1,1+d],:);%(D([s,s+d]).*[cos(A([s,s+d]));sin(A([s,s+d]))])';
%     l = p2l(xy);
%     xye = XY(end,:);%D(e)*[cos(A(e)),sin(A(e))];
%     if abs(l*[xye, 1]') < C.CluteringThreshold % クラスタが一つの直線の場合
%         l(k,:) = linefit(XY);
%         lc(k) = i;
%         X(k,:) = [XY(1,1),XY(end,1)];
%         Y(k,:) = [XY(1,2),XY(end,2)];
%         index(k,:) = [s0,e0];
%         k = k+1;
%     else % 複数直線がある場合
        while s+d <= e
            t = linefit(XY(s:s+d,:)); % tmp line           
            f = abs((t(1).*XY(s+d+1:end,1) + t(2).*XY(s+d+1:end,2) + t(3))/vecnorm(t(1:2))); % 直線までの射影距離
            tid = find(f > C.LineThreshold,1); % ラインから外れている点の id = s + d + tid
            if isempty(tid) % ラインから外れている点が無くなればクラスタの最後までの点を使って直線を導出
                ns = e;
%                 l(k,:) = linefit(XY(s:e,:));
%                 lc(k) = i;
%                 X(k,:) = [XY(s,1),XY(e,1)];
%                 Y(k,:) = [XY(s,2),XY(e,2)];
%                 index(k,:) = [s0+s,e0];
%                 k = k+1;
%                 s = e;
            else
                ns = s+d+tid -1; % 外れている点のひとつ前まではlineに含む
            end
            l(k,:) = linefit(XY(s:ns,:)); 
            lc(k) = i;
            X(k,:) = [XY(s,1),XY(ns,1)];
            Y(k,:) = [XY(s,2),XY(ns,2)];
            index(k,:) = [s0+s,s0+ns];
            k = k+1;
            s = ns + 1;
        end
%    end
end

%     %% Clustering
%     % 非ゼロの値をさがす
%     Startidx = 1;% index of start point of before search
%     while LaserDis(Startidx) < Constant.ZeroThreshold
%         Startidx = Startidx + 1;
%     end
%     % Initialize each variable
%     index_list = []; % index list
%     SegmentFlag = 2; % 1:searching start point, 2:searching end point
%     i = Startidx + 1; % loop-counter 
%     while 1
%         % Searching 'zero value' or 'separated from the distance one before'
%         if SegmentFlag == 2 && (LaserDis(i) < Constant.ZeroThreshold || abs(LaserDis(i) - LaserDis(i - 1)) > Constant.CluteringThreshold)
%             % Saving the index and changing mode
%             index_list(end + 1, :) = [Startidx, i - 1];
%             SegmentFlag = 1;
%             % i-th value may be available. so, variable 'i' is not increment.
%             continue;
%         % Searching non-zero value
%         elseif SegmentFlag == 1 && LaserDis(i) > Constant.ZeroThreshold
%             % Saving the index and changing mode
%             Startidx = i;
%             SegmentFlag = 2;
%         end
%         i = i + 1;
%         if i > length(LaserDis)
%             % If terminal value is available, appending the index to list
%             if SegmentFlag == 2
%                 index_list(end + 1, :) = [Startidx, length(LaserDis)];
%             end
%             break;
%         end
%     end
%     %% Making the line
%     % Calculation of a and b which means "y = a*x + b"
%     x = State(1) + LaserDis(index_list) .* cos(LaserAngle(index_list));% + State(3));
%     y = State(2) + LaserDis(index_list) .* sin(LaserAngle(index_list));% + State(3));
%     diff_x = x(:, 2) - x(:, 1);
%     a = (y(:, 2) - y(:, 1)) ./ diff_x;
%     % If x(:, 2) and x(:, 1) is same, 'diff_x' is nan. Nan is not able to caluculate.
%     a(abs(diff_x) < Constant.ZeroThreshold) = 1e10;
%     b = ones(size(a));
%     c = y(:, 1) - a .* x(:, 1);
%     % Separating the cluster using the distance from line drawing start and end point in the cluster
%     i = 1;
%     parameter.x = zeros(0, 2);
%     parameter.y = zeros(0, 2);
%     while true
%         % Caluculation of coordinate of the measutement
%         dist = LaserDis(index_list(i, 1) : index_list(i, 2));%indexに格納されているあるクラスタのレーザ距離
%         ang = LaserAngle(index_list(i, 1) : index_list(i, 2));%indexに格納されているあるクラスタのレーザ角度
%         x_0 = State(1) + dist .* cos(ang);% + State(3));%クラスタ点群のx座標
%         y_0 = State(2) + dist .* sin(ang);% + State(3));%クラスタ点群のy座標
%         % Caluculation of the distance between the line and the measurement
%         d = abs(a(i) * x_0 - y_0 + c(i)) ./ sqrt(a(i)^2 + 1);%算出した直線とその直線を算出するのに用いたクラスタ点群の距離
%         % Finding the maximum value and its index
%         [val, idx] = max(d);%最大距離算出
%         % Changing the beginning index from 1 to global
%         idx = idx + index_list(i, 1) - 1;
%         if val > Constant.PointThreshold%最大距離が閾値以上だったら
%             % Caluculation of new coefficient in "y = a*x + b"
%             new_index = [index_list(i, 1), idx; idx, index_list(i, 2)];%インデックスを分割
%             x = State(1) + LaserDis(new_index) .* cos(LaserAngle(new_index));% + State(3));%点群位置算出
%             y = State(2) + LaserDis(new_index) .* sin(LaserAngle(new_index));% + State(3));
%             diff_x = x(:, 2) - x(:, 1);%点群の変位を算出
%             new_a = (y(:, 2) - y(:, 1)) ./ diff_x;
%             new_a(abs(diff_x) < Constant.ZeroThreshold) = 1e10;
%             new_c = y(:, 1) - new_a .* x(:, 1);
%             % Updating the list of the cluster
%             index_list = [index_list(1:(i - 1), :); new_index; index_list((i + 1):end, :)];
%             a = [a(1:(i - 1)); new_a; a((i + 1):end)];
%             c = [c(1:(i - 1)); new_c; c((i + 1):end)];
%         else
%             [a(i), b(i), c(i), parameter.x(i, :), parameter.y(i, :)] = LinearizePoints(x_0, y_0);
%             parameter.x_raw{i, 1} = x_0;%端点のx座標
%             parameter.y_raw{i, 1} = y_0;%端点のy座標
%             i = i + 1;
%         end
%         % If separating the cluster is finished, i breaks the loop.
%         if i > size(a, 1)
%             break;
%         end
%     end

    % 適切に求まらなかった直線を削除
            tmpid=sum([X,Y],2)==0; 
            X(tmpid,:) = [];
            Y(tmpid,:) = [];
            l(tmpid,:) = [];
            lc(tmpid) = [];
            index(tmpid,:) = [];
    
    % Store the parameters
    % body 座標から慣性座標に変換（姿勢については考慮済みなので平行移動する）
    d = l*[-S(1:2);1];
    parameter.l = [l(:,1:2),d];
    parameter.cluster = lc; % line l(i) belongs to cluster(i)
    parameter.a = l(:,1);
    parameter.b = l(:,2);
    parameter.c = d;
    parameter.x = X + S(1)*[1,1];
    parameter.y = Y + S(2)*[1,1];
    parameter.index = index;
    
%     parameter.index = index_list;
%     parameter.a = a;
%     parameter.b = b;
%     parameter.c = c;
end

function l = p2l(XY)
% XY = [x1 y1;x2 y2] を通る直線(a,b,c)を返す
% x1 = x2 かつ y1 = y2 という点は想定しない．
    tmpid = abs(XY(1,:)-XY(2,:)) < 1e-3;
    if sum(tmpid) == 0 % x + by + c =0
        l = [1,([XY(:,2),[1;1]]\(-XY(:,1)))'];
    else % x = c or y = c  
        l = [-tmpid,XY(1,tmpid)]; 
    end
end

function l = linefit(XY)
% XY : 1列目がx, 2列目がy に関するデータ
% 最小二乗近似で直線の式(a,b,c)を算出
% 前提：データは順番に並んでいる
    v = var(XY); % 分散
    tmpid = v < 1e-3;
%    tmpid = abs(XY(1,:)-XY(end,:)) < 1e-3;
    if sum(tmpid) == 0 % x + by + c =0
        l = [1,(pinv([XY(:,2),ones(size(XY,1),1)])*(-XY(:,1)))'];
    else % x = c or y = c  
        l = [-tmpid,mean(XY(:,tmpid))];
    end
    if length(l) == 4
        error("ACSL : line fit error");
    end
end