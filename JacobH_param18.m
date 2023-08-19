function H = JacobH_param18(in1,in2,in3)
%JacobH_param18
%    H = JacobH_param18(IN1,IN2,IN3)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    2023/08/19 23:16:59

a = in2(:,1);
b = in2(:,2);
c = in2(:,3);
d = in2(:,4);
x1 = in1(1,:);
x2 = in1(2,:);
x3 = in1(3,:);
x4 = in1(4,:);
x5 = in1(5,:);
x6 = in1(6,:);
x13 = in1(13,:);
x14 = in1(14,:);
x15 = in1(15,:);
x16 = in1(16,:);
x17 = in1(17,:);
x18 = in1(18,:);
t2 = -d;
t3 = x4./2.0;
t4 = x5./2.0;
t5 = x6./2.0;
t6 = x16./2.0;
t7 = x17./2.0;
t8 = x18./2.0;
t9 = cos(t3);
t10 = cos(t4);
t11 = cos(t5);
t12 = cos(t6);
t13 = cos(t7);
t14 = cos(t8);
t15 = sin(t3);
t16 = sin(t4);
t17 = sin(t5);
t18 = sin(t6);
t19 = sin(t7);
t20 = sin(t8);
t21 = t9.*t10.*t11;
t22 = t12.*t13.*t14;
t23 = t9.*t10.*t17;
t24 = t9.*t11.*t16;
t25 = t10.*t11.*t15;
t26 = t12.*t13.*t20;
t27 = t12.*t14.*t19;
t28 = t13.*t14.*t18;
t29 = t9.*t16.*t17;
t30 = t10.*t15.*t17;
t31 = t11.*t15.*t16;
t32 = t12.*t19.*t20;
t33 = t13.*t18.*t20;
t34 = t14.*t18.*t19;
t35 = t15.*t16.*t17;
t36 = t18.*t19.*t20;
t37 = -t29;
t38 = -t31;
t39 = -t32;
t40 = -t34;
t41 = t21./2.0;
t42 = t22./2.0;
t43 = t23./2.0;
t44 = t24./2.0;
t45 = t25./2.0;
t46 = t26./2.0;
t47 = t27./2.0;
t48 = t28./2.0;
t49 = t29./2.0;
t50 = t30./2.0;
t51 = t31./2.0;
t52 = t32./2.0;
t53 = t33./2.0;
t54 = t34./2.0;
t55 = t35./2.0;
t56 = t36./2.0;
t65 = t21+t35;
t66 = t24+t30;
t67 = t22+t36;
t68 = t27+t33;
t57 = -t49;
t58 = -t50;
t59 = -t51;
t60 = -t52;
t61 = -t53;
t62 = -t54;
t63 = -t55;
t64 = -t56;
t69 = t65.^2;
t70 = t66.^2;
t71 = t67.^2;
t72 = t68.^2;
t73 = t23+t38;
t74 = t25+t37;
t75 = t26+t40;
t76 = t28+t39;
t81 = t41+t55;
t82 = t43+t51;
t83 = t44+t50;
t84 = t45+t49;
t85 = t42+t56;
t86 = t46+t54;
t87 = t47+t53;
t88 = t48+t52;
t77 = t73.^2;
t78 = t74.^2;
t79 = t75.^2;
t80 = t76.^2;
t89 = t41+t63;
t90 = t43+t59;
t91 = t44+t58;
t92 = t45+t57;
t93 = t42+t64;
t94 = t46+t62;
t95 = t47+t61;
t96 = t48+t60;
t112 = t73.*t81.*2.0;
t113 = t73.*t83.*2.0;
t114 = t73.*t84.*2.0;
t115 = t74.*t81.*2.0;
t116 = t74.*t82.*2.0;
t117 = t74.*t83.*2.0;
t121 = t75.*t85.*2.0;
t122 = t75.*t87.*2.0;
t123 = t75.*t88.*2.0;
t124 = t76.*t85.*2.0;
t125 = t76.*t86.*2.0;
t126 = t76.*t87.*2.0;
t97 = t65.*t90.*2.0;
t98 = t65.*t91.*2.0;
t99 = t65.*t92.*2.0;
t100 = t66.*t89.*2.0;
t101 = t66.*t90.*2.0;
t102 = t66.*t92.*2.0;
t103 = t67.*t94.*2.0;
t104 = t67.*t95.*2.0;
t105 = t67.*t96.*2.0;
t106 = t68.*t93.*2.0;
t107 = t68.*t94.*2.0;
t108 = t68.*t96.*2.0;
t127 = -t112;
t128 = -t115;
t129 = -t121;
t130 = -t124;
t131 = t69+t70+t77+t78;
t132 = t71+t72+t79+t80;
t109 = -t100;
t110 = -t101;
t111 = -t102;
t118 = -t106;
t119 = -t107;
t120 = -t108;
t133 = 1.0./t131;
t135 = 1.0./t132;
t134 = t133.^2;
t136 = t135.^2;
t137 = t69.*t133;
t138 = t70.*t133;
t139 = t71.*t135;
t140 = t72.*t135;
t141 = t77.*t133;
t142 = t78.*t133;
t144 = t79.*t135;
t145 = t80.*t135;
t150 = t65.*t66.*t133.*2.0;
t151 = t67.*t68.*t135.*2.0;
t152 = t65.*t73.*t133.*2.0;
t153 = t65.*t74.*t133.*2.0;
t154 = t66.*t73.*t133.*2.0;
t155 = t66.*t74.*t133.*2.0;
t156 = t67.*t75.*t135.*2.0;
t157 = t68.*t76.*t135.*2.0;
t160 = t73.*t74.*t133.*2.0;
t161 = t75.*t76.*t135.*2.0;
t164 = t65.*t81.*t133.*2.0;
t165 = t65.*t82.*t133.*2.0;
t166 = t65.*t83.*t133.*2.0;
t167 = t65.*t84.*t133.*2.0;
t168 = t66.*t81.*t133.*2.0;
t169 = t66.*t82.*t133.*2.0;
t170 = t66.*t83.*t133.*2.0;
t171 = t66.*t84.*t133.*2.0;
t172 = t67.*t85.*t135.*2.0;
t173 = t67.*t87.*t135.*2.0;
t174 = t67.*t88.*t135.*2.0;
t175 = t68.*t85.*t135.*2.0;
t176 = t68.*t86.*t135.*2.0;
t177 = t68.*t87.*t135.*2.0;
t178 = t65.*t89.*t133.*2.0;
t179 = t97.*t133;
t180 = t98.*t133;
t182 = t99.*t133;
t183 = t100.*t133;
t184 = t101.*t133;
t186 = t66.*t91.*t133.*2.0;
t188 = t102.*t133;
t190 = t67.*t93.*t135.*2.0;
t191 = t103.*t135;
t192 = t104.*t135;
t195 = t106.*t135;
t196 = t107.*t135;
t197 = t68.*t95.*t135.*2.0;
t199 = t108.*t135;
t200 = t65.*t91.*t133.*-2.0;
t201 = t66.*t90.*t133.*-2.0;
t203 = t66.*t92.*t133.*-2.0;
t204 = t112.*t133;
t205 = t73.*t82.*t133.*2.0;
t206 = t113.*t133;
t207 = t114.*t133;
t208 = t115.*t133;
t209 = t116.*t133;
t210 = t117.*t133;
t211 = t74.*t84.*t133.*2.0;
t212 = t68.*t94.*t135.*-2.0;
t215 = t121.*t135;
t216 = t75.*t86.*t135.*2.0;
t217 = t122.*t135;
t219 = t124.*t135;
t220 = t125.*t135;
t221 = t126.*t135;
t222 = t76.*t88.*t135.*2.0;
t223 = t73.*t89.*t133.*2.0;
t225 = t73.*t90.*t133.*2.0;
t227 = t73.*t91.*t133.*2.0;
t228 = t73.*t83.*t133.*-2.0;
t229 = t73.*t92.*t133.*2.0;
t230 = t73.*t84.*t133.*-2.0;
t231 = t74.*t89.*t133.*2.0;
t233 = t74.*t90.*t133.*2.0;
t234 = t74.*t82.*t133.*-2.0;
t235 = t74.*t91.*t133.*2.0;
t236 = t74.*t83.*t133.*-2.0;
t237 = t74.*t92.*t133.*2.0;
t240 = t75.*t94.*t135.*2.0;
t241 = t75.*t95.*t135.*2.0;
t242 = t75.*t87.*t135.*-2.0;
t243 = t75.*t96.*t135.*2.0;
t244 = t75.*t88.*t135.*-2.0;
t245 = t76.*t93.*t135.*2.0;
t247 = t76.*t94.*t135.*2.0;
t248 = t76.*t96.*t135.*2.0;
t258 = t98+t109+t114+t116;
t259 = t104+t118+t123+t125;
t260 = t97+t111+t117+t127;
t261 = t99+t110+t113+t128;
t262 = t103+t120+t126+t129;
t263 = t105+t119+t122+t130;
t143 = -t138;
t146 = -t140;
t147 = -t141;
t148 = -t142;
t149 = -t144;
t158 = -t154;
t159 = -t155;
t162 = -t160;
t163 = -t161;
t181 = -t166;
t185 = -t169;
t187 = -t170;
t189 = -t171;
t193 = -t173;
t198 = -t177;
t202 = -t186;
t213 = -t197;
t226 = -t205;
t238 = -t211;
t249 = -t223;
t250 = -t225;
t251 = -t229;
t252 = -t231;
t253 = -t233;
t254 = -t237;
t255 = -t240;
t256 = -t243;
t257 = -t245;
t264 = t150+t160;
t265 = t152+t155;
t266 = t153+t154;
t267 = t156+t157;
t281 = t69.*t134.*t258;
t282 = t70.*t134.*t258;
t283 = t71.*t136.*t259;
t284 = t72.*t136.*t259;
t285 = t69.*t134.*t260;
t286 = t69.*t134.*t261;
t287 = t70.*t134.*t260;
t288 = t70.*t134.*t261;
t289 = t71.*t136.*t262;
t290 = t71.*t136.*t263;
t291 = t72.*t136.*t262;
t292 = t72.*t136.*t263;
t293 = t77.*t134.*t258;
t294 = t78.*t134.*t258;
t296 = t79.*t136.*t259;
t297 = t80.*t136.*t259;
t299 = t77.*t134.*t260;
t300 = t77.*t134.*t261;
t301 = t78.*t134.*t260;
t302 = t78.*t134.*t261;
t307 = t79.*t136.*t262;
t308 = t79.*t136.*t263;
t309 = t80.*t136.*t262;
t310 = t80.*t136.*t263;
t322 = t65.*t66.*t134.*t258.*2.0;
t323 = t67.*t68.*t136.*t259.*2.0;
t324 = t65.*t66.*t134.*t260.*2.0;
t325 = t65.*t66.*t134.*t261.*2.0;
t326 = t67.*t68.*t136.*t262.*2.0;
t327 = t67.*t68.*t136.*t263.*2.0;
t328 = t65.*t73.*t134.*t258.*2.0;
t329 = t65.*t74.*t134.*t258.*2.0;
t330 = t66.*t73.*t134.*t258.*2.0;
t331 = t66.*t74.*t134.*t258.*2.0;
t332 = t67.*t75.*t136.*t259.*2.0;
t333 = t68.*t76.*t136.*t259.*2.0;
t334 = t65.*t73.*t134.*t260.*2.0;
t336 = t65.*t73.*t134.*t261.*2.0;
t337 = t65.*t74.*t134.*t260.*2.0;
t339 = t65.*t74.*t134.*t261.*2.0;
t340 = t66.*t73.*t134.*t260.*2.0;
t342 = t66.*t73.*t134.*t261.*2.0;
t343 = t66.*t74.*t134.*t260.*2.0;
t345 = t66.*t74.*t134.*t261.*2.0;
t346 = t67.*t75.*t136.*t262.*2.0;
t348 = t67.*t75.*t136.*t263.*2.0;
t349 = t68.*t76.*t136.*t262.*2.0;
t351 = t68.*t76.*t136.*t263.*2.0;
t356 = t73.*t74.*t134.*t258.*2.0;
t357 = t75.*t76.*t136.*t259.*2.0;
t358 = t73.*t74.*t134.*t260.*2.0;
t360 = t73.*t74.*t134.*t261.*2.0;
t361 = t75.*t76.*t136.*t262.*2.0;
t363 = t75.*t76.*t136.*t263.*2.0;
t268 = t150+t162;
t269 = t152+t159;
t270 = t153+t158;
t271 = t151+t163;
t272 = t265.*x13;
t273 = t266.*x14;
t274 = t264.*x15;
t295 = -t281;
t298 = -t283;
t303 = -t285;
t304 = -t286;
t305 = -t287;
t306 = -t288;
t311 = -t289;
t313 = -t293;
t314 = -t294;
t315 = -t297;
t317 = -t300;
t318 = -t301;
t320 = -t309;
t335 = -t328;
t338 = -t329;
t341 = -t330;
t344 = -t331;
t347 = -t332;
t350 = -t333;
t352 = -t336;
t353 = -t337;
t354 = -t342;
t355 = -t343;
t359 = -t356;
t362 = -t357;
t368 = t137+t138+t147+t148;
t369 = t137+t141+t143+t148;
t370 = t137+t142+t143+t147;
t371 = t139+t145+t146+t149;
t375 = t266.*t267;
t396 = t178+t202+t226+t238+t322+t356;
t402 = t164+t187+t237+t250+t334+t343;
t403 = t164+t187+t225+t254+t339+t342;
t405 = t168+t181+t233+t251+t336+t345;
t406 = t168+t181+t229+t253+t337+t340;
t407 = t182+t201+t208+t228+t324+t358;
t408 = t172+t198+t248+t255+t346+t349;
t409 = t175+t193+t247+t256+t348+t351;
t275 = t268.*x13;
t276 = t269.*x14;
t277 = t270.*x15;
t372 = t370.*x13;
t373 = t368.*x14;
t374 = t369.*x15;
t376 = t264.*t271;
t377 = t267.*t269;
t378 = t270.*t271;
t379 = -t375;
t380 = t267.*t368;
t381 = t265.*t371;
t382 = t271.*t369;
t383 = t268.*t371;
t384 = t370.*t371;
t392 = t178+t202+t205+t211+t322+t359;
t393 = t165+t189+t223+t235+t330+t338;
t394 = t167+t185+t227+t231+t331+t335;
t395 = t190+t213+t216+t222+t323+t362;
t397 = t165+t171+t235+t249+t338+t341;
t398 = t166+t168+t229+t233+t345+t352;
t399 = t166+t168+t229+t233+t340+t353;
t400 = t167+t169+t227+t252+t335+t344;
t401 = t174+t176+t241+t257+t347+t350;
t410 = t164+t170+t250+t254+t334+t355;
t411 = t164+t170+t250+t254+t339+t354;
t416 = t183+t200+t207+t209+t281+t282+t313+t314;
t417 = t180+t183+t209+t230+t282+t293+t295+t314;
t418 = t180+t183+t207+t234+t282+t294+t295+t313;
t419 = t192+t195+t220+t244+t284+t296+t298+t315;
t420 = t179+t188+t204+t210+t287+t299+t303+t318;
t421 = t182+t184+t206+t208+t288+t302+t304+t317;
t422 = t191+t199+t215+t221+t291+t307+t311+t320;
t423 = t179+t203+t204+t236+t299+t301+t303+t305;
t425 = t182+t201+t208+t228+t300+t302+t304+t306;
t278 = -t275;
t279 = -t276;
t280 = -t277;
t385 = -t384;
t428 = t378+t380+t381;
t431 = t379+t382+t383;
t386 = t274+t279+t372+x1;
t387 = t272+t280+t373+x2;
t388 = t273+t278+t374+x3;
t429 = b.*t428;
t430 = t376+t377+t385;
t434 = c.*t431;
t389 = a.*t386;
t390 = b.*t387;
t391 = c.*t388;
t432 = a.*t430;
t433 = -t429;
t435 = t2+t389+t390+t391;
t436 = t432+t433+t434;
t437 = 1.0./t436;
t438 = t437.^2;
mt1 = [1.0,0.0,0.0,0.0,0.0,0.0,a.*t437,0.0,1.0,0.0,0.0,0.0,0.0,b.*t437,0.0,0.0,1.0,0.0,0.0,0.0,c.*t437,0.0,0.0,0.0,1.0,0.0,0.0,t437.*(-b.*(-t405.*x13+t411.*x15+t425.*x14)+c.*(t403.*x14-t421.*x15+x13.*(t188+t204+t236-t325+t360-t65.*t90.*t133.*2.0))+a.*(x13.*(t201+t206+t208+t286+t302+t306+t317-t65.*t92.*t133.*2.0)+x15.*(t203+t204+t236+t325+t360+t65.*t90.*t133.*2.0)+t398.*x14))+t435.*t438.*(c.*(t267.*t403+t271.*t421+t371.*(t188+t204+t236-t325+t360-t65.*t90.*t133.*2.0))+a.*(t371.*(t201+t206+t208+t286+t302+t306+t317-t65.*t92.*t133.*2.0)-t271.*(t203+t204+t236+t325+t360+t65.*t90.*t133.*2.0)+t267.*t398)+b.*(t271.*t411-t267.*t425+t371.*t405)),0.0,0.0,0.0];
mt2 = [0.0,1.0,0.0,t437.*(a.*(t394.*x14+t396.*x15-t417.*x13)+b.*(t393.*x15-t400.*x13+t416.*x14)-c.*(t392.*x13+t397.*x14+t418.*x15))-t435.*t438.*(a.*(-t267.*t394+t271.*t396+t371.*t417)+b.*(t271.*t393-t267.*t416+t371.*t400)+c.*(t267.*t397-t271.*t418+t371.*t392)),0.0,0.0,0.0,0.0,0.0,1.0];
mt3 = [t437.*(-a.*(-t407.*x15+t410.*x14+t420.*x13)+b.*(t399.*x15+t402.*x13-t423.*x14)+c.*(x15.*(t203+t204+t210+t285+t299+t305+t318-t65.*t90.*t133.*2.0)+t406.*x14+x13.*(t184+t208+t228-t324+t358-t65.*t92.*t133.*2.0)))-t435.*t438.*(-c.*(-t271.*(t203+t204+t210+t285+t299+t305+t318-t65.*t90.*t133.*2.0)+t267.*t406+t371.*(t184+t208+t228-t324+t358-t65.*t92.*t133.*2.0))+a.*(t267.*t410+t271.*t407+t371.*t420)+b.*(t271.*t399+t267.*t423-t371.*t402)),0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
mt4 = [t437.*(a.*t370+b.*t265-c.*t268),0.0,0.0,0.0,0.0,0.0,0.0,t437.*(-a.*t269+b.*t368+c.*t266),0.0,0.0,0.0,0.0,0.0,0.0,t437.*(a.*t264-b.*t270+c.*t369),0.0,0.0,0.0,0.0,0.0,0.0];
mt5 = [t435.*t438.*(a.*(-t269.*t409+t264.*(t199+t215-t327+t363-t67.*t94.*t135.*2.0-t76.*t87.*t135.*2.0)+t370.*(t212+t217+t219+t290-t292-t308+t310-t67.*t96.*t135.*2.0))+b.*(t368.*t409-t270.*(t199+t215-t327+t363-t67.*t94.*t135.*2.0-t76.*t87.*t135.*2.0)+t265.*(t212+t217+t219+t290-t292-t308+t310-t67.*t96.*t135.*2.0))+c.*(t266.*t409+t369.*(t199+t215-t327+t363-t67.*t94.*t135.*2.0-t76.*t87.*t135.*2.0)-t268.*(t212+t217+t219+t290-t292-t308+t310-t67.*t96.*t135.*2.0))),0.0,0.0,0.0,0.0,0.0,0.0];
mt6 = [-t435.*t438.*(a.*(t264.*t395-t269.*t401+t370.*t419)+b.*(-t270.*t395+t265.*t419+t368.*t401)+c.*(t266.*t401-t268.*t419+t369.*t395)),0.0,0.0,0.0,0.0,0.0,0.0,-t435.*t438.*(a.*(t269.*t408+t370.*t422-t264.*(t196+t219+t242-t326+t361-t67.*t96.*t135.*2.0))+b.*(t265.*t422-t368.*t408+t270.*(t196+t219+t242-t326+t361-t67.*t96.*t135.*2.0))-c.*(t266.*t408+t268.*t422+t369.*(t196+t219+t242-t326+t361-t67.*t96.*t135.*2.0)))];
H = reshape([mt1,mt2,mt3,mt4,mt5,mt6],7,18);
end
