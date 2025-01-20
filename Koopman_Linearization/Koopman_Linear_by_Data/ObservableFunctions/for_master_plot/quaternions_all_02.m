function z = quaternions_all_02(x)
% F(x)およびG(x)の全ての項を観測量とする
%   Z = quartanionParameter(X)
%   X : [位置P; クォータニオンq or オイラー角 Q; 速度V; 角速度W]を持つ状態量
%   Z : [X(クォータニオンを含まない); (クォータニオン); (クォータニオンの2乗); (クォータニオンの3乗) ]

% ドローンの固定値
m = 0.5884;
lengths = 0.16;% モーター間の距離：正方形を仮定している
Lx = 0.16; % x軸方向のモーター間距離
Ly = 0.16; % y軸方向のモーター間距離
lx = 0.08; % x軸方向 重心からモーター１間距離
ly = 0.08; % y軸方向 重心からモーター１間距離
jx = 0.002237568;
jy = 0.002985236;
jz = 0.00480374;
gravity = 9.81;
km = 0.03010685884691849; % ロータ定数
k = 0.000008048;          % 推力定数

% 状態がクォータニオンを用いた13次元の場合
if size(x,1) == 9+4
    P1 = 0;
    P2 = 0;
    P3 = 0;
    Q1 = x(1,1); % roll
    Q2 = x(2,1); % pitch
    Q3 = x(3,1); % yaw
    V1 = x(4,1);
    V2 = x(5,1);
    V3 = x(6,1);
    W1 = x(7,1);
    W2 = x(8,1);
    W3 = x(9,1);
    u1 = 0;
    u2 = 0;
    u3 = 0;
    u4 = 0;
% 状態がオイラー角を用いた12次元の場合
elseif size(x,1) == 12+4
    P1 = x(1,1);
    P2 = x(2,1);
    P3 = x(3,1);
    Q1 = x(4,1); % roll
    Q2 = x(5,1); % pitch
    Q3 = x(6,1); % yaw
    V1 = x(7,1);
    V2 = x(8,1);
    V3 = x(9,1);
    W1 = x(10,1);
    W2 = x(11,1);
    W3 = x(12,1);
    u1 = 0; %x(13,1);
    u2 = 0; %x(14,1);
    u3 = 0; %x(15,1);
    u4 = 0; %x(16,1);
end

    % q0-q3 : 与えたオイラー角から求めたクォータニオン
    % eul2quat,quaternion はsingleかdouble型にしか使え無くて関数ハンドルを設定した時にエラーをはいた 残念
    q0 = cos(Q1/2)*cos(Q2/2)*cos(Q3/2)+sin(Q1/2)*sin(Q2/2)*sin(Q3/2);
    q1 = sin(Q1/2)*cos(Q2/2)*cos(Q3/2)-cos(Q1/2)*sin(Q2/2)*sin(Q3/2);
    q2 = cos(Q1/2)*sin(Q2/2)*cos(Q3/2)+sin(Q1/2)*cos(Q2/2)*sin(Q3/2);
    q3 = cos(Q1/2)*cos(Q2/2)*sin(Q3/2)-sin(Q1/2)*sin(Q2/2)*cos(Q3/2);
% end

%回転行列の一部
R13 = ( 2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)) + 2.*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)));
R23 = (-2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)) - 2.*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)));
R33 = (cos(Q2).*cos(Q1));
if size(x,1) == 12+4
common_z = [P1;P2;P3;Q1;Q2;Q3;V1;V2;V3;W1;W2;W3;
            R13;
            R23;
            R33;
            1];
common_2z = [P1;P2;P3;Q1;Q2;Q3;V1;V2;V3]; % code06用
end
common_except_pos_z = [Q1;Q2;Q3;V1;V2;V3;W1;W2;W3;
            R13;
            R23;
            R33;
            1]; % 位置を除いたcommon_z

%% 磯部先輩観測量 code = 00
isobe_z = [W1*W2;
            W2*W3;
            W3*W1;
            W2*cos(Q1);
            W3*sin(Q1);
            W1*cos(Q2)/cos(Q1);
            W2*sin(Q1)/cos(Q2);
            W3*cos(Q1)/cos(Q2);
            W2*sin(Q1)*sin(Q2)/cos(Q1);
            W3*cos(Q1)*sin(Q2)/cos(Q1)
            ];

%% F(x), G(x)の各項をそのまま観測量にする code = 01
F_z = [(W1*cos(Q2) + W3*cos(Q1)*sin(Q2) + W2*sin(Q2)*sin(Q1)) /cos(Q2);
    W2*cos(Q1) - W3*sin(Q1);
    (W3*cos(Q1) + W2*sin(Q1)) / cos(Q2);
     (jy*W2*W3 - jz*W2*W3) / jx;
    -(jx*W1*W3 - jz*W1*W3) / jx;
     (jx*W1*W2 - jy*W1*W2) / jx
     ];
