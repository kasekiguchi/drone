/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminconMEX_Trackobjective_emxutil.c
 *
 * Code generation for function 'fminconMEX_Trackobjective_emxutil'
 *
 */

/* Include files */
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include <stddef.h>
#include <string.h>

/* Function Definitions */
void c_emxInitStruct_anonymous_funct(anonymous_function *pStruct)
{
  emxInitMatrix_struct0_T(pStruct->tunableEnvironment);
}

void emxEnsureCapacity_boolean_T(const emlrtStack *sp, emxArray_boolean_T
  *emxArray, int32_T oldNumel, const emlrtRTEInfo *srcLocation)
{
  int32_T i;
  int32_T newNumel;
  void *newData;
  if (oldNumel < 0) {
    oldNumel = 0;
  }

  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel = (int32_T)emlrtSizeMulR2012b((uint32_T)newNumel, (uint32_T)
      emxArray->size[i], srcLocation, sp);
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i *= 2;
      }
    }

    newData = emlrtCallocMex((uint32_T)i, sizeof(boolean_T));
    if (newData == NULL) {
      emlrtHeapAllocationErrorR2012b(srcLocation, sp);
    }

    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, sizeof(boolean_T) * oldNumel);
      if (emxArray->canFreeData) {
        emlrtFreeMex(emxArray->data);
      }
    }

    emxArray->data = (boolean_T *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

void emxEnsureCapacity_int32_T(const emlrtStack *sp, emxArray_int32_T *emxArray,
  int32_T oldNumel, const emlrtRTEInfo *srcLocation)
{
  int32_T i;
  int32_T newNumel;
  void *newData;
  if (oldNumel < 0) {
    oldNumel = 0;
  }

  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel = (int32_T)emlrtSizeMulR2012b((uint32_T)newNumel, (uint32_T)
      emxArray->size[i], srcLocation, sp);
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i *= 2;
      }
    }

    newData = emlrtCallocMex((uint32_T)i, sizeof(int32_T));
    if (newData == NULL) {
      emlrtHeapAllocationErrorR2012b(srcLocation, sp);
    }

    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, sizeof(int32_T) * oldNumel);
      if (emxArray->canFreeData) {
        emlrtFreeMex(emxArray->data);
      }
    }

    emxArray->data = (int32_T *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

void emxEnsureCapacity_ptrdiff_t(const emlrtStack *sp, emxArray_ptrdiff_t
  *emxArray, int32_T oldNumel, const emlrtRTEInfo *srcLocation)
{
  int32_T i;
  int32_T newNumel;
  void *newData;
  if (oldNumel < 0) {
    oldNumel = 0;
  }

  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel = (int32_T)emlrtSizeMulR2012b((uint32_T)newNumel, (uint32_T)
      emxArray->size[i], srcLocation, sp);
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i *= 2;
      }
    }

    newData = emlrtCallocMex((uint32_T)i, sizeof(ptrdiff_t));
    if (newData == NULL) {
      emlrtHeapAllocationErrorR2012b(srcLocation, sp);
    }

    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, sizeof(ptrdiff_t) * oldNumel);
      if (emxArray->canFreeData) {
        emlrtFreeMex(emxArray->data);
      }
    }

    emxArray->data = (ptrdiff_t *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

void emxEnsureCapacity_real_T(const emlrtStack *sp, emxArray_real_T *emxArray,
  int32_T oldNumel, const emlrtRTEInfo *srcLocation)
{
  int32_T i;
  int32_T newNumel;
  void *newData;
  if (oldNumel < 0) {
    oldNumel = 0;
  }

  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel = (int32_T)emlrtSizeMulR2012b((uint32_T)newNumel, (uint32_T)
      emxArray->size[i], srcLocation, sp);
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i *= 2;
      }
    }

    newData = emlrtCallocMex((uint32_T)i, sizeof(real_T));
    if (newData == NULL) {
      emlrtHeapAllocationErrorR2012b(srcLocation, sp);
    }

    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, sizeof(real_T) * oldNumel);
      if (emxArray->canFreeData) {
        emlrtFreeMex(emxArray->data);
      }
    }

    emxArray->data = (real_T *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

void emxFreeStruct_struct3_T(struct3_T *pStruct)
{
  emxFree_real_T(&pStruct->eqnonlin);
  emxFree_real_T(&pStruct->ineqnonlin);
}

void emxFreeStruct_struct_T(d_struct_T *pStruct)
{
  emxFree_real_T(&pStruct->cIneq);
  emxFree_real_T(&pStruct->cIneq_old);
  emxFree_real_T(&pStruct->cEq);
  emxFree_real_T(&pStruct->cEq_old);
  emxFree_real_T(&pStruct->grad);
  emxFree_real_T(&pStruct->grad_old);
  emxFree_real_T(&pStruct->lambdasqp);
  emxFree_real_T(&pStruct->lambdasqp_old);
  emxFree_real_T(&pStruct->delta_x);
  emxFree_real_T(&pStruct->socDirection);
  emxFree_real_T(&pStruct->lambda_old);
  emxFree_int32_T(&pStruct->workingset_old);
  emxFree_real_T(&pStruct->JacCineqTrans_old);
  emxFree_real_T(&pStruct->JacCeqTrans_old);
  emxFree_real_T(&pStruct->gradLag);
  emxFree_real_T(&pStruct->delta_gradLag);
  emxFree_real_T(&pStruct->xstar);
  emxFree_real_T(&pStruct->lambda);
  emxFree_real_T(&pStruct->searchDir);
}

void emxFreeStruct_struct_T1(e_struct_T *pStruct)
{
  emxFree_real_T(&pStruct->cIneq_1);
  emxFree_real_T(&pStruct->cEq_1);
  emxFree_real_T(&pStruct->cIneq_2);
  emxFree_real_T(&pStruct->cEq_2);
}

void emxFreeStruct_struct_T2(g_struct_T *pStruct)
{
  emxFree_real_T(&pStruct->QR);
  emxFree_real_T(&pStruct->Q);
  emxFree_int32_T(&pStruct->jpvt);
  emxFree_real_T(&pStruct->tau);
}

void emxFreeStruct_struct_T3(h_struct_T *pStruct)
{
  emxFree_real_T(&pStruct->FMat);
}

void emxFreeStruct_struct_T4(i_struct_T *pStruct)
{
  emxFree_real_T(&pStruct->grad);
  emxFree_real_T(&pStruct->Hx);
}

void emxFreeStruct_struct_T5(c_struct_T *pStruct)
{
  emxFree_real_T(&pStruct->workspace_double);
  emxFree_int32_T(&pStruct->workspace_int);
  emxFree_int32_T(&pStruct->workspace_sort);
}

void emxFreeStruct_struct_T6(j_struct_T *pStruct)
{
  emxFree_real_T(&pStruct->Aineq);
  emxFree_real_T(&pStruct->bineq);
  emxFree_real_T(&pStruct->Aeq);
  emxFree_real_T(&pStruct->beq);
  emxFree_real_T(&pStruct->lb);
  emxFree_real_T(&pStruct->ub);
  emxFree_int32_T(&pStruct->indexLB);
  emxFree_int32_T(&pStruct->indexUB);
  emxFree_int32_T(&pStruct->indexFixed);
  emxFree_int32_T(&pStruct->indexEqRemoved);
  emxFree_real_T(&pStruct->ATwset);
  emxFree_real_T(&pStruct->bwset);
  emxFree_real_T(&pStruct->maxConstrWorkspace);
  emxFree_boolean_T(&pStruct->isActiveConstr);
  emxFree_int32_T(&pStruct->Wid);
  emxFree_int32_T(&pStruct->Wlocalidx);
}

void emxFree_boolean_T(emxArray_boolean_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_boolean_T *)NULL) {
    if (((*pEmxArray)->data != (boolean_T *)NULL) && (*pEmxArray)->canFreeData)
    {
      emlrtFreeMex((*pEmxArray)->data);
    }

    emlrtFreeMex((*pEmxArray)->size);
    emlrtFreeMex(*pEmxArray);
    *pEmxArray = (emxArray_boolean_T *)NULL;
  }
}

