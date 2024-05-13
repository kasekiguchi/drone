function z = quaternions_all(x)
% F(x)およびG(x)の全ての項を観測量とする
%   Z = quartanionParameter(X)
%   X : [位置P; クォータニオンq or オイラー角 Q; 速度V; 角速度W]を持つ状態量
%   Z : [X(クォータニオンを含まない); (クォータニオン); (クォータニオンの2乗); (クォータニオンの3乗) ]

% ドローンの固定値
const.m = 0.5884;
const.length = 0.16;% モーター間の距離：正方形を仮定している
const.Lx = 0.16; % x軸方向のモーター間距離
const.Ly = 0.16; % y軸方向のモーター間距離
const.lx = 0.08; % x軸方向 重心からモーター１間距離
const.ly = 0.08; % y軸方向 重心からモーター１間距離
const.jx = 0.002237568;
const.jy = 0.002985236;
const.jz = 0.00480374;
const.gravity = 9.81;
const.km = 0.03010685884691849; % ロータ定数
const.k = 0.000008048;          % 推力定数

% 状態がクォータニオンを用いた13次元の場合
if size(x,1) == 13
    P1 = x(1,1);
    P2 = x(2,1);
    P3 = x(3,1);
    q0 = x(4,1);
    q1 = x(5,1);
    q2 = x(6,1);
    q3 = x(7,1);
    V1 = x(8,1);
    V2 = x(9,1);
    V3 = x(10,1);
    W1 = x(11,1);
    W2 = x(12,1);
    W3 = x(13,1);
    %オイラー角に変換して記録しておく
    quat = quaternion([q0 q1 q2 q3]);
    Q = euler(quat,'ZYX','frame');
    Q1 = Q(1); Q2 = Q(2); Q3 = Q(3);
% 状態がオイラー角を用いた12次元の場合
elseif size(x,1) ==12
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
    % q0-q3 : 与えたオイラー角から求めたクォータニオン
    % eul2quat,quaternion はsingleかdouble型にしか使え無くて関数ハンドルを設定した時にエラーをはいた 残念
    q0 = cos(Q1/2)*cos(Q2/2)*cos(Q3/2)+sin(Q1/2)*sin(Q2/2)*sin(Q3/2);
    q1 = sin(Q1/2)*cos(Q2/2)*cos(Q3/2)-cos(Q1/2)*sin(Q2/2)*sin(Q3/2);
    q2 = cos(Q1/2)*sin(Q2/2)*cos(Q3/2)+sin(Q1/2)*cos(Q2/2)*sin(Q3/2);
    q3 = cos(Q1/2)*cos(Q2/2)*sin(Q3/2)-sin(Q1/2)*sin(Q2/2)*cos(Q3/2);
end

%回転行列の一部
R13 = ( 2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)) + 2.*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)));
R23 = (-2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)) - 2.*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)));
R33 = (cos(Q2).*cos(Q1));

common_z = [P1;P2;P3;Q1;Q2;Q3;V1;V2;V3;W1;W2;W3;
            R13;
            R23;
            R33;
            1];

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
% z = [common_z; isobe_z];

%% F(x), G(x)の各項をそのまま観測量にする code = 01
% F_z = [(W1*cos(Q2) + W3*cos(Q1)*sin(Q2) + W2*sin(Q2)*sin(Q1)) /cos(Q2);
%     W2*cos(Q1) - W3*sin(Q1);
%     (W3*cos(Q1) + W2*sin(Q1)) / cos(Q2);
%      (const.jy*W2*W3 - const.jz*W2*W3) / const.jx;
%     -(const.jx*W1*W3 - const.jz*W1*W3) / const.jx;
%      (const.jx*W1*W2 - const.jy*W1*W2) / const.jx
%      ];
% G_z = [(2*(cos(Q2/2)*cos(Q1/2)*cos(Q3/2) + sin(Q2/2)*sin(Q1/2)*sin(Q3/2))*(cos(Q1/2)*cos(Q3/2)*sin(Q2/2) + cos(Q2/2)*sin(Q1/2)*sin(Q3/2)) + 2*(cos(Q2/2)*cos(Q1/2)*sin(Q3/2) - cos(Q3/2)*sin(Q2/2)*sin(Q1/2))*(cos(Q2/2)*cos(Q3/2)*sin(Q1/2) - cos(Q1/2)*sin(Q2/2)*sin(Q3/2)))/const.m;
%     -(2*(cos(Q2/2)*cos(Q1/2)*cos(Q3/2) + sin(Q2/2)*sin(Q1/2)*sin(Q3/2))*(cos(Q2/2)*cos(Q3/2)*sin(Q1/2) - cos(Q1/2)*sin(Q2/2)*sin(Q3/2)) - 2*(cos(Q1/2)*cos(Q3/2)*sin(Q2/2) + cos(Q2/2)*sin(Q1/2)*sin(Q3/2))*(cos(Q2/2)*cos(Q1/2)*sin(Q3/2) - cos(Q3/2)*sin(Q2/2)*sin(Q1/2)))/const.m;
%     ((cos(Q2/2)*cos(Q1/2)*cos(Q3/2) + sin(Q2/2)*sin(Q1/2)*sin(Q3/2))^2 - (cos(Q1/2)*cos(Q3/2)*sin(Q2/2) + cos(Q2/2)*sin(Q1/2)*sin(Q3/2))^2 + (cos(Q2/2)*cos(Q1/2)*sin(Q3/2) - cos(Q3/2)*sin(Q2/2)*sin(Q1/2))^2 - (cos(Q2/2)*cos(Q3/2)*sin(Q1/2) - cos(Q1/2)*sin(Q2/2)*sin(Q3/2))^2)/const.m;
%     1/const.jx;
%     1/const.jy;
%     1/const.jz
%     ];
% z = [common_z; F_z; G_z];

