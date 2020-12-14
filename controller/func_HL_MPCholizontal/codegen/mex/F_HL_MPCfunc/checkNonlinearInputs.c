/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * checkNonlinearInputs.c
 *
 * Code generation for function 'checkNonlinearInputs'
 *
 */

/* Include files */
#include "checkNonlinearInputs.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo c_emlrtRSI = { 1,   /* lineNo */
  "checkNonlinearInputs",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseinput\\checkNonlinearInputs.p"/* pathName */
};

/* Function Definitions */
void checkNonlinearInputs(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const
  real_T x0[132], const struct0_T nonlcon_tunableEnvironment[1])
{
  real_T varargout_1[176];
  real_T varargout_2[88];
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &c_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  b_st.site = &d_emlrtRSI;
  __anon_fcn(SD, &b_st, nonlcon_tunableEnvironment[0].state_size,
             nonlcon_tunableEnvironment[0].Num, nonlcon_tunableEnvironment[0].
             Slew, nonlcon_tunableEnvironment[0].D_lim,
             nonlcon_tunableEnvironment[0].r_limit, nonlcon_tunableEnvironment[0]
             .A, nonlcon_tunableEnvironment[0].B, nonlcon_tunableEnvironment[0].
             wall_width_y, nonlcon_tunableEnvironment[0].wall_width_x,
             nonlcon_tunableEnvironment[0].sectionpoint,
             nonlcon_tunableEnvironment[0].Section_change,
             nonlcon_tunableEnvironment[0].S_front, nonlcon_tunableEnvironment[0]
             .front, nonlcon_tunableEnvironment[0].behind,
             nonlcon_tunableEnvironment[0].X0, x0, varargout_1, varargout_2);
}

/* End of code generation (checkNonlinearInputs.c) */