void emxFree_int32_T(emxArray_int32_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_int32_T *)NULL) {
    if (((*pEmxArray)->data != (int32_T *)NULL) && (*pEmxArray)->canFreeData) {
      emlrtFreeMex((*pEmxArray)->data);
    }

    emlrtFreeMex((*pEmxArray)->size);
    emlrtFreeMex(*pEmxArray);
    *pEmxArray = (emxArray_int32_T *)NULL;
  }
}

void emxFree_ptrdiff_t(emxArray_ptrdiff_t **pEmxArray)
{
  if (*pEmxArray != (emxArray_ptrdiff_t *)NULL) {
    if (((*pEmxArray)->data != (ptrdiff_t *)NULL) && (*pEmxArray)->canFreeData)
    {
      emlrtFreeMex((*pEmxArray)->data);
    }

    emlrtFreeMex((*pEmxArray)->size);
    emlrtFreeMex(*pEmxArray);
    *pEmxArray = (emxArray_ptrdiff_t *)NULL;
  }
}

void emxFree_real_T(emxArray_real_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_real_T *)NULL) {
    if (((*pEmxArray)->data != (real_T *)NULL) && (*pEmxArray)->canFreeData) {
      emlrtFreeMex((*pEmxArray)->data);
    }

    emlrtFreeMex((*pEmxArray)->size);
    emlrtFreeMex(*pEmxArray);
    *pEmxArray = (emxArray_real_T *)NULL;
  }
}

