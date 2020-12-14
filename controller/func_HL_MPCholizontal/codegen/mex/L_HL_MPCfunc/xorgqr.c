/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xorgqr.c
 *
 * Code generation for function 'xorgqr'
 *
 */

/* Include files */
#include "xorgqr.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "lapacke.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo dc_emlrtRSI = { 59, /* lineNo */
  "ceval_xorgqr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

static emlrtRSInfo hc_emlrtRSI = { 14, /* lineNo */
  "xorgqr",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

/* Function Definitions */
void xorgqr(const emlrtStack *sp, int32_T m, int32_T n, int32_T k, real_T A
            [94249], const real_T tau[307])
{
  ptrdiff_t info_t;
  int32_T info;
  boolean_T p;
  boolean_T b_p;
  static const char_T fname[14] = { 'L', 'A', 'P', 'A', 'C', 'K', 'E', '_', 'd',
    'o', 'r', 'g', 'q', 'r' };

  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &hc_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  info_t = LAPACKE_dorgqr(102, (ptrdiff_t)m, (ptrdiff_t)n, (ptrdiff_t)k, &A[0],
    (ptrdiff_t)307, &tau[0]);
  info = (int32_T)info_t;
  b_st.site = &dc_emlrtRSI;
  if (info != 0) {
    p = true;
    b_p = false;
    if (info == -7) {
      b_p = true;
    } else {
      if (info == -5) {
        b_p = true;
      }
    }

    if (!b_p) {
      if (info == -1010) {
        emlrtErrorWithMessageIdR2018a(&b_st, &e_emlrtRTEI, "MATLAB:nomem",
          "MATLAB:nomem", 0);
      } else {
        emlrtErrorWithMessageIdR2018a(&b_st, &d_emlrtRTEI,
          "Coder:toolbox:LAPACKCallErrorInfo",
          "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, fname, 12, info);
      }
    }
  } else {
    p = false;
  }

  if (p) {
    for (info = 0; info < 94249; info++) {
      A[info] = rtNaN;
    }
  }
}

/* End of code generation (xorgqr.c) */
