function cZ1 = Z1(in1,in2,in3)
%Z1
%    cZ1 = Z1(IN1,IN2,IN3)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    17-Feb-2022 16:18:54

Xd3 = in2(:,3);
dXd3 = in2(:,7);
dp3 = in1(10,:);
p3 = in1(7,:);
cZ1 = [-Xd3+p3;-dXd3+dp3];
