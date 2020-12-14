/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xtrsv.c
 *
 * Code generation for function 'xtrsv'
 *
 */

/* Include files */
#include "xtrsv.h"
#include "F_HL_MPCfunc.h"
#include "blas.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void b_xtrsv(int32_T n, const real_T A[380689], real_T x[485])
{
  char_T DIAGA1;
  char_T TRANSA1;
  char_T UPLO1;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  if (n >= 1) {
    DIAGA1 = 'N';
    TRANSA1 = 'T';
    UPLO1 = 'U';
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)617;
    incx_t = (ptrdiff_t)1;
    dtrsv(&UPLO1, &TRANSA1, &DIAGA1, &n_t, &A[0], &lda_t, &x[0], &incx_t);
  }
}

void c_xtrsv(int32_T n, const real_T A[380689], real_T x[485])
{
  char_T DIAGA1;
  char_T TRANSA1;
  char_T UPLO1;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  if (n >= 1) {
    DIAGA1 = 'N';
    TRANSA1 = 'N';
    UPLO1 = 'U';
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)617;
    incx_t = (ptrdiff_t)1;
    dtrsv(&UPLO1, &TRANSA1, &DIAGA1, &n_t, &A[0], &lda_t, &x[0], &incx_t);
  }
}

void d_xtrsv(int32_T n, const real_T A[380689], real_T x[299245])
{
  char_T DIAGA1;
  char_T TRANSA1;
  char_T UPLO1;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  DIAGA1 = 'N';
  TRANSA1 = 'T';
  UPLO1 = 'U';
  n_t = (ptrdiff_t)n;
  lda_t = (ptrdiff_t)617;
  incx_t = (ptrdiff_t)1;
  dtrsv(&UPLO1, &TRANSA1, &DIAGA1, &n_t, &A[0], &lda_t, &x[0], &incx_t);
}

void xtrsv(int32_T n, const real_T A[380689], real_T x[299245])
{
  char_T DIAGA1;
  char_T TRANSA1;
  char_T UPLO1;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  if (n >= 1) {
    DIAGA1 = 'N';
    TRANSA1 = 'N';
    UPLO1 = 'U';
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)617;
    incx_t = (ptrdiff_t)1;
    dtrsv(&UPLO1, &TRANSA1, &DIAGA1, &n_t, &A[0], &lda_t, &x[0], &incx_t);
  }
}

/* End of code generation (xtrsv.c) */
