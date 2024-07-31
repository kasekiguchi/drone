function A = zup_eul_Addx0do0_6(in1,in2,in3,in4)
%zup_eul_Addx0do0_6
%    A = zup_eul_Addx0do0_6(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 24.1.
%    2024/07/31 20:34:14

R01_1 = in2(1);
R01_2 = in2(4);
R01_3 = in2(7);
R02_1 = in2(2);
R02_2 = in2(5);
R02_3 = in2(8);
R03_1 = in2(3);
R03_2 = in2(6);
R03_3 = in2(9);
j01 = in4(:,3);
j02 = in4(:,4);
j03 = in4(:,5);
m0 = in4(:,2);
mi1 = in4(:,30);
mi2 = in4(:,31);
mi3 = in4(:,32);
mi4 = in4(:,33);
mi5 = in4(:,34);
mi6 = in4(:,35);
qi1_1 = in1(13,:);
qi1_2 = in1(16,:);
qi1_3 = in1(19,:);
qi1_4 = in1(22,:);
qi1_5 = in1(25,:);
qi1_6 = in1(28,:);
qi2_1 = in1(14,:);
qi2_2 = in1(17,:);
qi2_3 = in1(20,:);
qi2_4 = in1(23,:);
qi2_5 = in1(26,:);
qi2_6 = in1(29,:);
qi3_1 = in1(15,:);
qi3_2 = in1(18,:);
qi3_3 = in1(21,:);
qi3_4 = in1(24,:);
qi3_5 = in1(27,:);
qi3_6 = in1(30,:);
rho1_1 = in4(:,6);
rho1_2 = in4(:,9);
rho1_3 = in4(:,12);
rho1_4 = in4(:,15);
rho1_5 = in4(:,18);
rho1_6 = in4(:,21);
rho2_1 = in4(:,7);
rho2_2 = in4(:,10);
rho2_3 = in4(:,13);
rho2_4 = in4(:,16);
rho2_5 = in4(:,19);
rho2_6 = in4(:,22);
rho3_1 = in4(:,8);
rho3_2 = in4(:,11);
rho3_3 = in4(:,14);
rho3_4 = in4(:,17);
rho3_5 = in4(:,20);
rho3_6 = in4(:,23);
t2 = qi1_1.^2;
t3 = qi1_2.^2;
t4 = qi1_3.^2;
t5 = qi1_4.^2;
t6 = qi1_5.^2;
t7 = qi1_6.^2;
t8 = qi2_1.^2;
t9 = qi2_2.^2;
t10 = qi2_3.^2;
t11 = qi2_4.^2;
t12 = qi2_5.^2;
t13 = qi2_6.^2;
t14 = qi3_1.^2;
t15 = qi3_2.^2;
t16 = qi3_3.^2;
t17 = qi3_4.^2;
t18 = qi3_5.^2;
t19 = qi3_6.^2;
t20 = R01_2.*mi1.*rho1_1;
t21 = R01_3.*mi1.*rho1_1;
t22 = R01_2.*mi2.*rho1_2;
t23 = R01_3.*mi2.*rho1_2;
t24 = R01_2.*mi3.*rho1_3;
t25 = R01_3.*mi3.*rho1_3;
t26 = R01_2.*mi4.*rho1_4;
t27 = R01_3.*mi4.*rho1_4;
t28 = R01_2.*mi5.*rho1_5;
t29 = R01_1.*mi1.*rho2_1;
t30 = R01_3.*mi5.*rho1_5;
t31 = R01_2.*mi6.*rho1_6;
t32 = R02_2.*mi1.*rho1_1;
t33 = R01_1.*mi2.*rho2_2;
t34 = R01_3.*mi1.*rho2_1;
t35 = R01_3.*mi6.*rho1_6;
t36 = R02_3.*mi1.*rho1_1;
t37 = R02_2.*mi2.*rho1_2;
t38 = R01_1.*mi3.*rho2_3;
t39 = R01_3.*mi2.*rho2_2;
t40 = R02_3.*mi2.*rho1_2;
t41 = R02_2.*mi3.*rho1_3;
t42 = R01_1.*mi4.*rho2_4;
t43 = R01_3.*mi3.*rho2_3;
t44 = R02_3.*mi3.*rho1_3;
t45 = R02_2.*mi4.*rho1_4;
t46 = R01_1.*mi5.*rho2_5;
t47 = R01_3.*mi4.*rho2_4;
t48 = R02_3.*mi4.*rho1_4;
t49 = R02_2.*mi5.*rho1_5;
t50 = R01_1.*mi1.*rho3_1;
t51 = R01_1.*mi6.*rho2_6;
t52 = R01_3.*mi5.*rho2_5;
t53 = R02_1.*mi1.*rho2_1;
t54 = R02_3.*mi5.*rho1_5;
t55 = R01_2.*mi1.*rho3_1;
t56 = R02_2.*mi6.*rho1_6;
t57 = R03_2.*mi1.*rho1_1;
t58 = R01_1.*mi2.*rho3_2;
t59 = R01_3.*mi6.*rho2_6;
t60 = R02_1.*mi2.*rho2_2;
t61 = R02_3.*mi1.*rho2_1;
t62 = R02_3.*mi6.*rho1_6;
t63 = R03_3.*mi1.*rho1_1;
t64 = R01_2.*mi2.*rho3_2;
t65 = R03_2.*mi2.*rho1_2;
t66 = R01_1.*mi3.*rho3_3;
t67 = R02_1.*mi3.*rho2_3;
t68 = R02_3.*mi2.*rho2_2;
t69 = R03_3.*mi2.*rho1_2;
t70 = R01_2.*mi3.*rho3_3;
t71 = R03_2.*mi3.*rho1_3;
t72 = R01_1.*mi4.*rho3_4;
t73 = R02_1.*mi4.*rho2_4;
t74 = R02_3.*mi3.*rho2_3;
t75 = R03_3.*mi3.*rho1_3;
t76 = R01_2.*mi4.*rho3_4;
t77 = R03_2.*mi4.*rho1_4;
t78 = R01_1.*mi5.*rho3_5;
t79 = R02_1.*mi5.*rho2_5;
t80 = R02_3.*mi4.*rho2_4;
t81 = R03_3.*mi4.*rho1_4;
t82 = R01_2.*mi5.*rho3_5;
t83 = R03_2.*mi5.*rho1_5;
t84 = R01_1.*mi6.*rho3_6;
t85 = R02_1.*mi1.*rho3_1;
t86 = R02_1.*mi6.*rho2_6;
t87 = R02_3.*mi5.*rho2_5;
t88 = R03_1.*mi1.*rho2_1;
t89 = R03_3.*mi5.*rho1_5;
t90 = R01_2.*mi6.*rho3_6;
t91 = R02_2.*mi1.*rho3_1;
t92 = R03_2.*mi6.*rho1_6;
t93 = R02_1.*mi2.*rho3_2;
t94 = R02_3.*mi6.*rho2_6;
t95 = R03_1.*mi2.*rho2_2;
t96 = R03_3.*mi1.*rho2_1;
t97 = R03_3.*mi6.*rho1_6;
t98 = R02_2.*mi2.*rho3_2;
t99 = R02_1.*mi3.*rho3_3;
t100 = R03_1.*mi3.*rho2_3;
t101 = R03_3.*mi2.*rho2_2;
t102 = R02_2.*mi3.*rho3_3;
t103 = R02_1.*mi4.*rho3_4;
t104 = R03_1.*mi4.*rho2_4;
t105 = R03_3.*mi3.*rho2_3;
t106 = R02_2.*mi4.*rho3_4;
t107 = R02_1.*mi5.*rho3_5;
t108 = R03_1.*mi5.*rho2_5;
t109 = R03_3.*mi4.*rho2_4;
t110 = R02_2.*mi5.*rho3_5;
t111 = R02_1.*mi6.*rho3_6;
t112 = R03_1.*mi1.*rho3_1;
t113 = R03_1.*mi6.*rho2_6;
t114 = R03_3.*mi5.*rho2_5;
t115 = R02_2.*mi6.*rho3_6;
t116 = R03_2.*mi1.*rho3_1;
t117 = R03_1.*mi2.*rho3_2;
t118 = R03_3.*mi6.*rho2_6;
t119 = R03_2.*mi2.*rho3_2;
t120 = R03_1.*mi3.*rho3_3;
t121 = R03_2.*mi3.*rho3_3;
t122 = R03_1.*mi4.*rho3_4;
t123 = R03_2.*mi4.*rho3_4;
t124 = R03_1.*mi5.*rho3_5;
t125 = R03_2.*mi5.*rho3_5;
t126 = R03_1.*mi6.*rho3_6;
t127 = R03_2.*mi6.*rho3_6;
t128 = mi1.*qi1_1.*qi2_1;
t129 = mi2.*qi1_2.*qi2_2;
t130 = mi3.*qi1_3.*qi2_3;
t131 = mi4.*qi1_4.*qi2_4;
t132 = mi1.*qi1_1.*qi3_1;
t133 = mi5.*qi1_5.*qi2_5;
t134 = mi2.*qi1_2.*qi3_2;
t135 = mi6.*qi1_6.*qi2_6;
t136 = mi3.*qi1_3.*qi3_3;
t137 = mi4.*qi1_4.*qi3_4;
t138 = mi1.*qi2_1.*qi3_1;
t139 = mi5.*qi1_5.*qi3_5;
t140 = mi2.*qi2_2.*qi3_2;
t141 = mi6.*qi1_6.*qi3_6;
t142 = mi3.*qi2_3.*qi3_3;
t143 = mi4.*qi2_4.*qi3_4;
t144 = mi5.*qi2_5.*qi3_5;
t145 = mi6.*qi2_6.*qi3_6;
t146 = R01_1.*t128;
t147 = R01_2.*t128;
t148 = R01_3.*t128;
t149 = R01_1.*t129;
t150 = R01_2.*t129;
t151 = R01_3.*t129;
t152 = R01_1.*t130;
t153 = R01_2.*t130;
t154 = R01_3.*t130;
t155 = R01_1.*t131;
t156 = R01_1.*t132;
t157 = R01_2.*t131;
t158 = R02_1.*t128;
t159 = R01_2.*t132;
t160 = R01_3.*t131;
t161 = R02_2.*t128;
t162 = R01_1.*t133;
t163 = R01_3.*t132;
t164 = R02_3.*t128;
t165 = R01_1.*t134;
t166 = R01_2.*t133;
t167 = R02_1.*t129;
t168 = R01_2.*t134;
t169 = R01_3.*t133;
t170 = R02_2.*t129;
t171 = R01_1.*t135;
t172 = R01_3.*t134;
t173 = R02_3.*t129;
t174 = R01_1.*t136;
t175 = R01_2.*t135;
t176 = R02_1.*t130;
t177 = R01_2.*t136;
t178 = R01_3.*t135;
t179 = R02_2.*t130;
t180 = R01_3.*t136;
t181 = R02_3.*t130;
t182 = R01_1.*t137;
t183 = R02_1.*t131;
t184 = R01_2.*t137;
t185 = R02_2.*t131;
t186 = R01_3.*t137;
t187 = R02_3.*t131;
t188 = R01_1.*t139;
t189 = R02_1.*t133;
t190 = R01_2.*t139;
t191 = R02_2.*t133;
t192 = R01_3.*t139;
t193 = R02_3.*t133;
t194 = R01_1.*t141;
t195 = R02_1.*t135;
t196 = R01_2.*t141;
t197 = R02_2.*t135;
t198 = R01_3.*t141;
t199 = R02_3.*t135;
t200 = R02_1.*t138;
t201 = R03_1.*t132;
t202 = R02_2.*t138;
t203 = R03_2.*t132;
t204 = R02_3.*t138;
t205 = R03_3.*t132;
t206 = R02_1.*t140;
t207 = R03_1.*t134;
t208 = R02_2.*t140;
t209 = R03_2.*t134;
t210 = R02_3.*t140;
t211 = R03_3.*t134;
t212 = R02_1.*t142;
t213 = R03_1.*t136;
t214 = R02_2.*t142;
t215 = R03_2.*t136;
t216 = R02_3.*t142;
t217 = R03_3.*t136;
t218 = R02_1.*t143;
t219 = R03_1.*t137;
t220 = R02_2.*t143;
t221 = R03_1.*t138;
t222 = R03_2.*t137;
t223 = R02_3.*t143;
t224 = R03_2.*t138;
t225 = R03_3.*t137;
t226 = R02_1.*t144;
t227 = R03_1.*t139;
t228 = R03_3.*t138;
t229 = R02_2.*t144;
t230 = R03_1.*t140;
t231 = R03_2.*t139;
t232 = R02_3.*t144;
t233 = R03_2.*t140;
t234 = R03_3.*t139;
t235 = R02_1.*t145;
t236 = R03_1.*t141;
t237 = R03_3.*t140;
t238 = R02_2.*t145;
t239 = R03_1.*t142;
t240 = R03_2.*t141;
t241 = R02_3.*t145;
t242 = R03_2.*t142;
t243 = R03_3.*t141;
t244 = R03_3.*t142;
t245 = R03_1.*t143;
t246 = R03_2.*t143;
t247 = R03_3.*t143;
t248 = R03_1.*t144;
t249 = R03_2.*t144;
t250 = R03_3.*t144;
t251 = R03_1.*t145;
t252 = R03_2.*t145;
t253 = R03_3.*t145;
t254 = -t29;
t255 = -t33;
t256 = -t38;
t257 = -t42;
t258 = -t46;
t259 = -t50;
t260 = -t51;
t261 = -t53;
t262 = -t55;
t263 = -t58;
t264 = -t60;
t265 = -t64;
t266 = -t66;
t267 = -t67;
t268 = -t70;
t269 = -t72;
t270 = -t73;
t271 = -t76;
t272 = -t78;
t273 = -t79;
t274 = -t82;
t275 = -t84;
t276 = -t85;
t277 = -t86;
t278 = -t88;
t279 = -t90;
t280 = -t91;
t281 = -t93;
t282 = -t95;
t283 = -t98;
t284 = -t99;
t285 = -t100;
t286 = -t102;
t287 = -t103;
t288 = -t104;
t289 = -t106;
t290 = -t107;
t291 = -t108;
t292 = -t110;
t293 = -t111;
t294 = -t112;
t295 = -t113;
t296 = -t115;
t297 = -t116;
t298 = -t117;
t299 = -t119;
t300 = -t120;
t301 = -t121;
t302 = -t122;
t303 = -t123;
t304 = -t124;
t305 = -t125;
t306 = -t126;
t307 = -t127;
t308 = R01_1.*mi1.*t2;
t309 = R01_2.*mi1.*t2;
t310 = R01_1.*mi2.*t3;
t311 = R01_3.*mi1.*t2;
t312 = R01_2.*mi2.*t3;
t313 = R01_1.*mi3.*t4;
t314 = R01_3.*mi2.*t3;
t315 = R01_2.*mi3.*t4;
t316 = R01_1.*mi4.*t5;
t317 = R01_3.*mi3.*t4;
t318 = R01_2.*mi4.*t5;
t319 = R01_1.*mi5.*t6;
t320 = R01_3.*mi4.*t5;
t321 = R01_2.*mi5.*t6;
t322 = R01_1.*mi6.*t7;
t323 = R01_3.*mi5.*t6;
t324 = R01_2.*mi6.*t7;
t325 = R01_3.*mi6.*t7;
t326 = R02_1.*mi1.*t8;
t327 = R02_2.*mi1.*t8;
t328 = R02_1.*mi2.*t9;
t329 = R02_3.*mi1.*t8;
t330 = R02_2.*mi2.*t9;
t331 = R02_1.*mi3.*t10;
t332 = R02_3.*mi2.*t9;
t333 = R02_2.*mi3.*t10;
t334 = R02_1.*mi4.*t11;
t335 = R02_3.*mi3.*t10;
t336 = R02_2.*mi4.*t11;
t337 = R02_1.*mi5.*t12;
t338 = R02_3.*mi4.*t11;
t339 = R02_2.*mi5.*t12;
t340 = R02_1.*mi6.*t13;
t341 = R02_3.*mi5.*t12;
t342 = R02_2.*mi6.*t13;
t343 = R02_3.*mi6.*t13;
t344 = R03_1.*mi1.*t14;
t345 = R03_2.*mi1.*t14;
t346 = R03_1.*mi2.*t15;
t347 = R03_3.*mi1.*t14;
t348 = R03_2.*mi2.*t15;
t349 = R03_1.*mi3.*t16;
t350 = R03_3.*mi2.*t15;
t351 = R03_2.*mi3.*t16;
t352 = R03_1.*mi4.*t17;
t353 = R03_3.*mi3.*t16;
t354 = R03_2.*mi4.*t17;
t355 = R03_1.*mi5.*t18;
t356 = R03_3.*mi4.*t17;
t357 = R03_2.*mi5.*t18;
t358 = R03_1.*mi6.*t19;
t359 = R03_3.*mi5.*t18;
t360 = R03_2.*mi6.*t19;
t361 = R03_3.*mi6.*t19;
t524 = t128+t129+t130+t131+t133+t135;
t525 = t132+t134+t136+t137+t139+t141;
t526 = t138+t140+t142+t143+t144+t145;
t362 = t20+t254;
t363 = t22+t255;
t364 = t24+t256;
t365 = t21+t259;
t366 = t26+t257;
t367 = t23+t263;
t368 = t28+t258;
t369 = t25+t266;
t370 = t31+t260;
t371 = t32+t261;
t372 = t34+t262;
t373 = t27+t269;
t374 = t37+t264;
t375 = t39+t265;
t376 = t30+t272;
t377 = t41+t267;
t378 = t43+t268;
t379 = t35+t275;
t380 = t36+t276;
t381 = t45+t270;
t382 = t47+t271;
t383 = t40+t281;
t384 = t49+t273;
t385 = t52+t274;
t386 = t44+t284;
t387 = t56+t277;
t388 = t57+t278;
t389 = t59+t279;
t390 = t61+t280;
t391 = t48+t287;
t392 = t65+t282;
t393 = t68+t283;
t394 = t54+t290;
t395 = t71+t285;
t396 = t74+t286;
t397 = t62+t293;
t398 = t63+t294;
t399 = t77+t288;
t400 = t80+t289;
t401 = t69+t298;
t402 = t83+t291;
t403 = t87+t292;
t404 = t75+t300;
t405 = t92+t295;
t406 = t94+t296;
t407 = t96+t297;
t408 = t81+t302;
t409 = t101+t299;
t410 = t89+t304;
t411 = t105+t301;
t412 = t97+t306;
t413 = t109+t303;
t414 = t114+t305;
t415 = t118+t307;
t470 = t158+t201+t308;
t471 = t161+t203+t309;
t472 = t164+t205+t311;
t473 = t167+t207+t310;
t474 = t170+t209+t312;
t475 = t173+t211+t314;
t476 = t176+t213+t313;
t477 = t179+t215+t315;
t478 = t146+t221+t326;
t479 = t181+t217+t317;
t480 = t147+t224+t327;
t481 = t183+t219+t316;
t482 = t148+t228+t329;
t483 = t185+t222+t318;
t484 = t149+t230+t328;
t485 = t187+t225+t320;
t486 = t150+t233+t330;
t487 = t189+t227+t319;
t488 = t151+t237+t332;
t489 = t191+t231+t321;
t490 = t152+t239+t331;
t491 = t193+t234+t323;
t492 = t153+t242+t333;
t493 = t195+t236+t322;
t494 = t156+t200+t344;
t495 = t154+t244+t335;
t496 = t197+t240+t324;
t497 = t159+t202+t345;
A = ft_1({R01_1,R01_2,R01_3,R02_1,R02_2,R02_3,R03_1,R03_2,R03_3,j01,j02,j03,m0,mi1,mi2,mi3,mi4,mi5,mi6,qi1_1,qi1_2,qi1_3,qi1_4,qi1_5,qi1_6,qi2_1,qi2_2,qi2_3,qi2_4,qi2_5,qi2_6,qi3_1,qi3_2,qi3_3,qi3_4,qi3_5,qi3_6,rho1_1,rho1_2,rho1_3,rho1_4,rho1_5,rho1_6,rho2_1,rho2_2,rho2_3,rho2_4,rho2_5,rho2_6,rho3_1,rho3_2,rho3_3,rho3_4,rho3_5,rho3_6,t10,t11,t12,t13,t14,t15,t155,t157,t16,t160,t162,t163,t165,t166,t168,t169,t17,t171,t172,t174,t175,t177,t178,t18,t180,t182,t184,t186,t188,t19,t190,t192,t194,t196,t198,t199,t2,t204,t206,t208,t210,t212,t214,t216,t218,t220,t223,t226,t229,t232,t235,t238,t241,t243,t245,t246,t247,t248,t249,t250,t251,t252,t253,t3,t325,t334,t336,t337,t338,t339,t340,t341,t342,t343,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t363,t364,t365,t366,t367,t368,t369,t370,t371,t372,t373,t374,t375,t376,t377,t378,t379,t380,t381,t382,t383,t384,t385,t386,t387,t388,t389,t390,t391,t392,t393,t394,t395,t396,t397,t398,t399,t4,t400,t401,t402,t403,t404,t405,t406,t407,t408,t409,t410,t411,t412,t413,t414,t415,t470,t471,t472,t473,t474,t475,t476,t477,t478,t479,t480,t481,t482,t483,t484,t485,t486,t487,t488,t489,t490,t491,t492,t493,t494,t495,t496,t497,t5,t524,t525,t526,t6,t7,t8,t9});
end
function A = ft_1(ct)
[R01_1,R01_2,R01_3,R02_1,R02_2,R02_3,R03_1,R03_2,R03_3,j01,j02,j03,m0,mi1,mi2,mi3,mi4,mi5,mi6,qi1_1,qi1_2,qi1_3,qi1_4,qi1_5,qi1_6,qi2_1,qi2_2,qi2_3,qi2_4,qi2_5,qi2_6,qi3_1,qi3_2,qi3_3,qi3_4,qi3_5,qi3_6,rho1_1,rho1_2,rho1_3,rho1_4,rho1_5,rho1_6,rho2_1,rho2_2,rho2_3,rho2_4,rho2_5,rho2_6,rho3_1,rho3_2,rho3_3,rho3_4,rho3_5,rho3_6,t10,t11,t12,t13,t14,t15,t155,t157,t16,t160,t162,t163,t165,t166,t168,t169,t17,t171,t172,t174,t175,t177,t178,t18,t180,t182,t184,t186,t188,t19,t190,t192,t194,t196,t198,t199,t2,t204,t206,t208,t210,t212,t214,t216,t218,t220,t223,t226,t229,t232,t235,t238,t241,t243,t245,t246,t247,t248,t249,t250,t251,t252,t253,t3,t325,t334,t336,t337,t338,t339,t340,t341,t342,t343,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t363,t364,t365,t366,t367,t368,t369,t370,t371,t372,t373,t374,t375,t376,t377,t378,t379,t380,t381,t382,t383,t384,t385,t386,t387,t388,t389,t390,t391,t392,t393,t394,t395,t396,t397,t398,t399,t4,t400,t401,t402,t403,t404,t405,t406,t407,t408,t409,t410,t411,t412,t413,t414,t415,t470,t471,t472,t473,t474,t475,t476,t477,t478,t479,t480,t481,t482,t483,t484,t485,t486,t487,t488,t489,t490,t491,t492,t493,t494,t495,t496,t497,t5,t524,t525,t526,t6,t7,t8,t9] = ct{:};
t498 = t155+t245+t334;
t499 = t199+t243+t325;
t500 = t163+t204+t347;
t501 = t157+t246+t336;
t502 = t165+t206+t346;
t503 = t160+t247+t338;
t504 = t168+t208+t348;
t505 = t162+t248+t337;
t506 = t172+t210+t350;
t507 = t166+t249+t339;
t508 = t174+t212+t349;
t509 = t169+t250+t341;
t510 = t177+t214+t351;
t511 = t171+t251+t340;
t512 = t180+t216+t353;
t513 = t175+t252+t342;
t514 = t182+t218+t352;
t515 = t178+t253+t343;
t516 = t184+t220+t354;
t517 = t186+t223+t356;
t518 = t188+t226+t355;
t519 = t190+t229+t357;
t520 = t192+t232+t359;
t521 = t194+t235+t358;
t522 = t196+t238+t360;
t523 = t198+t241+t361;
t416 = qi1_1.*t362;
t417 = qi1_2.*t363;
t418 = qi1_3.*t364;
t419 = qi1_1.*t365;
t420 = qi1_4.*t366;
t421 = qi1_2.*t367;
t422 = qi1_5.*t368;
t423 = qi1_3.*t369;
t424 = qi1_1.*t372;
t425 = qi1_6.*t370;
t426 = qi1_4.*t373;
t427 = qi1_2.*t375;
t428 = qi2_1.*t371;
t429 = qi1_5.*t376;
t430 = qi1_3.*t378;
t431 = qi2_2.*t374;
t432 = qi1_6.*t379;
t433 = qi1_4.*t382;
t434 = qi2_3.*t377;
t435 = qi2_1.*t380;
t436 = qi1_5.*t385;
t437 = qi2_4.*t381;
t438 = qi2_2.*t383;
t439 = qi1_6.*t389;
t440 = qi2_5.*t384;
t441 = qi2_3.*t386;
t442 = qi2_1.*t390;
t443 = qi2_6.*t387;
t444 = qi2_4.*t391;
t445 = qi2_2.*t393;
t446 = qi3_1.*t388;
t447 = qi2_5.*t394;
t448 = qi2_3.*t396;
t449 = qi3_2.*t392;
t450 = qi2_6.*t397;
t451 = qi2_4.*t400;
t452 = qi3_3.*t395;
t453 = qi3_1.*t398;
t454 = qi2_5.*t403;
t455 = qi3_4.*t399;
t456 = qi3_2.*t401;
t457 = qi2_6.*t406;
t458 = qi3_5.*t402;
t459 = qi3_3.*t404;
t460 = qi3_1.*t407;
t461 = qi3_6.*t405;
t462 = qi3_4.*t408;
t463 = qi3_2.*t409;
t464 = qi3_5.*t410;
t465 = qi3_3.*t411;
t466 = qi3_6.*t412;
t467 = qi3_4.*t413;
t468 = qi3_5.*t414;
t469 = qi3_6.*t415;
t527 = t416+t428+t446;
t528 = t417+t431+t449;
t529 = t418+t434+t452;
t530 = t419+t435+t453;
t531 = t420+t437+t455;
t532 = t421+t438+t456;
t533 = t422+t440+t458;
t534 = t423+t441+t459;
t535 = t424+t442+t460;
t536 = t425+t443+t461;
t537 = t426+t444+t462;
t538 = t427+t445+t463;
t539 = t429+t447+t464;
t540 = t430+t448+t465;
t541 = t432+t450+t466;
t542 = t433+t451+t467;
t543 = t436+t454+t468;
t544 = t439+t457+t469;
t545 = R01_1.*qi1_1.*t527;
t546 = R01_2.*qi1_1.*t527;
t547 = R01_3.*qi1_1.*t527;
t548 = R01_1.*qi1_2.*t528;
t549 = R01_2.*qi1_2.*t528;
t550 = R01_3.*qi1_2.*t528;
t551 = R02_1.*qi2_1.*t527;
t552 = R02_2.*qi2_1.*t527;
t553 = R02_3.*qi2_1.*t527;
t554 = R01_1.*qi1_3.*t529;
t555 = R01_1.*qi1_1.*t530;
t556 = R01_2.*qi1_3.*t529;
t557 = R01_2.*qi1_1.*t530;
t558 = R01_3.*qi1_3.*t529;
t559 = R01_3.*qi1_1.*t530;
t560 = R02_1.*qi2_2.*t528;
t561 = R02_2.*qi2_2.*t528;
t562 = R02_3.*qi2_2.*t528;
t563 = R03_1.*qi3_1.*t527;
t564 = R03_2.*qi3_1.*t527;
t565 = R03_3.*qi3_1.*t527;
t566 = R01_1.*qi1_4.*t531;
t567 = R01_1.*qi1_2.*t532;
t568 = R01_2.*qi1_4.*t531;
t569 = R01_2.*qi1_2.*t532;
t570 = R01_3.*qi1_4.*t531;
t571 = R01_3.*qi1_2.*t532;
t572 = R02_1.*qi2_3.*t529;
t573 = R02_1.*qi2_1.*t530;
t574 = R02_2.*qi2_3.*t529;
t575 = R02_2.*qi2_1.*t530;
t576 = R02_3.*qi2_3.*t529;
t577 = R02_3.*qi2_1.*t530;
t578 = R03_1.*qi3_2.*t528;
t579 = R03_2.*qi3_2.*t528;
t580 = R03_3.*qi3_2.*t528;
t581 = R01_1.*qi1_5.*t533;
t582 = R01_1.*qi1_3.*t534;
t583 = R01_2.*qi1_5.*t533;
t584 = R01_1.*qi1_1.*t535;
t585 = R01_2.*qi1_3.*t534;
t586 = R01_3.*qi1_5.*t533;
t587 = R01_2.*qi1_1.*t535;
t588 = R01_3.*qi1_3.*t534;
t589 = R01_3.*qi1_1.*t535;
t590 = R02_1.*qi2_4.*t531;
t591 = R02_1.*qi2_2.*t532;
t592 = R02_2.*qi2_4.*t531;
t593 = R02_2.*qi2_2.*t532;
t594 = R02_3.*qi2_4.*t531;
t595 = R02_3.*qi2_2.*t532;
t596 = R03_1.*qi3_3.*t529;
t597 = R03_1.*qi3_1.*t530;
t598 = R03_2.*qi3_3.*t529;
t599 = R03_2.*qi3_1.*t530;
t600 = R03_3.*qi3_3.*t529;
t601 = R03_3.*qi3_1.*t530;
t602 = R01_1.*qi1_6.*t536;
t603 = R01_1.*qi1_4.*t537;
t604 = R01_2.*qi1_6.*t536;
t605 = R01_1.*qi1_2.*t538;
t606 = R01_2.*qi1_4.*t537;
t607 = R01_3.*qi1_6.*t536;
t608 = R01_2.*qi1_2.*t538;
t609 = R01_3.*qi1_4.*t537;
t610 = R01_3.*qi1_2.*t538;
t611 = R02_1.*qi2_5.*t533;
t612 = R02_1.*qi2_3.*t534;
t613 = R02_2.*qi2_5.*t533;
t614 = R02_1.*qi2_1.*t535;
t615 = R02_2.*qi2_3.*t534;
t616 = R02_3.*qi2_5.*t533;
t617 = R02_2.*qi2_1.*t535;
t618 = R02_3.*qi2_3.*t534;
t619 = R02_3.*qi2_1.*t535;
t620 = R03_1.*qi3_4.*t531;
t621 = R03_1.*qi3_2.*t532;
t622 = R03_2.*qi3_4.*t531;
t623 = R03_2.*qi3_2.*t532;
t624 = R03_3.*qi3_4.*t531;
t625 = R03_3.*qi3_2.*t532;
t626 = R01_1.*qi1_5.*t539;
t627 = R01_1.*qi1_3.*t540;
t628 = R01_2.*qi1_5.*t539;
t629 = R01_2.*qi1_3.*t540;
t630 = R01_3.*qi1_5.*t539;
t631 = R01_3.*qi1_3.*t540;
t632 = R02_1.*qi2_6.*t536;
t633 = R02_1.*qi2_4.*t537;
t634 = R02_2.*qi2_6.*t536;
t635 = R02_1.*qi2_2.*t538;
t636 = R02_2.*qi2_4.*t537;
t637 = R02_3.*qi2_6.*t536;
t638 = R02_2.*qi2_2.*t538;
t639 = R02_3.*qi2_4.*t537;
t640 = R02_3.*qi2_2.*t538;
t641 = R03_1.*qi3_5.*t533;
t642 = R03_1.*qi3_3.*t534;
t643 = R03_2.*qi3_5.*t533;
t644 = R03_1.*qi3_1.*t535;
t645 = R03_2.*qi3_3.*t534;
t646 = R03_3.*qi3_5.*t533;
t647 = R03_2.*qi3_1.*t535;
t648 = R03_3.*qi3_3.*t534;
t649 = R03_3.*qi3_1.*t535;
t650 = R01_1.*qi1_6.*t541;
t651 = R01_1.*qi1_4.*t542;
t652 = R01_2.*qi1_6.*t541;
t653 = R01_2.*qi1_4.*t542;
t654 = R01_3.*qi1_6.*t541;
t655 = R01_3.*qi1_4.*t542;
t656 = R02_1.*qi2_5.*t539;
t657 = R02_1.*qi2_3.*t540;
t658 = R02_2.*qi2_5.*t539;
t659 = R02_2.*qi2_3.*t540;
t660 = R02_3.*qi2_5.*t539;
t661 = R02_3.*qi2_3.*t540;
t662 = R03_1.*qi3_6.*t536;
t663 = R03_1.*qi3_4.*t537;
t664 = R03_2.*qi3_6.*t536;
t665 = R03_1.*qi3_2.*t538;
t666 = R03_2.*qi3_4.*t537;
t667 = R03_3.*qi3_6.*t536;
t668 = R03_2.*qi3_2.*t538;
t669 = R03_3.*qi3_4.*t537;
t670 = R03_3.*qi3_2.*t538;
t671 = R01_1.*qi1_5.*t543;
t672 = R01_2.*qi1_5.*t543;
t673 = R01_3.*qi1_5.*t543;
t674 = R02_1.*qi2_6.*t541;
t675 = R02_1.*qi2_4.*t542;
t676 = R02_2.*qi2_6.*t541;
t677 = R02_2.*qi2_4.*t542;
t678 = R02_3.*qi2_6.*t541;
t679 = R02_3.*qi2_4.*t542;
t680 = R03_1.*qi3_5.*t539;
t681 = R03_1.*qi3_3.*t540;
t682 = R03_2.*qi3_5.*t539;
t683 = R03_2.*qi3_3.*t540;
t684 = R03_3.*qi3_5.*t539;
t685 = R03_3.*qi3_3.*t540;
t686 = R01_1.*qi1_6.*t544;
t687 = R01_2.*qi1_6.*t544;
t688 = R01_3.*qi1_6.*t544;
t689 = R02_1.*qi2_5.*t543;
t690 = R02_2.*qi2_5.*t543;
t691 = R02_3.*qi2_5.*t543;
t692 = R03_1.*qi3_6.*t541;
t693 = R03_1.*qi3_4.*t542;
t694 = R03_2.*qi3_6.*t541;
t695 = R03_2.*qi3_4.*t542;
t696 = R03_3.*qi3_6.*t541;
t697 = R03_3.*qi3_4.*t542;
t698 = R02_1.*qi2_6.*t544;
t699 = R02_2.*qi2_6.*t544;
t700 = R02_3.*qi2_6.*t544;
t701 = R03_1.*qi3_5.*t543;
t702 = R03_2.*qi3_5.*t543;
t703 = R03_3.*qi3_5.*t543;
t704 = R03_1.*qi3_6.*t544;
t705 = R03_2.*qi3_6.*t544;
t706 = R03_3.*qi3_6.*t544;
t707 = t545+t551+t563;
t708 = t546+t552+t564;
t709 = t547+t553+t565;
t710 = t548+t560+t578;
t711 = t549+t561+t579;
t712 = t550+t562+t580;
t713 = t554+t572+t596;
t714 = t555+t573+t597;
t715 = t556+t574+t598;
t716 = t557+t575+t599;
t717 = t558+t576+t600;
t718 = t559+t577+t601;
t719 = t566+t590+t620;
t720 = t567+t591+t621;
t721 = t568+t592+t622;
t722 = t569+t593+t623;
t723 = t570+t594+t624;
t724 = t571+t595+t625;
t725 = t581+t611+t641;
t726 = t582+t612+t642;
t727 = t583+t613+t643;
t728 = t584+t614+t644;
t729 = t585+t615+t645;
t730 = t586+t616+t646;
t731 = t587+t617+t647;
t732 = t588+t618+t648;
t733 = t589+t619+t649;
t734 = t602+t632+t662;
t735 = t603+t633+t663;
t736 = t604+t634+t664;
t737 = t605+t635+t665;
t738 = t606+t636+t666;
t739 = t607+t637+t667;
t740 = t608+t638+t668;
t741 = t609+t639+t669;
t742 = t610+t640+t670;
t743 = t626+t656+t680;
t744 = t627+t657+t681;
t745 = t628+t658+t682;
t746 = t629+t659+t683;
t747 = t630+t660+t684;
t748 = t631+t661+t685;
t749 = t650+t674+t692;
t750 = t651+t675+t693;
t751 = t652+t676+t694;
t752 = t653+t677+t695;
t753 = t654+t678+t696;
t754 = t655+t679+t697;
t755 = t671+t689+t701;
t756 = t672+t690+t702;
t757 = t673+t691+t703;
t758 = t686+t698+t704;
t759 = t687+t699+t705;
t760 = t688+t700+t706;
mt1 = [m0+mi1.*t2+mi2.*t3+mi3.*t4+mi4.*t5+mi5.*t6+mi6.*t7,t524,t525,qi1_1.*t535+qi1_2.*t538+qi1_3.*t540+qi1_4.*t542+qi1_5.*t543+qi1_6.*t544,-qi1_1.*t530-qi1_2.*t532-qi1_3.*t534-qi1_4.*t537-qi1_5.*t539-qi1_6.*t541,qi1_1.*t527+qi1_2.*t528+qi1_3.*t529+qi1_4.*t531+qi1_5.*t533+qi1_6.*t536,t524,m0+mi1.*t8+mi2.*t9+mi3.*t10+mi4.*t11+mi5.*t12+mi6.*t13,t526,qi2_1.*t535+qi2_2.*t538+qi2_3.*t540+qi2_4.*t542+qi2_5.*t543+qi2_6.*t544,-qi2_1.*t530-qi2_2.*t532-qi2_3.*t534-qi2_4.*t537-qi2_5.*t539-qi2_6.*t541,qi2_1.*t527+qi2_2.*t528+qi2_3.*t529+qi2_4.*t531+qi2_5.*t533+qi2_6.*t536,t525,t526];
mt2 = [m0+mi1.*t14+mi2.*t15+mi3.*t16+mi4.*t17+mi5.*t18+mi6.*t19,qi3_1.*t535+qi3_2.*t538+qi3_3.*t540+qi3_4.*t542+qi3_5.*t543+qi3_6.*t544,-qi3_1.*t530-qi3_2.*t532-qi3_3.*t534-qi3_4.*t537-qi3_5.*t539-qi3_6.*t541,qi3_1.*t527+qi3_2.*t528+qi3_3.*t529+qi3_4.*t531+qi3_5.*t533+qi3_6.*t536,rho2_1.*t472+rho2_2.*t475+rho2_3.*t479-rho3_1.*t471-rho3_2.*t474+rho2_4.*t485-rho3_3.*t477+rho2_5.*t491-rho3_4.*t483-rho3_5.*t489+rho2_6.*t499-rho3_6.*t496,rho2_1.*t482+rho2_2.*t488-rho3_1.*t480+rho2_3.*t495-rho3_2.*t486-rho3_3.*t492+rho2_4.*t503+rho2_5.*t509-rho3_4.*t501+rho2_6.*t515-rho3_5.*t507-rho3_6.*t513];
mt3 = [rho2_1.*t500+rho2_2.*t506-rho3_1.*t497+rho2_3.*t512-rho3_2.*t504+rho2_4.*t517-rho3_3.*t510+rho2_5.*t520+rho2_6.*t523-rho3_4.*t516-rho3_5.*t519-rho3_6.*t522,j01+rho2_1.*t733-rho3_1.*t731+rho2_2.*t742+rho2_3.*t748-rho3_2.*t740+rho2_4.*t754-rho3_3.*t746+rho2_5.*t757+rho2_6.*t760-rho3_4.*t752-rho3_5.*t756-rho3_6.*t759,-rho2_1.*t718-rho2_2.*t724+rho3_1.*t716+rho3_2.*t722-rho2_3.*t732+rho3_3.*t729-rho2_4.*t741-rho2_5.*t747+rho3_4.*t738-rho2_6.*t753+rho3_5.*t745+rho3_6.*t751,rho2_1.*t709+rho2_2.*t712-rho3_1.*t708+rho2_3.*t717-rho3_2.*t711+rho2_4.*t723-rho3_3.*t715+rho2_5.*t730-rho3_4.*t721-rho3_5.*t727+rho2_6.*t739-rho3_6.*t736];
mt4 = [-rho1_1.*t472-rho1_2.*t475-rho1_3.*t479-rho1_4.*t485+rho3_1.*t470+rho3_2.*t473-rho1_5.*t491+rho3_3.*t476-rho1_6.*t499+rho3_4.*t481+rho3_5.*t487+rho3_6.*t493,-rho1_1.*t482-rho1_2.*t488-rho1_3.*t495+rho3_1.*t478+rho3_2.*t484-rho1_4.*t503+rho3_3.*t490-rho1_5.*t509-rho1_6.*t515+rho3_4.*t498+rho3_5.*t505+rho3_6.*t511,-rho1_1.*t500-rho1_2.*t506-rho1_3.*t512+rho3_1.*t494-rho1_4.*t517+rho3_2.*t502-rho1_5.*t520-rho1_6.*t523+rho3_3.*t508+rho3_4.*t514+rho3_5.*t518+rho3_6.*t521,-rho1_1.*t733-rho1_2.*t742+rho3_1.*t728-rho1_3.*t748-rho1_4.*t754+rho3_2.*t737-rho1_5.*t757-rho1_6.*t760+rho3_3.*t744+rho3_4.*t750+rho3_5.*t755+rho3_6.*t758];
mt5 = [j02+rho1_1.*t718+rho1_2.*t724+rho1_3.*t732-rho3_1.*t714-rho3_2.*t720+rho1_4.*t741-rho3_3.*t726+rho1_5.*t747+rho1_6.*t753-rho3_4.*t735-rho3_5.*t743-rho3_6.*t749,-rho1_1.*t709-rho1_2.*t712-rho1_3.*t717-rho1_4.*t723+rho3_1.*t707+rho3_2.*t710-rho1_5.*t730+rho3_3.*t713+rho3_4.*t719-rho1_6.*t739+rho3_5.*t725+rho3_6.*t734,rho1_1.*t471+rho1_2.*t474+rho1_3.*t477-rho2_1.*t470-rho2_2.*t473+rho1_4.*t483-rho2_3.*t476+rho1_5.*t489-rho2_4.*t481+rho1_6.*t496-rho2_5.*t487-rho2_6.*t493,rho1_1.*t480+rho1_2.*t486-rho2_1.*t478+rho1_3.*t492-rho2_2.*t484-rho2_3.*t490+rho1_4.*t501+rho1_5.*t507-rho2_4.*t498+rho1_6.*t513-rho2_5.*t505-rho2_6.*t511];
mt6 = [rho1_1.*t497-rho2_1.*t494+rho1_2.*t504+rho1_3.*t510-rho2_2.*t502+rho1_4.*t516-rho2_3.*t508+rho1_5.*t519+rho1_6.*t522-rho2_4.*t514-rho2_5.*t518-rho2_6.*t521,rho1_1.*t731-rho2_1.*t728+rho1_2.*t740+rho1_3.*t746-rho2_2.*t737+rho1_4.*t752-rho2_3.*t744+rho1_5.*t756-rho2_4.*t750+rho1_6.*t759-rho2_5.*t755-rho2_6.*t758,-rho1_1.*t716-rho1_2.*t722+rho2_1.*t714-rho1_3.*t729+rho2_2.*t720+rho2_3.*t726-rho1_4.*t738+rho2_4.*t735-rho1_5.*t745-rho1_6.*t751+rho2_5.*t743+rho2_6.*t749,j03+rho1_1.*t708+rho1_2.*t711+rho1_3.*t715-rho2_1.*t707-rho2_2.*t710+rho1_4.*t721-rho2_3.*t713+rho1_5.*t727-rho2_4.*t719-rho2_5.*t725+rho1_6.*t736-rho2_6.*t734];
A = reshape([mt1,mt2,mt3,mt4,mt5,mt6],6,6);
end
