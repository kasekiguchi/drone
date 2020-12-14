/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factorQR.c
 *
 * Code generation for function 'factorQR'
 *
 */

/* Include files */
#include "factorQR.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgeqrf.h"

/* Variable Definitions */
static emlrtBCInfo yb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "factorQR",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factorQR.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void factorQR(const emlrtStack *sp, k_struct_T *obj, const real_T A[93635],
              int32_T mrows, int32_T ncols)
{
  int32_T idx;
  boolean_T guard1 = false;
  int32_T b_idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  idx = mrows * ncols;
  guard1 = false;
  if (idx > 0) {
    st.site = &ad_emlrtRSI;
    if ((1 <= ncols) && (ncols > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (b_idx = 0; b_idx < ncols; b_idx++) {
      st.site = &ad_emlrtRSI;
      d_xcopy(&st, mrows, A, 307 * b_idx + 1, obj->QR, 307 * b_idx + 1);
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
    obj->usedPivoting = false;
    obj->mrows = mrows;
    obj->ncols = ncols;
    st.site = &ad_emlrtRSI;
    if ((1 <= ncols) && (ncols > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (b_idx = 0; b_idx < ncols; b_idx++) {
      idx = b_idx + 1;
      if ((idx < 1) || (idx > 307)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, 307, &yb_emlrtBCI, sp);
      }

      obj->jpvt[idx - 1] = idx;
    }

    obj->minRowCol = muIntScalarMin_sint32(mrows, ncols);
    st.site = &ad_emlrtRSI;
    xgeqrf(&st, obj->QR, mrows, ncols, obj->tau);
  }
}

/* End of code generation (factorQR.c) */
