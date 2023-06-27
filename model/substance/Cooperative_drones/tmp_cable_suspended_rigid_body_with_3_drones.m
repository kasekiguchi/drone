function dX = tmp_cable_suspended_rigid_body_with_3_drones(in1,in2,in3,in4)
%TMP_CABLE_SUSPENDED_RIGID_BODY_WITH_3_DRONES
%    dX = TMP_CABLE_SUSPENDED_RIGID_BODY_WITH_3_DRONES(IN1,IN2,IN3,IN4)

%    This function was generated by the Symbolic Math Toolbox version 9.1.
%    27-Jun-2023 15:55:10

Mi1_1 = in2(2,:);
Mi1_2 = in2(3,:);
Mi1_3 = in2(4,:);
Mi2_1 = in2(6,:);
Mi2_2 = in2(7,:);
Mi2_3 = in2(8,:);
Mi3_1 = in2(10,:);
Mi3_2 = in2(11,:);
Mi3_3 = in2(12,:);
ddX1 = in4(1,:);
ddX2 = in4(2,:);
ddX3 = in4(3,:);
ddX4 = in4(4,:);
ddX5 = in4(5,:);
ddX6 = in4(6,:);
dx01 = in1(8,:);
dx02 = in1(9,:);
dx03 = in1(10,:);
fi1 = in2(1,:);
fi2 = in2(5,:);
fi3 = in2(9,:);
g = in3(:,1);
ji1_1 = in3(:,21);
ji1_2 = in3(:,22);
ji1_3 = in3(:,23);
ji2_1 = in3(:,24);
ji2_2 = in3(:,25);
ji2_3 = in3(:,26);
ji3_1 = in3(:,27);
ji3_2 = in3(:,28);
ji3_3 = in3(:,29);
li1 = in3(:,15);
li2 = in3(:,16);
li3 = in3(:,17);
mi1 = in3(:,18);
mi2 = in3(:,19);
mi3 = in3(:,20);
o01 = in1(11,:);
o02 = in1(12,:);
o03 = in1(13,:);
oi1_1 = in1(44,:);
oi1_2 = in1(45,:);
oi1_3 = in1(46,:);
oi2_1 = in1(47,:);
oi2_2 = in1(48,:);
oi2_3 = in1(49,:);
oi3_1 = in1(50,:);
oi3_2 = in1(51,:);
oi3_3 = in1(52,:);
qi1_1 = in1(14,:);
qi1_2 = in1(15,:);
qi1_3 = in1(16,:);
qi2_1 = in1(17,:);
qi2_2 = in1(18,:);
qi2_3 = in1(19,:);
qi3_1 = in1(20,:);
qi3_2 = in1(21,:);
qi3_3 = in1(22,:);
r01 = in1(4,:);
r02 = in1(5,:);
r03 = in1(6,:);
r04 = in1(7,:);
rho1_1 = in3(:,6);
rho1_2 = in3(:,7);
rho1_3 = in3(:,8);
rho2_1 = in3(:,9);
rho2_2 = in3(:,10);
rho2_3 = in3(:,11);
rho3_1 = in3(:,12);
rho3_2 = in3(:,13);
rho3_3 = in3(:,14);
ri1_1 = in1(32,:);
ri1_2 = in1(33,:);
ri1_3 = in1(34,:);
ri1_4 = in1(35,:);
ri2_1 = in1(36,:);
ri2_2 = in1(37,:);
ri2_3 = in1(38,:);
ri2_4 = in1(39,:);
ri3_1 = in1(40,:);
ri3_2 = in1(41,:);
ri3_3 = in1(42,:);
ri3_4 = in1(43,:);
wi1_1 = in1(23,:);
wi1_2 = in1(24,:);
wi1_3 = in1(25,:);
wi2_1 = in1(26,:);
wi2_2 = in1(27,:);
wi2_3 = in1(28,:);
wi3_1 = in1(29,:);
wi3_2 = in1(30,:);
wi3_3 = in1(31,:);
t2 = o01.^2;
t3 = o02.^2;
t4 = o03.^2;
t5 = qi1_1.^2;
t6 = qi1_2.^2;
t7 = qi1_3.^2;
t8 = qi2_1.^2;
t9 = qi2_2.^2;
t10 = qi2_3.^2;
t11 = qi3_1.^2;
t12 = qi3_2.^2;
t13 = qi3_3.^2;
t14 = r01.^2;
t15 = r02.^2;
t16 = r03.^2;
t17 = r04.^2;
t18 = ri1_1.^2;
t19 = ri1_2.^2;
t20 = ri1_3.^2;
t21 = ri1_4.^2;
t22 = ri2_1.^2;
t23 = ri2_2.^2;
t24 = ri2_3.^2;
t25 = ri2_4.^2;
t26 = ri3_1.^2;
t27 = ri3_2.^2;
t28 = ri3_3.^2;
t29 = ri3_4.^2;
t30 = r01.*r02.*2.0;
t31 = r01.*r03.*2.0;
t32 = r01.*r04.*2.0;
t33 = r02.*r03.*2.0;
t34 = r02.*r04.*2.0;
t35 = r03.*r04.*2.0;
t36 = ri1_1.*ri1_2.*2.0;
t37 = ri1_1.*ri1_3.*2.0;
t38 = ri1_2.*ri1_4.*2.0;
t39 = ri1_3.*ri1_4.*2.0;
t40 = ri2_1.*ri2_2.*2.0;
t41 = ri2_1.*ri2_3.*2.0;
t42 = ri2_2.*ri2_4.*2.0;
t43 = ri2_3.*ri2_4.*2.0;
t44 = ri3_1.*ri3_2.*2.0;
t45 = ri3_1.*ri3_3.*2.0;
t46 = ri3_2.*ri3_4.*2.0;
t47 = ri3_3.*ri3_4.*2.0;
t48 = -g;
t49 = 1.0./li1;
t50 = 1.0./li2;
t51 = 1.0./li3;
t52 = 1.0./mi1;
t53 = 1.0./mi2;
t54 = 1.0./mi3;
t55 = -t33;
t56 = -t34;
t57 = -t35;
t58 = -t39;
t59 = -t43;
t60 = -t47;
t61 = t5-1.0;
t62 = t6-1.0;
t63 = t7-1.0;
t64 = t8-1.0;
t65 = t9-1.0;
t66 = t10-1.0;
t67 = t11-1.0;
t68 = t12-1.0;
t69 = t13-1.0;
t70 = -t15;
t71 = -t16;
t72 = -t17;
t73 = -t19;
t74 = -t20;
t75 = -t23;
t76 = -t24;
t77 = -t27;
t78 = -t28;
t79 = t2+t3;
t80 = t2+t4;
t81 = t3+t4;
t82 = t30+t35;
t83 = t31+t34;
t84 = t32+t33;
t85 = t37+t38;
t86 = t41+t42;
t87 = t45+t46;
t88 = t30+t57;
t89 = t31+t56;
t90 = t32+t55;
t91 = t36+t58;
t92 = t40+t59;
t93 = t44+t60;
t94 = rho1_1.*t82;
t95 = rho1_1.*t83;
t96 = rho1_2.*t83;
t97 = rho1_2.*t84;
t98 = rho1_3.*t82;
t99 = rho1_3.*t84;
t100 = rho2_1.*t82;
t101 = rho2_1.*t83;
t102 = rho2_2.*t83;
t103 = rho2_2.*t84;
t104 = rho2_3.*t82;
t105 = rho2_3.*t84;
t106 = rho3_1.*t82;
t107 = rho3_1.*t83;
t108 = rho3_2.*t83;
t109 = rho3_2.*t84;
t110 = rho3_3.*t82;
t111 = rho3_3.*t84;
t112 = o01.*o02.*t82;
t113 = o01.*o02.*t84;
t114 = o01.*o03.*t83;
t115 = o01.*o03.*t84;
t116 = o02.*o03.*t82;
t117 = o02.*o03.*t83;
t142 = fi1.*qi1_1.*qi1_2.*t85;
t143 = fi1.*qi1_1.*qi1_3.*t85;
t144 = fi2.*qi2_1.*qi2_2.*t86;
t145 = fi2.*qi2_1.*qi2_3.*t86;
t146 = fi3.*qi3_1.*qi3_2.*t87;
t147 = fi3.*qi3_1.*qi3_3.*t87;
t172 = t79.*t83;
t173 = t80.*t82;
t174 = t81.*t84;
t175 = fi1.*t61.*t85;
t176 = fi2.*t64.*t86;
t177 = fi3.*t67.*t87;
t184 = t14+t17+t70+t71;
t185 = t14+t16+t70+t72;
t186 = t14+t15+t71+t72;
t187 = t18+t21+t73+t74;
t188 = t22+t25+t75+t76;
t189 = t26+t29+t77+t78;
t118 = rho1_1.*t88;
t119 = rho1_1.*t90;
t120 = rho1_2.*t88;
t121 = rho1_2.*t89;
t122 = rho1_3.*t89;
t123 = rho1_3.*t90;
t124 = rho2_1.*t88;
t125 = rho2_1.*t90;
t126 = rho2_2.*t88;
t127 = rho2_2.*t89;
t128 = rho2_3.*t89;
t129 = rho2_3.*t90;
t130 = rho3_1.*t88;
t131 = rho3_1.*t90;
t132 = rho3_2.*t88;
t133 = rho3_2.*t89;
t134 = rho3_3.*t89;
t135 = rho3_3.*t90;
t136 = o01.*o02.*t89;
t137 = o01.*o02.*t90;
t138 = o01.*o03.*t88;
t139 = o01.*o03.*t89;
t140 = o02.*o03.*t88;
t141 = o02.*o03.*t90;
t148 = -t95;
t149 = -t97;
t150 = -t98;
t151 = -t101;
t152 = -t103;
t153 = -t104;
t154 = -t107;
t155 = -t109;
t156 = -t110;
t157 = -t113;
t158 = -t114;
t159 = -t116;
t160 = fi1.*qi1_1.*qi1_2.*t91;
t161 = fi1.*qi1_2.*qi1_3.*t91;
t162 = fi2.*qi2_1.*qi2_2.*t92;
t163 = fi2.*qi2_2.*qi2_3.*t92;
t164 = fi3.*qi3_1.*qi3_2.*t93;
t165 = fi3.*qi3_2.*qi3_3.*t93;
t178 = t79.*t88;
t179 = t80.*t90;
t180 = t81.*t89;
t181 = fi1.*t62.*t91;
t182 = fi2.*t65.*t92;
t183 = fi3.*t68.*t93;
t193 = rho1_1.*t184;
t194 = rho1_1.*t185;
t195 = rho1_2.*t184;
t196 = rho1_2.*t186;
t197 = rho1_3.*t185;
t198 = rho1_3.*t186;
t199 = rho2_1.*t184;
t200 = rho2_1.*t185;
t201 = rho2_2.*t184;
t202 = rho2_2.*t186;
t203 = rho2_3.*t185;
t204 = rho2_3.*t186;
t205 = rho3_1.*t184;
t206 = rho3_1.*t185;
t207 = rho3_2.*t184;
t208 = rho3_2.*t186;
t209 = rho3_3.*t185;
t210 = rho3_3.*t186;
t211 = o01.*o02.*t185;
t212 = o01.*o02.*t186;
t213 = o01.*o03.*t184;
t214 = o01.*o03.*t186;
t215 = o02.*o03.*t184;
t216 = o02.*o03.*t185;
t217 = fi1.*qi1_1.*qi1_3.*t187;
t218 = fi1.*qi1_2.*qi1_3.*t187;
t219 = fi2.*qi2_1.*qi2_3.*t188;
t220 = fi2.*qi2_2.*qi2_3.*t188;
t221 = fi3.*qi3_1.*qi3_3.*t189;
t222 = fi3.*qi3_2.*qi3_3.*t189;
t244 = fi1.*t63.*t187;
t245 = fi2.*t66.*t188;
t246 = fi3.*t69.*t189;
t247 = t79.*t184;
t248 = t80.*t185;
t249 = t81.*t186;
t166 = -t160;
t167 = -t161;
t168 = -t162;
t169 = -t163;
t170 = -t164;
t171 = -t165;
t190 = -t181;
t191 = -t182;
t192 = -t183;
t223 = -t211;
t224 = -t214;
t225 = -t215;
t226 = t94+t121;
t227 = t99+t118;
t228 = t96+t123;
t229 = t100+t127;
t230 = t105+t124;
t231 = t102+t129;
t232 = t106+t133;
t233 = t111+t130;
t234 = t108+t135;
t250 = t119+t196;
t251 = t122+t193;
t252 = t120+t197;
t253 = t125+t202;
t254 = t128+t199;
t255 = t126+t203;
t256 = t131+t208;
t257 = t134+t205;
t258 = t132+t209;
t259 = t149+t194;
t260 = t148+t198;
t261 = t150+t195;
t262 = t152+t200;
t263 = t151+t204;
t264 = t153+t201;
t265 = t155+t206;
t266 = t154+t210;
t267 = t156+t207;
t277 = -ddX4.*(t98-t195);
t278 = -ddX5.*(t95-t198);
t279 = -ddX6.*(t97-t194);
t280 = -ddX4.*(t104-t201);
t281 = -ddX5.*(t101-t204);
t282 = -ddX6.*(t103-t200);
t283 = -ddX4.*(t110-t207);
t284 = -ddX5.*(t107-t210);
t285 = -ddX6.*(t109-t206);
t295 = t115+t178+t216;
t296 = t117+t179+t212;
t297 = t112+t180+t213;
t310 = t139+t159+t247;
t311 = t140+t157+t248;
t312 = t137+t158+t249;
t235 = ddX4.*t228;
t236 = ddX5.*t227;
t237 = ddX6.*t226;
t238 = ddX4.*t231;
t239 = ddX5.*t230;
t240 = ddX6.*t229;
t241 = ddX4.*t234;
t242 = ddX5.*t233;
t243 = ddX6.*t232;
t268 = ddX4.*t252;
t269 = ddX5.*t251;
t270 = ddX6.*t250;
t271 = ddX4.*t255;
t272 = ddX5.*t254;
t273 = ddX6.*t253;
t274 = ddX4.*t258;
t275 = ddX5.*t257;
t276 = ddX6.*t256;
t298 = rho1_1.*t297;
t299 = rho1_2.*t296;
t300 = rho1_3.*t295;
t301 = rho2_1.*t297;
t302 = rho2_2.*t296;
t303 = rho2_3.*t295;
t304 = rho3_1.*t297;
t305 = rho3_2.*t296;
t306 = rho3_3.*t295;
t307 = t141+t172+t224;
t308 = t136+t173+t225;
t309 = t138+t174+t223;
t314 = rho1_1.*t312;
t316 = rho1_2.*t311;
t318 = rho1_3.*t310;
t320 = rho2_1.*t312;
t322 = rho2_2.*t311;
t324 = rho2_3.*t310;
t326 = rho3_1.*t312;
t328 = rho3_2.*t311;
t330 = rho3_3.*t310;
t331 = t166+t175+t217;
t332 = t142+t190+t218;
t333 = t143+t167+t244;
t334 = t168+t176+t219;
t335 = t144+t191+t220;
t336 = t145+t169+t245;
t337 = t170+t177+t221;
t338 = t146+t192+t222;
t339 = t147+t171+t246;
t286 = -t268;
t287 = -t269;
t288 = -t270;
t289 = -t271;
t290 = -t272;
t291 = -t273;
t292 = -t274;
t293 = -t275;
t294 = -t276;
t313 = rho1_1.*t309;
t315 = rho1_2.*t308;
t317 = rho1_3.*t307;
t319 = rho2_1.*t309;
t321 = rho2_2.*t308;
t323 = rho2_3.*t307;
t325 = rho3_1.*t309;
t327 = rho3_2.*t308;
t329 = rho3_3.*t307;
t341 = -t314;
t343 = -t316;
t345 = -t318;
t347 = -t320;
t349 = -t322;
t351 = -t324;
t353 = -t326;
t355 = -t328;
t357 = -t330;
t340 = -t313;
t342 = -t315;
t344 = -t317;
t346 = -t319;
t348 = -t321;
t350 = -t323;
t352 = -t325;
t354 = -t327;
t356 = -t329;
mt1 = [dx01;dx02;dx03;o01.*r02.*(-1.0./2.0)-(o02.*r03)./2.0-(o03.*r04)./2.0;(o01.*r01)./2.0-(o02.*r04)./2.0+(o03.*r03)./2.0;(o02.*r01)./2.0+(o01.*r04)./2.0-(o03.*r02)./2.0;o01.*r03.*(-1.0./2.0)+(o02.*r02)./2.0+(o03.*r01)./2.0;ddX1;ddX2;ddX3;ddX4;ddX5;ddX6;-qi1_2.*wi1_3+qi1_3.*wi1_2;qi1_1.*wi1_3-qi1_3.*wi1_1;-qi1_1.*wi1_2+qi1_2.*wi1_1;-qi2_2.*wi2_3+qi2_3.*wi2_2;qi2_1.*wi2_3-qi2_3.*wi2_1;-qi2_1.*wi2_2+qi2_2.*wi2_1;-qi3_2.*wi3_3+qi3_3.*wi3_2;qi3_1.*wi3_3-qi3_3.*wi3_1;-qi3_1.*wi3_2+qi3_2.*wi3_1];
mt2 = [-qi1_2.*t49.*(-ddX3+g-t237+t269-t298+t315+t318+ddX4.*(t98-t195))+qi1_3.*t49.*(-ddX2-t236+t268-t300+t313+t316+ddX6.*(t97-t194))-qi1_2.*t49.*t52.*t333+qi1_3.*t49.*t52.*t332;qi1_1.*t49.*(-ddX3+g-t237+t269-t298+t315+t318+ddX4.*(t98-t195))-qi1_3.*t49.*(-ddX1-t235+t270-t299+t314+t317+ddX5.*(t95-t198))+qi1_1.*t49.*t52.*t333-qi1_3.*t49.*t52.*t331];
mt3 = [-qi1_1.*t49.*(-ddX2-t236+t268-t300+t313+t316+ddX6.*(t97-t194))+qi1_2.*t49.*(-ddX1-t235+t270-t299+t314+t317+ddX5.*(t95-t198))-qi1_1.*t49.*t52.*t332+qi1_2.*t49.*t52.*t331;-qi2_2.*t50.*(-ddX3+g-t240+t272-t301+t321+t324+ddX4.*(t104-t201))+qi2_3.*t50.*(-ddX2-t239+t271-t303+t319+t322+ddX6.*(t103-t200))-qi2_2.*t50.*t53.*t336+qi2_3.*t50.*t53.*t335];
mt4 = [qi2_1.*t50.*(-ddX3+g-t240+t272-t301+t321+t324+ddX4.*(t104-t201))-qi2_3.*t50.*(-ddX1-t238+t273-t302+t320+t323+ddX5.*(t101-t204))+qi2_1.*t50.*t53.*t336-qi2_3.*t50.*t53.*t334;-qi2_1.*t50.*(-ddX2-t239+t271-t303+t319+t322+ddX6.*(t103-t200))+qi2_2.*t50.*(-ddX1-t238+t273-t302+t320+t323+ddX5.*(t101-t204))-qi2_1.*t50.*t53.*t335+qi2_2.*t50.*t53.*t334];
mt5 = [-qi3_2.*t51.*(-ddX3+g-t243+t275-t304+t327+t330+ddX4.*(t110-t207))+qi3_3.*t51.*(-ddX2-t242+t274-t306+t325+t328+ddX6.*(t109-t206))-qi3_2.*t51.*t54.*t339+qi3_3.*t51.*t54.*t338;qi3_1.*t51.*(-ddX3+g-t243+t275-t304+t327+t330+ddX4.*(t110-t207))-qi3_3.*t51.*(-ddX1-t241+t276-t305+t326+t329+ddX5.*(t107-t210))+qi3_1.*t51.*t54.*t339-qi3_3.*t51.*t54.*t337];
mt6 = [-qi3_1.*t51.*(-ddX2-t242+t274-t306+t325+t328+ddX6.*(t109-t206))+qi3_2.*t51.*(-ddX1-t241+t276-t305+t326+t329+ddX5.*(t107-t210))-qi3_1.*t51.*t54.*t338+qi3_2.*t51.*t54.*t337;oi1_1.*ri1_2.*(-1.0./2.0)-(oi1_2.*ri1_3)./2.0-(oi1_3.*ri1_4)./2.0;(oi1_1.*ri1_1)./2.0-(oi1_2.*ri1_4)./2.0+(oi1_3.*ri1_3)./2.0;(oi1_2.*ri1_1)./2.0+(oi1_1.*ri1_4)./2.0-(oi1_3.*ri1_2)./2.0;oi1_1.*ri1_3.*(-1.0./2.0)+(oi1_2.*ri1_2)./2.0+(oi1_3.*ri1_1)./2.0;oi2_1.*ri2_2.*(-1.0./2.0)-(oi2_2.*ri2_3)./2.0-(oi2_3.*ri2_4)./2.0;(oi2_1.*ri2_1)./2.0-(oi2_2.*ri2_4)./2.0+(oi2_3.*ri2_3)./2.0];
mt7 = [(oi2_2.*ri2_1)./2.0+(oi2_1.*ri2_4)./2.0-(oi2_3.*ri2_2)./2.0;oi2_1.*ri2_3.*(-1.0./2.0)+(oi2_2.*ri2_2)./2.0+(oi2_3.*ri2_1)./2.0;oi3_1.*ri3_2.*(-1.0./2.0)-(oi3_2.*ri3_3)./2.0-(oi3_3.*ri3_4)./2.0;(oi3_1.*ri3_1)./2.0-(oi3_2.*ri3_4)./2.0+(oi3_3.*ri3_3)./2.0;(oi3_2.*ri3_1)./2.0+(oi3_1.*ri3_4)./2.0-(oi3_3.*ri3_2)./2.0;oi3_1.*ri3_3.*(-1.0./2.0)+(oi3_2.*ri3_2)./2.0+(oi3_3.*ri3_1)./2.0;(Mi1_1+ji1_2.*oi1_2.*oi1_3-ji1_3.*oi1_2.*oi1_3)./ji1_1;(Mi1_2-ji1_1.*oi1_1.*oi1_3+ji1_3.*oi1_1.*oi1_3)./ji1_2;(Mi1_3+ji1_1.*oi1_1.*oi1_2-ji1_2.*oi1_1.*oi1_2)./ji1_3;(Mi2_1+ji2_2.*oi2_2.*oi2_3-ji2_3.*oi2_2.*oi2_3)./ji2_1];
mt8 = [(Mi2_2-ji2_1.*oi2_1.*oi2_3+ji2_3.*oi2_1.*oi2_3)./ji2_2;(Mi2_3+ji2_1.*oi2_1.*oi2_2-ji2_2.*oi2_1.*oi2_2)./ji2_3;(Mi3_1+ji3_2.*oi3_2.*oi3_3-ji3_3.*oi3_2.*oi3_3)./ji3_1;(Mi3_2-ji3_1.*oi3_1.*oi3_3+ji3_3.*oi3_1.*oi3_3)./ji3_2;(Mi3_3+ji3_1.*oi3_1.*oi3_2-ji3_2.*oi3_1.*oi3_2)./ji3_3];
dX = [mt1;mt2;mt3;mt4;mt5;mt6;mt7;mt8];
