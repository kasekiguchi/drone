/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeLinearResiduals.c
 *
 * Code generation for function 'computeLinearResiduals'
 *
 */

/* Include files */
#include "computeLinearResiduals.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Function Definitions */
void computeLinearResiduals(const real_T x[77], int32_T nVar, emxArray_real_T
  *workspaceIneq, int32_T mLinIneq, const emxArray_real_T *AineqT, int32_T ldAi,
  emxArray_real_T *workspaceEq, int32_T mLinEq, const emxArray_real_T *AeqT,
  int32_T ldAe)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (mLinIneq > 0) {
    alpha1 = 1.0;
    beta1 = -1.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)nVar;
    n_t = (ptrdiff_t)mLinIneq;
    lda_t = (ptrdiff_t)ldAi;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AineqT->data[0], &lda_t, &x[0], &incx_t,
          &beta1, &workspaceIneq->data[0], &incy_t);
  }

  if (mLinEq > 0) {
    alpha1 = 1.0;
    beta1 = -1.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)nVar;
    n_t = (ptrdiff_t)mLinEq;
    lda_t = (ptrdiff_t)ldAe;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &AeqT->data[0], &lda_t, &x[0], &incx_t,
          &beta1, &workspaceEq->data[0], &incy_t);
  }
}

/* End of code generation (computeLinearResiduals.c) */
