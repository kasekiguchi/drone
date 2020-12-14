/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * pchip.c
 *
 * Code generation for function 'pchip'
 *
 */

/* Include files */
#include "pchip.h"
#include "F_HL_MPCfunc.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo qe_emlrtRSI = { 15, /* lineNo */
  "pchip",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\polyfun\\pchip.m"/* pathName */
};

static emlrtRTEInfo g_emlrtRTEI = { 37,/* lineNo */
  15,                                  /* colNo */
  "chckxy",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\polyfun\\private\\chckxy.m"/* pName */
};

static emlrtRTEInfo h_emlrtRTEI = { 39,/* lineNo */
  1,                                   /* colNo */
  "chckxy",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\polyfun\\private\\chckxy.m"/* pName */
};

/* Function Definitions */
real_T pchip(const emlrtStack *sp, const real_T x[19], const real_T y[19],
             real_T xx)
{
  real_T v;
  boolean_T p;
  int32_T low_i;
  boolean_T exitg1;
  real_T signd1;
  real_T h[18];
  real_T hs;
  real_T del[18];
  real_T hs3;
  real_T w1;
  real_T slopes[19];
  int32_T low_ip1;
  real_T pp_coefs[72];
  int32_T high_i;
  int32_T mid_i;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &qe_emlrtRSI;
  p = ((!muDoubleScalarIsInf(x[0])) && (!muDoubleScalarIsNaN(x[0])));
  if (p) {
    low_i = 0;
    exitg1 = false;
    while ((!exitg1) && (low_i < 18)) {
      if (!(x[low_i] < x[low_i + 1])) {
        p = false;
        exitg1 = true;
      } else {
        low_i++;
      }
    }
  }

  if ((!p) || muDoubleScalarIsInf(x[18])) {
    p = false;
  }

  if (!p) {
    emlrtErrorWithMessageIdR2018a(&st, &g_emlrtRTEI,
      "Coder:toolbox:MustBeFiniteAndStrictlyIncreasing",
      "Coder:toolbox:MustBeFiniteAndStrictlyIncreasing", 0);
  }

  p = false;
  low_i = 0;
  exitg1 = false;
  while ((!exitg1) && (low_i < 19)) {
    if (muDoubleScalarIsNaN(y[low_i])) {
      p = true;
      exitg1 = true;
    } else {
      low_i++;
    }
  }

  if (p) {
    emlrtErrorWithMessageIdR2018a(&st, &h_emlrtRTEI,
      "Coder:toolbox:UnsupportedNaN", "Coder:toolbox:UnsupportedNaN", 0);
  }

  for (low_i = 0; low_i < 18; low_i++) {
    signd1 = x[low_i + 1] - x[low_i];
    h[low_i] = signd1;
    del[low_i] = (y[low_i + 1] - y[low_i]) / signd1;
  }

  for (low_i = 0; low_i < 17; low_i++) {
    signd1 = h[low_i + 1];
    hs = h[low_i] + signd1;
    hs3 = 3.0 * hs;
    w1 = (h[low_i] + hs) / hs3;
    hs = (signd1 + hs) / hs3;
    slopes[low_i + 1] = 0.0;
    if (del[low_i] < 0.0) {
      signd1 = del[low_i + 1];
      if (signd1 <= del[low_i]) {
        slopes[low_i + 1] = del[low_i] / (w1 * (del[low_i] / signd1) + hs);
      } else {
        if (signd1 < 0.0) {
          slopes[low_i + 1] = signd1 / (w1 + hs * (signd1 / del[low_i]));
        }
      }
    } else {
      if (del[low_i] > 0.0) {
        signd1 = del[low_i + 1];
        if (signd1 >= del[low_i]) {
          slopes[low_i + 1] = del[low_i] / (w1 * (del[low_i] / del[low_i + 1]) +
            hs);
        } else {
          if (signd1 > 0.0) {
            slopes[low_i + 1] = del[low_i + 1] / (w1 + hs * (del[low_i + 1] /
              del[low_i]));
          }
        }
      }
    }
  }

  hs = ((2.0 * h[0] + h[1]) * del[0] - h[0] * del[1]) / (h[0] + h[1]);
  signd1 = muDoubleScalarSign(del[0]);
  if (muDoubleScalarSign(hs) != signd1) {
    hs = 0.0;
  } else {
    if ((signd1 != muDoubleScalarSign(del[1])) && (muDoubleScalarAbs(hs) >
         muDoubleScalarAbs(3.0 * del[0]))) {
      hs = 3.0 * del[0];
    }
  }

  slopes[0] = hs;
  hs = ((2.0 * h[17] + h[16]) * del[17] - h[17] * del[16]) / (h[17] + h[16]);
  signd1 = muDoubleScalarSign(del[17]);
  if (muDoubleScalarSign(hs) != signd1) {
    hs = 0.0;
  } else {
    if ((signd1 != muDoubleScalarSign(del[16])) && (muDoubleScalarAbs(hs) >
         muDoubleScalarAbs(3.0 * del[17]))) {
      hs = 3.0 * del[17];
    }
  }

  slopes[18] = hs;
  for (low_i = 0; low_i < 18; low_i++) {
    hs = (del[low_i] - slopes[low_i]) / h[low_i];
    signd1 = (slopes[low_i + 1] - del[low_i]) / h[low_i];
    pp_coefs[low_i] = (signd1 - hs) / h[low_i];
    pp_coefs[low_i + 18] = 2.0 * hs - signd1;
    pp_coefs[low_i + 36] = slopes[low_i];
    pp_coefs[low_i + 54] = y[low_i];
  }

  if (muDoubleScalarIsNaN(xx)) {
    v = xx;
  } else {
    low_i = 0;
    low_ip1 = 2;
    high_i = 19;
    while (high_i > low_ip1) {
      mid_i = ((low_i + high_i) + 1) >> 1;
      if (xx >= x[mid_i - 1]) {
        low_i = mid_i - 1;
        low_ip1 = mid_i + 1;
      } else {
        high_i = mid_i;
      }
    }

    hs = xx - x[low_i];
    v = hs * (hs * (hs * pp_coefs[low_i] + pp_coefs[low_i + 18]) +
              pp_coefs[low_i + 36]) + pp_coefs[low_i + 54];
  }

  return v;
}

/* End of code generation (pchip.c) */
