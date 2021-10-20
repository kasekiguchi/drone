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
#include "fminconMEX_Trackobjective.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo i_emlrtRSI = { 1,   /* lineNo */
  "computeObjective_",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\computeObjective_.p"/* pathName */
};

/* Function Definitions */
void computeObjective_(const emlrtStack *sp, const struct0_T
  obj_objfun_tunableEnvironment[1], const real_T x[77], real_T *fval, int32_T
  *status)
{
  emlrtStack b_st;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &i_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b_st.site = &e_emlrtRSI;
  *fval = b_anon(&b_st, obj_objfun_tunableEnvironment[0].H,
                 obj_objfun_tunableEnvironment[0].state_size,
                 obj_objfun_tunableEnvironment[0].Q,
                 obj_objfun_tunableEnvironment[0].R,
                 obj_objfun_tunableEnvironment[0].Qf,
                 obj_objfun_tunableEnvironment[0].Xr, x);
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
