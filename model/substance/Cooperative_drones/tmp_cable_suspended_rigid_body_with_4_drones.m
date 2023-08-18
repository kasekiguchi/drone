function dX = tmp_cable_suspended_rigid_body_with_4_drones(in1,in2,in3,in4,in5,in6)
%TMP_CABLE_SUSPENDED_RIGID_BODY_WITH_4_DRONES
%    dX = TMP_CABLE_SUSPENDED_RIGID_BODY_WITH_4_DRONES(IN1,IN2,IN3,IN4,IN5,IN6)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/08/16 21:07:40

Mi1_1 = in4(2,:);
Mi1_2 = in4(6,:);
Mi1_3 = in4(10,:);
Mi1_4 = in4(14,:);
Mi2_1 = in4(3,:);
Mi2_2 = in4(7,:);
Mi2_3 = in4(11,:);
Mi2_4 = in4(15,:);
Mi3_1 = in4(4,:);
Mi3_2 = in4(8,:);
Mi3_3 = in4(12,:);
Mi3_4 = in4(16,:);
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
Ri2_3_1 = in3(8);
Ri2_3_2 = in3(17);
Ri2_3_3 = in3(26);
Ri2_3_4 = in3(35);
Ri3_3_1 = in3(9);
Ri3_3_2 = in3(18);
Ri3_3_3 = in3(27);
Ri3_3_4 = in3(36);
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
g = in5(:,1);
ji1_1 = in5(:,26);
ji1_2 = in5(:,29);
ji1_3 = in5(:,32);
ji1_4 = in5(:,35);
ji2_1 = in5(:,27);
ji2_2 = in5(:,30);
ji2_3 = in5(:,33);
ji2_4 = in5(:,36);
ji3_1 = in5(:,28);
ji3_2 = in5(:,31);
ji3_3 = in5(:,34);
ji3_4 = in5(:,37);
li1 = in5(:,18);
li2 = in5(:,19);
li3 = in5(:,20);
li4 = in5(:,21);
mi1 = in5(:,22);
mi2 = in5(:,23);
mi3 = in5(:,24);
mi4 = in5(:,25);
o01 = in1(11,:);
o02 = in1(12,:);
o03 = in1(13,:);
oi1_1 = in1(54,:);
oi1_2 = in1(57,:);
oi1_3 = in1(60,:);
oi1_4 = in1(63,:);
oi2_1 = in1(55,:);
oi2_2 = in1(58,:);
oi2_3 = in1(61,:);
oi2_4 = in1(64,:);
oi3_1 = in1(56,:);
oi3_2 = in1(59,:);
oi3_3 = in1(62,:);
oi3_4 = in1(65,:);
qi1_1 = in1(14,:);
qi1_2 = in1(17,:);
qi1_3 = in1(20,:);
qi1_4 = in1(23,:);
qi2_1 = in1(15,:);
qi2_2 = in1(18,:);
qi2_3 = in1(21,:);
qi2_4 = in1(24,:);
qi3_1 = in1(16,:);
qi3_2 = in1(19,:);
qi3_3 = in1(22,:);
qi3_4 = in1(25,:);
r01 = in1(4,:);
r02 = in1(5,:);
r03 = in1(6,:);
r04 = in1(7,:);
rho1_1 = in5(:,6);
rho1_2 = in5(:,9);
rho1_3 = in5(:,12);
rho1_4 = in5(:,15);
rho2_1 = in5(:,7);
rho2_2 = in5(:,10);
rho2_3 = in5(:,13);
rho2_4 = in5(:,16);
rho3_1 = in5(:,8);
rho3_2 = in5(:,11);
rho3_3 = in5(:,14);
rho3_4 = in5(:,17);
ri1_1 = in1(38,:);
ri1_2 = in1(42,:);
ri1_3 = in1(46,:);
ri1_4 = in1(50,:);
ri2_1 = in1(39,:);
ri2_2 = in1(43,:);
ri2_3 = in1(47,:);
ri2_4 = in1(51,:);
ri3_1 = in1(40,:);
ri3_2 = in1(44,:);
ri3_3 = in1(48,:);
ri3_4 = in1(52,:);
ri4_1 = in1(41,:);
ri4_2 = in1(45,:);
ri4_3 = in1(49,:);
ri4_4 = in1(53,:);
wi1_1 = in1(26,:);
wi1_2 = in1(29,:);
wi1_3 = in1(32,:);
wi1_4 = in1(35,:);
wi2_1 = in1(27,:);
wi2_2 = in1(30,:);
wi2_3 = in1(33,:);
wi2_4 = in1(36,:);
wi3_1 = in1(28,:);
wi3_2 = in1(31,:);
wi3_3 = in1(34,:);
wi3_4 = in1(37,:);
t2 = R01_2.*rho1_1;
t3 = R01_2.*rho1_2;
t4 = R01_3.*rho1_1;
t5 = R01_2.*rho1_3;
t6 = R01_3.*rho1_2;
t7 = R01_2.*rho1_4;
t8 = R01_3.*rho1_3;
t9 = R01_3.*rho1_4;
t10 = R01_1.*rho2_1;
t11 = R01_1.*rho2_2;
t12 = R02_2.*rho1_1;
t13 = R01_1.*rho2_3;
t14 = R01_3.*rho2_1;
t15 = R02_2.*rho1_2;
t16 = R02_3.*rho1_1;
t17 = R01_1.*rho2_4;
t18 = R01_3.*rho2_2;
t19 = R02_2.*rho1_3;
t20 = R02_3.*rho1_2;
t21 = R01_3.*rho2_3;
t22 = R02_2.*rho1_4;
t23 = R02_3.*rho1_3;
t24 = R01_3.*rho2_4;
t25 = R02_3.*rho1_4;
t26 = R01_1.*rho3_1;
t27 = R02_1.*rho2_1;
t28 = R01_1.*rho3_2;
t29 = R01_2.*rho3_1;
t30 = R02_1.*rho2_2;
t31 = R03_2.*rho1_1;
t32 = R01_1.*rho3_3;
t33 = R01_2.*rho3_2;
t34 = R02_1.*rho2_3;
t35 = R02_3.*rho2_1;
t36 = R03_2.*rho1_2;
t37 = R03_3.*rho1_1;
t38 = R01_1.*rho3_4;
t39 = R01_2.*rho3_3;
t40 = R02_1.*rho2_4;
t41 = R02_3.*rho2_2;
t42 = R03_2.*rho1_3;
t43 = R03_3.*rho1_2;
t44 = R01_2.*rho3_4;
t45 = R02_3.*rho2_3;
t46 = R03_2.*rho1_4;
t47 = R03_3.*rho1_3;
t48 = R02_3.*rho2_4;
t49 = R03_3.*rho1_4;
t50 = R02_1.*rho3_1;
t51 = R03_1.*rho2_1;
t52 = R02_1.*rho3_2;
t53 = R02_2.*rho3_1;
t54 = R03_1.*rho2_2;
t55 = R02_1.*rho3_3;
t56 = R02_2.*rho3_2;
t57 = R03_1.*rho2_3;
t58 = R03_3.*rho2_1;
t59 = R02_1.*rho3_4;
t60 = R02_2.*rho3_3;
t61 = R03_1.*rho2_4;
t62 = R03_3.*rho2_2;
t63 = R02_2.*rho3_4;
t64 = R03_3.*rho2_3;
t65 = R03_3.*rho2_4;
t66 = R03_1.*rho3_1;
t67 = R03_1.*rho3_2;
t68 = R03_2.*rho3_1;
t69 = R03_1.*rho3_3;
t70 = R03_2.*rho3_2;
t71 = R03_1.*rho3_4;
t72 = R03_2.*rho3_3;
t73 = R03_2.*rho3_4;
t74 = o01.^2;
t75 = o02.^2;
t76 = o03.^2;
t77 = qi1_1.^2;
t78 = qi1_2.^2;
t79 = qi1_3.^2;
t80 = qi1_4.^2;
t81 = qi2_1.^2;
t82 = qi2_2.^2;
t83 = qi2_3.^2;
t84 = qi2_4.^2;
t85 = qi3_1.^2;
t86 = qi3_2.^2;
t87 = qi3_3.^2;
t88 = qi3_4.^2;
t89 = R01_1.*o01.*o02;
t90 = R01_1.*o01.*o03;
t91 = R01_2.*o01.*o02;
t92 = R01_2.*o02.*o03;
t93 = R01_3.*o01.*o03;
t94 = R01_3.*o02.*o03;
t95 = R02_1.*o01.*o02;
t96 = R02_1.*o01.*o03;
t97 = R02_2.*o01.*o02;
t98 = R02_2.*o02.*o03;
t99 = R02_3.*o01.*o03;
t100 = R02_3.*o02.*o03;
t101 = R03_1.*o01.*o02;
t102 = R03_1.*o01.*o03;
t103 = R03_2.*o01.*o02;
t104 = R03_2.*o02.*o03;
t105 = R03_3.*o01.*o03;
t106 = R03_3.*o02.*o03;
t107 = 1.0./li1;
t108 = 1.0./li2;
t109 = 1.0./li3;
t110 = 1.0./li4;
t111 = 1.0./mi1;
t112 = 1.0./mi2;
t113 = 1.0./mi3;
t114 = 1.0./mi4;
t151 = Ri1_3_1.*fi1.*qi1_1.*qi2_1;
t152 = Ri1_3_2.*fi2.*qi1_2.*qi2_2;
t153 = Ri1_3_3.*fi3.*qi1_3.*qi2_3;
t154 = Ri1_3_1.*fi1.*qi1_1.*qi3_1;
t155 = Ri1_3_4.*fi4.*qi1_4.*qi2_4;
t156 = Ri1_3_2.*fi2.*qi1_2.*qi3_2;
t157 = Ri1_3_3.*fi3.*qi1_3.*qi3_3;
t158 = Ri1_3_4.*fi4.*qi1_4.*qi3_4;
t159 = Ri2_3_1.*fi1.*qi1_1.*qi2_1;
t160 = Ri2_3_2.*fi2.*qi1_2.*qi2_2;
t161 = Ri2_3_3.*fi3.*qi1_3.*qi2_3;
t162 = Ri2_3_4.*fi4.*qi1_4.*qi2_4;
t163 = Ri2_3_1.*fi1.*qi2_1.*qi3_1;
t164 = Ri2_3_2.*fi2.*qi2_2.*qi3_2;
t165 = Ri2_3_3.*fi3.*qi2_3.*qi3_3;
t166 = Ri2_3_4.*fi4.*qi2_4.*qi3_4;
t167 = Ri3_3_1.*fi1.*qi1_1.*qi3_1;
t168 = Ri3_3_2.*fi2.*qi1_2.*qi3_2;
t169 = Ri3_3_3.*fi3.*qi1_3.*qi3_3;
t170 = Ri3_3_1.*fi1.*qi2_1.*qi3_1;
t171 = Ri3_3_4.*fi4.*qi1_4.*qi3_4;
t172 = Ri3_3_2.*fi2.*qi2_2.*qi3_2;
t173 = Ri3_3_3.*fi3.*qi2_3.*qi3_3;
t174 = Ri3_3_4.*fi4.*qi2_4.*qi3_4;
t115 = -t10;
t116 = -t11;
t117 = -t13;
t118 = -t17;
t119 = -t26;
t120 = -t27;
t121 = -t28;
t122 = -t29;
t123 = -t30;
t124 = -t32;
t125 = -t33;
t126 = -t34;
t127 = -t38;
t128 = -t39;
t129 = -t40;
t130 = -t44;
t131 = -t50;
t132 = -t51;
t133 = -t52;
t134 = -t53;
t135 = -t54;
t136 = -t55;
t137 = -t56;
t138 = -t57;
t139 = -t59;
t140 = -t60;
t141 = -t61;
t142 = -t63;
t143 = -t66;
t144 = -t67;
t145 = -t68;
t146 = -t69;
t147 = -t70;
t148 = -t71;
t149 = -t72;
t150 = -t73;
t175 = t77-1.0;
t176 = t78-1.0;
t177 = t79-1.0;
t178 = t80-1.0;
t179 = t81-1.0;
t180 = t82-1.0;
t181 = t83-1.0;
t182 = t84-1.0;
t183 = t85-1.0;
t184 = t86-1.0;
t185 = t87-1.0;
t186 = t88-1.0;
t187 = t74+t75;
t188 = t74+t76;
t189 = t75+t76;
t190 = Ri1_3_1.*fi1.*t175;
t191 = Ri1_3_2.*fi2.*t176;
t192 = Ri1_3_3.*fi3.*t177;
t193 = Ri1_3_4.*fi4.*t178;
t194 = Ri2_3_1.*fi1.*t179;
t195 = Ri2_3_2.*fi2.*t180;
t196 = Ri2_3_3.*fi3.*t181;
t197 = Ri2_3_4.*fi4.*t182;
t198 = Ri3_3_1.*fi1.*t183;
t199 = Ri3_3_2.*fi2.*t184;
t200 = Ri3_3_3.*fi3.*t185;
t201 = Ri3_3_4.*fi4.*t186;
t202 = t2+t115;
t203 = t3+t116;
t204 = t5+t117;
t205 = t7+t118;
t206 = t4+t119;
t207 = t6+t121;
t208 = t8+t124;
t209 = t9+t127;
t210 = t12+t120;
t211 = t14+t122;
t212 = t15+t123;
t213 = t18+t125;
t214 = t19+t126;
t215 = t21+t128;
t216 = t22+t129;
t217 = t24+t130;
t218 = t16+t131;
t219 = t20+t133;
t220 = t23+t136;
t221 = t25+t139;
t222 = t31+t132;
t223 = t35+t134;
t224 = t36+t135;
t225 = t41+t137;
t226 = t42+t138;
t227 = t45+t140;
t228 = t46+t141;
t229 = t48+t142;
t230 = t37+t143;
t231 = t43+t144;
t232 = t47+t146;
t233 = t49+t148;
t234 = t58+t145;
t235 = t62+t147;
t236 = t64+t149;
t237 = t65+t150;
t238 = R01_1.*t189;
t239 = R01_2.*t188;
t240 = R01_3.*t187;
t241 = R02_1.*t189;
t242 = R02_2.*t188;
t243 = R02_3.*t187;
t244 = R03_1.*t189;
t245 = R03_2.*t188;
t246 = R03_3.*t187;
t247 = ddX6.*t202;
t248 = ddX6.*t203;
t249 = ddX6.*t204;
t250 = ddX6.*t205;
t251 = ddX5.*t206;
t252 = ddX5.*t207;
t253 = ddX5.*t208;
t254 = ddX5.*t209;
t255 = ddX4.*t211;
t256 = ddX6.*t210;
t257 = ddX4.*t213;
t258 = ddX6.*t212;
t259 = ddX4.*t215;
t260 = ddX6.*t214;
t261 = ddX4.*t217;
t262 = ddX6.*t216;
t263 = ddX5.*t218;
t264 = ddX5.*t219;
t265 = ddX5.*t220;
t266 = ddX5.*t221;
t267 = ddX4.*t223;
t268 = ddX6.*t222;
t269 = ddX4.*t225;
t270 = ddX6.*t224;
t271 = ddX4.*t227;
t272 = ddX6.*t226;
t273 = ddX4.*t229;
t274 = ddX6.*t228;
t275 = ddX5.*t230;
t276 = ddX5.*t231;
t277 = ddX5.*t232;
t278 = ddX5.*t233;
t279 = ddX4.*t234;
t280 = ddX4.*t235;
t281 = ddX4.*t236;
t282 = ddX4.*t237;
t283 = -t238;
t284 = -t239;
t285 = -t240;
t286 = -t241;
t287 = -t242;
t288 = -t243;
t289 = -t244;
t290 = -t245;
t291 = -t246;
t313 = t159+t167+t190;
t314 = t160+t168+t191;
t315 = t151+t170+t194;
t316 = t161+t169+t192;
t317 = t152+t172+t195;
t318 = t162+t171+t193;
t319 = t154+t163+t198;
t320 = t153+t173+t196;
t321 = t156+t164+t199;
t322 = t155+t174+t197;
t323 = t157+t165+t200;
t324 = t158+t166+t201;
t292 = -t251;
t293 = -t252;
t294 = -t253;
t295 = -t254;
t296 = -t263;
t297 = -t264;
t298 = -t265;
t299 = -t266;
t300 = -t275;
t301 = -t276;
t302 = -t277;
t303 = -t278;
t304 = t91+t93+t283;
t305 = t89+t94+t284;
t306 = t90+t92+t285;
t307 = t97+t99+t286;
t308 = t95+t100+t287;
t309 = t96+t98+t288;
t310 = t103+t105+t289;
t311 = t101+t106+t290;
t312 = t102+t104+t291;
t325 = rho1_1.*t304;
t326 = rho1_2.*t304;
t327 = rho1_3.*t304;
t328 = rho1_4.*t304;
t329 = rho2_1.*t305;
t330 = rho2_2.*t305;
t331 = rho2_3.*t305;
t332 = rho2_4.*t305;
t333 = rho3_1.*t306;
t334 = rho3_2.*t306;
t335 = rho3_3.*t306;
t336 = rho3_4.*t306;
t337 = rho1_1.*t307;
t338 = rho1_2.*t307;
t339 = rho1_3.*t307;
t340 = rho1_4.*t307;
t341 = rho2_1.*t308;
t342 = rho2_2.*t308;
t343 = rho2_3.*t308;
t344 = rho2_4.*t308;
t345 = rho3_1.*t309;
t346 = rho3_2.*t309;
t347 = rho3_3.*t309;
t348 = rho3_4.*t309;
t349 = rho1_1.*t310;
t350 = rho1_2.*t310;
t351 = rho1_3.*t310;
t352 = rho1_4.*t310;
t353 = rho2_1.*t311;
t354 = rho2_2.*t311;
t355 = rho2_3.*t311;
t356 = rho2_4.*t311;
t357 = rho3_1.*t312;
t358 = rho3_2.*t312;
t359 = rho3_3.*t312;
t360 = rho3_4.*t312;
t361 = ddX1+t247+t255+t292+t325+t329+t333;
t362 = ddX1+t248+t257+t293+t326+t330+t334;
t363 = ddX1+t249+t259+t294+t327+t331+t335;
dX = ft_1({Mi1_1,Mi1_2,Mi1_3,Mi1_4,Mi2_1,Mi2_2,Mi2_3,Mi2_4,Mi3_1,Mi3_2,Mi3_3,Mi3_4,ddX1,ddX2,ddX3,ddX4,ddX5,ddX6,dx01,dx02,dx03,g,ji1_1,ji1_2,ji1_3,ji1_4,ji2_1,ji2_2,ji2_3,ji2_4,ji3_1,ji3_2,ji3_3,ji3_4,o01,o02,o03,oi1_1,oi1_2,oi1_3,oi1_4,oi2_1,oi2_2,oi2_3,oi2_4,oi3_1,oi3_2,oi3_3,oi3_4,qi1_1,qi1_2,qi1_3,qi1_4,qi2_1,qi2_2,qi2_3,qi2_4,qi3_1,qi3_2,qi3_3,qi3_4,r01,r02,r03,r04,ri1_1,ri1_2,ri1_3,ri1_4,ri2_1,ri2_2,ri2_3,ri2_4,ri3_1,ri3_2,ri3_3,ri3_4,ri4_1,ri4_2,ri4_3,ri4_4,t107,t108,t109,t110,t111,t112,t113,t114,t250,t256,t258,t260,t261,t262,t267,t268,t269,t270,t271,t272,t273,t274,t279,t280,t281,t282,t295,t296,t297,t298,t299,t300,t301,t302,t303,t313,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t328,t332,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t363,wi1_1,wi1_2,wi1_3,wi1_4,wi2_1,wi2_2,wi2_3,wi2_4,wi3_1,wi3_2,wi3_3,wi3_4});
end
function dX = ft_1(ct)
[Mi1_1,Mi1_2,Mi1_3,Mi1_4,Mi2_1,Mi2_2,Mi2_3,Mi2_4,Mi3_1,Mi3_2,Mi3_3,Mi3_4,ddX1,ddX2,ddX3,ddX4,ddX5,ddX6,dx01,dx02,dx03,g,ji1_1,ji1_2,ji1_3,ji1_4,ji2_1,ji2_2,ji2_3,ji2_4,ji3_1,ji3_2,ji3_3,ji3_4,o01,o02,o03,oi1_1,oi1_2,oi1_3,oi1_4,oi2_1,oi2_2,oi2_3,oi2_4,oi3_1,oi3_2,oi3_3,oi3_4,qi1_1,qi1_2,qi1_3,qi1_4,qi2_1,qi2_2,qi2_3,qi2_4,qi3_1,qi3_2,qi3_3,qi3_4,r01,r02,r03,r04,ri1_1,ri1_2,ri1_3,ri1_4,ri2_1,ri2_2,ri2_3,ri2_4,ri3_1,ri3_2,ri3_3,ri3_4,ri4_1,ri4_2,ri4_3,ri4_4,t107,t108,t109,t110,t111,t112,t113,t114,t250,t256,t258,t260,t261,t262,t267,t268,t269,t270,t271,t272,t273,t274,t279,t280,t281,t282,t295,t296,t297,t298,t299,t300,t301,t302,t303,t313,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t328,t332,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t363,wi1_1,wi1_2,wi1_3,wi1_4,wi2_1,wi2_2,wi2_3,wi2_4,wi3_1,wi3_2,wi3_3,wi3_4] = ct{:};
t364 = ddX1+t250+t261+t295+t328+t332+t336;
t365 = ddX2+t256+t267+t296+t337+t341+t345;
t366 = ddX2+t258+t269+t297+t338+t342+t346;
t367 = ddX2+t260+t271+t298+t339+t343+t347;
t368 = ddX2+t262+t273+t299+t340+t344+t348;
t369 = ddX3+g+t268+t279+t300+t349+t353+t357;
t370 = ddX3+g+t270+t280+t301+t350+t354+t358;
t371 = ddX3+g+t272+t281+t302+t351+t355+t359;
t372 = ddX3+g+t274+t282+t303+t352+t356+t360;
mt1 = [dx01;dx02;dx03;o01.*r02.*(-1.0./2.0)-(o02.*r03)./2.0-(o03.*r04)./2.0;(o01.*r01)./2.0-(o02.*r04)./2.0+(o03.*r03)./2.0;(o02.*r01)./2.0+(o01.*r04)./2.0-(o03.*r02)./2.0;o01.*r03.*(-1.0./2.0)+(o02.*r02)./2.0+(o03.*r01)./2.0;ddX1;ddX2;ddX3;ddX4;ddX5;ddX6;-qi2_1.*wi3_1+qi3_1.*wi2_1;qi1_1.*wi3_1-qi3_1.*wi1_1;-qi1_1.*wi2_1+qi2_1.*wi1_1;-qi2_2.*wi3_2+qi3_2.*wi2_2;qi1_2.*wi3_2-qi3_2.*wi1_2;-qi1_2.*wi2_2+qi2_2.*wi1_2;-qi2_3.*wi3_3+qi3_3.*wi2_3;qi1_3.*wi3_3-qi3_3.*wi1_3;-qi1_3.*wi2_3+qi2_3.*wi1_3;-qi2_4.*wi3_4+qi3_4.*wi2_4;qi1_4.*wi3_4-qi3_4.*wi1_4;-qi1_4.*wi2_4+qi2_4.*wi1_4];
mt2 = [qi2_1.*t107.*t369-qi3_1.*t107.*t365+qi2_1.*t107.*t111.*t319-qi3_1.*t107.*t111.*t315;-qi1_1.*t107.*t369+qi3_1.*t107.*t361-qi1_1.*t107.*t111.*t319+qi3_1.*t107.*t111.*t313;qi1_1.*t107.*t365-qi2_1.*t107.*t361+qi1_1.*t107.*t111.*t315-qi2_1.*t107.*t111.*t313;qi2_2.*t108.*t370-qi3_2.*t108.*t366+qi2_2.*t108.*t112.*t321-qi3_2.*t108.*t112.*t317;-qi1_2.*t108.*t370+qi3_2.*t108.*t362-qi1_2.*t108.*t112.*t321+qi3_2.*t108.*t112.*t314;qi1_2.*t108.*t366-qi2_2.*t108.*t362+qi1_2.*t108.*t112.*t317-qi2_2.*t108.*t112.*t314;qi2_3.*t109.*t371-qi3_3.*t109.*t367+qi2_3.*t109.*t113.*t323-qi3_3.*t109.*t113.*t320;-qi1_3.*t109.*t371+qi3_3.*t109.*t363-qi1_3.*t109.*t113.*t323+qi3_3.*t109.*t113.*t316];
mt3 = [qi1_3.*t109.*t367-qi2_3.*t109.*t363+qi1_3.*t109.*t113.*t320-qi2_3.*t109.*t113.*t316;qi2_4.*t110.*t372-qi3_4.*t110.*t368+qi2_4.*t110.*t114.*t324-qi3_4.*t110.*t114.*t322;-qi1_4.*t110.*t372+qi3_4.*t110.*t364-qi1_4.*t110.*t114.*t324+qi3_4.*t110.*t114.*t318;qi1_4.*t110.*t368-qi2_4.*t110.*t364+qi1_4.*t110.*t114.*t322-qi2_4.*t110.*t114.*t318;oi1_1.*ri2_1.*(-1.0./2.0)-(oi2_1.*ri3_1)./2.0-(oi3_1.*ri4_1)./2.0;(oi1_1.*ri1_1)./2.0-(oi2_1.*ri4_1)./2.0+(oi3_1.*ri3_1)./2.0;(oi2_1.*ri1_1)./2.0+(oi1_1.*ri4_1)./2.0-(oi3_1.*ri2_1)./2.0;oi1_1.*ri3_1.*(-1.0./2.0)+(oi2_1.*ri2_1)./2.0+(oi3_1.*ri1_1)./2.0;oi1_2.*ri2_2.*(-1.0./2.0)-(oi2_2.*ri3_2)./2.0-(oi3_2.*ri4_2)./2.0];
mt4 = [(oi1_2.*ri1_2)./2.0-(oi2_2.*ri4_2)./2.0+(oi3_2.*ri3_2)./2.0;(oi2_2.*ri1_2)./2.0+(oi1_2.*ri4_2)./2.0-(oi3_2.*ri2_2)./2.0;oi1_2.*ri3_2.*(-1.0./2.0)+(oi2_2.*ri2_2)./2.0+(oi3_2.*ri1_2)./2.0;oi1_3.*ri2_3.*(-1.0./2.0)-(oi2_3.*ri3_3)./2.0-(oi3_3.*ri4_3)./2.0;(oi1_3.*ri1_3)./2.0-(oi2_3.*ri4_3)./2.0+(oi3_3.*ri3_3)./2.0;(oi2_3.*ri1_3)./2.0+(oi1_3.*ri4_3)./2.0-(oi3_3.*ri2_3)./2.0;oi1_3.*ri3_3.*(-1.0./2.0)+(oi2_3.*ri2_3)./2.0+(oi3_3.*ri1_3)./2.0;oi1_4.*ri2_4.*(-1.0./2.0)-(oi2_4.*ri3_4)./2.0-(oi3_4.*ri4_4)./2.0;(oi1_4.*ri1_4)./2.0-(oi2_4.*ri4_4)./2.0+(oi3_4.*ri3_4)./2.0];
mt5 = [(oi2_4.*ri1_4)./2.0+(oi1_4.*ri4_4)./2.0-(oi3_4.*ri2_4)./2.0;oi1_4.*ri3_4.*(-1.0./2.0)+(oi2_4.*ri2_4)./2.0+(oi3_4.*ri1_4)./2.0;(Mi1_1+ji2_1.*oi2_1.*oi3_1-ji3_1.*oi2_1.*oi3_1)./ji1_1;(Mi2_1-ji1_1.*oi1_1.*oi3_1+ji3_1.*oi1_1.*oi3_1)./ji2_1;(Mi3_1+ji1_1.*oi1_1.*oi2_1-ji2_1.*oi1_1.*oi2_1)./ji3_1;(Mi1_2+ji2_2.*oi2_2.*oi3_2-ji3_2.*oi2_2.*oi3_2)./ji1_2;(Mi2_2-ji1_2.*oi1_2.*oi3_2+ji3_2.*oi1_2.*oi3_2)./ji2_2;(Mi3_2+ji1_2.*oi1_2.*oi2_2-ji2_2.*oi1_2.*oi2_2)./ji3_2;(Mi1_3+ji2_3.*oi2_3.*oi3_3-ji3_3.*oi2_3.*oi3_3)./ji1_3;(Mi2_3-ji1_3.*oi1_3.*oi3_3+ji3_3.*oi1_3.*oi3_3)./ji2_3;(Mi3_3+ji1_3.*oi1_3.*oi2_3-ji2_3.*oi1_3.*oi2_3)./ji3_3];
mt6 = [(Mi1_4+ji2_4.*oi2_4.*oi3_4-ji3_4.*oi2_4.*oi3_4)./ji1_4;(Mi2_4-ji1_4.*oi1_4.*oi3_4+ji3_4.*oi1_4.*oi3_4)./ji2_4;(Mi3_4+ji1_4.*oi1_4.*oi2_4-ji2_4.*oi1_4.*oi2_4)./ji3_4];
dX = [mt1;mt2;mt3;mt4;mt5;mt6];
end
