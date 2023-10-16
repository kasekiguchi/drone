function V1 = Vfd_SuspendedLoad(obj,dt,in2,in3,in4,in5)
%VFD_SUSPENDEDLOAD
%    V1 = VFD_SUSPENDEDLOAD(DT,IN2,IN3,IN4,IN5)

%    This function was generated by the Symbolic Math Toolbox version 8.5.
%    19-Aug-2020 17:37:05

Xd3 = in3(:,3);
dXd3 = in3(:,7);
dpl3 = in2(13,:);
f11 = in5(:,1);
f12 = in5(:,2);
pl3 = in2(10,:);
t2 = dt.*f12;
t3 = dt.^2;
t5 = -dpl3;
t6 = -pl3;
t4 = f11.*t2;
t7 = dXd3+t5;
t8 = Xd3+t6;
t9 = t2-1.0;
t11 = (f11.*t3)./2.0;
t12 = (dt.*t2)./2.0;
t10 = f12.*t9;
t13 = -t12;
t16 = t11-1.0;
t14 = -t10;
t15 = dt+t13;
t18 = f11.*t16;
t17 = f11.*t15;
t19 = t4+t18;
t20 = t14+t17;
t21 = -dt.*f11.*(t10-t17);
t22 = dt.*f11.*(t10-t17);
t23 = t15.*t19;
t24 = t16.*t19;
t25 = -t9.*(t10-t17);
t26 = t22+t24;
t27 = t23+t25;
t28 = dt.*f11.*t27;
t30 = t9.*t27;
t31 = t16.*t26;
t32 = t15.*t26;
t29 = -t28;
t34 = t30+t32;
t33 = t29+t31;
V1 = [f11.*t8+f12.*t7,-t8.*t19-t7.*(t10-t17),-t7.*t27+t8.*t26,t7.*t34+t8.*(t28-t31),-t8.*(t16.*(t28-t31)+dt.*f11.*t34)-t7.*(t9.*t34-t15.*(t28-t31))];
