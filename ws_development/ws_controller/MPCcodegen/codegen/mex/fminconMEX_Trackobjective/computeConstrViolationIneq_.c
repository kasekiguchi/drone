/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeConstrViolationIneq_.c
 *
 * Code generation for function 'computeConstrViolationIneq_'
 *
 */

/* Include files */
#include "computeConstrViolationIneq_.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo nb_emlrtRSI = { 1,  /* lineNo */
  "computeConstrViolationIneq_",       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeConstrViolationIneq_.p"/* pathName */
};

static emlrtBCInfo q_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeConstrViolationIneq_",       /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeConstrViolationIneq_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
real_T computeConstrViolationIneq_(const emlrtStack *sp, int32_T mIneq, const
  emxArray_real_T *ineq_workspace)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T d;
  real_T normResid;
  int32_T idx;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  normResid = 0.0;
  st.site = &nb_emlrtRSI;
  if ((1 <= mIneq) && (mIneq > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mIneq; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > ineq_workspace->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, ineq_workspace->size[0],
        &q_emlrtBCI, sp);
    }

    d = ineq_workspace->data[idx];
    if (d > 0.0) {
      if ((idx + 1 < 1) || (idx + 1 > ineq_workspace->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, ineq_workspace->size[0],
          &q_emlrtBCI, sp);
      }

      normResid += d;
    }
  }

  return normResid;
}

/* End of code generation (computeConstrViolationIneq_.c) */
