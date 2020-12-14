/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * autoCons.c
 *
 * Code generation for function 'autoCons'
 *
 */

/* Include files */
#include "autoCons.h"
#include "F_HL_MPCfunc.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo tc_emlrtRSI = { 834,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo uc_emlrtRSI = { 835,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo vc_emlrtRSI = { 836,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo wc_emlrtRSI = { 837,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo xc_emlrtRSI = { 838,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo yc_emlrtRSI = { 839,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo ad_emlrtRSI = { 840,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo bd_emlrtRSI = { 841,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo cd_emlrtRSI = { 842,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo dd_emlrtRSI = { 843,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo ed_emlrtRSI = { 844,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo fd_emlrtRSI = { 845,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo gd_emlrtRSI = { 846,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo hd_emlrtRSI = { 847,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo id_emlrtRSI = { 848,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo jd_emlrtRSI = { 849,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo kd_emlrtRSI = { 850,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo ld_emlrtRSI = { 851,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo md_emlrtRSI = { 852,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRSInfo nd_emlrtRSI = { 853,/* lineNo */
  "autoCons",                          /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\autoCons.m"/* pathName */
};

static emlrtRTEInfo i_emlrtRTEI = { 13,/* lineNo */
  9,                                   /* colNo */
  "sqrt",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\sqrt.m"/* pName */
};

