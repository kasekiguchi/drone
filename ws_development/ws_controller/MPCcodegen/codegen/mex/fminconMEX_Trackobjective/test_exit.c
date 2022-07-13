/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * test_exit.c
 *
 * Code generation for function 'test_exit'
 *
 */

/* Include files */
#include "test_exit.h"
#include "computeComplError.h"
#include "computeDualFeasError.h"
#include "computeGradLag.h"
#include "computeLambdaLSQ.h"
#include "computePrimalFeasError.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "isDeltaXTooSmall.h"
#include "ixamax.h"
#include "rt_nonfinite.h"
#include "sortLambdaQP.h"
#include "updateWorkingSetForNewQP.h"
#include "xcopy.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo pb_emlrtRSI = { 1,  /* lineNo */
  "test_exit",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\test_exit.p"/* pathName */
};

static emlrtBCInfo nb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "test_exit",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\test_exit.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void b_test_exit(const emlrtStack *sp, struct_T *Flags, c_struct_T *memspace,
                 k_struct_T *MeritFunction, const emxArray_real_T
                 *fscales_cineq_constraint, j_struct_T *WorkingSet, d_struct_T
                 *TrialState, g_struct_T *QRManager)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T d;
  real_T nlpComplErrorTmp;
  real_T nlpDualFeasErrorTmp;
  real_T optimRelativeFactor;
  int32_T i;
  int32_T mEq;
  int32_T mIneq;
  int32_T mLB;
  int32_T mLambda;
  int32_T nActiveConstr;
  int32_T nVar;
  boolean_T dxTooSmall;
  boolean_T guard1 = false;
  boolean_T isFeasible;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nVar = WorkingSet->nVar;
  mEq = WorkingSet->sizes[1];
  mIneq = WorkingSet->sizes[2];
  mLB = WorkingSet->sizes[3];
  mLambda = (WorkingSet->sizes[1] + WorkingSet->sizes[2]) + WorkingSet->sizes[3];
  st.site = &pb_emlrtRSI;
  computeGradLag(&st, TrialState->gradLag, WorkingSet->ldA, WorkingSet->nVar,
                 TrialState->grad, WorkingSet->sizes[2], WorkingSet->Aineq,
                 WorkingSet->sizes[1], WorkingSet->Aeq, WorkingSet->indexLB,
                 WorkingSet->sizes[3], TrialState->lambdasqp);
  i = TrialState->grad->size[0];
  nActiveConstr = ixamax(WorkingSet->nVar, TrialState->grad);
  if ((nActiveConstr < 1) || (nActiveConstr > i)) {
    emlrtDynamicBoundsCheckR2012b(nActiveConstr, 1, i, &nb_emlrtBCI, sp);
  }

  optimRelativeFactor = muDoubleScalarMax(1.0, muDoubleScalarAbs
    (TrialState->grad->data[nActiveConstr - 1]));
  if (muDoubleScalarIsInf(optimRelativeFactor)) {
    optimRelativeFactor = 1.0;
  }

  st.site = &pb_emlrtRSI;
  MeritFunction->nlpPrimalFeasError = computePrimalFeasError(&st,
    WorkingSet->sizes[2] - TrialState->mNonlinIneq, TrialState->mNonlinIneq,
    TrialState->cIneq, WorkingSet->sizes[1] - TrialState->mNonlinEq,
    TrialState->mNonlinEq, TrialState->cEq, WorkingSet->indexLB,
    WorkingSet->sizes[3]);
  if (TrialState->sqpIterations == 0) {
    MeritFunction->feasRelativeFactor = muDoubleScalarMax(1.0,
      MeritFunction->nlpPrimalFeasError);
  }

  isFeasible = (MeritFunction->nlpPrimalFeasError <= 1.0E-6 *
                MeritFunction->feasRelativeFactor);
  st.site = &pb_emlrtRSI;
  computeDualFeasError(&st, WorkingSet->nVar, TrialState->gradLag,
                       &Flags->gradOK, &MeritFunction->nlpDualFeasError);
  if (!Flags->gradOK) {
    Flags->done = true;
    if (isFeasible) {
      TrialState->sqpExitFlag = 2;
    } else {
      TrialState->sqpExitFlag = -2;
    }
  } else {
    st.site = &pb_emlrtRSI;
    MeritFunction->nlpComplError = computeComplError(&st,
      fscales_cineq_constraint, WorkingSet->sizes[2], TrialState->cIneq,
      WorkingSet->indexLB, WorkingSet->sizes[3], TrialState->lambdasqp,
      WorkingSet->sizes[1] + 1);
    MeritFunction->firstOrderOpt = muDoubleScalarMax
      (MeritFunction->nlpDualFeasError, MeritFunction->nlpComplError);
    if (TrialState->sqpIterations > 1) {
      st.site = &pb_emlrtRSI;
      b_computeGradLag(&st, memspace->workspace_double, WorkingSet->ldA,
                       WorkingSet->nVar, TrialState->grad, WorkingSet->sizes[2],
                       WorkingSet->Aineq, WorkingSet->sizes[1], WorkingSet->Aeq,
                       WorkingSet->indexLB, WorkingSet->sizes[3],
                       TrialState->lambdasqp_old);
      st.site = &pb_emlrtRSI;
      b_computeDualFeasError(&st, WorkingSet->nVar, memspace->workspace_double,
        &dxTooSmall, &nlpDualFeasErrorTmp);
      st.site = &pb_emlrtRSI;
      nlpComplErrorTmp = computeComplError(&st, fscales_cineq_constraint,
        WorkingSet->sizes[2], TrialState->cIneq, WorkingSet->indexLB,
        WorkingSet->sizes[3], TrialState->lambdasqp_old, 1);
      d = muDoubleScalarMax(nlpDualFeasErrorTmp, nlpComplErrorTmp);
      if (d < muDoubleScalarMax(MeritFunction->nlpDualFeasError,
           MeritFunction->nlpComplError)) {
        MeritFunction->nlpDualFeasError = nlpDualFeasErrorTmp;
        MeritFunction->nlpComplError = nlpComplErrorTmp;
        MeritFunction->firstOrderOpt = d;
        st.site = &pb_emlrtRSI;
        b_xcopy(mLambda, TrialState->lambdasqp_old, TrialState->lambdasqp);
      } else {
        st.site = &pb_emlrtRSI;
        b_xcopy(mLambda, TrialState->lambdasqp, TrialState->lambdasqp_old);
      }
    } else {
      st.site = &pb_emlrtRSI;
      b_xcopy(mLambda, TrialState->lambdasqp, TrialState->lambdasqp_old);
    }

    if (isFeasible && (MeritFunction->nlpDualFeasError <= 1.0E-6 *
                       optimRelativeFactor) && (MeritFunction->nlpComplError <=
         1.0E-6 * optimRelativeFactor)) {
      Flags->done = true;
      TrialState->sqpExitFlag = 1;
    } else {
      Flags->done = false;
      if (isFeasible && (TrialState->sqpFval < -1.0E+20)) {
        Flags->done = true;
        TrialState->sqpExitFlag = -3;
      } else {
        guard1 = false;
        if (TrialState->sqpIterations > 0) {
          st.site = &pb_emlrtRSI;
          dxTooSmall = isDeltaXTooSmall(&st, TrialState->xstarsqp,
            TrialState->delta_x, WorkingSet->nVar);
          if (dxTooSmall) {
            if (!isFeasible) {
              if (Flags->stepType != 2) {
                Flags->stepType = 2;
                Flags->failedLineSearch = false;
                Flags->stepAccepted = false;
                guard1 = true;
              } else {
                Flags->done = true;
                TrialState->sqpExitFlag = -2;
              }
            } else {
              nActiveConstr = WorkingSet->nActiveConstr;
              if (WorkingSet->nActiveConstr > 0) {
                st.site = &pb_emlrtRSI;
                updateWorkingSetForNewQP(&st, WorkingSet, WorkingSet->sizes[2],
                  TrialState->mNonlinIneq, TrialState->cIneq, WorkingSet->sizes
                  [1], TrialState->mNonlinEq, TrialState->cEq);
                st.site = &pb_emlrtRSI;
                computeLambdaLSQ(&st, nVar, nActiveConstr, QRManager,
                                 WorkingSet->ATwset, TrialState->grad,
                                 TrialState->lambda, memspace->workspace_double);
                st.site = &pb_emlrtRSI;
                if ((1 <= mEq) && (mEq > 2147483646)) {
                  b_st.site = &s_emlrtRSI;
                  check_forloop_overflow_error(&b_st);
                }

                for (nActiveConstr = 1; nActiveConstr <= mEq; nActiveConstr++) {
                  i = TrialState->lambda->size[0];
                  if (nActiveConstr > i) {
                    emlrtDynamicBoundsCheckR2012b(nActiveConstr, 1, i,
                      &nb_emlrtBCI, sp);
                  }

                  i = TrialState->lambda->size[0];
                  if (nActiveConstr > i) {
                    emlrtDynamicBoundsCheckR2012b(nActiveConstr, 1, i,
                      &nb_emlrtBCI, sp);
                  }

                  TrialState->lambda->data[nActiveConstr - 1] =
                    -TrialState->lambda->data[nActiveConstr - 1];
                }

                st.site = &pb_emlrtRSI;
                sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
                             WorkingSet->sizes, WorkingSet->isActiveIdx,
                             WorkingSet->Wid, WorkingSet->Wlocalidx,
                             memspace->workspace_double);
                st.site = &pb_emlrtRSI;
                b_computeGradLag(&st, memspace->workspace_double,
                                 WorkingSet->ldA, nVar, TrialState->grad, mIneq,
                                 WorkingSet->Aineq, mEq, WorkingSet->Aeq,
                                 WorkingSet->indexLB, mLB, TrialState->lambda);
                st.site = &pb_emlrtRSI;
                b_computeDualFeasError(&st, nVar, memspace->workspace_double,
                  &dxTooSmall, &nlpDualFeasErrorTmp);
                st.site = &pb_emlrtRSI;
                nlpComplErrorTmp = computeComplError(&st,
                  fscales_cineq_constraint, mIneq, TrialState->cIneq,
                  WorkingSet->indexLB, mLB, TrialState->lambda, 1);
                if ((nlpDualFeasErrorTmp <= 1.0E-6 * optimRelativeFactor) &&
                    (nlpComplErrorTmp <= 1.0E-6 * optimRelativeFactor)) {
                  MeritFunction->nlpDualFeasError = nlpDualFeasErrorTmp;
                  MeritFunction->nlpComplError = nlpComplErrorTmp;
                  MeritFunction->firstOrderOpt = muDoubleScalarMax
                    (nlpDualFeasErrorTmp, nlpComplErrorTmp);
                  st.site = &pb_emlrtRSI;
                  b_xcopy(mLambda, TrialState->lambda, TrialState->lambdasqp);
                  Flags->done = true;
                  TrialState->sqpExitFlag = 1;
                } else {
                  Flags->done = true;
                  TrialState->sqpExitFlag = 2;
                }
              } else {
                Flags->done = true;
                TrialState->sqpExitFlag = 2;
              }
            }
          } else {
            guard1 = true;
          }
        } else {
          guard1 = true;
        }

        if (guard1) {
          if (TrialState->sqpIterations >= 1000000000) {
            Flags->done = true;
            TrialState->sqpExitFlag = 0;
          } else {
            if (TrialState->FunctionEvaluations >= 1000000000) {
              Flags->done = true;
              TrialState->sqpExitFlag = 0;
            }
          }
        }
      }
    }
  }
}

