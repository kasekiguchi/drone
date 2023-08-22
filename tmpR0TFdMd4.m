function y = tmpR0TFdMd4(x,xd,R0,R0d,P,K)
N = 4;
%%
%[x0d;dx0d;ddx0d;dddx0d;o0d;do0d]; % R0d は除いている
x0d = xd(1:3);
dx0d = xd(4:6);
ddx0d = xd(7:9);
dddx0d = xd(10:12);
o0d = xd(13:15);
do0d = xd(16:18);

%[x0;r0;dx0;o0;reshape([qi,wi],6*N,1);reshape(ri,4*N,1);reshape(oi,3*N,1)]; % 9*(N+1)
x0 = x(1:3);
r0 = x(4:7);
dx0 = x(8:10);
o0 = x(11:13);
qi = reshape(x(14:14+3*N-1),3,[]);
oi = reshape(x(end-3*N+1:end),3,[]);

physicalParam = P;
%[g m0 j0' reshape(rho,1, 3*N) li mi reshape(ji,1,3*N)];
m0 = P(2);
g = P(1);
ji = reshape(P(end-3*N+1:end),3,[]);
rho = reshape(P(6:6+3*N-1),3,[]);
j0 = K(3:5);

Gains = K;
%[kx0 kr0 kdx0 ko0 kqi kwi kri koi epsilon];
kx0 = K(1:3);
kr0 = K(4);
kdx0 = K(5:7);
ko0 = K(8);

%%
O0 = Skew(o0); % 牽引物の角速度行列（歪対象行列）
Oi = arrayfun(@(i) Skew(oi(:,i)),1:N,'UniformOutput',false); % ドローン角速度行列
J0 = diag(j0); % 牽引物の慣性行列
Ji = arrayfun(@(i) diag(ji(:,i)),1:N,'UniformOutput',false); % ドローン慣性行列
e3 = [0;0;1]; %

Rho = arrayfun(@(i) Skew(rho(:,i)),1:N,'UniformOutput',false); % rho の歪対称化
Qi = arrayfun(@(i) Skew(qi(:,i)),1:N,'UniformOutput',false); % qi の歪対称化
%% 状態：
% 牽引物: 位置，姿勢角，速度，角速度， : 13
% リンク: 角度，角速度 : N x 6
% ドローン:姿勢角，角速度

%% (20)-(22)
ex0 = x0 - x0d;
dex0 = dx0 -dx0d;
eR0 = Vee(R0d'*R0 - R0'*R0d)/2;
eo0 = o0 - R0'*R0d*o0d;
%% (23),(24)

Fd0 = m0*(-kx0*ex0- kdx0*dex0 + ddx0d + g*e3);
Md0 = -kr0*eR0 - ko0*eo0 + Skew(R0'*R0d*o0d)*J0*R0'*R0d*o0d + J0*R0'*R0d*do0d;
y = [R0'*Fd0;Md0];
end