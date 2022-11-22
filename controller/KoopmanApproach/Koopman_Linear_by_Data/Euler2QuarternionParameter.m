function z = Euler2QuarternionParameter(x)
%EULER2QUORTERNIONPARAMETER クォータニオンをパラメータとして含む観測量 オイラー角からクォータニオンへ変換
%   Z = quartanionParameter(X)
%   X : [位置P; オイラー角Q; 速度V; 角速度W]を持つ12次元の状態量
%   Z : [X; (クォータニオンを含む項) ]

P1 = x(1,1);
P2 = x(2,1);
P3 = x(3,1);
Q1 = x(4,1);
Q2 = x(5,1);
Q3 = x(6,1);
V1 = x(7,1);
V2 = x(8,1);
V3 = x(9,1);
W1 = x(10,1);
W2 = x(11,1);
W3 = x(12,1);

% q0-q3 : 与えたオイラー角から求めたクォータニオン
% eul2quat,quarternion はsingleかdouble型にしか使え無くて関数ハンドルを設定した時にエラーをはいた 残念
% 20221110 現状起きてる発散は多分これが原因
q0 = cos(Q1/2)*cos(Q2/2)*cos(Q3/2)+sin(Q1/2)*sin(Q2/2)*sin(Q3/2);
q1 = sin(Q1/2)*cos(Q2/2)*cos(Q3/2)-cos(Q1/2)*sin(Q2/2)*sin(Q3/2);
q2 = cos(Q1/2)*sin(Q2/2)*cos(Q3/2)+sin(Q1/2)*cos(Q2/2)*sin(Q3/2);
q3 = cos(Q1/2)*cos(Q2/2)*sin(Q3/2)-sin(Q1/2)*sin(Q2/2)*cos(Q3/2);

% % 発散 下のよりはまし 20221110 10^9オーダー
% z = [P1;P2;P3;Q1;Q2;Q3;V1;V2;V3;W1;W2;W3;
%     -W1*q1/2-W2*q2/2-W3*q3/2;
%      W1*q0/2-W2*q3/2+W3*q2/2;
%      W2*q0/2+W1*q3/2-W3*q1/2;
%      W2*q1/2-W1*q2/2+W3*q1/2];

% 発散 20221110 10^54オーダー
% z = [P1;P2;P3;Q1;Q2;Q3;V1;V2;V3;W1;W2;W3;
%     -W1*q1/2;
%     -W2*q2/2;
%     -W3*q3/2;
%      W1*q0/2;
%     -W2*q3/2;
%      W3*q2/2;
%      W2*q0/2;
%      W1*q3/2;
%     -W3*q1/2;
%      W2*q1/2;
%     -W1*q2/2;
%      W3*q1/2];

% チェック用
z = [P1;P2;P3;q0;q1;q2;q3;V1;V2;V3;W1;W2;W3];

end

