function result = stepImpl_entity(obj,x,xd)
% generated using gen_controller_entity_func.m
% generated at : 2024/04/17
% [Input]
% x : 13 state [q p v w] 
% xd : 20 reference [xd yd zd yawd; dxd dyd ..; ddxd ddyd ..; ..]
% [Output]
% u : 4 inputs [total thrust force; 3 torques]
Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4,1)]));
p = x(5:7,1);
q = x(1:4,1);
v = x(8:10,1);
w = x(11:13,1);
x = [R2q(Rb0'*RodriguesQuaternion(q));Rb0'*p;Rb0'*v;Rb0'*w];
xd(1:3)=Rb0'*xd(1:3);
xd(4) = 0;
xd(5:7)=Rb0'*xd(5:7);
xd(9:11)=Rb0'*xd(9:11);
xd(13:15)=Rb0'*xd(13:15);
xd(17:19)=Rb0'*xd(17:19);
vf = Vfd(obj.dt,x,xd',obj.param.P,obj.param.F1);
vs = Vsd(obj.dt,x,xd',vf,obj.param.P,obj.param.F2,obj.param.F3,obj.param.F4);
tmp = Uf(x,xd',vf,obj.param.P) + Us(x,xd',vf,vs',obj.param.P);
% max,min are applied for the safty
obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
result = obj.result;
end