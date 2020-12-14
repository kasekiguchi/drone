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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "blas.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo q_emlrtRSI = { 1,   /* lineNo */
  "computeGradLag",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p"/* pathName */
};

static emlrtBCInfo s_emlrtBCI = { 1,   /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGradLag",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo t_emlrtBCI = { 1,   /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGradLag",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo u_emlrtBCI = { 1,   /* iFirst */
  94249,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGradLag",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void b_computeGradLag(const emlrtStack *sp, real_T workspace[94249], int32_T
                      nVar, const real_T grad[307], const real_T AineqTrans[6140],
                      const real_T AeqTrans[27016], const int32_T finiteLB[307],
                      int32_T mLB, const real_T lambda[305])
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
  st.site = &q_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&workspace[0], &grad[0], nVar * sizeof(real_T));
  }

  st.site = &q_emlrtRSI;
  st.site = &q_emlrtRSI;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AeqTrans[0], &lda_t, &lambda[0], &incx_t,
        &beta1, &workspace[0], &incy_t);
  st.site = &q_emlrtRSI;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AineqTrans[0], &lda_t, &lambda[88],
        &incx_t, &beta1, &workspace[0], &incy_t);
  iL0 = 109;
  st.site = &q_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((finiteLB[idx] < 1) || (finiteLB[idx] > 94249)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB[idx], 1, 94249, &u_emlrtBCI, sp);
    }

    if (iL0 > 305) {
      emlrtDynamicBoundsCheckR2012b(306, 1, 305, &t_emlrtBCI, sp);
    }

    workspace[finiteLB[idx] - 1] -= lambda[iL0 - 1];
    iL0++;
  }

  st.site = &q_emlrtRSI;
}

void computeGradLag(const emlrtStack *sp, real_T workspace[307], int32_T nVar,
                    const real_T grad[307], const real_T AineqTrans[6140], const
                    real_T AeqTrans[27016], const int32_T finiteLB[307], int32_T
                    mLB, const real_T lambda[305])
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
  st.site = &q_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&workspace[0], &grad[0], nVar * sizeof(real_T));
  }

  st.site = &q_emlrtRSI;
  st.site = &q_emlrtRSI;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AeqTrans[0], &lda_t, &lambda[0], &incx_t,
        &beta1, &workspace[0], &incy_t);
  st.site = &q_emlrtRSI;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AineqTrans[0], &lda_t, &lambda[88],
        &incx_t, &beta1, &workspace[0], &incy_t);
  iL0 = 109;
  st.site = &q_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((finiteLB[idx] < 1) || (finiteLB[idx] > 307)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB[idx], 1, 307, &s_emlrtBCI, sp);
    }

    if (iL0 > 305) {
      emlrtDynamicBoundsCheckR2012b(306, 1, 305, &t_emlrtBCI, sp);
    }

    workspace[finiteLB[idx] - 1] -= lambda[iL0 - 1];
    iL0++;
  }

  st.site = &q_emlrtRSI;
}

/* End of code generation (computeGradLag.c) */
