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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo nf_emlrtRSI = { 1,  /* lineNo */
  "computeComplError",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeComplError.p"/* pathName */
};

static emlrtBCInfo fb_emlrtBCI = { 1,  /* iFirst */
  0,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeComplError",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeComplError.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo gb_emlrtBCI = { 1,  /* iFirst */
  132,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeComplError",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeComplError.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
real_T computeComplError(const emlrtStack *sp, const real_T cIneq[176], const
  int32_T finiteLB[485], int32_T mLB, const real_T lambda[617], int32_T iL0)
{
  real_T nlpComplError;
  int32_T idx;
  real_T d;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nlpComplError = 0.0;
  for (idx = 0; idx < 176; idx++) {
    d = lambda[(iL0 + idx) - 1];
    nlpComplError = muDoubleScalarMax(nlpComplError, muDoubleScalarMin
      (muDoubleScalarAbs(cIneq[idx] * d), muDoubleScalarMin(muDoubleScalarAbs
      (cIneq[idx]), d)));
  }

  st.site = &nf_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((finiteLB[idx] < 1) || (finiteLB[idx] > 132)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB[idx], 1, 132, &gb_emlrtBCI, sp);
    }

    emlrtDynamicBoundsCheckR2012b(finiteLB[idx], 1, 0, &fb_emlrtBCI, sp);
  }

  st.site = &nf_emlrtRSI;
  return nlpComplError;
}

/* End of code generation (computeComplError.c) */
