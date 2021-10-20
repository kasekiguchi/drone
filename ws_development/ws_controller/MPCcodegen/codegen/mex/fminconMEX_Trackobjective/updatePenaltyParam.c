/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * updatePenaltyParam.c
 *
 * Code generation for function 'updatePenaltyParam'
 *
 */

/* Include files */
#include "updatePenaltyParam.h"
#include "computeConstrViolationIneq_.h"
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo jf_emlrtRSI = { 1,  /* lineNo */
  "updatePenaltyParam",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\updatePenaltyParam.p"/* pathName */
};

/* Function Definitions */
void b_updatePenaltyParam(const emlrtStack *sp, k_struct_T *obj, real_T fval,
  const emxArray_real_T *ineq_workspace, int32_T mIneq, const emxArray_real_T
  *eq_workspace, int32_T mEq, int32_T sqpiter, real_T qpval, const
  emxArray_real_T *x, int32_T iReg0, int32_T nRegularized)
{
  ptrdiff_t incx_t;
  ptrdiff_t n_t;
  emlrtStack st;
  real_T constrViolationEq;
  real_T constrViolationIneq;
  real_T penaltyParamTrial;
  st.prev = sp;
  st.tls = sp->tls;
  penaltyParamTrial = obj->penaltyParam;
  n_t = (ptrdiff_t)mEq;
  incx_t = (ptrdiff_t)1;
  constrViolationEq = dasum(&n_t, &eq_workspace->data[0], &incx_t);
  st.site = &jf_emlrtRSI;
  constrViolationIneq = computeConstrViolationIneq_(&st, mIneq, ineq_workspace);
  constrViolationIneq += constrViolationEq;
  constrViolationEq = obj->linearizedConstrViol;
  if (nRegularized < 1) {
    obj->linearizedConstrViol = 0.0;
  } else {
    n_t = (ptrdiff_t)nRegularized;
    incx_t = (ptrdiff_t)1;
    obj->linearizedConstrViol = dasum(&n_t, &x->data[iReg0 - 1], &incx_t);
  }

  constrViolationEq = (constrViolationIneq + constrViolationEq) -
    obj->linearizedConstrViol;
  if ((constrViolationEq > 2.2204460492503131E-16) && (qpval > 0.0)) {
    if (fval == 0.0) {
      penaltyParamTrial = 1.0;
    } else {
      penaltyParamTrial = 1.5;
    }

    penaltyParamTrial = penaltyParamTrial * qpval / constrViolationEq;
  }

  if (penaltyParamTrial < obj->penaltyParam) {
    obj->phi = fval + penaltyParamTrial * constrViolationIneq;
    if ((obj->initFval + penaltyParamTrial * obj->initConstrViolationEq) -
        obj->phi > (real_T)obj->nPenaltyDecreases * obj->threshold) {
      obj->nPenaltyDecreases++;
      if ((obj->nPenaltyDecreases << 1) > sqpiter) {
        obj->threshold *= 10.0;
      }

      obj->penaltyParam = muDoubleScalarMax(penaltyParamTrial, 1.0E-10);
    } else {
      obj->phi = fval + obj->penaltyParam * constrViolationIneq;
    }
  } else {
    obj->penaltyParam = muDoubleScalarMax(penaltyParamTrial, 1.0E-10);
    obj->phi = fval + obj->penaltyParam * constrViolationIneq;
  }

  obj->phiPrimePlus = muDoubleScalarMin(qpval - obj->penaltyParam *
    constrViolationIneq, 0.0);
}

void updatePenaltyParam(const emlrtStack *sp, k_struct_T *obj, real_T fval,
  const emxArray_real_T *ineq_workspace, int32_T mIneq, const emxArray_real_T
  *eq_workspace, int32_T mEq, int32_T sqpiter, real_T qpval)
{
  ptrdiff_t incx_t;
  ptrdiff_t n_t;
  emlrtStack st;
  real_T constrViolationEq;
  real_T constrViolationIneq;
  real_T penaltyParamTrial;
  st.prev = sp;
  st.tls = sp->tls;
  penaltyParamTrial = obj->penaltyParam;
  n_t = (ptrdiff_t)mEq;
  incx_t = (ptrdiff_t)1;
  constrViolationEq = dasum(&n_t, &eq_workspace->data[0], &incx_t);
  st.site = &jf_emlrtRSI;
  constrViolationIneq = computeConstrViolationIneq_(&st, mIneq, ineq_workspace);
  constrViolationIneq += constrViolationEq;
  constrViolationEq = obj->linearizedConstrViol;
  obj->linearizedConstrViol = 0.0;
  constrViolationEq += constrViolationIneq;
  if ((constrViolationEq > 2.2204460492503131E-16) && (qpval > 0.0)) {
    if (fval == 0.0) {
      penaltyParamTrial = 1.0;
    } else {
      penaltyParamTrial = 1.5;
    }

    penaltyParamTrial = penaltyParamTrial * qpval / constrViolationEq;
  }

  if (penaltyParamTrial < obj->penaltyParam) {
    obj->phi = fval + penaltyParamTrial * constrViolationIneq;
    if ((obj->initFval + penaltyParamTrial * obj->initConstrViolationEq) -
        obj->phi > (real_T)obj->nPenaltyDecreases * obj->threshold) {
      obj->nPenaltyDecreases++;
      if ((obj->nPenaltyDecreases << 1) > sqpiter) {
        obj->threshold *= 10.0;
      }

      obj->penaltyParam = muDoubleScalarMax(penaltyParamTrial, 1.0E-10);
    } else {
      obj->phi = fval + obj->penaltyParam * constrViolationIneq;
    }
  } else {
    obj->penaltyParam = muDoubleScalarMax(penaltyParamTrial, 1.0E-10);
    obj->phi = fval + obj->penaltyParam * constrViolationIneq;
  }

  obj->phiPrimePlus = muDoubleScalarMin(qpval - obj->penaltyParam *
    constrViolationIneq, 0.0);
}

/* End of code generation (updatePenaltyParam.c) */
