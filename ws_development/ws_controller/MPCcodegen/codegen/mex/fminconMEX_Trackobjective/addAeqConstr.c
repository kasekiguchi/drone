/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * addAeqConstr.c
 *
 * Code generation for function 'addAeqConstr'
 *
 */

/* Include files */
#include "addAeqConstr.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "moveConstraint_.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo kf_emlrtRSI = { 1,  /* lineNo */
  "addAeqConstr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p"/* pathName */
};

static emlrtBCInfo id_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAeqConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void addAeqConstr(const emlrtStack *sp, j_struct_T *obj, int32_T idx_local)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T b;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T iAeq0;
  int32_T iAw0;
  int32_T idx;
  int32_T totalEq;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  totalEq = (obj->nWConstr[0] + obj->nWConstr[1]) + 1;
  if ((obj->nActiveConstr == totalEq - 1) && (idx_local > obj->nWConstr[1])) {
    st.site = &kf_emlrtRSI;
    obj->nWConstr[1]++;
    i = obj->isActiveConstr->size[0];
    i1 = (obj->isActiveIdx[1] + idx_local) - 1;
    if ((i1 < 1) || (i1 > i)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i, &tc_emlrtBCI, &st);
    }

    obj->isActiveConstr->data[i1 - 1] = true;
    obj->nActiveConstr++;
    i = obj->Wid->size[0];
    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &tc_emlrtBCI, &st);
    }

    obj->Wid->data[obj->nActiveConstr - 1] = 2;
    i = obj->Wlocalidx->size[0];
    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &tc_emlrtBCI, &st);
    }

    obj->Wlocalidx->data[obj->nActiveConstr - 1] = idx_local;
    iAeq0 = obj->ldA * (idx_local - 1);
    iAw0 = obj->ldA * (obj->nActiveConstr - 1);
    b = obj->nVar;
    st.site = &kf_emlrtRSI;
    if ((1 <= obj->nVar) && (obj->nVar > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b; idx++) {
      i = obj->Aeq->size[0] * obj->Aeq->size[1];
      i1 = (iAeq0 + idx) + 1;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &id_emlrtBCI, sp);
      }

      i = obj->ATwset->size[0] * obj->ATwset->size[1];
      i2 = (iAw0 + idx) + 1;
      if ((i2 < 1) || (i2 > i)) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, i, &id_emlrtBCI, sp);
      }

      obj->ATwset->data[i2 - 1] = obj->Aeq->data[i1 - 1];
    }

    i = obj->beq->size[0];
    if ((idx_local < 1) || (idx_local > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, i, &id_emlrtBCI, sp);
    }

    i = obj->bwset->size[0];
    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &id_emlrtBCI, sp);
    }

    obj->bwset->data[obj->nActiveConstr - 1] = obj->beq->data[idx_local - 1];
  } else {
    obj->nActiveConstr++;
    st.site = &kf_emlrtRSI;
    moveConstraint_(&st, obj, totalEq, obj->nActiveConstr);
    obj->nWConstr[1]++;
    i = obj->isActiveConstr->size[0];
    i1 = (obj->isActiveIdx[1] + idx_local) - 1;
    if ((i1 < 1) || (i1 > i)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i, &id_emlrtBCI, sp);
    }

    obj->isActiveConstr->data[i1 - 1] = true;
    i = obj->Wid->size[0];
    if ((totalEq < 1) || (totalEq > i)) {
      emlrtDynamicBoundsCheckR2012b(totalEq, 1, i, &id_emlrtBCI, sp);
    }

    obj->Wid->data[totalEq - 1] = 2;
    i = obj->Wlocalidx->size[0];
    if (totalEq > i) {
      emlrtDynamicBoundsCheckR2012b(totalEq, 1, i, &id_emlrtBCI, sp);
    }

    obj->Wlocalidx->data[totalEq - 1] = idx_local;
    iAeq0 = obj->ldA * (idx_local - 1);
    iAw0 = obj->ldA * (totalEq - 1);
    b = obj->nVar;
    st.site = &kf_emlrtRSI;
    if ((1 <= obj->nVar) && (obj->nVar > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b; idx++) {
      i = obj->Aeq->size[0] * obj->Aeq->size[1];
      i1 = (iAeq0 + idx) + 1;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &id_emlrtBCI, sp);
      }

      i = obj->ATwset->size[0] * obj->ATwset->size[1];
      i2 = (iAw0 + idx) + 1;
      if ((i2 < 1) || (i2 > i)) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, i, &id_emlrtBCI, sp);
      }

      obj->ATwset->data[i2 - 1] = obj->Aeq->data[i1 - 1];
    }

    i = obj->beq->size[0];
    if ((idx_local < 1) || (idx_local > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, i, &id_emlrtBCI, sp);
    }

    i = obj->bwset->size[0];
    if (totalEq > i) {
      emlrtDynamicBoundsCheckR2012b(totalEq, 1, i, &id_emlrtBCI, sp);
    }

    obj->bwset->data[totalEq - 1] = obj->beq->data[idx_local - 1];
  }
}

/* End of code generation (addAeqConstr.c) */
