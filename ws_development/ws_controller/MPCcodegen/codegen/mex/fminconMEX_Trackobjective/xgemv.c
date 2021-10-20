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
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo rb_emlrtRSI = { 76, /* lineNo */
  "xgemv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemv.m"/* pathName */
};

static emlrtRTEInfo vb_emlrtRTEI = { 76,/* lineNo */
  65,                                  /* colNo */
  "xgemv",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemv.m"/* pName */
};

static emlrtRTEInfo wb_emlrtRTEI = { 76,/* lineNo */
  5,                                   /* colNo */
  "xgemv",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemv.m"/* pName */
};

/* Function Definitions */
void b_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (m >= 1) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[0],
          &incx_t, &beta1, &y->data[0], &incy_t);
  }
}

void c_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (n >= 1) {
    alpha1 = -1.0;
    beta1 = 1.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[0],
          &incx_t, &beta1, &y->data[0], &incy_t);
  }
}

void d_xgemv(int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (n >= 1) {
    alpha1 = 1.0;
    beta1 = -1.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)77;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[0],
          &incx_t, &beta1, &y->data[0], &incy_t);
  }
}

void e_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (n >= 1) {
    alpha1 = 1.0;
    beta1 = -1.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[0],
          &incx_t, &beta1, &y->data[0], &incy_t);
  }
}

void f_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, int32_T ix0, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (n >= 1) {
    alpha1 = 1.0;
    beta1 = -1.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[ix0 - 1],
          &incx_t, &beta1, &y->data[0], &incy_t);
  }
}

void g_xgemv(int32_T m, int32_T n, const real_T A[5929], int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if ((m >= 1) && (n >= 1)) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'N';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A[0], &lda_t, &x->data[0], &incx_t,
          &beta1, &y->data[0], &incy_t);
  }
}

void h_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, int32_T ix0, emxArray_real_T *y, int32_T iy0)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if ((m >= 1) && (n >= 1)) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[ix0 - 1],
          &incx_t, &beta1, &y->data[iy0 - 1], &incy_t);
  }
}

void i_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T ia0,
             int32_T lda, const emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (m >= 1) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'N';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[ia0 - 1], &lda_t, &x->data[0],
          &incx_t, &beta1, &y->data[0], &incy_t);
  }
}

void j_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T ia0,
             int32_T lda, const emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (m >= 1) {
    alpha1 = -1.0;
    beta1 = 0.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[ia0 - 1], &lda_t, &x->data[0],
          &incx_t, &beta1, &y->data[0], &incy_t);
  }
}

void k_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y, int32_T iy0)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (n >= 1) {
    alpha1 = 1.0;
    beta1 = 0.0;
    TRANSA = 'T';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[0],
          &incx_t, &beta1, &y->data[iy0 - 1], &incy_t);
  }
}

void l_xgemv(const emlrtStack *sp, int32_T m, int32_T n, const emxArray_real_T
             *A, int32_T lda, const emxArray_real_T *x, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  emlrtStack st;
  emxArray_real_T *b_y;
  real_T alpha1;
  real_T beta1;
  int32_T b_loop_ub;
  int32_T i;
  int32_T i1;
  int32_T loop_ub;
  char_T TRANSA;
  st.prev = sp;
  st.tls = sp->tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &b_y, 2, &vb_emlrtRTEI, true);
  st.site = &rb_emlrtRSI;
  i = b_y->size[0] * b_y->size[1];
  b_y->size[0] = y->size[0];
  b_y->size[1] = y->size[1];
  emxEnsureCapacity_real_T(&st, b_y, i, &vb_emlrtRTEI);
  loop_ub = y->size[0] * y->size[1];
  for (i = 0; i < loop_ub; i++) {
    b_y->data[i] = y->data[i];
  }

  alpha1 = 1.0;
  beta1 = 1.0;
  TRANSA = 'T';
  m_t = (ptrdiff_t)m;
  n_t = (ptrdiff_t)n;
  lda_t = (ptrdiff_t)lda;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[0], &incx_t,
        &beta1, &b_y->data[0], &incy_t);
  i = y->size[0] * y->size[1];
  y->size[0] = b_y->size[0];
  y->size[1] = b_y->size[1];
  emxEnsureCapacity_real_T(sp, y, i, &wb_emlrtRTEI);
  loop_ub = b_y->size[1];
  for (i = 0; i < loop_ub; i++) {
    b_loop_ub = b_y->size[0];
    for (i1 = 0; i1 < b_loop_ub; i1++) {
      y->data[i1 + y->size[0] * i] = b_y->data[i1 + b_y->size[0] * i];
    }
  }

  emxFree_real_T(&b_y);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

void xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
           emxArray_real_T *x, int32_T ix0, emxArray_real_T *y)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  real_T alpha1;
  real_T beta1;
  char_T TRANSA;
  if (n >= 1) {
    alpha1 = 1.0;
    beta1 = 1.0;
    TRANSA = 'N';
    m_t = (ptrdiff_t)m;
    n_t = (ptrdiff_t)n;
    lda_t = (ptrdiff_t)lda;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &A->data[0], &lda_t, &x->data[ix0 - 1],
          &incx_t, &beta1, &y->data[0], &incy_t);
  }
}

/* End of code generation (xgemv.c) */
