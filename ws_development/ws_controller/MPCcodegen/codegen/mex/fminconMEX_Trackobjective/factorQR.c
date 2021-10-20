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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgeqrf.h"
#include "mwmathutil.h"

/* Function Definitions */
void factorQR(const emlrtStack *sp, g_struct_T *obj, const emxArray_real_T *A,
              int32_T mrows, int32_T ncols)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T i;
  int32_T idx;
  boolean_T guard1 = false;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  i = mrows * ncols;
  guard1 = false;
  if (i > 0) {
    st.site = &md_emlrtRSI;
    if ((1 <= ncols) && (ncols > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < ncols; idx++) {
      st.site = &md_emlrtRSI;
      xcopy(mrows, A, A->size[0] * idx + 1, obj->QR, obj->ldq * idx + 1);
    }

    guard1 = true;
  } else if (i == 0) {
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
    st.site = &md_emlrtRSI;
    if ((1 <= ncols) && (ncols > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < ncols; idx++) {
      i = obj->jpvt->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &mc_emlrtBCI, sp);
      }

      obj->jpvt->data[idx] = idx + 1;
    }

    obj->minRowCol = muIntScalarMin_sint32(mrows, ncols);
    st.site = &md_emlrtRSI;
    xgeqrf(&st, obj->QR, mrows, ncols, obj->tau);
  }
}

/* End of code generation (factorQR.c) */
