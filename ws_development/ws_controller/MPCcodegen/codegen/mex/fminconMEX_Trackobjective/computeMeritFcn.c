/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeMeritFcn.c
 *
 * Code generation for function 'computeMeritFcn'
 *
 */

/* Include files */
#include "computeMeritFcn.h"
#include "computeConstrViolationIneq_.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo vf_emlrtRSI = { 1,  /* lineNo */
  "computeMeritFcn",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeMeritFcn.p"/* pathName */
};

/* Function Definitions */
real_T computeMeritFcn(const emlrtStack *sp, real_T obj_penaltyParam, real_T
  fval, const emxArray_real_T *Cineq_workspace, int32_T mIneq, const
  emxArray_real_T *Ceq_workspace, int32_T mEq, boolean_T evalWellDefined)
{
  ptrdiff_t incx_t;
  ptrdiff_t n_t;
  emlrtStack st;
  real_T constrViolationEq;
  real_T constrViolationIneq;
  real_T val;
  st.prev = sp;
  st.tls = sp->tls;
  if (evalWellDefined) {
    n_t = (ptrdiff_t)mEq;
    incx_t = (ptrdiff_t)1;
    constrViolationEq = dasum(&n_t, &Ceq_workspace->data[0], &incx_t);
    st.site = &vf_emlrtRSI;
    constrViolationIneq = computeConstrViolationIneq_(&st, mIneq,
      Cineq_workspace);
    val = fval + obj_penaltyParam * (constrViolationEq + constrViolationIneq);
  } else {
    val = rtInf;
  }

  return val;
}

/* End of code generation (computeMeritFcn.c) */