G_z = [(2*(cos(Q2/2)*cos(Q1/2)*cos(Q3/2) + sin(Q2/2)*sin(Q1/2)*sin(Q3/2))*(cos(Q1/2)*cos(Q3/2)*sin(Q2/2) + cos(Q2/2)*sin(Q1/2)*sin(Q3/2)) + 2*(cos(Q2/2)*cos(Q1/2)*sin(Q3/2) - cos(Q3/2)*sin(Q2/2)*sin(Q1/2))*(cos(Q2/2)*cos(Q3/2)*sin(Q1/2) - cos(Q1/2)*sin(Q2/2)*sin(Q3/2)))/m;
    -(2*(cos(Q2/2)*cos(Q1/2)*cos(Q3/2) + sin(Q2/2)*sin(Q1/2)*sin(Q3/2))*(cos(Q2/2)*cos(Q3/2)*sin(Q1/2) - cos(Q1/2)*sin(Q2/2)*sin(Q3/2)) - 2*(cos(Q1/2)*cos(Q3/2)*sin(Q2/2) + cos(Q2/2)*sin(Q1/2)*sin(Q3/2))*(cos(Q2/2)*cos(Q1/2)*sin(Q3/2) - cos(Q3/2)*sin(Q2/2)*sin(Q1/2)))/m;
    ((cos(Q2/2)*cos(Q1/2)*cos(Q3/2) + sin(Q2/2)*sin(Q1/2)*sin(Q3/2))^2 - (cos(Q1/2)*cos(Q3/2)*sin(Q2/2) + cos(Q2/2)*sin(Q1/2)*sin(Q3/2))^2 + (cos(Q2/2)*cos(Q1/2)*sin(Q3/2) - cos(Q3/2)*sin(Q2/2)*sin(Q1/2))^2 - (cos(Q2/2)*cos(Q3/2)*sin(Q1/2) - cos(Q1/2)*sin(Q2/2)*sin(Q3/2))^2)/m;
    1/jx;
    1/jy;
    1/jz
    ];

%% F(x), G(x)の各項を分解して観測量にする code = 02
Fdisassembly_z = [W1*cos(Q2);
    W3*cos(Q1)*sin(Q2);
    W2*sin(Q2)*sin(Q1) /cos(Q2);
    W2*cos(Q1) - W3*sin(Q1);
    W3*cos(Q1) / cos(Q2); 
    W2*sin(Q1) / cos(Q2);
     (jy*W2*W3 - jz*W2*W3) / jx;
    -(jx*W1*W3 - jz*W1*W3) / jx;
     (jx*W1*W2 - jy*W1*W2) / jx
    ];
Gdisassembly_z = [cos(Q2/2)*cos(Q1/2)*cos(Q3/2);
    sin(Q2/2)*sin(Q1/2)*sin(Q3/2);
    cos(Q1/2)*cos(Q3/2)*sin(Q2/2);
    cos(Q2/2)*sin(Q1/2)*sin(Q3/2);
    cos(Q2/2)*cos(Q1/2)*sin(Q3/2);
    cos(Q3/2)*sin(Q2/2)*sin(Q1/2);
    cos(Q2/2)*cos(Q3/2)*sin(Q1/2);
    cos(Q1/2)*sin(Q2/2)*sin(Q3/2);
    1/jx;
    1/jy;
    1/jz
    ];

