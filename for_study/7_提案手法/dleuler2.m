function out = dleuler2(Axy,Az,xi,Bxy,Bz,v)
%DLEULER オイラー法によるステップ進行データの生成
%   out：1ステップ進めたxi[k+1]
%   Axy, Az：A行列
%   xi：仮想状態
%   Bxy, Bz：B行列
%   v：仮想入力
%   dxi = A*xi + B*v

s = size(xi); % サイズ[行 列]xi
state = s(1); % 状態数(行数)xi
vecs = s(2); % 列数xi：状態ベクトル数
% dxi = zeros(state,vecs); % 初期化dxi
sizeA = size(Axy);
rowA = sizeA(1);
colA = sizeA(2);
% sizeB = size(Bxy);
% rowB = sizeB(1);
% colB = sizeB(2);
dt = 0.01;

out = zeros(state,vecs); % 初期化xi[k+1]



% ============
% A * xi
% ============
% Axi = zeros(state,1);
xi_x = [xi(3,:);xi(4,:);xi(5,:);xi(6,:)]; % xi_x
xi_y = [xi(7,:);xi(8,:);xi(9,:);xi(10,:)]; % xi_y
xi_z = [xi(1,:);xi(2,:)]; % xi_z
xi_yaw = [xi(11,:);xi(12,:)]; % xi_yaw
% x, y
% for j = 1:rowA
%     term1 = 0;
%     term2 = 0;
%     for k = 1:colA
%         term1 = term1 + Axy(j,k) * xi_x(k,1);
%         term2 = term2 + Axy(j,k) * xi_y(k,1);
%     end
%     Axi(2+j,1) = term1;
%     Axi(6+j,1) = term2;
% end
xi_xT = extractdata(double(xi_x))';
xi_yT = extractdata(double(xi_y))';
xi_zT = extractdata(double(xi_z))';
xi_yawT = extractdata(double(xi_yaw))';
Axi_x = dlarray_prod_same_column2(Axy,xi_xT,vecs);
Axi_y = dlarray_prod_same_column2(Axy,xi_yT,vecs);
% Axi = dlarray_prod_same_row(Axy,xi_ano');
Axi_z = dlarray_prod_same_column2(Az,xi_zT,vecs);
Axi_yaw = dlarray_prod_same_column2(Az,xi_yawT,vecs);
Axi = [Axi_z;Axi_x;Axi_y;Axi_yaw];
% z
% Axi(1,1) = Az(1,1) * xi_z(1,1) + Az(1,2) * xi_z(2,1);
% Axi(2,1) = Az(2,1) * xi_z(1,1) + Az(2,2) * xi_z(2,1);
% yaw
% Axi(11,1) = Az(1,1) * xi_yaw(1,1) + Az(1,2) * xi_yaw(2,1);
% Axi(12,1) = Az(2,1) * xi_yaw(1,1) + Az(2,2) * xi_yaw(2,1);

% ============
% B * v
% ============
% Bv = zeros(state,1);
% z * v1
% Bv(1,1) = Bz(1,1) * v(1,i);
% Bv(2,1) = Bz(2,1) * v(1,i);
v_z = v(1,:);
v_zT = extractdata(double(v_z))';
Bv(1:2,:) = dlarray_prod_same_column2(Bz,v_zT,vecs);
% x * [v2;v3]
% Bv(3,1) = Bxy(1,1) * v(2,i);
% Bv(4,1) = Bxy(2,1) * v(2,i);
% Bv(5,1) = Bxy(3,1) * v(2,i);
% Bv(6,1) = Bxy(4,1) * v(2,i);
v_x = v(2,:);
v_xT = extractdata(double(v_x))';
Bv(3:6,:) = dlarray_prod_same_column2(Bxy,v_xT,vecs);
% y * [v2;v3]
% Bv(7,1) = Bxy(1,1) * v(3,i);
% Bv(8,1) = Bxy(2,1) * v(3,i);
% Bv(9,1) = Bxy(3,1) * v(3,i);
% Bv(10,1) = Bxy(4,1) * v(3,i);
v_y = v(3,:);
v_yT = extractdata(double(v_y))';
Bv(7:10,:) = dlarray_prod_same_column2(Bxy,v_yT,vecs);
% yaw * v4
% Bv(11,1) = Bz(1,1) * v(4,i);
% Bv(12,1) = Bz(2,1) * v(4,i);
v_yaw = v(4,:);
v_yawT = extractdata(double(v_yaw))';
Bv(11:12,:) = dlarray_prod_same_column2(Bz,v_yawT,vecs);

% ======================
% dxi = A * xi + B * v
% ======================
dxi = Axi + Bv;
dxi_z = [dxi(1,1);dxi(2,1)];
dxi_x = [dxi(3,1);dxi(4,1);dxi(5,1);dxi(6,1)];
dxi_y = [dxi(7,1);dxi(8,1);dxi(9,1);dxi(10,1)];
dxi_yaw = [dxi(11,1);dxi(12,1)];

% ===============================
% xi[k+1] = xi[k] + dxi[k] * dt
% ===============================
xikk_z = xi_z + dxi_z .* dt;
xikk_x = xi_x + dxi_x .* dt;
xikk_y = xi_y + dxi_y .* dt;
xikk_yaw = xi_yaw + dxi_yaw .* dt;

out = [xikk_z;xikk_x;xikk_y;xikk_yaw];


end



