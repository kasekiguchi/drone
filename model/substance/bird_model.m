function dx = bird_model(in1,in2,in3)
% u : force to x,y,z axis and 0
%position
p1 = in1(1,:);
p2 = in1(2,:);
p3 = in1(3,:);

%velocity
dp1 = in1(4,:);
dp2 = in1(5,:);
dp3 = in1(6,:);

%input
u1 = in2(1,:);
u2 = in2(2,:);
u3 = in2(3,:);


dx = [dp1,dp2,dp3,u1,u2,u3]';
end

