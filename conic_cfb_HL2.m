function [A,B] = conic_cfb_HL2(refx,refy,in3,in4,xQ,yQ,in7,C)
%conic_cfb_HL2
%    [A,B] = conic_cfb_HL2(REFX,REFY,IN3,IN4,xQ,yQ,IN7,C)

%    This function was generated by the Symbolic Math Toolbox version 24.1.
%    2024/10/02 18:58:53

a1 = in7(1,:);
a2 = in7(2,:);
a3 = in7(3,:);
a4 = in7(4,:);
a5 = in7(5,:);
a6 = in7(6,:);
xix1 = in3(1,:);
xix2 = in3(2,:);
xix3 = in3(3,:);
xix4 = in3(4,:);
xix5 = in3(5,:);
xix6 = in3(6,:);
xiy1 = in4(1,:);
xiy2 = in4(2,:);
xiy3 = in4(3,:);
xiy4 = in4(4,:);
xiy5 = in4(5,:);
xiy6 = in4(6,:);
t2 = a1.*2.0;
t3 = a2.*2.0;
t4 = a1.*4.0;
t5 = a3.*2.0;
t6 = a2.*4.0;
t7 = a4.*2.0;
t8 = a1.*6.0;
t9 = a3.*4.0;
t10 = a2.*6.0;
t11 = a3.*6.0;
t12 = a4.*6.0;
t13 = refx.*2.0;
t14 = refy.*2.0;
t15 = xQ.*2.0;
t16 = xix1.*2.0;
t17 = xix2.*2.0;
t18 = xix3.*2.0;
t19 = xix2.*4.0;
t20 = xix4.*2.0;
t21 = xix5.*2.0;
t22 = xix2.*6.0;
t23 = xix3.*6.0;
t24 = xiy1.*2.0;
t25 = xiy2.*2.0;
t26 = xiy3.*2.0;
t27 = xiy2.*4.0;
t28 = xiy4.*2.0;
t29 = xiy5.*2.0;
t30 = xiy2.*6.0;
t31 = xiy3.*6.0;
t32 = yQ.*2.0;
t38 = xix2.*8.0;
t39 = xix4.*8.0;
t40 = xix3.*1.2e+1;
t41 = xiy2.*8.0;
t42 = xiy4.*8.0;
t43 = xiy3.*1.2e+1;
t33 = a2.*t2;
t34 = a2.*t4;
t35 = t2.*xix2;
t36 = t2.*xiy2;
t37 = -t15;
t44 = -t32;
t50 = t2+t3;
t58 = t4+t6+t9;
t70 = t8+t10+t11+t12;
t45 = a3.*t33;
t46 = t33.*xix2;
t47 = t33.*xiy2;
t51 = a3.*t50;
t52 = t50.*xix2;
t53 = t50.*xix3;
t54 = t50.*xiy2;
t55 = t50.*xiy3;
t56 = t5.*t50;
t57 = t5+t50;
t59 = t13+t16+t37;
t60 = t14+t24+t44;
A = [t59,t60];
if nargout > 1
    t62 = a4.*t58;
    t65 = t58.*xix3;
    t68 = t58.*xiy3;
    t48 = t45.*xix2;
    t49 = t45.*xiy2;
    t61 = a4.*t57;
    t63 = t57.*xix2;
    t64 = t57.*xix4;
    t66 = t57.*xiy2;
    t67 = t57.*xiy4;
    t69 = t7+t57;
    t71 = a1.*t59;
    t72 = a2.*t59;
    t73 = a3.*t59;
    t74 = a4.*t59;
    t75 = a1.*t60;
    t76 = a2.*t60;
    t77 = a3.*t60;
    t78 = a4.*t60;
    t79 = t33+t51;
    t93 = t34+t56+t62;
    t80 = a4.*t79;
    t81 = t79.*xix2;
    t82 = t79.*xix3;
    t83 = t79.*xiy2;
    t84 = t79.*xiy3;
    t85 = t17+t71;
    t86 = t25+t75;
    t90 = t61+t79;
    t96 = t19+t71+t72;
    t97 = t27+t75+t76;
    t100 = t22+t71+t72+t73;
    t101 = t30+t75+t76+t77;
    t108 = t38+t71+t72+t73+t74;
    t109 = t41+t75+t76+t77+t78;
    t87 = a2.*t85;
    t88 = a2.*t86;
    t89 = t45+t80;
    t98 = a3.*t96;
    t99 = a3.*t97;
    t102 = a4.*t100;
    t103 = a4.*t101;
    t91 = t18+t35+t87;
    t92 = t26+t36+t88;
    t110 = t23+t35+t52+t87+t98;
    t111 = t31+t36+t54+t88+t99;
    t116 = t35+t40+t52+t63+t87+t98+t102;
    t117 = t36+t43+t54+t66+t88+t99+t103;
    t94 = a3.*t91;
    t95 = a3.*t92;
    t112 = a4.*t110;
    t113 = a4.*t111;
    t104 = t20+t46+t53+t94;
    t105 = t28+t47+t55+t95;
    t118 = t39+t46+t53+t65+t81+t94+t112;
    t119 = t42+t47+t55+t68+t83+t95+t113;
    t106 = a4.*t104;
    t107 = a4.*t105;
    t114 = t21+t48+t64+t82+t106;
    t115 = t29+t49+t67+t84+t107;
    et1 = -xix6.*(t71+t72+t73+t74+xix2.*1.0e+1+a5.*t59)-xiy6.*(t75+t76+t77+t78+xiy2.*1.0e+1+a5.*t60)-xix5.*(t35+t52+t63+t87+t98+t102+xix3.*2.0e+1+a5.*t108+t69.*xix2)-xiy5.*(t36+t54+t66+t88+t99+t103+xiy3.*2.0e+1+a5.*t109+t69.*xiy2)-xix2.*(xix6.*2.0+a4.*t48+a5.*t114+t69.*xix5+t89.*xix3+t90.*xix4)-xiy2.*(xiy6.*2.0+a4.*t49+a5.*t115+t69.*xiy5+t89.*xiy3+t90.*xiy4)-xix4.*(t46+t53+t65+t81+t94+t112+xix4.*2.0e+1+a5.*t116+t70.*xix3+t90.*xix2)-xiy4.*(t47+t55+t68+t83+t95+t113+xiy4.*2.0e+1+a5.*t117+t70.*xiy3+t90.*xiy2);
    et2 = -a6.*(t59.*xix6+t108.*xix5+t114.*xix2+t116.*xix4+t118.*xix3+t60.*xiy6+t109.*xiy5+t115.*xiy2+t117.*xiy4+t119.*xiy3+a5.*(a4.*(a3.*(t59.*xix3+t85.*xix2+t60.*xiy3+t86.*xiy2+a2.*(a1.*((refx-xQ+xix1).^2+(refy+xiy1-yQ).^2-C.^2)+t59.*xix2+t60.*xiy2))+t59.*xix4+t91.*xix2+t96.*xix3+t60.*xiy4+t92.*xiy2+t97.*xiy3)+t59.*xix5+t100.*xix4+t104.*xix2+t110.*xix3+t60.*xiy5+t101.*xiy4+t105.*xiy2+t111.*xiy3))-xix3.*(t48+t64+t82+t106+xix5.*1.0e+1+a5.*t118+t70.*xix4+t89.*xix2+t93.*xix3)-xiy3.*(t49+t67+t84+t107+xiy5.*1.0e+1+a5.*t119+t70.*xiy4+t89.*xiy2+t93.*xiy3);
    B = et1+et2;
end
end
