function [ES,EF,WS,WF] = gen_edge(obj,wind)
% Make a graph for nx-ny grid with weight generated by gen
% gen(x,y) generates weight at (x,y)
%   high value means high possibility to burn
%   gen must work with matrix arguments,that is x or y possible to choose as
%   a matrix.
% maxv : max probability, 300m尺度で0.04が目安
% obj.m_per_grid : map scale, obj.m_per_grid=dなら1セルd m
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
end
N = obj.N;
wind1 = wind(:,1);
wind2 = wind(:,2); % m/s
th = (pi/180) * wind1 + pi;  % wind direction : to cancel meshgrid effect, pi is added.
Rth = [cos(th), sin(th);-sin(th),cos(th)];
%% spreading fire
sigmaWS = [1/3,2/3,1]; % area for spreading fire
%probWS = [0.6827,0.9545,1]
%weightWS = [68.27,(95.45-68.27),(100-95.45)]; % weight for spreading area
weightWS = [8.5074    1.1734    0.1467];
% area k has k-sigma weight

% spreading region
cx = obj.nx*obj.m_per_grid/2; cy = obj.ny*obj.m_per_grid/2; % center
s_th = -pi:0.1:pi; % spreading fire angle : shape = egg shape
WS = sparse(N,N);

ns = obj.flag.ns;
r0 = obj.sm/0.6; % 0.6 is a default egg shape length
r = (obj.m_per_grid/obj.sm)*r0*wind2;
for k = 1:3 % classification on spreading magnitude
  % circle（卒論）
  %     xv3 = r * sin(s_th);
  %     yv3 = -r * cos(s_th);

  % egg shape
  % xv = r * cos(s_th./4).*sin(s_th);
  % yv = -r * cos(s_th) + r/6;
  [xv,yv] = egg_shape(r*sigmaWS(k),s_th,1);
  cyc = Rth*[xv;yv]; % CW rotation
  xv = cyc(1,:) + cx - obj.m_per_grid/2; % the last term cancels discretization as grid 
  yv = cyc(2,:) + cy;

  WS = WS + gen_E(xv,yv,obj.nx,obj.ny,obj.xq,obj.yq,weightWS(k));
end
if obj.flag.debug
  WW=reshape(WS(:,floor(1.01*N/2)),obj.nx,obj.ny);
  surf(obj.xq,obj.yq,WW);
  legend("x","y","z");
  view(2);daspect([1 1 1]);
  disp("延焼の隣接行列が生成完了しました");
end
%% flying fire
nf1 = obj.flag.nf(1);
nf2 = obj.flag.nf(2);
nf3 = obj.flag.nf(3);

windv = nf1 * (1/obj.m_per_grid)*wind2; % TODO : 要確認 grid/s ?

% base rhombus
x1 = 0; x2 = 1.5; x3 = -x2;
y1 = 0; y2 = 0.5; y3 = 2*y2;

xv = nf2*wind2*[x1 x2 x1 x3 x1];
yv = nf2*wind2*[y1 y2 y3 y2 y1];

cyc = Rth*[xv;yv]; % CW rotation
xv = cyc(1,:) + cx + windv*sin(th);
yv = cyc(2,:) + cy + windv*cos(th);

WF = gen_E(xv,yv,obj.nx,obj.ny,obj.xq,obj.yq,1);
if obj.flag.debug
  WW=reshape(WF(:,floor(1.01*N/2)),obj.nx,obj.ny);
  surf(obj.xq,obj.yq,WW);
  legend("x","y","z");
  view(2);daspect([1 1 1]);
  disp("飛び火の隣接行列が生成完了しました");
end

% 火災警報（消防法第２２条気象状況の通報及び警報の発令）の発令条件より
% https://www.fdma.go.jp/singi_kento/kento/items/kento187_46_shiryo6-1.pdf
if wind2 >= 7 % % TODO : wind speedに対して連続性を担保すべき
  WS = wind2.*WS;
  WF = wind2.*WF;
elseif wind2 < 7 && wind2 > 0
  WS = (wind2/10).*WS;
  WF = (wind2/10)^2.*WF;
else
  disp("wind speed should be 0 or larger.");
end
% WS, WFの正規化
WS = ns*0.02*WS/max(WS,[],'all');% 0.02 is a tunned value to be 80 m /h under 10 m/s wind
WF = nf3*WF/max(WF,[],'all');

W = reshape(obj.W,[],1); % grid weight
maxW = max(W);
ES = WS.*W/maxW;
EF = WF.*W/maxW;
ES = sparse(ES);
EF = sparse(EF);

if obj.flag.debug
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
function [x,y] = egg_shape(r,th,w)
% egg shape
% https://nyjp07.com/index_egg.html
  a = w*r;
  b = a*0.5;
  x = (b*(1-cos(th))/4-a/2).*sin(th);
  y = (b*(1-cos(th))/4-a/2).*(1+cos(th)) + 0.6*a;
end