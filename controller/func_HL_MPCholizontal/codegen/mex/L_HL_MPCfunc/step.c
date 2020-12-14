/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * step.c
 *
 * Code generation for function 'step'
 *
 */

/* Include files */
#include "step.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "normal.h"
#include "relaxed.h"
#include "rt_nonfinite.h"
#include "soc.h"
#include "xcopy.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo rd_emlrtRSI = { 1,  /* lineNo */
  "step",                              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\step.p"/* pathName */
};

static emlrtRSInfo xf_emlrtRSI = { 1,  /* lineNo */
  "BFGSReset",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\BFGSReset.p"/* pathName */
};

/* Function Definitions */
boolean_T step(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, int32_T
               *STEP_TYPE, real_T Hessian[12100], e_struct_T *TrialState,
               i_struct_T *MeritFunction, b_struct_T *memspace, g_struct_T
               *WorkingSet, k_struct_T *QRManager, l_struct_T *CholManager,
               j_struct_T *QPObjective, c_struct_T *qpoptions)
{
  boolean_T stepSuccess;
  int32_T nVar;
  int32_T exitg1;
  boolean_T guard1 = false;
  real_T dv[307];
  int32_T iH0;
  real_T nrmGradInf;
  real_T nrmDirInf;
  int32_T idx_col;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  stepSuccess = true;
  nVar = WorkingSet->nVar;
  if (*STEP_TYPE != 3) {
    st.site = &rd_emlrtRSI;
    e_xcopy(&st, WorkingSet->nVar, TrialState->xstarsqp, TrialState->xstar);
  } else {
    st.site = &rd_emlrtRSI;
    f_xcopy(&st, WorkingSet->nVar, TrialState->xstar, TrialState->searchDir);
  }

  do {
    exitg1 = 0;
    guard1 = false;
    switch (*STEP_TYPE) {
     case 1:
      SD->f1.TrialState = *TrialState;
      st.site = &rd_emlrtRSI;
      normal(SD, &st, Hessian, TrialState->grad, &SD->f1.TrialState,
             MeritFunction, memspace, WorkingSet, QRManager, CholManager,
             QPObjective, qpoptions);
      *TrialState = SD->f1.TrialState;
      if ((SD->f1.TrialState.state <= 0) && (SD->f1.TrialState.state != -6)) {
        *STEP_TYPE = 2;
      } else {
        memcpy(&TrialState->delta_x[0], &SD->f1.TrialState.delta_x[0], 307U *
               sizeof(real_T));
        st.site = &rd_emlrtRSI;
        f_xcopy(&st, nVar, SD->f1.TrialState.xstar, TrialState->delta_x);
        guard1 = true;
      }
      break;

     case 2:
      SD->f1.TrialState = *TrialState;
      st.site = &rd_emlrtRSI;
      relaxed(SD, &st, Hessian, TrialState->grad, &SD->f1.TrialState,
              MeritFunction, memspace, WorkingSet, QRManager, CholManager,
              QPObjective, qpoptions);
      *TrialState = SD->f1.TrialState;
      memcpy(&TrialState->delta_x[0], &SD->f1.TrialState.delta_x[0], 307U *
             sizeof(real_T));
      st.site = &rd_emlrtRSI;
      f_xcopy(&st, nVar, SD->f1.TrialState.xstar, TrialState->delta_x);
      guard1 = true;
      break;

     default:
      memcpy(&dv[0], &TrialState->grad[0], 307U * sizeof(real_T));
      st.site = &rd_emlrtRSI;
      stepSuccess = soc(SD, &st, Hessian, dv, TrialState, memspace, WorkingSet,
                        QRManager, CholManager, QPObjective, qpoptions);
      if (stepSuccess && (TrialState->state != -6)) {
        st.site = &rd_emlrtRSI;
        if ((1 <= nVar) && (nVar > 2147483646)) {
          b_st.site = &e_emlrtRSI;
          check_forloop_overflow_error(&b_st);
        }

        for (iH0 = 0; iH0 < nVar; iH0++) {
          TrialState->delta_x[iH0] = TrialState->xstar[iH0] +
            TrialState->socDirection[iH0];
        }
      }

      guard1 = true;
      break;
    }

    if (guard1) {
      if (TrialState->state != -6) {
        exitg1 = 1;
      } else {
        st.site = &rd_emlrtRSI;
        nrmGradInf = 0.0;
        nrmDirInf = 1.0;
        for (iH0 = 0; iH0 < 110; iH0++) {
          nrmGradInf = muDoubleScalarMax(nrmGradInf, muDoubleScalarAbs
            (TrialState->grad[iH0]));
          nrmDirInf = muDoubleScalarMax(nrmDirInf, muDoubleScalarAbs
            (TrialState->xstar[iH0]));
        }

        nrmGradInf = muDoubleScalarMax(2.2204460492503131E-16, nrmGradInf /
          nrmDirInf);
        for (idx_col = 0; idx_col < 110; idx_col++) {
          iH0 = 110 * idx_col;
          b_st.site = &xf_emlrtRSI;
          g_xcopy(&b_st, idx_col, Hessian, iH0 + 1);
          Hessian[idx_col + 110 * idx_col] = nrmGradInf;
          iH0 += idx_col;
          b_st.site = &xf_emlrtRSI;
          g_xcopy(&b_st, 109 - idx_col, Hessian, iH0 + 2);
        }
      }
    }
  } while (exitg1 == 0);

  return stepSuccess;
}

/* End of code generation (step.c) */
