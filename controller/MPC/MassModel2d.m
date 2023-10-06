function [dsys,csys]  = MassModel2d(n,Td) 
% [Input]
% n : state size
% Td : sampling time
%% continuous time system
if n == 2
Ac = [0.0, 0.0;
  0.0, 0.0];
Bc = [1.0, 0.0;
  0.0, 1.0];
Cc = diag([1,1]);
Dc = 0;
else
A = diag(ones(1,n/2-1),1);
B = [zeros(n/2-1);1];
Ac = blkdiag(A,A);
Bc = blkdiag(B,B);
Cc = eye(n);
Dc = 0;
end
csys =ss(Ac,Bc,Cc,Dc);

%% discrete time system
dsys=c2d(csys,Td);
%[Ad,Bd,Cd,Dd]=ssdata(dsys);

end