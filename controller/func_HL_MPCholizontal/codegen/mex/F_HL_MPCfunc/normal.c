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
#include "F_HL_MPCfunc.h"
#include "addAeqConstr.h"
#include "driver1.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "sortLambdaQP.h"

/* Variable Definitions */
static emlrtRSInfo ii_emlrtRSI = { 1,  /* lineNo */
  "normal",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\normal.p"/* pathName */
};

static emlrtBCInfo wc_emlrtBCI = { 1,  /* iFirst */
  88,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "normal",                            /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\normal.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void normal(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T
            Hessian[17424], const real_T grad[485], e_struct_T *TrialState,
            i_struct_T *MeritFunction, b_struct_T *memspace, g_struct_T
            *WorkingSet, k_struct_T *QRManager, l_struct_T *CholManager,
            j_struct_T *QPObjective, const c_struct_T *qpoptions)
{
  c_struct_T b_qpoptions;
  c_struct_T c_qpoptions;
  real_T penaltyParamTrial;
  boolean_T nonlinEqRemoved;
  boolean_T exitg1;
  real_T constrViolationEq;
  int32_T k;
  real_T constrViolationIneq;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  b_qpoptions = *qpoptions;
  c_qpoptions = *qpoptions;
  st.site = &ii_emlrtRSI;
  b_driver(SD, &st, Hessian, grad, TrialState, memspace, WorkingSet, QRManager,
           CholManager, QPObjective, &b_qpoptions, &c_qpoptions);
  if (TrialState->state > 0) {
    penaltyParamTrial = MeritFunction->penaltyParam;
    constrViolationEq = 0.0;
    for (k = 0; k < 88; k++) {
      constrViolationEq += muDoubleScalarAbs(TrialState->cEq[k]);
    }

    constrViolationIneq = 0.0;
    for (k = 0; k < 176; k++) {
      if (TrialState->cIneq[k] > 0.0) {
        constrViolationIneq += TrialState->cIneq[k];
      }
    }

    constrViolationIneq += constrViolationEq;
    constrViolationEq = MeritFunction->linearizedConstrViol;
    MeritFunction->linearizedConstrViol = 0.0;
    constrViolationEq += constrViolationIneq;
    if ((constrViolationEq > 2.2204460492503131E-16) && (TrialState->fstar > 0.0))
    {
      if (TrialState->sqpFval == 0.0) {
        penaltyParamTrial = 1.0;
      } else {
        penaltyParamTrial = 1.5;
      }

      penaltyParamTrial = penaltyParamTrial * TrialState->fstar /
        constrViolationEq;
    }

    if (penaltyParamTrial < MeritFunction->penaltyParam) {
      MeritFunction->phi = TrialState->sqpFval + penaltyParamTrial *
        constrViolationIneq;
      if ((MeritFunction->initFval + penaltyParamTrial *
           (MeritFunction->initConstrViolationEq +
            MeritFunction->initConstrViolationIneq)) - MeritFunction->phi >
          (real_T)MeritFunction->nPenaltyDecreases * MeritFunction->threshold) {
        MeritFunction->nPenaltyDecreases++;
        if ((MeritFunction->nPenaltyDecreases << 1) > TrialState->sqpIterations)
        {
          MeritFunction->threshold *= 10.0;
        }

        MeritFunction->penaltyParam = muDoubleScalarMax(penaltyParamTrial,
          1.0E-10);
      } else {
        MeritFunction->phi = TrialState->sqpFval + MeritFunction->penaltyParam *
          constrViolationIneq;
      }
    } else {
      MeritFunction->penaltyParam = muDoubleScalarMax(penaltyParamTrial, 1.0E-10);
      MeritFunction->phi = TrialState->sqpFval + MeritFunction->penaltyParam *
        constrViolationIneq;
    }

    MeritFunction->phiPrimePlus = muDoubleScalarMin(TrialState->fstar -
      MeritFunction->penaltyParam * constrViolationIneq, 0.0);
  }

  st.site = &ii_emlrtRSI;
  sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
               WorkingSet->sizes, WorkingSet->isActiveIdx, WorkingSet->Wid,
               WorkingSet->Wlocalidx, memspace->workspace_double);
  nonlinEqRemoved = (WorkingSet->mEqRemoved > 0);
  exitg1 = false;
  while ((!exitg1) && (WorkingSet->mEqRemoved > 0)) {
    if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > 88)) {
      emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, 88, &wc_emlrtBCI,
        sp);
    }

    k = WorkingSet->mEqRemoved - 1;
    if (WorkingSet->indexEqRemoved[k] >= 1) {
      if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > 88)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, 88,
          &wc_emlrtBCI, sp);
      }

      st.site = &ii_emlrtRSI;
      addAeqConstr(&st, WorkingSet, WorkingSet->indexEqRemoved[k]);
      WorkingSet->mEqRemoved--;
    } else {
      exitg1 = true;
    }
  }

  if (nonlinEqRemoved) {
    for (k = 0; k < 88; k++) {
      WorkingSet->Wlocalidx[k] = k + 1;
    }
  }
}

/* End of code generation (normal.c) */
