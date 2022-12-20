function segment = extract_max_line_segment(L)
% 同一直線上の点群から最大線分を抽出
% L : [x1,y1;x2,y2;...]
% 前提：全て同一直線上の点

T=[min(L,[],1);max(L,[],1)]; % = [xmin,ymin;xmax,ymax]
[~,id]=max(T(2,:)-T(1,:));% max-minが大きい軸を抽出
% 抽出した軸の最大，最小をとるインデックス抽出
[~,idm] = min(L(:,id));
[~,idM] = max(L(:,id));
T = [L(idm,:);L(idM,:)];
segment.x = T(:,1)';
segment.y = T(:,2)';
end
