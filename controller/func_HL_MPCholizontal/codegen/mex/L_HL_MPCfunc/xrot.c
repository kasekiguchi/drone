/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xrot.c
 *
 * Code generation for function 'xrot'
 *
 */

/* Include files */
#include "xrot.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo me_emlrtRSI = { 32, /* lineNo */
  "xrot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xrot.m"/* pathName */
};

static emlrtRSInfo ne_emlrtRSI = { 24, /* lineNo */
  "xrot",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xrot.m"/* pathName */
};

/* Function Definitions */
void b_xrot(const emlrtStack *sp, int32_T n, real_T x[94249], int32_T ix0,
            int32_T iy0, real_T c, real_T s)
{
  int32_T ix;
  int32_T iy;
  int32_T k;
  real_T temp;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &me_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  if (n >= 1) {
    ix = ix0 - 1;
    iy = iy0 - 1;
    b_st.site = &ne_emlrtRSI;
    if (n > 2147483646) {
      c_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (k = 0; k < n; k++) {
      temp = c * x[ix] + s * x[iy];
      x[iy] = c * x[iy] - s * x[ix];
      x[ix] = temp;
      iy += 307;
      ix += 307;
    }
  }
}

void xrot(const emlrtStack *sp, int32_T n, real_T x[94249], int32_T ix0, int32_T
          iy0, real_T c, real_T s)
{
  int32_T ix;
  int32_T iy;
  int32_T k;
  real_T temp;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &me_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  if (n >= 1) {
    ix = ix0 - 1;
    iy = iy0 - 1;
    b_st.site = &ne_emlrtRSI;
    if (n > 2147483646) {
      c_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (k = 0; k < n; k++) {
      temp = c * x[ix] + s * x[iy];
      x[iy] = c * x[iy] - s * x[ix];
      x[ix] = temp;
      iy++;
      ix++;
    }
  }
}

/* End of code generation (xrot.c) */
