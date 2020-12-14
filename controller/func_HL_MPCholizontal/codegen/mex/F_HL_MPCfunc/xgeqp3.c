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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo sf_emlrtRSI = { 57, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo tf_emlrtRSI = { 152,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo uf_emlrtRSI = { 148,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo vf_emlrtRSI = { 142,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo wf_emlrtRSI = { 137,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo xf_emlrtRSI = { 135,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo yf_emlrtRSI = { 132,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo ag_emlrtRSI = { 123,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo bg_emlrtRSI = { 119,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo cg_emlrtRSI = { 91, /* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo dg_emlrtRSI = { 86, /* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo eg_emlrtRSI = { 85, /* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

/* Function Definitions */
void xgeqp3(const emlrtStack *sp, real_T A[380689], int32_T m, int32_T n,
            int32_T jpvt[617], real_T tau[617])
{
  int32_T i;
  ptrdiff_t jpvt_t[617];
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
  st.site = &sf_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &eg_emlrtRSI;
  b_st.site = &dg_emlrtRSI;
  if (n < 1) {
    memset(&tau[0], 0, 617U * sizeof(real_T));
    b_st.site = &cg_emlrtRSI;
    for (k = 0; k < n; k++) {
      jpvt[k] = k + 1;
    }
  } else {
    for (i = 0; i < 617; i++) {
      jpvt_t[i] = (ptrdiff_t)jpvt[i];
    }

    b_st.site = &bg_emlrtRSI;
    b_st.site = &ag_emlrtRSI;
    info_t = LAPACKE_dgeqp3(102, (ptrdiff_t)m, (ptrdiff_t)n, &A[0], (ptrdiff_t)
      617, &jpvt_t[0], &tau[0]);
    b_st.site = &yf_emlrtRSI;
    i = (int32_T)info_t;
    if (i != 0) {
      p = true;
      if (i != -4) {
        if (i == -1010) {
          emlrtErrorWithMessageIdR2018a(&b_st, &k_emlrtRTEI, "MATLAB:nomem",
            "MATLAB:nomem", 0);
        } else {
          emlrtErrorWithMessageIdR2018a(&b_st, &j_emlrtRTEI,
            "Coder:toolbox:LAPACKCallErrorInfo",
            "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, fname, 12, i);
        }
      }
    } else {
      p = false;
    }

    if (p) {
      b_st.site = &xf_emlrtRSI;
      if (n > 2147483646) {
        c_st.site = &t_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = 0; k < n; k++) {
        b_st.site = &wf_emlrtRSI;
        if ((1 <= m) && (m > 2147483646)) {
          c_st.site = &t_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (i = 0; i < m; i++) {
          A[k * 617 + i] = rtNaN;
        }
      }

      i = muIntScalarMin_sint32(m, n);
      b_st.site = &vf_emlrtRSI;
      for (k = 0; k < i; k++) {
        tau[k] = rtNaN;
      }

      i++;
      for (k = i; k < 618; k++) {
        tau[k - 1] = 0.0;
      }

      b_st.site = &uf_emlrtRSI;
      for (k = 0; k < n; k++) {
        jpvt[k] = k + 1;
      }
    } else {
      b_st.site = &tf_emlrtRSI;
      if (n > 2147483646) {
        c_st.site = &t_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = 0; k < n; k++) {
        jpvt[k] = (int32_T)jpvt_t[k];
      }
    }
  }
}

/* End of code generation (xgeqp3.c) */
