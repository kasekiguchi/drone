/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fillLambdaStruct.c
 *
 * Code generation for function 'fillLambdaStruct'
 *
 */

/* Include files */
#include "fillLambdaStruct.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo bg_emlrtRSI = { 1,  /* lineNo */
  "fillLambdaStruct",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p"/* pathName */
};

static emlrtBCInfo bb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "fillLambdaStruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cb_emlrtBCI = { 1,  /* iFirst */
  77,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "fillLambdaStruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p",/* pName */
  3                                    /* checkKind */
};

static emlrtRTEInfo hb_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "fillLambdaStruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p"/* pName */
};

/* Function Definitions */
void fillLambdaStruct(const emlrtStack *sp, int32_T mNonlinIneq, int32_T
                      mNonlinEq, const emxArray_real_T *TrialState_lambdasqp,
                      const emxArray_int32_T *WorkingSet_indexLB, const int32_T
                      WorkingSet_sizes[5], emxArray_real_T *lambda_eqnonlin,
                      emxArray_real_T *lambda_ineqnonlin, real_T lambda_lower[77],
                      real_T lambda_upper[77])
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T idx;
  int32_T lambda_idx;
  int32_T mLB;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  mLB = WorkingSet_sizes[3];
  lambda_idx = lambda_eqnonlin->size[0];
  lambda_eqnonlin->size[0] = mNonlinEq;
  emxEnsureCapacity_real_T(sp, lambda_eqnonlin, lambda_idx, &hb_emlrtRTEI);
  for (lambda_idx = 0; lambda_idx < mNonlinEq; lambda_idx++) {
    lambda_eqnonlin->data[lambda_idx] = 0.0;
  }

  lambda_idx = lambda_ineqnonlin->size[0];
  lambda_ineqnonlin->size[0] = mNonlinIneq;
  emxEnsureCapacity_real_T(sp, lambda_ineqnonlin, lambda_idx, &hb_emlrtRTEI);
  for (lambda_idx = 0; lambda_idx < mNonlinIneq; lambda_idx++) {
    lambda_ineqnonlin->data[lambda_idx] = 0.0;
  }

  memset(&lambda_lower[0], 0, 77U * sizeof(real_T));
  memset(&lambda_upper[0], 0, 77U * sizeof(real_T));
  lambda_idx = 1;
  st.site = &bg_emlrtRSI;
  if ((1 <= mNonlinEq) && (mNonlinEq > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mNonlinEq; idx++) {
    if ((lambda_idx < 1) || (lambda_idx > TrialState_lambdasqp->size[0])) {
      emlrtDynamicBoundsCheckR2012b(lambda_idx, 1, TrialState_lambdasqp->size[0],
        &bb_emlrtBCI, sp);
    }

    if ((idx + 1 < 1) || (idx + 1 > lambda_eqnonlin->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, lambda_eqnonlin->size[0],
        &bb_emlrtBCI, sp);
    }

    lambda_eqnonlin->data[idx] = TrialState_lambdasqp->data[lambda_idx - 1];
    lambda_idx++;
  }

  st.site = &bg_emlrtRSI;
  if ((1 <= mNonlinIneq) && (mNonlinIneq > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mNonlinIneq; idx++) {
    if ((lambda_idx < 1) || (lambda_idx > TrialState_lambdasqp->size[0])) {
      emlrtDynamicBoundsCheckR2012b(lambda_idx, 1, TrialState_lambdasqp->size[0],
        &bb_emlrtBCI, sp);
    }

    if ((idx + 1 < 1) || (idx + 1 > lambda_ineqnonlin->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, lambda_ineqnonlin->size[0],
        &bb_emlrtBCI, sp);
    }

    lambda_ineqnonlin->data[idx] = TrialState_lambdasqp->data[lambda_idx - 1];
    lambda_idx++;
  }

  st.site = &bg_emlrtRSI;
  st.site = &bg_emlrtRSI;
  if ((1 <= WorkingSet_sizes[3]) && (WorkingSet_sizes[3] > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > WorkingSet_indexLB->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, WorkingSet_indexLB->size[0],
        &bb_emlrtBCI, sp);
    }

    if ((lambda_idx < 1) || (lambda_idx > TrialState_lambdasqp->size[0])) {
      emlrtDynamicBoundsCheckR2012b(lambda_idx, 1, TrialState_lambdasqp->size[0],
        &bb_emlrtBCI, sp);
    }

    if ((WorkingSet_indexLB->data[idx] < 1) || (WorkingSet_indexLB->data[idx] >
         77)) {
      emlrtDynamicBoundsCheckR2012b(WorkingSet_indexLB->data[idx], 1, 77,
        &cb_emlrtBCI, sp);
    }

    lambda_lower[WorkingSet_indexLB->data[idx] - 1] = TrialState_lambdasqp->
      data[lambda_idx - 1];
    lambda_idx++;
  }

  st.site = &bg_emlrtRSI;
}

/* End of code generation (fillLambdaStruct.c) */