/* Function Definitions */
void autoCons(const emlrtStack *sp, const real_T in1[132], const real_T in2[8],
              const real_T in3[64], const real_T in4[16], real_T Sr, const
              real_T in6[2], const real_T in7[22], const real_T in8[22], const
              real_T in9[22], const real_T in10[22], const real_T in11[22],
              const real_T in12[2], real_T cineq[176], real_T ceq[88], real_T
              dcineq[23232], real_T dceq[11616])
{
  real_T t256;
  real_T t257;
  real_T t258;
  real_T t259;
  real_T t260;
  real_T t261;
  real_T t262;
  real_T t263;
  real_T t264;
  real_T t265;
  real_T t266;
  real_T t267;
  real_T t268;
  real_T t269;
  real_T t270;
  real_T t271;
  real_T t272;
  real_T t273;
  real_T t274;
  real_T t275;
  real_T t276;
  real_T t277;
  real_T t278;
  real_T t279;
  real_T t280;
  real_T t281;
  real_T t282;
  real_T t283;
  real_T t284;
  real_T t285;
  real_T t286;
  real_T t287;
  real_T t288;
  real_T t289;
  real_T t290;
  real_T t291;
  real_T t292;
  real_T t293;
  real_T t294;
  real_T t295;
  real_T t296;
  real_T t297;
  real_T t298;
  real_T t299;
  real_T t300;
  real_T t301;
  real_T t302;
  real_T t303;
  real_T t304;
  real_T t305;
  real_T t306;
  real_T t307;
  real_T t308;
  real_T t309;
  real_T t310;
  real_T t311;
  real_T t312;
  real_T t313;
  real_T t314;
  real_T t315;
  real_T t356;
  real_T t357;
  real_T t358;
  real_T t359;
  real_T t360;
  real_T t361;
  real_T t362;
  real_T t363;
  real_T t364;
  real_T t365;
  real_T t366;
  real_T t367;
  real_T t368;
  real_T t369;
  real_T t370;
  real_T t371;
  real_T t372;
  real_T t373;
  real_T t374;
  real_T t375;
  real_T t376;
  real_T t377;
  real_T t378;
  real_T t379;
  real_T t380;
  real_T t381;
  real_T t382;
  real_T t383;
  real_T t384;
  real_T t385;
  real_T t386;
  real_T t387;
  real_T t388;
  real_T t389;
  real_T t390;
  real_T t391;
  real_T t392;
  real_T t393;
  real_T t394;
  real_T t395;
  real_T t396;
  real_T t397;
  real_T t398;
  real_T t399;
  real_T t400;
  real_T t401;
  real_T t402;
  real_T t403;
  real_T t404;
  real_T t405;
  real_T t406;
  real_T t407;
  real_T t408;
  real_T t409;
  real_T t410;
  real_T t411;
  real_T t412;
  real_T t413;
  real_T t414;
  real_T t415;
  real_T t526;
  real_T t527;
  real_T t528;
  real_T t529;
  real_T t530;
  real_T t531;
  real_T t532;
  real_T t533;
  real_T t534;
  real_T t535;
  real_T t536;
  real_T t537;
  real_T t538;
  real_T t539;
  real_T t540;
  real_T t541;
  real_T t542;
  real_T t543;
  real_T t544;
  real_T t545;
  real_T t546;
  real_T t547;
  real_T t548;
  real_T t549;
  real_T t550;
  real_T t551;
  real_T t552;
  real_T t553;
  real_T t554;
  real_T t555;
  real_T t476;
  real_T t477;
  real_T t478;
  real_T t479;
  real_T t480;
  real_T t481;
  real_T t482;
  real_T t483;
  real_T t484;
  real_T t485;
  real_T t486;
  real_T t487;
  real_T t488;
  real_T t489;
  real_T t490;
  real_T t491;
  real_T t492;
  real_T t493;
  real_T t494;
  real_T t495;
  real_T t496;
  real_T t497;
  real_T t498;
  real_T t499;
  real_T t506;
  real_T t508;
  real_T t510;
  real_T t512;
  real_T t514;
  real_T t516;
  real_T t518;
  real_T t520;
  real_T t522;
  real_T t524;
  real_T t507;
  real_T t509;
  real_T t511;
  real_T t513;
  real_T t515;
  real_T t517;
  real_T t519;
  real_T t521;
  real_T t523;
  real_T t525;
  real_T t556;
  real_T t557;
  real_T t558;
  real_T t559;
  real_T t560;
  real_T t561;
  real_T t562;
  real_T t563;
  real_T t564;
  real_T t565;
  real_T t566;
  real_T t567;
  real_T t568;
  real_T t569;
  real_T t570;
  real_T t571;
  real_T t572;
  real_T t573;
  real_T t574;
  real_T t575;
  real_T t576;
  real_T t577;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;

  /* AUTOCONS */
  /*     [CINEQ,CEQ,DCINEQ,DCEQ] = AUTOCONS(IN1,IN2,IN3,IN4,SR,IN6,IN7,IN8,IN9,IN10,IN11,IN12) */
  /*     This function was generated by the Symbolic Math Toolbox version 8.4. */
  /*     09-Mar-2020 18:45:12 */
  t256 = in8[2] + -in1[12];
  t257 = in8[4] + -in1[24];
  t258 = in8[6] + -in1[36];
  t259 = in8[8] + -in1[48];
  t260 = in8[10] + -in1[60];
  t261 = in8[12] + -in1[72];
  t262 = in8[14] + -in1[84];
  t263 = in8[16] + -in1[96];
  t264 = in8[3] + -in1[16];
  t265 = in8[5] + -in1[28];
  t266 = in8[7] + -in1[40];
  t267 = in8[9] + -in1[52];
  t268 = in8[11] + -in1[64];
  t269 = in8[13] + -in1[76];
  t270 = in8[15] + -in1[88];
  t271 = in8[17] + -in1[100];
  t272 = in8[18] + -in1[108];
  t273 = in8[20] + -in1[120];
  t274 = in8[19] + -in1[112];
  t275 = in8[21] + -in1[124];
  t276 = in7[2] + -in1[12];
  t277 = in7[4] + -in1[24];
  t278 = in7[6] + -in1[36];
  t279 = in7[8] + -in1[48];
  t280 = in7[10] + -in1[60];
  t281 = in7[12] + -in1[72];
  t282 = in7[14] + -in1[84];
  t283 = in7[16] + -in1[96];
  t284 = in7[3] + -in1[16];
  t285 = in7[5] + -in1[28];
  t286 = in7[7] + -in1[40];
  t287 = in7[9] + -in1[52];
  t288 = in7[11] + -in1[64];
  t289 = in7[13] + -in1[76];
  t290 = in7[15] + -in1[88];
  t291 = in7[17] + -in1[100];
  t292 = in7[18] + -in1[108];
  t293 = in7[20] + -in1[120];
  t294 = in7[19] + -in1[112];
  t295 = in7[21] + -in1[124];
  t296 = -in1[12] + in1[0];
  t297 = -in1[24] + in1[12];
  t298 = -in1[36] + in1[24];
  t299 = -in1[48] + in1[36];
  t300 = -in1[60] + in1[48];
  t301 = -in1[72] + in1[60];
  t302 = -in1[84] + in1[72];
  t303 = -in1[96] + in1[84];
  t304 = -in1[16] + in1[4];
  t305 = -in1[28] + in1[16];
  t306 = -in1[40] + in1[28];
  t307 = -in1[52] + in1[40];
  t308 = -in1[64] + in1[52];
  t309 = -in1[76] + in1[64];
  t310 = -in1[88] + in1[76];
  t311 = -in1[100] + in1[88];
  t312 = -in1[108] + in1[96];
  t313 = -in1[120] + in1[108];
  t314 = -in1[112] + in1[100];
  t315 = -in1[124] + in1[112];
  t356 = muDoubleScalarSign(t296);
  t357 = muDoubleScalarSign(t297);
  t358 = muDoubleScalarSign(t298);
  t359 = muDoubleScalarSign(t299);
  t360 = muDoubleScalarSign(t300);
  t361 = muDoubleScalarSign(t301);
  t362 = muDoubleScalarSign(t302);
  t363 = muDoubleScalarSign(t303);
  t364 = muDoubleScalarSign(t304);
  t365 = muDoubleScalarSign(t305);
  t366 = muDoubleScalarSign(t306);
  t367 = muDoubleScalarSign(t307);
  t368 = muDoubleScalarSign(t308);
  t369 = muDoubleScalarSign(t309);
  t370 = muDoubleScalarSign(t310);
  t371 = muDoubleScalarSign(t311);
  t372 = muDoubleScalarSign(t312);
  t373 = muDoubleScalarSign(t313);
  t374 = muDoubleScalarSign(t314);
  t375 = muDoubleScalarSign(t315);
  t376 = muDoubleScalarAbs(t256);
  t377 = muDoubleScalarAbs(t257);
  t378 = muDoubleScalarAbs(t258);
  t379 = muDoubleScalarAbs(t259);
  t380 = muDoubleScalarAbs(t260);
  t381 = muDoubleScalarAbs(t261);
  t382 = muDoubleScalarAbs(t262);
  t383 = muDoubleScalarAbs(t263);
  t384 = muDoubleScalarAbs(t264);
  t385 = muDoubleScalarAbs(t265);
  t386 = muDoubleScalarAbs(t266);
  t387 = muDoubleScalarAbs(t267);
  t388 = muDoubleScalarAbs(t268);
  t389 = muDoubleScalarAbs(t269);
  t390 = muDoubleScalarAbs(t270);
  t391 = muDoubleScalarAbs(t271);
  t392 = muDoubleScalarAbs(t272);
  t393 = muDoubleScalarAbs(t273);
  t394 = muDoubleScalarAbs(t274);
  t395 = muDoubleScalarAbs(t275);
  t396 = muDoubleScalarAbs(t276);
  t397 = muDoubleScalarAbs(t277);
  t398 = muDoubleScalarAbs(t278);
  t399 = muDoubleScalarAbs(t279);
  t400 = muDoubleScalarAbs(t280);
  t401 = muDoubleScalarAbs(t281);
  t402 = muDoubleScalarAbs(t282);
  t403 = muDoubleScalarAbs(t283);
  t404 = muDoubleScalarAbs(t284);
  t405 = muDoubleScalarAbs(t285);
  t406 = muDoubleScalarAbs(t286);
  t407 = muDoubleScalarAbs(t287);
  t408 = muDoubleScalarAbs(t288);
  t409 = muDoubleScalarAbs(t289);
  t410 = muDoubleScalarAbs(t290);
  t411 = muDoubleScalarAbs(t291);
  t412 = muDoubleScalarAbs(t292);
  t413 = muDoubleScalarAbs(t293);
  t414 = muDoubleScalarAbs(t294);
  t415 = muDoubleScalarAbs(t295);
  t526 = ((((in9[12] * in7[2] + in9[1] * in1[16]) + in7[3] * in1[12]) + -(in9[1]
            * in7[3])) + -(in9[12] * in1[12])) + -(in7[2] * in1[16]);
  t527 = ((((in9[13] * in7[4] + in9[2] * in1[28]) + in7[5] * in1[24]) + -(in9[2]
            * in7[5])) + -(in9[13] * in1[24])) + -(in7[4] * in1[28]);
  t528 = ((((in9[14] * in7[6] + in9[3] * in1[40]) + in7[7] * in1[36]) + -(in9[3]
            * in7[7])) + -(in9[14] * in1[36])) + -(in7[6] * in1[40]);
  t529 = ((((in9[15] * in7[8] + in9[4] * in1[52]) + in7[9] * in1[48]) + -(in9[4]
            * in7[9])) + -(in9[15] * in1[48])) + -(in7[8] * in1[52]);
  t530 = ((((in9[16] * in7[10] + in9[5] * in1[64]) + in7[11] * in1[60]) + -(in9
            [5] * in7[11])) + -(in9[16] * in1[60])) + -(in7[10] * in1[64]);
  t531 = ((((in9[17] * in7[12] + in9[6] * in1[76]) + in7[13] * in1[72]) + -(in9
            [6] * in7[13])) + -(in9[17] * in1[72])) + -(in7[12] * in1[76]);
  t532 = ((((in9[18] * in7[14] + in9[7] * in1[88]) + in7[15] * in1[84]) + -(in9
            [7] * in7[15])) + -(in9[18] * in1[84])) + -(in7[14] * in1[88]);
  t533 = ((((in9[19] * in7[16] + in9[8] * in1[100]) + in7[17] * in1[96]) +
           -(in9[8] * in7[17])) + -(in9[19] * in1[96])) + -(in7[16] * in1[100]);
  t534 = ((((in9[20] * in7[18] + in9[9] * in1[112]) + in7[19] * in1[108]) +
           -(in9[9] * in7[19])) + -(in9[20] * in1[108])) + -(in7[18] * in1[112]);
  t535 = ((((in9[21] * in7[20] + in9[10] * in1[124]) + in7[21] * in1[120]) +
           -(in9[10] * in7[21])) + -(in9[21] * in1[120])) + -(in7[20] * in1[124]);
  t536 = muDoubleScalarAbs(t526);
  t537 = muDoubleScalarAbs(t527);
  t538 = muDoubleScalarAbs(t528);
  t539 = muDoubleScalarAbs(t529);
  t540 = muDoubleScalarAbs(t530);
  t541 = muDoubleScalarAbs(t531);
  t542 = muDoubleScalarAbs(t532);
  t543 = muDoubleScalarAbs(t533);
  t544 = muDoubleScalarAbs(t534);
  t545 = muDoubleScalarAbs(t535);
  t546 = muDoubleScalarSign(t526);
  t547 = muDoubleScalarSign(t527);
  t548 = muDoubleScalarSign(t528);
  t549 = muDoubleScalarSign(t529);
  t550 = muDoubleScalarSign(t530);
  t551 = muDoubleScalarSign(t531);
  t552 = muDoubleScalarSign(t532);
  t553 = muDoubleScalarSign(t533);
  t554 = muDoubleScalarSign(t534);
  t555 = muDoubleScalarSign(t535);
  t476 = t376 * t376 + t384 * t384;
  st.site = &tc_emlrtRSI;
  if (t476 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t476 = muDoubleScalarSqrt(t476);
  t477 = t377 * t377 + t385 * t385;
  st.site = &uc_emlrtRSI;
  if (t477 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t477 = muDoubleScalarSqrt(t477);
  t478 = t378 * t378 + t386 * t386;
  st.site = &vc_emlrtRSI;
  if (t478 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t478 = muDoubleScalarSqrt(t478);
  t479 = t379 * t379 + t387 * t387;
  st.site = &wc_emlrtRSI;
  if (t479 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t479 = muDoubleScalarSqrt(t479);
  t480 = t380 * t380 + t388 * t388;
  st.site = &xc_emlrtRSI;
  if (t480 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t480 = muDoubleScalarSqrt(t480);
  t481 = t381 * t381 + t389 * t389;
  st.site = &yc_emlrtRSI;
  if (t481 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t481 = muDoubleScalarSqrt(t481);
  t482 = t382 * t382 + t390 * t390;
  st.site = &ad_emlrtRSI;
  if (t482 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t482 = muDoubleScalarSqrt(t482);
  t483 = t383 * t383 + t391 * t391;
  st.site = &bd_emlrtRSI;
  if (t483 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t483 = muDoubleScalarSqrt(t483);
  t484 = t392 * t392 + t394 * t394;
  st.site = &cd_emlrtRSI;
  if (t484 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t484 = muDoubleScalarSqrt(t484);
  t485 = t393 * t393 + t395 * t395;
  st.site = &dd_emlrtRSI;
  if (t485 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t485 = muDoubleScalarSqrt(t485);
  t486 = t396 * t396 + t404 * t404;
  st.site = &ed_emlrtRSI;
  if (t486 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t486 = muDoubleScalarSqrt(t486);
  t487 = t397 * t397 + t405 * t405;
  st.site = &fd_emlrtRSI;
  if (t487 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t487 = muDoubleScalarSqrt(t487);
  t488 = t398 * t398 + t406 * t406;
  st.site = &gd_emlrtRSI;
  if (t488 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t488 = muDoubleScalarSqrt(t488);
  t489 = t399 * t399 + t407 * t407;
  st.site = &hd_emlrtRSI;
  if (t489 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t489 = muDoubleScalarSqrt(t489);
  t490 = t400 * t400 + t408 * t408;
  st.site = &id_emlrtRSI;
  if (t490 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t490 = muDoubleScalarSqrt(t490);
  t491 = t401 * t401 + t409 * t409;
  st.site = &jd_emlrtRSI;
  if (t491 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t491 = muDoubleScalarSqrt(t491);
  t492 = t402 * t402 + t410 * t410;
  st.site = &kd_emlrtRSI;
  if (t492 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t492 = muDoubleScalarSqrt(t492);
  t493 = t403 * t403 + t411 * t411;
  st.site = &ld_emlrtRSI;
  if (t493 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t493 = muDoubleScalarSqrt(t493);
  t494 = t412 * t412 + t414 * t414;
  st.site = &md_emlrtRSI;
  if (t494 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t494 = muDoubleScalarSqrt(t494);
  t495 = t413 * t413 + t415 * t415;
  st.site = &nd_emlrtRSI;
  if (t495 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&st, &i_emlrtRTEI,
      "Coder:toolbox:ElFunDomainError", "Coder:toolbox:ElFunDomainError", 3, 4,
      4, "sqrt");
  }

  t495 = muDoubleScalarSqrt(t495);
  t496 = 1.0 / t476;
  t497 = 1.0 / t477;
  t498 = 1.0 / t478;
  t499 = 1.0 / t479;
  t526 = 1.0 / t480;
  t527 = 1.0 / t481;
  t528 = 1.0 / t482;
  t529 = 1.0 / t483;
  t530 = 1.0 / t484;
  t531 = 1.0 / t485;
  t506 = 1.0 / t486;
  t508 = 1.0 / t487;
  t510 = 1.0 / t488;
  t512 = 1.0 / t489;
  t514 = 1.0 / t490;
  t516 = 1.0 / t491;
  t518 = 1.0 / t492;
  t520 = 1.0 / t493;
  t522 = 1.0 / t494;
  t524 = 1.0 / t495;
  t507 = muDoubleScalarPower(t506, 3.0);
  t509 = muDoubleScalarPower(t508, 3.0);
  t511 = muDoubleScalarPower(t510, 3.0);
  t513 = muDoubleScalarPower(t512, 3.0);
  t515 = muDoubleScalarPower(t514, 3.0);
  t517 = muDoubleScalarPower(t516, 3.0);
  t519 = muDoubleScalarPower(t518, 3.0);
  t521 = muDoubleScalarPower(t520, 3.0);
  t523 = muDoubleScalarPower(t522, 3.0);
  t525 = muDoubleScalarPower(t524, 3.0);
  t556 = muDoubleScalarSign(t256) * t376 * t496;
  t557 = muDoubleScalarSign(t257) * t377 * t497;
  t558 = muDoubleScalarSign(t258) * t378 * t498;
  t559 = muDoubleScalarSign(t259) * t379 * t499;
  t560 = muDoubleScalarSign(t260) * t380 * t526;
  t561 = muDoubleScalarSign(t261) * t381 * t527;
  t562 = muDoubleScalarSign(t262) * t382 * t528;
  t563 = muDoubleScalarSign(t263) * t383 * t529;
  t564 = muDoubleScalarSign(t264) * t384 * t496;
  t565 = muDoubleScalarSign(t265) * t385 * t497;
  t566 = muDoubleScalarSign(t266) * t386 * t498;
  t567 = muDoubleScalarSign(t267) * t387 * t499;
  t568 = muDoubleScalarSign(t268) * t388 * t526;
  t569 = muDoubleScalarSign(t269) * t389 * t527;
  t570 = muDoubleScalarSign(t270) * t390 * t528;
  t571 = muDoubleScalarSign(t271) * t391 * t529;
  t572 = muDoubleScalarSign(t272) * t392 * t530;
  t573 = muDoubleScalarSign(t273) * t393 * t531;
  t574 = muDoubleScalarSign(t274) * t394 * t530;
  t575 = muDoubleScalarSign(t275) * t395 * t531;
  t395 = muDoubleScalarSign(t276) * t396;
  t576 = t395 * t506;
  t275 = muDoubleScalarSign(t277) * t397;
  t577 = t275 * t508;
  t274 = muDoubleScalarSign(t278) * t398;
  t397 = t274 * t510;
  t393 = muDoubleScalarSign(t279) * t399;
  t277 = t393 * t512;
  t392 = muDoubleScalarSign(t280) * t400;
  t396 = t392 * t514;
  t272 = muDoubleScalarSign(t281) * t401;
  t276 = t272 * t516;
  t271 = muDoubleScalarSign(t282) * t402;
  t394 = t271 * t518;
  t390 = muDoubleScalarSign(t283) * t403;
  t273 = t390 * t520;
  t264 = muDoubleScalarSign(t284) * t404;
  t391 = t264 * t506;
  t383 = muDoubleScalarSign(t285) * t405;
  t270 = t383 * t508;
  t382 = muDoubleScalarSign(t286) * t406;
  t389 = t382 * t510;
  t262 = muDoubleScalarSign(t287) * t407;
  t269 = t262 * t512;
  t381 = muDoubleScalarSign(t288) * t408;
  t388 = t381 * t514;
  t261 = muDoubleScalarSign(t289) * t409;
  t268 = t261 * t516;
  t380 = muDoubleScalarSign(t290) * t410;
  t387 = t380 * t518;
  t260 = muDoubleScalarSign(t291) * t411;
  t267 = t260 * t520;
  t385 = muDoubleScalarSign(t292) * t412;
  t386 = t385 * t522;
  t265 = muDoubleScalarSign(t293) * t413;
  t266 = t265 * t524;
  t379 = muDoubleScalarSign(t294) * t414;
  t384 = t379 * t522;
  t259 = muDoubleScalarSign(t295) * t415;
  t263 = t259 * t524;
  t526 = t506 * t536;
  t527 = t508 * t537;
  t528 = t510 * t538;
  t529 = t512 * t539;
  t530 = t514 * t540;
  t531 = t516 * t541;
  t532 = t518 * t542;
  t533 = t520 * t543;
  t534 = t522 * t544;
  t535 = t524 * t545;
  cineq[0] = -in1[10];
  cineq[1] = -in1[22];
  cineq[2] = -in1[34];
  cineq[3] = -in1[46];
  cineq[4] = -in1[58];
  cineq[5] = -in1[70];
  cineq[6] = -in1[82];
  cineq[7] = -in1[94];
  cineq[8] = -in1[106];
  cineq[9] = -in1[118];
  cineq[10] = -in1[130];
  cineq[11] = -in1[11];
  cineq[12] = -in1[23];
  cineq[13] = -in1[35];
  cineq[14] = -in1[47];
  cineq[15] = -in1[59];
  cineq[16] = -in1[71];
  cineq[17] = -in1[83];
  cineq[18] = -in1[95];
  cineq[19] = -in1[107];
  cineq[20] = -in1[119];
  cineq[21] = -in1[131];
  memset(&cineq[22], 0, 22U * sizeof(real_T));
  cineq[44] = -in6[0] + t486;
  cineq[45] = -in6[0] + t487;
  cineq[46] = -in6[0] + t488;
  cineq[47] = -in6[0] + t489;
  cineq[48] = -in6[0] + t490;
  cineq[49] = -in6[0] + t491;
  cineq[50] = -in6[0] + t492;
  cineq[51] = -in6[0] + t493;
  cineq[52] = -in6[0] + t494;
  cineq[53] = -in6[0] + t495;
  cineq[54] = 0.0;
  cineq[55] = in6[1] - t486;
  cineq[56] = in6[1] - t487;
  cineq[57] = in6[1] - t488;
  cineq[58] = in6[1] - t489;
  cineq[59] = in6[1] - t490;
  cineq[60] = in6[1] - t491;
  cineq[61] = in6[1] - t492;
  cineq[62] = in6[1] - t493;
  cineq[63] = in6[1] - t494;
  cineq[64] = in6[1] - t495;
  cineq[65] = 0.0;
  cineq[66] = -in6[0] + t476;
  cineq[67] = -in6[0] + t477;
  cineq[68] = -in6[0] + t478;
  cineq[69] = -in6[0] + t479;
  cineq[70] = -in6[0] + t480;
  cineq[71] = -in6[0] + t481;
  cineq[72] = -in6[0] + t482;
  cineq[73] = -in6[0] + t483;
  cineq[74] = -in6[0] + t484;
  cineq[75] = -in6[0] + t485;
  cineq[76] = 0.0;
  cineq[77] = in6[1] - t476;
  cineq[78] = in6[1] - t477;
  cineq[79] = in6[1] - t478;
  cineq[80] = in6[1] - t479;
  cineq[81] = in6[1] - t480;
  cineq[82] = in6[1] - t481;
  cineq[83] = in6[1] - t482;
  cineq[84] = in6[1] - t483;
  cineq[85] = in6[1] - t484;
  cineq[86] = in6[1] - t485;
  cineq[87] = 0.0;
  t378 = -Sr + -in1[22];
  cineq[88] = t378 + muDoubleScalarAbs(t296);
  t258 = -Sr + -in1[34];
  cineq[89] = t258 + muDoubleScalarAbs(t297);
  t499 = -Sr + -in1[46];
  cineq[90] = t499 + muDoubleScalarAbs(t298);
  t377 = -Sr + -in1[58];
  cineq[91] = t377 + muDoubleScalarAbs(t299);
  t257 = -Sr + -in1[70];
  cineq[92] = t257 + muDoubleScalarAbs(t300);
  t498 = -Sr + -in1[82];
  cineq[93] = t498 + muDoubleScalarAbs(t301);
  t376 = -Sr + -in1[94];
  cineq[94] = t376 + muDoubleScalarAbs(t302);
  t256 = -Sr + -in1[106];
  cineq[95] = t256 + muDoubleScalarAbs(t303);
  t497 = -Sr + -in1[118];
  cineq[96] = t497 + muDoubleScalarAbs(t312);
  t496 = -Sr + -in1[130];
  cineq[97] = t496 + muDoubleScalarAbs(t313);
  cineq[98] = 0.0;
  cineq[99] = t378 + muDoubleScalarAbs(t304);
  cineq[100] = t258 + muDoubleScalarAbs(t305);
  cineq[101] = t499 + muDoubleScalarAbs(t306);
  cineq[102] = t377 + muDoubleScalarAbs(t307);
  cineq[103] = t257 + muDoubleScalarAbs(t308);
  cineq[104] = t498 + muDoubleScalarAbs(t309);
  cineq[105] = t376 + muDoubleScalarAbs(t310);
  cineq[106] = t256 + muDoubleScalarAbs(t311);
  cineq[107] = t497 + muDoubleScalarAbs(t314);
  cineq[108] = t496 + muDoubleScalarAbs(t315);
  cineq[109] = 0.0;
  cineq[110] = -in12[1] + t526;
  cineq[111] = -in12[1] + t527;
  cineq[112] = -in12[1] + t528;
  cineq[113] = -in12[1] + t529;
  cineq[114] = -in12[1] + t530;
  cineq[115] = -in12[1] + t531;
  cineq[116] = -in12[1] + t532;
  cineq[117] = -in12[1] + t533;
  cineq[118] = -in12[1] + t534;
  cineq[119] = -in12[1] + t535;
  cineq[120] = 0.0;
  cineq[121] = (-in12[0] + -in1[23]) + t526;
  cineq[122] = (-in12[0] + -in1[35]) + t527;
  cineq[123] = (-in12[0] + -in1[47]) + t528;
  cineq[124] = (-in12[0] + -in1[59]) + t529;
  cineq[125] = (-in12[0] + -in1[71]) + t530;
  cineq[126] = (-in12[0] + -in1[83]) + t531;
  cineq[127] = (-in12[0] + -in1[95]) + t532;
  cineq[128] = (-in12[0] + -in1[107]) + t533;
  cineq[129] = (-in12[0] + -in1[119]) + t534;
  cineq[130] = (-in12[0] + -in1[131]) + t535;
  cineq[131] = 0.0;
  cineq[132] = -in1[16] + in11[1];
  cineq[133] = -in1[28] + in11[2];
  cineq[134] = -in1[40] + in11[3];
  cineq[135] = -in1[52] + in11[4];
  cineq[136] = -in1[64] + in11[5];
  cineq[137] = -in1[76] + in11[6];
  cineq[138] = -in1[88] + in11[7];
  cineq[139] = -in1[100] + in11[8];
  cineq[140] = -in1[112] + in11[9];
  cineq[141] = -in1[124] + in11[10];
  cineq[142] = 0.0;
  cineq[143] = -in11[12] + in1[16];
  cineq[144] = -in11[13] + in1[28];
  cineq[145] = -in11[14] + in1[40];
  cineq[146] = -in11[15] + in1[52];
  cineq[147] = -in11[16] + in1[64];
  cineq[148] = -in11[17] + in1[76];
  cineq[149] = -in11[18] + in1[88];
  cineq[150] = -in11[19] + in1[100];
  cineq[151] = -in11[20] + in1[112];
  cineq[152] = -in11[21] + in1[124];
  cineq[153] = 0.0;
  cineq[154] = -in1[12] + in10[1];
  cineq[155] = -in1[24] + in10[2];
  cineq[156] = -in1[36] + in10[3];
  cineq[157] = -in1[48] + in10[4];
  cineq[158] = -in1[60] + in10[5];
  cineq[159] = -in1[72] + in10[6];
  cineq[160] = -in1[84] + in10[7];
  cineq[161] = -in1[96] + in10[8];
  cineq[162] = -in1[108] + in10[9];
  cineq[163] = -in1[120] + in10[10];
  cineq[164] = 0.0;
  cineq[165] = -in10[12] + in1[12];
  cineq[166] = -in10[13] + in1[24];
  cineq[167] = -in10[14] + in1[36];
  cineq[168] = -in10[15] + in1[48];
  cineq[169] = -in10[16] + in1[60];
  cineq[170] = -in10[17] + in1[72];
  cineq[171] = -in10[18] + in1[84];
  cineq[172] = -in10[19] + in1[96];
  cineq[173] = -in10[20] + in1[108];
  cineq[174] = -in10[21] + in1[120];
  cineq[175] = 0.0;
  ceq[0] = -in2[0] + in1[0];
  ceq[1] = (((((((((in1[12] + -in4[8] * in1[9]) + -in3[0] * in1[0]) + -in3[8] *
                  in1[1]) + -in3[16] * in1[2]) + -in3[24] * in1[3]) + -in3[32] *
               in1[4]) + -in3[40] * in1[5]) + -in3[48] * in1[6]) + -in3[56] *
            in1[7]) + -in4[0] * in1[8];
  ceq[2] = (((((((((in1[24] + -in4[8] * in1[21]) + -in3[0] * in1[12]) + -in3[8] *
                  in1[13]) + -in3[16] * in1[14]) + -in3[24] * in1[15]) + -in3[32]
               * in1[16]) + -in3[40] * in1[17]) + -in3[48] * in1[18]) + -in3[56]
            * in1[19]) + -in4[0] * in1[20];
  ceq[3] = (((((((((in1[36] + -in4[8] * in1[33]) + -in3[0] * in1[24]) + -in3[8] *
                  in1[25]) + -in3[16] * in1[26]) + -in3[24] * in1[27]) + -in3[32]
               * in1[28]) + -in3[40] * in1[29]) + -in3[48] * in1[30]) + -in3[56]
            * in1[31]) + -in4[0] * in1[32];
  ceq[4] = (((((((((in1[48] + -in4[8] * in1[45]) + -in3[0] * in1[36]) + -in3[8] *
                  in1[37]) + -in3[16] * in1[38]) + -in3[24] * in1[39]) + -in3[32]
               * in1[40]) + -in3[40] * in1[41]) + -in3[48] * in1[42]) + -in3[56]
            * in1[43]) + -in4[0] * in1[44];
  ceq[5] = (((((((((in1[60] + -in4[8] * in1[57]) + -in3[0] * in1[48]) + -in3[8] *
                  in1[49]) + -in3[16] * in1[50]) + -in3[24] * in1[51]) + -in3[32]
               * in1[52]) + -in3[40] * in1[53]) + -in3[48] * in1[54]) + -in3[56]
            * in1[55]) + -in4[0] * in1[56];
  ceq[6] = (((((((((in1[72] + -in4[8] * in1[69]) + -in3[0] * in1[60]) + -in3[8] *
                  in1[61]) + -in3[16] * in1[62]) + -in3[24] * in1[63]) + -in3[32]
               * in1[64]) + -in3[40] * in1[65]) + -in3[48] * in1[66]) + -in3[56]
            * in1[67]) + -in4[0] * in1[68];
  ceq[7] = (((((((((in1[84] + -in4[8] * in1[81]) + -in3[0] * in1[72]) + -in3[8] *
                  in1[73]) + -in3[16] * in1[74]) + -in3[24] * in1[75]) + -in3[32]
               * in1[76]) + -in3[40] * in1[77]) + -in3[48] * in1[78]) + -in3[56]
            * in1[79]) + -in4[0] * in1[80];
  ceq[8] = (((((((((in1[96] + -in4[8] * in1[93]) + -in3[0] * in1[84]) + -in3[8] *
                  in1[85]) + -in3[16] * in1[86]) + -in3[24] * in1[87]) + -in3[32]
               * in1[88]) + -in3[40] * in1[89]) + -in3[48] * in1[90]) + -in3[56]
            * in1[91]) + -in4[0] * in1[92];
  ceq[9] = (((((((((in1[108] + -in4[8] * in1[105]) + -in3[0] * in1[96]) + -in3[8]
                  * in1[97]) + -in3[16] * in1[98]) + -in3[24] * in1[99]) + -in3
               [32] * in1[100]) + -in3[40] * in1[101]) + -in3[48] * in1[102]) +
            -in3[56] * in1[103]) + -in4[0] * in1[104];
  ceq[10] = (((((((((in1[120] + -in4[8] * in1[117]) + -in3[0] * in1[108]) +
                   -in3[8] * in1[109]) + -in3[16] * in1[110]) + -in3[24] * in1
                 [111]) + -in3[32] * in1[112]) + -in3[40] * in1[113]) + -in3[48]
              * in1[114]) + -in3[56] * in1[115]) + -in4[0] * in1[116];
  ceq[11] = -in2[1] + in1[1];
  ceq[12] = (((((((((in1[13] + -in4[9] * in1[9]) + -in3[1] * in1[0]) + -in3[9] *
                   in1[1]) + -in3[17] * in1[2]) + -in3[25] * in1[3]) + -in3[33] *
                in1[4]) + -in3[41] * in1[5]) + -in3[49] * in1[6]) + -in3[57] *
             in1[7]) + -in4[1] * in1[8];
  ceq[13] = (((((((((in1[25] + -in4[9] * in1[21]) + -in3[1] * in1[12]) + -in3[9]
                   * in1[13]) + -in3[17] * in1[14]) + -in3[25] * in1[15]) +
                -in3[33] * in1[16]) + -in3[41] * in1[17]) + -in3[49] * in1[18])
             + -in3[57] * in1[19]) + -in4[1] * in1[20];
  ceq[14] = (((((((((in1[37] + -in4[9] * in1[33]) + -in3[1] * in1[24]) + -in3[9]
                   * in1[25]) + -in3[17] * in1[26]) + -in3[25] * in1[27]) +
                -in3[33] * in1[28]) + -in3[41] * in1[29]) + -in3[49] * in1[30])
             + -in3[57] * in1[31]) + -in4[1] * in1[32];
  ceq[15] = (((((((((in1[49] + -in4[9] * in1[45]) + -in3[1] * in1[36]) + -in3[9]
                   * in1[37]) + -in3[17] * in1[38]) + -in3[25] * in1[39]) +
                -in3[33] * in1[40]) + -in3[41] * in1[41]) + -in3[49] * in1[42])
             + -in3[57] * in1[43]) + -in4[1] * in1[44];
  ceq[16] = (((((((((in1[61] + -in4[9] * in1[57]) + -in3[1] * in1[48]) + -in3[9]
                   * in1[49]) + -in3[17] * in1[50]) + -in3[25] * in1[51]) +
                -in3[33] * in1[52]) + -in3[41] * in1[53]) + -in3[49] * in1[54])
             + -in3[57] * in1[55]) + -in4[1] * in1[56];
  ceq[17] = (((((((((in1[73] + -in4[9] * in1[69]) + -in3[1] * in1[60]) + -in3[9]
                   * in1[61]) + -in3[17] * in1[62]) + -in3[25] * in1[63]) +
                -in3[33] * in1[64]) + -in3[41] * in1[65]) + -in3[49] * in1[66])
             + -in3[57] * in1[67]) + -in4[1] * in1[68];
  ceq[18] = (((((((((in1[85] + -in4[9] * in1[81]) + -in3[1] * in1[72]) + -in3[9]
                   * in1[73]) + -in3[17] * in1[74]) + -in3[25] * in1[75]) +
                -in3[33] * in1[76]) + -in3[41] * in1[77]) + -in3[49] * in1[78])
             + -in3[57] * in1[79]) + -in4[1] * in1[80];
  ceq[19] = (((((((((in1[97] + -in4[9] * in1[93]) + -in3[1] * in1[84]) + -in3[9]
                   * in1[85]) + -in3[17] * in1[86]) + -in3[25] * in1[87]) +
                -in3[33] * in1[88]) + -in3[41] * in1[89]) + -in3[49] * in1[90])
             + -in3[57] * in1[91]) + -in4[1] * in1[92];
  ceq[20] = (((((((((in1[109] + -in4[9] * in1[105]) + -in3[1] * in1[96]) + -in3
                   [9] * in1[97]) + -in3[17] * in1[98]) + -in3[25] * in1[99]) +
                -in3[33] * in1[100]) + -in3[41] * in1[101]) + -in3[49] * in1[102])
             + -in3[57] * in1[103]) + -in4[1] * in1[104];
  ceq[21] = (((((((((in1[121] + -in4[9] * in1[117]) + -in3[1] * in1[108]) +
                   -in3[9] * in1[109]) + -in3[17] * in1[110]) + -in3[25] * in1
                 [111]) + -in3[33] * in1[112]) + -in3[41] * in1[113]) + -in3[49]
              * in1[114]) + -in3[57] * in1[115]) + -in4[1] * in1[116];
  ceq[22] = -in2[2] + in1[2];
  ceq[23] = (((((((((in1[14] + -in4[10] * in1[9]) + -in3[2] * in1[0]) + -in3[10]
                   * in1[1]) + -in3[18] * in1[2]) + -in3[26] * in1[3]) + -in3[34]
                * in1[4]) + -in3[42] * in1[5]) + -in3[50] * in1[6]) + -in3[58] *
             in1[7]) + -in4[2] * in1[8];
  ceq[24] = (((((((((in1[26] + -in4[10] * in1[21]) + -in3[2] * in1[12]) + -in3
                   [10] * in1[13]) + -in3[18] * in1[14]) + -in3[26] * in1[15]) +
                -in3[34] * in1[16]) + -in3[42] * in1[17]) + -in3[50] * in1[18])
             + -in3[58] * in1[19]) + -in4[2] * in1[20];
  ceq[25] = (((((((((in1[38] + -in4[10] * in1[33]) + -in3[2] * in1[24]) + -in3
                   [10] * in1[25]) + -in3[18] * in1[26]) + -in3[26] * in1[27]) +
                -in3[34] * in1[28]) + -in3[42] * in1[29]) + -in3[50] * in1[30])
             + -in3[58] * in1[31]) + -in4[2] * in1[32];
  ceq[26] = (((((((((in1[50] + -in4[10] * in1[45]) + -in3[2] * in1[36]) + -in3
                   [10] * in1[37]) + -in3[18] * in1[38]) + -in3[26] * in1[39]) +
                -in3[34] * in1[40]) + -in3[42] * in1[41]) + -in3[50] * in1[42])
             + -in3[58] * in1[43]) + -in4[2] * in1[44];
  ceq[27] = (((((((((in1[62] + -in4[10] * in1[57]) + -in3[2] * in1[48]) + -in3
                   [10] * in1[49]) + -in3[18] * in1[50]) + -in3[26] * in1[51]) +
                -in3[34] * in1[52]) + -in3[42] * in1[53]) + -in3[50] * in1[54])
             + -in3[58] * in1[55]) + -in4[2] * in1[56];
  ceq[28] = (((((((((in1[74] + -in4[10] * in1[69]) + -in3[2] * in1[60]) + -in3
                   [10] * in1[61]) + -in3[18] * in1[62]) + -in3[26] * in1[63]) +
                -in3[34] * in1[64]) + -in3[42] * in1[65]) + -in3[50] * in1[66])
             + -in3[58] * in1[67]) + -in4[2] * in1[68];
  ceq[29] = (((((((((in1[86] + -in4[10] * in1[81]) + -in3[2] * in1[72]) + -in3
                   [10] * in1[73]) + -in3[18] * in1[74]) + -in3[26] * in1[75]) +
                -in3[34] * in1[76]) + -in3[42] * in1[77]) + -in3[50] * in1[78])
             + -in3[58] * in1[79]) + -in4[2] * in1[80];
  ceq[30] = (((((((((in1[98] + -in4[10] * in1[93]) + -in3[2] * in1[84]) + -in3
                   [10] * in1[85]) + -in3[18] * in1[86]) + -in3[26] * in1[87]) +
                -in3[34] * in1[88]) + -in3[42] * in1[89]) + -in3[50] * in1[90])
             + -in3[58] * in1[91]) + -in4[2] * in1[92];
  ceq[31] = (((((((((in1[110] + -in4[10] * in1[105]) + -in3[2] * in1[96]) +
                   -in3[10] * in1[97]) + -in3[18] * in1[98]) + -in3[26] * in1[99])
                + -in3[34] * in1[100]) + -in3[42] * in1[101]) + -in3[50] * in1
              [102]) + -in3[58] * in1[103]) + -in4[2] * in1[104];
  ceq[32] = (((((((((in1[122] + -in4[10] * in1[117]) + -in3[2] * in1[108]) +
                   -in3[10] * in1[109]) + -in3[18] * in1[110]) + -in3[26] * in1
                 [111]) + -in3[34] * in1[112]) + -in3[42] * in1[113]) + -in3[50]
              * in1[114]) + -in3[58] * in1[115]) + -in4[2] * in1[116];
  ceq[33] = -in2[3] + in1[3];
  ceq[34] = (((((((((in1[15] + -in4[11] * in1[9]) + -in3[3] * in1[0]) + -in3[11]
                   * in1[1]) + -in3[19] * in1[2]) + -in3[27] * in1[3]) + -in3[35]
                * in1[4]) + -in3[43] * in1[5]) + -in3[51] * in1[6]) + -in3[59] *
             in1[7]) + -in4[3] * in1[8];
  ceq[35] = (((((((((in1[27] + -in4[11] * in1[21]) + -in3[3] * in1[12]) + -in3
                   [11] * in1[13]) + -in3[19] * in1[14]) + -in3[27] * in1[15]) +
                -in3[35] * in1[16]) + -in3[43] * in1[17]) + -in3[51] * in1[18])
             + -in3[59] * in1[19]) + -in4[3] * in1[20];
  ceq[36] = (((((((((in1[39] + -in4[11] * in1[33]) + -in3[3] * in1[24]) + -in3
                   [11] * in1[25]) + -in3[19] * in1[26]) + -in3[27] * in1[27]) +
                -in3[35] * in1[28]) + -in3[43] * in1[29]) + -in3[51] * in1[30])
             + -in3[59] * in1[31]) + -in4[3] * in1[32];
  ceq[37] = (((((((((in1[51] + -in4[11] * in1[45]) + -in3[3] * in1[36]) + -in3
                   [11] * in1[37]) + -in3[19] * in1[38]) + -in3[27] * in1[39]) +
                -in3[35] * in1[40]) + -in3[43] * in1[41]) + -in3[51] * in1[42])
             + -in3[59] * in1[43]) + -in4[3] * in1[44];
  ceq[38] = (((((((((in1[63] + -in4[11] * in1[57]) + -in3[3] * in1[48]) + -in3
                   [11] * in1[49]) + -in3[19] * in1[50]) + -in3[27] * in1[51]) +
                -in3[35] * in1[52]) + -in3[43] * in1[53]) + -in3[51] * in1[54])
             + -in3[59] * in1[55]) + -in4[3] * in1[56];
  ceq[39] = (((((((((in1[75] + -in4[11] * in1[69]) + -in3[3] * in1[60]) + -in3
                   [11] * in1[61]) + -in3[19] * in1[62]) + -in3[27] * in1[63]) +
                -in3[35] * in1[64]) + -in3[43] * in1[65]) + -in3[51] * in1[66])
             + -in3[59] * in1[67]) + -in4[3] * in1[68];
  ceq[40] = (((((((((in1[87] + -in4[11] * in1[81]) + -in3[3] * in1[72]) + -in3
                   [11] * in1[73]) + -in3[19] * in1[74]) + -in3[27] * in1[75]) +
                -in3[35] * in1[76]) + -in3[43] * in1[77]) + -in3[51] * in1[78])
             + -in3[59] * in1[79]) + -in4[3] * in1[80];
  ceq[41] = (((((((((in1[99] + -in4[11] * in1[93]) + -in3[3] * in1[84]) + -in3
                   [11] * in1[85]) + -in3[19] * in1[86]) + -in3[27] * in1[87]) +
                -in3[35] * in1[88]) + -in3[43] * in1[89]) + -in3[51] * in1[90])
             + -in3[59] * in1[91]) + -in4[3] * in1[92];
  ceq[42] = (((((((((in1[111] + -in4[11] * in1[105]) + -in3[3] * in1[96]) +
                   -in3[11] * in1[97]) + -in3[19] * in1[98]) + -in3[27] * in1[99])
                + -in3[35] * in1[100]) + -in3[43] * in1[101]) + -in3[51] * in1
              [102]) + -in3[59] * in1[103]) + -in4[3] * in1[104];
  ceq[43] = (((((((((in1[123] + -in4[11] * in1[117]) + -in3[3] * in1[108]) +
                   -in3[11] * in1[109]) + -in3[19] * in1[110]) + -in3[27] * in1
                 [111]) + -in3[35] * in1[112]) + -in3[43] * in1[113]) + -in3[51]
              * in1[114]) + -in3[59] * in1[115]) + -in4[3] * in1[116];
  ceq[44] = -in2[4] + in1[4];
  ceq[45] = (((((((((in1[16] + -in4[12] * in1[9]) + -in3[4] * in1[0]) + -in3[12]
                   * in1[1]) + -in3[20] * in1[2]) + -in3[28] * in1[3]) + -in3[36]
                * in1[4]) + -in3[44] * in1[5]) + -in3[52] * in1[6]) + -in3[60] *
             in1[7]) + -in4[4] * in1[8];
  ceq[46] = (((((((((in1[28] + -in4[12] * in1[21]) + -in3[4] * in1[12]) + -in3
                   [12] * in1[13]) + -in3[20] * in1[14]) + -in3[28] * in1[15]) +
                -in3[36] * in1[16]) + -in3[44] * in1[17]) + -in3[52] * in1[18])
             + -in3[60] * in1[19]) + -in4[4] * in1[20];
  ceq[47] = (((((((((in1[40] + -in4[12] * in1[33]) + -in3[4] * in1[24]) + -in3
                   [12] * in1[25]) + -in3[20] * in1[26]) + -in3[28] * in1[27]) +
                -in3[36] * in1[28]) + -in3[44] * in1[29]) + -in3[52] * in1[30])
             + -in3[60] * in1[31]) + -in4[4] * in1[32];
  ceq[48] = (((((((((in1[52] + -in4[12] * in1[45]) + -in3[4] * in1[36]) + -in3
                   [12] * in1[37]) + -in3[20] * in1[38]) + -in3[28] * in1[39]) +
                -in3[36] * in1[40]) + -in3[44] * in1[41]) + -in3[52] * in1[42])
             + -in3[60] * in1[43]) + -in4[4] * in1[44];
  ceq[49] = (((((((((in1[64] + -in4[12] * in1[57]) + -in3[4] * in1[48]) + -in3
                   [12] * in1[49]) + -in3[20] * in1[50]) + -in3[28] * in1[51]) +
                -in3[36] * in1[52]) + -in3[44] * in1[53]) + -in3[52] * in1[54])
             + -in3[60] * in1[55]) + -in4[4] * in1[56];
  ceq[50] = (((((((((in1[76] + -in4[12] * in1[69]) + -in3[4] * in1[60]) + -in3
                   [12] * in1[61]) + -in3[20] * in1[62]) + -in3[28] * in1[63]) +
                -in3[36] * in1[64]) + -in3[44] * in1[65]) + -in3[52] * in1[66])
             + -in3[60] * in1[67]) + -in4[4] * in1[68];
  ceq[51] = (((((((((in1[88] + -in4[12] * in1[81]) + -in3[4] * in1[72]) + -in3
                   [12] * in1[73]) + -in3[20] * in1[74]) + -in3[28] * in1[75]) +
                -in3[36] * in1[76]) + -in3[44] * in1[77]) + -in3[52] * in1[78])
             + -in3[60] * in1[79]) + -in4[4] * in1[80];
  ceq[52] = (((((((((in1[100] + -in4[12] * in1[93]) + -in3[4] * in1[84]) + -in3
                   [12] * in1[85]) + -in3[20] * in1[86]) + -in3[28] * in1[87]) +
                -in3[36] * in1[88]) + -in3[44] * in1[89]) + -in3[52] * in1[90])
             + -in3[60] * in1[91]) + -in4[4] * in1[92];
  ceq[53] = (((((((((in1[112] + -in4[12] * in1[105]) + -in3[4] * in1[96]) +
                   -in3[12] * in1[97]) + -in3[20] * in1[98]) + -in3[28] * in1[99])
                + -in3[36] * in1[100]) + -in3[44] * in1[101]) + -in3[52] * in1
              [102]) + -in3[60] * in1[103]) + -in4[4] * in1[104];
  ceq[54] = (((((((((in1[124] + -in4[12] * in1[117]) + -in3[4] * in1[108]) +
                   -in3[12] * in1[109]) + -in3[20] * in1[110]) + -in3[28] * in1
                 [111]) + -in3[36] * in1[112]) + -in3[44] * in1[113]) + -in3[52]
              * in1[114]) + -in3[60] * in1[115]) + -in4[4] * in1[116];
  ceq[55] = -in2[5] + in1[5];
  ceq[56] = (((((((((in1[17] + -in4[13] * in1[9]) + -in3[5] * in1[0]) + -in3[13]
                   * in1[1]) + -in3[21] * in1[2]) + -in3[29] * in1[3]) + -in3[37]
                * in1[4]) + -in3[45] * in1[5]) + -in3[53] * in1[6]) + -in3[61] *
             in1[7]) + -in4[5] * in1[8];
  ceq[57] = (((((((((in1[29] + -in4[13] * in1[21]) + -in3[5] * in1[12]) + -in3
                   [13] * in1[13]) + -in3[21] * in1[14]) + -in3[29] * in1[15]) +
                -in3[37] * in1[16]) + -in3[45] * in1[17]) + -in3[53] * in1[18])
             + -in3[61] * in1[19]) + -in4[5] * in1[20];
  ceq[58] = (((((((((in1[41] + -in4[13] * in1[33]) + -in3[5] * in1[24]) + -in3
                   [13] * in1[25]) + -in3[21] * in1[26]) + -in3[29] * in1[27]) +
                -in3[37] * in1[28]) + -in3[45] * in1[29]) + -in3[53] * in1[30])
             + -in3[61] * in1[31]) + -in4[5] * in1[32];
  ceq[59] = (((((((((in1[53] + -in4[13] * in1[45]) + -in3[5] * in1[36]) + -in3
                   [13] * in1[37]) + -in3[21] * in1[38]) + -in3[29] * in1[39]) +
                -in3[37] * in1[40]) + -in3[45] * in1[41]) + -in3[53] * in1[42])
             + -in3[61] * in1[43]) + -in4[5] * in1[44];
  ceq[60] = (((((((((in1[65] + -in4[13] * in1[57]) + -in3[5] * in1[48]) + -in3
                   [13] * in1[49]) + -in3[21] * in1[50]) + -in3[29] * in1[51]) +
                -in3[37] * in1[52]) + -in3[45] * in1[53]) + -in3[53] * in1[54])
             + -in3[61] * in1[55]) + -in4[5] * in1[56];
  ceq[61] = (((((((((in1[77] + -in4[13] * in1[69]) + -in3[5] * in1[60]) + -in3
                   [13] * in1[61]) + -in3[21] * in1[62]) + -in3[29] * in1[63]) +
                -in3[37] * in1[64]) + -in3[45] * in1[65]) + -in3[53] * in1[66])
             + -in3[61] * in1[67]) + -in4[5] * in1[68];
  ceq[62] = (((((((((in1[89] + -in4[13] * in1[81]) + -in3[5] * in1[72]) + -in3
                   [13] * in1[73]) + -in3[21] * in1[74]) + -in3[29] * in1[75]) +
                -in3[37] * in1[76]) + -in3[45] * in1[77]) + -in3[53] * in1[78])
             + -in3[61] * in1[79]) + -in4[5] * in1[80];
  ceq[63] = (((((((((in1[101] + -in4[13] * in1[93]) + -in3[5] * in1[84]) + -in3
                   [13] * in1[85]) + -in3[21] * in1[86]) + -in3[29] * in1[87]) +
                -in3[37] * in1[88]) + -in3[45] * in1[89]) + -in3[53] * in1[90])
             + -in3[61] * in1[91]) + -in4[5] * in1[92];
  ceq[64] = (((((((((in1[113] + -in4[13] * in1[105]) + -in3[5] * in1[96]) +
                   -in3[13] * in1[97]) + -in3[21] * in1[98]) + -in3[29] * in1[99])
                + -in3[37] * in1[100]) + -in3[45] * in1[101]) + -in3[53] * in1
              [102]) + -in3[61] * in1[103]) + -in4[5] * in1[104];
  ceq[65] = (((((((((in1[125] + -in4[13] * in1[117]) + -in3[5] * in1[108]) +
                   -in3[13] * in1[109]) + -in3[21] * in1[110]) + -in3[29] * in1
                 [111]) + -in3[37] * in1[112]) + -in3[45] * in1[113]) + -in3[53]
              * in1[114]) + -in3[61] * in1[115]) + -in4[5] * in1[116];
  ceq[66] = -in2[6] + in1[6];
  ceq[67] = (((((((((in1[18] + -in4[14] * in1[9]) + -in3[6] * in1[0]) + -in3[14]
                   * in1[1]) + -in3[22] * in1[2]) + -in3[30] * in1[3]) + -in3[38]
                * in1[4]) + -in3[46] * in1[5]) + -in3[54] * in1[6]) + -in3[62] *
             in1[7]) + -in4[6] * in1[8];
  ceq[68] = (((((((((in1[30] + -in4[14] * in1[21]) + -in3[6] * in1[12]) + -in3
                   [14] * in1[13]) + -in3[22] * in1[14]) + -in3[30] * in1[15]) +
                -in3[38] * in1[16]) + -in3[46] * in1[17]) + -in3[54] * in1[18])
             + -in3[62] * in1[19]) + -in4[6] * in1[20];
  ceq[69] = (((((((((in1[42] + -in4[14] * in1[33]) + -in3[6] * in1[24]) + -in3
                   [14] * in1[25]) + -in3[22] * in1[26]) + -in3[30] * in1[27]) +
                -in3[38] * in1[28]) + -in3[46] * in1[29]) + -in3[54] * in1[30])
             + -in3[62] * in1[31]) + -in4[6] * in1[32];
  ceq[70] = (((((((((in1[54] + -in4[14] * in1[45]) + -in3[6] * in1[36]) + -in3
                   [14] * in1[37]) + -in3[22] * in1[38]) + -in3[30] * in1[39]) +
                -in3[38] * in1[40]) + -in3[46] * in1[41]) + -in3[54] * in1[42])
             + -in3[62] * in1[43]) + -in4[6] * in1[44];
  ceq[71] = (((((((((in1[66] + -in4[14] * in1[57]) + -in3[6] * in1[48]) + -in3
                   [14] * in1[49]) + -in3[22] * in1[50]) + -in3[30] * in1[51]) +
                -in3[38] * in1[52]) + -in3[46] * in1[53]) + -in3[54] * in1[54])
             + -in3[62] * in1[55]) + -in4[6] * in1[56];
  ceq[72] = (((((((((in1[78] + -in4[14] * in1[69]) + -in3[6] * in1[60]) + -in3
                   [14] * in1[61]) + -in3[22] * in1[62]) + -in3[30] * in1[63]) +
                -in3[38] * in1[64]) + -in3[46] * in1[65]) + -in3[54] * in1[66])
             + -in3[62] * in1[67]) + -in4[6] * in1[68];
  ceq[73] = (((((((((in1[90] + -in4[14] * in1[81]) + -in3[6] * in1[72]) + -in3
                   [14] * in1[73]) + -in3[22] * in1[74]) + -in3[30] * in1[75]) +
                -in3[38] * in1[76]) + -in3[46] * in1[77]) + -in3[54] * in1[78])
             + -in3[62] * in1[79]) + -in4[6] * in1[80];
  ceq[74] = (((((((((in1[102] + -in4[14] * in1[93]) + -in3[6] * in1[84]) + -in3
                   [14] * in1[85]) + -in3[22] * in1[86]) + -in3[30] * in1[87]) +
                -in3[38] * in1[88]) + -in3[46] * in1[89]) + -in3[54] * in1[90])
             + -in3[62] * in1[91]) + -in4[6] * in1[92];
  ceq[75] = (((((((((in1[114] + -in4[14] * in1[105]) + -in3[6] * in1[96]) +
                   -in3[14] * in1[97]) + -in3[22] * in1[98]) + -in3[30] * in1[99])
                + -in3[38] * in1[100]) + -in3[46] * in1[101]) + -in3[54] * in1
              [102]) + -in3[62] * in1[103]) + -in4[6] * in1[104];
  ceq[76] = (((((((((in1[126] + -in4[14] * in1[117]) + -in3[6] * in1[108]) +
                   -in3[14] * in1[109]) + -in3[22] * in1[110]) + -in3[30] * in1
                 [111]) + -in3[38] * in1[112]) + -in3[46] * in1[113]) + -in3[54]
              * in1[114]) + -in3[62] * in1[115]) + -in4[6] * in1[116];
  ceq[77] = -in2[7] + in1[7];
  ceq[78] = (((((((((in1[19] + -in4[15] * in1[9]) + -in3[7] * in1[0]) + -in3[15]
                   * in1[1]) + -in3[23] * in1[2]) + -in3[31] * in1[3]) + -in3[39]
                * in1[4]) + -in3[47] * in1[5]) + -in3[55] * in1[6]) + -in3[63] *
             in1[7]) + -in4[7] * in1[8];
  ceq[79] = (((((((((in1[31] + -in4[15] * in1[21]) + -in3[7] * in1[12]) + -in3
                   [15] * in1[13]) + -in3[23] * in1[14]) + -in3[31] * in1[15]) +
                -in3[39] * in1[16]) + -in3[47] * in1[17]) + -in3[55] * in1[18])
             + -in3[63] * in1[19]) + -in4[7] * in1[20];
  ceq[80] = (((((((((in1[43] + -in4[15] * in1[33]) + -in3[7] * in1[24]) + -in3
                   [15] * in1[25]) + -in3[23] * in1[26]) + -in3[31] * in1[27]) +
                -in3[39] * in1[28]) + -in3[47] * in1[29]) + -in3[55] * in1[30])
             + -in3[63] * in1[31]) + -in4[7] * in1[32];
  ceq[81] = (((((((((in1[55] + -in4[15] * in1[45]) + -in3[7] * in1[36]) + -in3
                   [15] * in1[37]) + -in3[23] * in1[38]) + -in3[31] * in1[39]) +
                -in3[39] * in1[40]) + -in3[47] * in1[41]) + -in3[55] * in1[42])
             + -in3[63] * in1[43]) + -in4[7] * in1[44];
  ceq[82] = (((((((((in1[67] + -in4[15] * in1[57]) + -in3[7] * in1[48]) + -in3
                   [15] * in1[49]) + -in3[23] * in1[50]) + -in3[31] * in1[51]) +
                -in3[39] * in1[52]) + -in3[47] * in1[53]) + -in3[55] * in1[54])
             + -in3[63] * in1[55]) + -in4[7] * in1[56];
  ceq[83] = (((((((((in1[79] + -in4[15] * in1[69]) + -in3[7] * in1[60]) + -in3
                   [15] * in1[61]) + -in3[23] * in1[62]) + -in3[31] * in1[63]) +
                -in3[39] * in1[64]) + -in3[47] * in1[65]) + -in3[55] * in1[66])
             + -in3[63] * in1[67]) + -in4[7] * in1[68];
  ceq[84] = (((((((((in1[91] + -in4[15] * in1[81]) + -in3[7] * in1[72]) + -in3
                   [15] * in1[73]) + -in3[23] * in1[74]) + -in3[31] * in1[75]) +
                -in3[39] * in1[76]) + -in3[47] * in1[77]) + -in3[55] * in1[78])
             + -in3[63] * in1[79]) + -in4[7] * in1[80];
  ceq[85] = (((((((((in1[103] + -in4[15] * in1[93]) + -in3[7] * in1[84]) + -in3
                   [15] * in1[85]) + -in3[23] * in1[86]) + -in3[31] * in1[87]) +
                -in3[39] * in1[88]) + -in3[47] * in1[89]) + -in3[55] * in1[90])
             + -in3[63] * in1[91]) + -in4[7] * in1[92];
  ceq[86] = (((((((((in1[115] + -in4[15] * in1[105]) + -in3[7] * in1[96]) +
                   -in3[15] * in1[97]) + -in3[23] * in1[98]) + -in3[31] * in1[99])
                + -in3[39] * in1[100]) + -in3[47] * in1[101]) + -in3[55] * in1
              [102]) + -in3[63] * in1[103]) + -in4[7] * in1[104];
  ceq[87] = (((((((((in1[127] + -in4[15] * in1[117]) + -in3[7] * in1[108]) +
                   -in3[15] * in1[109]) + -in3[23] * in1[110]) + -in3[31] * in1
                 [111]) + -in3[39] * in1[112]) + -in3[47] * in1[113]) + -in3[55]
              * in1[114]) + -in3[63] * in1[115]) + -in4[7] * in1[116];
  t378 = (in9[1] + -in7[2]) * t506 * t546 + t264 * t507 * t536;
  t258 = (in9[2] + -in7[4]) * t508 * t547 + t383 * t509 * t537;
  t499 = (in9[3] + -in7[6]) * t510 * t548 + t382 * t511 * t538;
  t377 = (in9[4] + -in7[8]) * t512 * t549 + t262 * t513 * t539;
  t257 = (in9[5] + -in7[10]) * t514 * t550 + t381 * t515 * t540;
  t498 = (in9[6] + -in7[12]) * t516 * t551 + t261 * t517 * t541;
  t376 = (in9[7] + -in7[14]) * t518 * t552 + t380 * t519 * t542;
  t256 = (in9[8] + -in7[16]) * t520 * t553 + t260 * t521 * t543;
  t497 = (in9[9] + -in7[18]) * t522 * t554 + t379 * t523 * t544;
  t496 = (in9[10] + -in7[20]) * t524 * t555 + t259 * t525 * t545;
  t535 = -((in9[12] + -in7[3]) * t506 * t546) + t395 * t507 * t536;
  t534 = -((in9[13] + -in7[5]) * t508 * t547) + t275 * t509 * t537;
  t533 = -((in9[14] + -in7[7]) * t510 * t548) + t274 * t511 * t538;
  t532 = -((in9[15] + -in7[9]) * t512 * t549) + t393 * t513 * t539;
  t531 = -((in9[16] + -in7[11]) * t514 * t550) + t392 * t515 * t540;
  t530 = -((in9[17] + -in7[13]) * t516 * t551) + t272 * t517 * t541;
  t529 = -((in9[18] + -in7[15]) * t518 * t552) + t271 * t519 * t542;
  t528 = -((in9[19] + -in7[17]) * t520 * t553) + t390 * t521 * t543;
  t527 = -((in9[20] + -in7[19]) * t522 * t554) + t385 * t523 * t544;
  t526 = -((in9[21] + -in7[21]) * t524 * t555) + t265 * t525 * t545;
  memset(&dcineq[0], 0, 10U * sizeof(real_T));
  dcineq[10] = -1.0;
  memset(&dcineq[11], 0, 143U * sizeof(real_T));
  dcineq[154] = -1.0;
  memset(&dcineq[155], 0, 143U * sizeof(real_T));
  dcineq[298] = -1.0;
  memset(&dcineq[299], 0, 143U * sizeof(real_T));
  dcineq[442] = -1.0;
  memset(&dcineq[443], 0, 143U * sizeof(real_T));
  dcineq[586] = -1.0;
  memset(&dcineq[587], 0, 143U * sizeof(real_T));
  dcineq[730] = -1.0;
  memset(&dcineq[731], 0, 143U * sizeof(real_T));
  dcineq[874] = -1.0;
  memset(&dcineq[875], 0, 143U * sizeof(real_T));
  dcineq[1018] = -1.0;
  memset(&dcineq[1019], 0, 143U * sizeof(real_T));
  dcineq[1162] = -1.0;
  memset(&dcineq[1163], 0, 143U * sizeof(real_T));
  dcineq[1306] = -1.0;
  memset(&dcineq[1307], 0, 143U * sizeof(real_T));
  dcineq[1450] = -1.0;
  memset(&dcineq[1451], 0, 12U * sizeof(real_T));
  dcineq[1463] = -1.0;
  memset(&dcineq[1464], 0, 143U * sizeof(real_T));
  dcineq[1607] = -1.0;
  memset(&dcineq[1608], 0, 143U * sizeof(real_T));
  dcineq[1751] = -1.0;
  memset(&dcineq[1752], 0, 143U * sizeof(real_T));
  dcineq[1895] = -1.0;
  memset(&dcineq[1896], 0, 143U * sizeof(real_T));
  dcineq[2039] = -1.0;
  memset(&dcineq[2040], 0, 143U * sizeof(real_T));
  dcineq[2183] = -1.0;
  memset(&dcineq[2184], 0, 143U * sizeof(real_T));
  dcineq[2327] = -1.0;
  memset(&dcineq[2328], 0, 143U * sizeof(real_T));
  dcineq[2471] = -1.0;
  memset(&dcineq[2472], 0, 143U * sizeof(real_T));
  dcineq[2615] = -1.0;
  memset(&dcineq[2616], 0, 143U * sizeof(real_T));
  dcineq[2759] = -1.0;
  memset(&dcineq[2760], 0, 143U * sizeof(real_T));
  dcineq[2903] = -1.0;
  memset(&dcineq[2904], 0, 2916U * sizeof(real_T));
  dcineq[5820] = -t576;
  dcineq[5821] = 0.0;
  dcineq[5822] = 0.0;
  dcineq[5823] = 0.0;
  dcineq[5824] = -t391;
  memset(&dcineq[5825], 0, 139U * sizeof(real_T));
  dcineq[5964] = -t577;
  dcineq[5965] = 0.0;
  dcineq[5966] = 0.0;
  dcineq[5967] = 0.0;
  dcineq[5968] = -t270;
  memset(&dcineq[5969], 0, 139U * sizeof(real_T));
  dcineq[6108] = -t397;
  dcineq[6109] = 0.0;
  dcineq[6110] = 0.0;
  dcineq[6111] = 0.0;
  dcineq[6112] = -t389;
  memset(&dcineq[6113], 0, 139U * sizeof(real_T));
  dcineq[6252] = -t277;
  dcineq[6253] = 0.0;
  dcineq[6254] = 0.0;
  dcineq[6255] = 0.0;
  dcineq[6256] = -t269;
  memset(&dcineq[6257], 0, 139U * sizeof(real_T));
  dcineq[6396] = -t396;
  dcineq[6397] = 0.0;
  dcineq[6398] = 0.0;
  dcineq[6399] = 0.0;
  dcineq[6400] = -t388;
  memset(&dcineq[6401], 0, 139U * sizeof(real_T));
  dcineq[6540] = -t276;
  dcineq[6541] = 0.0;
  dcineq[6542] = 0.0;
  dcineq[6543] = 0.0;
  dcineq[6544] = -t268;
  memset(&dcineq[6545], 0, 139U * sizeof(real_T));
  dcineq[6684] = -t394;
  dcineq[6685] = 0.0;
  dcineq[6686] = 0.0;
  dcineq[6687] = 0.0;
  dcineq[6688] = -t387;
  memset(&dcineq[6689], 0, 139U * sizeof(real_T));
  dcineq[6828] = -t273;
  dcineq[6829] = 0.0;
  dcineq[6830] = 0.0;
  dcineq[6831] = 0.0;
  dcineq[6832] = -t267;
  memset(&dcineq[6833], 0, 139U * sizeof(real_T));
  dcineq[6972] = -t386;
  dcineq[6973] = 0.0;
  dcineq[6974] = 0.0;
  dcineq[6975] = 0.0;
  dcineq[6976] = -t384;
  memset(&dcineq[6977], 0, 139U * sizeof(real_T));
  dcineq[7116] = -t266;
  dcineq[7117] = 0.0;
  dcineq[7118] = 0.0;
  dcineq[7119] = 0.0;
  dcineq[7120] = -t263;
  memset(&dcineq[7121], 0, 151U * sizeof(real_T));
  dcineq[7272] = t576;
  dcineq[7273] = 0.0;
  dcineq[7274] = 0.0;
  dcineq[7275] = 0.0;
  dcineq[7276] = t391;
  memset(&dcineq[7277], 0, 139U * sizeof(real_T));
  dcineq[7416] = t577;
  dcineq[7417] = 0.0;
  dcineq[7418] = 0.0;
  dcineq[7419] = 0.0;
  dcineq[7420] = t270;
  memset(&dcineq[7421], 0, 139U * sizeof(real_T));
  dcineq[7560] = t397;
  dcineq[7561] = 0.0;
  dcineq[7562] = 0.0;
  dcineq[7563] = 0.0;
  dcineq[7564] = t389;
  memset(&dcineq[7565], 0, 139U * sizeof(real_T));
  dcineq[7704] = t277;
  dcineq[7705] = 0.0;
  dcineq[7706] = 0.0;
  dcineq[7707] = 0.0;
  dcineq[7708] = t269;
  memset(&dcineq[7709], 0, 139U * sizeof(real_T));
  dcineq[7848] = t396;
  dcineq[7849] = 0.0;
  dcineq[7850] = 0.0;
  dcineq[7851] = 0.0;
  dcineq[7852] = t388;
  memset(&dcineq[7853], 0, 139U * sizeof(real_T));
  dcineq[7992] = t276;
  dcineq[7993] = 0.0;
  dcineq[7994] = 0.0;
  dcineq[7995] = 0.0;
  dcineq[7996] = t268;
  memset(&dcineq[7997], 0, 139U * sizeof(real_T));
  dcineq[8136] = t394;
  dcineq[8137] = 0.0;
  dcineq[8138] = 0.0;
  dcineq[8139] = 0.0;
  dcineq[8140] = t387;
  memset(&dcineq[8141], 0, 139U * sizeof(real_T));
  dcineq[8280] = t273;
  dcineq[8281] = 0.0;
  dcineq[8282] = 0.0;
  dcineq[8283] = 0.0;
  dcineq[8284] = t267;
  memset(&dcineq[8285], 0, 139U * sizeof(real_T));
  dcineq[8424] = t386;
  dcineq[8425] = 0.0;
  dcineq[8426] = 0.0;
  dcineq[8427] = 0.0;
  dcineq[8428] = t384;
  memset(&dcineq[8429], 0, 139U * sizeof(real_T));
  dcineq[8568] = t266;
  dcineq[8569] = 0.0;
  dcineq[8570] = 0.0;
  dcineq[8571] = 0.0;
  dcineq[8572] = t263;
  memset(&dcineq[8573], 0, 151U * sizeof(real_T));
  dcineq[8724] = -t556;
  dcineq[8725] = 0.0;
  dcineq[8726] = 0.0;
  dcineq[8727] = 0.0;
  dcineq[8728] = -t564;
  memset(&dcineq[8729], 0, 139U * sizeof(real_T));
  dcineq[8868] = -t557;
  dcineq[8869] = 0.0;
  dcineq[8870] = 0.0;
  dcineq[8871] = 0.0;
  dcineq[8872] = -t565;
  memset(&dcineq[8873], 0, 139U * sizeof(real_T));
  dcineq[9012] = -t558;
  dcineq[9013] = 0.0;
  dcineq[9014] = 0.0;
  dcineq[9015] = 0.0;
  dcineq[9016] = -t566;
  memset(&dcineq[9017], 0, 139U * sizeof(real_T));
  dcineq[9156] = -t559;
  dcineq[9157] = 0.0;
  dcineq[9158] = 0.0;
  dcineq[9159] = 0.0;
  dcineq[9160] = -t567;
  memset(&dcineq[9161], 0, 139U * sizeof(real_T));
  dcineq[9300] = -t560;
  dcineq[9301] = 0.0;
  dcineq[9302] = 0.0;
  dcineq[9303] = 0.0;
  dcineq[9304] = -t568;
  memset(&dcineq[9305], 0, 139U * sizeof(real_T));
  dcineq[9444] = -t561;
  dcineq[9445] = 0.0;
  dcineq[9446] = 0.0;
  dcineq[9447] = 0.0;
  dcineq[9448] = -t569;
  memset(&dcineq[9449], 0, 139U * sizeof(real_T));
  dcineq[9588] = -t562;
  dcineq[9589] = 0.0;
  dcineq[9590] = 0.0;
  dcineq[9591] = 0.0;
  dcineq[9592] = -t570;
  memset(&dcineq[9593], 0, 139U * sizeof(real_T));
  dcineq[9732] = -t563;
  dcineq[9733] = 0.0;
  dcineq[9734] = 0.0;
  dcineq[9735] = 0.0;
  dcineq[9736] = -t571;
  memset(&dcineq[9737], 0, 139U * sizeof(real_T));
  dcineq[9876] = -t572;
  dcineq[9877] = 0.0;
  dcineq[9878] = 0.0;
  dcineq[9879] = 0.0;
  dcineq[9880] = -t574;
  memset(&dcineq[9881], 0, 139U * sizeof(real_T));
  dcineq[10020] = -t573;
  dcineq[10021] = 0.0;
  dcineq[10022] = 0.0;
  dcineq[10023] = 0.0;
  dcineq[10024] = -t575;
  memset(&dcineq[10025], 0, 151U * sizeof(real_T));
  dcineq[10176] = t556;
  dcineq[10177] = 0.0;
  dcineq[10178] = 0.0;
  dcineq[10179] = 0.0;
  dcineq[10180] = t564;
  memset(&dcineq[10181], 0, 139U * sizeof(real_T));
  dcineq[10320] = t557;
  dcineq[10321] = 0.0;
  dcineq[10322] = 0.0;
  dcineq[10323] = 0.0;
  dcineq[10324] = t565;
  memset(&dcineq[10325], 0, 139U * sizeof(real_T));
  dcineq[10464] = t558;
  dcineq[10465] = 0.0;
  dcineq[10466] = 0.0;
  dcineq[10467] = 0.0;
  dcineq[10468] = t566;
  memset(&dcineq[10469], 0, 139U * sizeof(real_T));
  dcineq[10608] = t559;
  dcineq[10609] = 0.0;
  dcineq[10610] = 0.0;
  dcineq[10611] = 0.0;
  dcineq[10612] = t567;
  memset(&dcineq[10613], 0, 139U * sizeof(real_T));
  dcineq[10752] = t560;
  dcineq[10753] = 0.0;
  dcineq[10754] = 0.0;
  dcineq[10755] = 0.0;
  dcineq[10756] = t568;
  memset(&dcineq[10757], 0, 139U * sizeof(real_T));
  dcineq[10896] = t561;
  dcineq[10897] = 0.0;
  dcineq[10898] = 0.0;
  dcineq[10899] = 0.0;
  dcineq[10900] = t569;
  memset(&dcineq[10901], 0, 139U * sizeof(real_T));
  dcineq[11040] = t562;
  dcineq[11041] = 0.0;
  dcineq[11042] = 0.0;
  dcineq[11043] = 0.0;
  dcineq[11044] = t570;
  memset(&dcineq[11045], 0, 139U * sizeof(real_T));
  dcineq[11184] = t563;
  dcineq[11185] = 0.0;
  dcineq[11186] = 0.0;
  dcineq[11187] = 0.0;
  dcineq[11188] = t571;
  memset(&dcineq[11189], 0, 139U * sizeof(real_T));
  dcineq[11328] = t572;
  dcineq[11329] = 0.0;
  dcineq[11330] = 0.0;
  dcineq[11331] = 0.0;
  dcineq[11332] = t574;
  memset(&dcineq[11333], 0, 139U * sizeof(real_T));
  dcineq[11472] = t573;
  dcineq[11473] = 0.0;
  dcineq[11474] = 0.0;
  dcineq[11475] = 0.0;
  dcineq[11476] = t575;
  memset(&dcineq[11477], 0, 139U * sizeof(real_T));
  dcineq[11616] = t356;
  memset(&dcineq[11617], 0, 11U * sizeof(real_T));
  dcineq[11628] = -t356;
  memset(&dcineq[11629], 0, 9U * sizeof(real_T));
  dcineq[11638] = -1.0;
  memset(&dcineq[11639], 0, 121U * sizeof(real_T));
  dcineq[11760] = t357;
  memset(&dcineq[11761], 0, 11U * sizeof(real_T));
  dcineq[11772] = -t357;
  memset(&dcineq[11773], 0, 9U * sizeof(real_T));
  dcineq[11782] = -1.0;
  memset(&dcineq[11783], 0, 121U * sizeof(real_T));
  dcineq[11904] = t358;
  memset(&dcineq[11905], 0, 11U * sizeof(real_T));
  dcineq[11916] = -t358;
  memset(&dcineq[11917], 0, 9U * sizeof(real_T));
  dcineq[11926] = -1.0;
  memset(&dcineq[11927], 0, 121U * sizeof(real_T));
  dcineq[12048] = t359;
  memset(&dcineq[12049], 0, 11U * sizeof(real_T));
  dcineq[12060] = -t359;
  memset(&dcineq[12061], 0, 9U * sizeof(real_T));
  dcineq[12070] = -1.0;
  memset(&dcineq[12071], 0, 121U * sizeof(real_T));
  dcineq[12192] = t360;
  memset(&dcineq[12193], 0, 11U * sizeof(real_T));
  dcineq[12204] = -t360;
  memset(&dcineq[12205], 0, 9U * sizeof(real_T));
  dcineq[12214] = -1.0;
  memset(&dcineq[12215], 0, 121U * sizeof(real_T));
  dcineq[12336] = t361;
  memset(&dcineq[12337], 0, 11U * sizeof(real_T));
  dcineq[12348] = -t361;
  memset(&dcineq[12349], 0, 9U * sizeof(real_T));
  dcineq[12358] = -1.0;
  memset(&dcineq[12359], 0, 121U * sizeof(real_T));
  dcineq[12480] = t362;
  memset(&dcineq[12481], 0, 11U * sizeof(real_T));
  dcineq[12492] = -t362;
  memset(&dcineq[12493], 0, 9U * sizeof(real_T));
  dcineq[12502] = -1.0;
  memset(&dcineq[12503], 0, 121U * sizeof(real_T));
  dcineq[12624] = t363;
  memset(&dcineq[12625], 0, 11U * sizeof(real_T));
  dcineq[12636] = -t363;
  memset(&dcineq[12637], 0, 9U * sizeof(real_T));
  dcineq[12646] = -1.0;
  memset(&dcineq[12647], 0, 121U * sizeof(real_T));
  dcineq[12768] = t372;
  memset(&dcineq[12769], 0, 11U * sizeof(real_T));
  dcineq[12780] = -t372;
  memset(&dcineq[12781], 0, 9U * sizeof(real_T));
  dcineq[12790] = -1.0;
  memset(&dcineq[12791], 0, 121U * sizeof(real_T));
  dcineq[12912] = t373;
  memset(&dcineq[12913], 0, 11U * sizeof(real_T));
  dcineq[12924] = -t373;
  memset(&dcineq[12925], 0, 9U * sizeof(real_T));
  dcineq[12934] = -1.0;
  memset(&dcineq[12935], 0, 137U * sizeof(real_T));
  dcineq[13072] = t364;
  memset(&dcineq[13073], 0, 11U * sizeof(real_T));
  dcineq[13084] = -t364;
  dcineq[13085] = 0.0;
  dcineq[13086] = 0.0;
  dcineq[13087] = 0.0;
  dcineq[13088] = 0.0;
  dcineq[13089] = 0.0;
  dcineq[13090] = -1.0;
  memset(&dcineq[13091], 0, 125U * sizeof(real_T));
  dcineq[13216] = t365;
  memset(&dcineq[13217], 0, 11U * sizeof(real_T));
  dcineq[13228] = -t365;
  dcineq[13229] = 0.0;
  dcineq[13230] = 0.0;
  dcineq[13231] = 0.0;
  dcineq[13232] = 0.0;
  dcineq[13233] = 0.0;
  dcineq[13234] = -1.0;
  memset(&dcineq[13235], 0, 125U * sizeof(real_T));
  dcineq[13360] = t366;
  memset(&dcineq[13361], 0, 11U * sizeof(real_T));
  dcineq[13372] = -t366;
  dcineq[13373] = 0.0;
  dcineq[13374] = 0.0;
  dcineq[13375] = 0.0;
  dcineq[13376] = 0.0;
  dcineq[13377] = 0.0;
  dcineq[13378] = -1.0;
  memset(&dcineq[13379], 0, 125U * sizeof(real_T));
  dcineq[13504] = t367;
  memset(&dcineq[13505], 0, 11U * sizeof(real_T));
  dcineq[13516] = -t367;
  dcineq[13517] = 0.0;
  dcineq[13518] = 0.0;
  dcineq[13519] = 0.0;
  dcineq[13520] = 0.0;
  dcineq[13521] = 0.0;
  dcineq[13522] = -1.0;
  memset(&dcineq[13523], 0, 125U * sizeof(real_T));
  dcineq[13648] = t368;
  memset(&dcineq[13649], 0, 11U * sizeof(real_T));
  dcineq[13660] = -t368;
  dcineq[13661] = 0.0;
  dcineq[13662] = 0.0;
  dcineq[13663] = 0.0;
  dcineq[13664] = 0.0;
  dcineq[13665] = 0.0;
  dcineq[13666] = -1.0;
  memset(&dcineq[13667], 0, 125U * sizeof(real_T));
  dcineq[13792] = t369;
  memset(&dcineq[13793], 0, 11U * sizeof(real_T));
  dcineq[13804] = -t369;
  dcineq[13805] = 0.0;
  dcineq[13806] = 0.0;
  dcineq[13807] = 0.0;
  dcineq[13808] = 0.0;
  dcineq[13809] = 0.0;
  dcineq[13810] = -1.0;
  memset(&dcineq[13811], 0, 125U * sizeof(real_T));
  dcineq[13936] = t370;
  memset(&dcineq[13937], 0, 11U * sizeof(real_T));
  dcineq[13948] = -t370;
  dcineq[13949] = 0.0;
  dcineq[13950] = 0.0;
  dcineq[13951] = 0.0;
  dcineq[13952] = 0.0;
  dcineq[13953] = 0.0;
  dcineq[13954] = -1.0;
  memset(&dcineq[13955], 0, 125U * sizeof(real_T));
  dcineq[14080] = t371;
  memset(&dcineq[14081], 0, 11U * sizeof(real_T));
  dcineq[14092] = -t371;
  dcineq[14093] = 0.0;
  dcineq[14094] = 0.0;
  dcineq[14095] = 0.0;
  dcineq[14096] = 0.0;
  dcineq[14097] = 0.0;
  dcineq[14098] = -1.0;
  memset(&dcineq[14099], 0, 125U * sizeof(real_T));
  dcineq[14224] = t374;
  memset(&dcineq[14225], 0, 11U * sizeof(real_T));
  dcineq[14236] = -t374;
  dcineq[14237] = 0.0;
  dcineq[14238] = 0.0;
  dcineq[14239] = 0.0;
  dcineq[14240] = 0.0;
  dcineq[14241] = 0.0;
  dcineq[14242] = -1.0;
  memset(&dcineq[14243], 0, 125U * sizeof(real_T));
  dcineq[14368] = t375;
  memset(&dcineq[14369], 0, 11U * sizeof(real_T));
  dcineq[14380] = -t375;
  dcineq[14381] = 0.0;
  dcineq[14382] = 0.0;
  dcineq[14383] = 0.0;
  dcineq[14384] = 0.0;
  dcineq[14385] = 0.0;
  dcineq[14386] = -1.0;
  memset(&dcineq[14387], 0, 145U * sizeof(real_T));
  dcineq[14532] = t535;
  dcineq[14533] = 0.0;
  dcineq[14534] = 0.0;
  dcineq[14535] = 0.0;
  dcineq[14536] = t378;
  memset(&dcineq[14537], 0, 139U * sizeof(real_T));
  dcineq[14676] = t534;
  dcineq[14677] = 0.0;
  dcineq[14678] = 0.0;
  dcineq[14679] = 0.0;
  dcineq[14680] = t258;
  memset(&dcineq[14681], 0, 139U * sizeof(real_T));
  dcineq[14820] = t533;
  dcineq[14821] = 0.0;
  dcineq[14822] = 0.0;
  dcineq[14823] = 0.0;
  dcineq[14824] = t499;
  memset(&dcineq[14825], 0, 139U * sizeof(real_T));
  dcineq[14964] = t532;
  dcineq[14965] = 0.0;
  dcineq[14966] = 0.0;
  dcineq[14967] = 0.0;
  dcineq[14968] = t377;
  memset(&dcineq[14969], 0, 139U * sizeof(real_T));
  dcineq[15108] = t531;
  dcineq[15109] = 0.0;
  dcineq[15110] = 0.0;
  dcineq[15111] = 0.0;
  dcineq[15112] = t257;
  memset(&dcineq[15113], 0, 139U * sizeof(real_T));
  dcineq[15252] = t530;
  dcineq[15253] = 0.0;
  dcineq[15254] = 0.0;
  dcineq[15255] = 0.0;
  dcineq[15256] = t498;
  memset(&dcineq[15257], 0, 139U * sizeof(real_T));
  dcineq[15396] = t529;
  dcineq[15397] = 0.0;
  dcineq[15398] = 0.0;
  dcineq[15399] = 0.0;
  dcineq[15400] = t376;
  memset(&dcineq[15401], 0, 139U * sizeof(real_T));
  dcineq[15540] = t528;
  dcineq[15541] = 0.0;
  dcineq[15542] = 0.0;
  dcineq[15543] = 0.0;
  dcineq[15544] = t256;
  memset(&dcineq[15545], 0, 139U * sizeof(real_T));
  dcineq[15684] = t527;
  dcineq[15685] = 0.0;
  dcineq[15686] = 0.0;
  dcineq[15687] = 0.0;
  dcineq[15688] = t497;
  memset(&dcineq[15689], 0, 139U * sizeof(real_T));
  dcineq[15828] = t526;
  dcineq[15829] = 0.0;
  dcineq[15830] = 0.0;
  dcineq[15831] = 0.0;
  dcineq[15832] = t496;
  memset(&dcineq[15833], 0, 151U * sizeof(real_T));
  dcineq[15984] = t535;
  dcineq[15985] = 0.0;
  dcineq[15986] = 0.0;
  dcineq[15987] = 0.0;
  dcineq[15988] = t378;
  dcineq[15989] = 0.0;
  dcineq[15990] = 0.0;
  dcineq[15991] = 0.0;
  dcineq[15992] = 0.0;
  dcineq[15993] = 0.0;
  dcineq[15994] = 0.0;
  dcineq[15995] = -1.0;
  memset(&dcineq[15996], 0, 132U * sizeof(real_T));
  dcineq[16128] = t534;
  dcineq[16129] = 0.0;
  dcineq[16130] = 0.0;
  dcineq[16131] = 0.0;
  dcineq[16132] = t258;
  dcineq[16133] = 0.0;
  dcineq[16134] = 0.0;
  dcineq[16135] = 0.0;
  dcineq[16136] = 0.0;
  dcineq[16137] = 0.0;
  dcineq[16138] = 0.0;
  dcineq[16139] = -1.0;
  memset(&dcineq[16140], 0, 132U * sizeof(real_T));
  dcineq[16272] = t533;
  dcineq[16273] = 0.0;
  dcineq[16274] = 0.0;
  dcineq[16275] = 0.0;
  dcineq[16276] = t499;
  dcineq[16277] = 0.0;
  dcineq[16278] = 0.0;
  dcineq[16279] = 0.0;
  dcineq[16280] = 0.0;
  dcineq[16281] = 0.0;
  dcineq[16282] = 0.0;
  dcineq[16283] = -1.0;
  memset(&dcineq[16284], 0, 132U * sizeof(real_T));
  dcineq[16416] = t532;
  dcineq[16417] = 0.0;
  dcineq[16418] = 0.0;
  dcineq[16419] = 0.0;
  dcineq[16420] = t377;
  dcineq[16421] = 0.0;
  dcineq[16422] = 0.0;
  dcineq[16423] = 0.0;
  dcineq[16424] = 0.0;
  dcineq[16425] = 0.0;
  dcineq[16426] = 0.0;
  dcineq[16427] = -1.0;
  memset(&dcineq[16428], 0, 132U * sizeof(real_T));
  dcineq[16560] = t531;
  dcineq[16561] = 0.0;
  dcineq[16562] = 0.0;
  dcineq[16563] = 0.0;
  dcineq[16564] = t257;
  dcineq[16565] = 0.0;
  dcineq[16566] = 0.0;
  dcineq[16567] = 0.0;
  dcineq[16568] = 0.0;
  dcineq[16569] = 0.0;
  dcineq[16570] = 0.0;
  dcineq[16571] = -1.0;
  memset(&dcineq[16572], 0, 132U * sizeof(real_T));
  dcineq[16704] = t530;
  dcineq[16705] = 0.0;
  dcineq[16706] = 0.0;
  dcineq[16707] = 0.0;
  dcineq[16708] = t498;
  dcineq[16709] = 0.0;
  dcineq[16710] = 0.0;
  dcineq[16711] = 0.0;
  dcineq[16712] = 0.0;
  dcineq[16713] = 0.0;
  dcineq[16714] = 0.0;
  dcineq[16715] = -1.0;
  memset(&dcineq[16716], 0, 132U * sizeof(real_T));
  dcineq[16848] = t529;
  dcineq[16849] = 0.0;
  dcineq[16850] = 0.0;
  dcineq[16851] = 0.0;
  dcineq[16852] = t376;
  dcineq[16853] = 0.0;
  dcineq[16854] = 0.0;
  dcineq[16855] = 0.0;
  dcineq[16856] = 0.0;
  dcineq[16857] = 0.0;
  dcineq[16858] = 0.0;
  dcineq[16859] = -1.0;
  memset(&dcineq[16860], 0, 132U * sizeof(real_T));
  dcineq[16992] = t528;
  dcineq[16993] = 0.0;
  dcineq[16994] = 0.0;
  dcineq[16995] = 0.0;
  dcineq[16996] = t256;
  dcineq[16997] = 0.0;
  dcineq[16998] = 0.0;
  dcineq[16999] = 0.0;
  dcineq[17000] = 0.0;
  dcineq[17001] = 0.0;
  dcineq[17002] = 0.0;
  dcineq[17003] = -1.0;
  memset(&dcineq[17004], 0, 132U * sizeof(real_T));
  dcineq[17136] = t527;
  dcineq[17137] = 0.0;
  dcineq[17138] = 0.0;
  dcineq[17139] = 0.0;
  dcineq[17140] = t497;
  dcineq[17141] = 0.0;
  dcineq[17142] = 0.0;
  dcineq[17143] = 0.0;
  dcineq[17144] = 0.0;
  dcineq[17145] = 0.0;
  dcineq[17146] = 0.0;
  dcineq[17147] = -1.0;
  memset(&dcineq[17148], 0, 132U * sizeof(real_T));
  dcineq[17280] = t526;
  dcineq[17281] = 0.0;
  dcineq[17282] = 0.0;
  dcineq[17283] = 0.0;
  dcineq[17284] = t496;
  dcineq[17285] = 0.0;
  dcineq[17286] = 0.0;
  dcineq[17287] = 0.0;
  dcineq[17288] = 0.0;
  dcineq[17289] = 0.0;
  dcineq[17290] = 0.0;
  dcineq[17291] = -1.0;
  memset(&dcineq[17292], 0, 148U * sizeof(real_T));
  dcineq[17440] = -1.0;
  memset(&dcineq[17441], 0, 143U * sizeof(real_T));
  dcineq[17584] = -1.0;
  memset(&dcineq[17585], 0, 143U * sizeof(real_T));
  dcineq[17728] = -1.0;
  memset(&dcineq[17729], 0, 143U * sizeof(real_T));
  dcineq[17872] = -1.0;
  memset(&dcineq[17873], 0, 143U * sizeof(real_T));
  dcineq[18016] = -1.0;
  memset(&dcineq[18017], 0, 143U * sizeof(real_T));
  dcineq[18160] = -1.0;
  memset(&dcineq[18161], 0, 143U * sizeof(real_T));
  dcineq[18304] = -1.0;
  memset(&dcineq[18305], 0, 143U * sizeof(real_T));
  dcineq[18448] = -1.0;
  memset(&dcineq[18449], 0, 143U * sizeof(real_T));
  dcineq[18592] = -1.0;
  memset(&dcineq[18593], 0, 143U * sizeof(real_T));
  dcineq[18736] = -1.0;
  memset(&dcineq[18737], 0, 155U * sizeof(real_T));
  dcineq[18892] = 1.0;
  memset(&dcineq[18893], 0, 143U * sizeof(real_T));
  dcineq[19036] = 1.0;
  memset(&dcineq[19037], 0, 143U * sizeof(real_T));
  dcineq[19180] = 1.0;
  memset(&dcineq[19181], 0, 143U * sizeof(real_T));
  dcineq[19324] = 1.0;
  memset(&dcineq[19325], 0, 143U * sizeof(real_T));
  dcineq[19468] = 1.0;
  memset(&dcineq[19469], 0, 143U * sizeof(real_T));
  dcineq[19612] = 1.0;
  memset(&dcineq[19613], 0, 143U * sizeof(real_T));
  dcineq[19756] = 1.0;
  memset(&dcineq[19757], 0, 143U * sizeof(real_T));
  dcineq[19900] = 1.0;
  memset(&dcineq[19901], 0, 143U * sizeof(real_T));
  dcineq[20044] = 1.0;
  memset(&dcineq[20045], 0, 143U * sizeof(real_T));
  dcineq[20188] = 1.0;
  memset(&dcineq[20189], 0, 151U * sizeof(real_T));
  dcineq[20340] = -1.0;
  memset(&dcineq[20341], 0, 143U * sizeof(real_T));
  dcineq[20484] = -1.0;
  memset(&dcineq[20485], 0, 143U * sizeof(real_T));
  dcineq[20628] = -1.0;
  memset(&dcineq[20629], 0, 143U * sizeof(real_T));
  dcineq[20772] = -1.0;
  memset(&dcineq[20773], 0, 143U * sizeof(real_T));
  dcineq[20916] = -1.0;
  memset(&dcineq[20917], 0, 143U * sizeof(real_T));
  dcineq[21060] = -1.0;
  memset(&dcineq[21061], 0, 143U * sizeof(real_T));
  dcineq[21204] = -1.0;
  memset(&dcineq[21205], 0, 143U * sizeof(real_T));
  dcineq[21348] = -1.0;
  memset(&dcineq[21349], 0, 143U * sizeof(real_T));
  dcineq[21492] = -1.0;
  memset(&dcineq[21493], 0, 143U * sizeof(real_T));
  dcineq[21636] = -1.0;
  memset(&dcineq[21637], 0, 155U * sizeof(real_T));
  dcineq[21792] = 1.0;
  memset(&dcineq[21793], 0, 143U * sizeof(real_T));
  dcineq[21936] = 1.0;
  memset(&dcineq[21937], 0, 143U * sizeof(real_T));
  dcineq[22080] = 1.0;
  memset(&dcineq[22081], 0, 143U * sizeof(real_T));
  dcineq[22224] = 1.0;
  memset(&dcineq[22225], 0, 143U * sizeof(real_T));
  dcineq[22368] = 1.0;
  memset(&dcineq[22369], 0, 143U * sizeof(real_T));
  dcineq[22512] = 1.0;
  memset(&dcineq[22513], 0, 143U * sizeof(real_T));
  dcineq[22656] = 1.0;
  memset(&dcineq[22657], 0, 143U * sizeof(real_T));
  dcineq[22800] = 1.0;
  memset(&dcineq[22801], 0, 143U * sizeof(real_T));
  dcineq[22944] = 1.0;
  memset(&dcineq[22945], 0, 143U * sizeof(real_T));
  dcineq[23088] = 1.0;
  memset(&dcineq[23089], 0, 143U * sizeof(real_T));
  dceq[0] = 1.0;
  memset(&dceq[1], 0, 131U * sizeof(real_T));
  dceq[132] = -in3[0];
  dceq[133] = -in3[8];
  dceq[134] = -in3[16];
  dceq[135] = -in3[24];
  dceq[136] = -in3[32];
  dceq[137] = -in3[40];
  dceq[138] = -in3[48];
  dceq[139] = -in3[56];
  dceq[140] = -in4[0];
  dceq[141] = -in4[8];
  dceq[142] = 0.0;
  dceq[143] = 0.0;
  dceq[144] = 1.0;
  memset(&dceq[145], 0, 131U * sizeof(real_T));
  dceq[276] = -in3[0];
  dceq[277] = -in3[8];
  dceq[278] = -in3[16];
  dceq[279] = -in3[24];
  dceq[280] = -in3[32];
  dceq[281] = -in3[40];
  dceq[282] = -in3[48];
  dceq[283] = -in3[56];
  dceq[284] = -in4[0];
  dceq[285] = -in4[8];
  dceq[286] = 0.0;
  dceq[287] = 0.0;
  dceq[288] = 1.0;
  memset(&dceq[289], 0, 131U * sizeof(real_T));
  dceq[420] = -in3[0];
  dceq[421] = -in3[8];
  dceq[422] = -in3[16];
  dceq[423] = -in3[24];
  dceq[424] = -in3[32];
  dceq[425] = -in3[40];
  dceq[426] = -in3[48];
  dceq[427] = -in3[56];
  dceq[428] = -in4[0];
  dceq[429] = -in4[8];
  dceq[430] = 0.0;
  dceq[431] = 0.0;
  dceq[432] = 1.0;
  memset(&dceq[433], 0, 131U * sizeof(real_T));
  dceq[564] = -in3[0];
  dceq[565] = -in3[8];
  dceq[566] = -in3[16];
  dceq[567] = -in3[24];
  dceq[568] = -in3[32];
  dceq[569] = -in3[40];
  dceq[570] = -in3[48];
  dceq[571] = -in3[56];
  dceq[572] = -in4[0];
  dceq[573] = -in4[8];
  dceq[574] = 0.0;
  dceq[575] = 0.0;
  dceq[576] = 1.0;
  memset(&dceq[577], 0, 131U * sizeof(real_T));
  dceq[708] = -in3[0];
  dceq[709] = -in3[8];
  dceq[710] = -in3[16];
  dceq[711] = -in3[24];
  dceq[712] = -in3[32];
  dceq[713] = -in3[40];
  dceq[714] = -in3[48];
  dceq[715] = -in3[56];
  dceq[716] = -in4[0];
  dceq[717] = -in4[8];
  dceq[718] = 0.0;
  dceq[719] = 0.0;
  dceq[720] = 1.0;
  memset(&dceq[721], 0, 131U * sizeof(real_T));
  dceq[852] = -in3[0];
  dceq[853] = -in3[8];
  dceq[854] = -in3[16];
  dceq[855] = -in3[24];
  dceq[856] = -in3[32];
  dceq[857] = -in3[40];
  dceq[858] = -in3[48];
  dceq[859] = -in3[56];
  dceq[860] = -in4[0];
  dceq[861] = -in4[8];
  dceq[862] = 0.0;
  dceq[863] = 0.0;
  dceq[864] = 1.0;
  memset(&dceq[865], 0, 131U * sizeof(real_T));
  dceq[996] = -in3[0];
  dceq[997] = -in3[8];
  dceq[998] = -in3[16];
  dceq[999] = -in3[24];
  dceq[1000] = -in3[32];
  dceq[1001] = -in3[40];
  dceq[1002] = -in3[48];
  dceq[1003] = -in3[56];
  dceq[1004] = -in4[0];
  dceq[1005] = -in4[8];
  dceq[1006] = 0.0;
  dceq[1007] = 0.0;
  dceq[1008] = 1.0;
  memset(&dceq[1009], 0, 131U * sizeof(real_T));
  dceq[1140] = -in3[0];
  dceq[1141] = -in3[8];
  dceq[1142] = -in3[16];
  dceq[1143] = -in3[24];
  dceq[1144] = -in3[32];
  dceq[1145] = -in3[40];
  dceq[1146] = -in3[48];
  dceq[1147] = -in3[56];
  dceq[1148] = -in4[0];
  dceq[1149] = -in4[8];
  dceq[1150] = 0.0;
  dceq[1151] = 0.0;
  dceq[1152] = 1.0;
  memset(&dceq[1153], 0, 131U * sizeof(real_T));
  dceq[1284] = -in3[0];
  dceq[1285] = -in3[8];
  dceq[1286] = -in3[16];
  dceq[1287] = -in3[24];
  dceq[1288] = -in3[32];
  dceq[1289] = -in3[40];
  dceq[1290] = -in3[48];
  dceq[1291] = -in3[56];
  dceq[1292] = -in4[0];
  dceq[1293] = -in4[8];
  dceq[1294] = 0.0;
  dceq[1295] = 0.0;
  dceq[1296] = 1.0;
  memset(&dceq[1297], 0, 131U * sizeof(real_T));
  dceq[1428] = -in3[0];
  dceq[1429] = -in3[8];
  dceq[1430] = -in3[16];
  dceq[1431] = -in3[24];
  dceq[1432] = -in3[32];
  dceq[1433] = -in3[40];
  dceq[1434] = -in3[48];
  dceq[1435] = -in3[56];
  dceq[1436] = -in4[0];
  dceq[1437] = -in4[8];
  dceq[1438] = 0.0;
  dceq[1439] = 0.0;
  dceq[1440] = 1.0;
  memset(&dceq[1441], 0, 12U * sizeof(real_T));
  dceq[1453] = 1.0;
  memset(&dceq[1454], 0, 130U * sizeof(real_T));
  dceq[1584] = -in3[1];
  dceq[1585] = -in3[9];
  dceq[1586] = -in3[17];
  dceq[1587] = -in3[25];
  dceq[1588] = -in3[33];
  dceq[1589] = -in3[41];
  dceq[1590] = -in3[49];
  dceq[1591] = -in3[57];
  dceq[1592] = -in4[1];
  dceq[1593] = -in4[9];
  dceq[1594] = 0.0;
  dceq[1595] = 0.0;
  dceq[1596] = 0.0;
  dceq[1597] = 1.0;
  memset(&dceq[1598], 0, 130U * sizeof(real_T));
  dceq[1728] = -in3[1];
  dceq[1729] = -in3[9];
  dceq[1730] = -in3[17];
  dceq[1731] = -in3[25];
  dceq[1732] = -in3[33];
  dceq[1733] = -in3[41];
  dceq[1734] = -in3[49];
  dceq[1735] = -in3[57];
  dceq[1736] = -in4[1];
  dceq[1737] = -in4[9];
  dceq[1738] = 0.0;
  dceq[1739] = 0.0;
  dceq[1740] = 0.0;
  dceq[1741] = 1.0;
  memset(&dceq[1742], 0, 130U * sizeof(real_T));
  dceq[1872] = -in3[1];
  dceq[1873] = -in3[9];
  dceq[1874] = -in3[17];
  dceq[1875] = -in3[25];
  dceq[1876] = -in3[33];
  dceq[1877] = -in3[41];
  dceq[1878] = -in3[49];
  dceq[1879] = -in3[57];
  dceq[1880] = -in4[1];
  dceq[1881] = -in4[9];
  dceq[1882] = 0.0;
  dceq[1883] = 0.0;
  dceq[1884] = 0.0;
  dceq[1885] = 1.0;
  memset(&dceq[1886], 0, 130U * sizeof(real_T));
  dceq[2016] = -in3[1];
  dceq[2017] = -in3[9];
  dceq[2018] = -in3[17];
  dceq[2019] = -in3[25];
  dceq[2020] = -in3[33];
  dceq[2021] = -in3[41];
  dceq[2022] = -in3[49];
  dceq[2023] = -in3[57];
  dceq[2024] = -in4[1];
  dceq[2025] = -in4[9];
  dceq[2026] = 0.0;
  dceq[2027] = 0.0;
  dceq[2028] = 0.0;
  dceq[2029] = 1.0;
  memset(&dceq[2030], 0, 130U * sizeof(real_T));
  dceq[2160] = -in3[1];
  dceq[2161] = -in3[9];
  dceq[2162] = -in3[17];
  dceq[2163] = -in3[25];
  dceq[2164] = -in3[33];
  dceq[2165] = -in3[41];
  dceq[2166] = -in3[49];
  dceq[2167] = -in3[57];
  dceq[2168] = -in4[1];
  dceq[2169] = -in4[9];
  dceq[2170] = 0.0;
  dceq[2171] = 0.0;
  dceq[2172] = 0.0;
  dceq[2173] = 1.0;
  memset(&dceq[2174], 0, 130U * sizeof(real_T));
  dceq[2304] = -in3[1];
  dceq[2305] = -in3[9];
  dceq[2306] = -in3[17];
  dceq[2307] = -in3[25];
  dceq[2308] = -in3[33];
  dceq[2309] = -in3[41];
  dceq[2310] = -in3[49];
  dceq[2311] = -in3[57];
  dceq[2312] = -in4[1];
  dceq[2313] = -in4[9];
  dceq[2314] = 0.0;
  dceq[2315] = 0.0;
  dceq[2316] = 0.0;
  dceq[2317] = 1.0;
  memset(&dceq[2318], 0, 130U * sizeof(real_T));
  dceq[2448] = -in3[1];
  dceq[2449] = -in3[9];
  dceq[2450] = -in3[17];
  dceq[2451] = -in3[25];
  dceq[2452] = -in3[33];
  dceq[2453] = -in3[41];
  dceq[2454] = -in3[49];
  dceq[2455] = -in3[57];
  dceq[2456] = -in4[1];
  dceq[2457] = -in4[9];
  dceq[2458] = 0.0;
  dceq[2459] = 0.0;
  dceq[2460] = 0.0;
  dceq[2461] = 1.0;
  memset(&dceq[2462], 0, 130U * sizeof(real_T));
  dceq[2592] = -in3[1];
  dceq[2593] = -in3[9];
  dceq[2594] = -in3[17];
  dceq[2595] = -in3[25];
  dceq[2596] = -in3[33];
  dceq[2597] = -in3[41];
  dceq[2598] = -in3[49];
  dceq[2599] = -in3[57];
  dceq[2600] = -in4[1];
  dceq[2601] = -in4[9];
  dceq[2602] = 0.0;
  dceq[2603] = 0.0;
  dceq[2604] = 0.0;
  dceq[2605] = 1.0;
  memset(&dceq[2606], 0, 130U * sizeof(real_T));
  dceq[2736] = -in3[1];
  dceq[2737] = -in3[9];
  dceq[2738] = -in3[17];
  dceq[2739] = -in3[25];
  dceq[2740] = -in3[33];
  dceq[2741] = -in3[41];
  dceq[2742] = -in3[49];
  dceq[2743] = -in3[57];
  dceq[2744] = -in4[1];
  dceq[2745] = -in4[9];
  dceq[2746] = 0.0;
  dceq[2747] = 0.0;
  dceq[2748] = 0.0;
  dceq[2749] = 1.0;
  memset(&dceq[2750], 0, 130U * sizeof(real_T));
  dceq[2880] = -in3[1];
  dceq[2881] = -in3[9];
  dceq[2882] = -in3[17];
  dceq[2883] = -in3[25];
  dceq[2884] = -in3[33];
  dceq[2885] = -in3[41];
  dceq[2886] = -in3[49];
  dceq[2887] = -in3[57];
  dceq[2888] = -in4[1];
  dceq[2889] = -in4[9];
  dceq[2890] = 0.0;
  dceq[2891] = 0.0;
  dceq[2892] = 0.0;
  dceq[2893] = 1.0;
  memset(&dceq[2894], 0, 12U * sizeof(real_T));
  dceq[2906] = 1.0;
  memset(&dceq[2907], 0, 129U * sizeof(real_T));
  dceq[3036] = -in3[2];
  dceq[3037] = -in3[10];
  dceq[3038] = -in3[18];
  dceq[3039] = -in3[26];
  dceq[3040] = -in3[34];
  dceq[3041] = -in3[42];
  dceq[3042] = -in3[50];
  dceq[3043] = -in3[58];
  dceq[3044] = -in4[2];
  dceq[3045] = -in4[10];
  dceq[3046] = 0.0;
  dceq[3047] = 0.0;
  dceq[3048] = 0.0;
  dceq[3049] = 0.0;
  dceq[3050] = 1.0;
  memset(&dceq[3051], 0, 129U * sizeof(real_T));
  dceq[3180] = -in3[2];
  dceq[3181] = -in3[10];
  dceq[3182] = -in3[18];
  dceq[3183] = -in3[26];
  dceq[3184] = -in3[34];
  dceq[3185] = -in3[42];
  dceq[3186] = -in3[50];
  dceq[3187] = -in3[58];
  dceq[3188] = -in4[2];
  dceq[3189] = -in4[10];
  dceq[3190] = 0.0;
  dceq[3191] = 0.0;
  dceq[3192] = 0.0;
  dceq[3193] = 0.0;
  dceq[3194] = 1.0;
  memset(&dceq[3195], 0, 129U * sizeof(real_T));
  dceq[3324] = -in3[2];
  dceq[3325] = -in3[10];
  dceq[3326] = -in3[18];
  dceq[3327] = -in3[26];
  dceq[3328] = -in3[34];
  dceq[3329] = -in3[42];
  dceq[3330] = -in3[50];
  dceq[3331] = -in3[58];
  dceq[3332] = -in4[2];
  dceq[3333] = -in4[10];
  dceq[3334] = 0.0;
  dceq[3335] = 0.0;
  dceq[3336] = 0.0;
  dceq[3337] = 0.0;
  dceq[3338] = 1.0;
  memset(&dceq[3339], 0, 129U * sizeof(real_T));
  dceq[3468] = -in3[2];
  dceq[3469] = -in3[10];
  dceq[3470] = -in3[18];
  dceq[3471] = -in3[26];
  dceq[3472] = -in3[34];
  dceq[3473] = -in3[42];
  dceq[3474] = -in3[50];
  dceq[3475] = -in3[58];
  dceq[3476] = -in4[2];
  dceq[3477] = -in4[10];
  dceq[3478] = 0.0;
  dceq[3479] = 0.0;
  dceq[3480] = 0.0;
  dceq[3481] = 0.0;
  dceq[3482] = 1.0;
  memset(&dceq[3483], 0, 129U * sizeof(real_T));
  dceq[3612] = -in3[2];
  dceq[3613] = -in3[10];
  dceq[3614] = -in3[18];
  dceq[3615] = -in3[26];
  dceq[3616] = -in3[34];
  dceq[3617] = -in3[42];
  dceq[3618] = -in3[50];
  dceq[3619] = -in3[58];
  dceq[3620] = -in4[2];
  dceq[3621] = -in4[10];
  dceq[3622] = 0.0;
  dceq[3623] = 0.0;
  dceq[3624] = 0.0;
  dceq[3625] = 0.0;
  dceq[3626] = 1.0;
  memset(&dceq[3627], 0, 129U * sizeof(real_T));
  dceq[3756] = -in3[2];
  dceq[3757] = -in3[10];
  dceq[3758] = -in3[18];
  dceq[3759] = -in3[26];
  dceq[3760] = -in3[34];
  dceq[3761] = -in3[42];
  dceq[3762] = -in3[50];
  dceq[3763] = -in3[58];
  dceq[3764] = -in4[2];
  dceq[3765] = -in4[10];
  dceq[3766] = 0.0;
  dceq[3767] = 0.0;
  dceq[3768] = 0.0;
  dceq[3769] = 0.0;
  dceq[3770] = 1.0;
  memset(&dceq[3771], 0, 129U * sizeof(real_T));
  dceq[3900] = -in3[2];
  dceq[3901] = -in3[10];
  dceq[3902] = -in3[18];
  dceq[3903] = -in3[26];
  dceq[3904] = -in3[34];
  dceq[3905] = -in3[42];
  dceq[3906] = -in3[50];
  dceq[3907] = -in3[58];
  dceq[3908] = -in4[2];
  dceq[3909] = -in4[10];
  dceq[3910] = 0.0;
  dceq[3911] = 0.0;
  dceq[3912] = 0.0;
  dceq[3913] = 0.0;
  dceq[3914] = 1.0;
  memset(&dceq[3915], 0, 129U * sizeof(real_T));
  dceq[4044] = -in3[2];
  dceq[4045] = -in3[10];
  dceq[4046] = -in3[18];
  dceq[4047] = -in3[26];
  dceq[4048] = -in3[34];
  dceq[4049] = -in3[42];
  dceq[4050] = -in3[50];
  dceq[4051] = -in3[58];
  dceq[4052] = -in4[2];
  dceq[4053] = -in4[10];
  dceq[4054] = 0.0;
  dceq[4055] = 0.0;
  dceq[4056] = 0.0;
  dceq[4057] = 0.0;
  dceq[4058] = 1.0;
  memset(&dceq[4059], 0, 129U * sizeof(real_T));
  dceq[4188] = -in3[2];
  dceq[4189] = -in3[10];
  dceq[4190] = -in3[18];
  dceq[4191] = -in3[26];
  dceq[4192] = -in3[34];
  dceq[4193] = -in3[42];
  dceq[4194] = -in3[50];
  dceq[4195] = -in3[58];
  dceq[4196] = -in4[2];
  dceq[4197] = -in4[10];
  dceq[4198] = 0.0;
  dceq[4199] = 0.0;
  dceq[4200] = 0.0;
  dceq[4201] = 0.0;
  dceq[4202] = 1.0;
  memset(&dceq[4203], 0, 129U * sizeof(real_T));
  dceq[4332] = -in3[2];
  dceq[4333] = -in3[10];
  dceq[4334] = -in3[18];
  dceq[4335] = -in3[26];
  dceq[4336] = -in3[34];
  dceq[4337] = -in3[42];
  dceq[4338] = -in3[50];
  dceq[4339] = -in3[58];
  dceq[4340] = -in4[2];
  dceq[4341] = -in4[10];
  dceq[4342] = 0.0;
  dceq[4343] = 0.0;
  dceq[4344] = 0.0;
  dceq[4345] = 0.0;
  dceq[4346] = 1.0;
  memset(&dceq[4347], 0, 12U * sizeof(real_T));
  dceq[4359] = 1.0;
  memset(&dceq[4360], 0, 128U * sizeof(real_T));
  dceq[4488] = -in3[3];
  dceq[4489] = -in3[11];
  dceq[4490] = -in3[19];
  dceq[4491] = -in3[27];
  dceq[4492] = -in3[35];
  dceq[4493] = -in3[43];
  dceq[4494] = -in3[51];
  dceq[4495] = -in3[59];
  dceq[4496] = -in4[3];
  dceq[4497] = -in4[11];
  dceq[4498] = 0.0;
  dceq[4499] = 0.0;
  dceq[4500] = 0.0;
  dceq[4501] = 0.0;
  dceq[4502] = 0.0;
  dceq[4503] = 1.0;
  memset(&dceq[4504], 0, 128U * sizeof(real_T));
  dceq[4632] = -in3[3];
  dceq[4633] = -in3[11];
  dceq[4634] = -in3[19];
  dceq[4635] = -in3[27];
  dceq[4636] = -in3[35];
  dceq[4637] = -in3[43];
  dceq[4638] = -in3[51];
  dceq[4639] = -in3[59];
  dceq[4640] = -in4[3];
  dceq[4641] = -in4[11];
  dceq[4642] = 0.0;
  dceq[4643] = 0.0;
  dceq[4644] = 0.0;
  dceq[4645] = 0.0;
  dceq[4646] = 0.0;
  dceq[4647] = 1.0;
  memset(&dceq[4648], 0, 128U * sizeof(real_T));
  dceq[4776] = -in3[3];
  dceq[4777] = -in3[11];
  dceq[4778] = -in3[19];
  dceq[4779] = -in3[27];
  dceq[4780] = -in3[35];
  dceq[4781] = -in3[43];
  dceq[4782] = -in3[51];
  dceq[4783] = -in3[59];
  dceq[4784] = -in4[3];
  dceq[4785] = -in4[11];
  dceq[4786] = 0.0;
  dceq[4787] = 0.0;
  dceq[4788] = 0.0;
  dceq[4789] = 0.0;
  dceq[4790] = 0.0;
  dceq[4791] = 1.0;
  memset(&dceq[4792], 0, 128U * sizeof(real_T));
  dceq[4920] = -in3[3];
  dceq[4921] = -in3[11];
  dceq[4922] = -in3[19];
  dceq[4923] = -in3[27];
  dceq[4924] = -in3[35];
  dceq[4925] = -in3[43];
  dceq[4926] = -in3[51];
  dceq[4927] = -in3[59];
  dceq[4928] = -in4[3];
  dceq[4929] = -in4[11];
  dceq[4930] = 0.0;
  dceq[4931] = 0.0;
  dceq[4932] = 0.0;
  dceq[4933] = 0.0;
  dceq[4934] = 0.0;
  dceq[4935] = 1.0;
  memset(&dceq[4936], 0, 128U * sizeof(real_T));
  dceq[5064] = -in3[3];
  dceq[5065] = -in3[11];
  dceq[5066] = -in3[19];
  dceq[5067] = -in3[27];
  dceq[5068] = -in3[35];
  dceq[5069] = -in3[43];
  dceq[5070] = -in3[51];
  dceq[5071] = -in3[59];
  dceq[5072] = -in4[3];
  dceq[5073] = -in4[11];
  dceq[5074] = 0.0;
  dceq[5075] = 0.0;
  dceq[5076] = 0.0;
  dceq[5077] = 0.0;
  dceq[5078] = 0.0;
  dceq[5079] = 1.0;
  memset(&dceq[5080], 0, 128U * sizeof(real_T));
  dceq[5208] = -in3[3];
  dceq[5209] = -in3[11];
  dceq[5210] = -in3[19];
  dceq[5211] = -in3[27];
  dceq[5212] = -in3[35];
  dceq[5213] = -in3[43];
  dceq[5214] = -in3[51];
  dceq[5215] = -in3[59];
  dceq[5216] = -in4[3];
  dceq[5217] = -in4[11];
  dceq[5218] = 0.0;
  dceq[5219] = 0.0;
  dceq[5220] = 0.0;
  dceq[5221] = 0.0;
  dceq[5222] = 0.0;
  dceq[5223] = 1.0;
  memset(&dceq[5224], 0, 128U * sizeof(real_T));
  dceq[5352] = -in3[3];
  dceq[5353] = -in3[11];
  dceq[5354] = -in3[19];
  dceq[5355] = -in3[27];
  dceq[5356] = -in3[35];
  dceq[5357] = -in3[43];
  dceq[5358] = -in3[51];
  dceq[5359] = -in3[59];
  dceq[5360] = -in4[3];
  dceq[5361] = -in4[11];
  dceq[5362] = 0.0;
  dceq[5363] = 0.0;
  dceq[5364] = 0.0;
  dceq[5365] = 0.0;
  dceq[5366] = 0.0;
  dceq[5367] = 1.0;
  memset(&dceq[5368], 0, 128U * sizeof(real_T));
  dceq[5496] = -in3[3];
  dceq[5497] = -in3[11];
  dceq[5498] = -in3[19];
  dceq[5499] = -in3[27];
  dceq[5500] = -in3[35];
  dceq[5501] = -in3[43];
  dceq[5502] = -in3[51];
  dceq[5503] = -in3[59];
  dceq[5504] = -in4[3];
  dceq[5505] = -in4[11];
  dceq[5506] = 0.0;
  dceq[5507] = 0.0;
  dceq[5508] = 0.0;
  dceq[5509] = 0.0;
  dceq[5510] = 0.0;
  dceq[5511] = 1.0;
  memset(&dceq[5512], 0, 128U * sizeof(real_T));
  dceq[5640] = -in3[3];
  dceq[5641] = -in3[11];
  dceq[5642] = -in3[19];
  dceq[5643] = -in3[27];
  dceq[5644] = -in3[35];
  dceq[5645] = -in3[43];
  dceq[5646] = -in3[51];
  dceq[5647] = -in3[59];
  dceq[5648] = -in4[3];
  dceq[5649] = -in4[11];
  dceq[5650] = 0.0;
  dceq[5651] = 0.0;
  dceq[5652] = 0.0;
  dceq[5653] = 0.0;
  dceq[5654] = 0.0;
  dceq[5655] = 1.0;
  memset(&dceq[5656], 0, 128U * sizeof(real_T));
  dceq[5784] = -in3[3];
  dceq[5785] = -in3[11];
  dceq[5786] = -in3[19];
  dceq[5787] = -in3[27];
  dceq[5788] = -in3[35];
  dceq[5789] = -in3[43];
  dceq[5790] = -in3[51];
  dceq[5791] = -in3[59];
  dceq[5792] = -in4[3];
  dceq[5793] = -in4[11];
  dceq[5794] = 0.0;
  dceq[5795] = 0.0;
  dceq[5796] = 0.0;
  dceq[5797] = 0.0;
  dceq[5798] = 0.0;
  dceq[5799] = 1.0;
  memset(&dceq[5800], 0, 12U * sizeof(real_T));
  dceq[5812] = 1.0;
  memset(&dceq[5813], 0, 127U * sizeof(real_T));
  dceq[5940] = -in3[4];
  dceq[5941] = -in3[12];
  dceq[5942] = -in3[20];
  dceq[5943] = -in3[28];
  dceq[5944] = -in3[36];
  dceq[5945] = -in3[44];
  dceq[5946] = -in3[52];
  dceq[5947] = -in3[60];
  dceq[5948] = -in4[4];
  dceq[5949] = -in4[12];
  dceq[5950] = 0.0;
  dceq[5951] = 0.0;
  dceq[5952] = 0.0;
  dceq[5953] = 0.0;
  dceq[5954] = 0.0;
  dceq[5955] = 0.0;
  dceq[5956] = 1.0;
  memset(&dceq[5957], 0, 127U * sizeof(real_T));
  dceq[6084] = -in3[4];
  dceq[6085] = -in3[12];
  dceq[6086] = -in3[20];
  dceq[6087] = -in3[28];
  dceq[6088] = -in3[36];
  dceq[6089] = -in3[44];
  dceq[6090] = -in3[52];
  dceq[6091] = -in3[60];
  dceq[6092] = -in4[4];
  dceq[6093] = -in4[12];
  dceq[6094] = 0.0;
  dceq[6095] = 0.0;
  dceq[6096] = 0.0;
  dceq[6097] = 0.0;
  dceq[6098] = 0.0;
  dceq[6099] = 0.0;
  dceq[6100] = 1.0;
  memset(&dceq[6101], 0, 127U * sizeof(real_T));
  dceq[6228] = -in3[4];
  dceq[6229] = -in3[12];
  dceq[6230] = -in3[20];
  dceq[6231] = -in3[28];
  dceq[6232] = -in3[36];
  dceq[6233] = -in3[44];
  dceq[6234] = -in3[52];
  dceq[6235] = -in3[60];
  dceq[6236] = -in4[4];
  dceq[6237] = -in4[12];
  dceq[6238] = 0.0;
  dceq[6239] = 0.0;
  dceq[6240] = 0.0;
  dceq[6241] = 0.0;
  dceq[6242] = 0.0;
  dceq[6243] = 0.0;
  dceq[6244] = 1.0;
  memset(&dceq[6245], 0, 127U * sizeof(real_T));
  dceq[6372] = -in3[4];
  dceq[6373] = -in3[12];
  dceq[6374] = -in3[20];
  dceq[6375] = -in3[28];
  dceq[6376] = -in3[36];
  dceq[6377] = -in3[44];
  dceq[6378] = -in3[52];
  dceq[6379] = -in3[60];
  dceq[6380] = -in4[4];
  dceq[6381] = -in4[12];
  dceq[6382] = 0.0;
  dceq[6383] = 0.0;
  dceq[6384] = 0.0;
  dceq[6385] = 0.0;
  dceq[6386] = 0.0;
  dceq[6387] = 0.0;
  dceq[6388] = 1.0;
  memset(&dceq[6389], 0, 127U * sizeof(real_T));
  dceq[6516] = -in3[4];
  dceq[6517] = -in3[12];
  dceq[6518] = -in3[20];
  dceq[6519] = -in3[28];
  dceq[6520] = -in3[36];
  dceq[6521] = -in3[44];
  dceq[6522] = -in3[52];
  dceq[6523] = -in3[60];
  dceq[6524] = -in4[4];
  dceq[6525] = -in4[12];
  dceq[6526] = 0.0;
  dceq[6527] = 0.0;
  dceq[6528] = 0.0;
  dceq[6529] = 0.0;
  dceq[6530] = 0.0;
  dceq[6531] = 0.0;
  dceq[6532] = 1.0;
  memset(&dceq[6533], 0, 127U * sizeof(real_T));
  dceq[6660] = -in3[4];
  dceq[6661] = -in3[12];
  dceq[6662] = -in3[20];
  dceq[6663] = -in3[28];
  dceq[6664] = -in3[36];
  dceq[6665] = -in3[44];
  dceq[6666] = -in3[52];
  dceq[6667] = -in3[60];
  dceq[6668] = -in4[4];
  dceq[6669] = -in4[12];
  dceq[6670] = 0.0;
  dceq[6671] = 0.0;
  dceq[6672] = 0.0;
  dceq[6673] = 0.0;
  dceq[6674] = 0.0;
  dceq[6675] = 0.0;
  dceq[6676] = 1.0;
  memset(&dceq[6677], 0, 127U * sizeof(real_T));
  dceq[6804] = -in3[4];
  dceq[6805] = -in3[12];
  dceq[6806] = -in3[20];
  dceq[6807] = -in3[28];
  dceq[6808] = -in3[36];
  dceq[6809] = -in3[44];
  dceq[6810] = -in3[52];
  dceq[6811] = -in3[60];
  dceq[6812] = -in4[4];
  dceq[6813] = -in4[12];
  dceq[6814] = 0.0;
  dceq[6815] = 0.0;
  dceq[6816] = 0.0;
  dceq[6817] = 0.0;
  dceq[6818] = 0.0;
  dceq[6819] = 0.0;
  dceq[6820] = 1.0;
  memset(&dceq[6821], 0, 127U * sizeof(real_T));
  dceq[6948] = -in3[4];
  dceq[6949] = -in3[12];
  dceq[6950] = -in3[20];
  dceq[6951] = -in3[28];
  dceq[6952] = -in3[36];
  dceq[6953] = -in3[44];
  dceq[6954] = -in3[52];
  dceq[6955] = -in3[60];
  dceq[6956] = -in4[4];
  dceq[6957] = -in4[12];
  dceq[6958] = 0.0;
  dceq[6959] = 0.0;
  dceq[6960] = 0.0;
  dceq[6961] = 0.0;
  dceq[6962] = 0.0;
  dceq[6963] = 0.0;
  dceq[6964] = 1.0;
  memset(&dceq[6965], 0, 127U * sizeof(real_T));
  dceq[7092] = -in3[4];
  dceq[7093] = -in3[12];
  dceq[7094] = -in3[20];
  dceq[7095] = -in3[28];
  dceq[7096] = -in3[36];
  dceq[7097] = -in3[44];
  dceq[7098] = -in3[52];
  dceq[7099] = -in3[60];
  dceq[7100] = -in4[4];
  dceq[7101] = -in4[12];
  dceq[7102] = 0.0;
  dceq[7103] = 0.0;
  dceq[7104] = 0.0;
  dceq[7105] = 0.0;
  dceq[7106] = 0.0;
  dceq[7107] = 0.0;
  dceq[7108] = 1.0;
  memset(&dceq[7109], 0, 127U * sizeof(real_T));
  dceq[7236] = -in3[4];
  dceq[7237] = -in3[12];
  dceq[7238] = -in3[20];
  dceq[7239] = -in3[28];
  dceq[7240] = -in3[36];
  dceq[7241] = -in3[44];
  dceq[7242] = -in3[52];
  dceq[7243] = -in3[60];
  dceq[7244] = -in4[4];
  dceq[7245] = -in4[12];
  dceq[7246] = 0.0;
  dceq[7247] = 0.0;
  dceq[7248] = 0.0;
  dceq[7249] = 0.0;
  dceq[7250] = 0.0;
  dceq[7251] = 0.0;
  dceq[7252] = 1.0;
  memset(&dceq[7253], 0, 12U * sizeof(real_T));
  dceq[7265] = 1.0;
  memset(&dceq[7266], 0, 126U * sizeof(real_T));
  dceq[7392] = -in3[5];
  dceq[7393] = -in3[13];
  dceq[7394] = -in3[21];
  dceq[7395] = -in3[29];
  dceq[7396] = -in3[37];
  dceq[7397] = -in3[45];
  dceq[7398] = -in3[53];
  dceq[7399] = -in3[61];
  dceq[7400] = -in4[5];
  dceq[7401] = -in4[13];
  dceq[7402] = 0.0;
  dceq[7403] = 0.0;
  dceq[7404] = 0.0;
  dceq[7405] = 0.0;
  dceq[7406] = 0.0;
  dceq[7407] = 0.0;
  dceq[7408] = 0.0;
  dceq[7409] = 1.0;
  memset(&dceq[7410], 0, 126U * sizeof(real_T));
  dceq[7536] = -in3[5];
  dceq[7537] = -in3[13];
  dceq[7538] = -in3[21];
  dceq[7539] = -in3[29];
  dceq[7540] = -in3[37];
  dceq[7541] = -in3[45];
  dceq[7542] = -in3[53];
  dceq[7543] = -in3[61];
  dceq[7544] = -in4[5];
  dceq[7545] = -in4[13];
  dceq[7546] = 0.0;
  dceq[7547] = 0.0;
  dceq[7548] = 0.0;
  dceq[7549] = 0.0;
  dceq[7550] = 0.0;
  dceq[7551] = 0.0;
  dceq[7552] = 0.0;
  dceq[7553] = 1.0;
  memset(&dceq[7554], 0, 126U * sizeof(real_T));
  dceq[7680] = -in3[5];
  dceq[7681] = -in3[13];
  dceq[7682] = -in3[21];
  dceq[7683] = -in3[29];
  dceq[7684] = -in3[37];
  dceq[7685] = -in3[45];
  dceq[7686] = -in3[53];
  dceq[7687] = -in3[61];
  dceq[7688] = -in4[5];
  dceq[7689] = -in4[13];
  dceq[7690] = 0.0;
  dceq[7691] = 0.0;
  dceq[7692] = 0.0;
  dceq[7693] = 0.0;
  dceq[7694] = 0.0;
  dceq[7695] = 0.0;
  dceq[7696] = 0.0;
  dceq[7697] = 1.0;
  memset(&dceq[7698], 0, 126U * sizeof(real_T));
  dceq[7824] = -in3[5];
  dceq[7825] = -in3[13];
  dceq[7826] = -in3[21];
  dceq[7827] = -in3[29];
  dceq[7828] = -in3[37];
  dceq[7829] = -in3[45];
  dceq[7830] = -in3[53];
  dceq[7831] = -in3[61];
  dceq[7832] = -in4[5];
  dceq[7833] = -in4[13];
  dceq[7834] = 0.0;
  dceq[7835] = 0.0;
  dceq[7836] = 0.0;
  dceq[7837] = 0.0;
  dceq[7838] = 0.0;
  dceq[7839] = 0.0;
  dceq[7840] = 0.0;
  dceq[7841] = 1.0;
  memset(&dceq[7842], 0, 126U * sizeof(real_T));
  dceq[7968] = -in3[5];
  dceq[7969] = -in3[13];
  dceq[7970] = -in3[21];
  dceq[7971] = -in3[29];
  dceq[7972] = -in3[37];
  dceq[7973] = -in3[45];
  dceq[7974] = -in3[53];
  dceq[7975] = -in3[61];
  dceq[7976] = -in4[5];
  dceq[7977] = -in4[13];
  dceq[7978] = 0.0;
  dceq[7979] = 0.0;
  dceq[7980] = 0.0;
  dceq[7981] = 0.0;
  dceq[7982] = 0.0;
  dceq[7983] = 0.0;
  dceq[7984] = 0.0;
  dceq[7985] = 1.0;
  memset(&dceq[7986], 0, 126U * sizeof(real_T));
  dceq[8112] = -in3[5];
  dceq[8113] = -in3[13];
  dceq[8114] = -in3[21];
  dceq[8115] = -in3[29];
  dceq[8116] = -in3[37];
  dceq[8117] = -in3[45];
  dceq[8118] = -in3[53];
  dceq[8119] = -in3[61];
  dceq[8120] = -in4[5];
  dceq[8121] = -in4[13];
  dceq[8122] = 0.0;
  dceq[8123] = 0.0;
  dceq[8124] = 0.0;
  dceq[8125] = 0.0;
  dceq[8126] = 0.0;
  dceq[8127] = 0.0;
  dceq[8128] = 0.0;
  dceq[8129] = 1.0;
  memset(&dceq[8130], 0, 126U * sizeof(real_T));
  dceq[8256] = -in3[5];
  dceq[8257] = -in3[13];
  dceq[8258] = -in3[21];
  dceq[8259] = -in3[29];
  dceq[8260] = -in3[37];
  dceq[8261] = -in3[45];
  dceq[8262] = -in3[53];
  dceq[8263] = -in3[61];
  dceq[8264] = -in4[5];
  dceq[8265] = -in4[13];
  dceq[8266] = 0.0;
  dceq[8267] = 0.0;
  dceq[8268] = 0.0;
  dceq[8269] = 0.0;
  dceq[8270] = 0.0;
  dceq[8271] = 0.0;
  dceq[8272] = 0.0;
  dceq[8273] = 1.0;
  memset(&dceq[8274], 0, 126U * sizeof(real_T));
  dceq[8400] = -in3[5];
  dceq[8401] = -in3[13];
  dceq[8402] = -in3[21];
  dceq[8403] = -in3[29];
  dceq[8404] = -in3[37];
  dceq[8405] = -in3[45];
  dceq[8406] = -in3[53];
  dceq[8407] = -in3[61];
  dceq[8408] = -in4[5];
  dceq[8409] = -in4[13];
  dceq[8410] = 0.0;
  dceq[8411] = 0.0;
  dceq[8412] = 0.0;
  dceq[8413] = 0.0;
  dceq[8414] = 0.0;
  dceq[8415] = 0.0;
  dceq[8416] = 0.0;
  dceq[8417] = 1.0;
  memset(&dceq[8418], 0, 126U * sizeof(real_T));
  dceq[8544] = -in3[5];
  dceq[8545] = -in3[13];
  dceq[8546] = -in3[21];
  dceq[8547] = -in3[29];
  dceq[8548] = -in3[37];
  dceq[8549] = -in3[45];
  dceq[8550] = -in3[53];
  dceq[8551] = -in3[61];
  dceq[8552] = -in4[5];
  dceq[8553] = -in4[13];
  dceq[8554] = 0.0;
  dceq[8555] = 0.0;
  dceq[8556] = 0.0;
  dceq[8557] = 0.0;
  dceq[8558] = 0.0;
  dceq[8559] = 0.0;
  dceq[8560] = 0.0;
  dceq[8561] = 1.0;
  memset(&dceq[8562], 0, 126U * sizeof(real_T));
  dceq[8688] = -in3[5];
  dceq[8689] = -in3[13];
  dceq[8690] = -in3[21];
  dceq[8691] = -in3[29];
  dceq[8692] = -in3[37];
  dceq[8693] = -in3[45];
  dceq[8694] = -in3[53];
  dceq[8695] = -in3[61];
  dceq[8696] = -in4[5];
  dceq[8697] = -in4[13];
  dceq[8698] = 0.0;
  dceq[8699] = 0.0;
  dceq[8700] = 0.0;
  dceq[8701] = 0.0;
  dceq[8702] = 0.0;
  dceq[8703] = 0.0;
  dceq[8704] = 0.0;
  dceq[8705] = 1.0;
  memset(&dceq[8706], 0, 12U * sizeof(real_T));
  dceq[8718] = 1.0;
  memset(&dceq[8719], 0, 125U * sizeof(real_T));
  dceq[8844] = -in3[6];
  dceq[8845] = -in3[14];
  dceq[8846] = -in3[22];
  dceq[8847] = -in3[30];
  dceq[8848] = -in3[38];
  dceq[8849] = -in3[46];
  dceq[8850] = -in3[54];
  dceq[8851] = -in3[62];
  dceq[8852] = -in4[6];
  dceq[8853] = -in4[14];
  memset(&dceq[8854], 0, 8U * sizeof(real_T));
  dceq[8862] = 1.0;
  memset(&dceq[8863], 0, 125U * sizeof(real_T));
  dceq[8988] = -in3[6];
  dceq[8989] = -in3[14];
  dceq[8990] = -in3[22];
  dceq[8991] = -in3[30];
  dceq[8992] = -in3[38];
  dceq[8993] = -in3[46];
  dceq[8994] = -in3[54];
  dceq[8995] = -in3[62];
  dceq[8996] = -in4[6];
  dceq[8997] = -in4[14];
  memset(&dceq[8998], 0, 8U * sizeof(real_T));
  dceq[9006] = 1.0;
  memset(&dceq[9007], 0, 125U * sizeof(real_T));
  dceq[9132] = -in3[6];
  dceq[9133] = -in3[14];
  dceq[9134] = -in3[22];
  dceq[9135] = -in3[30];
  dceq[9136] = -in3[38];
  dceq[9137] = -in3[46];
  dceq[9138] = -in3[54];
  dceq[9139] = -in3[62];
  dceq[9140] = -in4[6];
  dceq[9141] = -in4[14];
  memset(&dceq[9142], 0, 8U * sizeof(real_T));
  dceq[9150] = 1.0;
  memset(&dceq[9151], 0, 125U * sizeof(real_T));
  dceq[9276] = -in3[6];
  dceq[9277] = -in3[14];
  dceq[9278] = -in3[22];
  dceq[9279] = -in3[30];
  dceq[9280] = -in3[38];
  dceq[9281] = -in3[46];
  dceq[9282] = -in3[54];
  dceq[9283] = -in3[62];
  dceq[9284] = -in4[6];
  dceq[9285] = -in4[14];
  memset(&dceq[9286], 0, 8U * sizeof(real_T));
  dceq[9294] = 1.0;
  memset(&dceq[9295], 0, 125U * sizeof(real_T));
  dceq[9420] = -in3[6];
  dceq[9421] = -in3[14];
  dceq[9422] = -in3[22];
  dceq[9423] = -in3[30];
  dceq[9424] = -in3[38];
  dceq[9425] = -in3[46];
  dceq[9426] = -in3[54];
  dceq[9427] = -in3[62];
  dceq[9428] = -in4[6];
  dceq[9429] = -in4[14];
  memset(&dceq[9430], 0, 8U * sizeof(real_T));
  dceq[9438] = 1.0;
  memset(&dceq[9439], 0, 125U * sizeof(real_T));
  dceq[9564] = -in3[6];
  dceq[9565] = -in3[14];
  dceq[9566] = -in3[22];
  dceq[9567] = -in3[30];
  dceq[9568] = -in3[38];
  dceq[9569] = -in3[46];
  dceq[9570] = -in3[54];
  dceq[9571] = -in3[62];
  dceq[9572] = -in4[6];
  dceq[9573] = -in4[14];
  memset(&dceq[9574], 0, 8U * sizeof(real_T));
  dceq[9582] = 1.0;
  memset(&dceq[9583], 0, 125U * sizeof(real_T));
  dceq[9708] = -in3[6];
  dceq[9709] = -in3[14];
  dceq[9710] = -in3[22];
  dceq[9711] = -in3[30];
  dceq[9712] = -in3[38];
  dceq[9713] = -in3[46];
  dceq[9714] = -in3[54];
  dceq[9715] = -in3[62];
  dceq[9716] = -in4[6];
  dceq[9717] = -in4[14];
  memset(&dceq[9718], 0, 8U * sizeof(real_T));
  dceq[9726] = 1.0;
  memset(&dceq[9727], 0, 125U * sizeof(real_T));
  dceq[9852] = -in3[6];
  dceq[9853] = -in3[14];
  dceq[9854] = -in3[22];
  dceq[9855] = -in3[30];
  dceq[9856] = -in3[38];
  dceq[9857] = -in3[46];
  dceq[9858] = -in3[54];
  dceq[9859] = -in3[62];
  dceq[9860] = -in4[6];
  dceq[9861] = -in4[14];
  memset(&dceq[9862], 0, 8U * sizeof(real_T));
  dceq[9870] = 1.0;
  memset(&dceq[9871], 0, 125U * sizeof(real_T));
  dceq[9996] = -in3[6];
  dceq[9997] = -in3[14];
  dceq[9998] = -in3[22];
  dceq[9999] = -in3[30];
  dceq[10000] = -in3[38];
  dceq[10001] = -in3[46];
  dceq[10002] = -in3[54];
  dceq[10003] = -in3[62];
  dceq[10004] = -in4[6];
  dceq[10005] = -in4[14];
  memset(&dceq[10006], 0, 8U * sizeof(real_T));
  dceq[10014] = 1.0;
  memset(&dceq[10015], 0, 125U * sizeof(real_T));
  dceq[10140] = -in3[6];
  dceq[10141] = -in3[14];
  dceq[10142] = -in3[22];
  dceq[10143] = -in3[30];
  dceq[10144] = -in3[38];
  dceq[10145] = -in3[46];
  dceq[10146] = -in3[54];
  dceq[10147] = -in3[62];
  dceq[10148] = -in4[6];
  dceq[10149] = -in4[14];
  memset(&dceq[10150], 0, 8U * sizeof(real_T));
  dceq[10158] = 1.0;
  memset(&dceq[10159], 0, 12U * sizeof(real_T));
  dceq[10171] = 1.0;
  memset(&dceq[10172], 0, 124U * sizeof(real_T));
  dceq[10296] = -in3[7];
  dceq[10297] = -in3[15];
  dceq[10298] = -in3[23];
  dceq[10299] = -in3[31];
  dceq[10300] = -in3[39];
  dceq[10301] = -in3[47];
  dceq[10302] = -in3[55];
  dceq[10303] = -in3[63];
  dceq[10304] = -in4[7];
  dceq[10305] = -in4[15];
  memset(&dceq[10306], 0, 9U * sizeof(real_T));
  dceq[10315] = 1.0;
  memset(&dceq[10316], 0, 124U * sizeof(real_T));
  dceq[10440] = -in3[7];
  dceq[10441] = -in3[15];
  dceq[10442] = -in3[23];
  dceq[10443] = -in3[31];
  dceq[10444] = -in3[39];
  dceq[10445] = -in3[47];
  dceq[10446] = -in3[55];
  dceq[10447] = -in3[63];
  dceq[10448] = -in4[7];
  dceq[10449] = -in4[15];
  memset(&dceq[10450], 0, 9U * sizeof(real_T));
  dceq[10459] = 1.0;
  memset(&dceq[10460], 0, 124U * sizeof(real_T));
  dceq[10584] = -in3[7];
  dceq[10585] = -in3[15];
  dceq[10586] = -in3[23];
  dceq[10587] = -in3[31];
  dceq[10588] = -in3[39];
  dceq[10589] = -in3[47];
  dceq[10590] = -in3[55];
  dceq[10591] = -in3[63];
  dceq[10592] = -in4[7];
  dceq[10593] = -in4[15];
  memset(&dceq[10594], 0, 9U * sizeof(real_T));
  dceq[10603] = 1.0;
  memset(&dceq[10604], 0, 124U * sizeof(real_T));
  dceq[10728] = -in3[7];
  dceq[10729] = -in3[15];
  dceq[10730] = -in3[23];
  dceq[10731] = -in3[31];
  dceq[10732] = -in3[39];
  dceq[10733] = -in3[47];
  dceq[10734] = -in3[55];
  dceq[10735] = -in3[63];
  dceq[10736] = -in4[7];
  dceq[10737] = -in4[15];
  memset(&dceq[10738], 0, 9U * sizeof(real_T));
  dceq[10747] = 1.0;
  memset(&dceq[10748], 0, 124U * sizeof(real_T));
  dceq[10872] = -in3[7];
  dceq[10873] = -in3[15];
  dceq[10874] = -in3[23];
  dceq[10875] = -in3[31];
  dceq[10876] = -in3[39];
  dceq[10877] = -in3[47];
  dceq[10878] = -in3[55];
  dceq[10879] = -in3[63];
  dceq[10880] = -in4[7];
  dceq[10881] = -in4[15];
  memset(&dceq[10882], 0, 9U * sizeof(real_T));
  dceq[10891] = 1.0;
  memset(&dceq[10892], 0, 124U * sizeof(real_T));
  dceq[11016] = -in3[7];
  dceq[11017] = -in3[15];
  dceq[11018] = -in3[23];
  dceq[11019] = -in3[31];
  dceq[11020] = -in3[39];
  dceq[11021] = -in3[47];
  dceq[11022] = -in3[55];
  dceq[11023] = -in3[63];
  dceq[11024] = -in4[7];
  dceq[11025] = -in4[15];
  memset(&dceq[11026], 0, 9U * sizeof(real_T));
  dceq[11035] = 1.0;
  memset(&dceq[11036], 0, 124U * sizeof(real_T));
  dceq[11160] = -in3[7];
  dceq[11161] = -in3[15];
  dceq[11162] = -in3[23];
  dceq[11163] = -in3[31];
  dceq[11164] = -in3[39];
  dceq[11165] = -in3[47];
  dceq[11166] = -in3[55];
  dceq[11167] = -in3[63];
  dceq[11168] = -in4[7];
  dceq[11169] = -in4[15];
  memset(&dceq[11170], 0, 9U * sizeof(real_T));
  dceq[11179] = 1.0;
  memset(&dceq[11180], 0, 124U * sizeof(real_T));
  dceq[11304] = -in3[7];
  dceq[11305] = -in3[15];
  dceq[11306] = -in3[23];
  dceq[11307] = -in3[31];
  dceq[11308] = -in3[39];
  dceq[11309] = -in3[47];
  dceq[11310] = -in3[55];
  dceq[11311] = -in3[63];
  dceq[11312] = -in4[7];
  dceq[11313] = -in4[15];
  memset(&dceq[11314], 0, 9U * sizeof(real_T));
  dceq[11323] = 1.0;
  memset(&dceq[11324], 0, 124U * sizeof(real_T));
  dceq[11448] = -in3[7];
  dceq[11449] = -in3[15];
  dceq[11450] = -in3[23];
  dceq[11451] = -in3[31];
  dceq[11452] = -in3[39];
  dceq[11453] = -in3[47];
  dceq[11454] = -in3[55];
  dceq[11455] = -in3[63];
  dceq[11456] = -in4[7];
  dceq[11457] = -in4[15];
  memset(&dceq[11458], 0, 9U * sizeof(real_T));
  dceq[11467] = 1.0;
  memset(&dceq[11468], 0, 124U * sizeof(real_T));
  dceq[11592] = -in3[7];
  dceq[11593] = -in3[15];
  dceq[11594] = -in3[23];
  dceq[11595] = -in3[31];
  dceq[11596] = -in3[39];
  dceq[11597] = -in3[47];
  dceq[11598] = -in3[55];
  dceq[11599] = -in3[63];
  dceq[11600] = -in4[7];
  dceq[11601] = -in4[15];
  memset(&dceq[11602], 0, 9U * sizeof(real_T));
  dceq[11611] = 1.0;
  dceq[11612] = 0.0;
  dceq[11613] = 0.0;
  dceq[11614] = 0.0;
  dceq[11615] = 0.0;
}

/* End of code generation (autoCons.c) */
