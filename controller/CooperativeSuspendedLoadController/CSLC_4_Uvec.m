function out1 = CSLC_4_Uvec(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14)
%CSLC_4_Uvec
%    OUT1 = CSLC_4_Uvec(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10,IN11,IN12,IN13,IN14)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/08/18 12:00:34

Ri1_1_1 = in7(1);
Ri1_1_2 = in7(10);
Ri1_1_3 = in7(19);
Ri1_1_4 = in7(28);
Ri1_2_1 = in7(4);
Ri1_2_2 = in7(13);
Ri1_2_3 = in7(22);
Ri1_2_4 = in7(31);
Ri1_3_1 = in7(7);
Ri1_3_2 = in7(16);
Ri1_3_3 = in7(25);
Ri1_3_4 = in7(34);
Ri2_1_1 = in7(2);
Ri2_1_2 = in7(11);
Ri2_1_3 = in7(20);
Ri2_1_4 = in7(29);
Ri2_2_1 = in7(5);
Ri2_2_2 = in7(14);
Ri2_2_3 = in7(23);
Ri2_2_4 = in7(32);
Ri2_3_1 = in7(8);
Ri2_3_2 = in7(17);
Ri2_3_3 = in7(26);
Ri2_3_4 = in7(35);
Ri3_1_1 = in7(3);
Ri3_1_2 = in7(12);
Ri3_1_3 = in7(21);
Ri3_1_4 = in7(30);
Ri3_2_1 = in7(6);
Ri3_2_2 = in7(15);
Ri3_2_3 = in7(24);
Ri3_2_4 = in7(33);
Ri3_3_1 = in7(9);
Ri3_3_2 = in7(18);
Ri3_3_3 = in7(27);
Ri3_3_4 = in7(36);
b11_1 = in10(1);
b11_2 = in10(4);
b11_3 = in10(7);
b11_4 = in10(10);
b12_1 = in10(2);
b12_2 = in10(5);
b12_3 = in10(8);
b12_4 = in10(11);
b13_1 = in10(3);
b13_2 = in10(6);
b13_3 = in10(9);
b13_4 = in10(12);
b21_1 = in11(1);
b21_2 = in11(4);
b21_3 = in11(7);
b21_4 = in11(10);
b22_1 = in11(2);
b22_2 = in11(5);
b22_3 = in11(8);
b22_4 = in11(11);
b23_1 = in11(3);
b23_2 = in11(6);
b23_3 = in11(9);
b23_4 = in11(12);
b31_1 = in12(1);
b31_2 = in12(4);
b31_3 = in12(7);
b31_4 = in12(10);
b32_1 = in12(2);
b32_2 = in12(5);
b32_3 = in12(8);
b32_4 = in12(11);
b33_1 = in12(3);
b33_2 = in12(6);
b33_3 = in12(9);
b33_4 = in12(12);
ci1 = in14(:,1);
ci2 = in14(:,2);
ci3 = in14(:,3);
ci4 = in14(:,4);
dddx0d1 = in2(10,:);
dddx0d2 = in2(11,:);
dddx0d3 = in2(12,:);
ddx0d1 = in2(7,:);
ddx0d2 = in2(8,:);
ddx0d3 = in2(9,:);
epsilon = in4(:,13);
ji1_1 = in3(:,26);
ji1_2 = in3(:,29);
ji1_3 = in3(:,32);
ji1_4 = in3(:,35);
ji2_1 = in3(:,27);
ji2_2 = in3(:,30);
ji2_3 = in3(:,33);
ji2_4 = in3(:,36);
ji3_1 = in3(:,28);
ji3_2 = in3(:,31);
ji3_3 = in3(:,34);
ji3_4 = in3(:,37);
koi = in4(:,12);
kri = in4(:,11);
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
si1 = in13(:,1);
si2 = in13(:,2);
si3 = in13(:,3);
si4 = in13(:,4);
ui1_1 = in5(1);
ui1_2 = in5(4);
ui1_3 = in5(7);
ui1_4 = in5(10);
ui2_1 = in5(2);
ui2_2 = in5(5);
ui2_3 = in5(8);
ui2_4 = in5(11);
ui3_1 = in5(3);
ui3_2 = in5(6);
ui3_3 = in5(9);
ui3_4 = in5(12);
t2 = Ri1_1_1.*b11_1;
t3 = Ri1_1_2.*b11_2;
t4 = Ri1_1_3.*b11_3;
t5 = Ri1_1_4.*b11_4;
t6 = Ri2_2_1.*b12_1;
t7 = Ri2_2_2.*b12_2;
t8 = Ri2_2_3.*b12_3;
t9 = Ri2_2_4.*b12_4;
t10 = Ri1_1_1.*b31_1;
t11 = Ri1_1_2.*b31_2;
t12 = Ri1_1_3.*b31_3;
t13 = Ri1_1_4.*b31_4;
t14 = Ri3_3_1.*b13_1;
t15 = Ri3_3_2.*b13_2;
t16 = Ri3_3_3.*b13_3;
t17 = Ri3_3_4.*b13_4;
t18 = Ri2_2_1.*b32_1;
t19 = Ri2_2_2.*b32_2;
t20 = Ri2_2_3.*b32_3;
t21 = Ri2_2_4.*b32_4;
t22 = Ri3_3_1.*b33_1;
t23 = Ri3_3_2.*b33_2;
t24 = Ri3_3_3.*b33_3;
t25 = Ri3_3_4.*b33_4;
t26 = Ri1_1_1.*oi2_1;
t27 = Ri1_2_1.*oi1_1;
t28 = Ri1_1_2.*oi2_2;
t29 = Ri1_2_2.*oi1_2;
t30 = Ri1_1_3.*oi2_3;
t31 = Ri1_2_3.*oi1_3;
t32 = Ri1_1_4.*oi2_4;
t33 = Ri1_2_4.*oi1_4;
t34 = Ri1_1_1.*oi3_1;
t35 = Ri1_3_1.*oi1_1;
t36 = Ri1_1_2.*oi3_2;
t37 = Ri1_3_2.*oi1_2;
t38 = Ri1_1_3.*oi3_3;
t39 = Ri1_3_3.*oi1_3;
t40 = Ri1_1_4.*oi3_4;
t41 = Ri1_3_4.*oi1_4;
t42 = Ri1_2_1.*oi3_1;
t43 = Ri1_3_1.*oi2_1;
t44 = Ri1_2_2.*oi3_2;
t45 = Ri1_3_2.*oi2_2;
t46 = Ri1_2_3.*oi3_3;
t47 = Ri1_3_3.*oi2_3;
t48 = Ri1_2_4.*oi3_4;
t49 = Ri1_3_4.*oi2_4;
t50 = Ri2_1_1.*oi2_1;
t51 = Ri2_2_1.*oi1_1;
t52 = Ri2_1_2.*oi2_2;
t53 = Ri2_2_2.*oi1_2;
t54 = Ri2_1_3.*oi2_3;
t55 = Ri2_2_3.*oi1_3;
t56 = Ri2_1_4.*oi2_4;
t57 = Ri2_2_4.*oi1_4;
t58 = Ri2_1_1.*oi3_1;
t59 = Ri2_3_1.*oi1_1;
t60 = Ri2_1_2.*oi3_2;
t61 = Ri2_3_2.*oi1_2;
t62 = Ri2_1_3.*oi3_3;
t63 = Ri2_3_3.*oi1_3;
t64 = Ri2_1_4.*oi3_4;
t65 = Ri2_3_4.*oi1_4;
t66 = Ri2_2_1.*oi3_1;
t67 = Ri2_3_1.*oi2_1;
t68 = Ri2_2_2.*oi3_2;
t69 = Ri2_3_2.*oi2_2;
t70 = Ri2_2_3.*oi3_3;
t71 = Ri2_3_3.*oi2_3;
t72 = Ri2_2_4.*oi3_4;
t73 = Ri2_3_4.*oi2_4;
t74 = Ri3_1_1.*oi2_1;
t75 = Ri3_2_1.*oi1_1;
t76 = Ri3_1_2.*oi2_2;
t77 = Ri3_2_2.*oi1_2;
t78 = Ri3_1_3.*oi2_3;
t79 = Ri3_2_3.*oi1_3;
t80 = Ri3_1_4.*oi2_4;
t81 = Ri3_2_4.*oi1_4;
t82 = Ri3_1_1.*oi3_1;
t83 = Ri3_3_1.*oi1_1;
t84 = Ri3_1_2.*oi3_2;
t85 = Ri3_3_2.*oi1_2;
t86 = Ri3_1_3.*oi3_3;
t87 = Ri3_3_3.*oi1_3;
t88 = Ri3_1_4.*oi3_4;
t89 = Ri3_3_4.*oi1_4;
t90 = Ri3_2_1.*oi3_1;
t91 = Ri3_3_1.*oi2_1;
t92 = Ri3_2_2.*oi3_2;
t93 = Ri3_3_2.*oi2_2;
t94 = Ri3_2_3.*oi3_3;
t95 = Ri3_3_3.*oi2_3;
t96 = Ri3_2_4.*oi3_4;
t97 = Ri3_3_4.*oi2_4;
t98 = b21_1.*ci1;
t99 = b21_2.*ci2;
t100 = b21_3.*ci3;
t101 = b21_4.*ci4;
t102 = b22_1.*ci1;
t103 = b22_2.*ci2;
t104 = b22_3.*ci3;
t105 = b22_4.*ci4;
t106 = b23_1.*ci1;
t107 = b23_2.*ci2;
t108 = b23_3.*ci3;
t109 = b23_4.*ci4;
t110 = b31_1.*dddx0d2;
t111 = b31_1.*dddx0d3;
t112 = b31_2.*dddx0d2;
t113 = b31_2.*dddx0d3;
t114 = b31_3.*dddx0d2;
t115 = b31_3.*dddx0d3;
t116 = b31_4.*dddx0d2;
t117 = b31_4.*dddx0d3;
t118 = b32_1.*dddx0d1;
t119 = b32_2.*dddx0d1;
t120 = b32_1.*dddx0d3;
t121 = b32_3.*dddx0d1;
t122 = b32_2.*dddx0d3;
t123 = b32_4.*dddx0d1;
t124 = b32_3.*dddx0d3;
t125 = b32_4.*dddx0d3;
t126 = b33_1.*dddx0d1;
t127 = b33_1.*dddx0d2;
t128 = b33_2.*dddx0d1;
t129 = b33_2.*dddx0d2;
t130 = b33_3.*dddx0d1;
t131 = b33_3.*dddx0d2;
t132 = b33_4.*dddx0d1;
t133 = b33_4.*dddx0d2;
t134 = b31_1.*ddx0d2;
t135 = b31_1.*ddx0d3;
t136 = b31_2.*ddx0d2;
t137 = b31_2.*ddx0d3;
t138 = b31_3.*ddx0d2;
t139 = b31_3.*ddx0d3;
t140 = b31_4.*ddx0d2;
t141 = b31_4.*ddx0d3;
t142 = b32_1.*ddx0d1;
t143 = b32_2.*ddx0d1;
t144 = b32_1.*ddx0d3;
t145 = b32_3.*ddx0d1;
t146 = b32_2.*ddx0d3;
t147 = b32_4.*ddx0d1;
t148 = b32_3.*ddx0d3;
t149 = b32_4.*ddx0d3;
t150 = b33_1.*ddx0d1;
t151 = b33_1.*ddx0d2;
t152 = b33_2.*ddx0d1;
t153 = b33_2.*ddx0d2;
t154 = b33_3.*ddx0d1;
t155 = b33_3.*ddx0d2;
t156 = b33_4.*ddx0d1;
t157 = b33_4.*ddx0d2;
t158 = 1.0./epsilon;
t160 = 1.0./si1;
t161 = 1.0./si2;
t162 = 1.0./si3;
t163 = 1.0./si4;
t159 = t158.^2;
t164 = -t27;
t165 = -t29;
t166 = -t31;
t167 = -t33;
t168 = -t35;
t169 = -t37;
t170 = -t39;
t171 = -t41;
t172 = -t43;
t173 = -t45;
t174 = -t47;
t175 = -t49;
t176 = -t51;
t177 = -t53;
t178 = -t55;
t179 = -t57;
t180 = -t59;
t181 = -t61;
t182 = -t63;
t183 = -t65;
t184 = -t67;
t185 = -t69;
t186 = -t71;
t187 = -t73;
t188 = -t75;
t189 = -t77;
t190 = -t79;
t191 = -t81;
t192 = -t83;
t193 = -t85;
t194 = -t87;
t195 = -t89;
t196 = -t91;
t197 = -t93;
t198 = -t95;
t199 = -t97;
t200 = -t111;
t201 = -t113;
t202 = -t115;
t203 = -t117;
t204 = -t118;
t205 = -t119;
t206 = -t121;
t207 = -t123;
t208 = -t127;
t209 = -t129;
t210 = -t131;
t211 = -t133;
t212 = -t134;
t213 = -t136;
t214 = -t138;
t215 = -t140;
t216 = -t142;
t217 = -t143;
t218 = -t144;
t219 = -t145;
t220 = -t146;
t221 = -t147;
t222 = -t148;
t223 = -t149;
t224 = -t150;
t225 = -t151;
t226 = -t152;
t227 = -t153;
t228 = -t154;
t229 = -t155;
t230 = -t156;
t231 = -t157;
t232 = t26+t164;
t233 = t28+t165;
t234 = t30+t166;
t235 = t32+t167;
t236 = t34+t168;
t237 = t36+t169;
t238 = t38+t170;
t239 = t40+t171;
t240 = t42+t172;
t241 = t44+t173;
t242 = t46+t174;
t243 = t48+t175;
t244 = t50+t176;
t245 = t52+t177;
t246 = t54+t178;
t247 = t56+t179;
t248 = t58+t180;
t249 = t60+t181;
t250 = t62+t182;
t251 = t64+t183;
t252 = t66+t184;
t253 = t68+t185;
t254 = t70+t186;
t255 = t72+t187;
t256 = t74+t188;
t257 = t76+t189;
t258 = t78+t190;
t259 = t80+t191;
t260 = t82+t192;
t261 = t84+t193;
t262 = t86+t194;
t263 = t88+t195;
t264 = t90+t196;
t265 = t92+t197;
t266 = t94+t198;
t267 = t96+t199;
t268 = t134+t216;
t269 = t136+t217;
t270 = t138+t219;
t271 = t140+t221;
t272 = t135+t224;
t273 = t137+t226;
t274 = t139+t228;
t275 = t141+t230;
t276 = t144+t225;
t277 = t146+t227;
t278 = t148+t229;
t279 = t149+t231;
t292 = t106+t142+t212;
t294 = t98+t151+t218;
t295 = t107+t143+t213;
t297 = t99+t153+t220;
t298 = t108+t145+t214;
t300 = t100+t155+t222;
t301 = t109+t147+t215;
t303 = t101+t157+t223;
t280 = ci1.*t268;
t281 = ci2.*t269;
t282 = ci3.*t270;
t283 = ci4.*t271;
t284 = ci1.*t272;
t285 = ci2.*t273;
t286 = ci3.*t274;
t287 = ci4.*t275;
t288 = ci1.*t276;
t289 = ci2.*t277;
t290 = ci3.*t278;
t291 = ci4.*t279;
t293 = t102+t272;
t296 = t103+t273;
t299 = t104+t274;
t302 = t105+t275;
t328 = b11_1.*t160.*t294;
t329 = b11_2.*t161.*t297;
t331 = b11_3.*t162.*t300;
t333 = b11_4.*t163.*t303;
t334 = b13_1.*t160.*t292;
t336 = b13_2.*t161.*t295;
t338 = b13_3.*t162.*t298;
t339 = b13_4.*t163.*t301;
t340 = b21_1.*t160.*t294;
t341 = b21_2.*t161.*t297;
t343 = b21_3.*t162.*t300;
t345 = b21_4.*t163.*t303;
t346 = b23_1.*t160.*t292;
t348 = b23_2.*t161.*t295;
t350 = b23_3.*t162.*t298;
t351 = b23_4.*t163.*t301;
t352 = b31_1.*t160.*t292;
t354 = b31_1.*t160.*t294;
t355 = b31_2.*t161.*t295;
t357 = b31_2.*t161.*t297;
t358 = b32_1.*t160.*t292;
t360 = b31_3.*t162.*t298;
t361 = b32_1.*t160.*t294;
t363 = b31_3.*t162.*t300;
t364 = b32_2.*t161.*t295;
t366 = b31_4.*t163.*t301;
t367 = b32_2.*t161.*t297;
t369 = b31_4.*t163.*t303;
t370 = b33_1.*t160.*t292;
t372 = b32_3.*t162.*t298;
t373 = b33_1.*t160.*t294;
t375 = b32_3.*t162.*t300;
t376 = b33_2.*t161.*t295;
t378 = b32_4.*t163.*t301;
t379 = b33_2.*t161.*t297;
t381 = b32_4.*t163.*t303;
t382 = b33_3.*t162.*t298;
t384 = b33_3.*t162.*t300;
t385 = b33_4.*t163.*t301;
t387 = b33_4.*t163.*t303;
t388 = ci1.*t160.*t292;
t390 = ci1.*t160.*t294;
t391 = ci2.*t161.*t295;
t393 = ci2.*t161.*t297;
t394 = ci3.*t162.*t298;
t396 = ci3.*t162.*t300;
t397 = ci4.*t163.*t301;
t399 = ci4.*t163.*t303;
t304 = b22_1+t284;
t305 = b22_2+t285;
t306 = b22_3+t286;
t307 = b22_4+t287;
t308 = -t280;
t309 = -t281;
t310 = -t282;
t311 = -t283;
t312 = -t288;
t313 = -t289;
t314 = -t290;
t315 = -t291;
t330 = b12_1.*t160.*t293;
t332 = b12_2.*t161.*t296;
t335 = b12_3.*t162.*t299;
t337 = b12_4.*t163.*t302;
t342 = b22_1.*t160.*t293;
t344 = b22_2.*t161.*t296;
t347 = b22_3.*t162.*t299;
t349 = b22_4.*t163.*t302;
t353 = b31_1.*t160.*t293;
t356 = b31_2.*t161.*t296;
t359 = b32_1.*t160.*t293;
t362 = b31_3.*t162.*t299;
t365 = b32_2.*t161.*t296;
out1 = ft_1({Ri1_1_1,Ri1_1_2,Ri1_1_3,Ri1_1_4,Ri1_2_1,Ri1_2_2,Ri1_2_3,Ri1_2_4,Ri1_3_1,Ri1_3_2,Ri1_3_3,Ri1_3_4,Ri2_1_1,Ri2_1_2,Ri2_1_3,Ri2_1_4,Ri2_3_1,Ri2_3_2,Ri2_3_3,Ri2_3_4,Ri3_1_1,Ri3_1_2,Ri3_1_3,Ri3_1_4,Ri3_2_1,Ri3_2_2,Ri3_2_3,Ri3_2_4,Ri3_3_1,Ri3_3_2,Ri3_3_3,Ri3_3_4,b11_1,b11_2,b11_3,b11_4,b12_1,b12_2,b12_3,b12_4,b13_1,b13_2,b13_3,b13_4,b21_1,b21_2,b21_3,b21_4,b22_1,b22_2,b22_3,b22_4,b23_1,b23_2,b23_3,b23_4,b31_1,b31_2,b31_3,b31_4,b32_1,b32_2,b32_3,b32_4,b33_1,b33_2,b33_3,b33_4,ci1,ci2,ci3,ci4,ji1_1,ji1_2,ji1_3,ji1_4,ji2_1,ji2_2,ji2_3,ji2_4,ji3_1,ji3_2,ji3_3,ji3_4,koi,kri,oi1_1,oi1_2,oi1_3,oi1_4,oi2_1,oi2_2,oi2_3,oi2_4,oi3_1,oi3_2,oi3_3,oi3_4,t10,t11,t110,t112,t114,t116,t12,t120,t122,t124,t125,t126,t128,t13,t130,t132,t14,t15,t158,t159,t16,t160,t161,t162,t163,t17,t18,t19,t2,t20,t200,t201,t202,t203,t204,t205,t206,t207,t208,t209,t21,t210,t211,t22,t23,t232,t233,t234,t235,t236,t237,t238,t239,t24,t240,t241,t242,t243,t244,t245,t246,t247,t248,t249,t25,t250,t251,t252,t253,t254,t255,t256,t257,t258,t259,t260,t261,t262,t263,t264,t265,t266,t267,t293,t296,t299,t3,t302,t304,t305,t306,t307,t308,t309,t310,t311,t312,t313,t314,t315,t328,t329,t330,t331,t332,t333,t334,t335,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t363,t364,t365,t366,t367,t369,t370,t372,t373,t375,t376,t378,t379,t381,t382,t384,t385,t387,t388,t390,t391,t393,t394,t396,t397,t399,t4,t5,t6,t7,t8,t9,ui1_1,ui1_2,ui1_3,ui1_4,ui2_1,ui2_2,ui2_3,ui2_4,ui3_1,ui3_2,ui3_3,ui3_4});
end
function out1 = ft_1(ct)
[Ri1_1_1,Ri1_1_2,Ri1_1_3,Ri1_1_4,Ri1_2_1,Ri1_2_2,Ri1_2_3,Ri1_2_4,Ri1_3_1,Ri1_3_2,Ri1_3_3,Ri1_3_4,Ri2_1_1,Ri2_1_2,Ri2_1_3,Ri2_1_4,Ri2_3_1,Ri2_3_2,Ri2_3_3,Ri2_3_4,Ri3_1_1,Ri3_1_2,Ri3_1_3,Ri3_1_4,Ri3_2_1,Ri3_2_2,Ri3_2_3,Ri3_2_4,Ri3_3_1,Ri3_3_2,Ri3_3_3,Ri3_3_4,b11_1,b11_2,b11_3,b11_4,b12_1,b12_2,b12_3,b12_4,b13_1,b13_2,b13_3,b13_4,b21_1,b21_2,b21_3,b21_4,b22_1,b22_2,b22_3,b22_4,b23_1,b23_2,b23_3,b23_4,b31_1,b31_2,b31_3,b31_4,b32_1,b32_2,b32_3,b32_4,b33_1,b33_2,b33_3,b33_4,ci1,ci2,ci3,ci4,ji1_1,ji1_2,ji1_3,ji1_4,ji2_1,ji2_2,ji2_3,ji2_4,ji3_1,ji3_2,ji3_3,ji3_4,koi,kri,oi1_1,oi1_2,oi1_3,oi1_4,oi2_1,oi2_2,oi2_3,oi2_4,oi3_1,oi3_2,oi3_3,oi3_4,t10,t11,t110,t112,t114,t116,t12,t120,t122,t124,t125,t126,t128,t13,t130,t132,t14,t15,t158,t159,t16,t160,t161,t162,t163,t17,t18,t19,t2,t20,t200,t201,t202,t203,t204,t205,t206,t207,t208,t209,t21,t210,t211,t22,t23,t232,t233,t234,t235,t236,t237,t238,t239,t24,t240,t241,t242,t243,t244,t245,t246,t247,t248,t249,t25,t250,t251,t252,t253,t254,t255,t256,t257,t258,t259,t260,t261,t262,t263,t264,t265,t266,t267,t293,t296,t299,t3,t302,t304,t305,t306,t307,t308,t309,t310,t311,t312,t313,t314,t315,t328,t329,t330,t331,t332,t333,t334,t335,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t363,t364,t365,t366,t367,t369,t370,t372,t373,t375,t376,t378,t379,t381,t382,t384,t385,t387,t388,t390,t391,t393,t394,t396,t397,t399,t4,t5,t6,t7,t8,t9,ui1_1,ui1_2,ui1_3,ui1_4,ui2_1,ui2_2,ui2_3,ui2_4,ui3_1,ui3_2,ui3_3,ui3_4] = ct{:};
t368 = b31_4.*t163.*t302;
t371 = b33_1.*t160.*t293;
t374 = b32_3.*t162.*t299;
t377 = b33_2.*t161.*t296;
t380 = b32_4.*t163.*t302;
t383 = b33_3.*t162.*t299;
t386 = b33_4.*t163.*t302;
t389 = ci1.*t160.*t293;
t392 = ci2.*t161.*t296;
t395 = ci3.*t162.*t299;
t398 = ci4.*t163.*t302;
t408 = -t361;
t409 = -t367;
t411 = -t373;
t412 = -t375;
t414 = -t379;
t415 = -t381;
t417 = -t384;
t419 = -t387;
t316 = b23_1+t308;
t317 = b21_1+t312;
t318 = b23_2+t309;
t319 = b21_2+t313;
t320 = b23_3+t310;
t321 = b21_3+t314;
t322 = b23_4+t311;
t323 = b21_4+t315;
t324 = t160.*t304;
t325 = t161.*t305;
t326 = t162.*t306;
t327 = t163.*t307;
t410 = -t371;
t413 = -t377;
t416 = -t383;
t418 = -t386;
t420 = t353+t408;
t421 = t352+t411;
t422 = t356+t409;
t424 = t355+t414;
t425 = t362+t412;
t427 = t360+t417;
t428 = t368+t415;
t430 = t366+t419;
t540 = t328+t330+t334;
t541 = t329+t332+t336;
t542 = t331+t335+t338;
t543 = t333+t337+t339;
t544 = t340+t342+t346;
t545 = t341+t344+t348;
t546 = t343+t347+t350;
t547 = t345+t349+t351;
t548 = t354+t359+t370;
t549 = t357+t365+t376;
t550 = t363+t374+t382;
t551 = t369+t380+t385;
t400 = t160.*t316;
t401 = t160.*t317;
t402 = t161.*t318;
t403 = t161.*t319;
t404 = t162.*t320;
t405 = t162.*t321;
t406 = t163.*t322;
t407 = t163.*t323;
t423 = t358+t410;
t426 = t364+t413;
t429 = t372+t416;
t431 = t378+t418;
t433 = b12_1.*t421;
t434 = b13_1.*t420;
t436 = b12_2.*t424;
t437 = b13_2.*t422;
t439 = b12_3.*t427;
t440 = b13_3.*t425;
t442 = b12_4.*t430;
t443 = b13_4.*t428;
t445 = b22_1.*t421;
t446 = b23_1.*t420;
t448 = b22_2.*t424;
t449 = b23_2.*t422;
t451 = b22_3.*t427;
t452 = b23_3.*t425;
t454 = b22_4.*t430;
t455 = b23_4.*t428;
t457 = b32_1.*t421;
t458 = b33_1.*t420;
t460 = b32_2.*t424;
t461 = b33_2.*t422;
t463 = b32_3.*t427;
t464 = b33_3.*t425;
t466 = b32_4.*t430;
t467 = b33_4.*t428;
t480 = t126+t200+t324+t389;
t481 = t128+t201+t325+t392;
t482 = t130+t202+t326+t395;
t483 = t132+t203+t327+t398;
t576 = t544.*t548;
t577 = t545.*t549;
t578 = t546.*t550;
t579 = t547.*t551;
t432 = b11_1.*t423;
t435 = b11_2.*t426;
t438 = b11_3.*t429;
t441 = b11_4.*t431;
t444 = b21_1.*t423;
t447 = b21_2.*t426;
t450 = b21_3.*t429;
t453 = b21_4.*t431;
t456 = b31_1.*t423;
t459 = b31_2.*t426;
t462 = b31_3.*t429;
t465 = b31_4.*t431;
t468 = -t433;
t469 = -t436;
t470 = -t439;
t471 = -t442;
t472 = -t445;
t473 = -t448;
t474 = -t451;
t475 = -t454;
t476 = -t457;
t477 = -t460;
t478 = -t463;
t479 = -t466;
t484 = t110+t204+t388+t400;
t485 = t112+t205+t391+t402;
t486 = t114+t206+t394+t404;
t487 = t120+t208+t390+t401;
t488 = t116+t207+t397+t406;
t489 = t122+t209+t393+t403;
t490 = t124+t210+t396+t405;
t491 = t125+t211+t399+t407;
t492 = b31_1.*t160.*t480;
t493 = b32_1.*t160.*t480;
t494 = b31_2.*t161.*t481;
t495 = b33_1.*t160.*t480;
t496 = b32_2.*t161.*t481;
t497 = b31_3.*t162.*t482;
t498 = b33_2.*t161.*t481;
t499 = b32_3.*t162.*t482;
t500 = b31_4.*t163.*t483;
t501 = b33_3.*t162.*t482;
t502 = b32_4.*t163.*t483;
t503 = b33_4.*t163.*t483;
t584 = -t576;
t585 = -t577;
t586 = -t578;
t587 = -t579;
t504 = b31_1.*t160.*t484;
t505 = b32_1.*t160.*t484;
t506 = b31_2.*t161.*t485;
t507 = b33_1.*t160.*t484;
t508 = b32_2.*t161.*t485;
t509 = b31_1.*t160.*t487;
t510 = b31_3.*t162.*t486;
t512 = b33_2.*t161.*t485;
t513 = b32_1.*t160.*t487;
t514 = b32_3.*t162.*t486;
t515 = b31_2.*t161.*t489;
t516 = b31_4.*t163.*t488;
t517 = b33_1.*t160.*t487;
t519 = b33_3.*t162.*t486;
t520 = b32_2.*t161.*t489;
t521 = b32_4.*t163.*t488;
t522 = b31_3.*t162.*t490;
t523 = b33_2.*t161.*t489;
t525 = b33_4.*t163.*t488;
t526 = b32_3.*t162.*t490;
t527 = b31_4.*t163.*t491;
t528 = b33_3.*t162.*t490;
t530 = b32_4.*t163.*t491;
t531 = b33_4.*t163.*t491;
t588 = t432+t434+t468;
t589 = t435+t437+t469;
t590 = t438+t440+t470;
t591 = t441+t443+t471;
t592 = t444+t446+t472;
t593 = t447+t449+t473;
t594 = t450+t452+t474;
t595 = t453+t455+t475;
t596 = t456+t458+t476;
t597 = t459+t461+t477;
t598 = t462+t464+t478;
t599 = t465+t467+t479;
t532 = -t513;
t533 = -t517;
t534 = -t520;
t535 = -t523;
t536 = -t526;
t537 = -t528;
t538 = -t530;
t539 = -t531;
t600 = t544.*t592;
t601 = t540.*t596;
t602 = t545.*t593;
t603 = t541.*t597;
t604 = t546.*t594;
t605 = t542.*t598;
t606 = t547.*t595;
t607 = t543.*t599;
t612 = t588.*t592;
t613 = t589.*t593;
t614 = t590.*t594;
t615 = t591.*t595;
t553 = t492+t532;
t555 = t494+t534;
t557 = t497+t536;
t559 = t500+t538;
t568 = t504+t533;
t569 = t506+t535;
t570 = t510+t537;
t571 = t516+t539;
t616 = t493+t507+t509+t584+t601;
t617 = t496+t512+t515+t585+t603;
t618 = t499+t519+t522+t586+t605;
t619 = t502+t525+t527+t587+t607;
t561 = b23_1.*t553;
t563 = b23_2.*t555;
t565 = b23_3.*t557;
t567 = b23_4.*t559;
t572 = b22_1.*t568;
t573 = b22_2.*t569;
t574 = b22_3.*t570;
t575 = b22_4.*t571;
mt1 = [Ri1_3_1.*ui1_1+Ri2_3_1.*ui2_1+Ri3_3_1.*ui3_1;ji1_1.*((t10+Ri1_2_1.*b32_1+Ri1_3_1.*b33_1).*(-t561+t572+t600-t612+b21_1.*(t495-t505))+t616.*(t2+Ri1_2_1.*b12_1+Ri1_3_1.*b13_1)-t548.*(b11_1.*t240+b12_1.*t252+b13_1.*t264)+t592.*(b31_1.*t240+b32_1.*t252+b33_1.*t264))-ji2_1.*oi2_1.*oi3_1+ji3_1.*oi2_1.*oi3_1-koi.*t158.*(oi1_1+t548.*(t2+Ri2_1_1.*b12_1+Ri3_1_1.*b13_1)-t592.*(t10+Ri2_1_1.*b32_1+Ri3_1_1.*b33_1))-kri.*t159.*(t18./2.0-(Ri1_3_1.*b21_1)./2.0+(Ri1_2_1.*b31_1)./2.0-(Ri2_3_1.*b22_1)./2.0-(Ri3_3_1.*b23_1)./2.0+(Ri3_2_1.*b33_1)./2.0)];
mt2 = [ji2_1.*((t18+Ri2_1_1.*b31_1+Ri2_3_1.*b33_1).*(-t561+t572+t600-t612+b21_1.*(t495-t505))+t616.*(t6+Ri2_1_1.*b11_1+Ri2_3_1.*b13_1)+t548.*(b11_1.*t236+b12_1.*t248+b13_1.*t260)-t592.*(b31_1.*t236+b32_1.*t248+b33_1.*t260))+kri.*t159.*(t10./2.0-t14./2.0-(Ri1_3_1.*b11_1)./2.0-(Ri2_3_1.*b12_1)./2.0+(Ri2_1_1.*b32_1)./2.0+(Ri3_1_1.*b33_1)./2.0)+ji1_1.*oi1_1.*oi3_1-ji3_1.*oi1_1.*oi3_1-koi.*t158.*(oi2_1+t548.*(t6+Ri1_2_1.*b11_1+Ri3_2_1.*b13_1)-t592.*(t18+Ri1_2_1.*b31_1+Ri3_2_1.*b33_1))];
mt3 = [ji3_1.*((t22+Ri3_1_1.*b31_1+Ri3_2_1.*b32_1).*(-t561+t572+t600-t612+b21_1.*(t495-t505))+t616.*(t14+Ri3_1_1.*b11_1+Ri3_2_1.*b12_1)-t548.*(b11_1.*t232+b12_1.*t244+b13_1.*t256)+t592.*(b31_1.*t232+b32_1.*t244+b33_1.*t256))-ji1_1.*oi1_1.*oi2_1+ji2_1.*oi1_1.*oi2_1-koi.*t158.*(oi3_1+t548.*(t14+Ri1_3_1.*b11_1+Ri2_3_1.*b12_1)-t592.*(t22+Ri1_3_1.*b31_1+Ri2_3_1.*b32_1))+kri.*t159.*(t6./2.0+(Ri1_2_1.*b11_1)./2.0-(Ri1_1_1.*b21_1)./2.0-(Ri2_1_1.*b22_1)./2.0+(Ri3_2_1.*b13_1)./2.0-(Ri3_1_1.*b23_1)./2.0);Ri1_3_2.*ui1_2+Ri2_3_2.*ui2_2+Ri3_3_2.*ui3_2];
mt4 = [ji1_2.*((t11+Ri1_2_2.*b32_2+Ri1_3_2.*b33_2).*(-t563+t573+t602-t613+b21_2.*(t498-t508))+t617.*(t3+Ri1_2_2.*b12_2+Ri1_3_2.*b13_2)-t549.*(b11_2.*t241+b12_2.*t253+b13_2.*t265)+t593.*(b31_2.*t241+b32_2.*t253+b33_2.*t265))-ji2_2.*oi2_2.*oi3_2+ji3_2.*oi2_2.*oi3_2-koi.*t158.*(oi1_2+t549.*(t3+Ri2_1_2.*b12_2+Ri3_1_2.*b13_2)-t593.*(t11+Ri2_1_2.*b32_2+Ri3_1_2.*b33_2))-kri.*t159.*(t19./2.0-(Ri1_3_2.*b21_2)./2.0+(Ri1_2_2.*b31_2)./2.0-(Ri2_3_2.*b22_2)./2.0-(Ri3_3_2.*b23_2)./2.0+(Ri3_2_2.*b33_2)./2.0)];
mt5 = [ji2_2.*((t19+Ri2_1_2.*b31_2+Ri2_3_2.*b33_2).*(-t563+t573+t602-t613+b21_2.*(t498-t508))+t617.*(t7+Ri2_1_2.*b11_2+Ri2_3_2.*b13_2)+t549.*(b11_2.*t237+b12_2.*t249+b13_2.*t261)-t593.*(b31_2.*t237+b32_2.*t249+b33_2.*t261))+kri.*t159.*(t11./2.0-t15./2.0-(Ri1_3_2.*b11_2)./2.0-(Ri2_3_2.*b12_2)./2.0+(Ri2_1_2.*b32_2)./2.0+(Ri3_1_2.*b33_2)./2.0)+ji1_2.*oi1_2.*oi3_2-ji3_2.*oi1_2.*oi3_2-koi.*t158.*(oi2_2+t549.*(t7+Ri1_2_2.*b11_2+Ri3_2_2.*b13_2)-t593.*(t19+Ri1_2_2.*b31_2+Ri3_2_2.*b33_2))];
mt6 = [ji3_2.*((t23+Ri3_1_2.*b31_2+Ri3_2_2.*b32_2).*(-t563+t573+t602-t613+b21_2.*(t498-t508))+t617.*(t15+Ri3_1_2.*b11_2+Ri3_2_2.*b12_2)-t549.*(b11_2.*t233+b12_2.*t245+b13_2.*t257)+t593.*(b31_2.*t233+b32_2.*t245+b33_2.*t257))-ji1_2.*oi1_2.*oi2_2+ji2_2.*oi1_2.*oi2_2-koi.*t158.*(oi3_2+t549.*(t15+Ri1_3_2.*b11_2+Ri2_3_2.*b12_2)-t593.*(t23+Ri1_3_2.*b31_2+Ri2_3_2.*b32_2))+kri.*t159.*(t7./2.0+(Ri1_2_2.*b11_2)./2.0-(Ri1_1_2.*b21_2)./2.0-(Ri2_1_2.*b22_2)./2.0+(Ri3_2_2.*b13_2)./2.0-(Ri3_1_2.*b23_2)./2.0);Ri1_3_3.*ui1_3+Ri2_3_3.*ui2_3+Ri3_3_3.*ui3_3];
mt7 = [ji1_3.*((t12+Ri1_2_3.*b32_3+Ri1_3_3.*b33_3).*(-t565+t574+t604-t614+b21_3.*(t501-t514))+t618.*(t4+Ri1_2_3.*b12_3+Ri1_3_3.*b13_3)-t550.*(b11_3.*t242+b12_3.*t254+b13_3.*t266)+t594.*(b31_3.*t242+b32_3.*t254+b33_3.*t266))-ji2_3.*oi2_3.*oi3_3+ji3_3.*oi2_3.*oi3_3-koi.*t158.*(oi1_3+t550.*(t4+Ri2_1_3.*b12_3+Ri3_1_3.*b13_3)-t594.*(t12+Ri2_1_3.*b32_3+Ri3_1_3.*b33_3))-kri.*t159.*(t20./2.0-(Ri1_3_3.*b21_3)./2.0+(Ri1_2_3.*b31_3)./2.0-(Ri2_3_3.*b22_3)./2.0-(Ri3_3_3.*b23_3)./2.0+(Ri3_2_3.*b33_3)./2.0)];
mt8 = [ji2_3.*((t20+Ri2_1_3.*b31_3+Ri2_3_3.*b33_3).*(-t565+t574+t604-t614+b21_3.*(t501-t514))+t618.*(t8+Ri2_1_3.*b11_3+Ri2_3_3.*b13_3)+t550.*(b11_3.*t238+b12_3.*t250+b13_3.*t262)-t594.*(b31_3.*t238+b32_3.*t250+b33_3.*t262))+kri.*t159.*(t12./2.0-t16./2.0-(Ri1_3_3.*b11_3)./2.0-(Ri2_3_3.*b12_3)./2.0+(Ri2_1_3.*b32_3)./2.0+(Ri3_1_3.*b33_3)./2.0)+ji1_3.*oi1_3.*oi3_3-ji3_3.*oi1_3.*oi3_3-koi.*t158.*(oi2_3+t550.*(t8+Ri1_2_3.*b11_3+Ri3_2_3.*b13_3)-t594.*(t20+Ri1_2_3.*b31_3+Ri3_2_3.*b33_3))];
mt9 = [ji3_3.*((t24+Ri3_1_3.*b31_3+Ri3_2_3.*b32_3).*(-t565+t574+t604-t614+b21_3.*(t501-t514))+t618.*(t16+Ri3_1_3.*b11_3+Ri3_2_3.*b12_3)-t550.*(b11_3.*t234+b12_3.*t246+b13_3.*t258)+t594.*(b31_3.*t234+b32_3.*t246+b33_3.*t258))-ji1_3.*oi1_3.*oi2_3+ji2_3.*oi1_3.*oi2_3-koi.*t158.*(oi3_3+t550.*(t16+Ri1_3_3.*b11_3+Ri2_3_3.*b12_3)-t594.*(t24+Ri1_3_3.*b31_3+Ri2_3_3.*b32_3))+kri.*t159.*(t8./2.0+(Ri1_2_3.*b11_3)./2.0-(Ri1_1_3.*b21_3)./2.0-(Ri2_1_3.*b22_3)./2.0+(Ri3_2_3.*b13_3)./2.0-(Ri3_1_3.*b23_3)./2.0);Ri1_3_4.*ui1_4+Ri2_3_4.*ui2_4+Ri3_3_4.*ui3_4];
mt10 = [ji1_4.*((t13+Ri1_2_4.*b32_4+Ri1_3_4.*b33_4).*(-t567+t575+t606-t615+b21_4.*(t503-t521))+t619.*(t5+Ri1_2_4.*b12_4+Ri1_3_4.*b13_4)-t551.*(b11_4.*t243+b12_4.*t255+b13_4.*t267)+t595.*(b31_4.*t243+b32_4.*t255+b33_4.*t267))-ji2_4.*oi2_4.*oi3_4+ji3_4.*oi2_4.*oi3_4-koi.*t158.*(oi1_4+t551.*(t5+Ri2_1_4.*b12_4+Ri3_1_4.*b13_4)-t595.*(t13+Ri2_1_4.*b32_4+Ri3_1_4.*b33_4))-kri.*t159.*(t21./2.0-(Ri1_3_4.*b21_4)./2.0+(Ri1_2_4.*b31_4)./2.0-(Ri2_3_4.*b22_4)./2.0-(Ri3_3_4.*b23_4)./2.0+(Ri3_2_4.*b33_4)./2.0)];
mt11 = [ji2_4.*((t21+Ri2_1_4.*b31_4+Ri2_3_4.*b33_4).*(-t567+t575+t606-t615+b21_4.*(t503-t521))+t619.*(t9+Ri2_1_4.*b11_4+Ri2_3_4.*b13_4)+t551.*(b11_4.*t239+b12_4.*t251+b13_4.*t263)-t595.*(b31_4.*t239+b32_4.*t251+b33_4.*t263))+kri.*t159.*(t13./2.0-t17./2.0-(Ri1_3_4.*b11_4)./2.0-(Ri2_3_4.*b12_4)./2.0+(Ri2_1_4.*b32_4)./2.0+(Ri3_1_4.*b33_4)./2.0)+ji1_4.*oi1_4.*oi3_4-ji3_4.*oi1_4.*oi3_4-koi.*t158.*(oi2_4+t551.*(t9+Ri1_2_4.*b11_4+Ri3_2_4.*b13_4)-t595.*(t21+Ri1_2_4.*b31_4+Ri3_2_4.*b33_4))];
mt12 = [ji3_4.*((t25+Ri3_1_4.*b31_4+Ri3_2_4.*b32_4).*(-t567+t575+t606-t615+b21_4.*(t503-t521))+t619.*(t17+Ri3_1_4.*b11_4+Ri3_2_4.*b12_4)-t551.*(b11_4.*t235+b12_4.*t247+b13_4.*t259)+t595.*(b31_4.*t235+b32_4.*t247+b33_4.*t259))-ji1_4.*oi1_4.*oi2_4+ji2_4.*oi1_4.*oi2_4-koi.*t158.*(oi3_4+t551.*(t17+Ri1_3_4.*b11_4+Ri2_3_4.*b12_4)-t595.*(t25+Ri1_3_4.*b31_4+Ri2_3_4.*b32_4))+kri.*t159.*(t9./2.0+(Ri1_2_4.*b11_4)./2.0-(Ri1_1_4.*b21_4)./2.0-(Ri2_1_4.*b22_4)./2.0+(Ri3_2_4.*b13_4)./2.0-(Ri3_1_4.*b23_4)./2.0)];
out1 = [mt1;mt2;mt3;mt4;mt5;mt6;mt7;mt8;mt9;mt10;mt11;mt12];
end