%% f(x, u, param)からdf/dparam したときの項+磯部先輩 code = 04
roll = Q1; pitch = Q2; yaw = Q3;
o1 = W1; o2 = W2; o3 = W3;
% u1 = 1; u2 = 1; u3 = 1; u4 = 1;
diff_param_z = [-(u1*(2*(cos(pitch/2)*cos(roll/2)*cos(yaw/2) + sin(pitch/2)*sin(roll/2)*sin(yaw/2))*(cos(roll/2)*cos(yaw/2)*sin(pitch/2) + cos(pitch/2)*sin(roll/2)*sin(yaw/2)) + 2*(cos(pitch/2)*cos(roll/2)*sin(yaw/2) - cos(yaw/2)*sin(pitch/2)*sin(roll/2))*(cos(pitch/2)*cos(yaw/2)*sin(roll/2) - cos(roll/2)*sin(pitch/2)*sin(yaw/2))))/m^2;
            (u1*(2*(cos(pitch/2)*cos(roll/2)*cos(yaw/2) + sin(pitch/2)*sin(roll/2)*sin(yaw/2))*(cos(pitch/2)*cos(yaw/2)*sin(roll/2) - cos(roll/2)*sin(pitch/2)*sin(yaw/2)) - 2*(cos(roll/2)*cos(yaw/2)*sin(pitch/2) + cos(pitch/2)*sin(roll/2)*sin(yaw/2))*(cos(pitch/2)*cos(roll/2)*sin(yaw/2) - cos(yaw/2)*sin(pitch/2)*sin(roll/2))))/m^2;
            -(u1*((cos(pitch/2)*cos(roll/2)*cos(yaw/2) + sin(pitch/2)*sin(roll/2)*sin(yaw/2))^2 - (cos(roll/2)*cos(yaw/2)*sin(pitch/2) + cos(pitch/2)*sin(roll/2)*sin(yaw/2))^2 + (cos(pitch/2)*cos(roll/2)*sin(yaw/2) - cos(yaw/2)*sin(pitch/2)*sin(roll/2))^2 - (cos(pitch/2)*cos(yaw/2)*sin(roll/2) - cos(roll/2)*sin(pitch/2)*sin(yaw/2))^2))/m^2;
            - u2/jx^2 - (jy*o2*o3 - jz*o2*o3)/jx^2;
                                      -(o1*o3)/jy;
                                       (o1*o2)/jz;
                                       (o2*o3)/jx;
             (jx*o1*o3 - jz*o1*o3)/jy^2 - u3/jy^2;
                                      -(o1*o2)/jz;
                                      -(o2*o3)/jx;
                                       (o1*o3)/jy;
           - u4/jz^2 - (jx*o1*o2 - jy*o1*o2)/jz^2;
                                               -1];

%% f(x, u, param)からdf/dparam を用いて code = 09
% 係数 2/m^2を除く
roll = Q1; pitch = Q2; yaw = Q3;
sigma = yaw/2;
comat_1 = cos(pitch/2)*cos(roll/2)*cos(sigma);
comat_2 = sin(pitch/2)*sin(roll/2)*sin(sigma);
comat_3 = cos(pitch/2)*cos(roll/2)*sin(sigma);
comat_4 = sin(pitch/2)*sin(roll/2)*cos(sigma);
comat_12_1 = cos(roll/2)*sin(pitch/2)*cos(sigma);
comat_12_2 = cos(pitch/2)*sin(roll/2)*sin(sigma);
comat_34_1 = cos(pitch/2)*sin(roll/2)*cos(sigma);
comat_34_2 = cos(roll/2)*sin(pitch/2)*sin(sigma);
partial_param_z_1 = [comat_1 * comat_12_1; comat_1 * comat_12_2; comat_2 * comat_12_1;
                    comat_2 * comat_12_2; comat_3 * comat_34_1; comat_3 * comat_34_2;
                    comat_4 * comat_34_1; comat_4 * comat_34_2]; % (7,1)
partial_param_z_2 = [comat_1 * comat_34_1; comat_1 * comat_34_2; comat_2 * comat_34_1;
                    comat_2 * comat_34_2; comat_34_1 * comat_3; comat_34_1 * comat_4;
                    comat_12_2 * comat_3; comat_12_2 * comat_4]; % (8,1)
partial_param_z_3 = [comat_1; comat_2; comat_12_1; comat_12_2;
                comat_3; comat_4; comat_34_1; comat_34_2]; % (9,1)
partial_param_z = [partial_param_z_1; partial_param_z_2; partial_param_z_3];

%% Hermite polynomial & kronecker product code=12
X = x(1:12,1);
U = [u1;u2;u3;u4];
H0 = 1;
H1x = 2.*X;
H1u = 2.*U;
hermite_x = [H0; H1x];
hermite_u = [H0; H1u];
hermite_z = kron(hermite_x, hermite_u); % ちょっと違うかも

%% Table 1のD(x)を基に算出 Wheeled Robot \thetaはyawと仮定
% kronの組み合わせをたくさんつくる
% H1 = @(x) [1; 2.*x]; % H0; H1  code12-15 物理的
H1 = @(x) [1; x]; % 確率論的
kron_p = kron(kron(H1(P1),H1(P2)), kron(H1(sin(Q3)), H1(cos(Q3))));
kron_v = kron(kron(H1(V1),H1(V2)), kron(H1(sin(W3)), H1(cos(W3))));
kron_x = [kron_p; kron_v];
hermite_WheeledRobot_z = kron(kron_x, hermite_u);

