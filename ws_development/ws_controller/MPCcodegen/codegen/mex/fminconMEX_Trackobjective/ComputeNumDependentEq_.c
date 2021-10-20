/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ComputeNumDependentEq_.c
 *
 * Code generation for function 'ComputeNumDependentEq_'
 *
 */

/* Include files */
#include "ComputeNumDependentEq_.h"
#include "computeQ_.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xdot.h"
#include "xgeqp3.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo ed_emlrtRSI = { 1,  /* lineNo */
  "ComputeNumDependentEq_",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\ComputeNumDependentEq_.p"/* pathName */
};

static emlrtBCInfo ec_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "ComputeNumDependentEq_",            /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\ComputeNumDependentEq_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
int32_T ComputeNumDependentEq_(const emlrtStack *sp, g_struct_T *qrmanager,
  const emxArray_real_T *beqf, int32_T mConstr, int32_T nVar)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T tol;
  int32_T idx;
  int32_T numDependent;
  int32_T y;
  boolean_T exitg1;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  y = mConstr - nVar;
  numDependent = muIntScalarMax_sint32(0, y);
  st.site = &ed_emlrtRSI;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nVar; idx++) {
    y = qrmanager->jpvt->size[0];
    if ((idx + 1 < 1) || (idx + 1 > y)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, y, &ec_emlrtBCI, sp);
    }

    qrmanager->jpvt->data[idx] = 0;
  }

  st.site = &ed_emlrtRSI;
  qrmanager->usedPivoting = true;
  qrmanager->mrows = mConstr;
  qrmanager->ncols = nVar;
  qrmanager->minRowCol = muIntScalarMin_sint32(mConstr, nVar);
  b_st.site = &ac_emlrtRSI;
  xgeqp3(&b_st, qrmanager->QR, mConstr, nVar, qrmanager->jpvt, qrmanager->tau);
  tol = 100.0 * (real_T)nVar * 2.2204460492503131E-16;
  idx = muIntScalarMin_sint32(nVar, mConstr);
  exitg1 = false;
  while ((!exitg1) && (idx > 0)) {
    y = qrmanager->QR->size[0];
    if (idx > y) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, y, &ec_emlrtBCI, sp);
    }

    y = qrmanager->QR->size[1];
    if (idx > y) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, y, &ec_emlrtBCI, sp);
    }

    if (muDoubleScalarAbs(qrmanager->QR->data[(idx + qrmanager->QR->size[0] *
          (idx - 1)) - 1]) < tol) {
      idx--;
      numDependent++;
    } else {
      exitg1 = true;
    }
  }

  if (numDependent > 0) {
    st.site = &ed_emlrtRSI;
    b_st.site = &oc_emlrtRSI;
    computeQ_(&b_st, qrmanager, mConstr);
    st.site = &ed_emlrtRSI;
    if (numDependent > 2147483646) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    idx = 0;
    exitg1 = false;
    while ((!exitg1) && (idx <= numDependent - 1)) {
      if (muDoubleScalarAbs(xdot(mConstr, qrmanager->Q, qrmanager->ldq *
            ((mConstr - idx) - 1) + 1, beqf)) >= tol) {
        numDependent = -1;
        exitg1 = true;
      } else {
        idx++;
      }
    }
  }

  return numDependent;
}

/* End of code generation (ComputeNumDependentEq_.c) */
