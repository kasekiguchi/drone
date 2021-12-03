function U2 = Us(in1,in2,in3,in4,in5)
%US
%    U2 = US(IN1,IN2,IN3,IN4,IN5)

%    This function was generated by the Symbolic Math Toolbox version 8.7.
%    16-Nov-2021 15:24:03

Lx = in5(:,2);
Ly = in5(:,3);
V1 = in3(:,1);
V2 = in4(1,:);
V3 = in4(2,:);
V4 = in4(3,:);
dV1 = in3(:,2);
ddV1 = in3(:,3);
ddXd3 = in2(:,11);
ddXd4 = in2(:,12);
dddXd3 = in2(:,15);
ddddXd1 = in2(:,17);
ddddXd2 = in2(:,18);
ddddXd3 = in2(:,19);
gravity = in5(:,9);
jx = in5(:,6);
jy = in5(:,7);
jz = in5(:,8);
km1 = in5(:,10);
km2 = in5(:,11);
km3 = in5(:,12);
km4 = in5(:,13);
lx = in5(:,4);
ly = in5(:,5);
m = in5(:,1);
o1 = in1(11,:);
o2 = in1(12,:);
o3 = in1(13,:);
q0 = in1(1,:);
q1 = in1(2,:);
q2 = in1(3,:);
q3 = in1(4,:);
t2 = dV1+dddXd3;
t3 = ddV1+ddddXd3;
t4 = q0.^2;
t5 = q0.^3;
t6 = q1.^2;
t8 = q1.^3;
t9 = q2.^2;
t11 = q2.^3;
t12 = q3.^2;
t14 = q3.^3;
t16 = q0.*q1.*2.0;
t17 = q0.*q2.*2.0;
t18 = q0.*q3.*2.0;
t19 = q1.*q2.*2.0;
t20 = q1.*q3.*2.0;
t21 = q2.*q3.*2.0;
t22 = V1+ddXd3+gravity;
t23 = -jy;
t24 = -jz;
t25 = 1.0./jx;
t26 = 1.0./jy;
t27 = 1.0./jz;
t48 = (o1.*q0)./2.0;
t49 = (o1.*q1)./2.0;
t50 = (o2.*q0)./2.0;
t51 = (o1.*q2)./2.0;
t52 = (o2.*q1)./2.0;
t53 = (o3.*q0)./2.0;
t54 = (o1.*q3)./2.0;
t55 = (o2.*q2)./2.0;
t56 = (o3.*q1)./2.0;
t57 = (o2.*q3)./2.0;
t58 = (o3.*q2)./2.0;
t59 = (o3.*q3)./2.0;
t63 = q0.*q1.*q2.*q3.*8.0;
t7 = t4.^2;
t10 = t6.^2;
t13 = t9.^2;
t15 = t12.^2;
t28 = -t21;
t29 = km1.*t4;
t30 = km1.*t6;
t31 = km2.*t4;
t32 = km1.*t9;
t33 = km2.*t6;
t34 = km3.*t4;
t35 = km1.*t12;
t36 = km2.*t9;
t37 = km3.*t6;
t38 = km4.*t4;
t39 = km2.*t12;
t40 = km3.*t9;
t41 = km4.*t6;
t42 = km3.*t12;
t43 = km4.*t9;
t44 = km4.*t12;
t45 = -t6;
t46 = -t9;
t47 = -t12;
t60 = jx+t23;
t61 = jx+t24;
t62 = jy+t24;
t64 = -t51;
t65 = -t56;
t66 = -t57;
t99 = t4.*t6.*2.0;
t100 = t4.*t9.*2.0;
t101 = t4.*t12.*2.0;
t102 = t6.*t9.*2.0;
t103 = t6.*t12.*2.0;
t104 = t9.*t12.*2.0;
t171 = Lx.*Ly.*jz.*q0.*t8.*2.0;
t172 = Lx.*Ly.*jz.*q1.*t5.*2.0;
t173 = Lx.*Ly.*jz.*q2.*t14.*2.0;
t174 = Lx.*Ly.*jz.*q3.*t11.*2.0;
t175 = Lx.*jy.*km1.*q0.*t14.*2.0;
t176 = Lx.*jy.*km1.*q1.*t11.*2.0;
t177 = Lx.*jy.*km1.*q3.*t5.*2.0;
t178 = Lx.*jy.*km1.*q2.*t8.*2.0;
t179 = Ly.*jx.*km1.*q0.*t14.*2.0;
t180 = Ly.*jx.*km1.*q1.*t11.*2.0;
t181 = Ly.*jx.*km1.*q3.*t5.*2.0;
t182 = Ly.*jx.*km1.*q2.*t8.*2.0;
t183 = Lx.*jy.*km2.*q0.*t14.*2.0;
t184 = Lx.*jy.*km2.*q1.*t11.*2.0;
t185 = Lx.*jy.*km2.*q3.*t5.*2.0;
t186 = Lx.*jy.*km2.*q2.*t8.*2.0;
t187 = Ly.*jx.*km2.*q0.*t14.*2.0;
t188 = Ly.*jx.*km2.*q1.*t11.*2.0;
t189 = Ly.*jx.*km2.*q3.*t5.*2.0;
t190 = Ly.*jx.*km2.*q2.*t8.*2.0;
t191 = Lx.*jy.*km3.*q0.*t14.*2.0;
t192 = Lx.*jy.*km3.*q1.*t11.*2.0;
t193 = Lx.*jy.*km3.*q3.*t5.*2.0;
t194 = Lx.*jy.*km3.*q2.*t8.*2.0;
t195 = Ly.*jx.*km3.*q0.*t14.*2.0;
t196 = Ly.*jx.*km3.*q1.*t11.*2.0;
t197 = Ly.*jx.*km3.*q3.*t5.*2.0;
t198 = Ly.*jx.*km3.*q2.*t8.*2.0;
t199 = Lx.*jy.*km4.*q0.*t14.*2.0;
t200 = Lx.*jy.*km4.*q1.*t11.*2.0;
t201 = Lx.*jy.*km4.*q3.*t5.*2.0;
t202 = Lx.*jy.*km4.*q2.*t8.*2.0;
t203 = Ly.*jx.*km4.*q0.*t14.*2.0;
t204 = Ly.*jx.*km4.*q1.*t11.*2.0;
t205 = Ly.*jx.*km4.*q3.*t5.*2.0;
t206 = Ly.*jx.*km4.*q2.*t8.*2.0;
t207 = t17+t20;
t208 = t18+t19;
t209 = Lx.*Ly.*jz.*t9.*t16;
t210 = Lx.*Ly.*jz.*t12.*t16;
t211 = Lx.*Ly.*jz.*q0.*q2.*t6.*4.0;
t212 = Lx.*Ly.*jz.*t4.*t21;
t213 = Lx.*Ly.*jz.*q1.*q3.*t4.*4.0;
t214 = Lx.*Ly.*jz.*t6.*t21;
t215 = Lx.*Ly.*jz.*q0.*q2.*t12.*4.0;
t216 = Lx.*Ly.*jz.*q1.*q3.*t9.*4.0;
t270 = Lx.*Ly.*jz.*q0.*q1.*t9.*-2.0;
t271 = Lx.*Ly.*jz.*q0.*q1.*t12.*-2.0;
t272 = Lx.*Ly.*jz.*q2.*q3.*t4.*-2.0;
t273 = Lx.*Ly.*jz.*q2.*q3.*t6.*-2.0;
t404 = t49+t55+t59;
t67 = Lx.*jy.*km1.*t7;
t68 = Ly.*jx.*km1.*t7;
t69 = Lx.*jy.*km1.*t10;
t70 = Lx.*jy.*km2.*t7;
t71 = Ly.*jx.*km1.*t10;
t72 = Ly.*jx.*km2.*t7;
t73 = Lx.*jy.*km1.*t13;
t74 = Lx.*jy.*km2.*t10;
t75 = Lx.*jy.*km3.*t7;
t76 = Ly.*jx.*km1.*t13;
t77 = Ly.*jx.*km2.*t10;
t78 = Ly.*jx.*km3.*t7;
t79 = Lx.*jy.*km1.*t15;
t80 = Lx.*jy.*km2.*t13;
t81 = Lx.*jy.*km3.*t10;
t82 = Lx.*jy.*km4.*t7;
t83 = Ly.*jx.*km1.*t15;
t84 = Ly.*jx.*km2.*t13;
t85 = Ly.*jx.*km3.*t10;
t86 = Ly.*jx.*km4.*t7;
t87 = Lx.*jy.*km2.*t15;
t88 = Lx.*jy.*km3.*t13;
t89 = Lx.*jy.*km4.*t10;
t90 = Ly.*jx.*km2.*t15;
t91 = Ly.*jx.*km3.*t13;
t92 = Ly.*jx.*km4.*t10;
t93 = Lx.*jy.*km3.*t15;
t94 = Lx.*jy.*km4.*t13;
t95 = Ly.*jx.*km3.*t15;
t96 = Ly.*jx.*km4.*t13;
t97 = Lx.*jy.*km4.*t15;
t98 = Ly.*jx.*km4.*t15;
t105 = Lx.*Ly.*V1.*km1.*t7;
t106 = Lx.*Ly.*V1.*km1.*t10;
t107 = Lx.*Ly.*V1.*km2.*t7;
t108 = Lx.*Ly.*V1.*km1.*t13;
t109 = Lx.*Ly.*V1.*km2.*t10;
t110 = Lx.*Ly.*V1.*km3.*t7;
t111 = Lx.*Ly.*V1.*km1.*t15;
t112 = Lx.*Ly.*V1.*km2.*t13;
t113 = Lx.*Ly.*V1.*km3.*t10;
t114 = Lx.*Ly.*V1.*km4.*t7;
t115 = Lx.*Ly.*V1.*km2.*t15;
t116 = Lx.*Ly.*V1.*km3.*t13;
t117 = Lx.*Ly.*V1.*km4.*t10;
t118 = Lx.*Ly.*V1.*km3.*t15;
t119 = Lx.*Ly.*V1.*km4.*t13;
t120 = Lx.*Ly.*V1.*km4.*t15;
t121 = Lx.*Ly.*ddXd3.*km1.*t7;
t122 = Lx.*Ly.*ddXd3.*km1.*t10;
t123 = Lx.*Ly.*ddXd3.*km2.*t7;
t124 = Lx.*Ly.*ddXd3.*km1.*t13;
t125 = Lx.*Ly.*ddXd3.*km2.*t10;
t126 = Lx.*Ly.*ddXd3.*km3.*t7;
t127 = Lx.*Ly.*ddXd3.*km1.*t15;
t128 = Lx.*Ly.*ddXd3.*km2.*t13;
t129 = Lx.*Ly.*ddXd3.*km3.*t10;
t130 = Lx.*Ly.*ddXd3.*km4.*t7;
t131 = Lx.*Ly.*ddXd3.*km2.*t15;
t132 = Lx.*Ly.*ddXd3.*km3.*t13;
t133 = Lx.*Ly.*ddXd3.*km4.*t10;
t134 = Lx.*Ly.*ddXd3.*km3.*t15;
t135 = Lx.*Ly.*ddXd3.*km4.*t13;
t136 = Lx.*Ly.*ddXd3.*km4.*t15;
t137 = Lx.*Ly.*gravity.*km1.*t7;
t138 = Lx.*Ly.*gravity.*km1.*t10;
t139 = Lx.*Ly.*gravity.*km2.*t7;
t140 = Lx.*Ly.*gravity.*km1.*t13;
t141 = Lx.*Ly.*gravity.*km2.*t10;
t142 = Lx.*Ly.*gravity.*km3.*t7;
t143 = Lx.*Ly.*gravity.*km1.*t15;
t144 = Lx.*Ly.*gravity.*km2.*t13;
t145 = Lx.*Ly.*gravity.*km3.*t10;
t146 = Lx.*Ly.*gravity.*km4.*t7;
t147 = Lx.*Ly.*gravity.*km2.*t15;
t148 = Lx.*Ly.*gravity.*km3.*t13;
t149 = Lx.*Ly.*gravity.*km4.*t10;
t150 = Lx.*Ly.*gravity.*km3.*t15;
t151 = Lx.*Ly.*gravity.*km4.*t13;
t152 = Lx.*Ly.*gravity.*km4.*t15;
t153 = -t100;
t154 = -t103;
t155 = Lx.*km1.*t10.*t23;
t157 = Lx.*km2.*t10.*t23;
t160 = Lx.*km1.*t15.*t23;
t161 = Lx.*km3.*t10.*t23;
t164 = Lx.*km2.*t15.*t23;
t165 = Lx.*km4.*t10.*t23;
t168 = Lx.*km3.*t15.*t23;
t170 = Lx.*km4.*t15.*t23;
t217 = Lx.*jy.*t19.*t29;
t218 = Ly.*jx.*t19.*t29;
t219 = Lx.*jy.*t18.*t30;
t220 = Lx.*jy.*t19.*t31;
t221 = Ly.*jx.*t18.*t30;
t222 = Ly.*jx.*t19.*t31;
t223 = Lx.*jy.*t18.*t32;
t224 = Lx.*jy.*t18.*t33;
t225 = Lx.*jy.*t19.*t34;
t226 = Ly.*jx.*t18.*t32;
t227 = Ly.*jx.*t18.*t33;
t228 = Ly.*jx.*t19.*t34;
t229 = Lx.*jy.*t19.*t35;
t230 = Lx.*jy.*t18.*t36;
t231 = Lx.*jy.*t18.*t37;
t232 = Lx.*jy.*t19.*t38;
t233 = Ly.*jx.*t19.*t35;
t234 = Ly.*jx.*t18.*t36;
t235 = Ly.*jx.*t18.*t37;
t236 = Ly.*jx.*t19.*t38;
t237 = Lx.*jy.*t19.*t39;
t238 = Lx.*jy.*t18.*t40;
t239 = Lx.*jy.*t18.*t41;
t240 = Ly.*jx.*t19.*t39;
t241 = Ly.*jx.*t18.*t40;
t242 = Ly.*jx.*t18.*t41;
t243 = Lx.*jy.*t19.*t42;
t244 = Lx.*jy.*t18.*t43;
t245 = Ly.*jx.*t19.*t42;
t246 = Ly.*jx.*t18.*t43;
t247 = Lx.*jy.*t19.*t44;
t248 = Ly.*jx.*t19.*t44;
t249 = -t171;
t250 = -t172;
t251 = -t173;
t252 = -t174;
t253 = -t176;
t254 = -t178;
t255 = -t179;
t256 = -t180;
t257 = -t181;
t258 = -t182;
t259 = -t184;
t260 = -t186;
t261 = -t191;
t262 = -t193;
t263 = -t195;
t264 = -t196;
t265 = -t197;
t266 = -t198;
t267 = -t199;
t268 = -t201;
t269 = t16+t28;
t274 = Ly.*jx.*t6.*t29.*2.0;
t275 = Lx.*jy.*t9.*t29.*2.0;
t276 = Ly.*jx.*t6.*t31.*2.0;
t277 = Lx.*jy.*t9.*t31.*2.0;
t278 = Ly.*jx.*t6.*t34.*2.0;
t279 = Lx.*jy.*t12.*t30.*2.0;
t280 = Lx.*jy.*t9.*t34.*2.0;
t281 = Ly.*jx.*t6.*t38.*2.0;
t282 = Lx.*jy.*t12.*t33.*2.0;
t283 = Lx.*jy.*t9.*t38.*2.0;
t284 = Ly.*jx.*t12.*t32.*2.0;
t285 = Lx.*jy.*t12.*t37.*2.0;
t286 = Ly.*jx.*t12.*t36.*2.0;
t287 = Lx.*jy.*t12.*t41.*2.0;
t288 = Ly.*jx.*t12.*t40.*2.0;
t289 = Ly.*jx.*t12.*t43.*2.0;
t290 = Ly.*jx.*q1.*q2.*t29.*-2.0;
t291 = Lx.*jy.*q0.*q3.*t30.*-2.0;
t292 = Ly.*jx.*q0.*q3.*t30.*-2.0;
t293 = Ly.*jx.*q1.*q2.*t31.*-2.0;
t294 = Lx.*jy.*q0.*q3.*t32.*-2.0;
t295 = Lx.*jy.*q0.*q3.*t33.*-2.0;
t296 = Lx.*jy.*q1.*q2.*t34.*-2.0;
t297 = Ly.*jx.*q0.*q3.*t32.*-2.0;
t298 = Ly.*jx.*q0.*q3.*t33.*-2.0;
t299 = Ly.*jx.*q1.*q2.*t34.*-2.0;
t300 = Lx.*jy.*q0.*q3.*t36.*-2.0;
t301 = Lx.*jy.*q1.*q2.*t38.*-2.0;
t302 = Ly.*jx.*q1.*q2.*t35.*-2.0;
t303 = Ly.*jx.*q0.*q3.*t36.*-2.0;
t304 = Ly.*jx.*q0.*q3.*t37.*-2.0;
t305 = Ly.*jx.*q1.*q2.*t38.*-2.0;
t306 = Ly.*jx.*q1.*q2.*t39.*-2.0;
t307 = Ly.*jx.*q0.*q3.*t40.*-2.0;
t308 = Ly.*jx.*q0.*q3.*t41.*-2.0;
t309 = Lx.*jy.*q1.*q2.*t42.*-2.0;
t310 = Ly.*jx.*q1.*q2.*t42.*-2.0;
t311 = Ly.*jx.*q0.*q3.*t43.*-2.0;
t312 = Lx.*jy.*q1.*q2.*t44.*-2.0;
t313 = Ly.*jx.*q1.*q2.*t44.*-2.0;
t314 = t208.^2;
t323 = Lx.*Ly.*V1.*t6.*t29.*2.0;
t324 = Lx.*Ly.*V1.*t9.*t29.*2.0;
t325 = Lx.*Ly.*V1.*t6.*t31.*2.0;
t326 = Lx.*Ly.*V1.*t12.*t29.*2.0;
t327 = Lx.*Ly.*V1.*t9.*t30.*2.0;
t328 = Lx.*Ly.*V1.*t9.*t31.*2.0;
t329 = Lx.*Ly.*V1.*t6.*t34.*2.0;
t330 = Lx.*Ly.*V1.*t12.*t30.*2.0;
t331 = Lx.*Ly.*V1.*t12.*t31.*2.0;
t332 = Lx.*Ly.*V1.*t9.*t33.*2.0;
t333 = Lx.*Ly.*V1.*t9.*t34.*2.0;
t334 = Lx.*Ly.*V1.*t6.*t38.*2.0;
t335 = Lx.*Ly.*V1.*t12.*t32.*2.0;
t336 = Lx.*Ly.*V1.*t12.*t33.*2.0;
t337 = Lx.*Ly.*V1.*t12.*t34.*2.0;
t338 = Lx.*Ly.*V1.*t9.*t37.*2.0;
t339 = Lx.*Ly.*V1.*t9.*t38.*2.0;
t340 = Lx.*Ly.*V1.*t12.*t36.*2.0;
t341 = Lx.*Ly.*V1.*t12.*t37.*2.0;
t342 = Lx.*Ly.*V1.*t12.*t38.*2.0;
t343 = Lx.*Ly.*V1.*t9.*t41.*2.0;
t344 = Lx.*Ly.*V1.*t12.*t40.*2.0;
t345 = Lx.*Ly.*V1.*t12.*t41.*2.0;
t346 = Lx.*Ly.*V1.*t12.*t43.*2.0;
t347 = Lx.*Ly.*ddXd3.*t6.*t29.*2.0;
t348 = Lx.*Ly.*ddXd3.*t9.*t29.*2.0;
t349 = Lx.*Ly.*ddXd3.*t6.*t31.*2.0;
t350 = Lx.*Ly.*ddXd3.*t12.*t29.*2.0;
t351 = Lx.*Ly.*ddXd3.*t9.*t30.*2.0;
t352 = Lx.*Ly.*ddXd3.*t9.*t31.*2.0;
t353 = Lx.*Ly.*ddXd3.*t6.*t34.*2.0;
t354 = Lx.*Ly.*ddXd3.*t12.*t30.*2.0;
t355 = Lx.*Ly.*ddXd3.*t12.*t31.*2.0;
t356 = Lx.*Ly.*ddXd3.*t9.*t33.*2.0;
t357 = Lx.*Ly.*ddXd3.*t9.*t34.*2.0;
t358 = Lx.*Ly.*ddXd3.*t6.*t38.*2.0;
t359 = Lx.*Ly.*ddXd3.*t12.*t32.*2.0;
t360 = Lx.*Ly.*ddXd3.*t12.*t33.*2.0;
t361 = Lx.*Ly.*ddXd3.*t12.*t34.*2.0;
t362 = Lx.*Ly.*ddXd3.*t9.*t37.*2.0;
t363 = Lx.*Ly.*ddXd3.*t9.*t38.*2.0;
t364 = Lx.*Ly.*ddXd3.*t12.*t36.*2.0;
t365 = Lx.*Ly.*ddXd3.*t12.*t37.*2.0;
t366 = Lx.*Ly.*ddXd3.*t12.*t38.*2.0;
t367 = Lx.*Ly.*ddXd3.*t9.*t41.*2.0;
t368 = Lx.*Ly.*ddXd3.*t12.*t40.*2.0;
t369 = Lx.*Ly.*ddXd3.*t12.*t41.*2.0;
t370 = Lx.*Ly.*ddXd3.*t12.*t43.*2.0;
t371 = Lx.*Ly.*gravity.*t6.*t29.*2.0;
t372 = Lx.*Ly.*gravity.*t9.*t29.*2.0;
t373 = Lx.*Ly.*gravity.*t6.*t31.*2.0;
t374 = Lx.*Ly.*gravity.*t12.*t29.*2.0;
t375 = Lx.*Ly.*gravity.*t9.*t30.*2.0;
t376 = Lx.*Ly.*gravity.*t9.*t31.*2.0;
t377 = Lx.*Ly.*gravity.*t6.*t34.*2.0;
t378 = Lx.*Ly.*gravity.*t12.*t30.*2.0;
t379 = Lx.*Ly.*gravity.*t12.*t31.*2.0;
t380 = Lx.*Ly.*gravity.*t9.*t33.*2.0;
t381 = Lx.*Ly.*gravity.*t9.*t34.*2.0;
t382 = Lx.*Ly.*gravity.*t6.*t38.*2.0;
t383 = Lx.*Ly.*gravity.*t12.*t32.*2.0;
t384 = Lx.*Ly.*gravity.*t12.*t33.*2.0;
t385 = Lx.*Ly.*gravity.*t12.*t34.*2.0;
t386 = Lx.*Ly.*gravity.*t9.*t37.*2.0;
t387 = Lx.*Ly.*gravity.*t9.*t38.*2.0;
t388 = Lx.*Ly.*gravity.*t12.*t36.*2.0;
t389 = Lx.*Ly.*gravity.*t12.*t37.*2.0;
t390 = Lx.*Ly.*gravity.*t12.*t38.*2.0;
t391 = Lx.*Ly.*gravity.*t9.*t41.*2.0;
t392 = Lx.*Ly.*gravity.*t12.*t40.*2.0;
t393 = Lx.*Ly.*gravity.*t12.*t41.*2.0;
t394 = Lx.*Ly.*gravity.*t12.*t43.*2.0;
t395 = q0.*t208.*4.0;
t396 = q1.*t208.*4.0;
t397 = q2.*t208.*4.0;
t398 = q3.*t208.*4.0;
t399 = o1.*o2.*t27.*t60;
t400 = o1.*o3.*t26.*t61;
t401 = o2.*o3.*t25.*t62;
t405 = t4+t12+t45+t46;
t406 = t4+t6+t46+t47;
t407 = t52+t53+t64;
t408 = t50+t54+t65;
t409 = t48+t58+t66;
t653 = t29+t30+t31+t32+t33+t34+t35+t36+t37+t38+t39+t40+t41+t42+t43+t44;
t156 = -t72;
t158 = -t76;
t159 = -t77;
t162 = -t83;
t163 = -t86;
t166 = -t91;
t167 = -t92;
t169 = -t95;
t315 = -t274;
t316 = -t275;
t317 = -t277;
t318 = -t278;
t319 = -t280;
t320 = -t283;
t321 = -t286;
t322 = -t289;
t402 = -t395;
t403 = -t396;
t410 = t406.^2;
t411 = q0.*t406.*4.0;
t412 = q1.*t406.*4.0;
t413 = q2.*t406.*4.0;
t414 = q3.*t406.*4.0;
t415 = 1.0./t405;
t416 = 1.0./t406;
t584 = t7+t10+t13+t15+t63+t99+t101+t102+t104+t153+t154;
t654 = 1.0./t653;
t892 = t105+t106+t107+t108+t109+t110+t111+t112+t113+t114+t115+t116+t117+t118+t119+t120+t121+t122+t123+t124+t125+t126+t127+t128+t129+t130+t131+t132+t133+t134+t135+t136+t137+t138+t139+t140+t141+t142+t143+t144+t145+t146+t147+t148+t149+t150+t151+t152+t323+t324+t325+t326+t327+t328+t329+t330+t331+t332+t333+t334+t335+t336+t337+t338+t339+t340+t341+t342+t343+t344+t345+t346+t347+t348+t349+t350+t351+t352+t353+t354+t355+t356+t357+t358+t359+t360+t361+t362+t363+t364+t365+t366+t367+t368+t369+t370+t371+t372+t373+t374+t375+t376+t377+t378+t379+t380+t381+t382+t383+t384+t385+t386+t387+t388+t389+t390+t391+t392+t393+t394;
t417 = t415.^2;
t418 = 1.0./t410;
t419 = t415.^3;
t420 = t416.^3;
t421 = t416.*2.0;
t437 = t22.*t415.*2.0;
t438 = q0.*t2.*t415.*2.0;
t439 = q1.*t2.*t415.*2.0;
t440 = q2.*t2.*t415.*2.0;
t441 = q3.*t2.*t415.*2.0;
t470 = km1.*m.*t22.*t27.*t415;
t471 = lx.*m.*t22.*t25.*t415;
t472 = ly.*m.*t22.*t26.*t415;
t473 = t314+t410;
t478 = t3.*t207.*t415;
t479 = t398+t411;
t480 = t397+t412;
t485 = t3.*t269.*t415;
t486 = t403+t413;
t487 = t402+t414;
t852 = t68+t71+t78+t85+t158+t162+t166+t169+t175+t177+t183+t185+t211+t213+t215+t216+t217+t220+t229+t237+t253+t254+t259+t260+t284+t288+t291+t294+t295+t300+t315+t318;
t853 = t84+t90+t96+t98+t156+t159+t163+t167+t175+t177+t183+t185+t211+t213+t215+t216+t217+t220+t229+t237+t253+t254+t259+t260+t276+t281+t291+t294+t295+t300+t321+t322;
t854 = t68+t71+t78+t85+t158+t162+t166+t169+t192+t194+t200+t202+t211+t213+t215+t216+t231+t238+t239+t244+t261+t262+t267+t268+t284+t288+t296+t301+t309+t312+t315+t318;
t860 = t67+t70+t73+t80+t155+t157+t160+t164+t171+t172+t212+t214+t218+t221+t226+t228+t233+t235+t241+t245+t251+t252+t255+t256+t257+t258+t263+t264+t265+t266+t270+t271+t279+t282+t316+t317;
t861 = t67+t70+t73+t80+t155+t157+t160+t164+t171+t172+t187+t188+t189+t190+t203+t204+t205+t206+t212+t214+t251+t252+t270+t271+t279+t282+t293+t298+t303+t305+t306+t308+t311+t313+t316+t317;
t862 = t75+t82+t88+t94+t161+t165+t168+t170+t173+t174+t179+t180+t181+t182+t195+t196+t197+t198+t209+t210+t249+t250+t272+t273+t285+t287+t290+t292+t297+t299+t302+t304+t307+t310+t319+t320;
t893 = 1.0./t892;
t422 = q0.*t421;
t423 = q1.*t421;
t424 = q2.*t421;
t425 = q3.*t421;
t426 = q0.*q1.*t418.*4.0;
t427 = q0.*q2.*t418.*4.0;
t428 = q1.*q3.*t418.*4.0;
t429 = q2.*q3.*t418.*4.0;
t431 = q0.*q3.*t418.*8.0;
t432 = q1.*q2.*t418.*8.0;
t433 = t4.*t418.*4.0;
t434 = t6.*t418.*4.0;
t435 = t9.*t418.*4.0;
t436 = t12.*t418.*4.0;
t444 = q0.*t437;
t445 = q1.*t437;
t446 = q2.*t437;
t447 = q3.*t437;
t448 = -t439;
t449 = -t441;
t450 = q0.*q1.*t22.*t417.*4.0;
t451 = q0.*q2.*t22.*t417.*4.0;
U2 = ft_1({V2,V3,V4,ddXd4,ddddXd1,ddddXd2,jz,o1,o2,o3,q0,q1,q2,q3,t12,t2,t207,t208,t22,t24,t269,t395,t396,t399,t4,t400,t401,t404,t406,t407,t408,t409,t410,t411,t412,t413,t414,t415,t417,t418,t419,t420,t421,t422,t423,t424,t425,t426,t427,t428,t429,t431,t432,t433,t434,t435,t436,t437,t438,t439,t440,t441,t444,t445,t446,t447,t448,t449,t450,t451,t470,t471,t472,t473,t478,t479,t480,t485,t584,t6,t654,t852,t853,t854,t860,t861,t862,t893,t9});
end
function U2 = ft_1(ct)
V2 = ct{1};
V3 = ct{2};
V4 = ct{3};
ddXd4 = ct{4};
ddddXd1 = ct{5};
ddddXd2 = ct{6};
jz = ct{7};
o1 = ct{8};
o2 = ct{9};
o3 = ct{10};
q0 = ct{11};
q1 = ct{12};
q2 = ct{13};
q3 = ct{14};
t12 = ct{15};
t2 = ct{16};
t207 = ct{17};
t208 = ct{18};
t22 = ct{19};
t24 = ct{20};
t269 = ct{21};
t395 = ct{22};
t396 = ct{23};
t399 = ct{24};
t4 = ct{25};
t400 = ct{26};
t401 = ct{27};
t404 = ct{28};
t406 = ct{29};
t407 = ct{30};
t408 = ct{31};
t409 = ct{32};
t410 = ct{33};
t411 = ct{34};
t412 = ct{35};
t413 = ct{36};
t414 = ct{37};
t415 = ct{38};
t417 = ct{39};
t418 = ct{40};
t419 = ct{41};
t420 = ct{42};
t421 = ct{43};
t422 = ct{44};
t423 = ct{45};
t424 = ct{46};
t425 = ct{47};
t426 = ct{48};
t427 = ct{49};
t428 = ct{50};
t429 = ct{51};
t431 = ct{52};
t432 = ct{53};
t433 = ct{54};
t434 = ct{55};
t435 = ct{56};
t436 = ct{57};
t437 = ct{58};
t438 = ct{59};
t439 = ct{60};
t440 = ct{61};
t441 = ct{62};
t444 = ct{63};
t445 = ct{64};
t446 = ct{65};
t447 = ct{66};
t448 = ct{67};
t449 = ct{68};
t450 = ct{69};
t451 = ct{70};
t470 = ct{71};
t471 = ct{72};
t472 = ct{73};
t473 = ct{74};
t478 = ct{75};
t479 = ct{76};
t480 = ct{77};
t485 = ct{78};
t584 = ct{79};
t6 = ct{80};
t654 = ct{81};
t852 = ct{82};
t853 = ct{83};
t854 = ct{84};
t860 = ct{85};
t861 = ct{86};
t862 = ct{87};
t893 = ct{88};
t9 = ct{89};
t452 = q0.*q3.*t22.*t417.*4.0;
t453 = q1.*q2.*t22.*t417.*4.0;
t454 = q1.*q3.*t22.*t417.*4.0;
t455 = q2.*q3.*t22.*t417.*4.0;
t456 = t4.*t22.*t417.*4.0;
t457 = t6.*t22.*t417.*4.0;
t458 = t9.*t22.*t417.*4.0;
t459 = t12.*t22.*t417.*4.0;
t462 = q0.*q1.*t22.*t417.*8.0;
t463 = q0.*q2.*t22.*t417.*8.0;
t464 = q1.*q3.*t22.*t417.*8.0;
t465 = q2.*q3.*t22.*t417.*8.0;
t469 = t208.*t418.*2.0;
t481 = -t471;
t482 = -t472;
t483 = q0.*t208.*t418.*-2.0;
t484 = q1.*t208.*t418.*-2.0;
t488 = 1.0./t473;
t490 = q0.*q1.*t208.*t420.*8.0;
t491 = q0.*q2.*t208.*t420.*8.0;
t492 = q0.*q3.*t208.*t420.*8.0;
t493 = q1.*q2.*t208.*t420.*8.0;
t494 = q1.*q3.*t208.*t420.*8.0;
t495 = q2.*q3.*t208.*t420.*8.0;
t496 = -t478;
t497 = t22.*t207.*t417.*2.0;
t498 = q0.*t2.*t207.*t417.*2.0;
t499 = q1.*t2.*t207.*t417.*2.0;
t500 = q2.*t2.*t207.*t417.*2.0;
t501 = q3.*t2.*t207.*t417.*2.0;
t502 = t4.*t208.*t420.*8.0;
t503 = t6.*t208.*t420.*8.0;
t504 = t9.*t208.*t420.*8.0;
t505 = t12.*t208.*t420.*8.0;
t509 = t22.*t269.*t417.*2.0;
t510 = q0.*t2.*t269.*t417.*2.0;
t512 = q1.*t2.*t269.*t417.*2.0;
t513 = q2.*t2.*t269.*t417.*2.0;
t514 = q3.*t2.*t269.*t417.*2.0;
t526 = q0.*t22.*t207.*t417.*-2.0;
t530 = q3.*t22.*t207.*t417.*-2.0;
t531 = q0.*q1.*t22.*t207.*t419.*8.0;
t532 = q0.*q2.*t22.*t207.*t419.*8.0;
t533 = q0.*q3.*t22.*t207.*t419.*8.0;
t534 = q1.*q2.*t22.*t207.*t419.*8.0;
t535 = q1.*q3.*t22.*t207.*t419.*8.0;
t536 = q2.*q3.*t22.*t207.*t419.*8.0;
t537 = q0.*t22.*t269.*t417.*-2.0;
t538 = q2.*t22.*t269.*t417.*-2.0;
t539 = t4.*t22.*t207.*t419.*8.0;
t540 = t6.*t22.*t207.*t419.*8.0;
t541 = t9.*t22.*t207.*t419.*8.0;
t542 = t12.*t22.*t207.*t419.*8.0;
t543 = q0.*q1.*t22.*t269.*t419.*8.0;
t544 = q0.*q2.*t22.*t269.*t419.*8.0;
t546 = q0.*q3.*t22.*t269.*t419.*8.0;
t548 = q1.*q2.*t22.*t269.*t419.*8.0;
t549 = q1.*q3.*t22.*t269.*t419.*8.0;
t551 = q2.*q3.*t22.*t269.*t419.*8.0;
t552 = t4.*t22.*t269.*t419.*8.0;
t554 = t6.*t22.*t269.*t419.*8.0;
t555 = t9.*t22.*t269.*t419.*8.0;
t556 = t12.*t22.*t269.*t419.*8.0;
t561 = t399+t470;
t430 = -t429;
t442 = -t433;
t443 = -t434;
t460 = -t453;
t461 = -t454;
t466 = -t456;
t467 = -t459;
t468 = -t465;
t474 = q0.*t469;
t475 = q1.*t469;
t476 = q2.*t469;
t477 = q3.*t469;
t489 = t488.^2;
t506 = -t490;
t507 = -t492;
t508 = -t493;
t511 = -t498;
t515 = -t501;
t516 = -t502;
t517 = -t503;
t518 = q0.*t497;
t519 = q1.*t497;
t520 = q2.*t497;
t521 = q3.*t497;
t522 = -t509;
t523 = -t510;
t524 = -t513;
t525 = q0.*t509;
t527 = q1.*t509;
t528 = q2.*t509;
t529 = q3.*t509;
t545 = -t532;
t547 = -t533;
t550 = -t535;
t553 = -t539;
t557 = -t542;
t558 = -t543;
t559 = -t544;
t560 = -t552;
t562 = t401+t481;
t563 = t400+t482;
t566 = t424+t484;
t567 = t425+t483;
t568 = t438+t500;
t569 = t441+t499;
t570 = t438+t512;
t573 = t440+t514;
t579 = t446+t526;
t580 = t445+t530;
t582 = t445+t537;
t583 = t447+t538;
t665 = t427+t428+t495;
t673 = t432+t469+t504;
t674 = t431+t469+t505;
t677 = t450+t455+t534;
t680 = t452+t453+t549;
t685 = t463+t497+t541;
t686 = t464+t497+t540;
t689 = t462+t509+t554;
t564 = t422+t477;
t565 = t423+t476;
t571 = t440+t511;
t572 = t439+t515;
t574 = t444+t520;
t575 = t447+t519;
t576 = t439+t523;
t577 = t441+t524;
t578 = t444+t527;
t581 = t446+t529;
t599 = (o1.*t579)./2.0;
t601 = (o2.*t579)./2.0;
t603 = (o1.*t580)./2.0;
t605 = (o3.*t579)./2.0;
t607 = (o2.*t580)./2.0;
t609 = (o3.*t580)./2.0;
t612 = (q1.*t579)./2.0;
t614 = (q0.*t580)./2.0;
t616 = (q2.*t579)./2.0;
t619 = (q1.*t580)./2.0;
t621 = (q3.*t579)./2.0;
t623 = (q2.*t580)./2.0;
t627 = (o1.*t582)./2.0;
t629 = (o2.*t582)./2.0;
t631 = (o3.*t582)./2.0;
t633 = (o1.*t583)./2.0;
t635 = (o2.*t583)./2.0;
t637 = (o3.*t583)./2.0;
t638 = (q1.*t582)./2.0;
t639 = (q2.*t582)./2.0;
t642 = (q3.*t582)./2.0;
t644 = (q0.*t583)./2.0;
t645 = (q1.*t583)./2.0;
t646 = (q3.*t583)./2.0;
t655 = t408.*t568;
t657 = t409.*t569;
t658 = t409.*t570;
t661 = t407.*t573;
t669 = t427+t428+t506;
t670 = t426+t430+t491;
t671 = t426+t430+t494;
t675 = t431+t469+t516;
t676 = t432+t469+t517;
t678 = t452+t460+t531;
t679 = t450+t455+t547;
t681 = t452+t460+t536;
t682 = t452+t453+t559;
t683 = t451+t461+t546;
t684 = t451+t461+t548;
t687 = t463+t497+t553;
t688 = t464+t497+t557;
t690 = t462+t509+t560;
t691 = t468+t509+t555;
t692 = t465+t522+t556;
t693 = t421+t436+t442+t507;
t694 = t421+t435+t443+t508;
t695 = t408.*t677;
t697 = t409.*t677;
t713 = t407.*t680;
t717 = t409.*t680;
t721 = (o1.*t410.*t488.*t566)./2.0;
t722 = (o1.*t410.*t488.*t567)./2.0;
t724 = (o2.*t410.*t488.*t566)./2.0;
t725 = (o2.*t410.*t488.*t567)./2.0;
t726 = (o3.*t410.*t488.*t566)./2.0;
t727 = (o3.*t410.*t488.*t567)./2.0;
t728 = (q0.*t410.*t488.*t566)./2.0;
t730 = (q1.*t410.*t488.*t567)./2.0;
t732 = (q2.*t410.*t488.*t566)./2.0;
t733 = (q2.*t410.*t488.*t567)./2.0;
t734 = (q3.*t410.*t488.*t566)./2.0;
t735 = (q3.*t410.*t488.*t567)./2.0;
t751 = t408.*t685;
t753 = t409.*t686;
t755 = t409.*t689;
t757 = t437+t458+t466+t545;
t758 = t437+t457+t467+t550;
t759 = t437+t458+t467+t551;
t762 = t437+t457+t466+t558;
t769 = t404.*t411.*t488.*t567;
t772 = t404.*t412.*t488.*t567;
t774 = t404.*t413.*t488.*t567;
t775 = t404.*t414.*t488.*t567;
t777 = t409.*t411.*t488.*t566;
t780 = q0.*t404.*t406.*t488.*t567.*-4.0;
t781 = t409.*t412.*t488.*t566;
t783 = t409.*t413.*t488.*t566;
t784 = t409.*t414.*t488.*t566;
t785 = q3.*t404.*t406.*t488.*t567.*-4.0;
t786 = q1.*t406.*t409.*t488.*t566.*-4.0;
t787 = q2.*t406.*t409.*t488.*t566.*-4.0;
t801 = t407.*t410.*t488.*t665;
t803 = t408.*t410.*t488.*t665;
t816 = t404.*t410.*t479.*t489.*t567;
t817 = t404.*t410.*t480.*t489.*t567;
t822 = t409.*t410.*t479.*t489.*t566;
t823 = t409.*t410.*t480.*t489.*t566;
t824 = -t404.*t410.*t489.*t567.*(t396-t413);
t825 = -t404.*t410.*t489.*t567.*(t395-t414);
t827 = -t409.*t410.*t489.*t566.*(t396-t413);
t828 = -t409.*t410.*t489.*t566.*(t395-t414);
t831 = t407.*t410.*t488.*t674;
t832 = t408.*t410.*t488.*t673;
t837 = t404.*t410.*t489.*t567.*(t396-t413);
t839 = t409.*t410.*t489.*t566.*(t395-t414);
t585 = (o1.*t574)./2.0;
t586 = (o2.*t574)./2.0;
t587 = (o1.*t575)./2.0;
t588 = (o3.*t574)./2.0;
t589 = (o2.*t575)./2.0;
t590 = (o3.*t575)./2.0;
t591 = (q0.*t574)./2.0;
t592 = (q1.*t574)./2.0;
t593 = (q0.*t575)./2.0;
t594 = (q3.*t574)./2.0;
t595 = (q2.*t575)./2.0;
t596 = (q3.*t575)./2.0;
t597 = (o1.*t578)./2.0;
t600 = (o2.*t578)./2.0;
t602 = (o3.*t578)./2.0;
t606 = (o1.*t581)./2.0;
t608 = (o2.*t581)./2.0;
t610 = (o3.*t581)./2.0;
t611 = (q0.*t578)./2.0;
t613 = (q2.*t578)./2.0;
t617 = (q3.*t578)./2.0;
t618 = (q0.*t581)./2.0;
t622 = (q1.*t581)./2.0;
t625 = (q2.*t581)./2.0;
t628 = -t599;
t630 = -t601;
t632 = -t603;
t640 = -t614;
t641 = -t616;
t647 = -t627;
t648 = -t629;
t649 = -t635;
t650 = -t638;
t651 = -t642;
t652 = -t646;
t656 = t404.*t571;
t659 = t404.*t576;
t660 = t407.*t572;
t662 = -t655;
t663 = t408.*t577;
t664 = -t657;
t668 = -t661;
t696 = t404.*t678;
t698 = t404.*t679;
t699 = (o1.*t410.*t488.*t564)./2.0;
t700 = (o1.*t410.*t488.*t565)./2.0;
t701 = (o2.*t410.*t488.*t564)./2.0;
t702 = (o2.*t410.*t488.*t565)./2.0;
t703 = (o3.*t410.*t488.*t564)./2.0;
t704 = (o3.*t410.*t488.*t565)./2.0;
t705 = (q0.*t410.*t488.*t564)./2.0;
t706 = (q0.*t410.*t488.*t565)./2.0;
t707 = (q1.*t410.*t488.*t564)./2.0;
t708 = (q1.*t410.*t488.*t565)./2.0;
t709 = (q2.*t410.*t488.*t564)./2.0;
t710 = (q3.*t410.*t488.*t565)./2.0;
t711 = t407.*t679;
t712 = t409.*t678;
t714 = t407.*t681;
t715 = t404.*t682;
t716 = t408.*t681;
t718 = t404.*t683;
t736 = t407.*t683;
t737 = t408.*t682;
t738 = t408.*t684;
t739 = t409.*t684;
t741 = -t725;
t742 = -t730;
t743 = -t733;
t744 = -t734;
t745 = -t735;
t748 = -t713;
t752 = t404.*t687;
t754 = t407.*t688;
t756 = t404.*t690;
t760 = t407.*t692;
t761 = t408.*t691;
t764 = t407.*t411.*t488.*t564;
t765 = t408.*t411.*t488.*t565;
t766 = t407.*t412.*t488.*t564;
t767 = t408.*t412.*t488.*t565;
t768 = t407.*t413.*t488.*t564;
t770 = t408.*t413.*t488.*t565;
t771 = t407.*t414.*t488.*t564;
t773 = t408.*t414.*t488.*t565;
t776 = q1.*t406.*t407.*t488.*t564.*-4.0;
t778 = q1.*t406.*t408.*t488.*t565.*-4.0;
t779 = q2.*t406.*t407.*t488.*t564.*-4.0;
t782 = q2.*t406.*t408.*t488.*t565.*-4.0;
t788 = t404.*t757;
t789 = t408.*t757;
t790 = t404.*t762;
t791 = t407.*t758;
t792 = t407.*t759;
t793 = t409.*t758;
t794 = t408.*t759;
t795 = t409.*t762;
t800 = t404.*t410.*t488.*t669;
t802 = t404.*t410.*t488.*t670;
t804 = t408.*t410.*t488.*t670;
t805 = t409.*t410.*t488.*t669;
t806 = t407.*t410.*t488.*t671;
t807 = t409.*t410.*t488.*t671;
t809 = -t803;
t812 = t407.*t410.*t479.*t489.*t564;
t813 = t407.*t410.*t480.*t489.*t564;
t814 = t408.*t410.*t479.*t489.*t565;
t815 = t408.*t410.*t480.*t489.*t565;
t818 = -t407.*t410.*t489.*t564.*(t396-t413);
t819 = -t407.*t410.*t489.*t564.*(t395-t414);
t820 = -t408.*t410.*t489.*t565.*(t396-t413);
t821 = -t408.*t410.*t489.*t565.*(t395-t414);
t830 = -t817;
t833 = t404.*t410.*t488.*t675;
t834 = t407.*t410.*t489.*t564.*(t395-t414);
t835 = t408.*t410.*t489.*t565.*(t395-t414);
t836 = -t822;
t838 = t409.*t410.*t488.*t676;
t840 = -t831;
t841 = t404.*t410.*t488.*t693;
t842 = t407.*t410.*t488.*t693;
t843 = t408.*t410.*t488.*t694;
t844 = t409.*t410.*t488.*t694;
t598 = -t585;
t604 = -t588;
t615 = -t593;
t620 = -t594;
t624 = -t595;
t626 = -t596;
t634 = -t608;
t636 = -t610;
t643 = -t618;
t666 = -t659;
t667 = -t660;
t672 = -t663;
t719 = -t699;
t720 = -t700;
t723 = -t701;
t729 = -t708;
t731 = -t709;
t740 = -t698;
t746 = -t711;
t747 = -t712;
t749 = -t714;
t750 = -t715;
t763 = -t760;
t796 = -t788;
t797 = -t790;
t798 = -t792;
t799 = -t793;
t808 = -t800;
t810 = -t804;
t811 = -t805;
t826 = -t812;
t829 = -t814;
t845 = -t843;
t849 = t617+t622+t639+t644;
t850 = t611+t625+t650+t652;
t856 = -t562.*(t593+t594-t612-t623);
t865 = t706+t707+t743+t744;
t869 = -t562.*(t709-t710-t728+t730);
t871 = t562.*(t709-t710-t728+t730);
t900 = -t408.*(t699+t725-t726+t768+t770+t783-t801-t802+t824-t832-t844-q2.*t404.*t406.*t488.*t567.*4.0+t407.*t410.*t489.*t564.*(t396-t413)+t408.*t410.*t489.*t565.*(t396-t413)+t409.*t410.*t489.*t566.*(t396-t413));
t901 = t408.*(t699+t725-t726+t768+t770+t783-t801-t802+t824-t832-t844-q2.*t404.*t406.*t488.*t567.*4.0+t407.*t410.*t489.*t564.*(t396-t413)+t408.*t410.*t489.*t565.*(t396-t413)+t409.*t410.*t489.*t566.*(t396-t413));
t846 = t591+t619+t626+t641;
t847 = t592+t621+t624+t640;
t848 = t612+t615+t620+t623;
t851 = t613+t643+t645+t651;
t859 = t563.*t849;
t863 = t562.*t850;
t864 = t705+t729+t732+t745;
t866 = t710+t728+t731+t742;
t870 = t563.*t865;
t872 = t569+t604+t607+t628+t695+t696+t753+t791;
t873 = t571+t586+t587+t609+t746+t747+t752+t789;
t874 = t568+t590+t630+t632+t697+t749+t751+t796;
t875 = t448+t501+t589+t598+t605+t716+t740+t754+t799;
t876 = t573+t600+t631+t633+t717+t718+t763+t794;
t877 = t576+t597+t636+t649+t736+t737+t756+t795;
t878 = t570+t634+t637+t647+t738+t748+t755+t797;
t879 = t449+t513+t602+t606+t648+t739+t750+t761+t798;
t894 = t704+t722+t723+t772+t776+t778+t786+t806+t808+t813+t815+t823+t830+t838+t845;
t895 = t719+t726+t741+t774+t779+t782+t787+t801+t802+t818+t820+t827+t832+t837+t844;
t896 = t702+t703+t721+t764+t765+t777+t780+t810+t811+t816+t826+t829+t833+t836+t842;
t897 = t720+t724+t727+t771+t773+t784+t785+t807+t809+t825+t834+t835+t839+t840+t841;
t855 = t561.*t847;
t857 = t563.*t846;
t858 = t561.*t851;
t867 = t561.*t864;
t880 = t409.*t872;
t882 = t404.*t873;
t883 = t408.*t874;
t884 = t407.*t875;
t886 = t407.*t876;
t887 = t404.*t877;
t890 = t409.*t878;
t891 = t408.*t879;
t898 = t404.*t896;
t899 = t409.*t894;
t902 = t407.*t897;
t868 = -t867;
t881 = -t880;
t885 = -t883;
t888 = -t886;
t889 = -t887;
t903 = V2+ddddXd1+t496+t656+t662+t664+t667+t855+t856+t857+t881+t882+t884+t885;
t904 = V3+ddddXd2+t485+t658+t666+t668+t672+t858+t859+t863+t888+t889+t890+t891;
t911 = V4+ddXd4+t868+t870+t871+t898+t899+t901+t902;
t905 = t860.*t893.*t903;
t906 = t861.*t893.*t903;
t907 = t862.*t893.*t903;
t908 = t852.*t893.*t904;
t909 = t853.*t893.*t904;
t910 = t854.*t893.*t904;
t912 = jz.*t415.*t584.*t654.*t911;
t913 = t24.*t415.*t584.*t654.*t911;
U2 = [t905-t906+t907+t908-t909-t910+t912;-t907+t910+t913;t906+t909+t913;-t905-t908+t912];
end
