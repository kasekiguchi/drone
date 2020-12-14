/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * assignResidualsToXSlack.c
 *
 * Code generation for function 'assignResidualsToXSlack'
 *
 */

/* Include files */
#include "assignResidualsToXSlack.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "addBoundToActiveSetMatrix_.h"
#include "rt_nonfinite.h"
#include "xgemv.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo ik_emlrtRSI = { 1,  /* lineNo */
  "assignResidualsToXSlack",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\assignResidualsToXSlack.p"/* pathName */
};

static emlrtBCInfo ve_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "assignResidualsToXSlack",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\assignResidualsToXSlack.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void assignResidualsToXSlack(const emlrtStack *sp, int32_T nVarOrig, g_struct_T *
  WorkingSet, e_struct_T *TrialState, b_struct_T *memspace)
{
  int32_T mLBOrig;
  int32_T idx;
  int32_T i;
  int32_T i1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  mLBOrig = WorkingSet->sizes[3] - 175;
  st.site = &ik_emlrtRSI;
  memcpy(&memspace->workspace_double[0], &WorkingSet->bineq[0], 176U * sizeof
         (real_T));
  st.site = &ik_emlrtRSI;
  p_xgemv(nVarOrig, WorkingSet->Aineq, TrialState->xstar,
          memspace->workspace_double);
  st.site = &ik_emlrtRSI;
  for (idx = 0; idx < 176; idx++) {
    i = (nVarOrig + idx) + 1;
    if ((i < 1) || (i > 485)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 485, &ve_emlrtBCI, sp);
    }

    TrialState->xstar[i - 1] = (real_T)(memspace->workspace_double[idx] > 0.0) *
      memspace->workspace_double[idx];
    if (memspace->workspace_double[idx] <= 1.0E-6) {
      st.site = &ik_emlrtRSI;
      b_st.site = &vj_emlrtRSI;
      addBoundToActiveSetMatrix_(&b_st, WorkingSet, 4, (mLBOrig + idx) - 176);
    }
  }

  st.site = &ik_emlrtRSI;
  memcpy(&memspace->workspace_double[0], &WorkingSet->beq[0], 88U * sizeof
         (real_T));
  st.site = &ik_emlrtRSI;
  r_xgemv(nVarOrig, WorkingSet->Aeq, TrialState->xstar,
          memspace->workspace_double);
  st.site = &ik_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    if (memspace->workspace_double[idx] <= 0.0) {
      i = nVarOrig + idx;
      i1 = i + 177;
      if ((i1 < 1) || (i1 > 485)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, 485, &ve_emlrtBCI, sp);
      }

      TrialState->xstar[i1 - 1] = 0.0;
      i += 265;
      if ((i < 1) || (i > 485)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 485, &ve_emlrtBCI, sp);
      }

      TrialState->xstar[i - 1] = -memspace->workspace_double[idx];
      st.site = &ik_emlrtRSI;
      b_st.site = &vj_emlrtRSI;
      addBoundToActiveSetMatrix_(&b_st, WorkingSet, 4, mLBOrig + idx);
      if (memspace->workspace_double[idx] >= -1.0E-6) {
        st.site = &ik_emlrtRSI;
        b_st.site = &vj_emlrtRSI;
        addBoundToActiveSetMatrix_(&b_st, WorkingSet, 4, (mLBOrig + idx) + 88);
      }
    } else {
      i = nVarOrig + idx;
      i1 = i + 177;
      if ((i1 < 1) || (i1 > 485)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, 485, &ve_emlrtBCI, sp);
      }

      TrialState->xstar[i1 - 1] = memspace->workspace_double[idx];
      i += 265;
      if ((i < 1) || (i > 485)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 485, &ve_emlrtBCI, sp);
      }

      TrialState->xstar[i - 1] = 0.0;
      st.site = &ik_emlrtRSI;
      b_st.site = &vj_emlrtRSI;
      addBoundToActiveSetMatrix_(&b_st, WorkingSet, 4, (mLBOrig + idx) + 88);
      if (memspace->workspace_double[idx] <= 1.0E-6) {
        st.site = &ik_emlrtRSI;
        b_st.site = &vj_emlrtRSI;
        addBoundToActiveSetMatrix_(&b_st, WorkingSet, 4, mLBOrig + idx);
      }
    }
  }
}

/* End of code generation (assignResidualsToXSlack.c) */
