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
#include "eml_int_forloop_overflow_check.h"
#include "finDiffEvalAndChkErr.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo bb_emlrtRSI = { 1,  /* lineNo */
  "computeFiniteDifferences",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\computeFiniteDifferences.p"/* pathName */
};

static emlrtRSInfo cb_emlrtRSI = { 1,  /* lineNo */
  "computeForwardDifferences",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\computeForwardDifferences.p"/* pathName */
};

static emlrtBCInfo eb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeForwardDifferences",         /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\computeForwardDifferences.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
boolean_T computeFiniteDifferences(const emlrtStack *sp, e_struct_T *obj, real_T
  fCurrent, const emxArray_real_T *cIneqCurrent, int32_T ineq0, const
  emxArray_real_T *cEqCurrent, int32_T eq0, real_T xk[66], emxArray_real_T
  *gradf, emxArray_real_T *JacCineqTrans, int32_T CineqColStart, emxArray_real_T
  *JacCeqTrans, int32_T CeqColStart)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T deltaX;
  int32_T b;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T idx;
  int32_T idx_row;
  boolean_T evalOK;
  boolean_T exitg1;
  boolean_T guard1 = false;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &bb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  evalOK = true;
  obj->numEvals = 0;
  b_st.site = &cb_emlrtRSI;
  idx = 0;
  exitg1 = false;
  while ((!exitg1) && (idx < 66)) {
    deltaX = 1.4901161193847656E-8 * (1.0 - 2.0 * (real_T)(xk[idx] < 0.0)) *
      muDoubleScalarMax(muDoubleScalarAbs(xk[idx]), 1.0);
    b_st.site = &cb_emlrtRSI;
    evalOK = finDiffEvalAndChkErr(&b_st, obj->objfun.tunableEnvironment,
      obj->nonlin.tunableEnvironment, obj->mIneq, obj->mEq, &obj->f_1,
      obj->cIneq_1, obj->cEq_1, idx + 1, deltaX, xk);
    obj->numEvals++;
    guard1 = false;
    if (!evalOK) {
      deltaX = -deltaX;
      b_st.site = &cb_emlrtRSI;
      evalOK = finDiffEvalAndChkErr(&b_st, obj->objfun.tunableEnvironment,
        obj->nonlin.tunableEnvironment, obj->mIneq, obj->mEq, &obj->f_1,
        obj->cIneq_1, obj->cEq_1, idx + 1, deltaX, xk);
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
      gradf->data[idx] = (obj->f_1 - fCurrent) / deltaX;
      b = obj->mIneq;
      b_st.site = &cb_emlrtRSI;
      if ((1 <= obj->mIneq) && (obj->mIneq > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx_row = 0; idx_row < b; idx_row++) {
        i = obj->cIneq_1->size[0];
        if ((idx_row + 1 < 1) || (idx_row + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_row + 1, 1, i, &eb_emlrtBCI, &st);
        }

        i = ineq0 + idx_row;
        if ((i < 1) || (i > cIneqCurrent->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i, 1, cIneqCurrent->size[0],
            &eb_emlrtBCI, &st);
        }

        i1 = JacCineqTrans->size[0];
        if (idx + 1 > i1) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i1, &eb_emlrtBCI, &st);
        }

        i1 = JacCineqTrans->size[1];
        i2 = CineqColStart + idx_row;
        if ((i2 < 1) || (i2 > i1)) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &eb_emlrtBCI, &st);
        }

        JacCineqTrans->data[idx + JacCineqTrans->size[0] * (i2 - 1)] =
          (obj->cIneq_1->data[idx_row] - cIneqCurrent->data[i - 1]) / deltaX;
      }

      b = obj->mEq;
      b_st.site = &cb_emlrtRSI;
      if ((1 <= obj->mEq) && (obj->mEq > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx_row = 0; idx_row < b; idx_row++) {
        i = obj->cEq_1->size[0];
        if ((idx_row + 1 < 1) || (idx_row + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_row + 1, 1, i, &eb_emlrtBCI, &st);
        }

        i = eq0 + idx_row;
        if ((i < 1) || (i > cEqCurrent->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i, 1, cEqCurrent->size[0], &eb_emlrtBCI,
            &st);
        }

        i1 = JacCeqTrans->size[1];
        i2 = CeqColStart + idx_row;
        if ((i2 < 1) || (i2 > i1)) {
          emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &eb_emlrtBCI, &st);
        }

        JacCeqTrans->data[idx + JacCeqTrans->size[0] * (i2 - 1)] = (obj->
          cEq_1->data[idx_row] - cEqCurrent->data[i - 1]) / deltaX;
      }

      idx++;
    }
  }

  return evalOK;
}

/* End of code generation (computeFiniteDifferences.c) */