void emxInitMatrix_struct0_T(struct0_T pMatrix[1])
{
  int32_T i;
  for (i = 0; i < 1; i++) {
    emxInitStruct_struct0_T(&pMatrix[0]);
  }
}

void emxInitStruct_struct0_T(struct0_T *pStruct)
{
  pStruct->dis.size[0] = 0;
  pStruct->dis.size[1] = 0;
  pStruct->alpha.size[0] = 0;
  pStruct->alpha.size[1] = 0;
  pStruct->phi.size[0] = 0;
  pStruct->phi.size[1] = 0;
}

void emxInitStruct_struct3_T(const emlrtStack *sp, struct3_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxInit_real_T(sp, &pStruct->eqnonlin, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->ineqnonlin, 1, srcLocation, doPush);
}

void emxInitStruct_struct_T(const emlrtStack *sp, d_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxInit_real_T(sp, &pStruct->cIneq, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->cIneq_old, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->cEq, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->cEq_old, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->grad, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->grad_old, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->lambdasqp, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->lambdasqp_old, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->delta_x, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->socDirection, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->lambda_old, 1, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->workingset_old, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->JacCineqTrans_old, 2, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->JacCeqTrans_old, 2, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->gradLag, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->delta_gradLag, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->xstar, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->lambda, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->searchDir, 1, srcLocation, doPush);
}

void emxInitStruct_struct_T1(const emlrtStack *sp, e_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  c_emxInitStruct_anonymous_funct(&pStruct->objfun);
  c_emxInitStruct_anonymous_funct(&pStruct->nonlin);
  emxInit_real_T(sp, &pStruct->cIneq_1, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->cEq_1, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->cIneq_2, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->cEq_2, 1, srcLocation, doPush);
}

void emxInitStruct_struct_T2(const emlrtStack *sp, g_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxInit_real_T(sp, &pStruct->QR, 2, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->Q, 2, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->jpvt, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->tau, 1, srcLocation, doPush);
}

void emxInitStruct_struct_T3(const emlrtStack *sp, h_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxInit_real_T(sp, &pStruct->FMat, 2, srcLocation, doPush);
}

void emxInitStruct_struct_T4(const emlrtStack *sp, i_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxInit_real_T(sp, &pStruct->grad, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->Hx, 1, srcLocation, doPush);
}

void emxInitStruct_struct_T5(const emlrtStack *sp, c_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxInit_real_T(sp, &pStruct->workspace_double, 2, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->workspace_int, 1, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->workspace_sort, 1, srcLocation, doPush);
}

