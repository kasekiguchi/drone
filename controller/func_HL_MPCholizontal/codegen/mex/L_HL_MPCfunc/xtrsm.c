/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xtrsm.c
 *
 * Code generation for function 'xtrsm'
 *
 */

/* Include files */
#include "xtrsm.h"
#include "L_HL_MPCfunc.h"
#include "blas.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void b_xtrsm(int32_T m, const real_T A[94249], real_T B[94249])
{
  real_T alpha1;
  char_T DIAGA1;
  char_T TRANSA1;
  char_T UPLO1;
  char_T SIDE1;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  if (m >= 1) {
    alpha1 = 1.0;
    DIAGA1 = 'N';
    TRANSA1 = 'T';
    UPLO1 = 'U';
    SIDE1 = 'L';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)2;
    lda_t = (ptrdiff_t)307;
    ldb_t = (ptrdiff_t)307;
    dtrsm(&SIDE1, &UPLO1, &TRANSA1, &DIAGA1, &m_t, &n_t, &alpha1, &A[0], &lda_t,
          &B[0], &ldb_t);
  }
}

void xtrsm(int32_T m, const real_T A[94249], real_T B[94249])
{
  real_T alpha1;
  char_T DIAGA1;
  char_T TRANSA1;
  char_T UPLO1;
  char_T SIDE1;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  alpha1 = 1.0;
  DIAGA1 = 'N';
  TRANSA1 = 'N';
  UPLO1 = 'U';
  SIDE1 = 'L';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)2;
  lda_t = (ptrdiff_t)307;
  ldb_t = (ptrdiff_t)307;
  dtrsm(&SIDE1, &UPLO1, &TRANSA1, &DIAGA1, &m_t, &n_t, &alpha1, &A[0], &lda_t,
        &B[0], &ldb_t);
}

/* End of code generation (xtrsm.c) */
