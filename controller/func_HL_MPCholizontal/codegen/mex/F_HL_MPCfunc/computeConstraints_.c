/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeConstraints_.c
 *
 * Code generation for function 'computeConstraints_'
 *
 */

/* Include files */
#include "computeConstraints_.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo se_emlrtRSI = { 1,  /* lineNo */
  "computeConstraints_",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\computeConstraints_.p"/* pathName */
};

static emlrtBCInfo ib_emlrtBCI = { 1,  /* iFirst */
  176,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "checkVectorNonFinite",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\+internal\\checkVectorNonFinite.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jb_emlrtBCI = { 1,  /* iFirst */
  88,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "checkVectorNonFinite",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\+internal\\checkVectorNonFinite.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
int32_T computeConstraints_(F_HL_MPCfuncStackData *SD, const emlrtStack *sp,
  const struct0_T obj_nonlcon_tunableEnvironment[1], const real_T x[132], real_T
  Cineq_workspace[176], real_T Ceq_workspace[88])
{
  int32_T status;
  real_T varargout_1[176];
  real_T varargout_2[88];
  boolean_T allFinite;
  int32_T idx_current;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &se_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b_st.site = &d_emlrtRSI;
  __anon_fcn(SD, &b_st, obj_nonlcon_tunableEnvironment[0].state_size,
             obj_nonlcon_tunableEnvironment[0].Num,
             obj_nonlcon_tunableEnvironment[0].Slew,
             obj_nonlcon_tunableEnvironment[0].D_lim,
             obj_nonlcon_tunableEnvironment[0].r_limit,
             obj_nonlcon_tunableEnvironment[0].A,
             obj_nonlcon_tunableEnvironment[0].B,
             obj_nonlcon_tunableEnvironment[0].wall_width_y,
             obj_nonlcon_tunableEnvironment[0].wall_width_x,
             obj_nonlcon_tunableEnvironment[0].sectionpoint,
             obj_nonlcon_tunableEnvironment[0].Section_change,
             obj_nonlcon_tunableEnvironment[0].S_front,
             obj_nonlcon_tunableEnvironment[0].front,
             obj_nonlcon_tunableEnvironment[0].behind,
             obj_nonlcon_tunableEnvironment[0].X0, x, varargout_1, varargout_2);
  memcpy(&Cineq_workspace[0], &varargout_1[0], 176U * sizeof(real_T));
  memcpy(&Ceq_workspace[0], &varargout_2[0], 88U * sizeof(real_T));
  st.site = &se_emlrtRSI;
  status = 1;
  allFinite = true;
  idx_current = 0;
  while (allFinite && (idx_current + 1 <= 176)) {
    allFinite = ((!muDoubleScalarIsInf(Cineq_workspace[idx_current])) &&
                 (!muDoubleScalarIsNaN(Cineq_workspace[idx_current])));
    idx_current++;
  }

  if (!allFinite) {
    if ((idx_current < 1) || (idx_current > 176)) {
      emlrtDynamicBoundsCheckR2012b(idx_current, 1, 176, &ib_emlrtBCI, &st);
    }

    if (muDoubleScalarIsNaN(Cineq_workspace[idx_current - 1])) {
      status = -3;
    } else if (Cineq_workspace[idx_current - 1] < 0.0) {
      status = -1;
    } else {
      status = -2;
    }
  }

  if (status == 1) {
    st.site = &se_emlrtRSI;
    allFinite = true;
    idx_current = 0;
    while (allFinite && (idx_current + 1 <= 88)) {
      allFinite = ((!muDoubleScalarIsInf(Ceq_workspace[idx_current])) &&
                   (!muDoubleScalarIsNaN(Ceq_workspace[idx_current])));
      idx_current++;
    }

    if (!allFinite) {
      if ((idx_current < 1) || (idx_current > 88)) {
        emlrtDynamicBoundsCheckR2012b(idx_current, 1, 88, &jb_emlrtBCI, &st);
      }

      if (muDoubleScalarIsNaN(Ceq_workspace[idx_current - 1])) {
        status = -3;
      } else if (Ceq_workspace[idx_current - 1] < 0.0) {
        status = -1;
      } else {
        status = -2;
      }
    }
  }

  return status;
}

/* End of code generation (computeConstraints_.c) */
