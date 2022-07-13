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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo nd_emlrtRSI = { 27, /* lineNo */
  "xgeqrf",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo od_emlrtRSI = { 102,/* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo pd_emlrtRSI = { 99, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo qd_emlrtRSI = { 94, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo rd_emlrtRSI = { 93, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRSInfo sd_emlrtRSI = { 91, /* lineNo */
  "ceval_xgeqrf",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pathName */
};

static emlrtRTEInfo sb_emlrtRTEI = { 73,/* lineNo */
  22,                                  /* colNo */
  "xgeqrf",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pName */
};

static emlrtRTEInfo tb_emlrtRTEI = { 75,/* lineNo */
  5,                                   /* colNo */
  "xgeqrf",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqrf.m"/* pName */
};

/* Function Definitions */
void xgeqrf(const emlrtStack *sp, emxArray_real_T *A, int32_T m, int32_T n,
            emxArray_real_T *tau)
{
  static const char_T fname[14] = { 'L', 'A', 'P', 'A', 'C', 'K', 'E', '_', 'd',
    'g', 'e', 'q', 'r', 'f' };

  ptrdiff_t info_t;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  int32_T i;
  int32_T ma;
  int32_T minmana;
  int32_T na;
  boolean_T p;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &nd_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  ma = A->size[0];
  na = A->size[1];
  minmana = muIntScalarMin_sint32(ma, na);
  na = tau->size[0];
  tau->size[0] = minmana;
  emxEnsureCapacity_real_T(&st, tau, na, &sb_emlrtRTEI);
  if (n == 0) {
    na = tau->size[0];
    tau->size[0] = minmana;
    emxEnsureCapacity_real_T(&st, tau, na, &tb_emlrtRTEI);
    for (na = 0; na < minmana; na++) {
      tau->data[na] = 0.0;
    }
  } else {
    info_t = LAPACKE_dgeqrf(102, (ptrdiff_t)m, (ptrdiff_t)n, &A->data[0],
      (ptrdiff_t)A->size[0], &tau->data[0]);
    na = (int32_T)info_t;
    b_st.site = &sd_emlrtRSI;
    if (na != 0) {
      p = true;
      if (na != -4) {
        if (na == -1010) {
          emlrtErrorWithMessageIdR2018a(&b_st, &p_emlrtRTEI, "MATLAB:nomem",
            "MATLAB:nomem", 0);
        } else {
          emlrtErrorWithMessageIdR2018a(&b_st, &o_emlrtRTEI,
            "Coder:toolbox:LAPACKCallErrorInfo",
            "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, fname, 12, na);
        }
      }
    } else {
      p = false;
    }

    if (p) {
      b_st.site = &rd_emlrtRSI;
      if ((1 <= n) && (n > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (na = 0; na < n; na++) {
        b_st.site = &qd_emlrtRSI;
        if ((1 <= m) && (m > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (i = 0; i < m; i++) {
          A->data[na * ma + i] = rtNaN;
        }
      }

      na = muIntScalarMin_sint32(m, n);
      b_st.site = &pd_emlrtRSI;
      for (i = 0; i < na; i++) {
        tau->data[i] = rtNaN;
      }

      ma = na + 1;
      b_st.site = &od_emlrtRSI;
      if ((na + 1 <= minmana) && (minmana > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (i = ma; i <= minmana; i++) {
        tau->data[i - 1] = 0.0;
      }
    }
  }
}

/* End of code generation (xgeqrf.c) */
