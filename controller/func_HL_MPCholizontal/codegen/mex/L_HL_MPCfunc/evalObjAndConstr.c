/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * evalObjAndConstr.c
 *
 * Code generation for function 'evalObjAndConstr'
 *
 */

/* Include files */
#include "evalObjAndConstr.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "computeConstraints_.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void evalObjAndConstr(const emlrtStack *sp, const struct0_T
                      obj_objfun_tunableEnvironment[1], const real_T
                      c_obj_nonlcon_tunableEnvironmen[8], real_T
                      d_obj_nonlcon_tunableEnvironmen, const real_T
                      e_obj_nonlcon_tunableEnvironmen[64], const real_T
                      f_obj_nonlcon_tunableEnvironmen[16], const real_T x[110],
                      real_T Cineq_workspace[20], real_T Ceq_workspace[88],
                      real_T *fval, int32_T *status)
{
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  *fval = __anon_fcn(obj_objfun_tunableEnvironment[0].Q,
                     obj_objfun_tunableEnvironment[0].Qf,
                     obj_objfun_tunableEnvironment[0].R,
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

  if (*status == 1) {
    st.site = &yf_emlrtRSI;
    *status = computeConstraints_(&st, c_obj_nonlcon_tunableEnvironmen,
      d_obj_nonlcon_tunableEnvironmen, e_obj_nonlcon_tunableEnvironmen,
      f_obj_nonlcon_tunableEnvironmen, x, Cineq_workspace, Ceq_workspace);
  }
}

/* End of code generation (evalObjAndConstr.c) */
