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
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "lapacke.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo qc_emlrtRSI = { 60, /* lineNo */
  "ceval_xorgqr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

static emlrtRSInfo rc_emlrtRSI = { 14, /* lineNo */
  "xorgqr",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pathName */
};

static emlrtRTEInfo qb_emlrtRTEI = { 14,/* lineNo */
  5,                                   /* colNo */
  "xorgqr",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+lapack\\xorgqr.m"/* pName */
};

/* Function Definitions */
void xorgqr(const emlrtStack *sp, int32_T m, int32_T n, int32_T k,
            emxArray_real_T *A, int32_T lda, const emxArray_real_T *tau)
{
  static const char_T fname[14] = { 'L', 'A', 'P', 'A', 'C', 'K', 'E', '_', 'd',
    'o', 'r', 'g', 'q', 'r' };

  ptrdiff_t info_t;
  emlrtStack b_st;
  emlrtStack st;
  int32_T A_idx_1;
  int32_T i;
  int32_T i1;
  int32_T info;
  boolean_T b_p;
  boolean_T p;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &rc_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  info_t = LAPACKE_dorgqr(102, (ptrdiff_t)m, (ptrdiff_t)n, (ptrdiff_t)k,
    &A->data[0], (ptrdiff_t)lda, &tau->data[0]);
  info = (int32_T)info_t;
  b_st.site = &qc_emlrtRSI;
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
        emlrtErrorWithMessageIdR2018a(&b_st, &p_emlrtRTEI, "MATLAB:nomem",
          "MATLAB:nomem", 0);
      } else {
        emlrtErrorWithMessageIdR2018a(&b_st, &o_emlrtRTEI,
          "Coder:toolbox:LAPACKCallErrorInfo",
          "Coder:toolbox:LAPACKCallErrorInfo", 5, 4, 14, fname, 12, info);
      }
    }
  } else {
    p = false;
  }

  if (p) {
    info = A->size[0];
    A_idx_1 = A->size[1];
    i = A->size[0] * A->size[1];
    A->size[0] = info;
    A->size[1] = A_idx_1;
    emxEnsureCapacity_real_T(&st, A, i, &qb_emlrtRTEI);
    for (i = 0; i < A_idx_1; i++) {
      for (i1 = 0; i1 < info; i1++) {
        A->data[i1 + A->size[0] * i] = rtNaN;
      }
    }
  }
}

/* End of code generation (xorgqr.c) */
