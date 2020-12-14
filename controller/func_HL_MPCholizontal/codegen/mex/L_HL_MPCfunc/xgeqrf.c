/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgeqrf.c
 *
 * Code generation for function 'xgeqrf'
 *
 */

/* Include files */
#include "xgeqrf.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo bd_emlrtRSI = { 27, /* lineNo */
  "xgeqrf",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo cd_emlrtRSI = { 99, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo dd_emlrtRSI = { 94, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo ed_emlrtRSI = { 93, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo fd_emlrtRSI = { 91, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo gd_emlrtRSI = { 84, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo hd_emlrtRSI = { 79, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo id_emlrtRSI = { 53, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo jd_emlrtRSI = { 52, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

/* Function Definitions */
void xgeqrf(const emlrtStack *sp, real_T A[94249], int32_T m, int32_T n, real_T
            tau[307])
{
  ptrdiff_t info_t;
  int32_T minmn;
  boolean_T p;
  static const char_T fname[14] = { 'L', 'A', 'P', 'A', 'C', 'K', 'E', '_', 'd',
    'g', 'e', 'q', 'r', 'f' };

  int32_T i;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &bd_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &jd_emlrtRSI;
  b_st.site = &id_emlrtRSI;
  if (n == 0) {
    memset(&tau[0], 0, 307U * sizeof(real_T));
  } else {
    b_st.site = &hd_emlrtRSI;
    b_st.site = &gd_emlrtRSI;
    info_t = LAPACKE_dgeqrf(102, (ptrdiff_t)m, (ptrdiff_t)n, &A[0], (ptrdiff_t)
      307, &tau[0]);
    b_st.site = &fd_emlrtRSI;
    minmn = (int32_T)info_t;
    if (minmn != 0) {
      p = true;
      if (minmn != -4) {
        if (minmn == -1010) {
          emlrtErrorWithMessageIdR2018a(&b_st, &e_emlrtRTEI, "MATLAB:nomem",
            "MATLAB:nomem", 0);
        } else {
          emlrtErrorWithMessageIdR2018a(&b_st, &d_emlrtRTEI,
            "Coder:toolbox:LAPACKCallErrorInfo",
            "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, fname, 12, minmn);
        }
      }
    } else {
      p = false;
    }

    if (p) {
      b_st.site = &ed_emlrtRSI;
      if ((1 <= n) && (n > 2147483646)) {
        c_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (minmn = 0; minmn < n; minmn++) {
        b_st.site = &dd_emlrtRSI;
        if ((1 <= m) && (m > 2147483646)) {
          c_st.site = &e_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (i = 0; i < m; i++) {
          A[minmn * 307 + i] = rtNaN;
        }
      }

      minmn = muIntScalarMin_sint32(m, n);
      b_st.site = &cd_emlrtRSI;
      for (i = 0; i < minmn; i++) {
        tau[i] = rtNaN;
      }

      minmn++;
      for (i = minmn; i < 308; i++) {
        tau[i - 1] = 0.0;
      }
    }
  }
}

/* End of code generation (xgeqrf.c) */
