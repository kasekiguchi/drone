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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "computeConstraints_.h"
#include "computeObjective_.h"
#include "eml_int_forloop_overflow_check.h"
#include "isDeltaXTooSmall.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xaxpy.h"
#include "xcopy.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo rk_emlrtRSI = { 1,  /* lineNo */
  "linesearch",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p"/* pathName */
};

static emlrtBCInfo cf_emlrtBCI = { 1,  /* iFirst */
  132,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "linesearch",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo df_emlrtBCI = { 1,  /* iFirst */
  132,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "linesearch",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void linesearch(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, boolean_T
                *evalWellDefined, int32_T WorkingSet_nVar, e_struct_T
                *TrialState, real_T MeritFunction_penaltyParam, real_T
                MeritFunction_phi, real_T MeritFunction_phiPrimePlus, real_T
                MeritFunction_phiFullStep, const struct0_T
                c_FcnEvaluator_objfun_tunableEn[1], const struct0_T
                c_FcnEvaluator_nonlcon_tunableE[1], boolean_T socTaken, real_T
                *alpha, int32_T *exitflag)
{
  real_T phi_alpha;
  int32_T exitg1;
  int32_T idx;
  boolean_T tooSmallX;
  int32_T status;
  real_T Cineq_workspace[176];
  real_T Ceq_workspace[88];
  int32_T i;
  real_T constrViolationEq;
  real_T constrViolationIneq;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  *alpha = 1.0;
  *exitflag = 1;
  phi_alpha = MeritFunction_phiFullStep;
  st.site = &rk_emlrtRSI;
  g_xcopy(&st, WorkingSet_nVar, TrialState->delta_x, TrialState->searchDir);
  do {
    exitg1 = 0;
    if (TrialState->FunctionEvaluations < 13200) {
      if ((*evalWellDefined) && (phi_alpha <= MeritFunction_phi + *alpha *
           0.0001 * MeritFunction_phiPrimePlus)) {
        exitg1 = 1;
      } else {
        *alpha *= 0.7;
        st.site = &rk_emlrtRSI;
        if ((1 <= WorkingSet_nVar) && (WorkingSet_nVar > 2147483646)) {
          b_st.site = &t_emlrtRSI;
          check_forloop_overflow_error(&b_st);
        }

        for (idx = 0; idx < WorkingSet_nVar; idx++) {
          TrialState->delta_x[idx] = *alpha * TrialState->searchDir[idx];
        }

        if (socTaken) {
          st.site = &rk_emlrtRSI;
          b_xaxpy(WorkingSet_nVar, *alpha * *alpha, TrialState->socDirection,
                  TrialState->delta_x);
        }

        st.site = &rk_emlrtRSI;
        tooSmallX = isDeltaXTooSmall(&st, TrialState->xstarsqp,
          TrialState->delta_x, WorkingSet_nVar);
        if (tooSmallX) {
          *exitflag = -2;
          exitg1 = 1;
        } else {
          st.site = &rk_emlrtRSI;
          for (idx = 0; idx < WorkingSet_nVar; idx++) {
            status = idx + 1;
            if ((status < 1) || (status > 132)) {
              emlrtDynamicBoundsCheckR2012b(status, 1, 132, &cf_emlrtBCI, sp);
            }

            i = idx + 1;
            if ((i < 1) || (i > 132)) {
              emlrtDynamicBoundsCheckR2012b(i, 1, 132, &df_emlrtBCI, sp);
            }

            TrialState->xstarsqp[i - 1] = TrialState->xstarsqp_old[status - 1] +
              TrialState->delta_x[idx];
          }

          st.site = &rk_emlrtRSI;
          memcpy(&Cineq_workspace[0], &TrialState->cIneq[0], 176U * sizeof
                 (real_T));
          memcpy(&Ceq_workspace[0], &TrialState->cEq[0], 88U * sizeof(real_T));
          b_st.site = &pk_emlrtRSI;
          computeObjective_(&b_st, c_FcnEvaluator_objfun_tunableEn,
                            TrialState->xstarsqp, &phi_alpha, &status);
          if (status == 1) {
            b_st.site = &pk_emlrtRSI;
            status = computeConstraints_(SD, &b_st,
              c_FcnEvaluator_nonlcon_tunableE, TrialState->xstarsqp,
              Cineq_workspace, Ceq_workspace);
          }

          TrialState->sqpFval = phi_alpha;
          memcpy(&TrialState->cIneq[0], &Cineq_workspace[0], 176U * sizeof
                 (real_T));
          memcpy(&TrialState->cEq[0], &Ceq_workspace[0], 88U * sizeof(real_T));
          TrialState->FunctionEvaluations++;
          *evalWellDefined = (status == 1);
          st.site = &rk_emlrtRSI;
          if (*evalWellDefined) {
            constrViolationEq = 0.0;
            for (status = 0; status < 88; status++) {
              constrViolationEq += muDoubleScalarAbs(Ceq_workspace[status]);
            }

            constrViolationIneq = 0.0;
            for (idx = 0; idx < 176; idx++) {
              if (Cineq_workspace[idx] > 0.0) {
                constrViolationIneq += Cineq_workspace[idx];
              }
            }

            phi_alpha += MeritFunction_penaltyParam * (constrViolationEq +
              constrViolationIneq);
          } else {
            phi_alpha = rtInf;
          }
        }
      }
    } else {
      *exitflag = 0;
      exitg1 = 1;
    }
  } while (exitg1 == 0);
}

/* End of code generation (linesearch.c) */