void test_exit(const emlrtStack *sp, k_struct_T *MeritFunction, const
               emxArray_real_T *fscales_cineq_constraint, const j_struct_T
               *WorkingSet, d_struct_T *TrialState, boolean_T *Flags_gradOK,
               boolean_T *Flags_fevalOK, boolean_T *Flags_done, boolean_T
               *Flags_stepAccepted, boolean_T *Flags_failedLineSearch, int32_T
               *Flags_stepType)
{
  emlrtStack st;
  real_T optimRelativeFactor;
  int32_T i;
  int32_T i1;
  boolean_T isFeasible;
  st.prev = sp;
  st.tls = sp->tls;
  *Flags_fevalOK = true;
  *Flags_done = false;
  *Flags_stepAccepted = false;
  *Flags_failedLineSearch = false;
  *Flags_stepType = 1;
  st.site = &pb_emlrtRSI;
  computeGradLag(&st, TrialState->gradLag, WorkingSet->ldA, WorkingSet->nVar,
                 TrialState->grad, WorkingSet->sizes[2], WorkingSet->Aineq,
                 WorkingSet->sizes[1], WorkingSet->Aeq, WorkingSet->indexLB,
                 WorkingSet->sizes[3], TrialState->lambdasqp);
  i = TrialState->grad->size[0];
  i1 = ixamax(WorkingSet->nVar, TrialState->grad);
  if ((i1 < 1) || (i1 > i)) {
    emlrtDynamicBoundsCheckR2012b(i1, 1, i, &nb_emlrtBCI, sp);
  }

  optimRelativeFactor = muDoubleScalarMax(1.0, muDoubleScalarAbs
    (TrialState->grad->data[i1 - 1]));
  if (muDoubleScalarIsInf(optimRelativeFactor)) {
    optimRelativeFactor = 1.0;
  }

  st.site = &pb_emlrtRSI;
  MeritFunction->nlpPrimalFeasError = computePrimalFeasError(&st,
    WorkingSet->sizes[2] - TrialState->mNonlinIneq, TrialState->mNonlinIneq,
    TrialState->cIneq, WorkingSet->sizes[1] - TrialState->mNonlinEq,
    TrialState->mNonlinEq, TrialState->cEq, WorkingSet->indexLB,
    WorkingSet->sizes[3]);
  MeritFunction->feasRelativeFactor = muDoubleScalarMax(1.0,
    MeritFunction->nlpPrimalFeasError);
  isFeasible = (MeritFunction->nlpPrimalFeasError <= 1.0E-6 *
                MeritFunction->feasRelativeFactor);
  st.site = &pb_emlrtRSI;
  computeDualFeasError(&st, WorkingSet->nVar, TrialState->gradLag, Flags_gradOK,
                       &MeritFunction->nlpDualFeasError);
  if (!*Flags_gradOK) {
    *Flags_done = true;
    if (isFeasible) {
      TrialState->sqpExitFlag = 2;
    } else {
      TrialState->sqpExitFlag = -2;
    }
  } else {
    st.site = &pb_emlrtRSI;
    computeComplError(&st, fscales_cineq_constraint, WorkingSet->sizes[2],
                      TrialState->cIneq, WorkingSet->indexLB, WorkingSet->sizes
                      [3], TrialState->lambdasqp, WorkingSet->sizes[1] + 1);
    MeritFunction->nlpComplError = 0.0;
    MeritFunction->firstOrderOpt = muDoubleScalarMax
      (MeritFunction->nlpDualFeasError, 0.0);
    b_xcopy((WorkingSet->sizes[1] + WorkingSet->sizes[2]) + WorkingSet->sizes[3],
            TrialState->lambdasqp, TrialState->lambdasqp_old);
    if (isFeasible && (MeritFunction->nlpDualFeasError <= 1.0E-6 *
                       optimRelativeFactor)) {
      *Flags_done = true;
      TrialState->sqpExitFlag = 1;
    } else if (isFeasible && (TrialState->sqpFval < -1.0E+20)) {
      *Flags_done = true;
      TrialState->sqpExitFlag = -3;
    } else {
      if (TrialState->FunctionEvaluations >= 1000000000) {
        *Flags_done = true;
        TrialState->sqpExitFlag = 0;
      }
    }
  }
}

/* End of code generation (test_exit.c) */
