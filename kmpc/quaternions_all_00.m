function z = quaternions_all_00(x)
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

z = [common_z; isobe_z]; % 00
end

