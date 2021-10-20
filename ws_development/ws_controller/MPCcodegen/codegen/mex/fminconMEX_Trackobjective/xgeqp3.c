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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "lapacke.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo bc_emlrtRSI = { 63, /* lineNo */
  "xgeqp3",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo cc_emlrtRSI = { 158,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo dc_emlrtRSI = { 154,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo ec_emlrtRSI = { 151,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo fc_emlrtRSI = { 148,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo gc_emlrtRSI = { 143,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo hc_emlrtRSI = { 141,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo ic_emlrtRSI = { 138,/* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRSInfo jc_emlrtRSI = { 98, /* lineNo */
  "ceval_xgeqp3",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pathName */
};

static emlrtRTEInfo nb_emlrtRTEI = { 92,/* lineNo */
  22,                                  /* colNo */
  "xgeqp3",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pName */
};

static emlrtRTEInfo ob_emlrtRTEI = { 105,/* lineNo */
  1,                                   /* colNo */
  "xgeqp3",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pName */
};

static emlrtRTEInfo pb_emlrtRTEI = { 97,/* lineNo */
  5,                                   /* colNo */
  "xgeqp3",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xgeqp3.m"/* pName */
};

/* Function Definitions */
void xgeqp3(const emlrtStack *sp, emxArray_real_T *A, int32_T m, int32_T n,
            emxArray_int32_T *jpvt, emxArray_real_T *tau)
{
  static const char_T fname[14] = { 'L', 'A', 'P', 'A', 'C', 'K', 'E', '_', 'd',
    'g', 'e', 'q', 'p', '3' };

  ptrdiff_t info_t;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  emxArray_ptrdiff_t *jpvt_t;
  int32_T k;
  int32_T ma;
  int32_T minmana;
  int32_T na;
  boolean_T p;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &bc_emlrtRSI;
  ma = A->size[0];
  na = A->size[1];
  minmana = muIntScalarMin_sint32(ma, na);
  k = tau->size[0];
  tau->size[0] = minmana;
  emxEnsureCapacity_real_T(&st, tau, k, &nb_emlrtRTEI);
  if (n < 1) {
    k = tau->size[0];
    tau->size[0] = minmana;
    emxEnsureCapacity_real_T(&st, tau, k, &pb_emlrtRTEI);
    for (k = 0; k < minmana; k++) {
      tau->data[k] = 0.0;
    }

    b_st.site = &jc_emlrtRSI;
    for (k = 0; k < n; k++) {
      jpvt->data[k] = k + 1;
    }
  } else {
    emxInit_ptrdiff_t(&st, &jpvt_t, 1, &ob_emlrtRTEI, true);
    k = jpvt_t->size[0];
    jpvt_t->size[0] = jpvt->size[0];
    emxEnsureCapacity_ptrdiff_t(&st, jpvt_t, k, &ob_emlrtRTEI);
    na = jpvt->size[0];
    for (k = 0; k < na; k++) {
      jpvt_t->data[k] = (ptrdiff_t)jpvt->data[k];
    }

    info_t = LAPACKE_dgeqp3(102, (ptrdiff_t)m, (ptrdiff_t)n, &A->data[0],
      (ptrdiff_t)A->size[0], &jpvt_t->data[0], &tau->data[0]);
    na = (int32_T)info_t;
    b_st.site = &ic_emlrtRSI;
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
      b_st.site = &hc_emlrtRSI;
      if (n > 2147483646) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (na = 0; na < n; na++) {
        b_st.site = &gc_emlrtRSI;
        if ((1 <= m) && (m > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (k = 0; k < m; k++) {
          A->data[na * ma + k] = rtNaN;
        }
      }

      na = muIntScalarMin_sint32(m, n);
      b_st.site = &fc_emlrtRSI;
      for (k = 0; k < na; k++) {
        tau->data[k] = rtNaN;
      }

      ma = na + 1;
      b_st.site = &ec_emlrtRSI;
      if ((na + 1 <= minmana) && (minmana > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = ma; k <= minmana; k++) {
        tau->data[k - 1] = 0.0;
      }

      b_st.site = &dc_emlrtRSI;
      for (k = 0; k < n; k++) {
        jpvt->data[k] = k + 1;
      }
    } else {
      b_st.site = &cc_emlrtRSI;
      if (n > 2147483646) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = 0; k < n; k++) {
        jpvt->data[k] = (int32_T)jpvt_t->data[k];
      }
    }

    emxFree_ptrdiff_t(&jpvt_t);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (xgeqp3.c) */
