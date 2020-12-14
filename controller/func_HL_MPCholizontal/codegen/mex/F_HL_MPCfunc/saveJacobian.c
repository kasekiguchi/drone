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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo bh_emlrtRSI = { 1,  /* lineNo */
  "saveJacobian",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+TrialState\\saveJacobian.p"/* pathName */
};

/* Function Definitions */
void saveJacobian(const emlrtStack *sp, e_struct_T *obj, int32_T nVar, const
                  real_T JacCineqTrans[85360], const real_T JacCeqTrans[42680])
{
  int32_T iCol;
  int32_T iCol_old;
  boolean_T overflow;
  int32_T idx_col;
  int32_T k;
  int32_T b_k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  iCol = -1;
  iCol_old = -1;
  st.site = &bh_emlrtRSI;
  overflow = ((1 <= nVar) && (nVar > 2147483646));
  for (idx_col = 0; idx_col < 176; idx_col++) {
    st.site = &bh_emlrtRSI;
    b_st.site = &xe_emlrtRSI;
    c_st.site = &ye_emlrtRSI;
    if (overflow) {
      d_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 0; k < nVar; k++) {
      b_k = k + 1;
      obj->JacCineqTrans_old[iCol_old + b_k] = JacCineqTrans[iCol + b_k];
    }

    iCol += 485;
    iCol_old += 485;
  }

  iCol = -1;
  iCol_old = -1;
  st.site = &bh_emlrtRSI;
  overflow = ((1 <= nVar) && (nVar > 2147483646));
  for (idx_col = 0; idx_col < 88; idx_col++) {
    st.site = &bh_emlrtRSI;
    b_st.site = &xe_emlrtRSI;
    c_st.site = &ye_emlrtRSI;
    if (overflow) {
      d_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 0; k < nVar; k++) {
      b_k = k + 1;
      obj->JacCeqTrans_old[iCol_old + b_k] = JacCeqTrans[iCol + b_k];
    }

    iCol += 485;
    iCol_old += 485;
  }
}

/* End of code generation (saveJacobian.c) */
