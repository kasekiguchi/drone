/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factorQRE.c
 *
 * Code generation for function 'factorQRE'
 *
 */

/* Include files */
#include "factorQRE.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgeqp3.h"

/* Function Definitions */
void factorQRE(const emlrtStack *sp, k_struct_T *obj, const real_T A[299245],
               int32_T mrows, int32_T ncols)
{
  int32_T idx;
  boolean_T guard1 = false;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  idx = mrows * ncols;
  guard1 = false;
  if (idx > 0) {
    st.site = &rf_emlrtRSI;
    if ((1 <= ncols) && (ncols > 2147483646)) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < ncols; idx++) {
      st.site = &rf_emlrtRSI;
      d_xcopy(mrows, A, 485 * idx + 1, obj->QR, 617 * idx + 1);
    }

    guard1 = true;
  } else if (idx == 0) {
    obj->mrows = mrows;
    obj->ncols = ncols;
    obj->minRowCol = 0;
  } else {
    guard1 = true;
  }

  if (guard1) {
    obj->usedPivoting = true;
    obj->mrows = mrows;
    obj->ncols = ncols;
    obj->minRowCol = muIntScalarMin_sint32(mrows, ncols);
    st.site = &rf_emlrtRSI;
    xgeqp3(&st, obj->QR, mrows, ncols, obj->jpvt, obj->tau);
  }
}

/* End of code generation (factorQRE.c) */
