/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeGradLag.c
 *
 * Code generation for function 'computeGradLag'
 *
 */

/* Include files */
#include "computeGradLag.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "blas.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo gf_emlrtRSI = { 1,  /* lineNo */
  "computeGradLag",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p"/* pathName */
};

static emlrtBCInfo qb_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGradLag",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rb_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGradLag",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sb_emlrtBCI = { 1,  /* iFirst */
  299245,                              /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGradLag",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void b_computeGradLag(const emlrtStack *sp, real_T workspace[299245], int32_T
                      nVar, const real_T grad[485], const real_T AineqTrans
                      [85360], const real_T AeqTrans[42680], const int32_T
                      finiteLB[485], int32_T mLB, const real_T lambda[617])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  int32_T iL0;
  int32_T idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &gf_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&workspace[0], &grad[0], nVar * sizeof(real_T));
  }

  st.site = &gf_emlrtRSI;
  st.site = &gf_emlrtRSI;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)485;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AeqTrans[0], &lda_t, &lambda[0], &incx_t,
        &beta1, &workspace[0], &incy_t);
  st.site = &gf_emlrtRSI;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)176;
  lda_t = (ptrdiff_t)485;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AineqTrans[0], &lda_t, &lambda[88],
        &incx_t, &beta1, &workspace[0], &incy_t);
  iL0 = 265;
  st.site = &gf_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((finiteLB[idx] < 1) || (finiteLB[idx] > 299245)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB[idx], 1, 299245, &sb_emlrtBCI, sp);
    }

    if (iL0 > 617) {
      emlrtDynamicBoundsCheckR2012b(618, 1, 617, &rb_emlrtBCI, sp);
    }

    workspace[finiteLB[idx] - 1] -= lambda[iL0 - 1];
    iL0++;
  }

  st.site = &gf_emlrtRSI;
}

void computeGradLag(const emlrtStack *sp, real_T workspace[485], int32_T nVar,
                    const real_T grad[485], const real_T AineqTrans[85360],
                    const real_T AeqTrans[42680], const int32_T finiteLB[485],
                    int32_T mLB, const real_T lambda[617])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  int32_T iL0;
  int32_T idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &gf_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&workspace[0], &grad[0], nVar * sizeof(real_T));
  }

  st.site = &gf_emlrtRSI;
  st.site = &gf_emlrtRSI;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)485;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AeqTrans[0], &lda_t, &lambda[0], &incx_t,
        &beta1, &workspace[0], &incy_t);
  st.site = &gf_emlrtRSI;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)176;
  lda_t = (ptrdiff_t)485;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AineqTrans[0], &lda_t, &lambda[88],
        &incx_t, &beta1, &workspace[0], &incy_t);
  iL0 = 265;
  st.site = &gf_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((finiteLB[idx] < 1) || (finiteLB[idx] > 485)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB[idx], 1, 485, &qb_emlrtBCI, sp);
    }

    if (iL0 > 617) {
      emlrtDynamicBoundsCheckR2012b(618, 1, 617, &rb_emlrtBCI, sp);
    }

    workspace[finiteLB[idx] - 1] -= lambda[iL0 - 1];
    iL0++;
  }

  st.site = &gf_emlrtRSI;
}

/* End of code generation (computeGradLag.c) */
