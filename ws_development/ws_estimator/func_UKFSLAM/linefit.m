function l = linefit(XY)
% XY : 1列目がx, 2列目がy に関するデータ
% 最小二乗近似で直線の式(a,b,c)を算出
% l = [a,b,c]
% [a,b] のノルムが1に正規化してある．
v = var(XY); % 分散
tmpid = v < 1e-3;
if sum(tmpid) == 0 % x + by + c = 0
    l = [1,(pinv([XY(:,2),ones(size(XY,1),1)])*(-XY(:,1)))'];
else  % x = c or y = c
    [~,tmpid] = min(v);
    tmpid = [1:2]==tmpid;
    l = [-tmpid,mean(XY(:,tmpid))];
end
l = l/vecnorm(l(1:2));
end
