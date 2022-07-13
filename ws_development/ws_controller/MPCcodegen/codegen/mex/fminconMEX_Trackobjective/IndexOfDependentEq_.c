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
#include "eml_int_forloop_overflow_check.h"
#include "factorQRE.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo fd_emlrtRSI = { 1,  /* lineNo */
  "IndexOfDependentEq_",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\IndexOfDependentEq_.p"/* pathName */
};

static emlrtBCInfo fc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "IndexOfDependentEq_",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\IndexOfDependentEq_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void IndexOfDependentEq_(const emlrtStack *sp, emxArray_int32_T *depIdx, int32_T
  mFixed, int32_T nDep, g_struct_T *qrmanager, const emxArray_real_T *AeqfPrime,
  int32_T mRows, int32_T nCols)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T a;
  int32_T i;
  int32_T idx;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &fd_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= mFixed) && (mFixed > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mFixed; idx++) {
    i = qrmanager->jpvt->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &fc_emlrtBCI, sp);
    }

    qrmanager->jpvt->data[idx] = 1;
  }

  a = mFixed + 1;
  st.site = &fd_emlrtRSI;
  if ((mFixed + 1 <= nCols) && (nCols > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = a; idx <= nCols; idx++) {
    i = qrmanager->jpvt->size[0];
    if ((idx < 1) || (idx > i)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, i, &fc_emlrtBCI, sp);
    }

    qrmanager->jpvt->data[idx - 1] = 0;
  }

  st.site = &fd_emlrtRSI;
  factorQRE(&st, qrmanager, AeqfPrime, mRows, nCols);
  st.site = &fd_emlrtRSI;
  if ((1 <= nDep) && (nDep > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nDep; idx++) {
    i = qrmanager->jpvt->size[0];
    a = ((nCols - nDep) + idx) + 1;
    if ((a < 1) || (a > i)) {
      emlrtDynamicBoundsCheckR2012b(a, 1, i, &fc_emlrtBCI, sp);
    }

    i = depIdx->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &fc_emlrtBCI, sp);
    }

    depIdx->data[idx] = qrmanager->jpvt->data[a - 1];
  }
}

/* End of code generation (IndexOfDependentEq_.c) */
