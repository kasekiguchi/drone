/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgeqp3.c
 *
 * Code generation for function 'xgeqp3'
 *
 */

/* Include files */
#include "xgeqp3.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo bb_emlrtRSI = { 57, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo cb_emlrtRSI = { 152,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo db_emlrtRSI = { 148,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo eb_emlrtRSI = { 142,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo fb_emlrtRSI = { 137,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo gb_emlrtRSI = { 135,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo hb_emlrtRSI = { 132,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo ib_emlrtRSI = { 123,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo jb_emlrtRSI = { 119,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo kb_emlrtRSI = { 91, /* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo lb_emlrtRSI = { 86, /* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo mb_emlrtRSI = { 85, /* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

/* Function Definitions */
void xgeqp3(const emlrtStack *sp, real_T A[94249], int32_T m, int32_T n, int32_T
            jpvt[307], real_T tau[307])
{
  int32_T i;
  ptrdiff_t jpvt_t[307];
  int32_T k;
  ptrdiff_t info_t;
  boolean_T p;
  static const char_T fname[14] = { 'L', 'A', 'P', 'A', 'C', 'K', 'E', '_', 'd',
    'g', 'e', 'q', 'p', '3' };

  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &bb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &mb_emlrtRSI;
  b_st.site = &lb_emlrtRSI;
  if (n < 1) {
    memset(&tau[0], 0, 307U * sizeof(real_T));
    b_st.site = &kb_emlrtRSI;
    for (k = 0; k < n; k++) {
      jpvt[k] = k + 1;
    }
  } else {
    for (i = 0; i < 307; i++) {
      jpvt_t[i] = (ptrdiff_t)jpvt[i];
    }

    b_st.site = &jb_emlrtRSI;
    b_st.site = &ib_emlrtRSI;
    info_t = LAPACKE_dgeqp3(102, (ptrdiff_t)m, (ptrdiff_t)n, &A[0], (ptrdiff_t)
      307, &jpvt_t[0], &tau[0]);
    b_st.site = &hb_emlrtRSI;
    i = (int32_T)info_t;
    if (i != 0) {
      p = true;
      if (i != -4) {
        if (i == -1010) {
          emlrtErrorWithMessageIdR2018a(&b_st, &e_emlrtRTEI, "MATLAB:nomem",
            "MATLAB:nomem", 0);
        } else {
          emlrtErrorWithMessageIdR2018a(&b_st, &d_emlrtRTEI,
            "Coder:toolbox:LAPACKCallErrorInfo",
            "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, fname, 12, i);
        }
      }
    } else {
      p = false;
    }

    if (p) {
      b_st.site = &gb_emlrtRSI;
      if (n > 2147483646) {
        c_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = 0; k < n; k++) {
        b_st.site = &fb_emlrtRSI;
        if ((1 <= m) && (m > 2147483646)) {
          c_st.site = &e_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (i = 0; i < m; i++) {
          A[k * 307 + i] = rtNaN;
        }
      }

      i = muIntScalarMin_sint32(m, n);
      b_st.site = &eb_emlrtRSI;
      for (k = 0; k < i; k++) {
        tau[k] = rtNaN;
      }

      i++;
      for (k = i; k < 308; k++) {
        tau[k - 1] = 0.0;
      }

      b_st.site = &db_emlrtRSI;
      for (k = 0; k < n; k++) {
        jpvt[k] = k + 1;
      }
    } else {
      b_st.site = &cb_emlrtRSI;
      if (n > 2147483646) {
        c_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = 0; k < n; k++) {
        jpvt[k] = (int32_T)jpvt_t[k];
      }
    }
  }
}

/* End of code generation (xgeqp3.c) */
