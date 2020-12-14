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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "computeConstraints_.h"
#include "eml_int_forloop_overflow_check.h"
#include "isDeltaXTooSmall.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xaxpy.h"
#include "xcopy.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo bg_emlrtRSI = { 1,  /* lineNo */
  "linesearch",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p"/* pathName */
};

static emlrtBCInfo ee_emlrtBCI = { 1,  /* iFirst */
  110,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "linesearch",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fe_emlrtBCI = { 1,  /* iFirst */
  110,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "linesearch",                        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\linesearch.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void linesearch(const emlrtStack *sp, boolean_T *evalWellDefined, int32_T
                WorkingSet_nVar, e_struct_T *TrialState, real_T
                MeritFunction_penaltyParam, real_T MeritFunction_phi, real_T
                MeritFunction_phiPrimePlus, real_T MeritFunction_phiFullStep,
                const struct0_T c_FcnEvaluator_objfun_tunableEn[1], const real_T
                c_FcnEvaluator_nonlcon_tunableE[8], real_T
                d_FcnEvaluator_nonlcon_tunableE, const real_T
                e_FcnEvaluator_nonlcon_tunableE[64], const real_T
                f_FcnEvaluator_nonlcon_tunableE[16], boolean_T socTaken, real_T *
                alpha, int32_T *exitflag)
{
  real_T phi_alpha;
  int32_T exitg1;
  int32_T idx;
  boolean_T tooSmallX;
  int32_T status;
  real_T dv[20];
  real_T dv1[88];
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
  st.site = &bg_emlrtRSI;
  f_xcopy(&st, WorkingSet_nVar, TrialState->delta_x, TrialState->searchDir);
  do {
    exitg1 = 0;
    if (TrialState->FunctionEvaluations < 11000) {
      if ((*evalWellDefined) && (phi_alpha <= MeritFunction_phi + *alpha *
           0.0001 * MeritFunction_phiPrimePlus)) {
        exitg1 = 1;
      } else {
        *alpha *= 0.7;
        st.site = &bg_emlrtRSI;
        if ((1 <= WorkingSet_nVar) && (WorkingSet_nVar > 2147483646)) {
          b_st.site = &e_emlrtRSI;
          check_forloop_overflow_error(&b_st);
        }

        for (idx = 0; idx < WorkingSet_nVar; idx++) {
          TrialState->delta_x[idx] = *alpha * TrialState->searchDir[idx];
        }

        if (socTaken) {
          st.site = &bg_emlrtRSI;
          b_xaxpy(WorkingSet_nVar, *alpha * *alpha, TrialState->socDirection,
                  TrialState->delta_x);
        }

        st.site = &bg_emlrtRSI;
        tooSmallX = isDeltaXTooSmall(&st, TrialState->xstarsqp,
          TrialState->delta_x, WorkingSet_nVar);
        if (tooSmallX) {
          *exitflag = -2;
          exitg1 = 1;
        } else {
          st.site = &bg_emlrtRSI;
          for (idx = 0; idx < WorkingSet_nVar; idx++) {
            status = idx + 1;
            if ((status < 1) || (status > 110)) {
              emlrtDynamicBoundsCheckR2012b(status, 1, 110, &ee_emlrtBCI, sp);
            }

            i = idx + 1;
            if ((i < 1) || (i > 110)) {
              emlrtDynamicBoundsCheckR2012b(i, 1, 110, &fe_emlrtBCI, sp);
            }

            TrialState->xstarsqp[i - 1] = TrialState->xstarsqp_old[status - 1] +
              TrialState->delta_x[idx];
          }

          st.site = &bg_emlrtRSI;
          memcpy(&dv[0], &TrialState->cIneq[0], 20U * sizeof(real_T));
          memcpy(&dv1[0], &TrialState->cEq[0], 88U * sizeof(real_T));
          phi_alpha = __anon_fcn(c_FcnEvaluator_objfun_tunableEn[0].Q,
            c_FcnEvaluator_objfun_tunableEn[0].Qf,
            c_FcnEvaluator_objfun_tunableEn[0].R,
            c_FcnEvaluator_objfun_tunableEn[0].Xr, TrialState->xstarsqp);
          status = 1;
          if (muDoubleScalarIsInf(phi_alpha) || muDoubleScalarIsNaN(phi_alpha))
          {
            if (muDoubleScalarIsNaN(phi_alpha)) {
              status = -6;
            } else if (phi_alpha < 0.0) {
              status = -4;
            } else {
              status = -5;
            }
          }

          TrialState->sqpFval = phi_alpha;
          if (status == 1) {
            b_st.site = &yf_emlrtRSI;
            status = computeConstraints_(&b_st, c_FcnEvaluator_nonlcon_tunableE,
              d_FcnEvaluator_nonlcon_tunableE, e_FcnEvaluator_nonlcon_tunableE,
              f_FcnEvaluator_nonlcon_tunableE, TrialState->xstarsqp, dv, dv1);
          }

          memcpy(&TrialState->cEq[0], &dv1[0], 88U * sizeof(real_T));
          memcpy(&TrialState->cIneq[0], &dv[0], 20U * sizeof(real_T));
          TrialState->FunctionEvaluations++;
          *evalWellDefined = (status == 1);
          st.site = &bg_emlrtRSI;
          if (*evalWellDefined) {
            constrViolationEq = 0.0;
            for (status = 0; status < 88; status++) {
              constrViolationEq += muDoubleScalarAbs(dv1[status]);
            }

            constrViolationIneq = 0.0;
            for (idx = 0; idx < 20; idx++) {
              if (dv[idx] > 0.0) {
                constrViolationIneq += dv[idx];
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
