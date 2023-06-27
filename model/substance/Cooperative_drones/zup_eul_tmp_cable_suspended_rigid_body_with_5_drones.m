function dX = zup_eul_tmp_cable_suspended_rigid_body_with_5_drones(in1,in2,in3,in4)
%ZUP_EUL_TMP_CABLE_SUSPENDED_RIGID_BODY_WITH_5_DRONES
%    dX = ZUP_EUL_TMP_CABLE_SUSPENDED_RIGID_BODY_WITH_5_DRONES(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/06/27 08:10:53

Mi1_1 = in2(2,:);
Mi1_2 = in2(3,:);
Mi1_3 = in2(4,:);
Mi2_1 = in2(6,:);
Mi2_2 = in2(7,:);
Mi2_3 = in2(8,:);
Mi3_1 = in2(10,:);
Mi3_2 = in2(11,:);
Mi3_3 = in2(12,:);
Mi4_1 = in2(14,:);
Mi4_2 = in2(15,:);
Mi4_3 = in2(16,:);
Mi5_1 = in2(18,:);
Mi5_2 = in2(19,:);
Mi5_3 = in2(20,:);
X4 = in1(4,:);
X5 = in1(5,:);
X6 = in1(6,:);
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
X40 = in1(40,:);
X41 = in1(41,:);
X42 = in1(42,:);
X43 = in1(43,:);
X44 = in1(44,:);
X45 = in1(45,:);
X46 = in1(46,:);
X47 = in1(47,:);
X48 = in1(48,:);
X49 = in1(49,:);
X50 = in1(50,:);
X51 = in1(51,:);
X52 = in1(52,:);
X53 = in1(53,:);
X54 = in1(54,:);
X55 = in1(55,:);
X56 = in1(56,:);
X57 = in1(57,:);
X58 = in1(58,:);
X59 = in1(59,:);
X60 = in1(60,:);
X61 = in1(61,:);
X62 = in1(62,:);
X63 = in1(63,:);
X64 = in1(64,:);
X65 = in1(65,:);
X66 = in1(66,:);
X67 = in1(67,:);
X68 = in1(68,:);
X69 = in1(69,:);
X70 = in1(70,:);
X71 = in1(71,:);
X72 = in1(72,:);
ddX1 = in4(1,:);
ddX2 = in4(2,:);
ddX3 = in4(3,:);
ddX4 = in4(4,:);
ddX5 = in4(5,:);
ddX6 = in4(6,:);
fi1 = in2(1,:);
fi2 = in2(5,:);
fi3 = in2(9,:);
fi4 = in2(13,:);
fi5 = in2(17,:);
g = in3(:,1);
ji1_1 = in3(:,31);
ji1_2 = in3(:,32);
ji1_3 = in3(:,33);
ji2_1 = in3(:,34);
ji2_2 = in3(:,35);
ji2_3 = in3(:,36);
ji3_1 = in3(:,37);
ji3_2 = in3(:,38);
ji3_3 = in3(:,39);
ji4_1 = in3(:,40);
ji4_2 = in3(:,41);
ji4_3 = in3(:,42);
ji5_1 = in3(:,43);
ji5_2 = in3(:,44);
ji5_3 = in3(:,45);
li1 = in3(:,21);
li2 = in3(:,22);
li3 = in3(:,23);
li4 = in3(:,24);
li5 = in3(:,25);
mi1 = in3(:,26);
mi2 = in3(:,27);
mi3 = in3(:,28);
mi4 = in3(:,29);
mi5 = in3(:,30);
rho1_1 = in3(:,6);
rho1_2 = in3(:,7);
rho1_3 = in3(:,8);
rho2_1 = in3(:,9);
rho2_2 = in3(:,10);
rho2_3 = in3(:,11);
rho3_1 = in3(:,12);
rho3_2 = in3(:,13);
rho3_3 = in3(:,14);
rho4_1 = in3(:,15);
rho4_2 = in3(:,16);
rho4_3 = in3(:,17);
rho5_1 = in3(:,18);
rho5_2 = in3(:,19);
rho5_3 = in3(:,20);
t2 = cos(X4);
t3 = cos(X5);
t4 = cos(X43);
t5 = cos(X44);
t6 = cos(X46);
t7 = cos(X47);
t8 = cos(X49);
t9 = cos(X50);
t10 = cos(X52);
t11 = cos(X53);
t12 = cos(X55);
t13 = cos(X56);
t14 = sin(X4);
t15 = sin(X5);
t16 = sin(X43);
t17 = sin(X44);
t18 = sin(X46);
t19 = sin(X47);
t20 = sin(X49);
t21 = sin(X50);
t22 = sin(X52);
t23 = sin(X53);
t24 = sin(X55);
t25 = sin(X56);
t26 = X10.^2;
t27 = X11.^2;
t28 = X12.^2;
t29 = X13.^2;
t30 = X14.^2;
t31 = X15.^2;
t32 = X16.^2;
t33 = X17.^2;
t34 = X18.^2;
t35 = X19.^2;
t36 = X20.^2;
t37 = X21.^2;
t38 = X22.^2;
t39 = X23.^2;
t40 = X24.^2;
t41 = X25.^2;
t42 = X26.^2;
t43 = X27.^2;
t44 = -ddX1;
t45 = -ddX3;
t46 = 1.0./li1;
t47 = 1.0./li2;
t48 = 1.0./li3;
t49 = 1.0./li4;
t50 = 1.0./li5;
t51 = 1.0./mi1;
t52 = 1.0./mi2;
t53 = 1.0./mi3;
t54 = 1.0./mi4;
t55 = 1.0./mi5;
t62 = X4./2.0;
t63 = X5./2.0;
t64 = X6./2.0;
t65 = X43./2.0;
t66 = X44./2.0;
t67 = X45./2.0;
t68 = X46./2.0;
t69 = X47./2.0;
t70 = X48./2.0;
t71 = X49./2.0;
t72 = X50./2.0;
t73 = X51./2.0;
t74 = X52./2.0;
t75 = X53./2.0;
t76 = X54./2.0;
t77 = X55./2.0;
t78 = X56./2.0;
t79 = X57./2.0;
t56 = 1.0./t3;
t57 = 1.0./t5;
t58 = 1.0./t7;
t59 = 1.0./t9;
t60 = 1.0./t11;
t61 = 1.0./t13;
t80 = t29-1.0;
t81 = t30-1.0;
t82 = t31-1.0;
t83 = t32-1.0;
t84 = t33-1.0;
t85 = t34-1.0;
t86 = t35-1.0;
t87 = t36-1.0;
t88 = t37-1.0;
t89 = t38-1.0;
t90 = t39-1.0;
t91 = t40-1.0;
t92 = t41-1.0;
t93 = t42-1.0;
t94 = t43-1.0;
t95 = cos(t62);
t96 = cos(t63);
t97 = cos(t64);
t98 = cos(t65);
t99 = cos(t66);
t100 = cos(t67);
t101 = cos(t68);
t102 = cos(t69);
t103 = cos(t70);
t104 = cos(t71);
t105 = cos(t72);
t106 = cos(t73);
t107 = cos(t74);
t108 = cos(t75);
t109 = cos(t76);
t110 = cos(t77);
t111 = cos(t78);
t112 = cos(t79);
t113 = sin(t62);
t114 = sin(t63);
t115 = sin(t64);
t116 = sin(t65);
t117 = sin(t66);
t118 = sin(t67);
t119 = sin(t68);
t120 = sin(t69);
t121 = sin(t70);
t122 = sin(t71);
t123 = sin(t72);
t124 = sin(t73);
t125 = sin(t74);
t126 = sin(t75);
t127 = sin(t76);
t128 = sin(t77);
t129 = sin(t78);
t130 = sin(t79);
t131 = t26+t27;
t132 = t26+t28;
t133 = t27+t28;
t134 = t95.*t96.*t97;
t135 = t98.*t99.*t100;
t136 = t101.*t102.*t103;
t137 = t104.*t105.*t106;
t138 = t107.*t108.*t109;
t139 = t110.*t111.*t112;
t140 = t95.*t96.*t115;
t141 = t95.*t97.*t114;
t142 = t96.*t97.*t113;
t143 = t98.*t99.*t118;
t144 = t98.*t100.*t117;
t145 = t99.*t100.*t116;
t146 = t101.*t102.*t121;
t147 = t101.*t103.*t120;
t148 = t102.*t103.*t119;
t149 = t104.*t105.*t124;
t150 = t104.*t106.*t123;
t151 = t105.*t106.*t122;
t152 = t107.*t108.*t127;
t153 = t107.*t109.*t126;
t154 = t108.*t109.*t125;
t155 = t110.*t111.*t130;
t156 = t110.*t112.*t129;
t157 = t111.*t112.*t128;
t158 = t95.*t114.*t115;
t159 = t96.*t113.*t115;
t160 = t97.*t113.*t114;
t161 = t98.*t117.*t118;
t162 = t99.*t116.*t118;
t163 = t100.*t116.*t117;
t164 = t101.*t120.*t121;
t165 = t102.*t119.*t121;
t166 = t103.*t119.*t120;
t167 = t104.*t123.*t124;
t168 = t105.*t122.*t124;
t169 = t106.*t122.*t123;
t170 = t107.*t126.*t127;
t171 = t108.*t125.*t127;
t172 = t109.*t125.*t126;
t173 = t110.*t129.*t130;
t174 = t111.*t128.*t130;
t175 = t112.*t128.*t129;
t176 = t113.*t114.*t115;
t177 = t116.*t117.*t118;
t178 = t119.*t120.*t121;
t179 = t122.*t123.*t124;
t180 = t125.*t126.*t127;
t181 = t128.*t129.*t130;
t182 = -t158;
t183 = -t160;
t184 = -t161;
t185 = -t163;
t186 = -t164;
t187 = -t166;
t188 = -t167;
t189 = -t169;
t190 = -t170;
t191 = -t172;
t192 = -t173;
t193 = -t175;
t194 = t134+t176;
t195 = t141+t159;
t196 = t135+t177;
t197 = t144+t162;
t198 = t136+t178;
t199 = t147+t165;
t200 = t137+t179;
t201 = t150+t168;
t202 = t138+t180;
t203 = t153+t171;
t204 = t139+t181;
t205 = t156+t174;
t206 = t194.^2;
t207 = t195.^2;
t208 = t196.^2;
t209 = t197.^2;
t210 = t198.^2;
t211 = t199.^2;
t212 = t200.^2;
t213 = t201.^2;
t214 = t202.^2;
t215 = t203.^2;
t216 = t204.^2;
t217 = t205.^2;
t218 = t140+t183;
t219 = t142+t182;
t220 = t143+t185;
t221 = t145+t184;
t222 = t146+t187;
t223 = t148+t186;
t224 = t149+t189;
t225 = t151+t188;
t226 = t152+t191;
t227 = t154+t190;
t228 = t155+t193;
t229 = t157+t192;
t255 = t194.*t195.*2.0;
t256 = t196.*t197.*2.0;
t257 = t198.*t199.*2.0;
t258 = t200.*t201.*2.0;
t259 = t202.*t203.*2.0;
t260 = t204.*t205.*2.0;
t230 = t218.^2;
t231 = t219.^2;
t232 = t220.^2;
t233 = t221.^2;
t234 = t222.^2;
t235 = t223.^2;
t236 = t224.^2;
t237 = t225.^2;
t238 = t226.^2;
t239 = t227.^2;
t240 = t228.^2;
t241 = t229.^2;
t242 = -t207;
t243 = -t209;
t244 = -t211;
t245 = -t213;
t246 = -t215;
t247 = -t217;
t261 = t194.*t218.*2.0;
t262 = t194.*t219.*2.0;
t263 = t195.*t218.*2.0;
t264 = t195.*t219.*2.0;
t265 = t196.*t221.*2.0;
t266 = t197.*t220.*2.0;
t267 = t198.*t223.*2.0;
t268 = t199.*t222.*2.0;
t269 = t200.*t225.*2.0;
t270 = t201.*t224.*2.0;
t271 = t202.*t227.*2.0;
t272 = t203.*t226.*2.0;
t273 = t204.*t229.*2.0;
t274 = t205.*t228.*2.0;
t282 = t218.*t219.*2.0;
t283 = t220.*t221.*2.0;
t284 = t222.*t223.*2.0;
t285 = t224.*t225.*2.0;
t286 = t226.*t227.*2.0;
t287 = t228.*t229.*2.0;
t248 = -t230;
t249 = -t231;
t250 = -t233;
t251 = -t235;
t252 = -t237;
t253 = -t239;
t254 = -t241;
t275 = -t263;
t276 = -t264;
t277 = -t266;
t278 = -t268;
t279 = -t270;
t280 = -t272;
t281 = -t274;
t288 = -t282;
t289 = t255+t282;
t290 = t261+t264;
t291 = t262+t263;
t292 = t256+t283;
t293 = t257+t284;
t294 = t258+t285;
t295 = t259+t286;
t296 = t260+t287;
t297 = t255+t288;
t298 = t261+t276;
t299 = t262+t275;
t300 = t265+t277;
t301 = t267+t278;
t302 = t269+t279;
t303 = t271+t280;
t304 = t273+t281;
t305 = rho1_1.*t289;
t306 = rho1_1.*t291;
t307 = rho1_2.*t289;
t308 = rho1_2.*t290;
t309 = rho1_3.*t290;
t310 = rho1_3.*t291;
t311 = rho2_1.*t289;
t312 = rho2_1.*t291;
t313 = rho2_2.*t289;
t314 = rho2_2.*t290;
t315 = rho2_3.*t290;
t316 = rho2_3.*t291;
t317 = rho3_1.*t289;
t318 = rho3_1.*t291;
t319 = rho3_2.*t289;
t320 = rho3_2.*t290;
t321 = rho3_3.*t290;
t322 = rho3_3.*t291;
t323 = rho4_1.*t289;
t324 = rho4_1.*t291;
t325 = rho4_2.*t289;
t326 = rho4_2.*t290;
t327 = rho4_3.*t290;
t328 = rho4_3.*t291;
t329 = rho5_1.*t289;
t330 = rho5_1.*t291;
t331 = rho5_2.*t289;
t332 = rho5_2.*t290;
t333 = rho5_3.*t290;
t334 = rho5_3.*t291;
t365 = X10.*X11.*t290;
t366 = X10.*X11.*t291;
t367 = X10.*X12.*t289;
t368 = X10.*X12.*t290;
t369 = X11.*X12.*t289;
t370 = X11.*X12.*t291;
t371 = X13.*X14.*fi1.*t292;
t372 = X13.*X15.*fi1.*t292;
t373 = X16.*X17.*fi2.*t293;
t374 = X16.*X18.*fi2.*t293;
t375 = X19.*X20.*fi3.*t294;
t376 = X19.*X21.*fi3.*t294;
t377 = X22.*X23.*fi4.*t295;
t378 = X22.*X24.*fi4.*t295;
t379 = X25.*X26.*fi5.*t296;
t380 = X25.*X27.*fi5.*t296;
t435 = t131.*t289;
t436 = t132.*t291;
t437 = t133.*t290;
t438 = fi1.*t80.*t292;
t439 = fi2.*t83.*t293;
t440 = fi3.*t86.*t294;
t441 = fi4.*t89.*t295;
t442 = fi5.*t92.*t296;
t451 = t206+t207+t248+t249;
t452 = t206+t230+t242+t249;
t453 = t206+t231+t242+t248;
t454 = t208+t232+t243+t250;
t455 = t210+t234+t244+t251;
t456 = t212+t236+t245+t252;
t457 = t214+t238+t246+t253;
dX = ft_1({Mi1_1,Mi1_2,Mi1_3,Mi2_1,Mi2_2,Mi2_3,Mi3_1,Mi3_2,Mi3_3,Mi4_1,Mi4_2,Mi4_3,Mi5_1,Mi5_2,Mi5_3,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22,X23,X24,X25,X26,X27,X28,X29,X30,X31,X32,X33,X34,X35,X36,X37,X38,X39,X40,X41,X42,X58,X59,X60,X61,X62,X63,X64,X65,X66,X67,X68,X69,X7,X70,X71,X72,X8,X9,ddX1,ddX2,ddX4,ddX5,ddX6,fi1,fi2,fi3,fi4,fi5,g,ji1_1,ji1_2,ji1_3,ji2_1,ji2_2,ji2_3,ji3_1,ji3_2,ji3_3,ji4_1,ji4_2,ji4_3,ji5_1,ji5_2,ji5_3,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,rho4_1,rho4_2,rho4_3,rho5_1,rho5_2,rho5_3,t10,t11,t12,t13,t131,t132,t133,t14,t15,t16,t17,t18,t19,t2,t20,t21,t216,t22,t23,t24,t240,t247,t25,t254,t297,t298,t299,t3,t300,t301,t302,t303,t304,t305,t306,t307,t308,t309,t310,t311,t312,t313,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t325,t326,t327,t328,t329,t330,t331,t332,t333,t334,t365,t366,t367,t368,t369,t370,t371,t372,t373,t374,t375,t376,t377,t378,t379,t380,t4,t435,t436,t437,t438,t439,t44,t440,t441,t442,t45,t451,t452,t453,t454,t455,t456,t457,t46,t47,t48,t49,t5,t50,t51,t52,t53,t54,t55,t56,t57,t58,t59,t6,t60,t61,t7,t8,t81,t82,t84,t85,t87,t88,t9,t90,t91,t93,t94});
end
function dX = ft_1(ct)
[Mi1_1,Mi1_2,Mi1_3,Mi2_1,Mi2_2,Mi2_3,Mi3_1,Mi3_2,Mi3_3,Mi4_1,Mi4_2,Mi4_3,Mi5_1,Mi5_2,Mi5_3,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22,X23,X24,X25,X26,X27,X28,X29,X30,X31,X32,X33,X34,X35,X36,X37,X38,X39,X40,X41,X42,X58,X59,X60,X61,X62,X63,X64,X65,X66,X67,X68,X69,X7,X70,X71,X72,X8,X9,ddX1,ddX2,ddX4,ddX5,ddX6,fi1,fi2,fi3,fi4,fi5,g,ji1_1,ji1_2,ji1_3,ji2_1,ji2_2,ji2_3,ji3_1,ji3_2,ji3_3,ji4_1,ji4_2,ji4_3,ji5_1,ji5_2,ji5_3,rho1_1,rho1_2,rho1_3,rho2_1,rho2_2,rho2_3,rho3_1,rho3_2,rho3_3,rho4_1,rho4_2,rho4_3,rho5_1,rho5_2,rho5_3,t10,t11,t12,t13,t131,t132,t133,t14,t15,t16,t17,t18,t19,t2,t20,t21,t216,t22,t23,t24,t240,t247,t25,t254,t297,t298,t299,t3,t300,t301,t302,t303,t304,t305,t306,t307,t308,t309,t310,t311,t312,t313,t314,t315,t316,t317,t318,t319,t320,t321,t322,t323,t324,t325,t326,t327,t328,t329,t330,t331,t332,t333,t334,t365,t366,t367,t368,t369,t370,t371,t372,t373,t374,t375,t376,t377,t378,t379,t380,t4,t435,t436,t437,t438,t439,t44,t440,t441,t442,t45,t451,t452,t453,t454,t455,t456,t457,t46,t47,t48,t49,t5,t50,t51,t52,t53,t54,t55,t56,t57,t58,t59,t6,t60,t61,t7,t8,t81,t82,t84,t85,t87,t88,t9,t90,t91,t93,t94] = ct{:};
t458 = t216+t240+t247+t254;
t335 = rho1_1.*t298;
t336 = rho1_1.*t299;
t337 = rho1_2.*t297;
t338 = rho1_2.*t299;
t339 = rho1_3.*t297;
t340 = rho1_3.*t298;
t341 = rho2_1.*t298;
t342 = rho2_1.*t299;
t343 = rho2_2.*t297;
t344 = rho2_2.*t299;
t345 = rho2_3.*t297;
t346 = rho2_3.*t298;
t347 = rho3_1.*t298;
t348 = rho3_1.*t299;
t349 = rho3_2.*t297;
t350 = rho3_2.*t299;
t351 = rho3_3.*t297;
t352 = rho3_3.*t298;
t353 = rho4_1.*t298;
t354 = rho4_1.*t299;
t355 = rho4_2.*t297;
t356 = rho4_2.*t299;
t357 = rho4_3.*t297;
t358 = rho4_3.*t298;
t359 = rho5_1.*t298;
t360 = rho5_1.*t299;
t361 = rho5_2.*t297;
t362 = rho5_2.*t299;
t363 = rho5_3.*t297;
t364 = rho5_3.*t298;
t391 = X10.*X11.*t297;
t392 = X10.*X11.*t298;
t393 = X10.*X12.*t297;
t394 = X10.*X12.*t299;
t395 = X11.*X12.*t298;
t396 = X11.*X12.*t299;
t397 = X13.*X14.*fi1.*t300;
t398 = X14.*X15.*fi1.*t300;
t399 = X16.*X17.*fi2.*t301;
t400 = X17.*X18.*fi2.*t301;
t401 = X19.*X20.*fi3.*t302;
t402 = X20.*X21.*fi3.*t302;
t403 = X22.*X23.*fi4.*t303;
t404 = X23.*X24.*fi4.*t303;
t405 = X25.*X26.*fi5.*t304;
t406 = X26.*X27.*fi5.*t304;
t422 = -t365;
t423 = -t367;
t424 = -t370;
t443 = t131.*t299;
t444 = t132.*t298;
t445 = t133.*t297;
t446 = fi1.*t81.*t300;
t447 = fi2.*t84.*t301;
t448 = fi3.*t87.*t302;
t449 = fi4.*t90.*t303;
t450 = fi5.*t93.*t304;
t464 = rho1_1.*t451;
t465 = rho1_1.*t452;
t466 = rho1_2.*t452;
t467 = rho1_2.*t453;
t468 = rho1_3.*t451;
t469 = rho1_3.*t453;
t470 = rho2_1.*t451;
t471 = rho2_1.*t452;
t472 = rho2_2.*t452;
t473 = rho2_2.*t453;
t474 = rho2_3.*t451;
t475 = rho2_3.*t453;
t476 = rho3_1.*t451;
t477 = rho3_1.*t452;
t478 = rho3_2.*t452;
t479 = rho3_2.*t453;
t480 = rho3_3.*t451;
t481 = rho3_3.*t453;
t482 = rho4_1.*t451;
t483 = rho4_1.*t452;
t484 = rho4_2.*t452;
t485 = rho4_2.*t453;
t486 = rho4_3.*t451;
t487 = rho4_3.*t453;
t488 = rho5_1.*t451;
t489 = rho5_1.*t452;
t490 = rho5_2.*t452;
t491 = rho5_2.*t453;
t492 = rho5_3.*t451;
t493 = rho5_3.*t453;
t494 = X10.*X11.*t451;
t495 = X10.*X11.*t453;
t496 = X10.*X12.*t452;
t497 = X10.*X12.*t453;
t498 = X11.*X12.*t451;
t499 = X11.*X12.*t452;
t500 = X13.*X15.*fi1.*t454;
t501 = X14.*X15.*fi1.*t454;
t502 = X16.*X18.*fi2.*t455;
t503 = X17.*X18.*fi2.*t455;
t504 = X19.*X21.*fi3.*t456;
t505 = X20.*X21.*fi3.*t456;
t506 = X22.*X24.*fi4.*t457;
t507 = X23.*X24.*fi4.*t457;
t508 = X25.*X27.*fi5.*t458;
t509 = X26.*X27.*fi5.*t458;
t513 = fi1.*t82.*t454;
t514 = fi2.*t85.*t455;
t515 = fi3.*t88.*t456;
t516 = fi4.*t91.*t457;
t517 = fi5.*t94.*t458;
t518 = t131.*t452;
t519 = t132.*t451;
t520 = t133.*t453;
t408 = -t337;
t411 = -t343;
t414 = -t349;
t417 = -t355;
t420 = -t361;
t425 = -t397;
t426 = -t398;
t427 = -t399;
t428 = -t400;
t429 = -t401;
t430 = -t402;
t431 = -t403;
t432 = -t404;
t433 = -t405;
t434 = -t406;
t459 = -t446;
t460 = -t447;
t461 = -t448;
t462 = -t449;
t463 = -t450;
t510 = -t494;
t511 = -t497;
t512 = -t499;
t521 = t307+t340;
t522 = t313+t346;
t523 = t319+t352;
t524 = t325+t358;
t525 = t331+t364;
t541 = -ddX5.*(t309-t336);
t543 = -ddX5.*(t315-t342);
t545 = -ddX5.*(t321-t348);
t547 = -ddX5.*(t327-t354);
t549 = -ddX5.*(t333-t360);
t556 = t308+t464;
t557 = t305+t469;
t558 = t314+t470;
t559 = t311+t475;
t560 = t320+t476;
t561 = t317+t481;
t562 = t326+t482;
t563 = t323+t487;
t564 = t332+t488;
t565 = t329+t493;
t566 = t338+t468;
t567 = t344+t474;
t568 = t350+t480;
t569 = t356+t486;
t570 = t362+t492;
t611 = -ddX5.*(t339-t465);
t612 = -ddX6.*(t335-t467);
t614 = -ddX5.*(t345-t471);
t615 = -ddX6.*(t341-t473);
t617 = -ddX5.*(t351-t477);
t618 = -ddX6.*(t347-t479);
t620 = -ddX5.*(t357-t483);
t621 = -ddX6.*(t353-t485);
t623 = -ddX5.*(t363-t489);
t624 = -ddX6.*(t359-t491);
t626 = ddX4.*(t310-t466);
t627 = ddX4.*(t316-t472);
t628 = ddX4.*(t322-t478);
t629 = ddX4.*(t328-t484);
t630 = ddX4.*(t334-t490);
t631 = t368+t443+t498;
t632 = t369+t444+t495;
t633 = t366+t445+t496;
t652 = t393+t424+t518;
t653 = t396+t422+t519;
t654 = t392+t423+t520;
t526 = ddX4.*t521;
t527 = ddX4.*t522;
t528 = ddX4.*t523;
t529 = ddX4.*t524;
t530 = ddX4.*t525;
t531 = t306+t408;
t533 = t312+t411;
t535 = t318+t414;
t537 = t324+t417;
t539 = t330+t420;
t576 = ddX5.*t557;
t577 = ddX6.*t556;
t578 = ddX5.*t559;
t579 = ddX6.*t558;
t580 = ddX5.*t561;
t581 = ddX6.*t560;
t582 = ddX5.*t563;
t583 = ddX6.*t562;
t584 = ddX5.*t565;
t585 = ddX6.*t564;
t596 = ddX4.*t566;
t597 = ddX4.*t567;
t598 = ddX4.*t568;
t599 = ddX4.*t569;
t600 = ddX4.*t570;
t634 = rho1_1.*t633;
t635 = rho1_2.*t632;
t636 = rho1_3.*t631;
t637 = rho2_1.*t633;
t638 = rho2_2.*t632;
t639 = rho2_3.*t631;
t640 = rho3_1.*t633;
t641 = rho3_2.*t632;
t642 = rho3_3.*t631;
t643 = rho4_1.*t633;
t644 = rho4_2.*t632;
t645 = rho4_3.*t631;
t646 = rho5_1.*t633;
t647 = rho5_2.*t632;
t648 = rho5_3.*t631;
t649 = t395+t435+t511;
t650 = t391+t436+t512;
t651 = t394+t437+t510;
t655 = t425+t438+t500;
t656 = t371+t459+t501;
t657 = t372+t426+t513;
t658 = t427+t439+t502;
t659 = t373+t460+t503;
t660 = t374+t428+t514;
t661 = t429+t440+t504;
t662 = t375+t461+t505;
t663 = t376+t430+t515;
t664 = t431+t441+t506;
t665 = t377+t462+t507;
t666 = t378+t432+t516;
t667 = t433+t442+t508;
t668 = t379+t463+t509;
t669 = t380+t434+t517;
t671 = rho1_1.*t654;
t673 = rho1_2.*t653;
t675 = rho1_3.*t652;
t677 = rho2_1.*t654;
t679 = rho2_2.*t653;
t681 = rho2_3.*t652;
t683 = rho3_1.*t654;
t685 = rho3_2.*t653;
t687 = rho3_3.*t652;
t689 = rho4_1.*t654;
t691 = rho4_2.*t653;
t693 = rho4_3.*t652;
t695 = rho5_1.*t654;
t697 = rho5_2.*t653;
t699 = rho5_3.*t652;
t542 = ddX6.*t531;
t544 = ddX6.*t533;
t546 = ddX6.*t535;
t548 = ddX6.*t537;
t550 = ddX6.*t539;
t602 = -t576;
t604 = -t578;
t606 = -t580;
t608 = -t582;
t610 = -t584;
t613 = -t596;
t616 = -t597;
t619 = -t598;
t622 = -t599;
t625 = -t600;
t670 = rho1_1.*t651;
t672 = rho1_2.*t650;
t674 = rho1_3.*t649;
t676 = rho2_1.*t651;
t678 = rho2_2.*t650;
t680 = rho2_3.*t649;
t682 = rho3_1.*t651;
t684 = rho3_2.*t650;
t686 = rho3_3.*t649;
t688 = rho4_1.*t651;
t690 = rho4_2.*t650;
t692 = rho4_3.*t649;
t694 = rho5_1.*t651;
t696 = rho5_2.*t650;
t698 = rho5_3.*t649;
t700 = -t673;
t702 = -t679;
t704 = -t685;
t706 = -t691;
t708 = -t697;
t551 = -t542;
t552 = -t544;
t553 = -t546;
t554 = -t548;
t555 = -t550;
t701 = -t674;
t703 = -t680;
t705 = -t686;
t707 = -t692;
t709 = -t698;
t710 = ddX2+t541+t577+t613+t636+t670+t700;
t711 = ddX2+t543+t579+t616+t639+t676+t702;
t712 = ddX2+t545+t581+t619+t642+t682+t704;
t713 = ddX2+t547+t583+t622+t645+t688+t706;
t714 = ddX2+t549+t585+t625+t648+t694+t708;
t715 = t44+t526+t602+t612+t635+t671+t701;
t716 = t44+t527+t604+t615+t638+t677+t703;
t717 = t44+t528+t606+t618+t641+t683+t705;
t718 = t44+t529+t608+t621+t644+t689+t707;
t719 = t44+t530+t610+t624+t647+t695+t709;
t720 = g+t45+t551+t611+t626+t634+t672+t675;
t721 = g+t45+t552+t614+t627+t637+t678+t681;
t722 = g+t45+t553+t617+t628+t640+t684+t687;
t723 = g+t45+t554+t620+t629+t643+t690+t693;
t724 = g+t45+t555+t623+t630+t646+t696+t699;
mt1 = [X7;X8;X9;t56.*(X10.*t3+X12.*t2.*t15+X11.*t14.*t15);X11.*t2-X12.*t14;t56.*(X12.*t2+X11.*t14);ddX1;-ddX2;t45;ddX4;-ddX5;-ddX6;-X14.*X30+X15.*X29;X13.*X30-X15.*X28;-X13.*X29+X14.*X28;-X17.*X33+X18.*X32;X16.*X33-X18.*X31;-X16.*X32+X17.*X31;-X20.*X36+X21.*X35;X19.*X36-X21.*X34;-X19.*X35+X20.*X34;-X23.*X39+X24.*X38;X22.*X39-X24.*X37;-X22.*X38+X23.*X37;-X26.*X42+X27.*X41;X25.*X42-X27.*X40;-X25.*X41+X26.*X40];
mt2 = [X15.*t46.*t710+X14.*t46.*t720+X14.*t46.*t51.*t657-X15.*t46.*t51.*t656;-X15.*t46.*t715-X13.*t46.*t720-X13.*t46.*t51.*t657+X15.*t46.*t51.*t655;-X13.*t46.*t710+X14.*t46.*t715+X13.*t46.*t51.*t656-X14.*t46.*t51.*t655;X18.*t47.*t711+X17.*t47.*t721+X17.*t47.*t52.*t660-X18.*t47.*t52.*t659;-X18.*t47.*t716-X16.*t47.*t721-X16.*t47.*t52.*t660+X18.*t47.*t52.*t658;-X16.*t47.*t711+X17.*t47.*t716+X16.*t47.*t52.*t659-X17.*t47.*t52.*t658;X21.*t48.*t712+X20.*t48.*t722+X20.*t48.*t53.*t663-X21.*t48.*t53.*t662;-X21.*t48.*t717-X19.*t48.*t722-X19.*t48.*t53.*t663+X21.*t48.*t53.*t661];
mt3 = [-X19.*t48.*t712+X20.*t48.*t717+X19.*t48.*t53.*t662-X20.*t48.*t53.*t661;X24.*t49.*t713+X23.*t49.*t723+X23.*t49.*t54.*t666-X24.*t49.*t54.*t665;-X24.*t49.*t718-X22.*t49.*t723-X22.*t49.*t54.*t666+X24.*t49.*t54.*t664;-X22.*t49.*t713+X23.*t49.*t718+X22.*t49.*t54.*t665-X23.*t49.*t54.*t664;X27.*t50.*t714+X26.*t50.*t724+X26.*t50.*t55.*t669-X27.*t50.*t55.*t668;-X27.*t50.*t719-X25.*t50.*t724-X25.*t50.*t55.*t669+X27.*t50.*t55.*t667;-X25.*t50.*t714+X26.*t50.*t719+X25.*t50.*t55.*t668-X26.*t50.*t55.*t667;t57.*(X58.*t5+X60.*t4.*t17+X59.*t16.*t17);X59.*t4-X60.*t16;t57.*(X60.*t4+X59.*t16)];
mt4 = [t58.*(X61.*t7+X63.*t6.*t19+X62.*t18.*t19);X62.*t6-X63.*t18;t58.*(X63.*t6+X62.*t18);t59.*(X64.*t9+X66.*t8.*t21+X65.*t20.*t21);X65.*t8-X66.*t20;t59.*(X66.*t8+X65.*t20);t60.*(X67.*t11+X69.*t10.*t23+X68.*t22.*t23);X68.*t10-X69.*t22;t60.*(X69.*t10+X68.*t22);t61.*(X70.*t13+X72.*t12.*t25+X71.*t24.*t25);X71.*t12-X72.*t24;t61.*(X72.*t12+X71.*t24);(Mi1_1+X59.*X60.*ji1_2-X59.*X60.*ji1_3)./ji1_1;-(Mi1_2+X58.*X60.*ji1_1-X58.*X60.*ji1_3)./ji1_2;-(Mi1_3-X58.*X59.*ji1_1+X58.*X59.*ji1_2)./ji1_3;(Mi2_1+X62.*X63.*ji2_2-X62.*X63.*ji2_3)./ji2_1];
mt5 = [-(Mi2_2+X61.*X63.*ji2_1-X61.*X63.*ji2_3)./ji2_2;-(Mi2_3-X61.*X62.*ji2_1+X61.*X62.*ji2_2)./ji2_3;(Mi3_1+X65.*X66.*ji3_2-X65.*X66.*ji3_3)./ji3_1;-(Mi3_2+X64.*X66.*ji3_1-X64.*X66.*ji3_3)./ji3_2;-(Mi3_3-X64.*X65.*ji3_1+X64.*X65.*ji3_2)./ji3_3;(Mi4_1+X68.*X69.*ji4_2-X68.*X69.*ji4_3)./ji4_1;-(Mi4_2+X67.*X69.*ji4_1-X67.*X69.*ji4_3)./ji4_2;-(Mi4_3-X67.*X68.*ji4_1+X67.*X68.*ji4_2)./ji4_3;(Mi5_1+X71.*X72.*ji5_2-X71.*X72.*ji5_3)./ji5_1;-(Mi5_2+X70.*X72.*ji5_1-X70.*X72.*ji5_3)./ji5_2];
mt6 = [-(Mi5_3-X70.*X71.*ji5_1+X70.*X71.*ji5_2)./ji5_3];
dX = [mt1;mt2;mt3;mt4;mt5;mt6];
end
