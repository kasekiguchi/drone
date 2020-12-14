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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo v_emlrtRSI = { 1,   /* lineNo */
  "computePrimalFeasError",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computePrimalFeasError.p"/* pathName */
};

static emlrtBCInfo f_emlrtBCI = { 1,   /* iFirst */
  110,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computePrimalFeasError",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computePrimalFeasError.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { 1,   /* iFirst */
  0,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computePrimalFeasError",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computePrimalFeasError.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
real_T computePrimalFeasError(const emlrtStack *sp, const real_T cIneq[20],
  const real_T cEq[88], const int32_T finiteLB[307], int32_T mLB)
{
  real_T feasError;
  int32_T idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  feasError = 0.0;
  st.site = &v_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    feasError = muDoubleScalarMax(feasError, muDoubleScalarAbs(cEq[idx]));
  }

  st.site = &v_emlrtRSI;
  for (idx = 0; idx < 20; idx++) {
    feasError = muDoubleScalarMax(feasError, cIneq[idx]);
  }

  st.site = &v_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((finiteLB[idx] < 1) || (finiteLB[idx] > 0)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB[idx], 1, 0, &g_emlrtBCI, sp);
    }

    if ((finiteLB[idx] < 1) || (finiteLB[idx] > 110)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB[idx], 1, 110, &f_emlrtBCI, sp);
    }
  }

  st.site = &v_emlrtRSI;
  return feasError;
}

/* End of code generation (computePrimalFeasError.c) */