kron_state = H1(x(1:12,:)); % point on a line
kron_pxyz = kron(kron(H1(P1),H1(P2)), H1(P3)); % point on a 3D space
kron_vxyz = kron(kron(H1(V1),H1(V2)), H1(V3));
kron_qxyz = kron(kron(H1(Q1),H1(Q2)), H1(Q3));
kron_wxyz = kron(kron(H1(W1),H1(W2)), H1(W3));
kron_pxy_yaw = kron(kron(H1(P1),H1(P2)), kron(H1(sin(Q3)),H1(cos(Q3)))); % wheeled robot
kron_vxy_yaw = kron(kron(H1(V1),H1(V2)), kron(H1(sin(W3)),H1(cos(W3))));
kron_pxy = kron(H1(P1),H1(P2)); % point on a plane
kron_vxy = kron(H1(V1),H1(V2));
kron_qxy = kron(H1(Q1),H1(Q2));
kron_wxy = kron(H1(W1),H1(W2));
kron_q1 = kron(H1(cos(Q1)), H1(cos(Q2))); % original
kron_q2 = kron(H1(sin(Q1)), H1(sin(Q2)));
kron_q3 = kron(H1(cos(Q1)), H1(sin(Q2)));
kron_q4 = kron(H1(sin(Q1)), H1(cos(Q2)));
kron_qq1 = kron(kron_q1, H1(Q3));
kron_qq2 = kron(kron_q2, H1(Q3));
kron_qq3 = kron(kron_q3, H1(Q3));
kron_qq4 = kron(kron_q4, H1(Q3));
hermite_total = [kron_state; kron_pxyz; kron_vxyz; kron_qxyz; kron_wxyz;
    kron_pxy_yaw; kron_vxy_yaw; kron_pxy; kron_vxy; kron_qxy; kron_wxy];
hermite_original_z = [kron_q1; kron_q2; kron_q3; kron_q4;
    kron_qq1; kron_qq2; kron_qq3; kron_qq4];
hermite_total_z = kron([hermite_total; hermite_original_z], hermite_u);

%% hermite ちゃんと頑張った版 
H = @(x) [1; x];
k1 = kron(kron(H(P1), H(P2)), kron(H(sin(Q3)), H(cos(Q3)))); % RxS
k2 = kron(kron(H(V1), H(V2)), kron(H(sin(W3)), H(cos(W3)))); % RxS
k3 = kron(kron(H(sin(Q1)), H(cos(Q1))), kron(H(sin(Q2)), H(cos(Q2)))); % S^2
k4 = kron(kron(H(sin(W1)), H(cos(W1))), kron(H(sin(W2)), H(cos(W2)))); % S^2

d1 = [k1; k2; k3; k4];
d2 = kron(kron(k1,k2), kron(k3,k4)); % kron(RxS, S) 
d3 = [kron(k1,k2); kron(k3,k4)]; % kron(RxS,RxS)
d4 = [kron(k1,k3); kron(k2,k4)]; % kron(RxS,S)
du = [H(u1); H(u2); H(u3); H(u4)];

% z = [common_z; kron(d1, du)]; % 17 528
% z = [common_z; kron(d2, du)]; % 18 52万次元のため中断
% z = [common_z; d1]; % 19 80
% z = [common_z; d2]; % 20 6万5000次元のため中断
% z = [common_z; d3]; % 21 kron(RxS, RxS) 528
% z = [common_z; d4]; % 22 kron(RxS, S) 528
% z = [common_z; isobe_z; d4]; % 23
% z = [common_z; isobe_z; d3; d4]; % 24
% z = [common_z; isobe_z; d1; d3; d4]; % 25
% z = [common_z; isobe_z; kron(k1,k2)]; % 26
% z = [common_z; isobe_z; kron(k3,k4)]; % 27
% z = [common_z; isobe_z; k3; k4]; % 28

%% まとめ
% z = [common_z; isobe_z]; % 00
z = [common_z; Fdisassembly_z; Gdisassembly_z]; % 02
% z = [common_z; Fdisassembly_z; Gdisassembly_z; isobe_z]; % 03
% z = [common_z; isobe_z; diff_param_z]; % 04
% z = [common_z; diff_param_z]; % 05
% z = [common_2z; isobe_z]; % 06
% z = [isobe_z; common_z]; % 07
% z = [common_z; isobe_z; F_z; G_z; Fdisassembly_z; Gdisassembly_z; diff_param_z]; % 08
% z = [common_except_pos_z; isobe_z; partial_param_z]; % 09  11の位置を含まない版
% z = [common_except_pos_z; isobe_z];                  % 10  00の位置を含まない版
% z = [common_z; isobe_z; partial_param_z]; % 11
% z = [common_z; hermite_z]; % 12
% z = [common_z; isobe_z; hermite_z]; % 13
% z = [common_z; hermite_WheeledRobot_z]; % 14
% z = [common_z; hermite_total_z]; % 15
% z = [common_z; isobe_z; hermite_WheeledRobot_z]; % 16
end

