function dX = zup_eul_ddx0do0_3(in1,in2,in3,in4,in5,in6)
%ZUP_EUL_DDX0DO0_3
%    dX = ZUP_EUL_DDX0DO0_3(IN1,IN2,IN3,IN4,IN5,IN6)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/07/03 13:32:16

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
Ri2_3_1 = in3(8);
Ri2_3_2 = in3(17);
Ri2_3_3 = in3(26);
Ri3_3_1 = in3(9);
Ri3_3_2 = in3(18);
Ri3_3_3 = in3(27);
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
fi1 = in4(1,:);
fi2 = in4(5,:);
fi3 = in4(9,:);
g = in5(:,1);
iA1_1 = in6(1);
iA1_2 = in6(7);
iA1_3 = in6(13);
iA1_4 = in6(19);
iA1_5 = in6(25);
iA1_6 = in6(31);
iA2_1 = in6(2);
iA2_2 = in6(8);
iA2_3 = in6(14);
iA2_4 = in6(20);
iA2_5 = in6(26);
iA2_6 = in6(32);
iA3_1 = in6(3);
iA3_2 = in6(9);
iA3_3 = in6(15);
iA3_4 = in6(21);
iA3_5 = in6(27);
iA3_6 = in6(33);
iA4_1 = in6(4);
iA4_2 = in6(10);
iA4_3 = in6(16);
iA4_4 = in6(22);
iA4_5 = in6(28);
iA4_6 = in6(34);
iA5_1 = in6(5);
iA5_2 = in6(11);
iA5_3 = in6(17);
iA5_4 = in6(23);
iA5_5 = in6(29);
iA5_6 = in6(35);
iA6_1 = in6(6);
iA6_2 = in6(12);
iA6_3 = in6(18);
iA6_4 = in6(24);
iA6_5 = in6(30);
iA6_6 = in6(36);
j01 = in5(:,3);
j02 = in5(:,4);
j03 = in5(:,5);
li1 = in5(:,15);
li2 = in5(:,16);
li3 = in5(:,17);
m0 = in5(:,2);
mi1 = in5(:,18);
mi2 = in5(:,19);
mi3 = in5(:,20);
rho1_1 = in5(:,6);
rho1_2 = in5(:,7);
rho1_3 = in5(:,8);
rho2_1 = in5(:,9);
rho2_2 = in5(:,10);
rho2_3 = in5(:,11);
rho3_1 = in5(:,12);
rho3_2 = in5(:,13);
rho3_3 = in5(:,14);
t2 = R01_1.*rho1_2;
t3 = R01_2.*rho1_1;
t4 = R01_1.*rho1_3;
t5 = R01_3.*rho1_1;
t6 = R01_2.*rho1_3;
t7 = R01_3.*rho1_2;
t8 = R01_1.*rho2_2;
t9 = R01_2.*rho2_1;
t10 = R02_1.*rho1_2;
t11 = R02_2.*rho1_1;
t12 = R01_1.*rho2_3;
t13 = R01_3.*rho2_1;
t14 = R02_1.*rho1_3;
t15 = R02_3.*rho1_1;
t16 = R01_2.*rho2_3;
t17 = R01_3.*rho2_2;
t18 = R02_2.*rho1_3;
t19 = R02_3.*rho1_2;
t20 = R01_1.*rho3_2;
t21 = R01_2.*rho3_1;
t22 = R02_1.*rho2_2;
t23 = R02_2.*rho2_1;
t24 = R03_1.*rho1_2;
t25 = R03_2.*rho1_1;
t26 = R01_1.*rho3_3;
t27 = R01_3.*rho3_1;
t28 = R02_1.*rho2_3;
t29 = R02_3.*rho2_1;
t30 = R03_1.*rho1_3;
t31 = R03_3.*rho1_1;
t32 = R01_2.*rho3_3;
t33 = R01_3.*rho3_2;
t34 = R02_2.*rho2_3;
t35 = R02_3.*rho2_2;
t36 = R03_2.*rho1_3;
t37 = R03_3.*rho1_2;
t38 = R02_1.*rho3_2;
t39 = R02_2.*rho3_1;
t40 = R03_1.*rho2_2;
t41 = R03_2.*rho2_1;
t42 = R02_1.*rho3_3;
t43 = R02_3.*rho3_1;
t44 = R03_1.*rho2_3;
t45 = R03_3.*rho2_1;
t46 = R02_2.*rho3_3;
t47 = R02_3.*rho3_2;
t48 = R03_2.*rho2_3;
t49 = R03_3.*rho2_2;
t50 = R03_1.*rho3_2;
t51 = R03_2.*rho3_1;
t52 = R03_1.*rho3_3;
t53 = R03_3.*rho3_1;
t54 = R03_2.*rho3_3;
t55 = R03_3.*rho3_2;
t56 = X10.^2;
t57 = X11.^2;
t58 = X12.^2;
t59 = X13.^2;
t60 = X14.^2;
t61 = X15.^2;
t62 = X16.^2;
t63 = X17.^2;
t64 = X18.^2;
t65 = X19.^2;
t66 = X20.^2;
t67 = X21.^2;
t68 = X22.^2;
t69 = X23.^2;
t70 = X24.^2;
t71 = X25.^2;
t72 = X26.^2;
t73 = X27.^2;
t74 = X28.^2;
t75 = X29.^2;
t76 = X30.^2;
t77 = X10.*X11.*j01;
t78 = X10.*X11.*j02;
t79 = X10.*X12.*j01;
t80 = X10.*X12.*j03;
t81 = X11.*X12.*j02;
t82 = X11.*X12.*j03;
t83 = X13.*X15.*mi1;
t84 = X14.*X15.*mi1;
t85 = X16.*X18.*mi2;
t86 = X17.*X18.*mi2;
t87 = X19.*X21.*mi3;
t88 = X20.*X21.*mi3;
t155 = Ri1_3_1.*X13.*X14.*fi1;
t156 = Ri1_3_1.*X13.*X15.*fi1;
t157 = Ri1_3_2.*X16.*X17.*fi2;
t158 = Ri1_3_2.*X16.*X18.*fi2;
t159 = Ri1_3_3.*X19.*X20.*fi3;
t160 = Ri1_3_3.*X19.*X21.*fi3;
t161 = Ri2_3_1.*X13.*X14.*fi1;
t162 = Ri2_3_1.*X14.*X15.*fi1;
t163 = Ri2_3_2.*X16.*X17.*fi2;
t164 = Ri2_3_2.*X17.*X18.*fi2;
t165 = Ri2_3_3.*X19.*X20.*fi3;
t166 = Ri2_3_3.*X20.*X21.*fi3;
t167 = Ri3_3_1.*X13.*X15.*fi1;
t168 = Ri3_3_1.*X14.*X15.*fi1;
t169 = Ri3_3_2.*X16.*X18.*fi2;
t170 = Ri3_3_2.*X17.*X18.*fi2;
t171 = Ri3_3_3.*X19.*X21.*fi3;
t172 = Ri3_3_3.*X20.*X21.*fi3;
t173 = R01_1.*X13.*X14.*mi1;
t175 = R01_2.*X13.*X14.*mi1;
t177 = R01_3.*X13.*X14.*mi1;
t179 = R01_1.*X16.*X17.*mi2;
t181 = R01_2.*X16.*X17.*mi2;
t183 = R01_3.*X16.*X17.*mi2;
t185 = R02_1.*X13.*X14.*mi1;
t186 = R02_2.*X13.*X14.*mi1;
t188 = R02_3.*X13.*X14.*mi1;
t190 = R01_1.*X19.*X20.*mi3;
t193 = R01_2.*X19.*X20.*mi3;
t195 = R01_3.*X19.*X20.*mi3;
t197 = R02_1.*X16.*X17.*mi2;
t198 = R02_2.*X16.*X17.*mi2;
t200 = R02_3.*X16.*X17.*mi2;
t208 = R02_1.*X19.*X20.*mi3;
t210 = R02_2.*X19.*X20.*mi3;
t212 = R02_3.*X19.*X20.*mi3;
t89 = mi1.*t2;
t90 = mi1.*t3;
t91 = mi1.*t4;
t92 = mi1.*t5;
t93 = mi1.*t6;
t94 = mi1.*t7;
t95 = mi1.*t10;
t96 = mi1.*t11;
t97 = mi2.*t8;
t98 = mi2.*t9;
t99 = mi1.*t14;
t100 = mi1.*t15;
t101 = mi2.*t12;
t102 = mi2.*t13;
t103 = mi1.*t18;
t104 = mi1.*t19;
t105 = mi2.*t16;
t106 = mi2.*t17;
t107 = mi1.*t24;
t108 = mi1.*t25;
t109 = mi2.*t22;
t110 = mi2.*t23;
t111 = mi1.*t30;
t112 = mi1.*t31;
t113 = mi3.*t20;
t114 = mi3.*t21;
t115 = mi2.*t28;
t116 = mi2.*t29;
t117 = mi1.*t36;
t118 = mi1.*t37;
t119 = mi3.*t26;
t120 = mi3.*t27;
t121 = mi2.*t34;
t122 = mi2.*t35;
t123 = mi3.*t32;
t124 = mi3.*t33;
t125 = mi2.*t40;
t126 = mi2.*t41;
t127 = mi3.*t38;
t128 = mi3.*t39;
t129 = mi2.*t44;
t130 = mi2.*t45;
t131 = mi3.*t42;
t132 = mi3.*t43;
t133 = mi2.*t48;
t134 = mi2.*t49;
t135 = mi3.*t46;
t136 = mi3.*t47;
t137 = mi3.*t50;
t138 = mi3.*t51;
t139 = mi3.*t52;
t140 = mi3.*t53;
t141 = mi3.*t54;
t142 = mi3.*t55;
t143 = -t7;
t144 = -t17;
t145 = -t19;
t146 = -t33;
t147 = -t35;
t148 = -t37;
t149 = -t47;
t150 = -t49;
t151 = -t55;
t152 = mi1.*t61;
t153 = mi2.*t64;
t154 = mi3.*t67;
t174 = R01_1.*t83;
t176 = R01_2.*t83;
t178 = R01_3.*t83;
t180 = R01_1.*t85;
t182 = R01_2.*t85;
t184 = R01_3.*t85;
t187 = R02_1.*t84;
t189 = R02_2.*t84;
t191 = R02_3.*t84;
t192 = R01_1.*t87;
t194 = R01_2.*t87;
t196 = R01_3.*t87;
t199 = R02_1.*t86;
t201 = R02_2.*t86;
t202 = R02_3.*t86;
t203 = R03_1.*t83;
t204 = R03_1.*t84;
t205 = R03_2.*t83;
t206 = R03_2.*t84;
t207 = R03_3.*t83;
t209 = R03_3.*t84;
t211 = R02_1.*t88;
t213 = R02_2.*t88;
t214 = R02_3.*t88;
t215 = R03_1.*t85;
t216 = R03_1.*t86;
t217 = R03_2.*t85;
t218 = R03_2.*t86;
t219 = R03_3.*t85;
t220 = R03_3.*t86;
t221 = R03_1.*t87;
t222 = R03_1.*t88;
t223 = R03_2.*t87;
t224 = R03_2.*t88;
t225 = R03_3.*t87;
t226 = R03_3.*t88;
t227 = -t78;
t228 = -t80;
t229 = -t82;
t239 = Ri1_3_1.*fi1.*t59;
t240 = Ri1_3_2.*fi2.*t62;
t241 = Ri1_3_3.*fi3.*t65;
t242 = Ri2_3_1.*fi1.*t60;
t243 = Ri2_3_2.*fi2.*t63;
t244 = Ri2_3_3.*fi3.*t66;
t245 = Ri3_3_1.*fi1.*t61;
t246 = Ri3_3_2.*fi2.*t64;
t247 = Ri3_3_3.*fi3.*t67;
t248 = R01_1.*mi1.*t59;
t249 = R01_2.*mi1.*t59;
t250 = R01_3.*mi1.*t59;
t251 = R01_1.*mi2.*t62;
t252 = R01_2.*mi2.*t62;
t253 = R01_3.*mi2.*t62;
t254 = R01_1.*mi3.*t65;
t255 = R01_2.*mi3.*t65;
t256 = R01_3.*mi3.*t65;
t257 = R02_1.*mi1.*t60;
t258 = R02_2.*mi1.*t60;
t259 = R02_3.*mi1.*t60;
t260 = R02_1.*mi2.*t63;
t261 = R02_2.*mi2.*t63;
t262 = R02_3.*mi2.*t63;
t263 = R02_1.*mi3.*t66;
t264 = R02_2.*mi3.*t66;
t265 = R02_3.*mi3.*t66;
t275 = t2+t3;
t276 = t4+t5;
t277 = t8+t9;
t278 = t10+t11;
t279 = t12+t13;
t280 = t14+t15;
t281 = t20+t21;
t282 = t22+t23;
t283 = t24+t25;
t284 = t26+t27;
t285 = t28+t29;
t286 = t30+t31;
t287 = t38+t39;
t288 = t40+t41;
t289 = t42+t43;
t290 = t44+t45;
t291 = t50+t51;
t292 = t52+t53;
t293 = t56+t57;
t294 = t56+t58;
t295 = t57+t58;
t323 = t68+t69+t70;
t324 = t71+t72+t73;
t325 = t74+t75+t76;
t389 = t83+t85+t87;
t390 = t84+t86+t88;
t230 = -t94;
t231 = -t104;
t232 = -t106;
t233 = -t118;
t234 = -t122;
t235 = -t124;
t236 = -t134;
t237 = -t136;
t238 = -t142;
t266 = R03_1.*t152;
t267 = R03_2.*t152;
t268 = R03_3.*t152;
t269 = R03_1.*t153;
t270 = R03_2.*t153;
t271 = R03_3.*t153;
t272 = R03_1.*t154;
t273 = R03_2.*t154;
t274 = R03_3.*t154;
t296 = t89+t90;
t297 = t91+t92;
t298 = t95+t96;
t299 = t97+t98;
t300 = t99+t100;
t301 = t101+t102;
t302 = t107+t108;
t303 = t109+t110;
t304 = t111+t112;
t305 = t113+t114;
t306 = t115+t116;
t307 = t119+t120;
t308 = t125+t126;
t309 = t127+t128;
t310 = t129+t130;
t311 = t131+t132;
t312 = t137+t138;
t313 = t139+t140;
t314 = t6+t143;
t315 = t16+t144;
t316 = t18+t145;
t317 = t32+t146;
t318 = t34+t147;
t319 = t36+t148;
t320 = t46+t149;
t321 = t48+t150;
t322 = t54+t151;
t326 = X13.*mi1.*t275;
t327 = X13.*mi1.*t276;
t328 = X14.*mi1.*t278;
t329 = X14.*mi1.*t280;
t330 = X16.*mi2.*t277;
t331 = X16.*mi2.*t279;
t332 = X15.*mi1.*t283;
t333 = X15.*mi1.*t286;
t334 = X17.*mi2.*t282;
t335 = X17.*mi2.*t285;
t336 = X19.*mi3.*t281;
t337 = X19.*mi3.*t284;
t338 = X18.*mi2.*t288;
t339 = X18.*mi2.*t290;
t340 = X20.*mi3.*t287;
t341 = X20.*mi3.*t289;
t342 = X21.*mi3.*t291;
t343 = X21.*mi3.*t292;
t391 = X13.*li1.*mi1.*t323;
t392 = X14.*li1.*mi1.*t323;
t393 = X15.*li1.*mi1.*t323;
t394 = X16.*li2.*mi2.*t324;
t395 = X17.*li2.*mi2.*t324;
t396 = X18.*li2.*mi2.*t324;
t397 = X19.*li3.*mi3.*t325;
t398 = X20.*li3.*mi3.*t325;
t399 = X21.*li3.*mi3.*t325;
t400 = g.*t389;
t401 = g.*t390;
t411 = m0+t152+t153+t154;
t414 = t161+t167+t239;
t415 = t155+t168+t242;
t416 = t156+t162+t245;
t417 = t163+t169+t240;
t418 = t157+t170+t243;
t419 = t158+t164+t246;
t420 = t165+t171+t241;
t421 = t159+t172+t244;
t422 = t160+t166+t247;
t423 = t185+t203+t248;
t424 = t173+t204+t257;
t425 = t186+t205+t249;
t427 = t175+t206+t258;
t428 = t188+t207+t250;
t430 = t177+t209+t259;
t432 = t197+t215+t251;
t433 = t179+t216+t260;
t434 = t198+t217+t252;
t436 = t181+t218+t261;
t437 = t200+t219+t253;
t439 = t183+t220+t262;
t441 = t208+t221+t254;
t442 = t190+t222+t263;
t443 = t210+t223+t255;
t445 = t193+t224+t264;
t446 = t212+t225+t256;
t448 = t195+t226+t265;
t344 = X13.*t296;
t345 = X13.*t297;
t346 = X14.*t298;
t347 = X14.*t300;
t348 = X16.*t299;
t349 = X16.*t301;
t350 = X15.*t302;
t351 = X15.*t304;
t352 = X17.*t303;
t353 = X17.*t306;
t354 = X19.*t305;
t355 = X19.*t307;
t356 = X18.*t308;
t357 = X18.*t310;
t358 = X20.*t309;
t359 = X20.*t311;
t360 = X21.*t312;
t361 = X21.*t313;
t362 = t93+t230;
dX = ft_1({R01_1,R01_2,R01_3,R02_1,R02_2,R02_3,R03_1,R03_2,R03_3,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,g,iA1_1,iA1_2,iA1_3,iA1_4,iA1_5,iA1_6,iA2_1,iA2_2,iA2_3,iA2_4,iA2_5,iA2_6,iA3_1,iA3_2,iA3_3,iA3_4,iA3_5,iA3_6,iA4_1,iA4_2,iA4_3,iA4_4,iA4_5,iA4_6,iA5_1,iA5_2,iA5_3,iA5_4,iA5_5,iA5_6,iA6_1,iA6_2,iA6_3,iA6_4,iA6_5,iA6_6,li1,li2,li3,mi1,mi2,mi3,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,t103,t105,t117,t121,t123,t133,t135,t141,t174,t176,t178,t180,t182,t184,t187,t189,t191,t192,t194,t196,t199,t201,t202,t211,t213,t214,t227,t228,t229,t231,t232,t233,t234,t235,t236,t237,t238,t266,t267,t268,t269,t270,t271,t272,t273,t274,t275,t276,t277,t278,t279,t280,t281,t282,t283,t284,t285,t286,t287,t288,t289,t290,t291,t292,t293,t294,t295,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t325,t326,t327,t328,t329,t330,t331,t332,t333,t334,t335,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t391,t392,t393,t394,t395,t396,t397,t398,t399,t400,t401,t411,t414,t415,t416,t417,t418,t419,t420,t421,t422,t423,t424,t425,t427,t428,t430,t432,t433,t434,t436,t437,t439,t441,t442,t443,t445,t446,t448,t77,t79,t81});
end
function dX = ft_1(ct)
[R01_1,R01_2,R01_3,R02_1,R02_2,R02_3,R03_1,R03_2,R03_3,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,g,iA1_1,iA1_2,iA1_3,iA1_4,iA1_5,iA1_6,iA2_1,iA2_2,iA2_3,iA2_4,iA2_5,iA2_6,iA3_1,iA3_2,iA3_3,iA3_4,iA3_5,iA3_6,iA4_1,iA4_2,iA4_3,iA4_4,iA4_5,iA4_6,iA5_1,iA5_2,iA5_3,iA5_4,iA5_5,iA5_6,iA6_1,iA6_2,iA6_3,iA6_4,iA6_5,iA6_6,li1,li2,li3,mi1,mi2,mi3,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,t103,t105,t117,t121,t123,t133,t135,t141,t174,t176,t178,t180,t182,t184,t187,t189,t191,t192,t194,t196,t199,t201,t202,t211,t213,t214,t227,t228,t229,t231,t232,t233,t234,t235,t236,t237,t238,t266,t267,t268,t269,t270,t271,t272,t273,t274,t275,t276,t277,t278,t279,t280,t281,t282,t283,t284,t285,t286,t287,t288,t289,t290,t291,t292,t293,t294,t295,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t325,t326,t327,t328,t329,t330,t331,t332,t333,t334,t335,t336,t337,t338,t339,t340,t341,t342,t343,t344,t345,t346,t347,t348,t349,t350,t351,t352,t353,t354,t355,t356,t357,t358,t359,t360,t361,t362,t391,t392,t393,t394,t395,t396,t397,t398,t399,t400,t401,t411,t414,t415,t416,t417,t418,t419,t420,t421,t422,t423,t424,t425,t427,t428,t430,t432,t433,t434,t436,t437,t439,t441,t442,t443,t445,t446,t448,t77,t79,t81] = ct{:};
t363 = t103+t231;
t364 = t105+t232;
t365 = t117+t233;
t366 = t121+t234;
t367 = t123+t235;
t368 = t133+t236;
t369 = t135+t237;
t370 = t141+t238;
t371 = X13.*mi1.*t314;
t372 = X14.*mi1.*t316;
t373 = X16.*mi2.*t315;
t374 = X15.*mi1.*t319;
t375 = X17.*mi2.*t318;
t376 = X19.*mi3.*t317;
t377 = X18.*mi2.*t321;
t378 = X20.*mi3.*t320;
t379 = X21.*mi3.*t322;
t402 = -t391;
t403 = -t392;
t404 = -t393;
t405 = -t394;
t406 = -t395;
t407 = -t396;
t408 = -t397;
t409 = -t398;
t410 = -t399;
t412 = -t400;
t413 = -t401;
t426 = t174+t187+t266;
t429 = t176+t189+t267;
t431 = t178+t191+t268;
t435 = t180+t199+t269;
t438 = t182+t201+t270;
t440 = t184+t202+t271;
t444 = t192+t211+t272;
t447 = t194+t213+t273;
t449 = t196+t214+t274;
t450 = g.*t411;
t451 = X10.*X11.*t423;
t452 = X10.*X12.*t423;
t453 = X10.*X11.*t424;
t454 = X10.*X11.*t425;
t455 = X10.*X12.*t424;
t457 = X10.*X11.*t427;
t459 = X11.*X12.*t425;
t461 = X10.*X12.*t428;
t462 = X11.*X12.*t427;
t463 = X11.*X12.*t428;
t464 = X10.*X12.*t430;
t466 = X11.*X12.*t430;
t469 = X10.*X11.*t432;
t470 = X10.*X12.*t432;
t471 = X10.*X11.*t433;
t472 = X10.*X11.*t434;
t473 = X10.*X12.*t433;
t475 = X10.*X11.*t436;
t477 = X11.*X12.*t434;
t479 = X10.*X12.*t437;
t480 = X11.*X12.*t436;
t481 = X11.*X12.*t437;
t482 = X10.*X12.*t439;
t484 = X11.*X12.*t439;
t487 = X10.*X11.*t441;
t488 = X10.*X12.*t441;
t489 = X10.*X11.*t442;
t490 = X10.*X11.*t443;
t491 = X10.*X12.*t442;
t493 = X10.*X11.*t445;
t495 = X11.*X12.*t443;
t497 = X10.*X12.*t446;
t498 = X11.*X12.*t445;
t499 = X11.*X12.*t446;
t500 = X10.*X12.*t448;
t502 = X11.*X12.*t448;
t506 = li1.*t323.*t326;
t507 = li1.*t323.*t327;
t508 = li1.*t323.*t328;
t509 = li1.*t323.*t329;
t510 = li2.*t324.*t330;
t511 = li2.*t324.*t331;
t512 = li1.*t323.*t332;
t513 = li1.*t323.*t333;
t514 = li2.*t324.*t334;
t515 = li2.*t324.*t335;
t516 = li3.*t325.*t336;
t517 = li3.*t325.*t337;
t518 = li2.*t324.*t338;
t519 = li2.*t324.*t339;
t520 = li3.*t325.*t340;
t521 = li3.*t325.*t341;
t522 = li3.*t325.*t342;
t523 = li3.*t325.*t343;
t551 = t295.*t423;
t552 = t294.*t425;
t553 = t295.*t424;
t554 = t293.*t428;
t555 = t294.*t427;
t557 = t293.*t430;
t560 = t295.*t432;
t561 = t294.*t434;
t562 = t295.*t433;
t563 = t293.*t437;
t564 = t294.*t436;
t566 = t293.*t439;
t569 = t295.*t441;
t570 = t294.*t443;
t571 = t295.*t442;
t572 = t293.*t446;
t573 = t294.*t445;
t575 = t293.*t448;
t587 = t275.*t414;
t588 = t276.*t414;
t589 = t278.*t415;
t590 = t280.*t415;
t591 = t277.*t417;
t592 = t279.*t417;
t593 = t283.*t416;
t594 = t286.*t416;
t595 = t282.*t418;
t596 = t285.*t418;
t597 = t281.*t420;
t598 = t284.*t420;
t599 = t288.*t419;
t600 = t290.*t419;
t601 = t287.*t421;
t602 = t289.*t421;
t603 = t291.*t422;
t604 = t292.*t422;
t632 = t314.*t414;
t633 = t316.*t415;
t634 = t315.*t417;
t635 = t319.*t416;
t636 = t318.*t418;
t637 = t317.*t420;
t638 = t321.*t419;
t639 = t320.*t421;
t640 = t322.*t422;
t641 = t326+t328+t332;
t642 = t327+t329+t333;
t643 = t330+t334+t338;
t644 = t331+t335+t339;
t645 = t336+t340+t342;
t646 = t337+t341+t343;
t380 = X13.*t362;
t381 = X14.*t363;
t382 = X16.*t364;
t383 = X15.*t365;
t384 = X17.*t366;
t385 = X19.*t367;
t386 = X18.*t368;
t387 = X20.*t369;
t388 = X21.*t370;
t456 = X10.*X11.*t426;
t458 = X10.*X12.*t426;
t460 = X10.*X11.*t429;
t465 = X11.*X12.*t429;
t467 = X10.*X12.*t431;
t468 = X11.*X12.*t431;
t474 = X10.*X11.*t435;
t476 = X10.*X12.*t435;
t478 = X10.*X11.*t438;
t483 = X11.*X12.*t438;
t485 = X10.*X12.*t440;
t486 = X11.*X12.*t440;
t492 = X10.*X11.*t444;
t494 = X10.*X12.*t444;
t496 = X10.*X11.*t447;
t501 = X11.*X12.*t447;
t503 = X10.*X12.*t449;
t504 = X11.*X12.*t449;
t505 = -t450;
t524 = -t506;
t525 = -t507;
t526 = li1.*t323.*t371;
t527 = -t508;
t528 = -t509;
t529 = li1.*t323.*t372;
t530 = -t510;
t531 = -t511;
t532 = li2.*t324.*t373;
t533 = -t512;
t534 = -t513;
t535 = li1.*t323.*t374;
t536 = -t514;
t537 = -t515;
t538 = li2.*t324.*t375;
t539 = -t516;
t540 = -t517;
t541 = li3.*t325.*t376;
t542 = -t518;
t543 = -t519;
t544 = li2.*t324.*t377;
t545 = -t520;
t546 = -t521;
t547 = li3.*t325.*t378;
t548 = -t522;
t549 = -t523;
t550 = li3.*t325.*t379;
t556 = t295.*t426;
t558 = t294.*t429;
t559 = t293.*t431;
t565 = t295.*t435;
t567 = t294.*t438;
t568 = t293.*t440;
t574 = t295.*t444;
t576 = t294.*t447;
t577 = t293.*t449;
t605 = -t551;
t606 = -t552;
t607 = -t553;
t608 = -t554;
t609 = -t555;
t611 = -t557;
t614 = -t560;
t615 = -t561;
t616 = -t562;
t617 = -t563;
t618 = -t564;
t620 = -t566;
t623 = -t569;
t624 = -t570;
t625 = -t571;
t626 = -t572;
t627 = -t573;
t629 = -t575;
t647 = t344+t346+t350;
t648 = t345+t347+t351;
t649 = t348+t352+t356;
t650 = t349+t353+t357;
t651 = t354+t358+t360;
t652 = t355+t359+t361;
t653 = R01_1.*X13.*t641;
t654 = R01_2.*X13.*t641;
t655 = R01_3.*X13.*t641;
t656 = R01_1.*X13.*t642;
t657 = R01_2.*X13.*t642;
t658 = R01_3.*X13.*t642;
t659 = R02_1.*X14.*t641;
t660 = R02_2.*X14.*t641;
t661 = R02_3.*X14.*t641;
t662 = R02_1.*X14.*t642;
t663 = R02_2.*X14.*t642;
t664 = R02_3.*X14.*t642;
t665 = R03_1.*X15.*t641;
t666 = R03_2.*X15.*t641;
t667 = R03_3.*X15.*t641;
t668 = R03_1.*X15.*t642;
t669 = R03_2.*X15.*t642;
t670 = R03_3.*X15.*t642;
t671 = R01_1.*X16.*t643;
t672 = R01_2.*X16.*t643;
t673 = R01_3.*X16.*t643;
t674 = R01_1.*X16.*t644;
t675 = R01_2.*X16.*t644;
t676 = R01_3.*X16.*t644;
t677 = R02_1.*X17.*t643;
t678 = R02_2.*X17.*t643;
t679 = R02_3.*X17.*t643;
t680 = R02_1.*X17.*t644;
t681 = R02_2.*X17.*t644;
t682 = R02_3.*X17.*t644;
t683 = R03_1.*X18.*t643;
t684 = R03_2.*X18.*t643;
t685 = R03_3.*X18.*t643;
t686 = R03_1.*X18.*t644;
t687 = R03_2.*X18.*t644;
t688 = R03_3.*X18.*t644;
t689 = R01_1.*X19.*t645;
t690 = R01_2.*X19.*t645;
t691 = R01_3.*X19.*t645;
t692 = R01_1.*X19.*t646;
t693 = R01_2.*X19.*t646;
t694 = R01_3.*X19.*t646;
t695 = R02_1.*X20.*t645;
t696 = R02_2.*X20.*t645;
t697 = R02_3.*X20.*t645;
t698 = R02_1.*X20.*t646;
t699 = R02_2.*X20.*t646;
t700 = R02_3.*X20.*t646;
t701 = R03_1.*X21.*t645;
t702 = R03_2.*X21.*t645;
t703 = R03_3.*X21.*t645;
t704 = R03_1.*X21.*t646;
t705 = R03_2.*X21.*t646;
t706 = R03_3.*X21.*t646;
t713 = t371+t372+t374;
t714 = t373+t375+t377;
t715 = t376+t378+t379;
t578 = -t526;
t579 = -t529;
t580 = -t532;
t581 = -t535;
t582 = -t538;
t583 = -t541;
t584 = -t544;
t585 = -t547;
t586 = -t550;
t610 = -t556;
t612 = -t558;
t613 = -t559;
t619 = -t565;
t621 = -t567;
t622 = -t568;
t628 = -t574;
t630 = -t576;
t631 = -t577;
t707 = X15.*g.*t647;
t708 = X15.*g.*t648;
t709 = X18.*g.*t649;
t710 = X18.*g.*t650;
t711 = X21.*g.*t651;
t712 = X21.*g.*t652;
t722 = t380+t381+t383;
t723 = t382+t384+t386;
t724 = t385+t387+t388;
t725 = R01_1.*X13.*t713;
t726 = R01_2.*X13.*t713;
t727 = R01_3.*X13.*t713;
t728 = R02_1.*X14.*t713;
t729 = R02_2.*X14.*t713;
t730 = R02_3.*X14.*t713;
t731 = R03_1.*X15.*t713;
t732 = R03_2.*X15.*t713;
t733 = R03_3.*X15.*t713;
t734 = R01_1.*X16.*t714;
t735 = R01_2.*X16.*t714;
t736 = R01_3.*X16.*t714;
t737 = R02_1.*X17.*t714;
t738 = R02_2.*X17.*t714;
t739 = R02_3.*X17.*t714;
t740 = R03_1.*X18.*t714;
t741 = R03_2.*X18.*t714;
t742 = R03_3.*X18.*t714;
t743 = R01_1.*X19.*t715;
t744 = R01_2.*X19.*t715;
t745 = R01_3.*X19.*t715;
t746 = R02_1.*X20.*t715;
t747 = R02_2.*X20.*t715;
t748 = R02_3.*X20.*t715;
t749 = R03_1.*X21.*t715;
t750 = R03_2.*X21.*t715;
t751 = R03_3.*X21.*t715;
t758 = t454+t461+t605;
t759 = t451+t463+t606;
t760 = t452+t459+t608;
t761 = t457+t464+t607;
t762 = t453+t466+t609;
t763 = t455+t462+t611;
t767 = t472+t479+t614;
t768 = t469+t481+t615;
t769 = t470+t477+t617;
t770 = t475+t482+t616;
t771 = t471+t484+t618;
t772 = t473+t480+t620;
t776 = t490+t497+t623;
t777 = t487+t499+t624;
t778 = t488+t495+t626;
t779 = t493+t500+t625;
t780 = t489+t502+t627;
t781 = t491+t498+t629;
t821 = t653+t659+t665;
t822 = t654+t660+t666;
t823 = t655+t661+t667;
t824 = t656+t662+t668;
t825 = t657+t663+t669;
t826 = t658+t664+t670;
t827 = t671+t677+t683;
t828 = t672+t678+t684;
t829 = t673+t679+t685;
t830 = t674+t680+t686;
t831 = t675+t681+t687;
t832 = t676+t682+t688;
t833 = t689+t695+t701;
t834 = t690+t696+t702;
t835 = t691+t697+t703;
t836 = t692+t698+t704;
t837 = t693+t699+t705;
t838 = t694+t700+t706;
t716 = -t707;
t717 = -t708;
t718 = -t709;
t719 = -t710;
t720 = -t711;
t721 = -t712;
t752 = X15.*g.*t722;
t753 = X18.*g.*t723;
t754 = X21.*g.*t724;
t764 = t460+t467+t610;
t765 = t456+t468+t612;
t766 = t458+t465+t613;
t773 = t478+t485+t619;
t774 = t474+t486+t621;
t775 = t476+t483+t622;
t782 = t496+t503+t628;
t783 = t492+t504+t630;
t784 = t494+t501+t631;
t785 = rho1_1.*t758;
t786 = rho1_2.*t759;
t787 = rho1_3.*t760;
t788 = rho1_1.*t761;
t789 = rho1_2.*t762;
t790 = rho1_3.*t763;
t794 = rho2_1.*t767;
t795 = rho2_2.*t768;
t796 = rho2_3.*t769;
t797 = rho2_1.*t770;
t798 = rho2_2.*t771;
t799 = rho2_3.*t772;
t803 = rho3_1.*t776;
t804 = rho3_2.*t777;
t805 = rho3_3.*t778;
t806 = rho3_1.*t779;
t807 = rho3_2.*t780;
t808 = rho3_3.*t781;
t839 = X10.*X11.*t821;
t840 = X10.*X12.*t821;
t841 = X10.*X11.*t822;
t842 = X11.*X12.*t822;
t843 = X10.*X12.*t823;
t844 = X11.*X12.*t823;
t845 = X10.*X11.*t824;
t846 = X10.*X12.*t824;
t847 = X10.*X11.*t825;
t848 = X11.*X12.*t825;
t849 = X10.*X12.*t826;
t850 = X11.*X12.*t826;
t851 = X10.*X11.*t827;
t852 = X10.*X12.*t827;
t853 = X10.*X11.*t828;
t854 = X11.*X12.*t828;
t855 = X10.*X12.*t829;
t856 = X11.*X12.*t829;
t857 = X10.*X11.*t830;
t858 = X10.*X12.*t830;
t859 = X10.*X11.*t831;
t860 = X11.*X12.*t831;
t861 = X10.*X12.*t832;
t862 = X11.*X12.*t832;
t863 = X10.*X11.*t833;
t864 = X10.*X12.*t833;
t865 = X10.*X11.*t834;
t866 = X11.*X12.*t834;
t867 = X10.*X12.*t835;
t868 = X11.*X12.*t835;
t869 = X10.*X11.*t836;
t870 = X10.*X12.*t836;
t871 = X10.*X11.*t837;
t872 = X11.*X12.*t837;
t873 = X10.*X12.*t838;
t874 = X11.*X12.*t838;
t875 = t295.*t821;
t876 = t294.*t822;
t877 = t293.*t823;
t878 = t295.*t824;
t879 = t294.*t825;
t880 = t293.*t826;
t881 = t295.*t827;
t882 = t294.*t828;
t883 = t293.*t829;
t884 = t295.*t830;
t885 = t294.*t831;
t886 = t293.*t832;
t887 = t295.*t833;
t888 = t294.*t834;
t889 = t293.*t835;
t890 = t295.*t836;
t891 = t294.*t837;
t892 = t293.*t838;
t911 = t725+t728+t731;
t912 = t726+t729+t732;
t913 = t727+t730+t733;
t914 = t734+t737+t740;
t915 = t735+t738+t741;
t916 = t736+t739+t742;
t917 = t743+t746+t749;
t918 = t744+t747+t750;
t919 = t745+t748+t751;
t755 = -t752;
t756 = -t753;
t757 = -t754;
t791 = rho1_1.*t764;
t792 = rho1_2.*t765;
t793 = rho1_3.*t766;
t800 = rho2_1.*t773;
t801 = rho2_2.*t774;
t802 = rho2_3.*t775;
t809 = rho3_1.*t782;
t810 = rho3_2.*t783;
t811 = rho3_3.*t784;
t812 = -t785;
t813 = -t788;
t815 = -t794;
t816 = -t797;
t818 = -t803;
t819 = -t806;
t893 = -t875;
t894 = -t876;
t895 = -t877;
t896 = -t878;
t897 = -t879;
dX = ft_2({X10,X11,X12,iA1_1,iA1_2,iA1_3,iA1_4,iA1_5,iA1_6,iA2_1,iA2_2,iA2_3,iA2_4,iA2_5,iA2_6,iA3_1,iA3_2,iA3_3,iA3_4,iA3_5,iA3_6,iA4_1,iA4_2,iA4_3,iA4_4,iA4_5,iA4_6,iA5_1,iA5_2,iA5_3,iA5_4,iA5_5,iA5_6,iA6_1,iA6_2,iA6_3,iA6_4,iA6_5,iA6_6,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,t227,t228,t229,t293,t294,t295,t402,t403,t404,t405,t406,t407,t408,t409,t410,t412,t413,t414,t415,t416,t417,t418,t419,t420,t421,t422,t505,t524,t525,t527,t528,t530,t531,t533,t534,t536,t537,t539,t540,t542,t543,t545,t546,t548,t549,t578,t579,t580,t581,t582,t583,t584,t585,t586,t587,t588,t589,t590,t591,t592,t593,t594,t595,t596,t597,t598,t599,t600,t601,t602,t603,t604,t632,t633,t634,t635,t636,t637,t638,t639,t640,t716,t717,t718,t719,t720,t721,t755,t756,t757,t77,t786,t787,t789,t79,t790,t791,t792,t793,t795,t796,t798,t799,t800,t801,t802,t804,t805,t807,t808,t809,t81,t810,t811,t812,t813,t815,t816,t818,t819,t839,t840,t841,t842,t843,t844,t845,t846,t847,t848,t849,t850,t851,t852,t853,t854,t855,t856,t857,t858,t859,t860,t861,t862,t863,t864,t865,t866,t867,t868,t869,t870,t871,t872,t873,t874,t880,t881,t882,t883,t884,t885,t886,t887,t888,t889,t890,t891,t892,t893,t894,t895,t896,t897,t911,t912,t913,t914,t915,t916,t917,t918,t919});
end
function dX = ft_2(ct)
[X10,X11,X12,iA1_1,iA1_2,iA1_3,iA1_4,iA1_5,iA1_6,iA2_1,iA2_2,iA2_3,iA2_4,iA2_5,iA2_6,iA3_1,iA3_2,iA3_3,iA3_4,iA3_5,iA3_6,iA4_1,iA4_2,iA4_3,iA4_4,iA4_5,iA4_6,iA5_1,iA5_2,iA5_3,iA5_4,iA5_5,iA5_6,iA6_1,iA6_2,iA6_3,iA6_4,iA6_5,iA6_6,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,t227,t228,t229,t293,t294,t295,t402,t403,t404,t405,t406,t407,t408,t409,t410,t412,t413,t414,t415,t416,t417,t418,t419,t420,t421,t422,t505,t524,t525,t527,t528,t530,t531,t533,t534,t536,t537,t539,t540,t542,t543,t545,t546,t548,t549,t578,t579,t580,t581,t582,t583,t584,t585,t586,t587,t588,t589,t590,t591,t592,t593,t594,t595,t596,t597,t598,t599,t600,t601,t602,t603,t604,t632,t633,t634,t635,t636,t637,t638,t639,t640,t716,t717,t718,t719,t720,t721,t755,t756,t757,t77,t786,t787,t789,t79,t790,t791,t792,t793,t795,t796,t798,t799,t800,t801,t802,t804,t805,t807,t808,t809,t81,t810,t811,t812,t813,t815,t816,t818,t819,t839,t840,t841,t842,t843,t844,t845,t846,t847,t848,t849,t850,t851,t852,t853,t854,t855,t856,t857,t858,t859,t860,t861,t862,t863,t864,t865,t866,t867,t868,t869,t870,t871,t872,t873,t874,t880,t881,t882,t883,t884,t885,t886,t887,t888,t889,t890,t891,t892,t893,t894,t895,t896,t897,t911,t912,t913,t914,t915,t916,t917,t918,t919] = ct{:};
t898 = -t880;
t899 = -t881;
t900 = -t882;
t901 = -t883;
t902 = -t884;
t903 = -t885;
t904 = -t886;
t905 = -t887;
t906 = -t888;
t907 = -t889;
t908 = -t890;
t909 = -t891;
t910 = -t892;
t920 = X10.*X11.*t911;
t921 = X10.*X12.*t911;
t922 = X10.*X11.*t912;
t923 = X11.*X12.*t912;
t924 = X10.*X12.*t913;
t925 = X11.*X12.*t913;
t926 = X10.*X11.*t914;
t927 = X10.*X12.*t914;
t928 = X10.*X11.*t915;
t929 = X11.*X12.*t915;
t930 = X10.*X12.*t916;
t931 = X11.*X12.*t916;
t932 = X10.*X11.*t917;
t933 = X10.*X12.*t917;
t934 = X10.*X11.*t918;
t935 = X11.*X12.*t918;
t936 = X10.*X12.*t919;
t937 = X11.*X12.*t919;
t938 = t295.*t911;
t939 = t294.*t912;
t940 = t293.*t913;
t941 = t295.*t914;
t942 = t294.*t915;
t943 = t293.*t916;
t944 = t295.*t917;
t945 = t294.*t918;
t946 = t293.*t919;
t814 = -t791;
t817 = -t800;
t820 = -t809;
t947 = -t938;
t948 = -t939;
t949 = -t940;
t950 = -t941;
t951 = -t942;
t952 = -t943;
t953 = -t944;
t954 = -t945;
t955 = -t946;
t956 = t841+t843+t893;
t957 = t839+t844+t894;
t958 = t840+t842+t895;
t959 = t847+t849+t896;
t960 = t845+t850+t897;
t961 = t846+t848+t898;
t962 = t853+t855+t899;
t963 = t851+t856+t900;
t964 = t852+t854+t901;
t965 = t859+t861+t902;
t966 = t857+t862+t903;
t967 = t858+t860+t904;
t968 = t865+t867+t905;
t969 = t863+t868+t906;
t970 = t864+t866+t907;
t971 = t871+t873+t908;
t972 = t869+t874+t909;
t973 = t870+t872+t910;
t1019 = t402+t405+t408+t412+t414+t417+t420+t786+t787+t795+t796+t804+t805+t812+t815+t818;
t1020 = t403+t406+t409+t413+t415+t418+t421+t789+t790+t798+t799+t807+t808+t813+t816+t819;
t974 = rho1_1.*t956;
t975 = rho1_2.*t957;
t976 = rho1_3.*t958;
t977 = rho1_1.*t959;
t978 = rho1_2.*t960;
t979 = rho1_3.*t961;
t980 = rho2_1.*t962;
t981 = rho2_2.*t963;
t982 = rho2_3.*t964;
t983 = rho2_1.*t965;
t984 = rho2_2.*t966;
t985 = rho2_3.*t967;
t986 = rho3_1.*t968;
t987 = rho3_2.*t969;
t988 = rho3_3.*t970;
t989 = rho3_1.*t971;
t990 = rho3_2.*t972;
t991 = rho3_3.*t973;
t998 = t922+t924+t947;
t999 = t920+t925+t948;
t1000 = t921+t923+t949;
t1001 = t928+t930+t950;
t1002 = t926+t931+t951;
t1003 = t927+t929+t952;
t1004 = t934+t936+t953;
t1005 = t932+t937+t954;
t1006 = t933+t935+t955;
t1021 = t404+t407+t410+t416+t419+t422+t505+t792+t793+t801+t802+t810+t811+t814+t817+t820;
t992 = -t974;
t993 = -t977;
t994 = -t980;
t995 = -t983;
t996 = -t986;
t997 = -t989;
t1007 = rho1_1.*t998;
t1008 = rho1_2.*t999;
t1009 = rho1_3.*t1000;
t1010 = rho2_1.*t1001;
t1011 = rho2_2.*t1002;
t1012 = rho2_3.*t1003;
t1013 = rho3_1.*t1004;
t1014 = rho3_2.*t1005;
t1015 = rho3_3.*t1006;
t1016 = -t1007;
t1017 = -t1010;
t1018 = -t1013;
t1022 = t77+t227+t524+t527+t530+t533+t536+t539+t542+t545+t548+t587+t589+t591+t593+t595+t597+t599+t601+t603+t716+t718+t720+t975+t976+t981+t982+t987+t988+t992+t994+t996;
t1023 = t79+t228+t525+t528+t531+t534+t537+t540+t543+t546+t549+t588+t590+t592+t594+t596+t598+t600+t602+t604+t717+t719+t721+t978+t979+t984+t985+t990+t991+t993+t995+t997;
t1024 = t81+t229+t578+t579+t580+t581+t582+t583+t584+t585+t586+t632+t633+t634+t635+t636+t637+t638+t639+t640+t755+t756+t757+t1008+t1009+t1011+t1012+t1014+t1015+t1016+t1017+t1018;
dX = [iA1_1.*t1019-iA1_2.*t1020-iA1_3.*t1021+iA1_4.*t1024+iA1_5.*t1023-iA1_6.*t1022;iA2_1.*t1019-iA2_2.*t1020-iA2_3.*t1021+iA2_4.*t1024+iA2_5.*t1023-iA2_6.*t1022;iA3_1.*t1019-iA3_2.*t1020-iA3_3.*t1021+iA3_4.*t1024+iA3_5.*t1023-iA3_6.*t1022;iA4_1.*t1019-iA4_2.*t1020-iA4_3.*t1021+iA4_4.*t1024+iA4_5.*t1023-iA4_6.*t1022;iA5_1.*t1019-iA5_2.*t1020-iA5_3.*t1021+iA5_4.*t1024+iA5_5.*t1023-iA5_6.*t1022;iA6_1.*t1019-iA6_2.*t1020-iA6_3.*t1021+iA6_4.*t1024+iA6_5.*t1023-iA6_6.*t1022];
end
