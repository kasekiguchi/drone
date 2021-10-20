/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * linesearch.c
 *
 * Code generation for function 'linesearch'
 *
 */

/* Include files */
#include "linesearch.h"
#include "computeConstraints_.h"
#include "computeLinearResiduals.h"
#include "computeMeritFcn.h"
#include "computeObjective_.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "isDeltaXTooSmall.h"
#include "rt_nonfinite.h"
#include "xaxpy.h"
#include "xcopy.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo wf_emlrtRSI = { 1,  /* lineNo */
  "linesearch",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p"/* pathName */
};

static emlrtBCInfo rd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "linesearch",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sd_emlrtBCI = { 1,  /* iFirst */
  77,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "linesearch",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo td_emlrtBCI = { 1,  /* iFirst */
  77,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "linesearch",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void linesearch(const emlrtStack *sp, boolean_T *evalWellDefined, int32_T
                WorkingSet_nVar, int32_T WorkingSet_ldA, const emxArray_real_T
                *WorkingSet_Aineq, const emxArray_real_T *WorkingSet_Aeq,
                d_struct_T *TrialState, real_T MeritFunction_penaltyParam,
                real_T MeritFunction_phi, real_T MeritFunction_phiPrimePlus,
                real_T MeritFunction_phiFullStep, const struct0_T
                c_FcnEvaluator_objfun_tunableEn[1], const struct0_T
                c_FcnEvaluator_nonlcon_tunableE[1], int32_T FcnEvaluator_mCineq,
                int32_T FcnEvaluator_mCeq, boolean_T socTaken, real_T *alpha,
                int32_T *exitflag)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T b_TrialState[77];
  real_T phi_alpha;
  int32_T exitg1;
  int32_T idx;
  int32_T mLinEq;
  int32_T mLinIneq;
  int32_T status;
  boolean_T tooSmallX;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  mLinIneq = TrialState->mIneq - TrialState->mNonlinIneq;
  mLinEq = TrialState->mEq - TrialState->mNonlinEq;
  *alpha = 1.0;
  *exitflag = 1;
  phi_alpha = MeritFunction_phiFullStep;
  st.site = &wf_emlrtRSI;
  b_xcopy(WorkingSet_nVar, TrialState->delta_x, TrialState->searchDir);
  do {
    exitg1 = 0;
    if (TrialState->FunctionEvaluations < 1000000000) {
      if ((*evalWellDefined) && (phi_alpha <= MeritFunction_phi + *alpha *
           0.0001 * MeritFunction_phiPrimePlus)) {
        exitg1 = 1;
      } else {
        *alpha *= 0.7;
        st.site = &wf_emlrtRSI;
        if ((1 <= WorkingSet_nVar) && (WorkingSet_nVar > 2147483646)) {
          b_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&b_st);
        }

        for (idx = 0; idx < WorkingSet_nVar; idx++) {
          status = TrialState->xstar->size[0];
          if ((idx + 1 < 1) || (idx + 1 > status)) {
            emlrtDynamicBoundsCheckR2012b(idx + 1, 1, status, &rd_emlrtBCI, sp);
          }

          status = TrialState->delta_x->size[0];
          if ((idx + 1 < 1) || (idx + 1 > status)) {
            emlrtDynamicBoundsCheckR2012b(idx + 1, 1, status, &rd_emlrtBCI, sp);
          }

          TrialState->delta_x->data[idx] = *alpha * TrialState->xstar->data[idx];
        }

        if (socTaken) {
          st.site = &wf_emlrtRSI;
          xaxpy(WorkingSet_nVar, *alpha * *alpha, TrialState->socDirection,
                TrialState->delta_x);
        }

        st.site = &wf_emlrtRSI;
        tooSmallX = isDeltaXTooSmall(&st, TrialState->xstarsqp,
          TrialState->delta_x, WorkingSet_nVar);
        if (tooSmallX) {
          *exitflag = -2;
          exitg1 = 1;
        } else {
          st.site = &wf_emlrtRSI;
          for (idx = 0; idx < WorkingSet_nVar; idx++) {
            if ((idx + 1 < 1) || (idx + 1 > 77)) {
              emlrtDynamicBoundsCheckR2012b(idx + 1, 1, 77, &sd_emlrtBCI, sp);
            }

            status = TrialState->delta_x->size[0];
            if ((idx + 1 < 1) || (idx + 1 > status)) {
              emlrtDynamicBoundsCheckR2012b(idx + 1, 1, status, &rd_emlrtBCI, sp);
            }

            if ((idx + 1 < 1) || (idx + 1 > 77)) {
              emlrtDynamicBoundsCheckR2012b(idx + 1, 1, 77, &td_emlrtBCI, sp);
            }

            TrialState->xstarsqp[idx] = TrialState->xstarsqp_old[idx] +
              TrialState->delta_x->data[idx];
          }

          st.site = &wf_emlrtRSI;
          memcpy(&b_TrialState[0], &TrialState->xstarsqp[0], 77U * sizeof(real_T));
          b_st.site = &tf_emlrtRSI;
          computeObjective_(&b_st, c_FcnEvaluator_objfun_tunableEn, b_TrialState,
                            &TrialState->sqpFval, &status);
          if (status == 1) {
            b_st.site = &tf_emlrtRSI;
            status = computeConstraints_(&b_st, c_FcnEvaluator_nonlcon_tunableE,
              FcnEvaluator_mCineq, FcnEvaluator_mCeq, TrialState->xstarsqp,
              TrialState->cIneq, TrialState->iNonIneq0, TrialState->cEq,
              TrialState->iNonEq0);
          }

          st.site = &wf_emlrtRSI;
          computeLinearResiduals(TrialState->xstarsqp, WorkingSet_nVar,
            TrialState->cIneq, mLinIneq, WorkingSet_Aineq, WorkingSet_ldA,
            TrialState->cEq, mLinEq, WorkingSet_Aeq, WorkingSet_ldA);
          TrialState->FunctionEvaluations++;
          *evalWellDefined = (status == 1);
          st.site = &wf_emlrtRSI;
          phi_alpha = computeMeritFcn(&st, MeritFunction_penaltyParam,
            TrialState->sqpFval, TrialState->cIneq, TrialState->mIneq,
            TrialState->cEq, TrialState->mEq, *evalWellDefined);
        }
      }
    } else {
      *exitflag = 0;
      exitg1 = 1;
    }
  } while (exitg1 == 0);
}

/* End of code generation (linesearch.c) */
