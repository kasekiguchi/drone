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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
void b_xcopy(const emlrtStack *sp, int32_T n, const real_T x[305], real_T y[305])
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &j_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memcpy(&y[0], &x[0], n * sizeof(real_T));
  }
}

void c_xcopy(const emlrtStack *sp, int32_T n, real_T y[305])
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &j_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memset(&y[0], 0, n * sizeof(real_T));
  }
}

void d_xcopy(const emlrtStack *sp, int32_T n, const real_T x[93635], int32_T ix0,
             real_T y[94249], int32_T iy0)
{
  int32_T k;
  int32_T b_k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &j_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < n; k++) {
    b_k = k - 1;
    y[iy0 + b_k] = x[ix0 + b_k];
  }
}

void e_xcopy(const emlrtStack *sp, int32_T n, const real_T x[110], real_T y[307])
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &j_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memcpy(&y[0], &x[0], n * sizeof(real_T));
  }
}

void f_xcopy(const emlrtStack *sp, int32_T n, const real_T x[307], real_T y[307])
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &j_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memcpy(&y[0], &x[0], n * sizeof(real_T));
  }
}

void g_xcopy(const emlrtStack *sp, int32_T n, real_T y[12100], int32_T iy0)
{
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &j_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  if (0 <= n - 1) {
    memset(&y[iy0 + -1], 0, ((n + iy0) - iy0) * sizeof(real_T));
  }
}

void xcopy(const emlrtStack *sp, int32_T n, const real_T x[6140], int32_T ix0,
           real_T y[93635], int32_T iy0)
{
  int32_T k;
  int32_T b_k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  b_st.site = &j_emlrtRSI;
  if ((1 <= n) && (n > 2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < n; k++) {
    b_k = k - 1;
    y[iy0 + b_k] = x[ix0 + b_k];
  }
}

/* End of code generation (xcopy.c) */
