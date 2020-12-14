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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "computeComplError.h"
#include "computeDualFeasError.h"
#include "computeGradLag.h"
#include "computeLambdaLSQ.h"
#include "computePrimalFeasError.h"
#include "isDeltaXTooSmall.h"
#include "ixamax.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "sortLambdaQP.h"
#include "updateWorkingSetForNewQP.h"
#include "xcopy.h"

/* Function Definitions */
void test_exit(const emlrtStack *sp, struct_T *Flags, b_struct_T *memspace,
               i_struct_T *MeritFunction, g_struct_T *WorkingSet, e_struct_T
               *TrialState, k_struct_T *QRManager)
{
  int32_T nVar;
  int32_T mLB;
  int32_T idx_max;
  real_T optimRelativeFactor;
  boolean_T isFeasible;
  boolean_T dxTooSmall;
  real_T nlpDualFeasErrorTmp;
  real_T nlpComplErrorTmp;
  real_T d;
  boolean_T guard1 = false;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  nVar = WorkingSet->nVar;
  mLB = WorkingSet->sizes[3];
  st.site = &ff_emlrtRSI;
  computeGradLag(&st, TrialState->gradLag, WorkingSet->nVar, TrialState->grad,
                 WorkingSet->Aineq, WorkingSet->Aeq, WorkingSet->indexLB,
                 WorkingSet->sizes[3], TrialState->lambdasqp);
  st.site = &ff_emlrtRSI;
  idx_max = ixamax(&st, WorkingSet->nVar, TrialState->grad);
  optimRelativeFactor = muDoubleScalarMax(1.0, muDoubleScalarAbs
    (TrialState->grad[idx_max - 1]));
  if (muDoubleScalarIsInf(optimRelativeFactor)) {
    optimRelativeFactor = 1.0;
  }

  st.site = &ff_emlrtRSI;
  MeritFunction->nlpPrimalFeasError = computePrimalFeasError(&st,
    TrialState->cIneq, TrialState->cEq, WorkingSet->indexLB, WorkingSet->sizes[3]);
  if (TrialState->sqpIterations == 0) {
    MeritFunction->feasRelativeFactor = muDoubleScalarMax(1.0,
      MeritFunction->nlpPrimalFeasError);
  }

  isFeasible = (MeritFunction->nlpPrimalFeasError <= 1.0E-6 *
                MeritFunction->feasRelativeFactor);
  st.site = &ff_emlrtRSI;
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
    st.site = &ff_emlrtRSI;
    MeritFunction->nlpComplError = computeComplError(&st, TrialState->cIneq,
      WorkingSet->indexLB, WorkingSet->sizes[3], TrialState->lambdasqp, 89);
    MeritFunction->firstOrderOpt = muDoubleScalarMax
      (MeritFunction->nlpDualFeasError, MeritFunction->nlpComplError);
    if (TrialState->sqpIterations > 1) {
      st.site = &ff_emlrtRSI;
      b_computeGradLag(&st, memspace->workspace_double, WorkingSet->nVar,
                       TrialState->grad, WorkingSet->Aineq, WorkingSet->Aeq,
                       WorkingSet->indexLB, WorkingSet->sizes[3],
                       TrialState->lambdasqp_old);
      st.site = &ff_emlrtRSI;
      b_computeDualFeasError(&st, WorkingSet->nVar, memspace->workspace_double,
        &dxTooSmall, &nlpDualFeasErrorTmp);
      st.site = &ff_emlrtRSI;
      nlpComplErrorTmp = computeComplError(&st, TrialState->cIneq,
        WorkingSet->indexLB, WorkingSet->sizes[3], TrialState->lambdasqp_old, 1);
      d = muDoubleScalarMax(nlpDualFeasErrorTmp, nlpComplErrorTmp);
      if (d < muDoubleScalarMax(MeritFunction->nlpDualFeasError,
           MeritFunction->nlpComplError)) {
        MeritFunction->nlpDualFeasError = nlpDualFeasErrorTmp;
        MeritFunction->nlpComplError = nlpComplErrorTmp;
        MeritFunction->firstOrderOpt = d;
        b_xcopy(WorkingSet->sizes[3] + 264, TrialState->lambdasqp_old,
                TrialState->lambdasqp);
      } else {
        b_xcopy(WorkingSet->sizes[3] + 264, TrialState->lambdasqp,
                TrialState->lambdasqp_old);
      }
    } else {
      b_xcopy(WorkingSet->sizes[3] + 264, TrialState->lambdasqp,
              TrialState->lambdasqp_old);
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
          st.site = &ff_emlrtRSI;
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
              idx_max = WorkingSet->nActiveConstr;
              if (WorkingSet->nActiveConstr > 0) {
                st.site = &ff_emlrtRSI;
                updateWorkingSetForNewQP(&st, WorkingSet, TrialState->cIneq,
                  TrialState->cEq);
                st.site = &ff_emlrtRSI;
                computeLambdaLSQ(&st, nVar, idx_max, QRManager,
                                 WorkingSet->ATwset, TrialState->grad,
                                 TrialState->lambda, memspace->workspace_double);
                for (idx_max = 0; idx_max < 88; idx_max++) {
                  TrialState->lambda[idx_max] = -TrialState->lambda[idx_max];
                }

                st.site = &ff_emlrtRSI;
                sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
                             WorkingSet->sizes, WorkingSet->isActiveIdx,
                             WorkingSet->Wid, WorkingSet->Wlocalidx,
                             memspace->workspace_double);
                st.site = &ff_emlrtRSI;
                b_computeGradLag(&st, memspace->workspace_double, nVar,
                                 TrialState->grad, WorkingSet->Aineq,
                                 WorkingSet->Aeq, WorkingSet->indexLB, mLB,
                                 TrialState->lambda);
                st.site = &ff_emlrtRSI;
                b_computeDualFeasError(&st, nVar, memspace->workspace_double,
                  &dxTooSmall, &nlpDualFeasErrorTmp);
                st.site = &ff_emlrtRSI;
                nlpComplErrorTmp = computeComplError(&st, TrialState->cIneq,
                  WorkingSet->indexLB, mLB, TrialState->lambda, 1);
                if ((nlpDualFeasErrorTmp <= 1.0E-6 * optimRelativeFactor) &&
                    (nlpComplErrorTmp <= 1.0E-6 * optimRelativeFactor)) {
                  MeritFunction->nlpDualFeasError = nlpDualFeasErrorTmp;
                  MeritFunction->nlpComplError = nlpComplErrorTmp;
                  MeritFunction->firstOrderOpt = muDoubleScalarMax
                    (nlpDualFeasErrorTmp, nlpComplErrorTmp);
                  b_xcopy(mLB + 264, TrialState->lambda, TrialState->lambdasqp);
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
          if (TrialState->sqpIterations >= 400) {
            Flags->done = true;
            TrialState->sqpExitFlag = 0;
          } else {
            if (TrialState->FunctionEvaluations >= 13200) {
              Flags->done = true;
              TrialState->sqpExitFlag = 0;
            }
          }
        }
      }
    }
  }
}

/* End of code generation (test_exit.c) */
