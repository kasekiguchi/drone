/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * evalObjAndConstrAndDerivatives.c
 *
 * Code generation for function 'evalObjAndConstrAndDerivatives'
 *
 */

/* Include files */
#include "evalObjAndConstrAndDerivatives.h"
#include "F_HL_MPCfunc.h"
#include "computeConstraints_.h"
#include "computeObjective_.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo ae_emlrtRSI = { 1,  /* lineNo */
  "evalObjAndConstrAndDerivatives",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\evalObjAndConstrAndDerivatives.p"/* pathName */
};

/* Function Definitions */
void evalObjAndConstrAndDerivatives(F_HL_MPCfuncStackData *SD, const emlrtStack *
  sp, const struct0_T obj_objfun_tunableEnvironment[1], const struct0_T
  obj_nonlcon_tunableEnvironment[1], const real_T x[132], real_T
  Cineq_workspace[176], real_T Ceq_workspace[88], real_T *fval, int32_T *status)
{
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ae_emlrtRSI;
  computeObjective_(&st, obj_objfun_tunableEnvironment, x, fval, status);
  if (*status == 1) {
    st.site = &ae_emlrtRSI;
    *status = computeConstraints_(SD, &st, obj_nonlcon_tunableEnvironment, x,
      Cineq_workspace, Ceq_workspace);
  }
}

/* End of code generation (evalObjAndConstrAndDerivatives.c) */
