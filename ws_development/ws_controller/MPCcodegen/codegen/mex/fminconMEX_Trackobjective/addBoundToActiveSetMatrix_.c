/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * addBoundToActiveSetMatrix_.c
 *
 * Code generation for function 'addBoundToActiveSetMatrix_'
 *
 */

/* Include files */
#include "addBoundToActiveSetMatrix_.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo ff_emlrtRSI = { 1,  /* lineNo */
  "addBoundToActiveSetMatrix_",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addBoundToActiveSetMatrix_.p"/* pathName */
};

static emlrtBCInfo hd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addBoundToActiveSetMatrix_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addBoundToActiveSetMatrix_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void addBoundToActiveSetMatrix_(const emlrtStack *sp, j_struct_T *obj, int32_T
  TYPE, int32_T idx_local)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T a;
  int32_T b;
  int32_T i;
  int32_T idx;
  int32_T idx_bnd_local;
  int32_T idx_global;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ff_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  obj->nWConstr[TYPE - 1]++;
  i = obj->isActiveConstr->size[0];
  idx_global = (obj->isActiveIdx[TYPE - 1] + idx_local) - 1;
  if ((idx_global < 1) || (idx_global > i)) {
    emlrtDynamicBoundsCheckR2012b(idx_global, 1, i, &tc_emlrtBCI, &st);
  }

  obj->isActiveConstr->data[idx_global - 1] = true;
  obj->nActiveConstr++;
  i = obj->Wid->size[0];
  if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
    emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &tc_emlrtBCI, &st);
  }

  obj->Wid->data[obj->nActiveConstr - 1] = TYPE;
  i = obj->Wlocalidx->size[0];
  if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
    emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &tc_emlrtBCI, &st);
  }

  obj->Wlocalidx->data[obj->nActiveConstr - 1] = idx_local;
  idx_global = obj->nActiveConstr;
  switch (TYPE) {
   case 5:
    i = obj->indexUB->size[0];
    if ((idx_local < 1) || (idx_local > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, i, &hd_emlrtBCI, sp);
    }

    idx_bnd_local = obj->indexUB->data[idx_local - 1];
    i = obj->ub->size[0];
    if ((idx_bnd_local < 1) || (idx_bnd_local > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->indexUB->data[idx_local - 1], 1, i,
        &hd_emlrtBCI, sp);
    }

    i = obj->bwset->size[0];
    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &hd_emlrtBCI, sp);
    }

    obj->bwset->data[obj->nActiveConstr - 1] = obj->ub->data[idx_bnd_local - 1];
    break;

   default:
    i = obj->indexLB->size[0];
    if ((idx_local < 1) || (idx_local > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, i, &hd_emlrtBCI, sp);
    }

    idx_bnd_local = obj->indexLB->data[idx_local - 1];
    i = obj->lb->size[0];
    if ((idx_bnd_local < 1) || (idx_bnd_local > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->indexLB->data[idx_local - 1], 1, i,
        &hd_emlrtBCI, sp);
    }

    i = obj->bwset->size[0];
    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &hd_emlrtBCI, sp);
    }

    obj->bwset->data[obj->nActiveConstr - 1] = obj->lb->data[idx_bnd_local - 1];
    break;
  }

  st.site = &ff_emlrtRSI;
  if ((1 <= idx_bnd_local - 1) && (idx_bnd_local - 1 > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx <= idx_bnd_local - 2; idx++) {
    i = obj->ATwset->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &hd_emlrtBCI, sp);
    }

    i = obj->ATwset->size[1];
    if ((idx_global < 1) || (idx_global > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_global, 1, i, &hd_emlrtBCI, sp);
    }

    obj->ATwset->data[idx + obj->ATwset->size[0] * (idx_global - 1)] = 0.0;
  }

  i = obj->ATwset->size[0];
  if ((idx_bnd_local < 1) || (idx_bnd_local > i)) {
    emlrtDynamicBoundsCheckR2012b(idx_bnd_local, 1, i, &hd_emlrtBCI, sp);
  }

  i = obj->ATwset->size[1];
  if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
    emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &hd_emlrtBCI, sp);
  }

  obj->ATwset->data[(idx_bnd_local + obj->ATwset->size[0] * (obj->nActiveConstr
    - 1)) - 1] = 2.0 * (real_T)(TYPE == 5) - 1.0;
  a = idx_bnd_local + 1;
  b = obj->nVar;
  st.site = &ff_emlrtRSI;
  if ((idx_bnd_local + 1 <= obj->nVar) && (obj->nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = a; idx <= b; idx++) {
    i = obj->ATwset->size[0];
    if ((idx < 1) || (idx > i)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, i, &hd_emlrtBCI, sp);
    }

    i = obj->ATwset->size[1];
    if ((idx_global < 1) || (idx_global > i)) {
      emlrtDynamicBoundsCheckR2012b(idx_global, 1, i, &hd_emlrtBCI, sp);
    }

    obj->ATwset->data[(idx + obj->ATwset->size[0] * (idx_global - 1)) - 1] = 0.0;
  }

  switch (obj->probType) {
   case 3:
   case 2:
    break;

   default:
    i = obj->ATwset->size[0];
    if ((obj->nVar < 1) || (obj->nVar > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->nVar, 1, i, &hd_emlrtBCI, sp);
    }

    i = obj->ATwset->size[1];
    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > i)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, i, &hd_emlrtBCI, sp);
    }

    obj->ATwset->data[(obj->nVar + obj->ATwset->size[0] * (obj->nActiveConstr -
      1)) - 1] = -1.0;
    break;
  }
}

/* End of code generation (addBoundToActiveSetMatrix_.c) */
