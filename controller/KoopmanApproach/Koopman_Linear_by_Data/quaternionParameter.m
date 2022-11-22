function z = quaternionParameter(x)
%QUATERNIONPARAMETER クォータニオンをパラメータとして含む観測量
%   Z = quartanionParameter(X)
%   X : [位置P; クォータニオンq or オイラー角 Q; 速度V; 角速度W]を持つ状態量
%   Z : [X; (クォータニオンを含む項) ]
% 22/11/22 Euler2QuaternionParameter と統合
% xが12状態でも13状態でも機能するように改良

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
    %一応オイラー角に変換して記録しておく
    quat = quaternion([q0 q1 q2 q3]);
    Q = euler(quat,'ZYX','frame');
    Q1 = Q(1); Q2 = Q(2); Q3 = Q(3);
elseif size(x,1) ==12
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
    % eul2quat,quaternion はsingleかdouble型にしか使え無くて関数ハンドルを設定した時にエラーをはいた 残念
    q0 = cos(Q1/2)*cos(Q2/2)*cos(Q3/2)+sin(Q1/2)*sin(Q2/2)*sin(Q3/2);
    q1 = sin(Q1/2)*cos(Q2/2)*cos(Q3/2)-cos(Q1/2)*sin(Q2/2)*sin(Q3/2);
    q2 = cos(Q1/2)*sin(Q2/2)*cos(Q3/2)+sin(Q1/2)*cos(Q2/2)*sin(Q3/2);
    q3 = cos(Q1/2)*cos(Q2/2)*sin(Q3/2)-sin(Q1/2)*sin(Q2/2)*cos(Q3/2);
end
% % 発散 下のよりはまし 22/11/10 10^9オーダー
% z = [P1;P2;P3;q0;q1;q2;q3;V1;V2;V3;W1;W2;W3;
%     -W1*q1/2-W2*q2/2-W3*q3/2;
%      W1*q0/2-W2*q3/2+W3*q2/2;
%      W2*q0/2+W1*q3/2-W3*q1/2;
%      W2*q1/2-W1*q2/2+W3*q1/2];

% % 発散 22/11/10 10^54オーダー
% z = [P1;P2;P3;q0;q1;q2;q3;V1;V2;V3;W1;W2;W3;
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
% % クォータニオンを含む13次元の状態量
% z = [P1;P2;P3;q0;q1;q2;q3;V1;V2;V3;W1;W2;W3];
% オイラー角を含む12次元の状態量
z = [P1;P2;P3;Q1;Q2;Q3;V1;V2;V3;W1;W2;W3];

end

