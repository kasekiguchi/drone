/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * checkStoppingAndUpdateFval.c
 *
 * Code generation for function 'checkStoppingAndUpdateFval'
 *
 */

/* Include files */
#include "checkStoppingAndUpdateFval.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "computeFval_ReuseHx.h"
#include "eml_int_forloop_overflow_check.h"
#include "feasibleX0ForWorkingSet.h"
#include "maxConstraintViolation.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo jf_emlrtRSI = { 1,  /* lineNo */
  "checkStoppingAndUpdateFval",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+stopping\\checkStoppingAndUpdateFval.p"/* pathName */
};

/* Function Definitions */
void checkStoppingAndUpdateFval(L_HL_MPCfuncStackData *SD, const emlrtStack *sp,
  int32_T *activeSetChangeID, const real_T f[307], e_struct_T *solution,
  b_struct_T *memspace, const j_struct_T *objective, g_struct_T *workingset,
  k_struct_T *qrmanager, real_T options_ObjectiveLimit, int32_T
  runTimeOptions_MaxIterations, boolean_T updateFval)
{
  int32_T nVar;
  boolean_T nonDegenerateWset;
  real_T constrViolation_new;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  solution->iterations++;
  nVar = objective->nvar;
  if ((solution->iterations >= runTimeOptions_MaxIterations) &&
      ((solution->state != 1) || (objective->objtype == 5))) {
    solution->state = 0;
  }

  if (solution->iterations - solution->iterations / 50 * 50 == 0) {
    st.site = &jf_emlrtRSI;
    solution->maxConstr = b_maxConstraintViolation(&st, workingset,
      solution->xstar);
    if (solution->maxConstr > 1.0E-6) {
      st.site = &jf_emlrtRSI;
      f_xcopy(&st, objective->nvar, solution->xstar, solution->searchDir);
      st.site = &jf_emlrtRSI;
      nonDegenerateWset = feasibleX0ForWorkingSet(SD, &st,
        memspace->workspace_double, solution->searchDir, workingset, qrmanager);
      if ((!nonDegenerateWset) && (solution->state != 0)) {
        solution->state = -2;
      }

      *activeSetChangeID = 0;
      st.site = &jf_emlrtRSI;
      constrViolation_new = b_maxConstraintViolation(&st, workingset,
        solution->searchDir);
      if (constrViolation_new < solution->maxConstr) {
        st.site = &jf_emlrtRSI;
        if ((1 <= objective->nvar) && (objective->nvar > 2147483646)) {
          b_st.site = &e_emlrtRSI;
          check_forloop_overflow_error(&b_st);
        }

        if (0 <= nVar - 1) {
          memcpy(&solution->xstar[0], &solution->searchDir[0], nVar * sizeof
                 (real_T));
        }

        solution->maxConstr = constrViolation_new;
      }
    }
  }

  if ((options_ObjectiveLimit > rtMinusInf) && updateFval) {
    st.site = &jf_emlrtRSI;
    solution->fstar = computeFval_ReuseHx(&st, objective,
      memspace->workspace_double, f, solution->xstar);
    if ((solution->fstar < options_ObjectiveLimit) && ((solution->state != 0) ||
         (objective->objtype != 5))) {
      solution->state = 2;
    }
  }
}

/* End of code generation (checkStoppingAndUpdateFval.c) */
