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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo yf_emlrtRSI = { 1,  /* lineNo */
  "computeDeltaLag",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeDeltaLag.p"/* pathName */
};

static emlrtBCInfo ud_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeDeltaLag",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeDeltaLag.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void computeDeltaLag(const emlrtStack *sp, int32_T nVar, int32_T ldJ, int32_T
                     mNonlinIneq, int32_T mNonlinEq, emxArray_real_T *workspace,
                     const emxArray_real_T *grad, const emxArray_real_T
                     *JacIneqTrans, int32_T ineqJ0, const emxArray_real_T
                     *JacEqTrans, int32_T eqJ0, const emxArray_real_T *grad_old,
                     const emxArray_real_T *JacIneqTrans_old, const
                     emxArray_real_T *JacEqTrans_old, const emxArray_real_T
                     *lambda, int32_T ineqL0, int32_T eqL0)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  emlrtStack b_st;
  emlrtStack st;
  real_T a;
  real_T beta1;
  int32_T b_i;
  int32_T i;
  char_T TRANSA;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &yf_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (i = 0; i < nVar; i++) {
    if ((i + 1 < 1) || (i + 1 > grad->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i + 1, 1, grad->size[0], &ud_emlrtBCI, sp);
    }

    b_i = workspace->size[0];
    if ((i + 1 < 1) || (i + 1 > b_i)) {
      emlrtDynamicBoundsCheckR2012b(i + 1, 1, b_i, &ud_emlrtBCI, sp);
    }

    workspace->data[i] = grad->data[i];
  }

  st.site = &yf_emlrtRSI;
  if (nVar >= 1) {
    a = -1.0;
    n_t = (ptrdiff_t)nVar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    daxpy(&n_t, &a, &grad_old->data[0], &incx_t, &workspace->data[0], &incy_t);
  }

  st.site = &yf_emlrtRSI;
  a = 1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)mNonlinEq;
  lda_t = (ptrdiff_t)ldJ;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &a, &JacEqTrans->data[ldJ * (eqJ0 - 1)], &lda_t,
        &lambda->data[eqL0 - 1], &incx_t, &beta1, &workspace->data[0], &incy_t);
  st.site = &yf_emlrtRSI;
  a = -1.0;
  beta1 = 1.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nVar;
  n_t = (ptrdiff_t)mNonlinEq;
  lda_t = (ptrdiff_t)ldJ;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &a, &JacEqTrans_old->data[0], &lda_t, &lambda->
        data[eqL0 - 1], &incx_t, &beta1, &workspace->data[0], &incy_t);
  if (mNonlinIneq > 0) {
    st.site = &yf_emlrtRSI;
    a = 1.0;
    beta1 = 1.0;
    TRANSA = 'N';
    m_t = (ptrdiff_t)nVar;
    n_t = (ptrdiff_t)mNonlinIneq;
    lda_t = (ptrdiff_t)ldJ;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &a, &JacIneqTrans->data[ldJ * (ineqJ0 - 1)],
          &lda_t, &lambda->data[ineqL0 - 1], &incx_t, &beta1, &workspace->data[0],
          &incy_t);
    st.site = &yf_emlrtRSI;
    a = -1.0;
    beta1 = 1.0;
    TRANSA = 'N';
    m_t = (ptrdiff_t)nVar;
    n_t = (ptrdiff_t)mNonlinIneq;
    lda_t = (ptrdiff_t)ldJ;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &a, &JacIneqTrans_old->data[0], &lda_t,
          &lambda->data[ineqL0 - 1], &incx_t, &beta1, &workspace->data[0],
          &incy_t);
  }
}

/* End of code generation (computeDeltaLag.c) */
