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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgeqp3.h"

/* Function Definitions */
void factorQRE(const emlrtStack *sp, k_struct_T *obj, const real_T A[93635],
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
    st.site = &ab_emlrtRSI;
    if ((1 <= ncols) && (ncols > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < ncols; idx++) {
      st.site = &ab_emlrtRSI;
      d_xcopy(&st, mrows, A, 307 * idx + 1, obj->QR, 307 * idx + 1);
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
    st.site = &ab_emlrtRSI;
    xgeqp3(&st, obj->QR, mrows, ncols, obj->jpvt, obj->tau);
  }
}

/* End of code generation (factorQRE.c) */
