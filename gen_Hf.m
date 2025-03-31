function [H,f] = gen_Hf(X,U,Y,dt,F)
% function [xxT,xuT,uuT,xy,uy] = gen_Hf(X,U,Y,dt,F)
N = size(X,2);
tmp = F([X(:,1);U(:,1)]);
n = size(tmp,1);
m = size(U,1);
xxT = zeros(n,n);
xuT = zeros(n,m);
uuT = zeros(m,m);
xy = zeros(n^2,1);
uy = zeros(n*m,1);
disp("Total: "); N

for i =1:N
  u = U(:,i);
  x = F([X(:,i);u]);
  y = F([Y(:,i);u]);
  xxT = xxT + x*x';
  xuT = xuT + x*u';
  uuT = uuT + u*u';
  xy = xy - reshape(x*y',[],1);
  uy = uy - reshape(u*y',[],1);
  if rem(N,10000) == 0
    disp("Number: ");i
  end
end

txxT = arrayfun(@(i) xxT,1:n,'UniformOutput',false);
txuT = arrayfun(@(i) xuT,1:n,'UniformOutput',false);
tuuT = arrayfun(@(i) uuT,1:n,'UniformOutput',false);
tH = [blkdiag(txxT{:}),blkdiag(txuT{:});blkdiag(txuT{:})',blkdiag(tuuT{:})];
tf = [xy;uy];

%% constraint
fn = 6; % q = q + w*dt 
dt_ids = [7:7+(fn-1)] + (0:(fn-1))*n;
z_ids = [1:fn*n,n^2+1:n^2+fn*m];
H = tH;
H(z_ids,:) = [];
H(:,z_ids) = [];
f = tf;
ttH = tH(:,dt_ids)*dt;
f(z_ids,:) = [];
ttH(z_ids,:) = [];
f = f+ sum(ttH,2);
end
% function [A,B] = gen_Hf(X,U,Y,dt,F)
% N = size(X,2);
% tmp = F([X(:,1);U(:,1)]);
% n = size(tmp,1);
% m = size(U,1);
% A = zeros(n*N,n^2+n*m);
% B = zeros(n*N,1);
% zx_ids = 1:3*n;
% zu_ids = 1:3*m;
% dt_ids = [7,8,9] + (0:2)*n;
% disp("Total: "); N
% for i = 1:N
%   xT = F([X(:,i);u])';
%   y = F([Y(:,i);u]);
%   txT = arrayfun(@(i) xT,1:n,'UniformOutput',false);
%   tuT = arrayfun(@(i) uT,1:n,'UniformOutput',false);
%   MX = blkdiag(txT{:});
%   MU = blkdiag(tuT{:});
%   dtMX = MX(:,dt_ids);
%   MX(:,zx_ids) = [];
%   MU(:,zu_ids) = [];
%   A((i-1)*n+1:n*i,:) = [MX,MU];
%   B((i-1)*n+1:n*i,:) = y - dt*sum(dtMX,2);
%   if rem(N,10000) == 0
%     disp("Number: ");i
%   end
% end
% end