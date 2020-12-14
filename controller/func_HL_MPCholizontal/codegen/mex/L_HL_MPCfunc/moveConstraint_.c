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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo xc_emlrtRSI = { 1,  /* lineNo */
  "moveConstraint_",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\moveConstraint_.p"/* pathName */
};

static emlrtBCInfo ub_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "moveConstraint_",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\moveConstraint_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vb_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "moveConstraint_",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\moveConstraint_.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void moveConstraint_(const emlrtStack *sp, g_struct_T *obj, int32_T
                     idx_global_start, int32_T idx_global_dest)
{
  int32_T b;
  int32_T idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((idx_global_start < 1) || (idx_global_start > 305)) {
    emlrtDynamicBoundsCheckR2012b(idx_global_start, 1, 305, &ub_emlrtBCI, sp);
  }

  if ((idx_global_dest < 1) || (idx_global_dest > 305)) {
    emlrtDynamicBoundsCheckR2012b(idx_global_dest, 1, 305, &vb_emlrtBCI, sp);
  }

  obj->Wid[idx_global_dest - 1] = obj->Wid[idx_global_start - 1];
  obj->Wlocalidx[idx_global_dest - 1] = obj->Wlocalidx[idx_global_start - 1];
  b = obj->nVar;
  st.site = &xc_emlrtRSI;
  if ((1 <= obj->nVar) && (obj->nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < b; idx++) {
    obj->ATwset[idx + 307 * (idx_global_dest - 1)] = obj->ATwset[idx + 307 *
      (idx_global_start - 1)];
  }

  obj->bwset[idx_global_dest - 1] = obj->bwset[idx_global_start - 1];
}

/* End of code generation (moveConstraint_.c) */
