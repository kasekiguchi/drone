/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * initActiveSet.c
 *
 * Code generation for function 'initActiveSet'
 *
 */

/* Include files */
#include "initActiveSet.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "setProblemType.h"

/* Variable Definitions */
static emlrtRSInfo ib_emlrtRSI = { 1,  /* lineNo */
  "initActiveSet",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\initActiveSet.p"/* pathName */
};

static emlrtBCInfo gb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "initActiveSet",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\initActiveSet.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void initActiveSet(const emlrtStack *sp, j_struct_T *obj)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T b;
  int32_T b_i;
  int32_T i;
  int32_T i1;
  int32_T idx;
  int32_T idxFillStart;
  int32_T idx_local;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ib_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  setProblemType(&st, obj, 3);
  idxFillStart = obj->isActiveIdx[2];
  b = obj->mConstrMax;
  st.site = &ib_emlrtRSI;
  if ((obj->isActiveIdx[2] <= obj->mConstrMax) && (obj->mConstrMax > 2147483646))
  {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = idxFillStart; idx <= b; idx++) {
    i = obj->isActiveConstr->size[0];
    if ((idx < 1) || (idx > i)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, i, &gb_emlrtBCI, sp);
    }

    obj->isActiveConstr->data[idx - 1] = false;
  }

  obj->nWConstr[0] = 0;
  obj->nWConstr[1] = obj->sizes[1];
  obj->nWConstr[2] = 0;
  obj->nWConstr[3] = 0;
  obj->nWConstr[4] = 0;
  obj->nActiveConstr = obj->nWConstr[1];
  st.site = &ib_emlrtRSI;
  idxFillStart = obj->sizes[1];
  st.site = &ib_emlrtRSI;
  if ((1 <= obj->sizes[1]) && (obj->sizes[1] > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx_local = 0; idx_local < idxFillStart; idx_local++) {
    i = obj->Wid->size[0];
    if ((idx_local + 1 < 1) || (idx_local + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local + 1, 1, i, &gb_emlrtBCI, sp);
    }

    obj->Wid->data[idx_local] = 2;
    i = obj->Wlocalidx->size[0];
    if ((idx_local + 1 < 1) || (idx_local + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local + 1, 1, i, &gb_emlrtBCI, sp);
    }

    obj->Wlocalidx->data[idx_local] = idx_local + 1;
    i = obj->isActiveConstr->size[0];
    if ((idx_local + 1 < 1) || (idx_local + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local + 1, 1, i, &gb_emlrtBCI, sp);
    }

    obj->isActiveConstr->data[idx_local] = true;
    b = obj->ldA * idx_local + 1;
    i = obj->nVar - 1;
    for (b_i = 0; b_i <= i; b_i++) {
      idx = obj->Aeq->size[0] * obj->Aeq->size[1];
      i1 = b + b_i;
      if ((i1 < 1) || (i1 > idx)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, idx, &gb_emlrtBCI, sp);
      }

      idx = obj->ATwset->size[0] * obj->ATwset->size[1];
      if ((i1 < 1) || (i1 > idx)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, idx, &gb_emlrtBCI, sp);
      }

      obj->ATwset->data[i1 - 1] = obj->Aeq->data[i1 - 1];
    }

    i = obj->beq->size[0];
    if ((idx_local + 1 < 1) || (idx_local + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local + 1, 1, i, &gb_emlrtBCI, sp);
    }

    i = obj->bwset->size[0];
    if ((idx_local + 1 < 1) || (idx_local + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local + 1, 1, i, &gb_emlrtBCI, sp);
    }

    obj->bwset->data[idx_local] = obj->beq->data[idx_local];
  }
}

/* End of code generation (initActiveSet.c) */
