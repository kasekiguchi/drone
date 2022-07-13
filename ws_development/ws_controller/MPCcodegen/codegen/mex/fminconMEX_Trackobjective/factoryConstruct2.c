/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factoryConstruct2.c
 *
 * Code generation for function 'factoryConstruct2'
 *
 */

/* Include files */
#include "factoryConstruct2.h"
#include "computeConstrViolationIneq_.h"
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "blas.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo mb_emlrtRSI = { 1,  /* lineNo */
  "factoryConstruct",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\factoryConstruct.p"/* pathName */
};

/* Function Definitions */
void c_factoryConstruct(const emlrtStack *sp, real_T fval, const emxArray_real_T
  *Cineq_workspace, int32_T mNonlinIneq, const emxArray_real_T *Ceq_workspace,
  int32_T mNonlinEq, k_struct_T *obj)
{
  ptrdiff_t incx_t;
  ptrdiff_t n_t;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  obj->penaltyParam = 1.0;
  obj->threshold = 0.0001;
  obj->nPenaltyDecreases = 0;
  obj->linearizedConstrViol = 0.0;
  obj->initFval = fval;
  n_t = (ptrdiff_t)mNonlinEq;
  incx_t = (ptrdiff_t)1;
  obj->initConstrViolationEq = dasum(&n_t, &Ceq_workspace->data[0], &incx_t);
  st.site = &mb_emlrtRSI;
  computeConstrViolationIneq_(&st, mNonlinIneq, Cineq_workspace);
  obj->initConstrViolationIneq = 0.0;
  obj->phi = 0.0;
  obj->phiPrimePlus = 0.0;
  obj->phiFullStep = 0.0;
  obj->feasRelativeFactor = 0.0;
  obj->nlpPrimalFeasError = 0.0;
  obj->nlpDualFeasError = 0.0;
  obj->nlpComplError = 0.0;
  obj->firstOrderOpt = 0.0;
  obj->hasObjective = true;
}

/* End of code generation (factoryConstruct2.c) */
