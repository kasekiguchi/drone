function out1 = CSLC_5_ui(in1,in2,in3,in4,in5,in6,in7,in8,in9)
%CSLC_5_ui
%    OUT1 = CSLC_5_ui(IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,IN9)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/07/03 10:16:12

Gains5 = in6(5,:);
Gains6 = in6(6,:);
R01_1 = in3(1);
R01_2 = in3(2);
R01_3 = in3(3);
R02_1 = in3(4);
R02_2 = in3(5);
R02_3 = in3(6);
R03_1 = in3(7);
R03_2 = in3(8);
R03_3 = in3(9);
R0d1_1 = in4(1);
R0d1_2 = in4(2);
R0d1_3 = in4(3);
R0d2_1 = in4(4);
R0d2_2 = in4(5);
R0d2_3 = in4(6);
R0d3_1 = in4(7);
R0d3_2 = in4(8);
R0d3_3 = in4(9);
X7 = in1(7,:);
X8 = in1(8,:);
X9 = in1(9,:);
X10 = in1(10,:);
X11 = in1(11,:);
X12 = in1(12,:);
X13 = in1(13,:);
X14 = in1(14,:);
X15 = in1(15,:);
X16 = in1(16,:);
X17 = in1(17,:);
X18 = in1(18,:);
X19 = in1(19,:);
X20 = in1(20,:);
X21 = in1(21,:);
X22 = in1(22,:);
X23 = in1(23,:);
X24 = in1(24,:);
X25 = in1(25,:);
X26 = in1(26,:);
X27 = in1(27,:);
X28 = in1(28,:);
X29 = in1(29,:);
X30 = in1(30,:);
X31 = in1(31,:);
X32 = in1(32,:);
X33 = in1(33,:);
X34 = in1(34,:);
X35 = in1(35,:);
X36 = in1(36,:);
X37 = in1(37,:);
X38 = in1(38,:);
X39 = in1(39,:);
Xd13 = in2(13,:);
Xd14 = in2(14,:);
Xd15 = in2(15,:);
j01 = in5(:,3);
j02 = in5(:,4);
j03 = in5(:,5);
li1 = in5(:,21);
li2 = in5(:,22);
li3 = in5(:,23);
li4 = in5(:,24);
li5 = in5(:,25);
m0 = in5(:,2);
mi1 = in5(:,26);
mi2 = in5(:,27);
mi3 = in5(:,28);
mi4 = in5(:,29);
mi5 = in5(:,30);
mui1_1 = in8(1);
mui1_2 = in8(4);
mui1_3 = in8(7);
mui1_4 = in8(10);
mui1_5 = in8(13);
mui2_1 = in8(2);
mui2_2 = in8(5);
mui2_3 = in8(8);
mui2_4 = in8(11);
mui2_5 = in8(14);
mui3_1 = in8(3);
mui3_2 = in8(6);
mui3_3 = in8(9);
mui3_4 = in8(12);
mui3_5 = in8(15);
qid1_1 = in9(1);
qid1_2 = in9(4);
qid1_3 = in9(7);
qid1_4 = in9(10);
qid1_5 = in9(13);
qid2_1 = in9(2);
qid2_2 = in9(5);
qid2_3 = in9(8);
qid2_4 = in9(11);
qid2_5 = in9(14);
qid3_1 = in9(3);
qid3_2 = in9(6);
qid3_3 = in9(9);
qid3_4 = in9(12);
qid3_5 = in9(15);
rho1_1 = in5(:,6);
rho1_2 = in5(:,7);
rho1_3 = in5(:,8);
rho2_1 = in5(:,9);
rho2_2 = in5(:,10);
rho2_3 = in5(:,11);
rho3_1 = in5(:,12);
rho3_2 = in5(:,13);
rho3_3 = in5(:,14);
rho4_1 = in5(:,15);
rho4_2 = in5(:,16);
rho4_3 = in5(:,17);
rho5_1 = in5(:,18);
rho5_2 = in5(:,19);
rho5_3 = in5(:,20);
t2 = R0d1_1.*Xd14;
t3 = R0d1_1.*Xd15;
t4 = R0d1_2.*Xd14;
t5 = R0d1_2.*Xd15;
t6 = R0d1_3.*Xd14;
t7 = R0d1_3.*Xd15;
t8 = R0d2_1.*Xd13;
t9 = R0d2_2.*Xd13;
t10 = R0d2_1.*Xd15;
t11 = R0d2_3.*Xd13;
t12 = R0d2_2.*Xd15;
t13 = R0d2_3.*Xd15;
t14 = R0d3_1.*Xd13;
t15 = R0d3_1.*Xd14;
t16 = R0d3_2.*Xd13;
t17 = R0d3_2.*Xd14;
t18 = R0d3_3.*Xd13;
t19 = R0d3_3.*Xd14;
t20 = X10.*X25;
t21 = X11.*X26;
t22 = X12.*X27;
t23 = X13.*X28;
t24 = X14.*X29;
t25 = X15.*X30;
t26 = X16.*X31;
t27 = X17.*X32;
t28 = X18.*X33;
t29 = X19.*X34;
t30 = X20.*X35;
t31 = X21.*X36;
t32 = X22.*X37;
t33 = X23.*X38;
t34 = X24.*X39;
t35 = R0d1_1.*qid1_1;
t36 = R0d1_1.*qid1_2;
t37 = R0d1_1.*qid1_3;
t38 = R0d1_1.*qid1_4;
t39 = R0d1_1.*qid1_5;
t40 = R0d2_1.*qid1_1;
t41 = R0d1_2.*qid2_1;
t42 = R0d2_1.*qid1_2;
t43 = R0d1_2.*qid2_2;
t44 = R0d2_1.*qid1_3;
t45 = R0d1_2.*qid2_3;
t46 = R0d2_1.*qid1_4;
t47 = R0d1_2.*qid2_4;
t48 = R0d2_1.*qid1_5;
t49 = R0d1_2.*qid2_5;
t50 = R0d3_1.*qid1_1;
t51 = R0d2_2.*qid2_1;
t52 = R0d3_1.*qid1_2;
t53 = R0d1_3.*qid3_1;
t54 = R0d2_2.*qid2_2;
t55 = R0d3_1.*qid1_3;
t56 = R0d1_3.*qid3_2;
t57 = R0d2_2.*qid2_3;
t58 = R0d3_1.*qid1_4;
t59 = R0d1_3.*qid3_3;
t60 = R0d2_2.*qid2_4;
t61 = R0d3_1.*qid1_5;
t62 = R0d1_3.*qid3_4;
t63 = R0d2_2.*qid2_5;
t64 = R0d1_3.*qid3_5;
t65 = R0d3_2.*qid2_1;
t66 = R0d2_3.*qid3_1;
t67 = R0d3_2.*qid2_2;
t68 = R0d2_3.*qid3_2;
t69 = R0d3_2.*qid2_3;
t70 = R0d2_3.*qid3_3;
t71 = R0d3_2.*qid2_4;
t72 = R0d2_3.*qid3_4;
t73 = R0d3_2.*qid2_5;
t74 = R0d2_3.*qid3_5;
t75 = R0d3_3.*qid3_1;
t76 = R0d3_3.*qid3_2;
t77 = R0d3_3.*qid3_3;
t78 = R0d3_3.*qid3_4;
t79 = R0d3_3.*qid3_5;
t80 = R01_1.*rho1_2;
t81 = R01_1.*rho1_3;
t82 = R01_2.*rho1_2;
t83 = R01_2.*rho1_3;
t84 = R01_3.*rho1_2;
t85 = R01_3.*rho1_3;
t86 = R02_1.*rho1_1;
t87 = R01_1.*rho2_2;
t88 = R02_2.*rho1_1;
t89 = R01_1.*rho2_3;
t90 = R01_2.*rho2_2;
t91 = R02_1.*rho1_3;
t92 = R02_3.*rho1_1;
t93 = R01_2.*rho2_3;
t94 = R01_3.*rho2_2;
t95 = R02_2.*rho1_3;
t96 = R01_3.*rho2_3;
t97 = R02_3.*rho1_3;
t98 = R02_1.*rho2_1;
t99 = R03_1.*rho1_1;
t100 = R01_1.*rho3_2;
t101 = R02_2.*rho2_1;
t102 = R03_1.*rho1_2;
t103 = R03_2.*rho1_1;
t104 = R01_1.*rho3_3;
t105 = R01_2.*rho3_2;
t106 = R02_1.*rho2_3;
t107 = R02_3.*rho2_1;
t108 = R03_2.*rho1_2;
t109 = R03_3.*rho1_1;
t110 = R01_2.*rho3_3;
t111 = R01_3.*rho3_2;
t112 = R02_2.*rho2_3;
t113 = R03_3.*rho1_2;
t114 = R01_3.*rho3_3;
t115 = R02_3.*rho2_3;
t116 = R02_1.*rho3_1;
t117 = R03_1.*rho2_1;
t118 = R01_1.*rho4_2;
t119 = R02_2.*rho3_1;
t120 = R03_1.*rho2_2;
t121 = R03_2.*rho2_1;
t122 = R01_1.*rho4_3;
t123 = R01_2.*rho4_2;
t124 = R02_1.*rho3_3;
t125 = R02_3.*rho3_1;
t126 = R03_2.*rho2_2;
t127 = R03_3.*rho2_1;
t128 = R01_2.*rho4_3;
t129 = R01_3.*rho4_2;
t130 = R02_2.*rho3_3;
t131 = R03_3.*rho2_2;
t132 = R01_3.*rho4_3;
t133 = R02_3.*rho3_3;
t134 = R02_1.*rho4_1;
t135 = R03_1.*rho3_1;
t136 = R01_1.*rho5_2;
t137 = R02_2.*rho4_1;
t138 = R03_1.*rho3_2;
t139 = R03_2.*rho3_1;
t140 = R01_1.*rho5_3;
t141 = R01_2.*rho5_2;
t142 = R02_1.*rho4_3;
t143 = R02_3.*rho4_1;
t144 = R03_2.*rho3_2;
t145 = R03_3.*rho3_1;
t146 = R01_2.*rho5_3;
t147 = R01_3.*rho5_2;
t148 = R02_2.*rho4_3;
t149 = R03_3.*rho3_2;
t150 = R01_3.*rho5_3;
t151 = R02_3.*rho4_3;
t152 = R02_1.*rho5_1;
t153 = R03_1.*rho4_1;
t154 = R02_2.*rho5_1;
t155 = R03_1.*rho4_2;
t156 = R03_2.*rho4_1;
t157 = R02_1.*rho5_3;
t158 = R02_3.*rho5_1;
t159 = R03_2.*rho4_2;
t160 = R03_3.*rho4_1;
t161 = R02_2.*rho5_3;
t162 = R03_3.*rho4_2;
t163 = R02_3.*rho5_3;
t164 = R03_1.*rho5_1;
t165 = R03_1.*rho5_2;
t166 = R03_2.*rho5_1;
t167 = R03_2.*rho5_2;
t168 = R03_3.*rho5_1;
t169 = R03_3.*rho5_2;
t170 = X10.*qid1_1;
t171 = X13.*qid1_2;
t172 = X16.*qid1_3;
t173 = X11.*qid2_1;
t174 = X19.*qid1_4;
t175 = X14.*qid2_2;
t176 = X22.*qid1_5;
t177 = X17.*qid2_3;
t178 = X12.*qid3_1;
t179 = X20.*qid2_4;
t180 = X15.*qid3_2;
t181 = X23.*qid2_5;
t182 = X18.*qid3_3;
t183 = X21.*qid3_4;
t184 = X24.*qid3_5;
t185 = X7.^2;
t186 = X8.^2;
t187 = X9.^2;
t188 = X25.^2;
t189 = X26.^2;
t190 = X27.^2;
t191 = X28.^2;
t192 = X29.^2;
t193 = X30.^2;
t194 = X31.^2;
t195 = X32.^2;
t196 = X33.^2;
t197 = X34.^2;
t198 = X35.^2;
t199 = X36.^2;
t200 = X37.^2;
t201 = X38.^2;
t202 = X39.^2;
t203 = R01_1.*X7.*X8;
t204 = R01_1.*X7.*X9;
t205 = R01_2.*X7.*X8;
t206 = R01_2.*X7.*X9;
t207 = R01_3.*X7.*X8;
t208 = R01_3.*X7.*X9;
t209 = R02_1.*X7.*X8;
t210 = R02_2.*X7.*X8;
t211 = R02_1.*X8.*X9;
t212 = R02_3.*X7.*X8;
t213 = R02_2.*X8.*X9;
t214 = R02_3.*X8.*X9;
t215 = R03_1.*X7.*X9;
t216 = R03_1.*X8.*X9;
t217 = R03_2.*X7.*X9;
t218 = R03_2.*X8.*X9;
t219 = R03_3.*X7.*X9;
t220 = R03_3.*X8.*X9;
t221 = X7.*X8.*j01;
t222 = X7.*X8.*j02;
t223 = X7.*X9.*j01;
t224 = X7.*X9.*j03;
t225 = X8.*X9.*j02;
t226 = X8.*X9.*j03;
t227 = 1.0./j01;
t228 = 1.0./j02;
t229 = 1.0./j03;
t230 = 1.0./m0;
t293 = mui1_1+mui1_2+mui1_3+mui1_4+mui1_5;
t294 = mui2_1+mui2_2+mui2_3+mui2_4+mui2_5;
t295 = mui3_1+mui3_2+mui3_3+mui3_4+mui3_5;
t231 = -t15;
t232 = -t17;
t233 = -t19;
t234 = -t86;
t235 = -t88;
t236 = -t92;
t237 = -t98;
t238 = -t99;
t239 = -t101;
t240 = -t102;
t241 = -t103;
t242 = -t107;
t243 = -t108;
t244 = -t109;
t245 = -t113;
t246 = -t116;
t247 = -t117;
t248 = -t119;
t249 = -t120;
t250 = -t121;
t251 = -t125;
t252 = -t126;
t253 = -t127;
t254 = -t131;
t255 = -t134;
t256 = -t135;
t257 = -t137;
t258 = -t138;
t259 = -t139;
t260 = -t143;
t261 = -t144;
t262 = -t145;
t263 = -t149;
t264 = -t152;
t265 = -t153;
t266 = -t154;
t267 = -t155;
t268 = -t156;
t269 = -t158;
t270 = -t159;
t271 = -t160;
t272 = -t162;
t273 = -t164;
t274 = -t165;
t275 = -t166;
t276 = -t167;
t277 = -t168;
t278 = -t169;
t279 = -t170;
t280 = -t171;
t281 = -t172;
t282 = -t174;
t283 = -t176;
t284 = -t211;
t285 = -t213;
t286 = -t214;
t287 = -t216;
t288 = -t218;
t289 = -t220;
t290 = -t222;
t291 = -t224;
t292 = -t225;
t296 = t2+t8;
t297 = t4+t9;
t298 = t6+t11;
t299 = t3+t14;
t300 = t5+t16;
t301 = t7+t18;
t302 = t185+t186;
t303 = t185+t187;
t304 = t186+t187;
t362 = t188+t189+t190;
t363 = t191+t192+t193;
t364 = t194+t195+t196;
t365 = t197+t198+t199;
t366 = t200+t201+t202;
t367 = t20+t21+t22;
t368 = t23+t24+t25;
t369 = t26+t27+t28;
t370 = t29+t30+t31;
t371 = t32+t33+t34;
t372 = t35+t41+t53;
t373 = t36+t43+t56;
t374 = t37+t45+t59;
t375 = t38+t47+t62;
t376 = t39+t49+t64;
t377 = t40+t51+t66;
t378 = t42+t54+t68;
t379 = t44+t57+t70;
t380 = t46+t60+t72;
t381 = t48+t63+t74;
t382 = t50+t65+t75;
t383 = t52+t67+t76;
t384 = t55+t69+t77;
t385 = t58+t71+t78;
t386 = t61+t73+t79;
t432 = t230.*t293;
t433 = t230.*t294;
t434 = t230.*t295;
t305 = t10+t231;
t306 = t12+t232;
t307 = t13+t233;
t308 = R01_1.*t304;
t309 = R01_2.*t304;
t310 = R01_3.*t304;
t311 = R02_1.*t303;
t312 = R02_2.*t303;
t313 = R02_3.*t303;
t314 = R03_1.*t302;
t315 = R03_2.*t302;
t316 = R03_3.*t302;
t317 = t80+t234;
t318 = t82+t235;
t319 = t84+t236;
t320 = t81+t238;
t321 = t83+t241;
t322 = t85+t244;
t323 = t87+t237;
t324 = t90+t239;
t325 = t91+t240;
t326 = t94+t242;
t327 = t95+t243;
t328 = t97+t245;
t329 = t89+t247;
t330 = t93+t250;
t331 = t96+t253;
t332 = t100+t246;
t333 = t105+t248;
t334 = t106+t249;
t335 = t111+t251;
t336 = t112+t252;
t337 = t115+t254;
t338 = t104+t256;
t339 = t110+t259;
t340 = t114+t262;
t341 = t118+t255;
t342 = t123+t257;
t343 = t124+t258;
t344 = t129+t260;
t345 = t130+t261;
t346 = t133+t263;
t347 = t122+t265;
t348 = t128+t268;
t349 = t132+t271;
t350 = t136+t264;
t351 = t141+t266;
t352 = t142+t267;
t353 = t147+t269;
t354 = t148+t270;
t355 = t151+t272;
t356 = t140+t273;
t357 = t146+t275;
t358 = t150+t277;
out1 = ft_1({Gains5,Gains6,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22,X23,X24,X25,X26,X27,X28,X29,X30,X31,X32,X33,X34,X35,X36,X37,X38,X39,li1,li2,li3,li4,li5,mi1,mi2,mi3,mi4,mi5,mui1_1,mui1_2,mui1_3,mui1_4,mui1_5,mui2_1,mui2_2,mui2_3,mui2_4,mui2_5,mui3_1,mui3_2,mui3_3,mui3_4,mui3_5,qid1_1,qid1_2,qid1_3,qid1_4,qid1_5,qid2_1,qid2_2,qid2_3,qid2_4,qid2_5,qid3_1,qid3_2,qid3_3,qid3_4,qid3_5,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,rho4_1,rho4_2,rho4_3,rho5_1,rho5_2,rho5_3,t157,t161,t163,t173,t175,t177,t178,t179,t180,t181,t182,t183,t184,t203,t204,t205,t206,t207,t208,t209,t210,t212,t215,t217,t219,t221,t223,t226,t227,t228,t229,t274,t276,t278,t279,t280,t281,t282,t283,t284,t285,t286,t287,t288,t289,t290,t291,t292,t296,t297,t298,t299,t300,t301,t305,t306,t307,t308,t309,t310,t311,t312,t313,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t325,t326,t327,t328,t329,t330,t331,t332,t333,t334,t335,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t362,t363,t364,t365,t366,t367,t368,t369,t370,t371,t372,t373,t374,t375,t376,t377,t378,t379,t380,t381,t382,t383,t384,t385,t386,t432,t433,t434});
end
function out1 = ft_1(ct)
[Gains5,Gains6,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22,X23,X24,X25,X26,X27,X28,X29,X30,X31,X32,X33,X34,X35,X36,X37,X38,X39,li1,li2,li3,li4,li5,mi1,mi2,mi3,mi4,mi5,mui1_1,mui1_2,mui1_3,mui1_4,mui1_5,mui2_1,mui2_2,mui2_3,mui2_4,mui2_5,mui3_1,mui3_2,mui3_3,mui3_4,mui3_5,qid1_1,qid1_2,qid1_3,qid1_4,qid1_5,qid2_1,qid2_2,qid2_3,qid2_4,qid2_5,qid3_1,qid3_2,qid3_3,qid3_4,qid3_5,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,rho4_1,rho4_2,rho4_3,rho5_1,rho5_2,rho5_3,t157,t161,t163,t173,t175,t177,t178,t179,t180,t181,t182,t183,t184,t203,t204,t205,t206,t207,t208,t209,t210,t212,t215,t217,t219,t221,t223,t226,t227,t228,t229,t274,t276,t278,t279,t280,t281,t282,t283,t284,t285,t286,t287,t288,t289,t290,t291,t292,t296,t297,t298,t299,t300,t301,t305,t306,t307,t308,t309,t310,t311,t312,t313,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t325,t326,t327,t328,t329,t330,t331,t332,t333,t334,t335,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t362,t363,t364,t365,t366,t367,t368,t369,t370,t371,t372,t373,t374,t375,t376,t377,t378,t379,t380,t381,t382,t383,t384,t385,t386,t432,t433,t434] = ct{:};
t359 = t157+t274;
t360 = t161+t276;
t361 = t163+t278;
t435 = t173+t178+t279;
t436 = t175+t180+t280;
t437 = t177+t182+t281;
t438 = t179+t183+t282;
t439 = t181+t184+t283;
t440 = t299.*t377;
t441 = t300.*t377;
t442 = t299.*t378;
t443 = t301.*t377;
t444 = t300.*t378;
t445 = t299.*t379;
t446 = t301.*t378;
t447 = t300.*t379;
t448 = t299.*t380;
t449 = t301.*t379;
t450 = t300.*t380;
t451 = t299.*t381;
t452 = t301.*t380;
t453 = t300.*t381;
t454 = t301.*t381;
t455 = t296.*t382;
t456 = t297.*t382;
t457 = t296.*t383;
t458 = t298.*t382;
t459 = t297.*t383;
t460 = t296.*t384;
t461 = t298.*t383;
t462 = t297.*t384;
t463 = t296.*t385;
t464 = t298.*t384;
t465 = t297.*t385;
t466 = t296.*t386;
t467 = t298.*t385;
t468 = t297.*t386;
t469 = t298.*t386;
t387 = mui1_1.*t317;
t388 = mui1_1.*t320;
t389 = mui2_1.*t318;
t390 = mui1_2.*t323;
t391 = mui1_1.*t325;
t392 = mui2_1.*t321;
t393 = mui3_1.*t319;
t394 = mui1_2.*t329;
t395 = mui2_2.*t324;
t396 = mui2_1.*t327;
t397 = mui3_1.*t322;
t398 = mui1_3.*t332;
t399 = mui1_2.*t334;
t400 = mui2_2.*t330;
t401 = mui3_2.*t326;
t402 = mui3_1.*t328;
t403 = mui1_3.*t338;
t404 = mui2_3.*t333;
t405 = mui2_2.*t336;
t406 = mui3_2.*t331;
t407 = mui1_4.*t341;
t408 = mui1_3.*t343;
t409 = mui2_3.*t339;
t410 = mui3_3.*t335;
t411 = mui3_2.*t337;
t412 = mui1_4.*t347;
t413 = mui2_4.*t342;
t414 = mui2_3.*t345;
t415 = mui3_3.*t340;
t416 = mui1_5.*t350;
t417 = mui1_4.*t352;
t418 = mui2_4.*t348;
t419 = mui3_4.*t344;
t420 = mui3_3.*t346;
t421 = mui1_5.*t356;
t422 = mui2_5.*t351;
t423 = mui2_4.*t354;
t424 = mui3_4.*t349;
t425 = mui1_5.*t359;
t426 = mui2_5.*t357;
t427 = mui3_5.*t353;
t428 = mui3_4.*t355;
t429 = mui2_5.*t360;
t430 = mui3_5.*t358;
t431 = mui3_5.*t361;
t470 = t209+t215+t308;
t471 = t210+t217+t309;
t472 = t212+t219+t310;
t473 = t305.*t372;
t474 = t306.*t372;
t475 = t305.*t373;
t476 = t307.*t372;
t477 = t306.*t373;
t478 = t305.*t374;
t479 = t307.*t373;
t480 = t306.*t374;
t481 = t305.*t375;
t482 = t307.*t374;
t483 = t306.*t375;
t484 = t305.*t376;
t485 = t307.*t375;
t486 = t306.*t376;
t487 = t307.*t376;
t488 = -t440;
t489 = -t441;
t490 = -t442;
t491 = -t443;
t492 = -t444;
t493 = -t445;
t494 = -t446;
t495 = -t447;
t496 = -t448;
t497 = -t449;
t498 = -t450;
t499 = -t451;
t500 = -t452;
t501 = -t453;
t502 = -t454;
t503 = t203+t287+t311;
t504 = t204+t284+t314;
t505 = t205+t288+t312;
t506 = t206+t285+t315;
t507 = t207+t289+t313;
t508 = t208+t286+t316;
t509 = t455+t473+t488;
t510 = t456+t474+t489;
t511 = t457+t475+t490;
t512 = t458+t476+t491;
t513 = t459+t477+t492;
t514 = t460+t478+t493;
t515 = t461+t479+t494;
t516 = t462+t480+t495;
t517 = t463+t481+t496;
t518 = t464+t482+t497;
t519 = t465+t483+t498;
t520 = t466+t484+t499;
t521 = t467+t485+t500;
t522 = t468+t486+t501;
t523 = t469+t487+t502;
t624 = t221+t290+t387+t389+t390+t393+t395+t398+t401+t404+t407+t410+t413+t416+t419+t422+t427;
t625 = t223+t291+t388+t392+t394+t397+t400+t403+t406+t409+t412+t415+t418+t421+t424+t426+t430;
t626 = t226+t292+t391+t396+t399+t402+t405+t408+t411+t414+t417+t420+t423+t425+t428+t429+t431;
t524 = qid1_1.*t510;
t525 = qid2_1.*t509;
t526 = qid1_1.*t512;
t527 = qid1_2.*t513;
t528 = qid2_2.*t511;
t529 = qid3_1.*t509;
t530 = qid1_2.*t515;
t531 = qid2_1.*t512;
t532 = qid1_3.*t516;
t533 = qid3_1.*t510;
t534 = qid2_3.*t514;
t535 = qid3_2.*t511;
t536 = qid1_3.*t518;
t537 = qid2_2.*t515;
t538 = qid1_4.*t519;
t539 = qid3_2.*t513;
t540 = qid2_4.*t517;
t541 = qid3_3.*t514;
t542 = qid1_4.*t521;
t543 = qid2_3.*t518;
t544 = qid1_5.*t522;
t545 = qid3_3.*t516;
t546 = qid2_5.*t520;
t547 = qid3_4.*t517;
t548 = qid1_5.*t523;
t549 = qid2_4.*t521;
t550 = qid3_4.*t519;
t551 = qid3_5.*t520;
t552 = qid2_5.*t523;
t553 = qid3_5.*t522;
t554 = -t524;
t555 = -t525;
t556 = -t527;
t557 = -t528;
t558 = -t529;
t559 = -t532;
t560 = -t533;
t561 = -t534;
t562 = -t535;
t563 = -t538;
t564 = -t539;
t565 = -t540;
t566 = -t541;
t567 = -t544;
t568 = -t545;
t569 = -t546;
t570 = -t547;
t571 = -t550;
t572 = -t551;
t573 = -t553;
t574 = t524+t555;
t575 = t526+t558;
t576 = t527+t557;
t577 = t531+t560;
t578 = t530+t562;
t579 = t532+t561;
t580 = t537+t564;
t581 = t536+t566;
t582 = t538+t565;
t583 = t543+t568;
t584 = t542+t570;
t585 = t544+t569;
t586 = t549+t571;
t587 = t548+t572;
t588 = t552+t573;
t589 = X27+t525+t554;
t591 = X30+t528+t556;
t594 = X33+t534+t559;
t597 = X36+t540+t563;
t600 = X39+t546+t567;
t590 = X26+t575;
t592 = X25+t577;
t593 = X29+t578;
t595 = X28+t580;
t596 = X32+t581;
t598 = X31+t583;
t599 = X35+t584;
t601 = X34+t586;
t602 = X38+t587;
t603 = X37+t588;
t604 = X12.*t574;
t605 = X11.*t575;
t606 = X15.*t576;
t607 = X10.*t577;
t608 = X14.*t578;
t609 = X18.*t579;
t610 = X13.*t580;
t611 = X17.*t581;
t612 = X21.*t582;
t613 = X16.*t583;
t614 = X20.*t584;
t615 = X24.*t585;
t616 = X19.*t586;
t617 = X23.*t587;
t618 = X22.*t588;
t619 = -t604;
t620 = -t606;
t621 = -t609;
t622 = -t612;
t623 = -t615;
t627 = t605+t607+t619;
t628 = t608+t610+t620;
t629 = t611+t613+t621;
t630 = t614+t616+t622;
t631 = t617+t618+t623;
mt1 = [mui1_1+mi1.*(t432-rho1_1.*t470-rho1_2.*t503-rho1_3.*t504+t229.*t317.*t624+t228.*t320.*t625+t227.*t325.*t626)+li1.*mi1.*(X10.*t362+X11.*t574+X12.*t575-Gains6.*(X11.*t589-X12.*t590)-Gains5.*(qid1_1+X10.*t435)+t627.*(X25-X10.*t367)),mui2_1+mi1.*(t433-rho1_1.*t471-rho1_2.*t505-rho1_3.*t506+t229.*t318.*t624+t228.*t321.*t625+t227.*t327.*t626)-li1.*mi1.*(X11.*t362-X10.*t574-X12.*t577+Gains6.*(X10.*t589-X12.*t592)+Gains5.*(qid2_1-X11.*t435)+t627.*(X26-X11.*t367))];
mt2 = [mui3_1+mi1.*(t434-rho1_1.*t472-rho1_2.*t507-rho1_3.*t508+t229.*t319.*t624+t228.*t322.*t625+t227.*t328.*t626)-li1.*mi1.*(X12.*t362-X10.*t575+X11.*t577-Gains6.*(X10.*t590-X11.*t592)+Gains5.*(qid3_1-X12.*t435)+t627.*(X27-X12.*t367)),mui1_2+mi2.*(t432-rho2_1.*t470-rho2_2.*t503-rho2_3.*t504+t229.*t323.*t624+t228.*t329.*t625+t227.*t334.*t626)+li2.*mi2.*(X13.*t363+X14.*t576+X15.*t578-Gains6.*(X14.*t591-X15.*t593)-Gains5.*(qid1_2+X13.*t436)+t628.*(X28-X13.*t368))];
mt3 = [mui2_2+mi2.*(t433-rho2_1.*t471-rho2_2.*t505-rho2_3.*t506+t229.*t324.*t624+t228.*t330.*t625+t227.*t336.*t626)-li2.*mi2.*(X14.*t363-X13.*t576-X15.*t580+Gains6.*(X13.*t591-X15.*t595)+Gains5.*(qid2_2-X14.*t436)+t628.*(X29-X14.*t368)),mui3_2+mi2.*(t434-rho2_1.*t472-rho2_2.*t507-rho2_3.*t508+t229.*t326.*t624+t228.*t331.*t625+t227.*t337.*t626)-li2.*mi2.*(X15.*t363-X13.*t578+X14.*t580-Gains6.*(X13.*t593-X14.*t595)+Gains5.*(qid3_2-X15.*t436)+t628.*(X30-X15.*t368))];
mt4 = [mui1_3+mi3.*(t432-rho3_1.*t470-rho3_2.*t503-rho3_3.*t504+t229.*t332.*t624+t228.*t338.*t625+t227.*t343.*t626)+li3.*mi3.*(X16.*t364+X17.*t579+X18.*t581-Gains6.*(X17.*t594-X18.*t596)-Gains5.*(qid1_3+X16.*t437)+t629.*(X31-X16.*t369)),mui2_3+mi3.*(t433-rho3_1.*t471-rho3_2.*t505-rho3_3.*t506+t229.*t333.*t624+t228.*t339.*t625+t227.*t345.*t626)-li3.*mi3.*(X17.*t364-X16.*t579-X18.*t583+Gains6.*(X16.*t594-X18.*t598)+Gains5.*(qid2_3-X17.*t437)+t629.*(X32-X17.*t369))];
mt5 = [mui3_3+mi3.*(t434-rho3_1.*t472-rho3_2.*t507-rho3_3.*t508+t229.*t335.*t624+t228.*t340.*t625+t227.*t346.*t626)-li3.*mi3.*(X18.*t364-X16.*t581+X17.*t583-Gains6.*(X16.*t596-X17.*t598)+Gains5.*(qid3_3-X18.*t437)+t629.*(X33-X18.*t369)),mui1_4+mi4.*(t432-rho4_1.*t470-rho4_2.*t503-rho4_3.*t504+t229.*t341.*t624+t228.*t347.*t625+t227.*t352.*t626)+li4.*mi4.*(X19.*t365+X20.*t582+X21.*t584-Gains6.*(X20.*t597-X21.*t599)-Gains5.*(qid1_4+X19.*t438)+t630.*(X34-X19.*t370))];
mt6 = [mui2_4+mi4.*(t433-rho4_1.*t471-rho4_2.*t505-rho4_3.*t506+t229.*t342.*t624+t228.*t348.*t625+t227.*t354.*t626)-li4.*mi4.*(X20.*t365-X19.*t582-X21.*t586+Gains6.*(X19.*t597-X21.*t601)+Gains5.*(qid2_4-X20.*t438)+t630.*(X35-X20.*t370)),mui3_4+mi4.*(t434-rho4_1.*t472-rho4_2.*t507-rho4_3.*t508+t229.*t344.*t624+t228.*t349.*t625+t227.*t355.*t626)-li4.*mi4.*(X21.*t365-X19.*t584+X20.*t586-Gains6.*(X19.*t599-X20.*t601)+Gains5.*(qid3_4-X21.*t438)+t630.*(X36-X21.*t370))];
mt7 = [mui1_5+mi5.*(t432-rho5_1.*t470-rho5_2.*t503-rho5_3.*t504+t229.*t350.*t624+t228.*t356.*t625+t227.*t359.*t626)+li5.*mi5.*(X22.*t366+X23.*t585+X24.*t587-Gains6.*(X23.*t600-X24.*t602)-Gains5.*(qid1_5+X22.*t439)+t631.*(X37-X22.*t371)),mui2_5+mi5.*(t433-rho5_1.*t471-rho5_2.*t505-rho5_3.*t506+t229.*t351.*t624+t228.*t357.*t625+t227.*t360.*t626)-li5.*mi5.*(X23.*t366-X22.*t585-X24.*t588+Gains6.*(X22.*t600-X24.*t603)+Gains5.*(qid2_5-X23.*t439)+t631.*(X38-X23.*t371))];
mt8 = [mui3_5+mi5.*(t434-rho5_1.*t472-rho5_2.*t507-rho5_3.*t508+t229.*t353.*t624+t228.*t358.*t625+t227.*t361.*t626)-li5.*mi5.*(X24.*t366-X22.*t587+X23.*t588-Gains6.*(X22.*t602-X23.*t603)+Gains5.*(qid3_5-X24.*t439)+t631.*(X39-X24.*t371))];
out1 = reshape([mt1,mt2,mt3,mt4,mt5,mt6,mt7,mt8],3,5);
end
