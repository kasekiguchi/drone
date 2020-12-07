syms theta
Zero = sym('0');
A = repmat(Zero,[5 5]);
A(4,1:2)= [cos(theta),sin(theta)];
A(5,3) = sym('1');
B = sym('B' ,[5,5], 'real');
H = sym('H',[10,5], 'real');
V =diag([sym('1.0'), sym('1.0'), sym('1.0'), sym('10.0'), sym('10.0')]);
R = sym('1.0E-3');
R = diag(repmat(R,[10,1]));
% P = sym('P(t)', [5 5], 'real');
syms P(t) [5 5]
syms t
eqns = diff(P,t) == -P*A - A'*P + H'*R*H - P*B*V*B'*P;
Sol = dsolve(eqns);

