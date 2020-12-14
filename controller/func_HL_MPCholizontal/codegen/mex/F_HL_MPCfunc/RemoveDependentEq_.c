/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * RemoveDependentEq_.c
 *
 * Code generation for function 'RemoveDependentEq_'
 *
 */

/* Include files */
#include "RemoveDependentEq_.h"
#include "ComputeNumDependentEq_.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "IndexOfDependentEq_.h"
#include "countsort.h"
#include "eml_int_forloop_overflow_check.h"
#include "moveConstraint_.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo eh_emlrtRSI = { 1,  /* lineNo */
  "RemoveDependentEq_",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p"/* pathName */
};

static emlrtRSInfo lh_emlrtRSI = { 1,  /* lineNo */
  "removeEqConstr",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p"/* pathName */
};

static emlrtBCInfo dc_emlrtBCI = { 1,  /* iFirst */
  6,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ec_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentEq_",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fc_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentEq_",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo gc_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hc_emlrtBCI = { 1,  /* iFirst */
  88,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo jc_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo lc_emlrtBCI = { 1,  /* iFirst */
  5,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
int32_T RemoveDependentEq_(const emlrtStack *sp, b_struct_T *memspace,
  g_struct_T *workingset, k_struct_T *qrmanager)
{
  int32_T nDepInd;
  int32_T nVar;
  int32_T TYPE;
  int32_T idx_row;
  int32_T idx_col;
  int32_T i;
  int32_T i1;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  nVar = workingset->nVar;
  TYPE = workingset->nWConstr[1] + workingset->nWConstr[0];
  nDepInd = 0;
  if (TYPE > 0) {
    st.site = &eh_emlrtRSI;
    if (TYPE > 2147483646) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx_row = 0; idx_row < TYPE; idx_row++) {
      st.site = &eh_emlrtRSI;
      if ((1 <= nVar) && (nVar > 2147483646)) {
        b_st.site = &t_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idx_col = 0; idx_col < nVar; idx_col++) {
        i = idx_row + 1;
        if (i > 617) {
          emlrtDynamicBoundsCheckR2012b(i, 1, 617, &ec_emlrtBCI, sp);
        }

        i1 = idx_row + 1;
        if (i1 > 617) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, 617, &fc_emlrtBCI, sp);
        }

        qrmanager->QR[(i1 + 617 * idx_col) - 1] = workingset->ATwset[idx_col +
          485 * (i - 1)];
      }
    }

    st.site = &eh_emlrtRSI;
    nDepInd = ComputeNumDependentEq_(&st, qrmanager, workingset->bwset, TYPE,
      workingset->nVar);
    if (nDepInd > 0) {
      st.site = &eh_emlrtRSI;
      IndexOfDependentEq_(&st, memspace->workspace_int, workingset->nWConstr[0],
                          nDepInd, qrmanager, workingset->ATwset,
                          workingset->nVar, TYPE);
      st.site = &eh_emlrtRSI;
      countsort(&st, memspace->workspace_int, nDepInd, memspace->workspace_sort,
                1, TYPE);
      for (idx_row = nDepInd; idx_row >= 1; idx_row--) {
        st.site = &eh_emlrtRSI;
        if (idx_row > 617) {
          emlrtDynamicBoundsCheckR2012b(idx_row, 1, 617, &ec_emlrtBCI, &st);
        }

        i = workingset->nWConstr[0] + workingset->nWConstr[1];
        if (i != 0) {
          i1 = memspace->workspace_int[idx_row - 1];
          if (i1 <= i) {
            if ((workingset->nActiveConstr == i) || (i1 == i)) {
              workingset->mEqRemoved++;
              if ((i1 < 1) || (i1 > 617)) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int[idx_row -
                  1], 1, 617, &gc_emlrtBCI, &st);
              }

              if ((workingset->mEqRemoved < 1) || (workingset->mEqRemoved > 88))
              {
                emlrtDynamicBoundsCheckR2012b(workingset->mEqRemoved, 1, 88,
                  &hc_emlrtBCI, &st);
              }

              i = memspace->workspace_int[idx_row - 1] - 1;
              workingset->indexEqRemoved[workingset->mEqRemoved - 1] =
                workingset->Wlocalidx[i];
              b_st.site = &lh_emlrtRSI;
              TYPE = workingset->Wid[i];
              i1 = workingset->Wid[i];
              if ((i1 < 1) || (i1 > 6)) {
                emlrtDynamicBoundsCheckR2012b(i1, 1, 6, &cc_emlrtBCI, &b_st);
              }

              i = (workingset->isActiveIdx[workingset->Wid[i] - 1] +
                   workingset->Wlocalidx[i]) - 1;
              if ((i < 1) || (i > 617)) {
                emlrtDynamicBoundsCheckR2012b(i, 1, 617, &kc_emlrtBCI, &b_st);
              }

              workingset->isActiveConstr[i - 1] = false;
              c_st.site = &mh_emlrtRSI;
              moveConstraint_(&c_st, workingset, workingset->nActiveConstr,
                              memspace->workspace_int[idx_row - 1]);
              workingset->nActiveConstr--;
              if ((TYPE < 1) || (TYPE > 5)) {
                emlrtDynamicBoundsCheckR2012b(TYPE, 1, 5, &mc_emlrtBCI, &b_st);
              }

              workingset->nWConstr[TYPE - 1]--;
            } else {
              workingset->mEqRemoved++;
              if ((i1 < 1) || (i1 > 617)) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int[idx_row -
                  1], 1, 617, &gc_emlrtBCI, &st);
              }

              nVar = i1 - 1;
              TYPE = workingset->Wid[nVar];
              if ((workingset->mEqRemoved < 1) || (workingset->mEqRemoved > 88))
              {
                emlrtDynamicBoundsCheckR2012b(workingset->mEqRemoved, 1, 88,
                  &hc_emlrtBCI, &st);
              }

              workingset->indexEqRemoved[workingset->mEqRemoved - 1] =
                workingset->Wlocalidx[nVar];
              i1 = workingset->Wid[nVar];
              if ((i1 < 1) || (i1 > 6)) {
                emlrtDynamicBoundsCheckR2012b(i1, 1, 6, &dc_emlrtBCI, &st);
              }

              i1 = (workingset->isActiveIdx[workingset->Wid[nVar] - 1] +
                    workingset->Wlocalidx[nVar]) - 1;
              if ((i1 < 1) || (i1 > 617)) {
                emlrtDynamicBoundsCheckR2012b(i1, 1, 617, &jc_emlrtBCI, &st);
              }

              workingset->isActiveConstr[i1 - 1] = false;
              b_st.site = &lh_emlrtRSI;
              moveConstraint_(&b_st, workingset, i, memspace->
                              workspace_int[idx_row - 1]);
              b_st.site = &lh_emlrtRSI;
              moveConstraint_(&b_st, workingset, workingset->nActiveConstr, i);
              workingset->nActiveConstr--;
              if ((TYPE < 1) || (TYPE > 5)) {
                emlrtDynamicBoundsCheckR2012b(TYPE, 1, 5, &lc_emlrtBCI, &st);
              }

              workingset->nWConstr[TYPE - 1]--;
            }
          }
        }
      }
    }
  }

  return nDepInd;
}

/* End of code generation (RemoveDependentEq_.c) */
