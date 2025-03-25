function [H,f] = gen_Hf(X,U,Y,dt,F)
N = size(X,2);
tmp = F([X(:,1);U(:,1)]);
n = size(tmp,1);
m = size(U,1);
xxT = zeros(n,n);
xuT = zeros(n,m);
uuT = zeros(m,m);
xy = zeros(n^2,1);
uy = zeros(n*m,1);
for i =1:N
  u = U(:,i);
  x = F([X(:,i);u]);
  y = F([Y(:,i);u]);
  xxT = xxT + x*x';
  xuT = xuT + x*u';
  uuT = uuT + u*u';
  xy = xy - reshape(x*y',[],1);
  uy = uy - reshape(u*y',[],1);
end

txxT = arrayfun(@(i) xxT,1:n,'UniformOutput',false);
txuT = arrayfun(@(i) xuT,1:n,'UniformOutput',false);
tuuT = arrayfun(@(i) uuT,1:n,'UniformOutput',false);
tH = [blkdiag(txxT{:}),blkdiag(txuT{:});blkdiag(txuT{:})',blkdiag(tuuT{:})];
tf = [xy;uy];

%% constraint
dt_ids = [7,8,9] + (0:2)*n;
z_ids = [1:3*n,n^2+1:n^2+3*m];
H = tH;
H(z_ids,:) = [];
H(:,z_ids) = [];
f = tf;
ttH = tH(:,dt_ids)*dt;
f(z_ids,:) = [];
ttH(z_ids,:) = [];
f = f+ sum(ttH,2);
end