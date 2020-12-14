/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xdot.c
 *
 * Code generation for function 'xdot'
 *
 */

/* Include files */
#include "xdot.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "blas.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo ui_emlrtRSI = { 32, /* lineNo */
  "xdotx",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xdotx.m"/* pathName */
};

/* Function Definitions */
real_T b_xdot(const emlrtStack *sp, int32_T n, const real_T x[485], const real_T
              y[299245])
{
  real_T d;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ti_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  b_st.site = &hh_emlrtRSI;
  d = 0.0;
  if (n >= 1) {
    c_st.site = &ui_emlrtRSI;
    if (n > 2147483646) {
      d_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 0; k < n; k++) {
      d += x[k] * y[k];
    }
  }

  return d;
}

real_T c_xdot(const emlrtStack *sp, int32_T n, const real_T x[485], const real_T
              y[484])
{
  real_T d;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ti_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  b_st.site = &hh_emlrtRSI;
  d = 0.0;
  if (n >= 1) {
    c_st.site = &ui_emlrtRSI;
    if (n > 2147483646) {
      d_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 0; k < n; k++) {
      d += x[k] * y[k];
    }
  }

  return d;
}

real_T d_xdot(const emlrtStack *sp, int32_T n, const real_T x[485], const real_T
              y[485])
{
  real_T d;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ti_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  b_st.site = &hh_emlrtRSI;
  d = 0.0;
  c_st.site = &ui_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    d_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  for (k = 0; k < n; k++) {
    d += x[k] * y[k];
  }

  return d;
}

real_T xdot(int32_T n, const real_T x[380689], int32_T ix0, const real_T y[617])
{
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  n_t = (ptrdiff_t)n;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  return ddot(&n_t, &x[ix0 - 1], &incx_t, &y[0], &incy_t);
}

/* End of code generation (xdot.c) */
