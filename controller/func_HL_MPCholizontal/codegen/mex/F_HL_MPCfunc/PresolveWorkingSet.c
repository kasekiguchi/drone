/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * PresolveWorkingSet.c
 *
 * Code generation for function 'PresolveWorkingSet'
 *
 */

/* Include files */
#include "PresolveWorkingSet.h"
#include "F_HL_MPCfunc.h"
#include "RemoveDependentEq_.h"
#include "RemoveDependentIneq_.h"
#include "feasibleX0ForWorkingSet.h"
#include "maxConstraintViolation.h"
#include "removeAllIneqConstr.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo ki_emlrtRSI = { 1,  /* lineNo */
  "PresolveWorkingSet",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\PresolveWorkingSet.p"/* pathName */
};

/* Function Definitions */
void PresolveWorkingSet(F_HL_MPCfuncStackData *SD, const emlrtStack *sp,
  e_struct_T *solution, b_struct_T *memspace, g_struct_T *workingset, k_struct_T
  *qrmanager)
{
  int32_T i;
  boolean_T okWorkingSet;
  boolean_T guard1 = false;
  real_T constrViolation;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  solution->state = 82;
  st.site = &ki_emlrtRSI;
  i = RemoveDependentEq_(&st, memspace, workingset, qrmanager);
  if (i != -1) {
    st.site = &ki_emlrtRSI;
    RemoveDependentIneq_(&st, workingset, qrmanager, memspace, 100.0);
    st.site = &ki_emlrtRSI;
    okWorkingSet = feasibleX0ForWorkingSet(SD, &st, memspace->workspace_double,
      solution->xstar, workingset, qrmanager);
    guard1 = false;
    if (!okWorkingSet) {
      st.site = &ki_emlrtRSI;
      RemoveDependentIneq_(&st, workingset, qrmanager, memspace, 1000.0);
      st.site = &ki_emlrtRSI;
      okWorkingSet = feasibleX0ForWorkingSet(SD, &st, memspace->workspace_double,
        solution->xstar, workingset, qrmanager);
      if (!okWorkingSet) {
        solution->state = -7;
      } else {
        guard1 = true;
      }
    } else {
      guard1 = true;
    }

    if (guard1 && (workingset->nWConstr[0] + workingset->nWConstr[1] ==
                   workingset->nVar)) {
      st.site = &ki_emlrtRSI;
      constrViolation = b_maxConstraintViolation(&st, workingset,
        solution->xstar);
      if (constrViolation > 1.0E-6) {
        solution->state = -2;
      }
    }
  } else {
    solution->state = -3;
    st.site = &ki_emlrtRSI;
    removeAllIneqConstr(&st, workingset);
  }
}

/* End of code generation (PresolveWorkingSet.c) */
