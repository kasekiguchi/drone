i=1;
x=[Agent.estimator.result{1,i}.state.q(1:3);Agent.estimator.result{1,i}.state.w(1:3);Agent.estimator.result{1,i}.state.pL(1:3);Agent.estimator.result{1,i}.state.vL(1:3);Agent.estimator.result{1,i}.state.pT(1:3);Agent.estimator.result{1,i}.state.wL(1:3)];
xd=Agent.reference.result{1,i}.state.xd;
P=([0.73, 0.175, 0.175/2, 0.175/2, 0.175/2, 9.81, 0.0301, 0.0301, 0.0301, 0.0301, 0.000008, 0.000008, 0.000008, 0.000008, 0.084, 0.046]);            
result.Z1 = Z1_SuspendedLoad(x,xd',0,P);
             vf=-F1*result.Z1


             function cZ1 = Z1_SuspendedLoad(in1,in2,in3)
%Z1_SuspendedLoad
%    cZ1 = Z1_SuspendedLoad(IN1,IN2,IN3)

%    This function was generated by the Symbolic Math Toolbox version 24.1.
%    2024/04/30 19:51:49

Xd3 = in2(:,3);
dpl3 = in1(13,:);
pl3 = in1(10,:);
cZ1 = [-Xd3+pl3;dpl3];
end