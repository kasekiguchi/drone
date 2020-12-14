/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeDeltaLag.c
 *
 * Code generation for function 'computeDeltaLag'
 *
 */

/* Include files */
#include "computeDeltaLag.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "blas.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo dg_emlrtRSI = { 1,  /* lineNo */
  "computeDeltaLag",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeDeltaLag.p"/* pathName */
};

/* Function Definitions */
void computeDeltaLag(const emlrtStack *sp, int32_T nVar, real_T workspace[307],
                     const real_T grad[307], const real_T JacIneqTrans[6140],
                     const real_T JacEqTrans[27016], const real_T grad_old[307],
                     const real_T JacIneqTrans_old[6140], const real_T
                     JacEqTrans_old[27016], const real_T lambda[305])
{
  real_T a;
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t lda_t;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &dg_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&workspace[0], &grad[0], nVar * sizeof(real_T));
  }

  st.site = &dg_emlrtRSI;
  if (nVar >= 1) {
    a = -1.0;
    n_t = (ptrdiff_t)nVar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    daxpy(&n_t, &a, &grad_old[0], &incx_t, &workspace[0], &incy_t);
  }

  st.site = &dg_emlrtRSI;
  a = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &a, &JacEqTrans[0], &lda_t, &lambda[0], &incx_t,
        &beta1, &workspace[0], &incy_t);
  st.site = &dg_emlrtRSI;
  a = -1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &a, &JacEqTrans_old[0], &lda_t, &lambda[0], &incx_t,
        &beta1, &workspace[0], &incy_t);
  st.site = &dg_emlrtRSI;
  a = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &a, &JacIneqTrans[0], &lda_t, &lambda[88], &incx_t,
        &beta1, &workspace[0], &incy_t);
  st.site = &dg_emlrtRSI;
  a = -1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &a, &JacIneqTrans_old[0], &lda_t, &lambda[88],
        &incx_t, &beta1, &workspace[0], &incy_t);
}

/* End of code generation (computeDeltaLag.c) */
