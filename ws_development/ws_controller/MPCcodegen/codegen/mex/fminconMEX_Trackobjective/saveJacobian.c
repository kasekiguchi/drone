/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * saveJacobian.c
 *
 * Code generation for function 'saveJacobian'
 *
 */

/* Include files */
#include "saveJacobian.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xcopy.h"

/* Variable Definitions */
static emlrtRSInfo vc_emlrtRSI = { 1,  /* lineNo */
  "saveJacobian",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+TrialState\\saveJacobian.p"/* pathName */
};

/* Function Definitions */
void saveJacobian(const emlrtStack *sp, d_struct_T *obj, int32_T nVar, int32_T
                  mIneq, const emxArray_real_T *JacCineqTrans, int32_T ineqCol0,
                  int32_T mEq, const emxArray_real_T *JacCeqTrans, int32_T
                  eqCol0, int32_T ldJ)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T b;
  int32_T iCol;
  int32_T iCol_old;
  int32_T idx_col;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  iCol = ldJ * (ineqCol0 - 1) + 1;
  iCol_old = 1;
  b = (mIneq - ineqCol0) + 1;
  st.site = &vc_emlrtRSI;
  if ((1 <= b) && (b > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx_col = 0; idx_col < b; idx_col++) {
    st.site = &vc_emlrtRSI;
    xcopy(nVar, JacCineqTrans, iCol, obj->JacCineqTrans_old, iCol_old);
    iCol += ldJ;
    iCol_old += ldJ;
  }

  iCol = ldJ * (eqCol0 - 1) + 1;
  iCol_old = 1;
  b = (mEq - eqCol0) + 1;
  st.site = &vc_emlrtRSI;
  if ((1 <= b) && (b > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx_col = 0; idx_col < b; idx_col++) {
    st.site = &vc_emlrtRSI;
    xcopy(nVar, JacCeqTrans, iCol, obj->JacCeqTrans_old, iCol_old);
    iCol += ldJ;
    iCol_old += ldJ;
  }
}

/* End of code generation (saveJacobian.c) */
