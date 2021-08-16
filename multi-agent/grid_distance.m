function d = grid_distance(i1,i2,nx,ny)
% distance between i1 and i2 on the nx-ny grid
% i1 : position index (scalar)
% i2 : position index (vector)
% nx, ny : size of grid
% % p1y = rem(i1,ny);
% % p1x = (i1-p1y)/ny+1;
% % p2y = rem(i2,ny);
% % p2x = (i2-p2y)/ny+1;
% % % i = (px - 1)*ny + py
[p1x,p1y]=ind2sub([nx,ny],i1);
[p2x,p2y]=ind2sub([nx,ny],i2);
%d = max(abs(p2y - p1y),abs(p2x - p1x)); %
%斜め移動も可能な場合の升目距離:[1,1]から[4,2]の場合に[2,0]経由も可という問題
d = abs(p2y - p1y)+abs(p2x - p1x); % 斜め移動も可能な場合の升目距離
end

