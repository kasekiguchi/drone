function [ES,EF] = gen_edge(obj,wind,flag)
% Make a graph for nx-ny grid with weight generated by gen
% gen(x,y) generates weight at (x,y)
%   high value means high possibility to burn
%   gen must work with matrix arguments,that is x or y possible to choose as
%   a matrix.
% maxv : max probability, 300m尺度で0.04が目安
% obj.map_scale : map scale, obj.map_scale=dなら1セルd m
% ES : edge matrix for spreading fire
% EF : edge matrix for flying fire
% E = ES+EF : edge matrix : N-N size matrix where N = nx*ny
% eij : (i,j) element of E
% eij > 0 if edge exists from j to i else eij = 0
% W : weight matrix : nx-ny size matrix
% wind1 : 風向(32方位) , wind2 : 風速
% build : モデルのタイプ　3，延焼速度調整モード
arguments
  obj
  wind
  flag
end
N = obj.N;
wind1 = wind(:,1);
wind2 = wind(:,2); % m/s
th = (pi()/180) * wind1 + pi;  % wind direction : to cancel meshgrid effect, pi is added.
%% spreading fire
spread = 3; % classification on spreading magnitude
sigmaWS = [68.27,(95.45-68.27),(100-95.45)]; % weight for spreading area 
% area k has k-sigma weight

n4 = 1.2;   % 延焼倍率（0.01刻みで適当な定数で調整，卒論再現の正円の場合は0.99，ジャーナルは1.2）
nx0 = obj.nx/2; ny0 = obj.ny/2; % 中心
t2 = -pi:0.1:pi; %
WS = sparse(N,N);

for k = 1:spread
  r = k * n4 * (1.1 + 1/k^2) * sqrt(wind2/10); % TODO : 半径 意味
  %     xv3 = r * sin(t2);  %正円Verのx（卒論）
  %     yv3 = -r * cos(t2); %正円Verのy（卒論）
  xv = r * cos(t2./4).*sin(t2);    %卵型Verのx
  yv = -r * cos(t2) + r/6;         %卵型Verのy
  % 回転項
  cyc = [cos(th), sin(th);-sin(th),cos(th)]*[xv;yv]; % CW rotation
  xv = cyc(1,:) + nx0;
  yv = cyc(2,:) + ny0;

  [xq,yq] = meshgrid(1:1:obj.nx);
  WS = WS + gen_E(xv,yv,obj.nx,obj.ny,xq,yq,sigmaWS(spread));
end
if flag.debug
WW=reshape(WS(:,floor(1.01*N/2)),obj.nx,obj.ny);
[xq,yq] = meshgrid(1:obj.nx);
surf(xq,yq,WW);
legend("x","y","z");
view(2);daspect([1 1 1]);
disp("延焼の隣接行列が生成完了しました");
end
%% 飛び火用隣接行列
windv = round(obj.nx/obj.map_scale) * (0.075 * wind2); % TODO : 要確認 grid/s ?

% base rhombus
x1 = 0; x2 = 1.5; x3 = -x2;
y1 = 0; y2 = 0.5; y3 = 2*y2;

n1 = wind2 * 1.2;
xv = n1*[x1 x2 x1 x3 x1];
yv = n1*[y1 y2 y3 y2 y1];

cyc = [cos(th), sin(th);-sin(th),cos(th)]*[xv;yv]; % CW rotation
xv = cyc(1,:) + nx0 + windv*sin(th);
yv = cyc(2,:) + ny0 + windv*cos(th);

[xq,yq] = meshgrid(1:1:obj.nx);
WF = gen_E(xv,yv,obj.nx,obj.ny,xq,yq,1);
if flag.debug
WW=reshape(WF(:,floor(1.01*N/2)),obj.nx,obj.ny);
surf(xq,yq,WW);
legend("x","y","z");
view(2);daspect([1 1 1]);
disp("飛び火の隣接行列が生成完了しました");
end

FlyTune = 1.5;   % (手動糸魚川の場合：風一定1.5，風細分化:1.0)

% 火災警報（消防法第２２条気象状況の通報及び警報の発令）の発令条件より
% https://www.fdma.go.jp/singi_kento/kento/items/kento187_46_shiryo6-1.pdf
if wind2 >= 7 % 
  WS = sqrt(wind2/10) .* WS;
  WF = sqrt(wind2/10) .* WF * FlyTune;
elseif wind2 < 7 && wind2 > 0
  WS = (wind2/10) .* WS;
  WF = (wind2/10)^2 .* WF * FlyTune;
else
  disp("wind speed should be 0 or larger.");
end

W = reshape(obj.W,[],1); % grid weight
ES = WS .* W; 
EF = WF .* W;
ES = sparse(ES);
EF = sparse(EF);

maxW = max(W);
if maxW > 1 | obj.maxv~=1
  ES = (obj.maxv*ES/maxW);
  EF = (obj.maxv*EF/maxW);
end
if flag.debug
WW=reshape(ES(:,floor(1.01*N/2)),obj.nx,obj.ny);
surf(xq,yq,WW);
surf(xq,yq,obj.W);
legend("x","y","z");
view(2);daspect([1 1 1]);
disp("complete generating ES EF");
end
end

function W = gen_E(xv,yv,nx,ny,xq,yq,weight)
N = nx*ny;

in = inpolygon(xq,yq,xv,yv);
in = logical(in);

[row0,col0]=ind2sub([nx,ny],find(in));
Row = row0' + (1:ny)' - ny/2;
Col = col0' + (1:nx)' - nx/2;
Row(Row>ny | Row<1) = NaN;
Col(Col>nx | Col<1) = NaN;
Rows = repmat(Row,nx,1);
Cols = kron(Col,ones(ny,1));
Inds = sub2ind([nx,ny],Rows,Cols);
Wr = repmat((1:N)',size(Inds,2),1);
Wc = reshape(Inds,[],1);
Wr(isnan(Wc)) = [];
Wc(isnan(Wc)) = [];
Wv = weight*ones(size(Wc));
W = sparse(Wr,Wc,Wv,N,N);
end