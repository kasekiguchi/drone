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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "computeQ_.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xdot.h"
#include "xgeqp3.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo fh_emlrtRSI = { 1,  /* lineNo */
  "ComputeNumDependentEq_",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\ComputeNumDependentEq_.p"/* pathName */
};

/* Function Definitions */
int32_T ComputeNumDependentEq_(const emlrtStack *sp, k_struct_T *qrmanager,
  const real_T beqf[617], int32_T mConstr, int32_T nVar)
{
  int32_T numDependent;
  int32_T y;
  real_T tol;
  boolean_T exitg1;
  real_T x;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  y = mConstr - nVar;
  numDependent = muIntScalarMax_sint32(0, y);
  st.site = &fh_emlrtRSI;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= nVar - 1) {
    memset(&qrmanager->jpvt[0], 0, nVar * sizeof(int32_T));
  }

  st.site = &fh_emlrtRSI;
  qrmanager->usedPivoting = true;
  qrmanager->mrows = mConstr;
  qrmanager->ncols = nVar;
  qrmanager->minRowCol = muIntScalarMin_sint32(mConstr, nVar);
  b_st.site = &rf_emlrtRSI;
  xgeqp3(&b_st, qrmanager->QR, mConstr, nVar, qrmanager->jpvt, qrmanager->tau);
  tol = 100.0 * (real_T)nVar * 2.2204460492503131E-16;
  y = muIntScalarMin_sint32(nVar, mConstr);
  while ((y > 0) && (muDoubleScalarAbs(qrmanager->QR[(y + 617 * (y - 1)) - 1]) <
                     tol)) {
    y--;
    numDependent++;
  }

  if (numDependent > 0) {
    st.site = &fh_emlrtRSI;
    b_st.site = &ug_emlrtRSI;
    computeQ_(&b_st, qrmanager, mConstr);
    st.site = &fh_emlrtRSI;
    if (numDependent > 2147483646) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    y = 0;
    exitg1 = false;
    while ((!exitg1) && (y <= numDependent - 1)) {
      st.site = &fh_emlrtRSI;
      x = xdot(mConstr, qrmanager->Q, 617 * ((mConstr - y) - 1) + 1, beqf);
      if (muDoubleScalarAbs(x) >= tol) {
        numDependent = -1;
        exitg1 = true;
      } else {
        y++;
      }
    }
  }

  return numDependent;
}

/* End of code generation (ComputeNumDependentEq_.c) */
