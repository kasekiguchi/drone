/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * finDiffEvalAndChkErr.c
 *
 * Code generation for function 'finDiffEvalAndChkErr'
 *
 */

/* Include files */
#include "finDiffEvalAndChkErr.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo ve_emlrtRSI = { 1,  /* lineNo */
  "finDiffEvalAndChkErr",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\finDiffEvalAndChkErr.p"/* pathName */
};

/* Function Definitions */
boolean_T finDiffEvalAndChkErr(F_HL_MPCfuncStackData *SD, const emlrtStack *sp,
  const struct0_T obj_objfun_tunableEnvironment[1], const struct0_T
  obj_nonlin_tunableEnvironment[1], real_T *fplus, real_T cIneqPlus[176], real_T
  cEqPlus[88], int32_T dim, real_T delta, real_T xk[132])
{
  boolean_T evalOK;
  real_T temp_tmp;
  real_T varargout_1[176];
  int32_T idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  temp_tmp = xk[dim - 1];
  xk[dim - 1] = temp_tmp + delta;
  st.site = &ve_emlrtRSI;
  b_st.site = &d_emlrtRSI;
  *fplus = d___anon_fcn(&b_st, &obj_objfun_tunableEnvironment[0], xk);
  evalOK = ((!muDoubleScalarIsInf(*fplus)) && (!muDoubleScalarIsNaN(*fplus)));
  if (evalOK) {
    st.site = &ve_emlrtRSI;
    b_st.site = &d_emlrtRSI;
    __anon_fcn(SD, &b_st, obj_nonlin_tunableEnvironment[0].state_size,
               obj_nonlin_tunableEnvironment[0].Num,
               obj_nonlin_tunableEnvironment[0].Slew,
               obj_nonlin_tunableEnvironment[0].D_lim,
               obj_nonlin_tunableEnvironment[0].r_limit,
               obj_nonlin_tunableEnvironment[0].A,
               obj_nonlin_tunableEnvironment[0].B,
               obj_nonlin_tunableEnvironment[0].wall_width_y,
               obj_nonlin_tunableEnvironment[0].wall_width_x,
               obj_nonlin_tunableEnvironment[0].sectionpoint,
               obj_nonlin_tunableEnvironment[0].Section_change,
               obj_nonlin_tunableEnvironment[0].S_front,
               obj_nonlin_tunableEnvironment[0].front,
               obj_nonlin_tunableEnvironment[0].behind,
               obj_nonlin_tunableEnvironment[0].X0, xk, varargout_1, cEqPlus);
    memcpy(&cIneqPlus[0], &varargout_1[0], 176U * sizeof(real_T));
    idx = 0;
    while (evalOK && (idx + 1 <= 176)) {
      evalOK = ((!muDoubleScalarIsInf(cIneqPlus[idx])) && (!muDoubleScalarIsNaN
                 (cIneqPlus[idx])));
      idx++;
    }

    if (evalOK) {
      idx = 0;
      while (evalOK && (idx + 1 <= 88)) {
        evalOK = ((!muDoubleScalarIsInf(cEqPlus[idx])) && (!muDoubleScalarIsNaN
                   (cEqPlus[idx])));
        idx++;
      }

      xk[dim - 1] = temp_tmp;
    }
  }

  return evalOK;
}

/* End of code generation (finDiffEvalAndChkErr.c) */
