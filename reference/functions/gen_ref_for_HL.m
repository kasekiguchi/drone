function ref = gen_ref_for_HL(xdt)
syms t real
%xd =[xd1(t),xd2(t),xd3(t),xd4(t)];
xd=xdt(t);
dxd =diff(xd,t);
ddxd =diff(dxd,t);
dddxd =diff(ddxd,t);
ddddxd =diff(dddxd,t);
dddddxd =diff(ddddxd,t);
ddddddxd =diff(dddddxd,t);
ref = matlabFunction([xd;dxd;ddxd;dddxd;ddddxd;dddddxd;ddddddxd],'vars',t);
end