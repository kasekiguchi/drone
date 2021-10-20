/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * normal.c
 *
 * Code generation for function 'normal'
 *
 */

/* Include files */
#include "normal.h"
#include "addAeqConstr.h"
#include "driver1.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "sortLambdaQP.h"
#include "updatePenaltyParam.h"

/* Variable Definitions */
static emlrtRSInfo ad_emlrtRSI = { 1,  /* lineNo */
  "normal",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\normal.p"/* pathName */
};

static emlrtBCInfo rb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "normal",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\normal.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void normal(const emlrtStack *sp, const real_T Hessian[5929], const
            emxArray_real_T *grad, d_struct_T *TrialState, k_struct_T
            *MeritFunction, c_struct_T *memspace, j_struct_T *WorkingSet,
            g_struct_T *QRManager, h_struct_T *CholManager, i_struct_T
            *QPObjective, const b_struct_T *qpoptions)
{
  b_struct_T b_qpoptions;
  emlrtStack b_st;
  emlrtStack st;
  int32_T b;
  int32_T i;
  int32_T i1;
  int32_T idx;
  boolean_T exitg1;
  boolean_T nonlinEqRemoved;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b_qpoptions = *qpoptions;
  st.site = &ad_emlrtRSI;
  b_driver(&st, Hessian, grad, TrialState, memspace, WorkingSet, QRManager,
           CholManager, QPObjective, &b_qpoptions, qpoptions->MaxIterations);
  if (TrialState->state > 0) {
    st.site = &ad_emlrtRSI;
    updatePenaltyParam(&st, MeritFunction, TrialState->sqpFval,
                       TrialState->cIneq, WorkingSet->sizes[2], TrialState->cEq,
                       WorkingSet->sizes[1], TrialState->sqpIterations,
                       TrialState->fstar);
  }

  st.site = &ad_emlrtRSI;
  sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
               WorkingSet->sizes, WorkingSet->isActiveIdx, WorkingSet->Wid,
               WorkingSet->Wlocalidx, memspace->workspace_double);
  nonlinEqRemoved = (WorkingSet->mEqRemoved > 0);
  exitg1 = false;
  while ((!exitg1) && (WorkingSet->mEqRemoved > 0)) {
    i = WorkingSet->indexEqRemoved->size[0];
    if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > i)) {
      emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, i, &rb_emlrtBCI,
        sp);
    }

    i = WorkingSet->indexEqRemoved->data[WorkingSet->mEqRemoved - 1];
    if (i >= TrialState->iNonEq0) {
      i1 = WorkingSet->indexEqRemoved->size[0];
      if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > i1)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, i1,
          &rb_emlrtBCI, sp);
      }

      st.site = &ad_emlrtRSI;
      addAeqConstr(&st, WorkingSet, i);
      WorkingSet->mEqRemoved--;
    } else {
      exitg1 = true;
    }
  }

  if (nonlinEqRemoved) {
    b = TrialState->mNonlinEq;
    st.site = &ad_emlrtRSI;
    if ((1 <= TrialState->mNonlinEq) && (TrialState->mNonlinEq > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b; idx++) {
      i = WorkingSet->Wlocalidx->size[0];
      i1 = TrialState->iNonEq0 + idx;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &rb_emlrtBCI, sp);
      }

      WorkingSet->Wlocalidx->data[i1 - 1] = i1;
    }
  }
}

/* End of code generation (normal.c) */
