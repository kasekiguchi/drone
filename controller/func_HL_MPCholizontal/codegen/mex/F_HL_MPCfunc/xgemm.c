/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgemm.c
 *
 * Code generation for function 'xgemm'
 *
 */

/* Include files */
#include "xgemm.h"
#include "F_HL_MPCfunc.h"
#include "blas.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void b_xgemm(int32_T m, int32_T k, const real_T A[380689], const real_T B[299245],
             real_T C[299245])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSB1;
  char_T TRANSA1;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  if (k >= 1) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSB1 = 'N';
    TRANSA1 = 'N';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)2;
    k_t = (ptrdiff_t)k;
    lda_t = (ptrdiff_t)617;
    ldb_t = (ptrdiff_t)617;
    ldc_t = (ptrdiff_t)617;
    dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &alpha1, &A[0], &lda_t, &B[0],
          &ldb_t, &beta1, &C[0], &ldc_t);
  }
}

void c_xgemm(int32_T m, int32_T n, int32_T k, const real_T A[17424], int32_T lda,
             const real_T B[380689], int32_T ib0, real_T C[299245])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSB1;
  char_T TRANSA1;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  if ((m >= 1) && (n >= 1) && (k >= 1)) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSB1 = 'N';
    TRANSA1 = 'N';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    k_t = (ptrdiff_t)k;
    lda_t = (ptrdiff_t)lda;
    ldb_t = (ptrdiff_t)617;
    ldc_t = (ptrdiff_t)617;
    dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &alpha1, &A[0], &lda_t, &B[ib0 -
          1], &ldb_t, &beta1, &C[0], &ldc_t);
  }
}

void d_xgemm(int32_T m, int32_T n, int32_T k, const real_T A[380689], int32_T
             ia0, const real_T B[299245], real_T C[380689])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSB1;
  char_T TRANSA1;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  if ((m >= 1) && (n >= 1) && (k >= 1)) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSB1 = 'N';
    TRANSA1 = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    k_t = (ptrdiff_t)k;
    lda_t = (ptrdiff_t)617;
    ldb_t = (ptrdiff_t)617;
    ldc_t = (ptrdiff_t)617;
    dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &alpha1, &A[ia0 - 1], &lda_t,
          &B[0], &ldb_t, &beta1, &C[0], &ldc_t);
  }
}

void xgemm(int32_T m, int32_T k, const real_T A[380689], const real_T B[299245],
           real_T C[299245])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSB1;
  char_T TRANSA1;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t k_t;
  ptrdiff_t lda_t;
  ptrdiff_t ldb_t;
  ptrdiff_t ldc_t;
  alpha1 = 1.0;
  beta1 = 0.0;
  TRANSB1 = 'N';
  TRANSA1 = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)2;
  k_t = (ptrdiff_t)k;
  lda_t = (ptrdiff_t)617;
  ldb_t = (ptrdiff_t)617;
  ldc_t = (ptrdiff_t)617;
  dgemm(&TRANSA1, &TRANSB1, &m_t, &n_t, &k_t, &alpha1, &A[0], &lda_t, &B[0],
        &ldb_t, &beta1, &C[0], &ldc_t);
}

/* End of code generation (xgemm.c) */
