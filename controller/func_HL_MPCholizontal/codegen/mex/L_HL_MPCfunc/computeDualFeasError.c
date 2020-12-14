/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeDualFeasError.c
 *
 * Code generation for function 'computeDualFeasError'
 *
 */

/* Include files */
#include "computeDualFeasError.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo w_emlrtRSI = { 1,   /* lineNo */
  "computeDualFeasError",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeDualFeasError.p"/* pathName */
};

/* Function Definitions */
void b_computeDualFeasError(const emlrtStack *sp, int32_T nVar, const real_T
  gradLag[94249], boolean_T *gradOK, real_T *val)
{
  int32_T idx;
  boolean_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  *gradOK = true;
  *val = 0.0;
  st.site = &w_emlrtRSI;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  idx = 0;
  exitg1 = false;
  while ((!exitg1) && (idx <= nVar - 1)) {
    *gradOK = ((!muDoubleScalarIsInf(gradLag[idx])) && (!muDoubleScalarIsNaN
                (gradLag[idx])));
    if (!*gradOK) {
      exitg1 = true;
    } else {
      *val = muDoubleScalarMax(*val, muDoubleScalarAbs(gradLag[idx]));
      idx++;
    }
  }
}

void computeDualFeasError(const emlrtStack *sp, int32_T nVar, const real_T
  gradLag[307], boolean_T *gradOK, real_T *val)
{
  int32_T idx;
  boolean_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  *gradOK = true;
  *val = 0.0;
  st.site = &w_emlrtRSI;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  idx = 0;
  exitg1 = false;
  while ((!exitg1) && (idx <= nVar - 1)) {
    *gradOK = ((!muDoubleScalarIsInf(gradLag[idx])) && (!muDoubleScalarIsNaN
                (gradLag[idx])));
    if (!*gradOK) {
      exitg1 = true;
    } else {
      *val = muDoubleScalarMax(*val, muDoubleScalarAbs(gradLag[idx]));
      idx++;
    }
  }
}

/* End of code generation (computeDualFeasError.c) */