void emxInitStruct_struct_T6(const emlrtStack *sp, j_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxInit_real_T(sp, &pStruct->Aineq, 2, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->bineq, 2, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->Aeq, 2, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->beq, 2, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->lb, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->ub, 1, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->indexLB, 1, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->indexUB, 1, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->indexFixed, 1, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->indexEqRemoved, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->ATwset, 2, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->bwset, 1, srcLocation, doPush);
  emxInit_real_T(sp, &pStruct->maxConstrWorkspace, 1, srcLocation, doPush);
  emxInit_boolean_T(sp, &pStruct->isActiveConstr, 1, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->Wid, 1, srcLocation, doPush);
  emxInit_int32_T(sp, &pStruct->Wlocalidx, 1, srcLocation, doPush);
}

void emxInit_boolean_T(const emlrtStack *sp, emxArray_boolean_T **pEmxArray,
  int32_T numDimensions, const emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxArray_boolean_T *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_boolean_T *)emlrtMallocMex(sizeof(emxArray_boolean_T));
  if ((void *)*pEmxArray == NULL) {
    emlrtHeapAllocationErrorR2012b(srcLocation, sp);
  }

  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(sp, (void *)pEmxArray, (void *)
      &emxFree_boolean_T);
  }

  emxArray = *pEmxArray;
  emxArray->data = (boolean_T *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex(sizeof(int32_T) * numDimensions);
  if ((void *)emxArray->size == NULL) {
    emlrtHeapAllocationErrorR2012b(srcLocation, sp);
  }

  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

void emxInit_int32_T(const emlrtStack *sp, emxArray_int32_T **pEmxArray, int32_T
                     numDimensions, const emlrtRTEInfo *srcLocation, boolean_T
                     doPush)
{
  emxArray_int32_T *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_int32_T *)emlrtMallocMex(sizeof(emxArray_int32_T));
  if ((void *)*pEmxArray == NULL) {
    emlrtHeapAllocationErrorR2012b(srcLocation, sp);
  }

  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(sp, (void *)pEmxArray, (void *)
      &emxFree_int32_T);
  }

  emxArray = *pEmxArray;
  emxArray->data = (int32_T *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex(sizeof(int32_T) * numDimensions);
  if ((void *)emxArray->size == NULL) {
    emlrtHeapAllocationErrorR2012b(srcLocation, sp);
  }

  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

void emxInit_ptrdiff_t(const emlrtStack *sp, emxArray_ptrdiff_t **pEmxArray,
  int32_T numDimensions, const emlrtRTEInfo *srcLocation, boolean_T doPush)
{
  emxArray_ptrdiff_t *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_ptrdiff_t *)emlrtMallocMex(sizeof(emxArray_ptrdiff_t));
  if ((void *)*pEmxArray == NULL) {
    emlrtHeapAllocationErrorR2012b(srcLocation, sp);
  }

  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(sp, (void *)pEmxArray, (void *)
      &emxFree_ptrdiff_t);
  }

  emxArray = *pEmxArray;
  emxArray->data = (ptrdiff_t *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex(sizeof(int32_T) * numDimensions);
  if ((void *)emxArray->size == NULL) {
    emlrtHeapAllocationErrorR2012b(srcLocation, sp);
  }

  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray, int32_T
                    numDimensions, const emlrtRTEInfo *srcLocation, boolean_T
                    doPush)
{
  emxArray_real_T *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_real_T *)emlrtMallocMex(sizeof(emxArray_real_T));
  if ((void *)*pEmxArray == NULL) {
    emlrtHeapAllocationErrorR2012b(srcLocation, sp);
  }

  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(sp, (void *)pEmxArray, (void *)
      &emxFree_real_T);
  }

  emxArray = *pEmxArray;
  emxArray->data = (real_T *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex(sizeof(int32_T) * numDimensions);
  if ((void *)emxArray->size == NULL) {
    emlrtHeapAllocationErrorR2012b(srcLocation, sp);
  }

  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/* End of code generation (fminconMEX_Trackobjective_emxutil.c) */
