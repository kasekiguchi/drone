/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BFGSUpdate.c
 *
 * Code generation for function 'BFGSUpdate'
 *
 */

/* Include files */
#include "BFGSUpdate.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "blas.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include "xdot.h"

/* Variable Definitions */
static emlrtRSInfo hf_emlrtRSI = { 87, /* lineNo */
  "xgemv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemv.m"/* pathName */
};

static emlrtRSInfo if_emlrtRSI = { 86, /* lineNo */
  "xgemv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemv.m"/* pathName */
};

static emlrtRSInfo mg_emlrtRSI = { 62, /* lineNo */
  "xger",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xger.m"/* pathName */
};

static emlrtRSInfo ng_emlrtRSI = { 63, /* lineNo */
  "xger",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xger.m"/* pathName */
};

static emlrtRSInfo fi_emlrtRSI = { 61, /* lineNo */
  "xaxpy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xaxpy.m"/* pathName */
};

static emlrtRSInfo gi_emlrtRSI = { 60, /* lineNo */
  "xaxpy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xaxpy.m"/* pathName */
};

static emlrtRSInfo uk_emlrtRSI = { 1,  /* lineNo */
  "BFGSUpdate",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\BFGSUpdate.p"/* pathName */
};

/* Function Definitions */
boolean_T BFGSUpdate(const emlrtStack *sp, int32_T nvar, real_T Bk[17424], const
                     real_T sk[485], real_T yk[485], real_T workspace[299245])
{
  boolean_T success;
  real_T dotSY;
  real_T theta;
  real_T curvatureS;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &uk_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  dotSY = d_xdot(&st, nvar, sk, yk);
  st.site = &uk_emlrtRSI;
  b_st.site = &if_emlrtRSI;
  b_st.site = &hf_emlrtRSI;
  theta = 1.0;
  curvatureS = 0.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nvar;
  n_t = (ptrdiff_t)nvar;
  lda_t = (ptrdiff_t)132;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &theta, &Bk[0], &lda_t, &sk[0], &incx_t,
        &curvatureS, &workspace[0], &incy_t);
  st.site = &uk_emlrtRSI;
  curvatureS = b_xdot(&st, nvar, sk, workspace);
  if (dotSY < 0.2 * curvatureS) {
    theta = 0.8 * curvatureS / (curvatureS - dotSY);
    st.site = &uk_emlrtRSI;
    b_st.site = &kg_emlrtRSI;
    c_st.site = &lg_emlrtRSI;
    if ((1 <= nvar) && (nvar > 2147483646)) {
      d_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 0; k < nvar; k++) {
      yk[k] *= theta;
    }

    theta = 1.0 - theta;
    st.site = &uk_emlrtRSI;
    b_st.site = &gi_emlrtRSI;
    b_st.site = &fi_emlrtRSI;
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    daxpy(&n_t, &theta, &workspace[0], &incx_t, &yk[0], &incy_t);
    st.site = &uk_emlrtRSI;
    dotSY = d_xdot(&st, nvar, sk, yk);
  }

  if ((curvatureS > 2.2204460492503131E-16) && (dotSY > 2.2204460492503131E-16))
  {
    success = true;
  } else {
    success = false;
  }

  if (success) {
    theta = -1.0 / curvatureS;
    st.site = &uk_emlrtRSI;
    b_st.site = &mg_emlrtRSI;
    b_st.site = &ng_emlrtRSI;
    m_t = (ptrdiff_t)nvar;
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    lda_t = (ptrdiff_t)132;
    dger(&m_t, &n_t, &theta, &workspace[0], &incx_t, &workspace[0], &incy_t,
         &Bk[0], &lda_t);
    theta = 1.0 / dotSY;
    st.site = &uk_emlrtRSI;
    b_st.site = &mg_emlrtRSI;
    b_st.site = &ng_emlrtRSI;
    m_t = (ptrdiff_t)nvar;
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    lda_t = (ptrdiff_t)132;
    dger(&m_t, &n_t, &theta, &yk[0], &incx_t, &yk[0], &incy_t, &Bk[0], &lda_t);
  }

  return success;
}

/* End of code generation (BFGSUpdate.c) */
