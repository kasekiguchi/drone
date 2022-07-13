/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factoryConstruct.c
 *
 * Code generation for function 'factoryConstruct'
 *
 */

/* Include files */
#include "factoryConstruct.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo y_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "factoryConstruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+TrialState\\factoryConstruct.p"/* pName */
};

/* Function Definitions */
void factoryConstruct(const emlrtStack *sp, int32_T nVarMax, int32_T mConstrMax,
                      int32_T mIneq, int32_T mEq, int32_T mNonlinIneq, int32_T
                      mNonlinEq, d_struct_T *obj)
{
  int32_T i;
  obj->nVarMax = nVarMax;
  obj->mNonlinIneq = mNonlinIneq;
  obj->mNonlinEq = mNonlinEq;
  obj->mIneq = mIneq;
  obj->mEq = mEq;
  obj->iNonIneq0 = (mIneq - mNonlinIneq) + 1;
  obj->iNonEq0 = (mEq - mNonlinEq) + 1;
  obj->sqpFval = 0.0;
  obj->sqpFval_old = 0.0;
  i = obj->cIneq->size[0];
  obj->cIneq->size[0] = mIneq;
  emxEnsureCapacity_real_T(sp, obj->cIneq, i, &y_emlrtRTEI);
  i = obj->cIneq_old->size[0];
  obj->cIneq_old->size[0] = mIneq;
  emxEnsureCapacity_real_T(sp, obj->cIneq_old, i, &y_emlrtRTEI);
  i = obj->cEq->size[0];
  obj->cEq->size[0] = mEq;
  emxEnsureCapacity_real_T(sp, obj->cEq, i, &y_emlrtRTEI);
  i = obj->cEq_old->size[0];
  obj->cEq_old->size[0] = mEq;
  emxEnsureCapacity_real_T(sp, obj->cEq_old, i, &y_emlrtRTEI);
  i = obj->grad->size[0];
  obj->grad->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->grad, i, &y_emlrtRTEI);
  i = obj->grad_old->size[0];
  obj->grad_old->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->grad_old, i, &y_emlrtRTEI);
  obj->FunctionEvaluations = 0;
  obj->sqpIterations = 0;
  obj->sqpExitFlag = 0;
  i = obj->lambdasqp->size[0];
  obj->lambdasqp->size[0] = mConstrMax;
  emxEnsureCapacity_real_T(sp, obj->lambdasqp, i, &y_emlrtRTEI);
  for (i = 0; i < mConstrMax; i++) {
    obj->lambdasqp->data[i] = 0.0;
  }

  i = obj->lambdasqp_old->size[0];
  obj->lambdasqp_old->size[0] = mConstrMax;
  emxEnsureCapacity_real_T(sp, obj->lambdasqp_old, i, &y_emlrtRTEI);
  obj->steplength = 1.0;
  i = obj->delta_x->size[0];
  obj->delta_x->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->delta_x, i, &y_emlrtRTEI);
  for (i = 0; i < nVarMax; i++) {
    obj->delta_x->data[i] = 0.0;
  }

  i = obj->socDirection->size[0];
  obj->socDirection->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->socDirection, i, &y_emlrtRTEI);
  i = obj->lambda_old->size[0];
  obj->lambda_old->size[0] = mConstrMax;
  emxEnsureCapacity_real_T(sp, obj->lambda_old, i, &y_emlrtRTEI);
  i = obj->workingset_old->size[0];
  obj->workingset_old->size[0] = mConstrMax;
  emxEnsureCapacity_int32_T(sp, obj->workingset_old, i, &y_emlrtRTEI);
  if (mNonlinIneq > 0) {
    i = obj->JacCineqTrans_old->size[0] * obj->JacCineqTrans_old->size[1];
    obj->JacCineqTrans_old->size[0] = nVarMax;
    obj->JacCineqTrans_old->size[1] = mNonlinIneq;
    emxEnsureCapacity_real_T(sp, obj->JacCineqTrans_old, i, &y_emlrtRTEI);
  } else {
    obj->JacCineqTrans_old->size[0] = 0;
    obj->JacCineqTrans_old->size[1] = 0;
  }

  i = obj->JacCeqTrans_old->size[0] * obj->JacCeqTrans_old->size[1];
  obj->JacCeqTrans_old->size[0] = nVarMax;
  obj->JacCeqTrans_old->size[1] = mNonlinEq;
  emxEnsureCapacity_real_T(sp, obj->JacCeqTrans_old, i, &y_emlrtRTEI);
  i = obj->gradLag->size[0];
  obj->gradLag->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->gradLag, i, &y_emlrtRTEI);
  i = obj->delta_gradLag->size[0];
  obj->delta_gradLag->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->delta_gradLag, i, &y_emlrtRTEI);
  i = obj->xstar->size[0];
  obj->xstar->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->xstar, i, &y_emlrtRTEI);
  obj->fstar = 0.0;
  obj->firstorderopt = 0.0;
  i = obj->lambda->size[0];
  obj->lambda->size[0] = mConstrMax;
  emxEnsureCapacity_real_T(sp, obj->lambda, i, &y_emlrtRTEI);
  for (i = 0; i < mConstrMax; i++) {
    obj->lambda->data[i] = 0.0;
  }

  obj->state = 0;
  obj->maxConstr = 0.0;
  obj->iterations = 0;
  i = obj->searchDir->size[0];
  obj->searchDir->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->searchDir, i, &y_emlrtRTEI);
}

/* End of code generation (factoryConstruct.c) */
