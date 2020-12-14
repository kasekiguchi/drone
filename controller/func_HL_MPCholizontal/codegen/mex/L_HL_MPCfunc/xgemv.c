/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgemv.c
 *
 * Code generation for function 'xgemv'
 *
 */

/* Include files */
#include "xgemv.h"
#include "L_HL_MPCfunc.h"
#include "blas.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void b_xgemv(int32_T m, int32_T n, const real_T A[93635], const real_T x[307],
             real_T y[94249])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  if (n >= 1) {
    alpha1 = -1.0;
    beta1 = 1.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)307;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1,
          &y[0], &incy_t);
  }
}

void c_xgemv(const real_T A[6140], const real_T x[94249], real_T y[305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)110;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void d_xgemv(int32_T m, const real_T A[27016], const real_T x[94249], real_T y
             [305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void e_xgemv(int32_T m, const real_T A[6140], const real_T x[94249], real_T y
             [305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void f_xgemv(const real_T A[6140], const real_T x[94249], real_T y[305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)110;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[307], &incx_t, &beta1,
        &y[0], &incy_t);
}

void g_xgemv(int32_T m, const real_T A[27016], const real_T x[94249], real_T y
             [305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[307], &incx_t, &beta1,
        &y[0], &incy_t);
}

void h_xgemv(int32_T m, const real_T A[6140], const real_T x[94249], real_T y
             [305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[307], &incx_t, &beta1,
        &y[0], &incy_t);
}

void i_xgemv(const real_T A[6140], const real_T x[307], real_T y[305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)110;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void j_xgemv(int32_T m, const real_T A[27016], const real_T x[307], real_T y[305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void k_xgemv(int32_T m, const real_T A[6140], const real_T x[307], real_T y[305])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void l_xgemv(int32_T m, int32_T n, const real_T A[12100], int32_T lda, const
             real_T x[307], real_T y[306])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  if ((m >= 1) && (n >= 1)) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'N';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1,
          &y[0], &incy_t);
  }
}

void m_xgemv(int32_T m, int32_T n, const real_T A[94249], const real_T x[93635],
             int32_T ix0, real_T y[94249], int32_T iy0)
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  if ((m >= 1) && (n >= 1)) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)307;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[ix0 - 1], &incx_t,
          &beta1, &y[iy0 - 1], &incy_t);
  }
}

void n_xgemv(int32_T m, int32_T n, const real_T A[94249], int32_T ia0, const
             real_T x[94249], real_T y[307])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  if (m >= 1) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'N';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)307;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[ia0 - 1], &lda_t, &x[0], &incx_t,
          &beta1, &y[0], &incy_t);
  }
}

void o_xgemv(int32_T m, int32_T n, const real_T A[94249], int32_T ia0, const
             real_T x[307], real_T y[94249])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  if (m >= 1) {
    alpha1 = -1.0;
    beta1 = 0.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)307;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[ia0 - 1], &lda_t, &x[0], &incx_t,
          &beta1, &y[0], &incy_t);
  }
}

void p_xgemv(int32_T m, const real_T A[6140], const real_T x[307], real_T y
             [94249])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void q_xgemv(int32_T m, const real_T A[6140], const real_T x[307], real_T y
             [94249])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = 0.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)20;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [307], &incy_t);
}

void r_xgemv(int32_T m, const real_T A[27016], const real_T x[307], real_T y
             [94249])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = -1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void s_xgemv(int32_T m, const real_T A[27016], const real_T x[307], real_T y[88])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)88;
  lda_t = (ptrdiff_t)307;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1, &y
        [0], &incy_t);
}

void xgemv(int32_T m, int32_T n, const real_T A[94249], const real_T x[307],
           real_T y[94249])
{
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  if (m >= 1) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)307;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x[0], &incx_t, &beta1,
          &y[0], &incy_t);
  }
}

/* End of code generation (xgemv.c) */
