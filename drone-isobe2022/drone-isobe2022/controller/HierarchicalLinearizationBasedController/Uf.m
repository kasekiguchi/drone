function U1 = Uf(in1,in2,in3,in4)
%Uf
%    U1 = Uf(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    17-Feb-2022 16:18:58

V1 = in3(:,1);
ddXd3 = in2(:,11);
gravity = in4(:,9);
m = in4(:,1);
q0 = in1(1,:);
q1 = in1(2,:);
q2 = in1(3,:);
q3 = in1(4,:);
U1 = [(m.*(V1+ddXd3+gravity))./(q0.^2-q1.^2-q2.^2+q3.^2);0.0;0.0;0.0];
