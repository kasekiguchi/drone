/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * moveConstraint_.c
 *
 * Code generation for function 'moveConstraint_'
 *
 */

/* Include files */
#include "moveConstraint_.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo jd_emlrtRSI = { 1,  /* lineNo */
  "moveConstraint_",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\moveConstraint_.p"/* pathName */
};

static emlrtBCInfo hc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "moveConstraint_",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\moveConstraint_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void moveConstraint_(const emlrtStack *sp, j_struct_T *obj, int32_T
                     idx_global_start, int32_T idx_global_dest)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T b;
  int32_T i;
  int32_T idx;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  i = obj->Wid->size[0];
  if ((idx_global_start < 1) || (idx_global_start > i)) {
    emlrtDynamicBoundsCheckR2012b(idx_global_start, 1, i, &hc_emlrtBCI, sp);
  }

  i = obj->Wid->size[0];
  if ((idx_global_dest < 1) || (idx_global_dest > i)) {
    emlrtDynamicBoundsCheckR2012b(idx_global_dest, 1, i, &hc_emlrtBCI, sp);
  }

  obj->Wid->data[idx_global_dest - 1] = obj->Wid->data[idx_global_start - 1];
  i = obj->Wlocalidx->size[0];
  if (idx_global_start > i) {
    emlrtDynamicBoundsCheckR2012b(idx_global_start, 1, i, &hc_emlrtBCI, sp);
  }

  i = obj->Wlocalidx->size[0];
  if (idx_global_dest > i) {
    emlrtDynamicBoundsCheckR2012b(idx_global_dest, 1, i, &hc_emlrtBCI, sp);
  }

  obj->Wlocalidx->data[idx_global_dest - 1] = obj->Wlocalidx->
    data[idx_global_start - 1];
  b = obj->nVar;
  st.site = &jd_emlrtRSI;
  if ((1 <= obj->nVar) && (obj->nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < b; idx++) {
    i = obj->ATwset->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &hc_emlrtBCI, sp);
    }

    i = obj->ATwset->size[1];
    if (idx_global_start > i) {
      emlrtDynamicBoundsCheckR2012b(idx_global_start, 1, i, &hc_emlrtBCI, sp);
    }

    i = obj->ATwset->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &hc_emlrtBCI, sp);
    }

    i = obj->ATwset->size[1];
    if (idx_global_dest > i) {
      emlrtDynamicBoundsCheckR2012b(idx_global_dest, 1, i, &hc_emlrtBCI, sp);
    }

    obj->ATwset->data[idx + obj->ATwset->size[0] * (idx_global_dest - 1)] =
      obj->ATwset->data[idx + obj->ATwset->size[0] * (idx_global_start - 1)];
  }

  i = obj->bwset->size[0];
  if (idx_global_start > i) {
    emlrtDynamicBoundsCheckR2012b(idx_global_start, 1, i, &hc_emlrtBCI, sp);
  }

  i = obj->bwset->size[0];
  if (idx_global_dest > i) {
    emlrtDynamicBoundsCheckR2012b(idx_global_dest, 1, i, &hc_emlrtBCI, sp);
  }

  obj->bwset->data[idx_global_dest - 1] = obj->bwset->data[idx_global_start - 1];
}

/* End of code generation (moveConstraint_.c) */
