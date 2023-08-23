function ui = CSLC_3_ui(in1,in2,in3,in4,in5,in6,in7,in8,in9,in10)
%CSLC_3_ui
%    UI = CSLC_3_ui(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9,IN10)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/08/24 02:37:36

R01_1 = in3(1);
R01_2 = in3(4);
R01_3 = in3(7);
R02_1 = in3(2);
R02_2 = in3(5);
R02_3 = in3(8);
R03_1 = in3(3);
R03_2 = in3(6);
R03_3 = in3(9);
R0d1_1 = in4(1);
R0d1_2 = in4(4);
R0d1_3 = in4(7);
R0d2_1 = in4(2);
R0d2_2 = in4(5);
R0d2_3 = in4(8);
R0d3_1 = in4(3);
R0d3_2 = in4(6);
R0d3_3 = in4(9);
do0d1 = in2(16,:);
do0d2 = in2(17,:);
do0d3 = in2(18,:);
j01 = in5(:,3);
j02 = in5(:,4);
j03 = in5(:,5);
kqi = in6(:,13);
kwi = in6(:,14);
li1 = in5(:,15);
li2 = in5(:,16);
li3 = in5(:,17);
m0 = in5(:,2);
mi1 = in5(:,18);
mi2 = in5(:,19);
mi3 = in5(:,20);
muid1_1 = in10(1);
muid1_2 = in10(4);
muid1_3 = in10(7);
muid2_1 = in10(2);
muid2_2 = in10(5);
muid2_3 = in10(8);
muid3_1 = in10(3);
muid3_2 = in10(6);
muid3_3 = in10(9);
o01 = in1(11,:);
o02 = in1(12,:);
o03 = in1(13,:);
o0d1 = in2(13,:);
o0d2 = in2(14,:);
o0d3 = in2(15,:);
qi1_1 = in1(14,:);
qi1_2 = in1(17,:);
qi1_3 = in1(20,:);
qi2_1 = in1(15,:);
qi2_2 = in1(18,:);
qi2_3 = in1(21,:);
qi3_1 = in1(16,:);
qi3_2 = in1(19,:);
qi3_3 = in1(22,:);
qid1_1 = in7(1);
qid1_2 = in7(4);
qid1_3 = in7(7);
qid2_1 = in7(2);
qid2_2 = in7(5);
qid2_3 = in7(8);
qid3_1 = in7(3);
qid3_2 = in7(6);
qid3_3 = in7(9);
rho1_1 = in5(:,6);
rho1_2 = in5(:,9);
rho1_3 = in5(:,12);
rho2_1 = in5(:,7);
rho2_2 = in5(:,10);
rho2_3 = in5(:,13);
rho3_1 = in5(:,8);
rho3_2 = in5(:,11);
rho3_3 = in5(:,14);
wi1_1 = in1(23,:);
wi1_2 = in1(26,:);
wi1_3 = in1(29,:);
wi2_1 = in1(24,:);
wi2_2 = in1(27,:);
wi2_3 = in1(30,:);
wi3_1 = in1(25,:);
wi3_2 = in1(28,:);
wi3_3 = in1(31,:);
t2 = R0d1_1.*o0d2;
t3 = R0d1_2.*o0d1;
t4 = R0d1_1.*o0d3;
t5 = R0d1_3.*o0d1;
t6 = R0d1_2.*o0d3;
t7 = R0d1_3.*o0d2;
t8 = R0d2_1.*o0d2;
t9 = R0d2_2.*o0d1;
t10 = R0d2_1.*o0d3;
t11 = R0d2_3.*o0d1;
t12 = R0d2_2.*o0d3;
t13 = R0d2_3.*o0d2;
t14 = R0d3_1.*o0d2;
t15 = R0d3_2.*o0d1;
t16 = R0d3_1.*o0d3;
t17 = R0d3_3.*o0d1;
t18 = R0d3_2.*o0d3;
t19 = R0d3_3.*o0d2;
t20 = R0d1_1.*qid1_1;
t21 = R0d1_1.*qid1_2;
t22 = R0d1_2.*qid1_1;
t23 = R0d1_1.*qid1_3;
t24 = R0d1_2.*qid1_2;
t25 = R0d1_3.*qid1_1;
t26 = R0d1_2.*qid1_3;
t27 = R0d1_3.*qid1_2;
t28 = R0d1_3.*qid1_3;
t29 = R0d2_1.*qid2_1;
t30 = R0d2_1.*qid2_2;
t31 = R0d2_2.*qid2_1;
t32 = R0d2_1.*qid2_3;
t33 = R0d2_2.*qid2_2;
t34 = R0d2_3.*qid2_1;
t35 = R0d2_2.*qid2_3;
t36 = R0d2_3.*qid2_2;
t37 = R0d2_3.*qid2_3;
t38 = R0d3_1.*qid3_1;
t39 = R0d3_1.*qid3_2;
t40 = R0d3_2.*qid3_1;
t41 = R0d3_1.*qid3_3;
t42 = R0d3_2.*qid3_2;
t43 = R0d3_3.*qid3_1;
t44 = R0d3_2.*qid3_3;
t45 = R0d3_3.*qid3_2;
t46 = R0d3_3.*qid3_3;
t47 = R01_2.*rho1_1;
t48 = R01_2.*rho1_2;
t49 = R01_3.*rho1_1;
t50 = R01_2.*rho1_3;
t51 = R01_3.*rho1_2;
t52 = R01_3.*rho1_3;
t53 = R01_1.*rho2_1;
t54 = R01_1.*rho2_2;
t55 = R02_2.*rho1_1;
t56 = R01_1.*rho2_3;
t57 = R01_3.*rho2_1;
t58 = R02_2.*rho1_2;
t59 = R02_3.*rho1_1;
t60 = R01_3.*rho2_2;
t61 = R02_2.*rho1_3;
t62 = R02_3.*rho1_2;
t63 = R01_3.*rho2_3;
t64 = R02_3.*rho1_3;
t65 = R01_1.*rho3_1;
t66 = R02_1.*rho2_1;
t67 = R01_1.*rho3_2;
t68 = R01_2.*rho3_1;
t69 = R02_1.*rho2_2;
t70 = R03_2.*rho1_1;
t71 = R01_1.*rho3_3;
t72 = R01_2.*rho3_2;
t73 = R02_1.*rho2_3;
t74 = R02_3.*rho2_1;
t75 = R03_2.*rho1_2;
t76 = R03_3.*rho1_1;
t77 = R01_2.*rho3_3;
t78 = R02_3.*rho2_2;
t79 = R03_2.*rho1_3;
t80 = R03_3.*rho1_2;
t81 = R02_3.*rho2_3;
t82 = R03_3.*rho1_3;
t83 = R02_1.*rho3_1;
t84 = R03_1.*rho2_1;
t85 = R02_1.*rho3_2;
t86 = R02_2.*rho3_1;
t87 = R03_1.*rho2_2;
t88 = R02_1.*rho3_3;
t89 = R02_2.*rho3_2;
t90 = R03_1.*rho2_3;
t91 = R03_3.*rho2_1;
t92 = R02_2.*rho3_3;
t93 = R03_3.*rho2_2;
t94 = R03_3.*rho2_3;
t95 = R03_1.*rho3_1;
t96 = R03_1.*rho3_2;
t97 = R03_2.*rho3_1;
t98 = R03_1.*rho3_3;
t99 = R03_2.*rho3_2;
t100 = R03_2.*rho3_3;
t101 = o0d1.*o0d2;
t102 = o0d1.*o0d3;
t103 = o0d2.*o0d3;
t104 = qi1_1.*qid2_1;
t105 = qi2_1.*qid1_1;
t106 = qi1_2.*qid2_2;
t107 = qi2_2.*qid1_2;
t108 = qi1_3.*qid2_3;
t109 = qi2_3.*qid1_3;
t110 = qi1_1.*qid3_1;
t111 = qi3_1.*qid1_1;
t112 = qi1_2.*qid3_2;
t113 = qi3_2.*qid1_2;
t114 = qi1_3.*qid3_3;
t115 = qi3_3.*qid1_3;
t116 = qi2_1.*qid3_1;
t117 = qi3_1.*qid2_1;
t118 = qi2_2.*qid3_2;
t119 = qi3_2.*qid2_2;
t120 = qi2_3.*qid3_3;
t121 = qi3_3.*qid2_3;
t122 = qi1_1.*wi2_1;
t123 = qi2_1.*wi1_1;
t124 = qi1_2.*wi2_2;
t125 = qi2_2.*wi1_2;
t126 = qi1_3.*wi2_3;
t127 = qi2_3.*wi1_3;
t128 = qi1_1.*wi3_1;
t129 = qi3_1.*wi1_1;
t130 = qi1_2.*wi3_2;
t131 = qi3_2.*wi1_2;
t132 = qi1_3.*wi3_3;
t133 = qi3_3.*wi1_3;
t134 = qi2_1.*wi3_1;
t135 = qi3_1.*wi2_1;
t136 = qi2_2.*wi3_2;
t137 = qi3_2.*wi2_2;
t138 = qi2_3.*wi3_3;
t139 = qi3_3.*wi2_3;
t140 = o01.^2;
t141 = o02.^2;
t142 = o03.^2;
t143 = o0d1.^2;
t144 = o0d2.^2;
t145 = o0d3.^2;
t146 = qi1_1.^2;
t147 = qi1_2.^2;
t148 = qi1_3.^2;
t149 = qi2_1.^2;
t150 = qi2_2.^2;
t151 = qi2_3.^2;
t152 = qi3_1.^2;
t153 = qi3_2.^2;
t154 = qi3_3.^2;
t155 = wi1_1.^2;
t156 = wi1_2.^2;
t157 = wi1_3.^2;
t158 = wi2_1.^2;
t159 = wi2_2.^2;
t160 = wi2_3.^2;
t161 = wi3_1.^2;
t162 = wi3_2.^2;
t163 = wi3_3.^2;
t164 = R01_1.*o01.*o02;
t165 = R01_1.*o01.*o03;
t166 = R01_2.*o01.*o02;
t167 = R01_2.*o02.*o03;
t168 = R01_3.*o01.*o03;
t169 = R01_3.*o02.*o03;
t170 = R02_1.*o01.*o02;
t171 = R02_1.*o01.*o03;
t172 = R02_2.*o01.*o02;
t173 = R02_2.*o02.*o03;
t174 = R02_3.*o01.*o03;
t175 = R02_3.*o02.*o03;
t176 = R03_1.*o01.*o02;
t177 = R03_1.*o01.*o03;
t178 = R03_2.*o01.*o02;
t179 = R03_2.*o02.*o03;
t180 = R03_3.*o01.*o03;
t181 = R03_3.*o02.*o03;
t182 = j01.*o01.*o02;
t183 = j01.*o01.*o03;
t184 = j02.*o01.*o02;
t185 = j02.*o02.*o03;
t186 = j03.*o01.*o03;
t187 = j03.*o02.*o03;
t188 = muid1_1+muid1_2+muid1_3;
t189 = muid2_1+muid2_2+muid2_3;
t190 = muid3_1+muid3_2+muid3_3;
t191 = 1.0./j01;
t192 = 1.0./j02;
t193 = 1.0./j03;
t194 = 1.0./m0;
t195 = -wi2_1;
t196 = -wi2_2;
t197 = -wi2_3;
t198 = do0d1+t103;
t199 = do0d2+t102;
t200 = do0d3+t101;
t201 = -t3;
t202 = -t5;
t203 = -t7;
t204 = -t9;
t205 = -t11;
t206 = -t13;
t207 = -t15;
t208 = -t17;
t209 = -t19;
t210 = -t53;
t211 = -t54;
t212 = -t56;
t213 = -t65;
t214 = -t66;
t215 = -t67;
t216 = -t68;
t217 = -t69;
t218 = -t71;
t219 = -t72;
t220 = -t73;
t221 = -t77;
t222 = -t83;
t223 = -t84;
t224 = -t85;
t225 = -t86;
t226 = -t87;
t227 = -t88;
t228 = -t89;
t229 = -t90;
t230 = -t92;
t231 = -t95;
t232 = -t96;
t233 = -t97;
t234 = -t98;
t235 = -t99;
t236 = -t100;
t237 = -t101;
t238 = -t102;
t239 = -t103;
t240 = -t105;
t241 = -t107;
t242 = -t109;
t243 = -t111;
t244 = -t113;
t245 = -t115;
t246 = -t117;
t247 = -t119;
t248 = -t121;
t249 = -t123;
t250 = -t125;
t251 = -t127;
t252 = -t129;
t253 = -t131;
t254 = -t133;
t255 = -t135;
t256 = -t137;
t257 = -t139;
t258 = -t184;
t259 = -t186;
t260 = -t187;
t261 = t146+t149;
t262 = t147+t150;
t263 = t148+t151;
t264 = t146+t152;
t265 = t147+t153;
t266 = t148+t154;
t267 = t149+t152;
t268 = t150+t153;
t269 = t151+t154;
t282 = t140+t141;
t283 = t140+t142;
t284 = t141+t142;
t285 = t143+t144;
t286 = t143+t145;
t287 = t144+t145;
t360 = t188.*t194;
t361 = t189.*t194;
t362 = t190.*t194;
t381 = t20+t29+t38;
t382 = t21+t30+t39;
t383 = t22+t31+t40;
t384 = t23+t32+t41;
t385 = t24+t33+t42;
t386 = t25+t34+t43;
t387 = t26+t35+t44;
t388 = t27+t36+t45;
t389 = t28+t37+t46;
t390 = t155+t158+t161;
t391 = t156+t159+t162;
t392 = t157+t160+t163;
t270 = do0d1+t239;
t271 = do0d2+t238;
t272 = do0d3+t237;
t273 = R0d1_1.*t199;
t274 = R0d1_2.*t200;
t275 = R0d1_3.*t198;
t276 = R0d2_1.*t199;
t277 = R0d2_2.*t200;
t278 = R0d2_3.*t198;
t279 = R0d3_1.*t199;
t280 = R0d3_2.*t200;
t281 = R0d3_3.*t198;
t288 = t2+t201;
t289 = t4+t202;
t290 = t6+t203;
t291 = t8+t204;
t292 = t10+t205;
t293 = t12+t206;
t294 = t14+t207;
t295 = t16+t208;
t296 = t18+t209;
t297 = t47+t210;
t298 = t48+t211;
t299 = t50+t212;
t300 = t49+t213;
t301 = t51+t215;
t302 = t52+t218;
t303 = t55+t214;
t304 = t57+t216;
t305 = t58+t217;
t306 = t60+t219;
t307 = t61+t220;
t308 = t63+t221;
t309 = t59+t222;
t310 = t62+t224;
t311 = t64+t227;
t312 = t70+t223;
t313 = t74+t225;
t314 = t75+t226;
t315 = t78+t228;
t316 = t79+t229;
t317 = t81+t230;
t318 = t76+t231;
t319 = t80+t232;
t320 = t82+t234;
t321 = t91+t233;
t322 = t93+t235;
t323 = t94+t236;
t324 = R01_1.*t284;
t325 = R01_2.*t283;
t326 = R01_3.*t282;
t327 = R02_1.*t284;
t328 = R02_2.*t283;
t329 = R02_3.*t282;
t330 = R03_1.*t284;
t331 = R03_2.*t283;
t332 = R03_3.*t282;
t333 = R0d1_1.*t287;
t334 = R0d1_2.*t286;
t335 = R0d1_3.*t285;
t336 = R0d2_1.*t287;
t337 = R0d2_2.*t286;
t338 = R0d2_3.*t285;
t339 = R0d3_1.*t287;
t340 = R0d3_2.*t286;
t341 = R0d3_3.*t285;
t363 = t104+t240;
t364 = t106+t241;
t365 = t108+t242;
t366 = t110+t243;
t367 = t112+t244;
t368 = t114+t245;
t369 = t116+t246;
t370 = t118+t247;
t371 = t120+t248;
t372 = t122+t249;
t373 = t124+t250;
t374 = t126+t251;
t375 = t128+t252;
t376 = t130+t253;
t377 = t132+t254;
t378 = t134+t255;
t379 = t136+t256;
t380 = t138+t257;
t342 = R0d1_1.*t272;
t343 = -t273;
t344 = R0d1_2.*t270;
t345 = -t274;
t346 = R0d1_3.*t271;
t347 = -t275;
t348 = R0d2_1.*t272;
t349 = -t276;
t350 = R0d2_2.*t270;
t351 = -t277;
t352 = R0d2_3.*t271;
t353 = -t278;
t354 = R0d3_1.*t272;
t355 = -t279;
t356 = R0d3_2.*t270;
t357 = -t280;
t358 = R0d3_3.*t271;
t359 = -t281;
t393 = muid1_1.*t297;
t394 = muid1_2.*t298;
t395 = muid1_3.*t299;
t396 = muid1_1.*t300;
t397 = muid1_2.*t301;
t398 = muid1_3.*t302;
t399 = muid1_1.*t304;
t400 = muid1_2.*t306;
t401 = muid1_3.*t308;
t402 = muid2_1.*t303;
t403 = muid2_2.*t305;
t404 = muid2_3.*t307;
t405 = muid2_1.*t309;
t406 = muid2_2.*t310;
t407 = muid2_3.*t311;
t408 = muid2_1.*t313;
t409 = muid2_2.*t315;
t410 = muid2_3.*t317;
t411 = muid3_1.*t312;
t412 = muid3_2.*t314;
t413 = muid3_3.*t316;
t414 = muid3_1.*t318;
t415 = muid3_2.*t319;
t416 = muid3_3.*t320;
t417 = muid3_1.*t321;
ui = ft_1({kqi,kwi,li1,li2,li3,mi1,mi2,mi3,muid1_1,muid1_2,muid1_3,muid2_1,muid2_2,muid2_3,muid3_1,muid3_2,muid3_3,qi1_1,qi1_2,qi1_3,qi2_1,qi2_2,qi2_3,qi3_1,qi3_2,qi3_3,qid1_1,qid1_2,qid1_3,qid2_1,qid2_2,qid2_3,qid3_1,qid3_2,qid3_3,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,t146,t147,t148,t149,t150,t151,t152,t153,t154,t164,t165,t166,t167,t168,t169,t170,t171,t172,t173,t174,t175,t176,t177,t178,t179,t180,t181,t182,t183,t185,t191,t192,t193,t195,t196,t197,t258,t259,t260,t261,t262,t263,t264,t265,t266,t267,t268,t269,t288,t289,t290,t291,t292,t293,t294,t295,t296,t297,t298,t299,t300,t301,t302,t303,t304,t305,t306,t307,t308,t309,t310,t311,t312,t313,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t325,t326,t327,t328,t329,t330,t331,t332,t333,t334,t335,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t363,t364,t365,t366,t367,t368,t369,t370,t371,t372,t373,t374,t375,t376,t377,t378,t379,t380,t381,t382,t383,t384,t385,t386,t387,t388,t389,t390,t391,t392,t393,t394,t395,t396,t397,t398,t399,t400,t401,t402,t403,t404,t405,t406,t407,t408,t409,t410,t411,t412,t413,t414,t415,t416,t417,wi1_1,wi1_2,wi1_3,wi3_1,wi3_2,wi3_3});
end
function ui = ft_1(ct)
[kqi,kwi,li1,li2,li3,mi1,mi2,mi3,muid1_1,muid1_2,muid1_3,muid2_1,muid2_2,muid2_3,muid3_1,muid3_2,muid3_3,qi1_1,qi1_2,qi1_3,qi2_1,qi2_2,qi2_3,qi3_1,qi3_2,qi3_3,qid1_1,qid1_2,qid1_3,qid2_1,qid2_2,qid2_3,qid3_1,qid3_2,qid3_3,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,t146,t147,t148,t149,t150,t151,t152,t153,t154,t164,t165,t166,t167,t168,t169,t170,t171,t172,t173,t174,t175,t176,t177,t178,t179,t180,t181,t182,t183,t185,t191,t192,t193,t195,t196,t197,t258,t259,t260,t261,t262,t263,t264,t265,t266,t267,t268,t269,t288,t289,t290,t291,t292,t293,t294,t295,t296,t297,t298,t299,t300,t301,t302,t303,t304,t305,t306,t307,t308,t309,t310,t311,t312,t313,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t325,t326,t327,t328,t329,t330,t331,t332,t333,t334,t335,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t363,t364,t365,t366,t367,t368,t369,t370,t371,t372,t373,t374,t375,t376,t377,t378,t379,t380,t381,t382,t383,t384,t385,t386,t387,t388,t389,t390,t391,t392,t393,t394,t395,t396,t397,t398,t399,t400,t401,t402,t403,t404,t405,t406,t407,t408,t409,t410,t411,t412,t413,t414,t415,t416,t417,wi1_1,wi1_2,wi1_3,wi3_1,wi3_2,wi3_3] = ct{:};
t418 = muid3_2.*t322;
t419 = muid3_3.*t323;
t420 = -t324;
t421 = -t325;
t422 = -t326;
t423 = -t327;
t424 = -t328;
t425 = -t329;
t426 = -t330;
t427 = -t331;
t428 = -t332;
t429 = kqi.*t363;
t430 = kqi.*t364;
t431 = kqi.*t365;
t432 = kqi.*t366;
t433 = kqi.*t367;
t434 = kqi.*t368;
t435 = kqi.*t369;
t436 = kqi.*t370;
t437 = kqi.*t371;
t456 = t290.*t381;
t457 = t289.*t383;
t458 = t288.*t386;
t459 = t290.*t382;
t460 = t289.*t385;
t461 = t288.*t388;
t462 = t290.*t384;
t463 = t289.*t387;
t464 = t288.*t389;
t465 = t293.*t381;
t466 = t292.*t383;
t467 = t291.*t386;
t468 = t293.*t382;
t469 = t292.*t385;
t470 = t291.*t388;
t471 = t293.*t384;
t472 = t292.*t387;
t473 = t291.*t389;
t474 = t296.*t381;
t475 = t295.*t383;
t476 = t294.*t386;
t477 = t296.*t382;
t478 = t295.*t385;
t479 = t294.*t388;
t480 = t296.*t384;
t481 = t295.*t387;
t482 = t294.*t389;
t447 = t166+t168+t420;
t448 = t164+t169+t421;
t449 = t165+t167+t422;
t450 = t172+t174+t423;
t451 = t170+t175+t424;
t452 = t171+t173+t425;
t453 = t178+t180+t426;
t454 = t176+t181+t427;
t455 = t177+t179+t428;
t483 = -t457;
t484 = -t460;
t485 = -t463;
t486 = -t466;
t487 = -t469;
t488 = -t472;
t489 = -t475;
t490 = -t478;
t491 = -t481;
t519 = t335+t343+t344;
t520 = t334+t342+t347;
t521 = t333+t345+t346;
t522 = t338+t349+t350;
t523 = t337+t348+t353;
t524 = t336+t351+t352;
t525 = t341+t355+t356;
t526 = t340+t354+t359;
t527 = t339+t357+t358;
t591 = t182+t258+t393+t394+t395+t402+t403+t404+t411+t412+t413;
t592 = t183+t259+t396+t397+t398+t405+t406+t407+t414+t415+t416;
t593 = t185+t260+t399+t400+t401+t408+t409+t410+t417+t418+t419;
t492 = rho1_1.*t447;
t493 = rho1_2.*t447;
t494 = rho1_3.*t447;
t495 = rho2_1.*t448;
t496 = rho2_2.*t448;
t497 = rho2_3.*t448;
t498 = rho3_1.*t449;
t499 = rho3_2.*t449;
t500 = rho3_3.*t449;
t501 = rho1_1.*t450;
t502 = rho1_2.*t450;
t503 = rho1_3.*t450;
t504 = rho2_1.*t451;
t505 = rho2_2.*t451;
t506 = rho2_3.*t451;
t507 = rho3_1.*t452;
t508 = rho3_2.*t452;
t509 = rho3_3.*t452;
t510 = rho1_1.*t453;
t511 = rho1_2.*t453;
t512 = rho1_3.*t453;
t513 = rho2_1.*t454;
t514 = rho2_2.*t454;
t515 = rho2_3.*t454;
t516 = rho3_1.*t455;
t517 = rho3_2.*t455;
t518 = rho3_3.*t455;
t528 = t381.*t521;
t529 = t383.*t520;
t530 = t382.*t521;
t531 = t386.*t519;
t532 = t385.*t520;
t533 = t384.*t521;
t534 = t388.*t519;
t535 = t387.*t520;
t536 = t389.*t519;
t537 = t381.*t524;
t538 = t383.*t523;
t539 = t382.*t524;
t540 = t386.*t522;
t541 = t385.*t523;
t542 = t384.*t524;
t543 = t388.*t522;
t544 = t387.*t523;
t545 = t389.*t522;
t546 = t381.*t527;
t547 = t383.*t526;
t548 = t382.*t527;
t549 = t386.*t525;
t550 = t385.*t526;
t551 = t384.*t527;
t552 = t388.*t525;
t553 = t387.*t526;
t554 = t389.*t525;
t555 = t456+t458+t483;
t556 = t459+t461+t484;
t557 = t462+t464+t485;
t558 = t465+t467+t486;
t559 = t468+t470+t487;
t560 = t471+t473+t488;
t561 = t474+t476+t489;
t562 = t477+t479+t490;
t563 = t480+t482+t491;
t630 = t193.*t297.*t591;
t631 = t193.*t298.*t591;
t632 = t193.*t299.*t591;
t633 = t193.*t303.*t591;
t634 = t193.*t305.*t591;
t635 = t193.*t307.*t591;
t636 = t193.*t312.*t591;
t637 = t193.*t314.*t591;
t638 = t193.*t316.*t591;
t639 = t192.*t300.*t592;
t640 = t192.*t301.*t592;
t641 = t192.*t302.*t592;
t642 = t192.*t309.*t592;
t643 = t192.*t310.*t592;
t644 = t192.*t311.*t592;
t645 = t192.*t318.*t592;
t646 = t192.*t319.*t592;
t647 = t192.*t320.*t592;
t648 = t191.*t304.*t593;
t649 = t191.*t306.*t593;
t650 = t191.*t308.*t593;
t651 = t191.*t313.*t593;
t652 = t191.*t315.*t593;
t653 = t191.*t317.*t593;
t654 = t191.*t321.*t593;
t655 = t191.*t322.*t593;
t656 = t191.*t323.*t593;
t564 = qid2_1.*t555;
t565 = qid2_2.*t556;
t566 = qid3_1.*t555;
t567 = qid2_3.*t557;
t568 = qid3_2.*t556;
t569 = qid3_3.*t557;
t570 = qid1_1.*t558;
t571 = qid1_2.*t559;
t572 = qid1_3.*t560;
t573 = qid3_1.*t558;
t574 = qid3_2.*t559;
t575 = qid3_3.*t560;
t576 = qid1_1.*t561;
t577 = qid1_2.*t562;
t578 = qid2_1.*t561;
t579 = qid1_3.*t563;
t580 = qid2_2.*t562;
t581 = qid2_3.*t563;
t594 = t528+t529+t531;
t595 = t530+t532+t534;
t596 = t533+t535+t536;
t597 = t537+t538+t540;
t598 = t539+t541+t543;
t599 = t542+t544+t545;
t600 = t546+t547+t549;
t601 = t548+t550+t552;
t602 = t551+t553+t554;
t783 = t360+t492+t495+t498+t630+t639+t648;
t784 = t360+t493+t496+t499+t631+t640+t649;
t785 = t360+t494+t497+t500+t632+t641+t650;
t786 = t361+t501+t504+t507+t633+t642+t651;
t787 = t361+t502+t505+t508+t634+t643+t652;
t788 = t361+t503+t506+t509+t635+t644+t653;
t789 = t362+t510+t513+t516+t636+t645+t654;
t790 = t362+t511+t514+t517+t637+t646+t655;
t791 = t362+t512+t515+t518+t638+t647+t656;
t582 = -t570;
t583 = -t571;
t584 = -t572;
t585 = -t576;
t586 = -t577;
t587 = -t578;
t588 = -t579;
t589 = -t580;
t590 = -t581;
t603 = qid2_1.*t594;
t604 = qid2_2.*t595;
t605 = qid3_1.*t594;
t606 = qid2_3.*t596;
t607 = qid3_2.*t595;
t608 = qid3_3.*t596;
t609 = qid1_1.*t597;
t610 = qid1_2.*t598;
t611 = qid1_3.*t599;
t612 = qid3_1.*t597;
t613 = qid3_2.*t598;
t614 = qid3_3.*t599;
t615 = qid1_1.*t600;
t616 = qid1_2.*t601;
t617 = qid2_1.*t600;
t618 = qid1_3.*t602;
t619 = qid2_2.*t601;
t620 = qid2_3.*t602;
t621 = -t609;
t622 = -t610;
t623 = -t611;
t624 = -t615;
t625 = -t616;
t626 = -t617;
t627 = -t618;
t628 = -t619;
t629 = -t620;
t657 = t564+t582;
t658 = t565+t583;
t659 = t567+t584;
t660 = t566+t585;
t661 = t568+t586;
t662 = t569+t588;
t663 = t573+t587;
t664 = t574+t589;
t665 = t575+t590;
t666 = qi3_1.*t657;
t667 = qi3_2.*t658;
t668 = qi3_3.*t659;
t669 = qi2_1.*t660;
t670 = qi2_2.*t661;
t671 = qi2_3.*t662;
t672 = qi1_1.*t663;
t673 = qi1_2.*t664;
t674 = qi1_3.*t665;
t702 = t261.*t657;
t703 = t262.*t658;
t704 = t263.*t659;
t705 = t264.*t660;
t706 = t265.*t661;
t707 = t266.*t662;
t708 = t267.*t663;
t709 = t268.*t664;
t710 = t269.*t665;
t711 = t603+t621;
t712 = t604+t622;
t713 = t606+t623;
t714 = t605+t624;
t715 = t607+t625;
t716 = t608+t627;
t717 = t612+t626;
t718 = t613+t628;
t719 = t614+t629;
t675 = qi1_1.*t666;
t676 = qi2_1.*t666;
t677 = qi1_2.*t667;
t678 = qi2_2.*t667;
t679 = qi1_3.*t668;
t680 = qi2_3.*t668;
t681 = qi1_1.*t669;
t682 = qi3_1.*t669;
t683 = qi1_2.*t670;
t684 = qi3_2.*t670;
t685 = qi1_3.*t671;
t686 = qi3_3.*t671;
t687 = qi2_1.*t672;
t688 = qi3_1.*t672;
t689 = qi2_2.*t673;
t690 = qi3_2.*t673;
t691 = qi2_3.*t674;
t692 = qi3_3.*t674;
t693 = -t669;
t694 = -t670;
t695 = -t671;
t720 = qi1_1.*qi3_1.*t711;
t721 = qi2_1.*qi3_1.*t711;
t722 = qi1_2.*qi3_2.*t712;
t723 = qi2_2.*qi3_2.*t712;
t724 = qi1_3.*qi3_3.*t713;
t725 = qi2_3.*qi3_3.*t713;
t726 = qi1_1.*qi2_1.*t714;
t727 = qi2_1.*qi3_1.*t714;
t728 = qi1_2.*qi2_2.*t715;
t729 = qi2_2.*qi3_2.*t715;
t730 = qi1_3.*qi2_3.*t716;
t731 = qi2_3.*qi3_3.*t716;
t732 = qi1_1.*qi2_1.*t717;
t733 = qi1_1.*qi3_1.*t717;
t734 = qi1_2.*qi2_2.*t718;
t735 = qi1_2.*qi3_2.*t718;
t736 = qi1_3.*qi2_3.*t719;
t737 = qi1_3.*qi3_3.*t719;
t744 = t261.*t711;
t745 = t262.*t712;
t746 = t263.*t713;
t747 = t264.*t714;
t748 = t265.*t715;
t749 = t266.*t716;
t750 = t267.*t717;
t751 = t268.*t718;
t752 = t269.*t719;
t696 = -t675;
t697 = -t677;
t698 = -t679;
t699 = -t688;
t700 = -t690;
t701 = -t692;
t738 = -t720;
t739 = -t722;
t740 = -t724;
t741 = -t733;
t742 = -t735;
t743 = -t737;
t753 = t666+t672+t693;
t754 = t667+t673+t694;
t755 = t668+t674+t695;
t762 = t195+t676+t687+t705;
t763 = t196+t678+t689+t706;
t764 = t197+t680+t691+t707;
t756 = t681+t696+t708+wi1_1;
t757 = t682+t699+t702+wi3_1;
t758 = t683+t697+t709+wi1_2;
t759 = t684+t700+t703+wi3_2;
t760 = t685+t698+t710+wi1_3;
t761 = t686+t701+t704+wi3_3;
t765 = t372.*t753;
t766 = t375.*t753;
t767 = t378.*t753;
t768 = t373.*t754;
t769 = t376.*t754;
t770 = t379.*t754;
t771 = t374.*t755;
t772 = t377.*t755;
t773 = t380.*t755;
t780 = kwi.*t762;
t781 = kwi.*t763;
t782 = kwi.*t764;
t774 = kwi.*t756;
t775 = kwi.*t757;
t776 = kwi.*t758;
t777 = kwi.*t759;
t778 = kwi.*t760;
t779 = kwi.*t761;
mt1 = [muid1_1+mi1.*t146.*t783+mi1.*t267.*t783+li1.*mi1.*qi1_1.*t390-li1.*mi1.*qi2_1.*(-t429+t727+t741+t744+t765+t775)-li1.*mi1.*qi3_1.*(-t432+t721+t732+t747+t766+t780),muid2_1+mi1.*t149.*t786+mi1.*t264.*t786+li1.*mi1.*qi2_1.*t390+li1.*mi1.*qi1_1.*(-t429+t727+t741+t744+t765+t775)-li1.*mi1.*qi3_1.*(-t435+t726+t738+t750+t767+t774),muid3_1+mi1.*t152.*t789+mi1.*t261.*t789+li1.*mi1.*qi3_1.*t390+li1.*mi1.*qi1_1.*(-t432+t721+t732+t747+t766+t780)+li1.*mi1.*qi2_1.*(-t435+t726+t738+t750+t767+t774),muid1_2+mi2.*t147.*t784+mi2.*t268.*t784+li2.*mi2.*qi1_2.*t391-li2.*mi2.*qi2_2.*(-t430+t729+t742+t745+t768+t777)-li2.*mi2.*qi3_2.*(-t433+t723+t734+t748+t769+t781)];
mt2 = [muid2_2+mi2.*t150.*t787+mi2.*t265.*t787+li2.*mi2.*qi2_2.*t391+li2.*mi2.*qi1_2.*(-t430+t729+t742+t745+t768+t777)-li2.*mi2.*qi3_2.*(-t436+t728+t739+t751+t770+t776),muid3_2+mi2.*t153.*t790+mi2.*t262.*t790+li2.*mi2.*qi3_2.*t391+li2.*mi2.*qi1_2.*(-t433+t723+t734+t748+t769+t781)+li2.*mi2.*qi2_2.*(-t436+t728+t739+t751+t770+t776),muid1_3+mi3.*t148.*t785+mi3.*t269.*t785+li3.*mi3.*qi1_3.*t392-li3.*mi3.*qi2_3.*(-t431+t731+t743+t746+t771+t779)-li3.*mi3.*qi3_3.*(-t434+t725+t736+t749+t772+t782),muid2_3+mi3.*t151.*t788+mi3.*t266.*t788+li3.*mi3.*qi2_3.*t392+li3.*mi3.*qi1_3.*(-t431+t731+t743+t746+t771+t779)-li3.*mi3.*qi3_3.*(-t437+t730+t740+t752+t773+t778)];
mt3 = [muid3_3+mi3.*t154.*t791+mi3.*t263.*t791+li3.*mi3.*qi3_3.*t392+li3.*mi3.*qi1_3.*(-t434+t725+t736+t749+t772+t782)+li3.*mi3.*qi2_3.*(-t437+t730+t740+t752+t773+t778)];
ui = reshape([mt1,mt2,mt3],3,3);
end
