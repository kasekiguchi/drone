/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computePrimalFeasError.c
 *
 * Code generation for function 'computePrimalFeasError'
 *
 */

/* Include files */
#include "computePrimalFeasError.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo tb_emlrtRSI = { 1,  /* lineNo */
  "computePrimalFeasError",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computePrimalFeasError.p"/* pathName */
};

static emlrtBCInfo r_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computePrimalFeasError",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computePrimalFeasError.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo s_emlrtBCI = { 1,   /* iFirst */
  0,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computePrimalFeasError",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computePrimalFeasError.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo t_emlrtBCI = { 1,   /* iFirst */
  77,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computePrimalFeasError",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computePrimalFeasError.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
real_T computePrimalFeasError(const emlrtStack *sp, int32_T mLinIneq, int32_T
  mNonlinIneq, const emxArray_real_T *cIneq, int32_T mLinEq, int32_T mNonlinEq,
  const emxArray_real_T *cEq, const emxArray_int32_T *finiteLB, int32_T mLB)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T feasError;
  int32_T idx;
  int32_T mEq;
  int32_T mIneq;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  feasError = 0.0;
  mEq = mNonlinEq + mLinEq;
  mIneq = mNonlinIneq + mLinIneq;
  st.site = &tb_emlrtRSI;
  if ((1 <= mEq) && (mEq > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mEq; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > cEq->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, cEq->size[0], &r_emlrtBCI, sp);
    }

    feasError = muDoubleScalarMax(feasError, muDoubleScalarAbs(cEq->data[idx]));
  }

  st.site = &tb_emlrtRSI;
  if ((1 <= mIneq) && (mIneq > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mIneq; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > cIneq->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, cIneq->size[0], &r_emlrtBCI, sp);
    }

    feasError = muDoubleScalarMax(feasError, cIneq->data[idx]);
  }

  st.site = &tb_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > finiteLB->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, finiteLB->size[0], &r_emlrtBCI,
        sp);
    }

    if ((finiteLB->data[idx] < 1) || (finiteLB->data[idx] > 0)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB->data[idx], 1, 0, &s_emlrtBCI, sp);
    }

    if ((finiteLB->data[idx] < 1) || (finiteLB->data[idx] > 77)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB->data[idx], 1, 77, &t_emlrtBCI, sp);
    }
  }

  st.site = &tb_emlrtRSI;
  return feasError;
}

/* End of code generation (computePrimalFeasError.c) */
