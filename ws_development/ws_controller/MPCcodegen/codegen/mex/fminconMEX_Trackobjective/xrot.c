/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xrot.c
 *
 * Code generation for function 'xrot'
 *
 */

/* Include files */
#include "xrot.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Function Definitions */
void b_xrot(int32_T n, emxArray_real_T *x, int32_T ix0, int32_T incx, int32_T
            iy0, int32_T incy, real_T c, real_T s)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  if (n >= 1) {
    n_t = (ptrdiff_t)n;
    incx_t = (ptrdiff_t)incx;
    incy_t = (ptrdiff_t)incy;
    drot(&n_t, &x->data[ix0 - 1], &incx_t, &x->data[iy0 - 1], &incy_t, &c, &s);
  }
}

void xrot(int32_T n, emxArray_real_T *x, int32_T ix0, int32_T iy0, real_T c,
          real_T s)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  if (n >= 1) {
    n_t = (ptrdiff_t)n;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    drot(&n_t, &x->data[ix0 - 1], &incx_t, &x->data[iy0 - 1], &incy_t, &c, &s);
  }
}

/* End of code generation (xrot.c) */
