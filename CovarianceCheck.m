% x+ = Ax + Bu + Q
% y = Cx + R
% KF 
% 
n = 1; % 状態数
n2 = 0; %パラ数
m = 1; % 出力数
m2 = 0; % 出力数2
A = eye(n+n2); 
syms C [m n+np] real
syms Cl [m2 n+np] real
syms P [n+np n+np] real 
syms Q [n+np n+np] real
syms R [m m] real
syms R2 [m2 m2] real
syms P [n+np n+np] real
G = P*C'/(C*P*C'+R);
Pc1 = A*(eye(n+n2)-G*C)*P*A'+Q;
% Case 2 センサ追加
n = 1; % 状態数
n2 = 0; %パラ数
m = 1; % 出力数
m2 = 1; % 出力数2
A = eye(n+n2); 
syms C [m n+np] real
syms Cl [m2 n+np] real
syms P [n+np n+np] real 
syms Q [n+np n+np] real
syms R [m m] real
syms R2 [m2 m2] real
syms P [n+np n+np] real
Cc2 = [C;Cl];
Rc2 = [R,zeros(m,m2);zeros(m2,m),R2];
G = P*Cc2'/(Cc2*P*Cc2'+Rc2);
Pc2 = A*(eye(n+n2)-G*Cc2)*P*A'+Q;

% Case 3 状態数　+ センサ追加
n = 1; % 状態数
n2 = 1; %パラ数
m = 1; % 出力数
m2 = 1; % 出力数2
A = eye(n+n2); 
syms C [m n+np] real
syms Cl [m2 n+np] real
syms P [n+np n+np] real 
syms Q [n n] real
syms R [m m] real
syms R2 [m2 m2] real
syms P [n+np n+np] real
Qc2 = [Q,zeros(n,n2);zeros(n2,n),zeros(n2)];
Cc2 = [C;Cl];
Rc2 = [R,zeros(m,m2);zeros(m2,m),R2];
G = P*Cc2'/(Cc2*P*Cc2'+Rc2);
Pc3 = A*(eye(n+n2)-G*Cc2)*P*A'+Qc2;
dif = Pc3(1,1) - Pc1;
Pc1v = subs(Pc1,[P1,C1,R1,Q1],[1,1,0.1,0.1]);
Pc3v = subs(Pc2,[P1,C1,Cl1,R1,R21,Q1],[1,1,1,0.1,0.5,0.1]);





