/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xasum.c
 *
 * Code generation for function 'xasum'
 *
 */

/* Include files */
#include "xasum.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Function Definitions */
real_T xasum(int32_T n, const emxArray_real_T *x, int32_T ix0)
{
  ptrdiff_t incx_t;
  ptrdiff_t n_t;
  real_T y;
  if (n < 1) {
    y = 0.0;
  } else {
    n_t = (ptrdiff_t)n;
    incx_t = (ptrdiff_t)1;
    y = dasum(&n_t, &x->data[ix0 - 1], &incx_t);
  }

  return y;
}

/* End of code generation (xasum.c) */
