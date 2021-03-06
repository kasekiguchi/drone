function U1 = Uf(in1,in2,in3,in4)
%UF
%    U1 = UF(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    13-Mar-2020 17:40:03

V1 = in3(:,1);
ddXd3 = in2(:,11);
gravity = in4(:,6);
m = in4(:,1);
q0 = in1(1,:);
q1 = in1(2,:);
q2 = in1(3,:);
q3 = in1(4,:);
U1 = [(m.*(V1+ddXd3+gravity))./(q0.^2-q1.^2-q2.^2+q3.^2);0.0;0.0;0.0];
