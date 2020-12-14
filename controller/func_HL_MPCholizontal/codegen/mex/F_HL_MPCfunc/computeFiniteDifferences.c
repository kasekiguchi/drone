/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeFiniteDifferences.c
 *
 * Code generation for function 'computeFiniteDifferences'
 *
 */

/* Include files */
#include "computeFiniteDifferences.h"
#include "F_HL_MPCfunc.h"
#include "finDiffEvalAndChkErr.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo te_emlrtRSI = { 1,  /* lineNo */
  "computeFiniteDifferences",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\computeFiniteDifferences.p"/* pathName */
};

static emlrtRSInfo ue_emlrtRSI = { 1,  /* lineNo */
  "computeForwardDifferences",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\computeForwardDifferences.p"/* pathName */
};

/* Function Definitions */
boolean_T computeFiniteDifferences(F_HL_MPCfuncStackData *SD, const emlrtStack
  *sp, h_struct_T *obj, real_T fCurrent, const real_T cIneqCurrent[176], const
  real_T cEqCurrent[88], real_T xk[132], real_T gradf[485], real_T
  JacCineqTrans[85360], real_T JacCeqTrans[42680])
{
  boolean_T evalOK;
  int32_T idx;
  boolean_T exitg1;
  real_T deltaX;
  struct0_T t0_objfun_tunableEnvironment[1];
  struct0_T t0_nonlin_tunableEnvironment[1];
  boolean_T guard1 = false;
  int32_T idx_row;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &te_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  evalOK = true;
  obj->numEvals = 0;
  idx = 0;
  exitg1 = false;
  while ((!exitg1) && (idx < 132)) {
    deltaX = 1.4901161193847656E-8 * (1.0 - 2.0 * (real_T)(xk[idx] < 0.0)) *
      muDoubleScalarMax(muDoubleScalarAbs(xk[idx]), 1.0);
    t0_objfun_tunableEnvironment[0] = obj->objfun.tunableEnvironment[0];
    t0_nonlin_tunableEnvironment[0] = obj->nonlin.tunableEnvironment[0];
    b_st.site = &ue_emlrtRSI;
    evalOK = finDiffEvalAndChkErr(SD, &b_st, t0_objfun_tunableEnvironment,
      t0_nonlin_tunableEnvironment, &obj->f_1, obj->cIneq_1, obj->cEq_1, idx + 1,
      deltaX, xk);
    obj->numEvals++;
    guard1 = false;
    if (!evalOK) {
      deltaX = -deltaX;
      t0_objfun_tunableEnvironment[0] = obj->objfun.tunableEnvironment[0];
      t0_nonlin_tunableEnvironment[0] = obj->nonlin.tunableEnvironment[0];
      b_st.site = &ue_emlrtRSI;
      evalOK = finDiffEvalAndChkErr(SD, &b_st, t0_objfun_tunableEnvironment,
        t0_nonlin_tunableEnvironment, &obj->f_1, obj->cIneq_1, obj->cEq_1, idx +
        1, deltaX, xk);
      obj->numEvals++;
      if (!evalOK) {
        exitg1 = true;
      } else {
        guard1 = true;
      }
    } else {
      guard1 = true;
    }

    if (guard1) {
      gradf[idx] = (obj->f_1 - fCurrent) / deltaX;
      for (idx_row = 0; idx_row < 176; idx_row++) {
        JacCineqTrans[idx + 485 * idx_row] = (obj->cIneq_1[idx_row] -
          cIneqCurrent[idx_row]) / deltaX;
      }

      for (idx_row = 0; idx_row < 88; idx_row++) {
        JacCeqTrans[idx + 485 * idx_row] = (obj->cEq_1[idx_row] -
          cEqCurrent[idx_row]) / deltaX;
      }

      idx++;
    }
  }

  return evalOK;
}

/* End of code generation (computeFiniteDifferences.c) */
