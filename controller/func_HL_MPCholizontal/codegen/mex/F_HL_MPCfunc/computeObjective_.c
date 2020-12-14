/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeObjective_.c
 *
 * Code generation for function 'computeObjective_'
 *
 */

/* Include files */
#include "computeObjective_.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo be_emlrtRSI = { 1,  /* lineNo */
  "computeObjective_",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\computeObjective_.p"/* pathName */
};

/* Function Definitions */
void computeObjective_(const emlrtStack *sp, const struct0_T
  obj_objfun_tunableEnvironment[1], const real_T x[132], real_T *fval, int32_T
  *status)
{
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &be_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b_st.site = &d_emlrtRSI;
  *fval = d___anon_fcn(&b_st, &obj_objfun_tunableEnvironment[0], x);
  *status = 1;
  if (muDoubleScalarIsInf(*fval) || muDoubleScalarIsNaN(*fval)) {
    if (muDoubleScalarIsNaN(*fval)) {
      *status = -6;
    } else if (*fval < 0.0) {
      *status = -4;
    } else {
      *status = -5;
    }
  }
}

/* End of code generation (computeObjective_.c) */
