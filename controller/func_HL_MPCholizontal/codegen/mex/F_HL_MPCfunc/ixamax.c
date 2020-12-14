/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ixamax.c
 *
 * Code generation for function 'ixamax'
 *
 */

/* Include files */
#include "ixamax.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "blas.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo jf_emlrtRSI = { 23, /* lineNo */
  "ixamax",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\ixamax.m"/* pathName */
};

static emlrtRSInfo kf_emlrtRSI = { 24, /* lineNo */
  "ixamax",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\ixamax.m"/* pathName */
};

/* Function Definitions */
int32_T b_ixamax(int32_T n, const real_T x[617])
{
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  n_t = (ptrdiff_t)n;
  incx_t = (ptrdiff_t)1;
  n_t = idamax(&n_t, &x[0], &incx_t);
  return (int32_T)n_t;
}

int32_T ixamax(const emlrtStack *sp, int32_T n, const real_T x[485])
{
  int32_T idxmax;
  int32_T ix;
  real_T smax;
  int32_T k;
  real_T s;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &jf_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  if (n < 1) {
    idxmax = 0;
  } else {
    idxmax = 1;
    if (n > 1) {
      ix = 0;
      smax = muDoubleScalarAbs(x[0]);
      b_st.site = &kf_emlrtRSI;
      if (n > 2147483646) {
        c_st.site = &t_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (k = 2; k <= n; k++) {
        ix++;
        s = muDoubleScalarAbs(x[ix]);
        if (s > smax) {
          idxmax = k;
          smax = s;
        }
      }
    }
  }

  return idxmax;
}

/* End of code generation (ixamax.c) */
