function A = Addx0do0_3(in1,in2,in3,in4)
%Addx0do0_3
%    A = Addx0do0_3(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/07/03 14:04:13

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
mi1 = in4(:,18);
mi2 = in4(:,19);
mi3 = in4(:,20);
qi1_1 = in1(14,:);
qi1_2 = in1(15,:);
qi1_3 = in1(16,:);
qi2_1 = in1(17,:);
qi2_2 = in1(18,:);
qi2_3 = in1(19,:);
qi3_1 = in1(20,:);
qi3_2 = in1(21,:);
qi3_3 = in1(22,:);
rho1_1 = in4(:,6);
rho1_2 = in4(:,7);
rho1_3 = in4(:,8);
rho2_1 = in4(:,9);
rho2_2 = in4(:,10);
rho2_3 = in4(:,11);
rho3_1 = in4(:,12);
rho3_2 = in4(:,13);
rho3_3 = in4(:,14);
t2 = qi1_1.^2;
t3 = qi1_2.^2;
t4 = qi1_3.^2;
t5 = qi2_1.^2;
t6 = qi2_2.^2;
t7 = qi2_3.^2;
t8 = qi3_1.^2;
t9 = qi3_2.^2;
t10 = qi3_3.^2;
t11 = R01_1.*mi1.*rho1_2;
t12 = R01_2.*mi1.*rho1_1;
t13 = R01_1.*mi1.*rho1_3;
t14 = R01_3.*mi1.*rho1_1;
t15 = R01_2.*mi1.*rho1_3;
t16 = R01_3.*mi1.*rho1_2;
t17 = R02_1.*mi1.*rho1_2;
t18 = R02_2.*mi1.*rho1_1;
t19 = R01_1.*mi2.*rho2_2;
t20 = R01_2.*mi2.*rho2_1;
t21 = R02_1.*mi1.*rho1_3;
t22 = R02_3.*mi1.*rho1_1;
t23 = R01_1.*mi2.*rho2_3;
t24 = R01_3.*mi2.*rho2_1;
t25 = R02_2.*mi1.*rho1_3;
t26 = R02_3.*mi1.*rho1_2;
t27 = R01_2.*mi2.*rho2_3;
t28 = R01_3.*mi2.*rho2_2;
t29 = R03_1.*mi1.*rho1_2;
t30 = R03_2.*mi1.*rho1_1;
t31 = R02_1.*mi2.*rho2_2;
t32 = R02_2.*mi2.*rho2_1;
t33 = R03_1.*mi1.*rho1_3;
t34 = R03_3.*mi1.*rho1_1;
t35 = R01_1.*mi3.*rho3_2;
t36 = R01_2.*mi3.*rho3_1;
t37 = R02_1.*mi2.*rho2_3;
t38 = R02_3.*mi2.*rho2_1;
t39 = R03_2.*mi1.*rho1_3;
t40 = R03_3.*mi1.*rho1_2;
t41 = R01_1.*mi3.*rho3_3;
t42 = R01_3.*mi3.*rho3_1;
t43 = R02_2.*mi2.*rho2_3;
t44 = R02_3.*mi2.*rho2_2;
t45 = R01_2.*mi3.*rho3_3;
t46 = R01_3.*mi3.*rho3_2;
t47 = R03_1.*mi2.*rho2_2;
t48 = R03_2.*mi2.*rho2_1;
t49 = R02_1.*mi3.*rho3_2;
t50 = R02_2.*mi3.*rho3_1;
t51 = R03_1.*mi2.*rho2_3;
t52 = R03_3.*mi2.*rho2_1;
t53 = R02_1.*mi3.*rho3_3;
t54 = R02_3.*mi3.*rho3_1;
t55 = R03_2.*mi2.*rho2_3;
t56 = R03_3.*mi2.*rho2_2;
t57 = R02_2.*mi3.*rho3_3;
t58 = R02_3.*mi3.*rho3_2;
t59 = R03_1.*mi3.*rho3_2;
t60 = R03_2.*mi3.*rho3_1;
t61 = R03_1.*mi3.*rho3_3;
t62 = R03_3.*mi3.*rho3_1;
t63 = R03_2.*mi3.*rho3_3;
t64 = R03_3.*mi3.*rho3_2;
t65 = mi1.*qi1_1.*qi1_2;
t66 = mi1.*qi1_1.*qi1_3;
t67 = mi1.*qi1_2.*qi1_3;
t68 = mi2.*qi2_1.*qi2_2;
t69 = mi2.*qi2_1.*qi2_3;
t70 = mi2.*qi2_2.*qi2_3;
t71 = mi3.*qi3_1.*qi3_2;
t72 = mi3.*qi3_1.*qi3_3;
t73 = mi3.*qi3_2.*qi3_3;
t74 = R01_1.*t65;
t75 = R01_1.*t66;
t76 = R01_2.*t65;
t77 = R01_2.*t66;
t78 = R01_3.*t65;
t79 = R01_3.*t66;
t80 = R02_1.*t65;
t81 = R02_2.*t65;
t82 = R02_1.*t67;
t83 = R02_3.*t65;
t84 = R02_2.*t67;
t85 = R02_3.*t67;
t86 = R01_1.*t68;
t87 = R03_1.*t66;
t88 = R01_1.*t69;
t89 = R01_2.*t68;
t90 = R03_1.*t67;
t91 = R03_2.*t66;
t92 = R01_2.*t69;
t93 = R01_3.*t68;
t94 = R03_2.*t67;
t95 = R03_3.*t66;
t96 = R01_3.*t69;
t97 = R03_3.*t67;
t98 = R02_1.*t68;
t99 = R02_2.*t68;
t100 = R02_1.*t70;
t101 = R02_3.*t68;
t102 = R02_2.*t70;
t103 = R02_3.*t70;
t104 = R01_1.*t71;
t105 = R03_1.*t69;
t106 = R01_1.*t72;
t107 = R01_2.*t71;
t108 = R03_1.*t70;
t109 = R03_2.*t69;
t110 = R01_2.*t72;
t111 = R01_3.*t71;
t112 = R03_2.*t70;
t113 = R03_3.*t69;
t114 = R01_3.*t72;
t115 = R03_3.*t70;
t116 = R02_1.*t71;
t117 = R02_2.*t71;
t118 = R02_1.*t73;
t119 = R02_3.*t71;
t120 = R02_2.*t73;
t121 = R02_3.*t73;
t122 = R03_1.*t72;
t123 = R03_1.*t73;
t124 = R03_2.*t72;
t125 = R03_2.*t73;
t126 = R03_3.*t72;
t127 = R03_3.*t73;
t128 = -t12;
t129 = -t14;
t130 = -t16;
t131 = -t18;
t132 = -t20;
t133 = -t22;
t134 = -t24;
t135 = -t26;
t136 = -t28;
t137 = -t30;
t138 = -t32;
t139 = -t34;
t140 = -t36;
t141 = -t38;
t142 = -t40;
t143 = -t42;
t144 = -t44;
t145 = -t46;
t146 = -t48;
t147 = -t50;
t148 = -t52;
t149 = -t54;
t150 = -t56;
t151 = -t58;
t152 = -t60;
t153 = -t62;
t154 = -t64;
t155 = R01_1.*mi1.*t2;
t156 = R01_2.*mi1.*t2;
t157 = R01_3.*mi1.*t2;
t158 = R01_1.*mi2.*t5;
t159 = R02_1.*mi1.*t3;
t160 = R01_2.*mi2.*t5;
t161 = R02_2.*mi1.*t3;
t162 = R01_3.*mi2.*t5;
t163 = R02_3.*mi1.*t3;
t164 = R01_1.*mi3.*t8;
t165 = R02_1.*mi2.*t6;
t166 = R03_1.*mi1.*t4;
t167 = R01_2.*mi3.*t8;
t168 = R02_2.*mi2.*t6;
t169 = R03_2.*mi1.*t4;
t170 = R01_3.*mi3.*t8;
t171 = R02_3.*mi2.*t6;
t172 = R03_3.*mi1.*t4;
t173 = R02_1.*mi3.*t9;
t174 = R03_1.*mi2.*t7;
t175 = R02_2.*mi3.*t9;
t176 = R03_2.*mi2.*t7;
t177 = R02_3.*mi3.*t9;
t178 = R03_3.*mi2.*t7;
t179 = R03_1.*mi3.*t10;
t180 = R03_2.*mi3.*t10;
t181 = R03_3.*mi3.*t10;
t236 = t65+t68+t71;
t237 = t66+t69+t72;
t238 = t67+t70+t73;
t182 = t11+t128;
t183 = t13+t129;
t184 = t15+t130;
t185 = t17+t131;
t186 = t19+t132;
t187 = t21+t133;
t188 = t23+t134;
t189 = t25+t135;
t190 = t27+t136;
t191 = t29+t137;
t192 = t31+t138;
t193 = t33+t139;
t194 = t35+t140;
t195 = t37+t141;
t196 = t39+t142;
t197 = t41+t143;
t198 = t43+t144;
t199 = t45+t145;
t200 = t47+t146;
t201 = t49+t147;
t202 = t51+t148;
t203 = t53+t149;
t204 = t55+t150;
t205 = t57+t151;
t206 = t59+t152;
t207 = t61+t153;
t208 = t63+t154;
t239 = t80+t87+t155;
t240 = t74+t90+t159;
t241 = t81+t91+t156;
t242 = t75+t82+t166;
t243 = t76+t94+t161;
t244 = t83+t95+t157;
t245 = t77+t84+t169;
t246 = t78+t97+t163;
t247 = t79+t85+t172;
t248 = t98+t105+t158;
t249 = t86+t108+t165;
t250 = t99+t109+t160;
t251 = t88+t100+t174;
t252 = t89+t112+t168;
t253 = t101+t113+t162;
t254 = t92+t102+t176;
t255 = t93+t115+t171;
t256 = t96+t103+t178;
t257 = t116+t122+t164;
t258 = t104+t123+t173;
t259 = t117+t124+t167;
t260 = t106+t118+t179;
t261 = t107+t125+t175;
t262 = t119+t126+t170;
t263 = t110+t120+t180;
t264 = t111+t127+t177;
t265 = t114+t121+t181;
t209 = qi1_1.*t182;
t210 = qi1_1.*t183;
t211 = qi1_1.*t184;
t212 = qi1_2.*t185;
t213 = qi1_2.*t187;
t214 = qi1_2.*t189;
t215 = qi2_1.*t186;
t216 = qi2_1.*t188;
t217 = qi2_1.*t190;
t218 = qi1_3.*t191;
t219 = qi1_3.*t193;
t220 = qi1_3.*t196;
t221 = qi2_2.*t192;
t222 = qi2_2.*t195;
t223 = qi2_2.*t198;
t224 = qi3_1.*t194;
t225 = qi3_1.*t197;
t226 = qi3_1.*t199;
t227 = qi2_3.*t200;
t228 = qi2_3.*t202;
t229 = qi2_3.*t204;
t230 = qi3_2.*t201;
t231 = qi3_2.*t203;
t232 = qi3_2.*t205;
t233 = qi3_3.*t206;
t234 = qi3_3.*t207;
t235 = qi3_3.*t208;
t266 = t209+t212+t218;
t267 = t210+t213+t219;
t268 = t211+t214+t220;
t269 = t215+t221+t227;
t270 = t216+t222+t228;
t271 = t217+t223+t229;
t272 = t224+t230+t233;
t273 = t225+t231+t234;
t274 = t226+t232+t235;
t275 = R01_1.*qi1_1.*t266;
t276 = R01_2.*qi1_1.*t266;
t277 = R01_3.*qi1_1.*t266;
t278 = R01_1.*qi1_1.*t267;
t279 = R01_2.*qi1_1.*t267;
t280 = R01_3.*qi1_1.*t267;
t281 = R02_1.*qi1_2.*t266;
t282 = R01_1.*qi1_1.*t268;
t283 = R02_2.*qi1_2.*t266;
t284 = R01_2.*qi1_1.*t268;
t285 = R02_3.*qi1_2.*t266;
t286 = R01_3.*qi1_1.*t268;
t287 = R02_1.*qi1_2.*t267;
t288 = R02_2.*qi1_2.*t267;
t289 = R02_3.*qi1_2.*t267;
t290 = R03_1.*qi1_3.*t266;
t291 = R02_1.*qi1_2.*t268;
t292 = R03_2.*qi1_3.*t266;
t293 = R02_2.*qi1_2.*t268;
t294 = R03_3.*qi1_3.*t266;
t295 = R02_3.*qi1_2.*t268;
t296 = R03_1.*qi1_3.*t267;
t297 = R03_2.*qi1_3.*t267;
t298 = R03_3.*qi1_3.*t267;
t299 = R03_1.*qi1_3.*t268;
t300 = R03_2.*qi1_3.*t268;
t301 = R03_3.*qi1_3.*t268;
t302 = R01_1.*qi2_1.*t269;
t303 = R01_2.*qi2_1.*t269;
t304 = R01_3.*qi2_1.*t269;
t305 = R01_1.*qi2_1.*t270;
t306 = R01_2.*qi2_1.*t270;
t307 = R01_3.*qi2_1.*t270;
t308 = R02_1.*qi2_2.*t269;
t309 = R01_1.*qi2_1.*t271;
t310 = R02_2.*qi2_2.*t269;
t311 = R01_2.*qi2_1.*t271;
t312 = R02_3.*qi2_2.*t269;
t313 = R01_3.*qi2_1.*t271;
t314 = R02_1.*qi2_2.*t270;
t315 = R02_2.*qi2_2.*t270;
t316 = R02_3.*qi2_2.*t270;
t317 = R03_1.*qi2_3.*t269;
t318 = R02_1.*qi2_2.*t271;
t319 = R03_2.*qi2_3.*t269;
t320 = R02_2.*qi2_2.*t271;
t321 = R03_3.*qi2_3.*t269;
t322 = R02_3.*qi2_2.*t271;
t323 = R03_1.*qi2_3.*t270;
t324 = R03_2.*qi2_3.*t270;
t325 = R03_3.*qi2_3.*t270;
t326 = R03_1.*qi2_3.*t271;
t327 = R03_2.*qi2_3.*t271;
t328 = R03_3.*qi2_3.*t271;
t329 = R01_1.*qi3_1.*t272;
t330 = R01_2.*qi3_1.*t272;
t331 = R01_3.*qi3_1.*t272;
t332 = R01_1.*qi3_1.*t273;
t333 = R01_2.*qi3_1.*t273;
t334 = R01_3.*qi3_1.*t273;
t335 = R02_1.*qi3_2.*t272;
t336 = R01_1.*qi3_1.*t274;
t337 = R02_2.*qi3_2.*t272;
t338 = R01_2.*qi3_1.*t274;
t339 = R02_3.*qi3_2.*t272;
t340 = R01_3.*qi3_1.*t274;
t341 = R02_1.*qi3_2.*t273;
t342 = R02_2.*qi3_2.*t273;
t343 = R02_3.*qi3_2.*t273;
t344 = R03_1.*qi3_3.*t272;
t345 = R02_1.*qi3_2.*t274;
t346 = R03_2.*qi3_3.*t272;
t347 = R02_2.*qi3_2.*t274;
t348 = R03_3.*qi3_3.*t272;
t349 = R02_3.*qi3_2.*t274;
t350 = R03_1.*qi3_3.*t273;
t351 = R03_2.*qi3_3.*t273;
t352 = R03_3.*qi3_3.*t273;
t353 = R03_1.*qi3_3.*t274;
t354 = R03_2.*qi3_3.*t274;
t355 = R03_3.*qi3_3.*t274;
t356 = t275+t281+t290;
t357 = t276+t283+t292;
t358 = t277+t285+t294;
t359 = t278+t287+t296;
t360 = t279+t288+t297;
t361 = t280+t289+t298;
t362 = t282+t291+t299;
t363 = t284+t293+t300;
t364 = t286+t295+t301;
t365 = t302+t308+t317;
t366 = t303+t310+t319;
t367 = t304+t312+t321;
t368 = t305+t314+t323;
t369 = t306+t315+t324;
t370 = t307+t316+t325;
t371 = t309+t318+t326;
t372 = t311+t320+t327;
t373 = t313+t322+t328;
t374 = t329+t335+t344;
t375 = t330+t337+t346;
t376 = t331+t339+t348;
t377 = t332+t341+t350;
t378 = t333+t342+t351;
t379 = t334+t343+t352;
t380 = t336+t345+t353;
t381 = t338+t347+t354;
t382 = t340+t349+t355;
mt1 = [m0+mi1.*t2+mi2.*t5+mi3.*t8,t236,t237,-qi1_1.*t268-qi2_1.*t271-qi3_1.*t274,qi1_1.*t267+qi2_1.*t270+qi3_1.*t273,-qi1_1.*t266-qi2_1.*t269-qi3_1.*t272,t236,m0+mi1.*t3+mi2.*t6+mi3.*t9,t238,-qi1_2.*t268-qi2_2.*t271-qi3_2.*t274,qi1_2.*t267+qi2_2.*t270+qi3_2.*t273,-qi1_2.*t266-qi2_2.*t269-qi3_2.*t272,t237,t238,m0+mi1.*t4+mi2.*t7+mi3.*t10,-qi1_3.*t268-qi2_3.*t271-qi3_3.*t274,qi1_3.*t267+qi2_3.*t270+qi3_3.*t273,-qi1_3.*t266-qi2_3.*t269-qi3_3.*t272,-rho1_3.*t241+rho1_2.*t244-rho2_3.*t250+rho2_2.*t253-rho3_3.*t259+rho3_2.*t262];
mt2 = [-rho1_3.*t243+rho1_2.*t246-rho2_3.*t252+rho2_2.*t255-rho3_3.*t261+rho3_2.*t264,-rho1_3.*t245+rho1_2.*t247-rho2_3.*t254+rho2_2.*t256-rho3_3.*t263+rho3_2.*t265,j01-rho1_2.*t364+rho1_3.*t363-rho2_2.*t373+rho2_3.*t372-rho3_2.*t382+rho3_3.*t381,rho1_2.*t361-rho1_3.*t360+rho2_2.*t370-rho2_3.*t369+rho3_2.*t379-rho3_3.*t378,-rho1_2.*t358+rho1_3.*t357-rho2_2.*t367+rho2_3.*t366-rho3_2.*t376+rho3_3.*t375,rho1_3.*t239-rho1_1.*t244+rho2_3.*t248-rho2_1.*t253+rho3_3.*t257-rho3_1.*t262,rho1_3.*t240-rho1_1.*t246+rho2_3.*t249-rho2_1.*t255+rho3_3.*t258-rho3_1.*t264];
mt3 = [rho1_3.*t242-rho1_1.*t247+rho2_3.*t251-rho2_1.*t256+rho3_3.*t260-rho3_1.*t265,rho1_1.*t364-rho1_3.*t362+rho2_1.*t373-rho2_3.*t371+rho3_1.*t382-rho3_3.*t380,j02-rho1_1.*t361+rho1_3.*t359-rho2_1.*t370+rho2_3.*t368-rho3_1.*t379+rho3_3.*t377,rho1_1.*t358-rho1_3.*t356+rho2_1.*t367-rho2_3.*t365+rho3_1.*t376-rho3_3.*t374,-rho1_2.*t239+rho1_1.*t241-rho2_2.*t248+rho2_1.*t250-rho3_2.*t257+rho3_1.*t259,-rho1_2.*t240+rho1_1.*t243-rho2_2.*t249+rho2_1.*t252-rho3_2.*t258+rho3_1.*t261,-rho1_2.*t242+rho1_1.*t245-rho2_2.*t251+rho2_1.*t254-rho3_2.*t260+rho3_1.*t263];
mt4 = [-rho1_1.*t363+rho1_2.*t362-rho2_1.*t372+rho2_2.*t371-rho3_1.*t381+rho3_2.*t380,rho1_1.*t360-rho1_2.*t359+rho2_1.*t369-rho2_2.*t368+rho3_1.*t378-rho3_2.*t377,j03-rho1_1.*t357+rho1_2.*t356-rho2_1.*t366+rho2_2.*t365-rho3_1.*t375+rho3_2.*t374];
A = reshape([mt1,mt2,mt3,mt4],6,6);
end
