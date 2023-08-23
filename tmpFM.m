function FM = tmpFM(x,xd,R0,R0d,P,K,qid,ui,Ri,b1,b2,b3,si,ci)
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
wi = reshape(x(14+3*N:14+6*N-1),3,[]);
oi = reshape(x(end-3*N+1:end),3,[]);

physicalParam = P;
%[g m0 j0' reshape(rho,1, 3*N) li mi reshape(ji,1,3*N)];
m0 = P(2);
g = P(1);
ji = reshape(P(end-3*N+1:end),3,[]);
rho = reshape(P(6:6+3*N-1),3,[]);
j0 = K(3:5);
mi = P(end-4*N+1:end-3*N);
li = P(end-5*N+1:end-4*N);

Gains = K;
%[kx0 kr0 kdx0 ko0 kqi kwi kri koi epsilon];
kx0 = K(1:3);
kr0 = K(4:6);
kdx0 = K(7:9);
ko0 = K(10:12);
kqi = K(end-4);
kwi = K(end-3);
kri = K(end-2);
koi = K(end-1);
epsilon = K(end);

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
db3 = zeros(size(b3));
for i = 1:N
b3ddx0d(:,i) = cross(b3(:,i),ddx0d);
db2(:,i) = (b3ddx0d(:,i)-ci(i)*b2(:,i))/si(i);
db1(:,i) = -cross(b3(:,i),db2(:,i));
ddb3(:,i) = db3(:,i);
ddb2(:,i) = (cross(b3(:,i),dddx0d)+(b2(:,i)-ci(i)*b3ddx0d(:,i))/si(i) - ci(i)*db2(:,i))/si(i);
ddb1(:,i) = -cross(b3(:,i),ddb2(:,i));
Ric{i} = [b1(:,i) b2(:,i) b3(:,i)];% 3x3xN
dRic{i} = [db1(:,i) db2(:,i) db3(:,i)];% 3x3xN
ddRic{i} = [ddb1(:,i),ddb2(:,i),ddb3(:,i)];% 3x3xN
oic(:,i) = Vee(Ric{i}'*dRic{i});% 3xN = Vee(hoic)
doic(:,i) = Vee(Ric{i}'*ddRic{i} - (Ric{i}'*dRic{i})^2);% + (dRic{i}'*dRic{i}));% 3xN
%doic(:,i) = Vee(Ric{i}'*ddRic{i} + (dRic{i}'*dRic{i}));% 3xN
end
for i = 1:N
  eri(:,i) = Vee(Ric{i}'*Ri(:,:,i)-Ri(:,:,i)'*Ric{i})/2;
  eoi(:,i) = oi(:,i) - Ri(:,:,i)'*Ric{i}*oic(:,i);% 3xN
end
%%
for i = 1:N
fi(i) = ui(:,i)'*Ri(:,:,i)*e3;
Mi(:,i) = - kri*eri(:,i)/(epsilon^2) - koi*eoi(:,i)/epsilon + Oi{i}*Ji{i}*oi(:,i) - Ji{i}*(Oi{i}*Ri(:,:,i)'*Ric{i}*oic(:,i)-Ri(:,:,i)*Ric{i}*doic(:,i));% 3xN
end
%[Mi,eoi,oi]
FM = reshape([fi;Mi],[],1);
end