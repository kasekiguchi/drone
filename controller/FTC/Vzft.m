function Vftc = Vzft(in1,in2)
%Vzft
%    Vftc = Vzft(IN1,IN2)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/07/20 15:41:28

sz11 = in2(1,:);
sz12 = in2(2,:);
zF1_1 = in1(1);
zF1_2 = in1(3);
zF1_3 = in1(5);
zF1_4 = in1(7);
zF2_1 = in1(2);
zF2_2 = in1(4);
zF2_3 = in1(6);
zF2_4 = in1(8);
t2 = sz11.*zF1_2;
t3 = sz12.*zF2_2;
t4 = sz11.^2;
t5 = sz12.^2;
t6 = zF1_2.^2;
t7 = zF1_2.^3;
t8 = zF2_2.^2;
t9 = zF2_2.^3;
t12 = -sz11;
t13 = -sz12;
t16 = zF1_4./2.0;
t17 = zF2_4./2.0;
t20 = sz12./2.0e+1;
t21 = sz12./4.0e+1;
t22 = sz12.*(3.0./4.0e+1);
t10 = tanh(t2);
t11 = tanh(t3);
t14 = t4+zF1_3;
t15 = t5+zF2_3;
t23 = -t22;
t24 = t16-1.0;
t26 = t17-1.0;
t18 = t10.^2;
t19 = t11.^2;
t25 = t24-1.0;
t27 = t26-1.0;
t30 = t14.^t16;
t31 = t15.^t17;
t32 = t14.^t24;
t34 = t15.^t26;
t28 = t18-1.0;
t29 = t19-1.0;
t33 = t14.^t25;
t35 = t15.^t27;
t36 = (t10.*t30.*zF1_1)./4.0e+1;
t37 = (t11.*t31.*zF2_1)./4.0e+1;
t38 = (t10.*t30.*zF1_1)./6.4e+2;
t39 = (t11.*t31.*zF2_1)./6.4e+2;
t40 = (t10.*t30.*zF1_1)./3.2e+3;
t41 = t10.*t30.*zF1_1.*9.375e-4;
t42 = (t11.*t31.*zF2_1)./3.2e+3;
t43 = t11.*t31.*zF2_1.*9.375e-4;
t44 = -t40;
t45 = -t41;
t46 = -t42;
t47 = -t43;
t48 = t13+t36+t37;
t49 = t48.^2;
t50 = t48.^3;
t51 = sz11+t21+t44+t46;
t55 = sz12.*t11.*t34.*t48.*zF2_1.*zF2_4.*(-1.0./4.0e+1);
t56 = (t29.*t31.*t48.*zF2_1.*zF2_2)./4.0e+1;
t58 = (sz12.*t11.*t34.*t48.*zF2_1.*zF2_4)./3.2e+3;
t59 = sz12.*t11.*t34.*t48.*zF2_1.*zF2_4.*9.375e-4;
t61 = (t29.*t31.*t48.*zF2_1.*zF2_2)./3.2e+3;
t62 = t29.*t31.*t48.*zF2_1.*zF2_2.*9.375e-4;
t52 = t51.^2;
t53 = t51.^3;
t57 = (t11.*t34.*t49.*zF2_1.*zF2_4)./4.0e+1;
t60 = -t59;
t63 = (t11.*t34.*t49.*zF2_1.*zF2_4)./3.2e+3;
t64 = -t61;
t65 = (t3.*t29.*t34.*t49.*zF2_1.*zF2_4)./2.0e+1;
t66 = (t8.*t11.*t29.*t31.*t49.*zF2_1)./2.0e+1;
t67 = (sz11.*t10.*t32.*t51.*zF1_1.*zF1_4)./4.0e+1;
t69 = (t28.*t30.*t51.*zF1_1.*zF1_2)./4.0e+1;
t71 = (t3.*t29.*t34.*t49.*zF2_1.*zF2_4)./1.6e+3;
t73 = (t8.*t11.*t29.*t31.*t49.*zF2_1)./1.6e+3;
t74 = (sz11.*t10.*t32.*t51.*zF1_1.*zF1_4)./3.2e+3;
t75 = sz11.*t10.*t32.*t51.*zF1_1.*zF1_4.*9.375e-4;
t77 = (t28.*t30.*t51.*zF1_1.*zF1_2)./3.2e+3;
t78 = t28.*t30.*t51.*zF1_1.*zF1_2.*9.375e-4;
t81 = (t5.*t11.*t26.*t35.*t49.*zF2_1.*zF2_4)./2.0e+1;
t83 = (t5.*t11.*t26.*t35.*t49.*zF2_1.*zF2_4)./1.6e+3;
t68 = -t65;
t70 = (t10.*t32.*t52.*zF1_1.*zF1_4)./4.0e+1;
t72 = -t69;
t76 = -t71;
t79 = (t10.*t32.*t52.*zF1_1.*zF1_4)./3.2e+3;
t80 = -t74;
t82 = -t78;
t84 = (t2.*t28.*t32.*t52.*zF1_1.*zF1_4)./2.0e+1;
t86 = (t6.*t10.*t28.*t30.*t52.*zF1_1)./2.0e+1;
t87 = (t2.*t28.*t32.*t52.*zF1_1.*zF1_4)./1.6e+3;
t89 = (t6.*t10.*t28.*t30.*t52.*zF1_1)./1.6e+3;
t90 = (t4.*t10.*t24.*t33.*t52.*zF1_1.*zF1_4)./2.0e+1;
t91 = (t4.*t10.*t24.*t33.*t52.*zF1_1.*zF1_4)./1.6e+3;
t85 = -t84;
t88 = -t87;
t92 = t48+t55+t56+t67+t72;
t93 = sz11+t20+t45+t47+t58+t64+t77+t80;
t95 = (t29.*t31.*t92.*zF2_1.*zF2_2)./4.0e+1;
t96 = sz12.*t11.*t34.*t92.*zF2_1.*zF2_4.*(-1.0./4.0e+1);
t97 = (sz12.*t11.*t34.*t92.*zF2_1.*zF2_4)./3.2e+3;
t98 = (t29.*t31.*t92.*zF2_1.*zF2_2)./3.2e+3;
t100 = (sz11.*t10.*t32.*t93.*zF1_1.*zF1_4)./4.0e+1;
t101 = (t28.*t30.*t93.*zF1_1.*zF1_2)./4.0e+1;
t103 = (sz11.*t10.*t32.*t93.*zF1_1.*zF1_4)./3.2e+3;
t104 = (t28.*t30.*t93.*zF1_1.*zF1_2)./3.2e+3;
t99 = -t97;
t102 = -t101;
t105 = -t104;
t106 = t57+t66+t68+t70+t81+t85+t86+t90+t92+t95+t96+t100+t102;
t107 = t12+t23+t38+t39+t60+t62+t63+t73+t75+t76+t79+t82+t83+t88+t89+t91+t98+t99+t103+t105;
et1 = t7.*t28.^2.*t30.*t53.*zF1_1.*2.0-t9.*t29.^2.*t31.*t50.*zF2_1.*2.0-t28.*t30.*t107.*zF1_1.*zF1_2-t29.*t31.*t106.*zF2_1.*zF2_2+t7.*t18.*t28.*t30.*t53.*zF1_1.*4.0-t9.*t19.*t29.*t31.*t50.*zF2_1.*4.0+sz11.*t10.*t32.*t107.*zF1_1.*zF1_4+sz12.*t11.*t34.*t106.*zF2_1.*zF2_4-t10.*t32.*t51.*t93.*zF1_1.*zF1_4.*3.0-t11.*t34.*t48.*t92.*zF2_1.*zF2_4.*3.0+t28.*t32.*t53.*zF1_1.*zF1_2.*zF1_4.*3.0-t29.*t34.*t50.*zF2_1.*zF2_2.*zF2_4.*3.0-t6.*t10.*t28.*t30.*t51.*t93.*zF1_1.*6.0-t8.*t11.*t29.*t31.*t48.*t92.*zF2_1.*6.0-sz11.*t10.*t24.*t33.*t53.*zF1_1.*zF1_4.*6.0+sz12.*t11.*t26.*t35.*t50.*zF2_1.*zF2_4.*6.0+t2.*t28.*t32.*t51.*t93.*zF1_1.*zF1_4.*6.0+t3.*t29.*t34.*t48.*t92.*zF2_1.*zF2_4.*6.0+sz11.*t2.*t24.*t28.*t33.*t53.*zF1_1.*zF1_4.*6.0-sz12.*t3.*t26.*t29.*t35.*t50.*zF2_1.*zF2_4.*6.0-t4.*t10.*t24.*t33.*t51.*t93.*zF1_1.*zF1_4.*6.0;
et2 = t5.*t11.*t26.*t35.*t48.*t92.*zF2_1.*zF2_4.*-6.0-t2.*t10.*t28.*t32.*t53.*zF1_1.*zF1_2.*zF1_4.*6.0+t3.*t11.*t29.*t34.*t50.*zF2_1.*zF2_2.*zF2_4.*6.0-sz11.^3.*t10.*t14.^(t25-1.0).*t24.*t25.*t53.*zF1_1.*zF1_4.*4.0+sz12.^3.*t11.*t15.^(t27-1.0).*t26.*t27.*t50.*zF2_1.*zF2_4.*4.0;
Vftc = [-t10.*t30.*zF1_1-t11.*t31.*zF2_1,t28.*t30.*t51.*zF1_1.*zF1_2-t29.*t31.*t48.*zF2_1.*zF2_2+sz12.*t11.*t34.*t48.*zF2_1.*zF2_4+t10.*t12.*t32.*t51.*zF1_1.*zF1_4,-t10.*t32.*t52.*zF1_1.*zF1_4-t11.*t34.*t49.*zF2_1.*zF2_4+t28.*t30.*t93.*zF1_1.*zF1_2-t29.*t31.*t92.*zF2_1.*zF2_2-t6.*t10.*t28.*t30.*t52.*zF1_1.*2.0-t8.*t11.*t29.*t31.*t49.*zF2_1.*2.0+sz12.*t11.*t34.*t92.*zF2_1.*zF2_4+t2.*t28.*t32.*t52.*zF1_1.*zF1_4.*2.0+t3.*t29.*t34.*t49.*zF2_1.*zF2_4.*2.0+t10.*t12.*t32.*t93.*zF1_1.*zF1_4-t4.*t10.*t24.*t33.*t52.*zF1_1.*zF1_4.*2.0-t5.*t11.*t26.*t35.*t49.*zF2_1.*zF2_4.*2.0,et1+et2];
end
