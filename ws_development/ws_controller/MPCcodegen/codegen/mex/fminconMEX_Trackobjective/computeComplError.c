/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeComplError.c
 *
 * Code generation for function 'computeComplError'
 *
 */

/* Include files */
#include "computeComplError.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo vb_emlrtRSI = { 1,  /* lineNo */
  "computeComplError",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeComplError.p"/* pathName */
};

static emlrtBCInfo v_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeComplError",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeComplError.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo w_emlrtBCI = { 1,   /* iFirst */
  77,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeComplError",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeComplError.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo x_emlrtBCI = { 1,   /* iFirst */
  0,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeComplError",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeComplError.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
real_T computeComplError(const emlrtStack *sp, const emxArray_real_T
  *fscales_cineq_constraint, int32_T mIneq, const emxArray_real_T *cIneq, const
  emxArray_int32_T *finiteLB, int32_T mLB, const emxArray_real_T *lambda,
  int32_T iL0)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T nlpComplError;
  int32_T i;
  int32_T idx;
  int32_T mNonlinIneq;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nlpComplError = 0.0;
  mNonlinIneq = fscales_cineq_constraint->size[0];
  if (mIneq + mLB > 0) {
    st.site = &vb_emlrtRSI;
    if ((1 <= fscales_cineq_constraint->size[0]) &&
        (fscales_cineq_constraint->size[0] > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mNonlinIneq; idx++) {
      if ((idx + 1 < 1) || (idx + 1 > fscales_cineq_constraint->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, fscales_cineq_constraint->
          size[0], &v_emlrtBCI, sp);
      }

      if ((idx + 1 < 1) || (idx + 1 > cIneq->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, cIneq->size[0], &v_emlrtBCI,
          sp);
      }

      i = iL0 + idx;
      if ((i < 1) || (i > lambda->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, lambda->size[0], &v_emlrtBCI, sp);
      }

      if ((idx + 1 < 1) || (idx + 1 > cIneq->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, cIneq->size[0], &v_emlrtBCI,
          sp);
      }

      if (i > lambda->size[0]) {
        emlrtDynamicBoundsCheckR2012b(i, 1, lambda->size[0], &v_emlrtBCI, sp);
      }

      nlpComplError = muDoubleScalarMax(nlpComplError, muDoubleScalarMin
        (muDoubleScalarAbs(cIneq->data[idx] * lambda->data[i - 1]),
         muDoubleScalarMin(muDoubleScalarAbs(cIneq->data[idx]), lambda->data[i -
                           1])));
    }

    mNonlinIneq = iL0 + mIneq;
    st.site = &vb_emlrtRSI;
    if ((1 <= mLB) && (mLB > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mLB; idx++) {
      if ((idx + 1 < 1) || (idx + 1 > finiteLB->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, finiteLB->size[0], &v_emlrtBCI,
          sp);
      }

      if ((finiteLB->data[idx] < 1) || (finiteLB->data[idx] > 77)) {
        emlrtDynamicBoundsCheckR2012b(finiteLB->data[idx], 1, 77, &w_emlrtBCI,
          sp);
      }

      if ((finiteLB->data[idx] < 1) || (finiteLB->data[idx] > 0)) {
        emlrtDynamicBoundsCheckR2012b(finiteLB->data[idx], 1, 0, &x_emlrtBCI, sp);
      }

      i = mNonlinIneq + idx;
      if ((i < 1) || (i > lambda->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, lambda->size[0], &v_emlrtBCI, sp);
      }
    }

    st.site = &vb_emlrtRSI;
  }

  return nlpComplError;
}

/* End of code generation (computeComplError.c) */
