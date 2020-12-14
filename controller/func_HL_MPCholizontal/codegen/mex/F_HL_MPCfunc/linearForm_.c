/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * linearForm_.c
 *
 * Code generation for function 'linearForm_'
 *
 */

/* Include files */
#include "linearForm_.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "blas.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo si_emlrtRSI = { 1,  /* lineNo */
  "linearForm_",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\linearForm_.p"/* pathName */
};

/* Function Definitions */
void linearForm_(const emlrtStack *sp, boolean_T obj_hasLinear, int32_T obj_nvar,
                 real_T workspace[299245], const real_T H[17424], const real_T
                 f[485], const real_T x[485])
{
  real_T beta1;
  real_T alpha1;
  char_T TRANSA;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  ptrdiff_t lda_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  beta1 = 0.0;
  if (obj_hasLinear) {
    st.site = &si_emlrtRSI;
    if ((1 <= obj_nvar) && (obj_nvar > 2147483646)) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    if (0 <= obj_nvar - 1) {
      memcpy(&workspace[0], &f[0], obj_nvar * sizeof(real_T));
    }

    beta1 = 1.0;
  }

  st.site = &si_emlrtRSI;
  if (obj_nvar >= 1) {
    alpha1 = 0.5;
    TRANSA = 'N';
    m_t = (ptrdiff_t)obj_nvar;
    n_t = (ptrdiff_t)obj_nvar;
    lda_t = (ptrdiff_t)obj_nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &H[0], &lda_t, &x[0], &incx_t, &beta1,
          &workspace[0], &incy_t);
  }
}

/* End of code generation (linearForm_.c) */
