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
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Function Definitions */
boolean_T BFGSUpdate(int32_T nvar, real_T Bk[4356], const emxArray_real_T *sk,
                     emxArray_real_T *yk, emxArray_real_T *workspace)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T curvatureS;
  real_T dotSY;
  real_T theta;
  char_T TRANSA;
  boolean_T success;
  if (nvar < 1) {
    dotSY = 0.0;
  } else {
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dotSY = ddot(&n_t, &sk->data[0], &incx_t, &yk->data[0], &incy_t);
  }

  theta = 1.0;
  curvatureS = 0.0;
  TRANSA = 'N';
  m_t = (ptrdiff_t)nvar;
  n_t = (ptrdiff_t)nvar;
  lda_t = (ptrdiff_t)66;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &theta, &Bk[0], &lda_t, &sk->data[0], &incx_t,
        &curvatureS, &workspace->data[0], &incy_t);
  if (nvar < 1) {
    curvatureS = 0.0;
  } else {
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    curvatureS = ddot(&n_t, &sk->data[0], &incx_t, &workspace->data[0], &incy_t);
  }

  if (dotSY < 0.2 * curvatureS) {
    theta = 0.8 * curvatureS / (curvatureS - dotSY);
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    dscal(&n_t, &theta, &yk->data[0], &incx_t);
    theta = 1.0 - theta;
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    daxpy(&n_t, &theta, &workspace->data[0], &incx_t, &yk->data[0], &incy_t);
    if (nvar < 1) {
      dotSY = 0.0;
    } else {
      n_t = (ptrdiff_t)nvar;
      incx_t = (ptrdiff_t)1;
      incy_t = (ptrdiff_t)1;
      dotSY = ddot(&n_t, &sk->data[0], &incx_t, &yk->data[0], &incy_t);
    }
  }

  if ((curvatureS > 2.2204460492503131E-16) && (dotSY > 2.2204460492503131E-16))
  {
    success = true;
  } else {
    success = false;
  }

  if (success) {
    theta = -1.0 / curvatureS;
    m_t = (ptrdiff_t)nvar;
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    lda_t = (ptrdiff_t)66;
    dger(&m_t, &n_t, &theta, &workspace->data[0], &incx_t, &workspace->data[0],
         &incy_t, &Bk[0], &lda_t);
    theta = 1.0 / dotSY;
    m_t = (ptrdiff_t)nvar;
    n_t = (ptrdiff_t)nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    lda_t = (ptrdiff_t)66;
    dger(&m_t, &n_t, &theta, &yk->data[0], &incx_t, &yk->data[0], &incy_t, &Bk[0],
         &lda_t);
  }

  return success;
}

/* End of code generation (BFGSUpdate.c) */
