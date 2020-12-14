/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xcopy.c
 *
 * Code generation for function 'xcopy'
 *
 */

/* Include files */
#include "xcopy.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "blas.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
void b_xcopy(int32_T n, const real_T x[617], real_T y[617])
{
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  n_t = (ptrdiff_t)n;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dcopy(&n_t, &x[0], &incx_t, &y[0], &incy_t);
}

void c_xcopy(const emlrtStack *sp, int32_T n, real_T y[617])
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &xe_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &ye_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memset(&y[0], 0, n * sizeof(real_T));
  }
}

void d_xcopy(int32_T n, const real_T x[299245], int32_T ix0, real_T y[380689],
             int32_T iy0)
{
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  n_t = (ptrdiff_t)n;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dcopy(&n_t, &x[ix0 - 1], &incx_t, &y[iy0 - 1], &incy_t);
}

void e_xcopy(int32_T n, const real_T x[380689], int32_T ix0, real_T y[380689],
             int32_T iy0)
{
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  if (n >= 1) {
    n_t = (ptrdiff_t)n;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dcopy(&n_t, &x[ix0 - 1], &incx_t, &y[iy0 - 1], &incy_t);
  }
}

void f_xcopy(const emlrtStack *sp, int32_T n, const real_T x[132], real_T y[485])
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &xe_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &ye_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memcpy(&y[0], &x[0], n * sizeof(real_T));
  }
}

void g_xcopy(const emlrtStack *sp, int32_T n, const real_T x[485], real_T y[485])
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &xe_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &ye_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memcpy(&y[0], &x[0], n * sizeof(real_T));
  }
}

void h_xcopy(const emlrtStack *sp, int32_T n, real_T y[17424], int32_T iy0)
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &xe_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &ye_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memset(&y[iy0 + -1], 0, ((n + iy0) - iy0) * sizeof(real_T));
  }
}

void xcopy(const emlrtStack *sp, int32_T n, const real_T x[85360], int32_T ix0,
           real_T y[299245], int32_T iy0)
{
  int32_T k;
  int32_T b_k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &xe_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &ye_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < n; k++) {
    b_k = k - 1;
    y[iy0 + b_k] = x[ix0 + b_k];
  }
}

/* End of code generation (xcopy.c) */
