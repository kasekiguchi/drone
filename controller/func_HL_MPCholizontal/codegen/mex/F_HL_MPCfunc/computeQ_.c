/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeQ_.c
 *
 * Code generation for function 'computeQ_'
 *
 */

/* Include files */
#include "computeQ_.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xorgqr.h"

/* Variable Definitions */
static emlrtRSInfo vg_emlrtRSI = { 1,  /* lineNo */
  "computeQ_",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\computeQ_.p"/* pathName */
};

/* Function Definitions */
void computeQ_(const emlrtStack *sp, k_struct_T *obj, int32_T nrows)
{
  int32_T b;
  int32_T idx;
  int32_T iQR0;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b = obj->minRowCol;
  st.site = &vg_emlrtRSI;
  if ((1 <= obj->minRowCol) && (obj->minRowCol > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < b; idx++) {
    iQR0 = (617 * idx + idx) + 2;
    st.site = &vg_emlrtRSI;
    e_xcopy((obj->mrows - idx) - 1, obj->QR, iQR0, obj->Q, iQR0);
  }

  st.site = &vg_emlrtRSI;
  xorgqr(&st, obj->mrows, nrows, obj->minRowCol, obj->Q, obj->tau);
}

/* End of code generation (computeQ_.c) */
