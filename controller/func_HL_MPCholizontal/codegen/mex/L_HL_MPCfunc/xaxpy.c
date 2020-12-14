/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xaxpy.c
 *
 * Code generation for function 'xaxpy'
 *
 */

/* Include files */
#include "xaxpy.h"
#include "L_HL_MPCfunc.h"
#include "blas.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void b_xaxpy(int32_T n, real_T a, const real_T x[307], real_T y[307])
{
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  if (n >= 1) {
    n_t = (ptrdiff_t)n;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    daxpy(&n_t, &a, &x[0], &incx_t, &y[0], &incy_t);
  }
}

void xaxpy(int32_T n, const real_T x[307], real_T y[94249])
{
  real_T a;
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  a = 1.0;
  n_t = (ptrdiff_t)n;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  daxpy(&n_t, &a, &x[0], &incx_t, &y[0], &incy_t);
}

/* End of code generation (xaxpy.c) */
