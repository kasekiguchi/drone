/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * IndexOfDependentEq_.c
 *
 * Code generation for function 'IndexOfDependentEq_'
 *
 */

/* Include files */
#include "IndexOfDependentEq_.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQRE.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo jh_emlrtRSI = { 1,  /* lineNo */
  "IndexOfDependentEq_",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\IndexOfDependentEq_.p"/* pathName */
};

static emlrtBCInfo nc_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "IndexOfDependentEq_",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\IndexOfDependentEq_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo oc_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "IndexOfDependentEq_",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\IndexOfDependentEq_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void IndexOfDependentEq_(const emlrtStack *sp, int32_T depIdx[617], int32_T
  mFixed, int32_T nDep, k_struct_T *qrmanager, const real_T AeqfPrime[299245],
  int32_T mRows, int32_T nCols)
{
  int32_T idx;
  int32_T a;
  int32_T b_idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &jh_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= mFixed) && (mFixed > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mFixed; idx++) {
    a = idx + 1;
    if ((a < 1) || (a > 617)) {
      emlrtDynamicBoundsCheckR2012b(a, 1, 617, &nc_emlrtBCI, sp);
    }

    qrmanager->jpvt[a - 1] = 1;
  }

  a = mFixed + 1;
  st.site = &jh_emlrtRSI;
  if ((mFixed + 1 <= nCols) && (nCols > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = a; idx <= nCols; idx++) {
    if ((idx < 1) || (idx > 617)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &nc_emlrtBCI, sp);
    }

    qrmanager->jpvt[idx - 1] = 0;
  }

  st.site = &jh_emlrtRSI;
  factorQRE(&st, qrmanager, AeqfPrime, mRows, nCols);
  st.site = &jh_emlrtRSI;
  if ((1 <= nDep) && (nDep > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nDep; idx++) {
    b_idx = idx + 1;
    a = (nCols - nDep) + b_idx;
    if ((a < 1) || (a > 617)) {
      emlrtDynamicBoundsCheckR2012b(a, 1, 617, &oc_emlrtBCI, sp);
    }

    if ((b_idx < 1) || (b_idx > 617)) {
      emlrtDynamicBoundsCheckR2012b(b_idx, 1, 617, &nc_emlrtBCI, sp);
    }

    depIdx[b_idx - 1] = qrmanager->jpvt[a - 1];
  }
}

/* End of code generation (IndexOfDependentEq_.c) */
