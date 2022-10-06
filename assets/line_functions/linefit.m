function l = linefit(XY)
% XY : 1列目がx, 2列目がy に関するデータ
% 最小二乗近似で直線の式(a,b,c)を算出
% l = [a,b,c]
% [a,b] のノルムが1, c < 0 
% readme.md 参照
A = cov(XY); % 共分散行列
[ab,~]=eig(A);
c = -sum(XY,1)*ab(:,1)/size(XY,1);
if c <= 0
    l = [ab(1),ab(2), c];
else
    l = -[ab(1),ab(2), c];
end
% v = var(XY);
% tmpid = v < 1e-3;
% if sum(tmpid) == 0 % x + by + c = 0
%     l = [1,(pinv([XY(:,2),ones(size(XY,1),1)])*(-XY(:,1)))'];
% else  % x = c or y = c
%     [~,tmpid] = min(v);
%     tmpid = [1:2]==tmpid;
%     l = [-tmpid,mean(XY(:,tmpid))];
% end
% l = l/vecnorm(l(1:2));
end
