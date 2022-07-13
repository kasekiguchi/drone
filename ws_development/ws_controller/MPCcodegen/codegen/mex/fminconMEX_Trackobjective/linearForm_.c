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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo he_emlrtRSI = { 1,  /* lineNo */
  "linearForm_",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\linearForm_.p"/* pathName */
};

static emlrtBCInfo rc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "linearForm_",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\linearForm_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void linearForm_(const emlrtStack *sp, boolean_T obj_hasLinear, int32_T obj_nvar,
                 emxArray_real_T *workspace, const real_T H[4356], const
                 emxArray_real_T *f, const emxArray_real_T *x)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t lda_t;
  ptrdiff_t m_t;
  ptrdiff_t n_t;
  emlrtStack b_st;
  emlrtStack st;
  real_T alpha1;
  real_T beta1;
  int32_T b_i;
  int32_T i;
  char_T TRANSA;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  beta1 = 0.0;
  if (obj_hasLinear) {
    st.site = &he_emlrtRSI;
    if ((1 <= obj_nvar) && (obj_nvar > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (i = 0; i < obj_nvar; i++) {
      if ((i + 1 < 1) || (i + 1 > f->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i + 1, 1, f->size[0], &rc_emlrtBCI, sp);
      }

      b_i = workspace->size[0] * workspace->size[1];
      if ((i + 1 < 1) || (i + 1 > b_i)) {
        emlrtDynamicBoundsCheckR2012b(i + 1, 1, b_i, &rc_emlrtBCI, sp);
      }

      workspace->data[i] = f->data[i];
    }

    beta1 = 1.0;
  }

  st.site = &he_emlrtRSI;
  if (obj_nvar >= 1) {
    alpha1 = 0.5;
    TRANSA = 'N';
    m_t = (ptrdiff_t)obj_nvar;
    n_t = (ptrdiff_t)obj_nvar;
    lda_t = (ptrdiff_t)obj_nvar;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dgemv(&TRANSA, &m_t, &n_t, &alpha1, &H[0], &lda_t, &x->data[0], &incx_t,
          &beta1, &workspace->data[0], &incy_t);
  }
}

/* End of code generation (linearForm_.c) */
