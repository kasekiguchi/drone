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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>
#include <string.h>

/* Function Definitions */
void b_xcopy(int32_T n, const emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  if (n >= 1) {
    n_t = (ptrdiff_t)n;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dcopy(&n_t, &x->data[0], &incx_t, &y->data[0], &incy_t);
  }
}

void c_xcopy(const emlrtStack *sp, int32_T n, emxArray_real_T *y)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  int32_T k;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &xb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &gb_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < n; k++) {
    y->data[k] = 0.0;
  }
}

void d_xcopy(const emlrtStack *sp, int32_T n, const real_T x[66],
             emxArray_real_T *y)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  int32_T k;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &xb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &gb_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < n; k++) {
    y->data[k] = x[k];
  }
}

void e_xcopy(int32_T n, const emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  n_t = (ptrdiff_t)n;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dcopy(&n_t, &x->data[0], &incx_t, &y->data[0], &incy_t);
}

void f_xcopy(const emlrtStack *sp, int32_T n, real_T y[4356], int32_T iy0)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &xb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &gb_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memset(&y[iy0 + -1], 0, ((n + iy0) - iy0) * sizeof(real_T));
  }
}

void xcopy(int32_T n, const emxArray_real_T *x, int32_T ix0, emxArray_real_T *y,
           int32_T iy0)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  if (n >= 1) {
    n_t = (ptrdiff_t)n;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dcopy(&n_t, &x->data[ix0 - 1], &incx_t, &y->data[iy0 - 1], &incy_t);
  }
}

/* End of code generation (xcopy.c) */
