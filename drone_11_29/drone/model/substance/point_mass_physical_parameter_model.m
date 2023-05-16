function dx = point_mass_physical_parameter_model(in1,in2,in3)
% point mass model with physical parameter

dp1 = in1(4,:);
dp2 = in1(5,:);
dp3 = in1(6,:);
gravity = in3(:,6);
m = in3(:,1);
u1 = in2(1,:);
u2 = in2(2,:);
u3 = in2(3,:);
dx = [dp1;dp2;dp3;u1/m;u2/m;-gravity+u3/m];