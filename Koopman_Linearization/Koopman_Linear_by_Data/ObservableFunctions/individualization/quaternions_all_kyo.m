function z = quaternions_all_kyo(x)
% F(x)およびG(x)の全ての項を観測量とする
%   Z = quartanionParameter(X)
%   X : [位置P; クォータニオンq or オイラー角 Q; 速度V; 角速度W]を持つ状態量
%   Z : [X(クォータニオンを含まない); (クォータニオン); (クォータニオンの2乗); (クォータニオンの3乗) ]

% ドローンの固定値
m = 0.75;
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
U1 = x(13,1);
U2 = x(14,1);
U3 = x(15,1);
U4 = x(16,1);
% q0-q3 : 与えたオイラー角から求めたクォータニオン
% eul2quat,quaternion はsingleかdouble型にしか使え無くて関数ハンドルを設定した時にエラーをはいた 残念
% q0 = cos(Q1/2)*cos(Q2/2)*cos(Q3/2)+sin(Q1/2)*sin(Q2/2)*sin(Q3/2);
% q1 = sin(Q1/2)*cos(Q2/2)*cos(Q3/2)-cos(Q1/2)*sin(Q2/2)*sin(Q3/2);
% q2 = cos(Q1/2)*sin(Q2/2)*cos(Q3/2)+sin(Q1/2)*cos(Q2/2)*sin(Q3/2);
% q3 = cos(Q1/2)*cos(Q2/2)*sin(Q3/2)-sin(Q1/2)*sin(Q2/2)*cos(Q3/2);

% 回転行列の一部
% R13 = ( 2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)) + 2.*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)));
% R23 = (-2.*(cos(Q2/2).*cos(Q1/2).*cos(Q3/2) + sin(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q3/2).*sin(Q1/2) - cos(Q1/2).*sin(Q2/2).*sin(Q3/2)) - 2.*(cos(Q1/2).*cos(Q3/2).*sin(Q2/2) + cos(Q2/2).*sin(Q1/2).*sin(Q3/2)).*(cos(Q2/2).*cos(Q1/2).*sin(Q3/2) - cos(Q3/2).*sin(Q2/2).*sin(Q1/2)));
% R33 = (cos(Q2).*cos(Q1));  %問題あるそう


R13 = cos(Q3).*sin(Q2).*cos(Q1) + sin(Q3).*sin(Q1);
R23 = sin(Q3).*sin(Q2).*cos(Q1) - cos(Q3).*sin(Q1);
R33 = cos(Q2).*cos(Q1);
%多弁正し
% R13 = 2 .* ( q1 .* q3 + q0 .* q2 );
% R23 = 2 .* ( q2 .* q3 - q0 .* q1 );
% R33 = 1 - 2 .* ( q1 .* q1 + q2 .* q2 ); 

common_z = [P1;P2;P3;Q1;Q2;Q3;V1;V2;V3;W1;W2;W3;
            R13;
            R23;
            R33];
             % 1];% 16

%% 磯部先輩観測量 code = 00
kyo_z = [W1*W2;
            W2*W3;
            W3*W1;
            W2*cos(Q1);
            W3*sin(Q1);
            W1*cos(Q2)/cos(Q1);%??どこから
            W2*sin(Q1)/cos(Q2);
            W3*cos(Q1)/cos(Q2);
            W2*sin(Q1)*sin(Q2)/cos(Q2);
            W3*cos(Q1)*sin(Q2)/cos(Q2)
            ]; %9
kudo_z =[sin(Q1);
        cos(Q1);%sin,cos
        sin(Q1)*sin(Q2);
        sin(Q2)*sin(Q3);
        sin(Q3)*sin(Q1);%ssの組
        cos(Q1)*cos(Q2);
        cos(Q2)*cos(Q3);
        cos(Q3)*cos(Q1);%ccの組
        sin(Q1)*cos(Q2);%35番目
        sin(Q1)*cos(Q3);
        sin(Q2)*cos(Q1);
        sin(Q2)*cos(Q3);
        sin(Q3)*cos(Q1);
        sin(Q3)*cos(Q2);%scの組40番目
        sin(Q1)*sin(Q2)*sin(Q3);%sssの組
        sin(Q1)*sin(Q2)*cos(Q3);
        sin(Q1)*sin(Q3)*cos(Q2);
        sin(Q2)*sin(Q3)*cos(Q1);%sscの組
        sin(Q1)*cos(Q2)*cos(Q3);
        sin(Q2)*cos(Q1)*cos(Q3);
        sin(Q3)*cos(Q1)*cos(Q2);%sccの組
        cos(Q1)*cos(Q2)*cos(Q3)%cccの組
         ]; %22

kmec_qodt_z=[%I^-1wIwの項
             W2*cos(Q2);
             W2*sin(Q2);
             W3*sin(Q2);
             W3*cos(Q2);
             cos(Q2);
             sin(Q2);
             W2*sin(Q2)*tan(Q1);
             W2*cos(Q2)*tan(Q1);
             W3*sin(Q2)*tan(Q1);
             W3*cos(Q2)*tan(Q1);
             cos(Q2)*tan(Q1);
             sin(Q2)*tan(Q1)
             ]; %12  総計59
new_z =  [P1^2; P2^2; P3^2; P1*P2; P1*P3; P2*P3; %6
            V1*abs(V1); V2*abs(V2); V3*abs(V3);%3
            Q1^2; Q2^2; Q3^2; V1^2; V2^2; V3^2; W1^2; W2^2; W3^2;%9
            V1*W1; V1*W2; V1*W3; V2*W1; V2*W2; V2*W3; V3*W1; V3*W2; V3*W3;%9
            P1*V1; P1*V2; P1*V3; P2*V1; P2*V2; P2*V3; P3*V1; P3*V2; P3*V3;  %9  
        R13 * U1;    
        R23 * U1;    
        R33 * U1;  %3  
        W1 * U2; 
        W2 * U3;
        W3 * U4;  %3     
        V1 * U1;
        V2 * U1;
        V3 * U1;%3
        sqrt(V1^2+V2^2) *U1; %1
        U1;
        U2;
        U3;
        U4%4
    ]; % 50
smallnew_z =[ 
    cos(Q1)*cos(Q2);
    sin(Q1)*cos(Q2);
    cos(Q1)*sin(Q2);
    W1*sin(Q2);
    W2*sin(Q1);
    W3*cos(Q2);
    V2*W3;
    V3*W2;
    V1*W2;
    V2*W1;
    R33*V3;
    R13*V1;
    R23*V2;];%13
% z = [common_z; kyo_z ;kudo_z;kmec_qodt_z;new_z]; % 109
% z =[common_z; kyo_z ;smallnew_z ];%37
z = [common_z; kyo_z ];
end

