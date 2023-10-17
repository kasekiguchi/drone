function dX = tmp_cable_suspended_rigid_body_with_6_drones(in1,in2,in3,in4,in5,in6)
%TMP_CABLE_SUSPENDED_RIGID_BODY_WITH_6_DRONES
%    dX = TMP_CABLE_SUSPENDED_RIGID_BODY_WITH_6_DRONES(IN1,IN2,IN3,IN4,IN5,IN6)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/08/16 21:12:59

Mi1_1 = in4(2,:);
Mi1_2 = in4(6,:);
Mi1_3 = in4(10,:);
Mi1_4 = in4(14,:);
Mi1_5 = in4(18,:);
Mi1_6 = in4(22,:);
Mi2_1 = in4(3,:);
Mi2_2 = in4(7,:);
Mi2_3 = in4(11,:);
Mi2_4 = in4(15,:);
Mi2_5 = in4(19,:);
Mi2_6 = in4(23,:);
Mi3_1 = in4(4,:);
Mi3_2 = in4(8,:);
Mi3_3 = in4(12,:);
Mi3_4 = in4(16,:);
Mi3_5 = in4(20,:);
Mi3_6 = in4(24,:);
R01_1 = in2(1);
R01_2 = in2(4);
R01_3 = in2(7);
R02_1 = in2(2);
R02_2 = in2(5);
R02_3 = in2(8);
R03_1 = in2(3);
R03_2 = in2(6);
R03_3 = in2(9);
Ri1_3_1 = in3(7);
Ri1_3_2 = in3(16);
Ri1_3_3 = in3(25);
Ri1_3_4 = in3(34);
Ri1_3_5 = in3(43);
Ri1_3_6 = in3(52);
Ri2_3_1 = in3(8);
Ri2_3_2 = in3(17);
Ri2_3_3 = in3(26);
Ri2_3_4 = in3(35);
Ri2_3_5 = in3(44);
Ri2_3_6 = in3(53);
Ri3_3_1 = in3(9);
Ri3_3_2 = in3(18);
Ri3_3_3 = in3(27);
Ri3_3_4 = in3(36);
Ri3_3_5 = in3(45);
Ri3_3_6 = in3(54);
ddX1 = in6(1,:);
ddX2 = in6(2,:);
ddX3 = in6(3,:);
ddX4 = in6(4,:);
ddX5 = in6(5,:);
ddX6 = in6(6,:);
dx01 = in1(8,:);
dx02 = in1(9,:);
dx03 = in1(10,:);
fi1 = in4(1,:);
fi2 = in4(5,:);
fi3 = in4(9,:);
fi4 = in4(13,:);
fi5 = in4(17,:);
fi6 = in4(21,:);
g = in5(:,1);
ji1_1 = in5(:,36);
ji1_2 = in5(:,39);
ji1_3 = in5(:,42);
ji1_4 = in5(:,45);
ji1_5 = in5(:,48);
ji1_6 = in5(:,51);
ji2_1 = in5(:,37);
ji2_2 = in5(:,40);
ji2_3 = in5(:,43);
ji2_4 = in5(:,46);
ji2_5 = in5(:,49);
ji2_6 = in5(:,52);
ji3_1 = in5(:,38);
ji3_2 = in5(:,41);
ji3_3 = in5(:,44);
ji3_4 = in5(:,47);
ji3_5 = in5(:,50);
ji3_6 = in5(:,53);
li1 = in5(:,24);
li2 = in5(:,25);
li3 = in5(:,26);
li4 = in5(:,27);
li5 = in5(:,28);
li6 = in5(:,29);
mi1 = in5(:,30);
mi2 = in5(:,31);
mi3 = in5(:,32);
mi4 = in5(:,33);
mi5 = in5(:,34);
mi6 = in5(:,35);
o01 = in1(11,:);
o02 = in1(12,:);
o03 = in1(13,:);
oi1_1 = in1(74,:);
oi1_2 = in1(77,:);
oi1_3 = in1(80,:);
oi1_4 = in1(83,:);
oi1_5 = in1(86,:);
oi1_6 = in1(89,:);
oi2_1 = in1(75,:);
oi2_2 = in1(78,:);
oi2_3 = in1(81,:);
oi2_4 = in1(84,:);
oi2_5 = in1(87,:);
oi2_6 = in1(90,:);
oi3_1 = in1(76,:);
oi3_2 = in1(79,:);
oi3_3 = in1(82,:);
oi3_4 = in1(85,:);
oi3_5 = in1(88,:);
oi3_6 = in1(91,:);
qi1_1 = in1(14,:);
qi1_2 = in1(17,:);
qi1_3 = in1(20,:);
qi1_4 = in1(23,:);
qi1_5 = in1(26,:);
qi1_6 = in1(29,:);
qi2_1 = in1(15,:);
qi2_2 = in1(18,:);
qi2_3 = in1(21,:);
qi2_4 = in1(24,:);
qi2_5 = in1(27,:);
qi2_6 = in1(30,:);
qi3_1 = in1(16,:);
qi3_2 = in1(19,:);
qi3_3 = in1(22,:);
qi3_4 = in1(25,:);
qi3_5 = in1(28,:);
qi3_6 = in1(31,:);
r01 = in1(4,:);
r02 = in1(5,:);
r03 = in1(6,:);
r04 = in1(7,:);
rho1_1 = in5(:,6);
rho1_2 = in5(:,9);
rho1_3 = in5(:,12);
rho1_4 = in5(:,15);
rho1_5 = in5(:,18);
rho1_6 = in5(:,21);
rho2_1 = in5(:,7);
rho2_2 = in5(:,10);
rho2_3 = in5(:,13);
rho2_4 = in5(:,16);
rho2_5 = in5(:,19);
rho2_6 = in5(:,22);
rho3_1 = in5(:,8);
rho3_2 = in5(:,11);
rho3_3 = in5(:,14);
rho3_4 = in5(:,17);
rho3_5 = in5(:,20);
rho3_6 = in5(:,23);
ri1_1 = in1(50,:);
ri1_2 = in1(54,:);
ri1_3 = in1(58,:);
ri1_4 = in1(62,:);
ri1_5 = in1(66,:);
ri1_6 = in1(70,:);
ri2_1 = in1(51,:);
ri2_2 = in1(55,:);
ri2_3 = in1(59,:);
ri2_4 = in1(63,:);
ri2_5 = in1(67,:);
ri2_6 = in1(71,:);
ri3_1 = in1(52,:);
ri3_2 = in1(56,:);
ri3_3 = in1(60,:);
ri3_4 = in1(64,:);
ri3_5 = in1(68,:);
ri3_6 = in1(72,:);
ri4_1 = in1(53,:);
ri4_2 = in1(57,:);
ri4_3 = in1(61,:);
ri4_4 = in1(65,:);
ri4_5 = in1(69,:);
ri4_6 = in1(73,:);
wi1_1 = in1(32,:);
wi1_2 = in1(35,:);
wi1_3 = in1(38,:);
wi1_4 = in1(41,:);
wi1_5 = in1(44,:);
wi1_6 = in1(47,:);
wi2_1 = in1(33,:);
wi2_2 = in1(36,:);
wi2_3 = in1(39,:);
wi2_4 = in1(42,:);
wi2_5 = in1(45,:);
wi2_6 = in1(48,:);
wi3_1 = in1(34,:);
wi3_2 = in1(37,:);
wi3_3 = in1(40,:);
wi3_4 = in1(43,:);
wi3_5 = in1(46,:);
wi3_6 = in1(49,:);
t2 = R01_2.*rho1_1;
t3 = R01_2.*rho1_2;
t4 = R01_3.*rho1_1;
t5 = R01_2.*rho1_3;
t6 = R01_3.*rho1_2;
t7 = R01_2.*rho1_4;
t8 = R01_3.*rho1_3;
t9 = R01_2.*rho1_5;
t10 = R01_3.*rho1_4;
t11 = R01_2.*rho1_6;
t12 = R01_3.*rho1_5;
t13 = R01_3.*rho1_6;
t14 = R01_1.*rho2_1;
t15 = R01_1.*rho2_2;
t16 = R02_2.*rho1_1;
t17 = R01_1.*rho2_3;
t18 = R01_3.*rho2_1;
t19 = R02_2.*rho1_2;
t20 = R02_3.*rho1_1;
t21 = R01_1.*rho2_4;
t22 = R01_3.*rho2_2;
t23 = R02_2.*rho1_3;
t24 = R02_3.*rho1_2;
t25 = R01_1.*rho2_5;
t26 = R01_3.*rho2_3;
t27 = R02_2.*rho1_4;
t28 = R02_3.*rho1_3;
t29 = R01_1.*rho2_6;
t30 = R01_3.*rho2_4;
t31 = R02_2.*rho1_5;
t32 = R02_3.*rho1_4;
t33 = R01_3.*rho2_5;
t34 = R02_2.*rho1_6;
t35 = R02_3.*rho1_5;
t36 = R01_3.*rho2_6;
t37 = R02_3.*rho1_6;
t38 = R01_1.*rho3_1;
t39 = R02_1.*rho2_1;
t40 = R01_1.*rho3_2;
t41 = R01_2.*rho3_1;
t42 = R02_1.*rho2_2;
t43 = R03_2.*rho1_1;
t44 = R01_1.*rho3_3;
t45 = R01_2.*rho3_2;
t46 = R02_1.*rho2_3;
t47 = R02_3.*rho2_1;
t48 = R03_2.*rho1_2;
t49 = R03_3.*rho1_1;
t50 = R01_1.*rho3_4;
t51 = R01_2.*rho3_3;
t52 = R02_1.*rho2_4;
t53 = R02_3.*rho2_2;
t54 = R03_2.*rho1_3;
t55 = R03_3.*rho1_2;
t56 = R01_1.*rho3_5;
t57 = R01_2.*rho3_4;
t58 = R02_1.*rho2_5;
t59 = R02_3.*rho2_3;
t60 = R03_2.*rho1_4;
t61 = R03_3.*rho1_3;
t62 = R01_1.*rho3_6;
t63 = R01_2.*rho3_5;
t64 = R02_1.*rho2_6;
t65 = R02_3.*rho2_4;
t66 = R03_2.*rho1_5;
t67 = R03_3.*rho1_4;
t68 = R01_2.*rho3_6;
t69 = R02_3.*rho2_5;
t70 = R03_2.*rho1_6;
t71 = R03_3.*rho1_5;
t72 = R02_3.*rho2_6;
t73 = R03_3.*rho1_6;
t74 = R02_1.*rho3_1;
t75 = R03_1.*rho2_1;
t76 = R02_1.*rho3_2;
t77 = R02_2.*rho3_1;
t78 = R03_1.*rho2_2;
t79 = R02_1.*rho3_3;
t80 = R02_2.*rho3_2;
t81 = R03_1.*rho2_3;
t82 = R03_3.*rho2_1;
t83 = R02_1.*rho3_4;
t84 = R02_2.*rho3_3;
t85 = R03_1.*rho2_4;
t86 = R03_3.*rho2_2;
t87 = R02_1.*rho3_5;
t88 = R02_2.*rho3_4;
t89 = R03_1.*rho2_5;
t90 = R03_3.*rho2_3;
t91 = R02_1.*rho3_6;
t92 = R02_2.*rho3_5;
t93 = R03_1.*rho2_6;
t94 = R03_3.*rho2_4;
t95 = R02_2.*rho3_6;
t96 = R03_3.*rho2_5;
t97 = R03_3.*rho2_6;
t98 = R03_1.*rho3_1;
t99 = R03_1.*rho3_2;
t100 = R03_2.*rho3_1;
t101 = R03_1.*rho3_3;
t102 = R03_2.*rho3_2;
t103 = R03_1.*rho3_4;
t104 = R03_2.*rho3_3;
t105 = R03_1.*rho3_5;
t106 = R03_2.*rho3_4;
t107 = R03_1.*rho3_6;
t108 = R03_2.*rho3_5;
t109 = R03_2.*rho3_6;
t110 = o01.^2;
t111 = o02.^2;
t112 = o03.^2;
t113 = qi1_1.^2;
t114 = qi1_2.^2;
t115 = qi1_3.^2;
t116 = qi1_4.^2;
t117 = qi1_5.^2;
t118 = qi1_6.^2;
t119 = qi2_1.^2;
t120 = qi2_2.^2;
t121 = qi2_3.^2;
t122 = qi2_4.^2;
t123 = qi2_5.^2;
t124 = qi2_6.^2;
t125 = qi3_1.^2;
t126 = qi3_2.^2;
t127 = qi3_3.^2;
t128 = qi3_4.^2;
t129 = qi3_5.^2;
t130 = qi3_6.^2;
t131 = R01_1.*o01.*o02;
t132 = R01_1.*o01.*o03;
t133 = R01_2.*o01.*o02;
t134 = R01_2.*o02.*o03;
t135 = R01_3.*o01.*o03;
t136 = R01_3.*o02.*o03;
t137 = R02_1.*o01.*o02;
t138 = R02_1.*o01.*o03;
t139 = R02_2.*o01.*o02;
t140 = R02_2.*o02.*o03;
t141 = R02_3.*o01.*o03;
t142 = R02_3.*o02.*o03;
t143 = R03_1.*o01.*o02;
t144 = R03_1.*o01.*o03;
t145 = R03_2.*o01.*o02;
t146 = R03_2.*o02.*o03;
t147 = R03_3.*o01.*o03;
t148 = R03_3.*o02.*o03;
t149 = 1.0./li1;
t150 = 1.0./li2;
t151 = 1.0./li3;
t152 = 1.0./li4;
t153 = 1.0./li5;
t154 = 1.0./li6;
t155 = 1.0./mi1;
t156 = 1.0./mi2;
t157 = 1.0./mi3;
t158 = 1.0./mi4;
t159 = 1.0./mi5;
t160 = 1.0./mi6;
t215 = Ri1_3_1.*fi1.*qi1_1.*qi2_1;
t216 = Ri1_3_2.*fi2.*qi1_2.*qi2_2;
t217 = Ri1_3_3.*fi3.*qi1_3.*qi2_3;
t218 = Ri1_3_1.*fi1.*qi1_1.*qi3_1;
t219 = Ri1_3_4.*fi4.*qi1_4.*qi2_4;
t220 = Ri1_3_2.*fi2.*qi1_2.*qi3_2;
t221 = Ri1_3_5.*fi5.*qi1_5.*qi2_5;
t222 = Ri1_3_3.*fi3.*qi1_3.*qi3_3;
t223 = Ri1_3_6.*fi6.*qi1_6.*qi2_6;
t224 = Ri1_3_4.*fi4.*qi1_4.*qi3_4;
t225 = Ri1_3_5.*fi5.*qi1_5.*qi3_5;
t226 = Ri1_3_6.*fi6.*qi1_6.*qi3_6;
t227 = Ri2_3_1.*fi1.*qi1_1.*qi2_1;
t228 = Ri2_3_2.*fi2.*qi1_2.*qi2_2;
t229 = Ri2_3_3.*fi3.*qi1_3.*qi2_3;
t230 = Ri2_3_4.*fi4.*qi1_4.*qi2_4;
t231 = Ri2_3_5.*fi5.*qi1_5.*qi2_5;
t232 = Ri2_3_1.*fi1.*qi2_1.*qi3_1;
t233 = Ri2_3_6.*fi6.*qi1_6.*qi2_6;
t234 = Ri2_3_2.*fi2.*qi2_2.*qi3_2;
t235 = Ri2_3_3.*fi3.*qi2_3.*qi3_3;
t236 = Ri2_3_4.*fi4.*qi2_4.*qi3_4;
t237 = Ri2_3_5.*fi5.*qi2_5.*qi3_5;
t238 = Ri2_3_6.*fi6.*qi2_6.*qi3_6;
t239 = Ri3_3_1.*fi1.*qi1_1.*qi3_1;
t240 = Ri3_3_2.*fi2.*qi1_2.*qi3_2;
t241 = Ri3_3_3.*fi3.*qi1_3.*qi3_3;
t242 = Ri3_3_1.*fi1.*qi2_1.*qi3_1;
t243 = Ri3_3_4.*fi4.*qi1_4.*qi3_4;
t244 = Ri3_3_2.*fi2.*qi2_2.*qi3_2;
t245 = Ri3_3_5.*fi5.*qi1_5.*qi3_5;
t246 = Ri3_3_3.*fi3.*qi2_3.*qi3_3;
t247 = Ri3_3_6.*fi6.*qi1_6.*qi3_6;
t248 = Ri3_3_4.*fi4.*qi2_4.*qi3_4;
t249 = Ri3_3_5.*fi5.*qi2_5.*qi3_5;
t250 = Ri3_3_6.*fi6.*qi2_6.*qi3_6;
t161 = -t14;
t162 = -t15;
t163 = -t17;
t164 = -t21;
t165 = -t25;
t166 = -t29;
t167 = -t38;
t168 = -t39;
t169 = -t40;
t170 = -t41;
t171 = -t42;
t172 = -t44;
t173 = -t45;
t174 = -t46;
t175 = -t50;
t176 = -t51;
t177 = -t52;
t178 = -t56;
t179 = -t57;
t180 = -t58;
t181 = -t62;
t182 = -t63;
t183 = -t64;
t184 = -t68;
t185 = -t74;
t186 = -t75;
t187 = -t76;
t188 = -t77;
t189 = -t78;
t190 = -t79;
t191 = -t80;
t192 = -t81;
t193 = -t83;
t194 = -t84;
t195 = -t85;
t196 = -t87;
t197 = -t88;
t198 = -t89;
t199 = -t91;
t200 = -t92;
t201 = -t93;
t202 = -t95;
t203 = -t98;
t204 = -t99;
t205 = -t100;
t206 = -t101;
t207 = -t102;
t208 = -t103;
t209 = -t104;
t210 = -t105;
t211 = -t106;
t212 = -t107;
t213 = -t108;
t214 = -t109;
t251 = t113-1.0;
t252 = t114-1.0;
t253 = t115-1.0;
t254 = t116-1.0;
t255 = t117-1.0;
t256 = t118-1.0;
t257 = t119-1.0;
t258 = t120-1.0;
t259 = t121-1.0;
t260 = t122-1.0;
t261 = t123-1.0;
t262 = t124-1.0;
t263 = t125-1.0;
t264 = t126-1.0;
t265 = t127-1.0;
t266 = t128-1.0;
t267 = t129-1.0;
t268 = t130-1.0;
t269 = t110+t111;
t270 = t110+t112;
t271 = t111+t112;
t272 = Ri1_3_1.*fi1.*t251;
t273 = Ri1_3_2.*fi2.*t252;
t274 = Ri1_3_3.*fi3.*t253;
t275 = Ri1_3_4.*fi4.*t254;
t276 = Ri1_3_5.*fi5.*t255;
t277 = Ri1_3_6.*fi6.*t256;
t278 = Ri2_3_1.*fi1.*t257;
t279 = Ri2_3_2.*fi2.*t258;
t280 = Ri2_3_3.*fi3.*t259;
t281 = Ri2_3_4.*fi4.*t260;
t282 = Ri2_3_5.*fi5.*t261;
t283 = Ri2_3_6.*fi6.*t262;
t284 = Ri3_3_1.*fi1.*t263;
t285 = Ri3_3_2.*fi2.*t264;
t286 = Ri3_3_3.*fi3.*t265;
t287 = Ri3_3_4.*fi4.*t266;
t288 = Ri3_3_5.*fi5.*t267;
t289 = Ri3_3_6.*fi6.*t268;
t290 = t2+t161;
t291 = t3+t162;
t292 = t5+t163;
t293 = t7+t164;
t294 = t9+t165;
t295 = t11+t166;
t296 = t4+t167;
t297 = t6+t169;
t298 = t8+t172;
t299 = t10+t175;
t300 = t12+t178;
t301 = t16+t168;
t302 = t13+t181;
t303 = t18+t170;
t304 = t19+t171;
t305 = t22+t173;
t306 = t23+t174;
t307 = t26+t176;
dX = ft_1({Mi1_1,Mi1_2,Mi1_3,Mi1_4,Mi1_5,Mi1_6,Mi2_1,Mi2_2,Mi2_3,Mi2_4,Mi2_5,Mi2_6,Mi3_1,Mi3_2,Mi3_3,Mi3_4,Mi3_5,Mi3_6,R01_1,R01_2,R01_3,R02_1,R02_2,R02_3,R03_1,R03_2,R03_3,ddX1,ddX2,ddX3,ddX4,ddX5,ddX6,dx01,dx02,dx03,g,ji1_1,ji1_2,ji1_3,ji1_4,ji1_5,ji1_6,ji2_1,ji2_2,ji2_3,ji2_4,ji2_5,ji2_6,ji3_1,ji3_2,ji3_3,ji3_4,ji3_5,ji3_6,o01,o02,o03,oi1_1,oi1_2,oi1_3,oi1_4,oi1_5,oi1_6,oi2_1,oi2_2,oi2_3,oi2_4,oi2_5,oi2_6,oi3_1,oi3_2,oi3_3,oi3_4,oi3_5,oi3_6,qi1_1,qi1_2,qi1_3,qi1_4,qi1_5,qi1_6,qi2_1,qi2_2,qi2_3,qi2_4,qi2_5,qi2_6,qi3_1,qi3_2,qi3_3,qi3_4,qi3_5,qi3_6,r01,r02,r03,r04,rho1_1,rho1_2,rho1_3,rho1_4,rho1_5,rho1_6,rho2_1,rho2_2,rho2_3,rho2_4,rho2_5,rho2_6,rho3_1,rho3_2,rho3_3,rho3_4,rho3_5,rho3_6,ri1_1,ri1_2,ri1_3,ri1_4,ri1_5,ri1_6,ri2_1,ri2_2,ri2_3,ri2_4,ri2_5,ri2_6,ri3_1,ri3_2,ri3_3,ri3_4,ri3_5,ri3_6,ri4_1,ri4_2,ri4_3,ri4_4,ri4_5,ri4_6,t131,t132,t133,t134,t135,t136,t137,t138,t139,t140,t141,t142,t143,t144,t145,t146,t147,t148,t149,t150,t151,t152,t153,t154,t155,t156,t157,t158,t159,t160,t177,t179,t180,t182,t183,t184,t185,t186,t187,t188,t189,t190,t191,t192,t193,t194,t195,t196,t197,t198,t199,t20,t200,t201,t202,t203,t204,t205,t206,t207,t208,t209,t210,t211,t212,t213,t214,t215,t216,t217,t218,t219,t220,t221,t222,t223,t224,t225,t226,t227,t228,t229,t230,t231,t232,t233,t234,t235,t236,t237,t238,t239,t24,t240,t241,t242,t243,t244,t245,t246,t247,t248,t249,t250,t269,t27,t270,t271,t272,t273,t274,t275,t276,t277,t278,t279,t28,t280,t281,t282,t283,t284,t285,t286,t287,t288,t289,t290,t291,t292,t293,t294,t295,t296,t297,t298,t299,t30,t300,t301,t302,t303,t304,t305,t306,t307,t31,t32,t33,t34,t35,t36,t37,t43,t47,t48,t49,t53,t54,t55,t59,t60,t61,t65,t66,t67,t69,t70,t71,t72,t73,t82,t86,t90,t94,t96,t97,wi1_1,wi1_2,wi1_3,wi1_4,wi1_5,wi1_6,wi2_1,wi2_2,wi2_3,wi2_4,wi2_5,wi2_6,wi3_1,wi3_2,wi3_3,wi3_4,wi3_5,wi3_6});
end
function dX = ft_1(ct)
[Mi1_1,Mi1_2,Mi1_3,Mi1_4,Mi1_5,Mi1_6,Mi2_1,Mi2_2,Mi2_3,Mi2_4,Mi2_5,Mi2_6,Mi3_1,Mi3_2,Mi3_3,Mi3_4,Mi3_5,Mi3_6,R01_1,R01_2,R01_3,R02_1,R02_2,R02_3,R03_1,R03_2,R03_3,ddX1,ddX2,ddX3,ddX4,ddX5,ddX6,dx01,dx02,dx03,g,ji1_1,ji1_2,ji1_3,ji1_4,ji1_5,ji1_6,ji2_1,ji2_2,ji2_3,ji2_4,ji2_5,ji2_6,ji3_1,ji3_2,ji3_3,ji3_4,ji3_5,ji3_6,o01,o02,o03,oi1_1,oi1_2,oi1_3,oi1_4,oi1_5,oi1_6,oi2_1,oi2_2,oi2_3,oi2_4,oi2_5,oi2_6,oi3_1,oi3_2,oi3_3,oi3_4,oi3_5,oi3_6,qi1_1,qi1_2,qi1_3,qi1_4,qi1_5,qi1_6,qi2_1,qi2_2,qi2_3,qi2_4,qi2_5,qi2_6,qi3_1,qi3_2,qi3_3,qi3_4,qi3_5,qi3_6,r01,r02,r03,r04,rho1_1,rho1_2,rho1_3,rho1_4,rho1_5,rho1_6,rho2_1,rho2_2,rho2_3,rho2_4,rho2_5,rho2_6,rho3_1,rho3_2,rho3_3,rho3_4,rho3_5,rho3_6,ri1_1,ri1_2,ri1_3,ri1_4,ri1_5,ri1_6,ri2_1,ri2_2,ri2_3,ri2_4,ri2_5,ri2_6,ri3_1,ri3_2,ri3_3,ri3_4,ri3_5,ri3_6,ri4_1,ri4_2,ri4_3,ri4_4,ri4_5,ri4_6,t131,t132,t133,t134,t135,t136,t137,t138,t139,t140,t141,t142,t143,t144,t145,t146,t147,t148,t149,t150,t151,t152,t153,t154,t155,t156,t157,t158,t159,t160,t177,t179,t180,t182,t183,t184,t185,t186,t187,t188,t189,t190,t191,t192,t193,t194,t195,t196,t197,t198,t199,t20,t200,t201,t202,t203,t204,t205,t206,t207,t208,t209,t210,t211,t212,t213,t214,t215,t216,t217,t218,t219,t220,t221,t222,t223,t224,t225,t226,t227,t228,t229,t230,t231,t232,t233,t234,t235,t236,t237,t238,t239,t24,t240,t241,t242,t243,t244,t245,t246,t247,t248,t249,t250,t269,t27,t270,t271,t272,t273,t274,t275,t276,t277,t278,t279,t28,t280,t281,t282,t283,t284,t285,t286,t287,t288,t289,t290,t291,t292,t293,t294,t295,t296,t297,t298,t299,t30,t300,t301,t302,t303,t304,t305,t306,t307,t31,t32,t33,t34,t35,t36,t37,t43,t47,t48,t49,t53,t54,t55,t59,t60,t61,t65,t66,t67,t69,t70,t71,t72,t73,t82,t86,t90,t94,t96,t97,wi1_1,wi1_2,wi1_3,wi1_4,wi1_5,wi1_6,wi2_1,wi2_2,wi2_3,wi2_4,wi2_5,wi2_6,wi3_1,wi3_2,wi3_3,wi3_4,wi3_5,wi3_6] = ct{:};
t308 = t27+t177;
t309 = t30+t179;
t310 = t31+t180;
t311 = t33+t182;
t312 = t34+t183;
t313 = t20+t185;
t314 = t36+t184;
t315 = t24+t187;
t316 = t28+t190;
t317 = t32+t193;
t318 = t35+t196;
t319 = t43+t186;
t320 = t37+t199;
t321 = t47+t188;
t322 = t48+t189;
t323 = t53+t191;
t324 = t54+t192;
t325 = t59+t194;
t326 = t60+t195;
t327 = t65+t197;
t328 = t66+t198;
t329 = t69+t200;
t330 = t70+t201;
t331 = t49+t203;
t332 = t72+t202;
t333 = t55+t204;
t334 = t61+t206;
t335 = t67+t208;
t336 = t71+t210;
t337 = t73+t212;
t338 = t82+t205;
t339 = t86+t207;
t340 = t90+t209;
t341 = t94+t211;
t342 = t96+t213;
t343 = t97+t214;
t344 = R01_1.*t271;
t345 = R01_2.*t270;
t346 = R01_3.*t269;
t347 = R02_1.*t271;
t348 = R02_2.*t270;
t349 = R02_3.*t269;
t350 = R03_1.*t271;
t351 = R03_2.*t270;
t352 = R03_3.*t269;
t353 = ddX6.*t290;
t354 = ddX6.*t291;
t355 = ddX6.*t292;
t356 = ddX6.*t293;
t357 = ddX6.*t294;
t358 = ddX5.*t296;
t359 = ddX6.*t295;
t360 = ddX5.*t297;
t361 = ddX5.*t298;
t362 = ddX5.*t299;
t363 = ddX5.*t300;
t364 = ddX4.*t303;
t365 = ddX5.*t302;
t366 = ddX6.*t301;
t367 = ddX4.*t305;
t368 = ddX6.*t304;
t369 = ddX4.*t307;
t370 = ddX6.*t306;
t371 = ddX4.*t309;
t372 = ddX6.*t308;
t373 = ddX4.*t311;
t374 = ddX6.*t310;
t375 = ddX4.*t314;
t376 = ddX5.*t313;
t377 = ddX6.*t312;
t378 = ddX5.*t315;
t379 = ddX5.*t316;
t380 = ddX5.*t317;
t381 = ddX5.*t318;
t382 = ddX4.*t321;
t383 = ddX5.*t320;
t384 = ddX6.*t319;
t385 = ddX4.*t323;
t386 = ddX6.*t322;
t387 = ddX4.*t325;
t388 = ddX6.*t324;
t389 = ddX4.*t327;
t390 = ddX6.*t326;
t391 = ddX4.*t329;
t392 = ddX6.*t328;
t393 = ddX4.*t332;
t394 = ddX5.*t331;
t395 = ddX6.*t330;
t396 = ddX5.*t333;
t397 = ddX5.*t334;
t398 = ddX5.*t335;
t399 = ddX5.*t336;
t400 = ddX4.*t338;
t401 = ddX5.*t337;
t402 = ddX4.*t339;
t403 = ddX4.*t340;
t404 = ddX4.*t341;
t405 = ddX4.*t342;
t406 = ddX4.*t343;
t407 = -t344;
t408 = -t345;
t409 = -t346;
t410 = -t347;
t411 = -t348;
t412 = -t349;
t413 = -t350;
t414 = -t351;
t415 = -t352;
t443 = t227+t239+t272;
t444 = t228+t240+t273;
t445 = t215+t242+t278;
t446 = t229+t241+t274;
t447 = t216+t244+t279;
t448 = t230+t243+t275;
t449 = t218+t232+t284;
t450 = t217+t246+t280;
t451 = t231+t245+t276;
t452 = t220+t234+t285;
t453 = t219+t248+t281;
t454 = t233+t247+t277;
t455 = t222+t235+t286;
t456 = t221+t249+t282;
t457 = t224+t236+t287;
t458 = t223+t250+t283;
t459 = t225+t237+t288;
t460 = t226+t238+t289;
t416 = -t358;
t417 = -t360;
t418 = -t361;
t419 = -t362;
t420 = -t363;
t421 = -t365;
t422 = -t376;
t423 = -t378;
t424 = -t379;
t425 = -t380;
t426 = -t381;
t427 = -t383;
t428 = -t394;
t429 = -t396;
t430 = -t397;
t431 = -t398;
t432 = -t399;
t433 = -t401;
t434 = t133+t135+t407;
t435 = t131+t136+t408;
t436 = t132+t134+t409;
t437 = t139+t141+t410;
t438 = t137+t142+t411;
t439 = t138+t140+t412;
t440 = t145+t147+t413;
t441 = t143+t148+t414;
t442 = t144+t146+t415;
t461 = rho1_1.*t434;
t462 = rho1_2.*t434;
t463 = rho1_3.*t434;
t464 = rho1_4.*t434;
t465 = rho1_5.*t434;
t466 = rho1_6.*t434;
t467 = rho2_1.*t435;
t468 = rho2_2.*t435;
t469 = rho2_3.*t435;
t470 = rho2_4.*t435;
t471 = rho2_5.*t435;
t472 = rho2_6.*t435;
t473 = rho3_1.*t436;
t474 = rho3_2.*t436;
t475 = rho3_3.*t436;
t476 = rho3_4.*t436;
t477 = rho3_5.*t436;
t478 = rho3_6.*t436;
t479 = rho1_1.*t437;
t480 = rho1_2.*t437;
t481 = rho1_3.*t437;
t482 = rho1_4.*t437;
t483 = rho1_5.*t437;
t484 = rho1_6.*t437;
t485 = rho2_1.*t438;
t486 = rho2_2.*t438;
t487 = rho2_3.*t438;
t488 = rho2_4.*t438;
t489 = rho2_5.*t438;
t490 = rho2_6.*t438;
t491 = rho3_1.*t439;
t492 = rho3_2.*t439;
t493 = rho3_3.*t439;
t494 = rho3_4.*t439;
t495 = rho3_5.*t439;
t496 = rho3_6.*t439;
t497 = rho1_1.*t440;
t498 = rho1_2.*t440;
t499 = rho1_3.*t440;
t500 = rho1_4.*t440;
t501 = rho1_5.*t440;
t502 = rho1_6.*t440;
t503 = rho2_1.*t441;
t504 = rho2_2.*t441;
t505 = rho2_3.*t441;
t506 = rho2_4.*t441;
t507 = rho2_5.*t441;
t508 = rho2_6.*t441;
t509 = rho3_1.*t442;
t510 = rho3_2.*t442;
t511 = rho3_3.*t442;
t512 = rho3_4.*t442;
t513 = rho3_5.*t442;
t514 = rho3_6.*t442;
t515 = ddX1+t353+t364+t416+t461+t467+t473;
t516 = ddX1+t354+t367+t417+t462+t468+t474;
t517 = ddX1+t355+t369+t418+t463+t469+t475;
t518 = ddX1+t356+t371+t419+t464+t470+t476;
t519 = ddX1+t357+t373+t420+t465+t471+t477;
t520 = ddX1+t359+t375+t421+t466+t472+t478;
t521 = ddX2+t366+t382+t422+t479+t485+t491;
t522 = ddX2+t368+t385+t423+t480+t486+t492;
t523 = ddX2+t370+t387+t424+t481+t487+t493;
t524 = ddX2+t372+t389+t425+t482+t488+t494;
t525 = ddX2+t374+t391+t426+t483+t489+t495;
t526 = ddX2+t377+t393+t427+t484+t490+t496;
t527 = ddX3+g+t384+t400+t428+t497+t503+t509;
t528 = ddX3+g+t386+t402+t429+t498+t504+t510;
t529 = ddX3+g+t388+t403+t430+t499+t505+t511;
t530 = ddX3+g+t390+t404+t431+t500+t506+t512;
t531 = ddX3+g+t392+t405+t432+t501+t507+t513;
t532 = ddX3+g+t395+t406+t433+t502+t508+t514;
mt1 = [dx01;dx02;dx03;o01.*r02.*(-1.0./2.0)-(o02.*r03)./2.0-(o03.*r04)./2.0;(o01.*r01)./2.0-(o02.*r04)./2.0+(o03.*r03)./2.0;(o02.*r01)./2.0+(o01.*r04)./2.0-(o03.*r02)./2.0;o01.*r03.*(-1.0./2.0)+(o02.*r02)./2.0+(o03.*r01)./2.0;ddX1;ddX2;ddX3;ddX4;ddX5;ddX6;-qi2_1.*wi3_1+qi3_1.*wi2_1;qi1_1.*wi3_1-qi3_1.*wi1_1;-qi1_1.*wi2_1+qi2_1.*wi1_1;-qi2_2.*wi3_2+qi3_2.*wi2_2;qi1_2.*wi3_2-qi3_2.*wi1_2;-qi1_2.*wi2_2+qi2_2.*wi1_2;-qi2_3.*wi3_3+qi3_3.*wi2_3;qi1_3.*wi3_3-qi3_3.*wi1_3;-qi1_3.*wi2_3+qi2_3.*wi1_3;-qi2_4.*wi3_4+qi3_4.*wi2_4;qi1_4.*wi3_4-qi3_4.*wi1_4;-qi1_4.*wi2_4+qi2_4.*wi1_4];
mt2 = [-qi2_5.*wi3_5+qi3_5.*wi2_5;qi1_5.*wi3_5-qi3_5.*wi1_5;-qi1_5.*wi2_5+qi2_5.*wi1_5;-qi2_6.*wi3_6+qi3_6.*wi2_6;qi1_6.*wi3_6-qi3_6.*wi1_6;-qi1_6.*wi2_6+qi2_6.*wi1_6;qi2_1.*t149.*t527-qi3_1.*t149.*t521+qi2_1.*t149.*t155.*t449-qi3_1.*t149.*t155.*t445;-qi1_1.*t149.*t527+qi3_1.*t149.*t515-qi1_1.*t149.*t155.*t449+qi3_1.*t149.*t155.*t443;qi1_1.*t149.*t521-qi2_1.*t149.*t515+qi1_1.*t149.*t155.*t445-qi2_1.*t149.*t155.*t443;qi2_2.*t150.*t528-qi3_2.*t150.*t522+qi2_2.*t150.*t156.*t452-qi3_2.*t150.*t156.*t447;-qi1_2.*t150.*t528+qi3_2.*t150.*t516-qi1_2.*t150.*t156.*t452+qi3_2.*t150.*t156.*t444;qi1_2.*t150.*t522-qi2_2.*t150.*t516+qi1_2.*t150.*t156.*t447-qi2_2.*t150.*t156.*t444];
mt3 = [qi2_3.*t151.*t529-qi3_3.*t151.*t523+qi2_3.*t151.*t157.*t455-qi3_3.*t151.*t157.*t450;-qi1_3.*t151.*t529+qi3_3.*t151.*t517-qi1_3.*t151.*t157.*t455+qi3_3.*t151.*t157.*t446;qi1_3.*t151.*t523-qi2_3.*t151.*t517+qi1_3.*t151.*t157.*t450-qi2_3.*t151.*t157.*t446;qi2_4.*t152.*t530-qi3_4.*t152.*t524+qi2_4.*t152.*t158.*t457-qi3_4.*t152.*t158.*t453;-qi1_4.*t152.*t530+qi3_4.*t152.*t518-qi1_4.*t152.*t158.*t457+qi3_4.*t152.*t158.*t448;qi1_4.*t152.*t524-qi2_4.*t152.*t518+qi1_4.*t152.*t158.*t453-qi2_4.*t152.*t158.*t448;qi2_5.*t153.*t531-qi3_5.*t153.*t525+qi2_5.*t153.*t159.*t459-qi3_5.*t153.*t159.*t456;-qi1_5.*t153.*t531+qi3_5.*t153.*t519-qi1_5.*t153.*t159.*t459+qi3_5.*t153.*t159.*t451];
mt4 = [qi1_5.*t153.*t525-qi2_5.*t153.*t519+qi1_5.*t153.*t159.*t456-qi2_5.*t153.*t159.*t451;qi2_6.*t154.*t532-qi3_6.*t154.*t526+qi2_6.*t154.*t160.*t460-qi3_6.*t154.*t160.*t458;-qi1_6.*t154.*t532+qi3_6.*t154.*t520-qi1_6.*t154.*t160.*t460+qi3_6.*t154.*t160.*t454;qi1_6.*t154.*t526-qi2_6.*t154.*t520+qi1_6.*t154.*t160.*t458-qi2_6.*t154.*t160.*t454;oi1_1.*ri2_1.*(-1.0./2.0)-(oi2_1.*ri3_1)./2.0-(oi3_1.*ri4_1)./2.0;(oi1_1.*ri1_1)./2.0-(oi2_1.*ri4_1)./2.0+(oi3_1.*ri3_1)./2.0;(oi2_1.*ri1_1)./2.0+(oi1_1.*ri4_1)./2.0-(oi3_1.*ri2_1)./2.0;oi1_1.*ri3_1.*(-1.0./2.0)+(oi2_1.*ri2_1)./2.0+(oi3_1.*ri1_1)./2.0;oi1_2.*ri2_2.*(-1.0./2.0)-(oi2_2.*ri3_2)./2.0-(oi3_2.*ri4_2)./2.0];
mt5 = [(oi1_2.*ri1_2)./2.0-(oi2_2.*ri4_2)./2.0+(oi3_2.*ri3_2)./2.0;(oi2_2.*ri1_2)./2.0+(oi1_2.*ri4_2)./2.0-(oi3_2.*ri2_2)./2.0;oi1_2.*ri3_2.*(-1.0./2.0)+(oi2_2.*ri2_2)./2.0+(oi3_2.*ri1_2)./2.0;oi1_3.*ri2_3.*(-1.0./2.0)-(oi2_3.*ri3_3)./2.0-(oi3_3.*ri4_3)./2.0;(oi1_3.*ri1_3)./2.0-(oi2_3.*ri4_3)./2.0+(oi3_3.*ri3_3)./2.0;(oi2_3.*ri1_3)./2.0+(oi1_3.*ri4_3)./2.0-(oi3_3.*ri2_3)./2.0;oi1_3.*ri3_3.*(-1.0./2.0)+(oi2_3.*ri2_3)./2.0+(oi3_3.*ri1_3)./2.0;oi1_4.*ri2_4.*(-1.0./2.0)-(oi2_4.*ri3_4)./2.0-(oi3_4.*ri4_4)./2.0;(oi1_4.*ri1_4)./2.0-(oi2_4.*ri4_4)./2.0+(oi3_4.*ri3_4)./2.0];
mt6 = [(oi2_4.*ri1_4)./2.0+(oi1_4.*ri4_4)./2.0-(oi3_4.*ri2_4)./2.0;oi1_4.*ri3_4.*(-1.0./2.0)+(oi2_4.*ri2_4)./2.0+(oi3_4.*ri1_4)./2.0;oi1_5.*ri2_5.*(-1.0./2.0)-(oi2_5.*ri3_5)./2.0-(oi3_5.*ri4_5)./2.0;(oi1_5.*ri1_5)./2.0-(oi2_5.*ri4_5)./2.0+(oi3_5.*ri3_5)./2.0;(oi2_5.*ri1_5)./2.0+(oi1_5.*ri4_5)./2.0-(oi3_5.*ri2_5)./2.0;oi1_5.*ri3_5.*(-1.0./2.0)+(oi2_5.*ri2_5)./2.0+(oi3_5.*ri1_5)./2.0;oi1_6.*ri2_6.*(-1.0./2.0)-(oi2_6.*ri3_6)./2.0-(oi3_6.*ri4_6)./2.0;(oi1_6.*ri1_6)./2.0-(oi2_6.*ri4_6)./2.0+(oi3_6.*ri3_6)./2.0;(oi2_6.*ri1_6)./2.0+(oi1_6.*ri4_6)./2.0-(oi3_6.*ri2_6)./2.0];
mt7 = [oi1_6.*ri3_6.*(-1.0./2.0)+(oi2_6.*ri2_6)./2.0+(oi3_6.*ri1_6)./2.0;(Mi1_1+ji2_1.*oi2_1.*oi3_1-ji3_1.*oi2_1.*oi3_1)./ji1_1;(Mi2_1-ji1_1.*oi1_1.*oi3_1+ji3_1.*oi1_1.*oi3_1)./ji2_1;(Mi3_1+ji1_1.*oi1_1.*oi2_1-ji2_1.*oi1_1.*oi2_1)./ji3_1;(Mi1_2+ji2_2.*oi2_2.*oi3_2-ji3_2.*oi2_2.*oi3_2)./ji1_2;(Mi2_2-ji1_2.*oi1_2.*oi3_2+ji3_2.*oi1_2.*oi3_2)./ji2_2;(Mi3_2+ji1_2.*oi1_2.*oi2_2-ji2_2.*oi1_2.*oi2_2)./ji3_2;(Mi1_3+ji2_3.*oi2_3.*oi3_3-ji3_3.*oi2_3.*oi3_3)./ji1_3;(Mi2_3-ji1_3.*oi1_3.*oi3_3+ji3_3.*oi1_3.*oi3_3)./ji2_3;(Mi3_3+ji1_3.*oi1_3.*oi2_3-ji2_3.*oi1_3.*oi2_3)./ji3_3;(Mi1_4+ji2_4.*oi2_4.*oi3_4-ji3_4.*oi2_4.*oi3_4)./ji1_4];
mt8 = [(Mi2_4-ji1_4.*oi1_4.*oi3_4+ji3_4.*oi1_4.*oi3_4)./ji2_4;(Mi3_4+ji1_4.*oi1_4.*oi2_4-ji2_4.*oi1_4.*oi2_4)./ji3_4;(Mi1_5+ji2_5.*oi2_5.*oi3_5-ji3_5.*oi2_5.*oi3_5)./ji1_5;(Mi2_5-ji1_5.*oi1_5.*oi3_5+ji3_5.*oi1_5.*oi3_5)./ji2_5;(Mi3_5+ji1_5.*oi1_5.*oi2_5-ji2_5.*oi1_5.*oi2_5)./ji3_5;(Mi1_6+ji2_6.*oi2_6.*oi3_6-ji3_6.*oi2_6.*oi3_6)./ji1_6;(Mi2_6-ji1_6.*oi1_6.*oi3_6+ji3_6.*oi1_6.*oi3_6)./ji2_6;(Mi3_6+ji1_6.*oi1_6.*oi2_6-ji2_6.*oi1_6.*oi2_6)./ji3_6];
dX = [mt1;mt2;mt3;mt4;mt5;mt6;mt7;mt8];
end
