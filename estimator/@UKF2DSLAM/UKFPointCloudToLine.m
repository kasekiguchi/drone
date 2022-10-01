function parameter = UKFPointCloudToLine(obj,D, A, S)
% 点群データをクラスタリングして直線の方程式に変換する関数
% レーザセンサのデータ形式としてレンジ外のものは0値を出すと仮定
% 論文の3.2.1および3.2.2に該当
% D : A に対応した距離
% A : 絶対座標で表したLaser照射角度
% S : state
% C : 各種定数
% [output] parameter は以下のフィールドを持つ
% a,b,c : 直線のパラメータ
% x, y : 各行[始点, 終点] のx, y 座標
% index : 各行[始点, 終点] のレーザーindex

C = obj.constant;

% 以下10程度のデータで確認してみること
%D = [3:0.1:3.2,4:0.1:4.3,2.8:0.1:3];
Dn = circshift(D,-1);
dD = Dn - D; % 要素i はD(i+1) - D(i), 最後だけ D(1) - D(end)
gids = abs(dD) > C.CluteringThreshold; % gap indices
%dDn = circshift(dD,-1);
%gids = abs(dDn-dD) > C.CluteringThreshold;
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
elseif eids(end) > length(D)
    eids(end) = eids(end)-1;
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
k = 1; % 直線の数 ~= クラスタの数
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

    %while s+1.5*d <= e
    while s+d <= e
        %s = s + floor(d/2);
        t = linefit(XY(s:s+d,:)); % tmp line
        f = abs(t(1).*XY(s+d+1:end,1) + t(2).*XY(s+d+1:end,2) + t(3)); % 直線までの射影距離
        tid = find(f > C.LineThreshold,1); % ラインから外れている点の id = s + d + tid
        ns = s+d;
        if isempty(tid) % ラインから外れている点が無くなればクラスタの最後までの点を使って直線を導出
            ns = e;
            t = linefit(XY(s:ns,:)); % tmp line
        else
            while tid > 1
                ns = ns + tid - 1;% -1; % 外れている点のひとつ前まではlineに含む
                t = linefit(XY(s:ns,:)); % tmp line
                f = abs(t(1).*XY(ns+1:end,1) + t(2).*XY(ns+1:end,2) + t(3)); % 直線までの射影距離
                tid = find(f > C.LineThreshold,1); % ラインから外れている点の id = s + d + tid
                if isempty(tid) % ラインから外れている点が無くなればクラスタの最後までの点を使って直線を導出
                    ns = e;
                    t = linefit(XY(s:ns,:)); % tmp line
                end
            end
        end
        l(k,:) = t;
        lc(k) = i;
        perp = projection(l(k,:),[XY(s,:);XY(ns,:)]);
        X(k,:) = perp(:,1)';%[XY(s,1),XY(ns,1)];
        Y(k,:) = perp(:,2)';%[XY(s,2),XY(ns,2)];
        index(k,:) = [s0+s,s0+ns];
        k = k+1;
        s = ns + 1;
    end
    %    end
end

% 適切に求まらなかった直線を削除 % TODO : そもそも何で生じるのか確認
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
parameter.index = mod(index,length(D));

end

function l = p2l(XY) % TODO : 使っていない
% XY = [x1 y1;x2 y2] を通る直線(a,b,c)を返す
% x1 = x2 かつ y1 = y2 という点は想定しない．
tmpid = abs(XY(1,:)-XY(2,:)) < 1e-3;
if sum(tmpid) == 0 % x + by + c =0
    l = [1,([XY(:,2),[1;1]]\(-XY(:,1)))'];
else % x = c or y = c
    l = [-tmpid,XY(1,tmpid)];
end
end

