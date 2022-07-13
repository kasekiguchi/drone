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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xorgqr.h"

/* Variable Definitions */
static emlrtRSInfo pc_emlrtRSI = { 1,  /* lineNo */
  "computeQ_",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\computeQ_.p"/* pathName */
};

/* Function Definitions */
void computeQ_(const emlrtStack *sp, g_struct_T *obj, int32_T nrows)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T b;
  int32_T iQR0;
  int32_T idx;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b = obj->minRowCol;
  st.site = &pc_emlrtRSI;
  if ((1 <= obj->minRowCol) && (obj->minRowCol > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < b; idx++) {
    iQR0 = (obj->ldq * idx + idx) + 2;
    st.site = &pc_emlrtRSI;
    xcopy((obj->mrows - idx) - 1, obj->QR, iQR0, obj->Q, iQR0);
  }

  st.site = &pc_emlrtRSI;
  xorgqr(&st, obj->mrows, nrows, obj->minRowCol, obj->Q, obj->ldq, obj->tau);
}

/* End of code generation (computeQ_.c) */
