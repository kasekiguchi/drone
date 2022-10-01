function parameter = UKFCombiningTwoLines(obj,index_map, s, index_s)
% index_map : focused line index in map
% s : estimator.LSA_param in UKFSLAM
% index_s : target line index in s
% map = obj.map_param;
% map(index_map) と s(index_s) をくっつける
% map : estimated map : estimator.map_param in UKFSLAM
map = obj.map_param;
l1 = [map.x(index_map,:)',map.y(index_map,:)'];
l2 = [s.x(index_s,:)',s.y(index_s,:)'];
L = [l1;l2];
T=[min(L,[],1);max(L,[],1)]; % [xmin,ymin;xmax,ymax]
[~,id]=max(T(2,:)-T(1,:));% max-minが大きい軸を抽出
% 抽出した軸の最大，最小をとるインデックス抽出
[~,idm] = min(L(:,id));
[~,idM] = max(L(:,id));
T = [L(idm,:);L(idM,:)];
parameter.x = T(:,1)';
parameter.y = T(:,2)';
end
