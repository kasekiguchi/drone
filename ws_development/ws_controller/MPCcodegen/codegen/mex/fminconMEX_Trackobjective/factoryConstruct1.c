/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factoryConstruct1.c
 *
 * Code generation for function 'factoryConstruct1'
 *
 */

/* Include files */
#include "factoryConstruct1.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo ab_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "factoryConstruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\factoryConstruct.p"/* pName */
};

/* Function Definitions */
void b_factoryConstruct(const emlrtStack *sp, int32_T mIneq, int32_T mEq,
  int32_T nVarMax, int32_T mConstrMax, j_struct_T *obj)
{
  emxArray_real_T *r;
  int32_T i;
  int32_T obj_tmp;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  obj_tmp = mIneq + mEq;
  obj->mConstr = obj_tmp;
  obj->mConstrOrig = obj_tmp;
  obj->mConstrMax = mConstrMax;
  obj->nVar = 66;
  obj->nVarOrig = 66;
  obj->nVarMax = nVarMax;
  obj->ldA = nVarMax;
  emxInit_real_T(sp, &r, 1, &ab_emlrtRTEI, true);
  if (mIneq > 0) {
    i = obj->Aineq->size[0] * obj->Aineq->size[1];
    obj->Aineq->size[0] = nVarMax;
    obj->Aineq->size[1] = mIneq;
    emxEnsureCapacity_real_T(sp, obj->Aineq, i, &ab_emlrtRTEI);
    i = r->size[0];
    r->size[0] = mIneq;
    emxEnsureCapacity_real_T(sp, r, i, &ab_emlrtRTEI);
    for (i = 0; i < mIneq; i++) {
      r->data[i] = 1.7976931348623157E+308;
    }

    i = obj->bineq->size[0] * obj->bineq->size[1];
    obj->bineq->size[0] = r->size[0];
    obj->bineq->size[1] = 1;
    emxEnsureCapacity_real_T(sp, obj->bineq, i, &ab_emlrtRTEI);
  } else {
    obj->Aineq->size[0] = 0;
    obj->Aineq->size[1] = 0;
    obj->bineq->size[0] = 0;
    obj->bineq->size[1] = 0;
  }

  i = obj->Aeq->size[0] * obj->Aeq->size[1];
  obj->Aeq->size[0] = nVarMax;
  obj->Aeq->size[1] = mEq;
  emxEnsureCapacity_real_T(sp, obj->Aeq, i, &ab_emlrtRTEI);
  i = r->size[0];
  r->size[0] = mEq;
  emxEnsureCapacity_real_T(sp, r, i, &ab_emlrtRTEI);
  for (i = 0; i < mEq; i++) {
    r->data[i] = 1.7976931348623157E+308;
  }

  i = obj->beq->size[0] * obj->beq->size[1];
  obj->beq->size[0] = r->size[0];
  obj->beq->size[1] = 1;
  emxEnsureCapacity_real_T(sp, obj->beq, i, &ab_emlrtRTEI);
  i = obj->lb->size[0];
  obj->lb->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->lb, i, &ab_emlrtRTEI);
  i = obj->ub->size[0];
  obj->ub->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, obj->ub, i, &ab_emlrtRTEI);
  i = obj->indexLB->size[0];
  obj->indexLB->size[0] = nVarMax;
  emxEnsureCapacity_int32_T(sp, obj->indexLB, i, &ab_emlrtRTEI);
  i = obj->indexUB->size[0];
  obj->indexUB->size[0] = nVarMax;
  emxEnsureCapacity_int32_T(sp, obj->indexUB, i, &ab_emlrtRTEI);
  i = obj->indexFixed->size[0];
  obj->indexFixed->size[0] = nVarMax;
  emxEnsureCapacity_int32_T(sp, obj->indexFixed, i, &ab_emlrtRTEI);
  obj->mEqRemoved = 0;
  i = obj->indexEqRemoved->size[0];
  obj->indexEqRemoved->size[0] = mEq;
  emxEnsureCapacity_int32_T(sp, obj->indexEqRemoved, i, &ab_emlrtRTEI);
  i = obj->ATwset->size[0] * obj->ATwset->size[1];
  obj->ATwset->size[0] = nVarMax;
  obj->ATwset->size[1] = mConstrMax;
  emxEnsureCapacity_real_T(sp, obj->ATwset, i, &ab_emlrtRTEI);
  i = obj->bwset->size[0];
  obj->bwset->size[0] = mConstrMax;
  emxEnsureCapacity_real_T(sp, obj->bwset, i, &ab_emlrtRTEI);
  obj->nActiveConstr = 0;
  i = obj->maxConstrWorkspace->size[0];
  obj->maxConstrWorkspace->size[0] = mConstrMax;
  emxEnsureCapacity_real_T(sp, obj->maxConstrWorkspace, i, &ab_emlrtRTEI);
  obj->sizes[0] = 0;
  obj->sizes[1] = mEq;
  obj->sizes[2] = mIneq;
  obj->sizes[3] = 0;
  obj->sizes[4] = 0;
  obj->sizesPhaseOne[0] = 0;
  obj->sizesPhaseOne[1] = mEq;
  obj->sizesPhaseOne[2] = mIneq;
  obj->sizesPhaseOne[3] = 1;
  obj->sizesPhaseOne[4] = 0;
  obj->sizesRegularized[0] = 0;
  obj->sizesRegularized[1] = mEq;
  obj->sizesRegularized[2] = mIneq;
  i = mIneq + (mEq << 1);
  obj->sizesRegularized[3] = i;
  obj->sizesRegularized[4] = 0;
  obj->sizesRegPhaseOne[0] = 0;
  obj->sizesRegPhaseOne[1] = mEq;
  obj->sizesRegPhaseOne[2] = mIneq;
  obj->sizesRegPhaseOne[3] = i + 1;
  obj->sizesRegPhaseOne[4] = 0;
  obj->isActiveIdxRegPhaseOne[0] = 1;
  obj->isActiveIdxRegPhaseOne[1] = 0;
  obj->isActiveIdxRegPhaseOne[2] = mEq;
  obj->isActiveIdxRegPhaseOne[3] = mIneq;
  obj->isActiveIdxRegPhaseOne[4] = 0;
  obj->isActiveIdxRegPhaseOne[5] = 0;
  emxFree_real_T(&r);
  for (obj_tmp = 0; obj_tmp < 5; obj_tmp++) {
    obj->sizesNormal[obj_tmp] = obj->sizes[obj_tmp];
    obj->isActiveIdxRegPhaseOne[obj_tmp + 1] += obj->
      isActiveIdxRegPhaseOne[obj_tmp];
  }

  for (obj_tmp = 0; obj_tmp < 6; obj_tmp++) {
    obj->isActiveIdx[obj_tmp] = obj->isActiveIdxRegPhaseOne[obj_tmp];
    obj->isActiveIdxNormal[obj_tmp] = obj->isActiveIdxRegPhaseOne[obj_tmp];
  }

  obj->isActiveIdxRegPhaseOne[0] = 1;
  obj->isActiveIdxRegPhaseOne[1] = 0;
  obj->isActiveIdxRegPhaseOne[2] = mEq;
  obj->isActiveIdxRegPhaseOne[3] = mIneq;
  obj->isActiveIdxRegPhaseOne[4] = 1;
  obj->isActiveIdxRegPhaseOne[5] = 0;
  for (obj_tmp = 0; obj_tmp < 5; obj_tmp++) {
    obj->isActiveIdxRegPhaseOne[obj_tmp + 1] += obj->
      isActiveIdxRegPhaseOne[obj_tmp];
  }

  for (obj_tmp = 0; obj_tmp < 6; obj_tmp++) {
    obj->isActiveIdxPhaseOne[obj_tmp] = obj->isActiveIdxRegPhaseOne[obj_tmp];
  }

  obj->isActiveIdxRegPhaseOne[0] = 1;
  obj->isActiveIdxRegPhaseOne[1] = 0;
  obj->isActiveIdxRegPhaseOne[2] = mEq;
  obj->isActiveIdxRegPhaseOne[3] = mIneq;
  obj->isActiveIdxRegPhaseOne[4] = i;
  obj->isActiveIdxRegPhaseOne[5] = 0;
  for (obj_tmp = 0; obj_tmp < 5; obj_tmp++) {
    obj->isActiveIdxRegPhaseOne[obj_tmp + 1] += obj->
      isActiveIdxRegPhaseOne[obj_tmp];
  }

  for (i = 0; i < 6; i++) {
    obj->isActiveIdxRegularized[i] = obj->isActiveIdxRegPhaseOne[i];
  }

  obj->isActiveIdxRegPhaseOne[0] = 1;
  obj->isActiveIdxRegPhaseOne[1] = 0;
  obj->isActiveIdxRegPhaseOne[2] = mEq;
  obj->isActiveIdxRegPhaseOne[3] = mIneq;
  obj->isActiveIdxRegPhaseOne[4] = (mIneq + (mEq << 1)) + 1;
  obj->isActiveIdxRegPhaseOne[5] = 0;
  i = obj->isActiveConstr->size[0];
  obj->isActiveConstr->size[0] = mConstrMax;
  emxEnsureCapacity_boolean_T(sp, obj->isActiveConstr, i, &ab_emlrtRTEI);
  i = obj->Wid->size[0];
  obj->Wid->size[0] = mConstrMax;
  emxEnsureCapacity_int32_T(sp, obj->Wid, i, &ab_emlrtRTEI);
  i = obj->Wlocalidx->size[0];
  obj->Wlocalidx->size[0] = mConstrMax;
  emxEnsureCapacity_int32_T(sp, obj->Wlocalidx, i, &ab_emlrtRTEI);
  for (obj_tmp = 0; obj_tmp < 5; obj_tmp++) {
    obj->isActiveIdxRegPhaseOne[obj_tmp + 1] += obj->
      isActiveIdxRegPhaseOne[obj_tmp];
    obj->nWConstr[obj_tmp] = 0;
  }

  obj->probType = 3;
  obj->SLACK0 = 1.0E-5;
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (factoryConstruct1.c) */
