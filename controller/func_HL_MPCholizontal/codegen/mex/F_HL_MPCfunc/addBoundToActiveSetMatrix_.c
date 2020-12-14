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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo wj_emlrtRSI = { 1,  /* lineNo */
  "addBoundToActiveSetMatrix_",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addBoundToActiveSetMatrix_.p"/* pathName */
};

static emlrtBCInfo ke_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addBoundToActiveSetMatrix_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addBoundToActiveSetMatrix_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo le_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addBoundToActiveSetMatrix_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addBoundToActiveSetMatrix_.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void addBoundToActiveSetMatrix_(const emlrtStack *sp, g_struct_T *obj, int32_T
  TYPE, int32_T idx_local)
{
  int32_T i;
  int32_T idx_bnd_local_tmp;
  int32_T idx_bnd_local;
  int32_T b;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &wj_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  obj->nWConstr[TYPE - 1]++;
  i = (obj->isActiveIdx[TYPE - 1] + idx_local) - 1;
  if ((i < 1) || (i > 617)) {
    emlrtDynamicBoundsCheckR2012b(i, 1, 617, &od_emlrtBCI, &st);
  }

  obj->isActiveConstr[i - 1] = true;
  obj->nActiveConstr++;
  if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > 617)) {
    emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, 617, &od_emlrtBCI, &st);
  }

  obj->Wid[obj->nActiveConstr - 1] = TYPE;
  obj->Wlocalidx[obj->nActiveConstr - 1] = idx_local;
  i = obj->nActiveConstr - 1;
  switch (TYPE) {
   case 5:
    if ((idx_local < 1) || (idx_local > 485)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, 485, &ke_emlrtBCI, sp);
    }

    idx_bnd_local_tmp = obj->indexUB[idx_local - 1];
    idx_bnd_local = idx_bnd_local_tmp - 1;
    if ((idx_bnd_local_tmp < 1) || (idx_bnd_local_tmp > 485)) {
      emlrtDynamicBoundsCheckR2012b(obj->indexUB[idx_local - 1], 1, 485,
        &ke_emlrtBCI, sp);
    }

    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > 617)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, 617, &le_emlrtBCI, sp);
    }

    obj->bwset[obj->nActiveConstr - 1] = obj->ub[idx_bnd_local];
    break;

   default:
    if ((idx_local < 1) || (idx_local > 485)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, 485, &ke_emlrtBCI, sp);
    }

    idx_bnd_local_tmp = obj->indexLB[idx_local - 1];
    idx_bnd_local = idx_bnd_local_tmp - 1;
    if ((idx_bnd_local_tmp < 1) || (idx_bnd_local_tmp > 485)) {
      emlrtDynamicBoundsCheckR2012b(obj->indexLB[idx_local - 1], 1, 485,
        &ke_emlrtBCI, sp);
    }

    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > 617)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, 617, &le_emlrtBCI, sp);
    }

    obj->bwset[obj->nActiveConstr - 1] = obj->lb[idx_bnd_local];
    break;
  }

  st.site = &wj_emlrtRSI;
  if ((1 <= idx_bnd_local) && (idx_bnd_local > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= idx_bnd_local - 1) {
    memset(&obj->ATwset[i * 485], 0, ((idx_bnd_local + i * 485) - i * 485) *
           sizeof(real_T));
  }

  obj->ATwset[idx_bnd_local + 485 * (obj->nActiveConstr - 1)] = 2.0 * (real_T)
    (TYPE == 5) - 1.0;
  idx_bnd_local_tmp = idx_bnd_local + 2;
  b = obj->nVar;
  st.site = &wj_emlrtRSI;
  if ((idx_bnd_local + 2 <= obj->nVar) && (obj->nVar > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (idx_bnd_local_tmp <= b) {
    memset(&obj->ATwset[(idx_bnd_local_tmp + i * 485) + -1], 0, ((((b + i * 485)
              - idx_bnd_local_tmp) - i * 485) + 1) * sizeof(real_T));
  }

  switch (obj->probType) {
   case 3:
   case 2:
    break;

   default:
    obj->ATwset[(obj->nVar + 485 * (obj->nActiveConstr - 1)) - 1] = -1.0;
    break;
  }
}

/* End of code generation (addBoundToActiveSetMatrix_.c) */