%% F(x), G(x)の各項を分解して観測量にする code = 02
% F_z = [W1*cos(Q2);
%     W3*cos(Q1)*sin(Q2);
%     W2*sin(Q2)*sin(Q1) /cos(Q2);
%     W2*cos(Q1) - W3*sin(Q1);
%     W3*cos(Q1) / cos(Q2); 
%     W2*sin(Q1) / cos(Q2);
%      (const.jy*W2*W3 - const.jz*W2*W3) / const.jx;
%     -(const.jx*W1*W3 - const.jz*W1*W3) / const.jx;
%      (const.jx*W1*W2 - const.jy*W1*W2) / const.jx
%     ];
% G_z = [cos(Q2/2)*cos(Q1/2)*cos(Q3/2);
%     sin(Q2/2)*sin(Q1/2)*sin(Q3/2);
%     cos(Q1/2)*cos(Q3/2)*sin(Q2/2);
%     cos(Q2/2)*sin(Q1/2)*sin(Q3/2);
%     cos(Q2/2)*cos(Q1/2)*sin(Q3/2);
%     cos(Q3/2)*sin(Q2/2)*sin(Q1/2);
%     cos(Q2/2)*cos(Q3/2)*sin(Q1/2);
%     cos(Q1/2)*sin(Q2/2)*sin(Q3/2);
%     1/const.jx;
%     1/const.jy;
%     1/const.jz
%     ];
% z = [common_z; F_z; G_z];

%% F(x), G(x)の各項を分解+磯部先輩 code = 03
% F_z = [W1*cos(Q2);
%     W3*cos(Q1)*sin(Q2);
%     W2*sin(Q2)*sin(Q1) /cos(Q2);
%     W2*cos(Q1) - W3*sin(Q1);
%     W3*cos(Q1) / cos(Q2); 
%     W2*sin(Q1) / cos(Q2);
%      (const.jy*W2*W3 - const.jz*W2*W3) / const.jx;
%     -(const.jx*W1*W3 - const.jz*W1*W3) / const.jx;
%      (const.jx*W1*W2 - const.jy*W1*W2) / const.jx
%     ];
% G_z = [cos(Q2/2)*cos(Q1/2)*cos(Q3/2);
%     sin(Q2/2)*sin(Q1/2)*sin(Q3/2);
%     cos(Q1/2)*cos(Q3/2)*sin(Q2/2);
%     cos(Q2/2)*sin(Q1/2)*sin(Q3/2);
%     cos(Q2/2)*cos(Q1/2)*sin(Q3/2);
%     cos(Q3/2)*sin(Q2/2)*sin(Q1/2);
%     cos(Q2/2)*cos(Q3/2)*sin(Q1/2);
%     cos(Q1/2)*sin(Q2/2)*sin(Q3/2);
%     1/const.jx;
%     1/const.jy;
%     1/const.jz
%     ];
% z = [common_z; F_z; G_z; isobe_z];

%% f(x, u, param)からdf/dparam したときの項 code = 04
roll = Q1; pitch = Q2; yaw = Q3;
jx = const.jx; jy = const.jy; jz = const.jz;
o1 = W1; o2 = W2; o3 = W3;
m = const.m;
u1 = 0; u2 = 0; u3 = 0; u4 = 0;
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
z = [common_z; isobe_z; diff_param_z];
end

