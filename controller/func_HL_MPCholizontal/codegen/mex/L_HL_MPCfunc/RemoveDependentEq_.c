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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "computeQ_.h"
#include "countsort.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQRE.h"
#include "moveConstraint_.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xgeqp3.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo oc_emlrtRSI = { 1,  /* lineNo */
  "RemoveDependentEq_",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p"/* pathName */
};

static emlrtRSInfo pc_emlrtRSI = { 1,  /* lineNo */
  "ComputeNumDependentEq_",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\ComputeNumDependentEq_.p"/* pathName */
};

static emlrtRSInfo tc_emlrtRSI = { 1,  /* lineNo */
  "IndexOfDependentEq_",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\IndexOfDependentEq_.p"/* pathName */
};

static emlrtRSInfo vc_emlrtRSI = { 1,  /* lineNo */
  "removeEqConstr",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p"/* pathName */
};

static emlrtBCInfo fb_emlrtBCI = { 1,  /* iFirst */
  6,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo gb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "IndexOfDependentEq_",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\IndexOfDependentEq_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo hb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentEq_",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ib_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentEq_",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentEq_",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo kb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "IndexOfDependentEq_",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\IndexOfDependentEq_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo lb_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo mb_emlrtBCI = { 1,  /* iFirst */
  88,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo ob_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo qb_emlrtBCI = { 1,  /* iFirst */
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
  int32_T mWorkingFixed;
  int32_T mTotalWorkingEq_tmp_tmp;
  int32_T ix;
  int32_T idx_col;
  int32_T k;
  int32_T i;
  real_T tol;
  boolean_T exitg1;
  real_T qtb;
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
  mWorkingFixed = workingset->nWConstr[0];
  mTotalWorkingEq_tmp_tmp = workingset->nWConstr[1] + workingset->nWConstr[0];
  nDepInd = 0;
  if (mTotalWorkingEq_tmp_tmp > 0) {
    st.site = &oc_emlrtRSI;
    if (mTotalWorkingEq_tmp_tmp > 2147483646) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (ix = 0; ix < mTotalWorkingEq_tmp_tmp; ix++) {
      st.site = &oc_emlrtRSI;
      if ((1 <= nVar) && (nVar > 2147483646)) {
        b_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idx_col = 0; idx_col < nVar; idx_col++) {
        k = ix + 1;
        if (k > 305) {
          emlrtDynamicBoundsCheckR2012b(k, 1, 305, &ib_emlrtBCI, sp);
        }

        i = ix + 1;
        if (i > 307) {
          emlrtDynamicBoundsCheckR2012b(i, 1, 307, &jb_emlrtBCI, sp);
        }

        qrmanager->QR[(i + 307 * idx_col) - 1] = workingset->ATwset[idx_col +
          307 * (k - 1)];
      }
    }

    st.site = &oc_emlrtRSI;
    ix = mTotalWorkingEq_tmp_tmp - workingset->nVar;
    nDepInd = muIntScalarMax_sint32(0, ix);
    b_st.site = &pc_emlrtRSI;
    if ((1 <= workingset->nVar) && (workingset->nVar > 2147483646)) {
      c_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    if (0 <= nVar - 1) {
      memset(&qrmanager->jpvt[0], 0, nVar * sizeof(int32_T));
    }

    b_st.site = &pc_emlrtRSI;
    qrmanager->usedPivoting = true;
    qrmanager->mrows = mTotalWorkingEq_tmp_tmp;
    qrmanager->ncols = workingset->nVar;
    qrmanager->minRowCol = muIntScalarMin_sint32(mTotalWorkingEq_tmp_tmp,
      workingset->nVar);
    c_st.site = &ab_emlrtRSI;
    xgeqp3(&c_st, qrmanager->QR, mTotalWorkingEq_tmp_tmp, workingset->nVar,
           qrmanager->jpvt, qrmanager->tau);
    tol = 100.0 * (real_T)workingset->nVar * 2.2204460492503131E-16;
    idx_col = muIntScalarMin_sint32(workingset->nVar, mTotalWorkingEq_tmp_tmp);
    while ((idx_col > 0) && (muDoubleScalarAbs(qrmanager->QR[(idx_col + 307 *
              (idx_col - 1)) - 1]) < tol)) {
      idx_col--;
      nDepInd++;
    }

    if (nDepInd > 0) {
      b_st.site = &pc_emlrtRSI;
      c_st.site = &fc_emlrtRSI;
      computeQ_(&c_st, qrmanager, mTotalWorkingEq_tmp_tmp);
      b_st.site = &pc_emlrtRSI;
      if (nDepInd > 2147483646) {
        c_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      idx_col = 0;
      exitg1 = false;
      while ((!exitg1) && (idx_col <= nDepInd - 1)) {
        ix = 307 * ((mTotalWorkingEq_tmp_tmp - idx_col) - 1);
        b_st.site = &pc_emlrtRSI;
        qtb = 0.0;
        nVar = 0;
        for (k = 0; k < mTotalWorkingEq_tmp_tmp; k++) {
          qtb += qrmanager->Q[ix] * workingset->bwset[nVar];
          ix++;
          nVar++;
        }

        if (muDoubleScalarAbs(qtb) >= tol) {
          nDepInd = -1;
          exitg1 = true;
        } else {
          idx_col++;
        }
      }
    }

    if (nDepInd > 0) {
      st.site = &oc_emlrtRSI;
      b_st.site = &tc_emlrtRSI;
      if ((1 <= workingset->nWConstr[0]) && (workingset->nWConstr[0] >
           2147483646)) {
        c_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx_col = 0; idx_col < mWorkingFixed; idx_col++) {
        k = idx_col + 1;
        if ((k < 1) || (k > 307)) {
          emlrtDynamicBoundsCheckR2012b(k, 1, 307, &gb_emlrtBCI, &st);
        }

        qrmanager->jpvt[k - 1] = 1;
      }

      ix = workingset->nWConstr[0] + 1;
      b_st.site = &tc_emlrtRSI;
      for (idx_col = ix; idx_col <= mTotalWorkingEq_tmp_tmp; idx_col++) {
        if ((idx_col < 1) || (idx_col > 307)) {
          emlrtDynamicBoundsCheckR2012b(idx_col, 1, 307, &gb_emlrtBCI, &st);
        }

        qrmanager->jpvt[idx_col - 1] = 0;
      }

      b_st.site = &tc_emlrtRSI;
      factorQRE(&b_st, qrmanager, workingset->ATwset, workingset->nVar,
                mTotalWorkingEq_tmp_tmp);
      b_st.site = &tc_emlrtRSI;
      for (idx_col = 0; idx_col < nDepInd; idx_col++) {
        k = ((mTotalWorkingEq_tmp_tmp - nDepInd) + idx_col) + 1;
        if ((k < 1) || (k > 307)) {
          emlrtDynamicBoundsCheckR2012b(k, 1, 307, &kb_emlrtBCI, &st);
        }

        i = idx_col + 1;
        if (i > 307) {
          emlrtDynamicBoundsCheckR2012b(i, 1, 307, &jb_emlrtBCI, &st);
        }

        memspace->workspace_int[i - 1] = qrmanager->jpvt[k - 1];
      }

      st.site = &oc_emlrtRSI;
      countsort(&st, memspace->workspace_int, nDepInd, memspace->workspace_sort,
                1, mTotalWorkingEq_tmp_tmp);
      for (idx_col = nDepInd; idx_col >= 1; idx_col--) {
        st.site = &oc_emlrtRSI;
        if (idx_col > 307) {
          emlrtDynamicBoundsCheckR2012b(idx_col, 1, 307, &hb_emlrtBCI, &st);
        }

        k = workingset->nWConstr[0] + workingset->nWConstr[1];
        if (k != 0) {
          i = memspace->workspace_int[idx_col - 1];
          if (i <= k) {
            if ((workingset->nActiveConstr == k) || (i == k)) {
              workingset->mEqRemoved++;
              if ((i < 1) || (i > 305)) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int[idx_col -
                  1], 1, 305, &lb_emlrtBCI, &st);
              }

              if ((workingset->mEqRemoved < 1) || (workingset->mEqRemoved > 88))
              {
                emlrtDynamicBoundsCheckR2012b(workingset->mEqRemoved, 1, 88,
                  &mb_emlrtBCI, &st);
              }

              k = memspace->workspace_int[idx_col - 1] - 1;
              workingset->indexEqRemoved[workingset->mEqRemoved - 1] =
                workingset->Wlocalidx[k];
              b_st.site = &vc_emlrtRSI;
              nVar = workingset->Wid[k];
              i = workingset->Wid[k];
              if ((i < 1) || (i > 6)) {
                emlrtDynamicBoundsCheckR2012b(i, 1, 6, &eb_emlrtBCI, &b_st);
              }

              k = (workingset->isActiveIdx[workingset->Wid[k] - 1] +
                   workingset->Wlocalidx[k]) - 1;
              if ((k < 1) || (k > 305)) {
                emlrtDynamicBoundsCheckR2012b(k, 1, 305, &pb_emlrtBCI, &b_st);
              }

              workingset->isActiveConstr[k - 1] = false;
              c_st.site = &wc_emlrtRSI;
              moveConstraint_(&c_st, workingset, workingset->nActiveConstr,
                              memspace->workspace_int[idx_col - 1]);
              workingset->nActiveConstr--;
              if ((nVar < 1) || (nVar > 5)) {
                emlrtDynamicBoundsCheckR2012b(nVar, 1, 5, &rb_emlrtBCI, &b_st);
              }

              workingset->nWConstr[nVar - 1]--;
            } else {
              workingset->mEqRemoved++;
              if ((i < 1) || (i > 305)) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int[idx_col -
                  1], 1, 305, &lb_emlrtBCI, &st);
              }

              ix = i - 1;
              nVar = workingset->Wid[ix];
              if ((workingset->mEqRemoved < 1) || (workingset->mEqRemoved > 88))
              {
                emlrtDynamicBoundsCheckR2012b(workingset->mEqRemoved, 1, 88,
                  &mb_emlrtBCI, &st);
              }

              workingset->indexEqRemoved[workingset->mEqRemoved - 1] =
                workingset->Wlocalidx[ix];
              i = workingset->Wid[ix];
              if ((i < 1) || (i > 6)) {
                emlrtDynamicBoundsCheckR2012b(i, 1, 6, &fb_emlrtBCI, &st);
              }

              i = (workingset->isActiveIdx[workingset->Wid[ix] - 1] +
                   workingset->Wlocalidx[ix]) - 1;
              if ((i < 1) || (i > 305)) {
                emlrtDynamicBoundsCheckR2012b(i, 1, 305, &ob_emlrtBCI, &st);
              }

              workingset->isActiveConstr[i - 1] = false;
              b_st.site = &vc_emlrtRSI;
              moveConstraint_(&b_st, workingset, k, memspace->
                              workspace_int[idx_col - 1]);
              b_st.site = &vc_emlrtRSI;
              moveConstraint_(&b_st, workingset, workingset->nActiveConstr, k);
              workingset->nActiveConstr--;
              if ((nVar < 1) || (nVar > 5)) {
                emlrtDynamicBoundsCheckR2012b(nVar, 1, 5, &qb_emlrtBCI, &st);
              }

              workingset->nWConstr[nVar - 1]--;
            }
          }
        }
      }
    }
  }

  return nDepInd;
}

/* End of code generation (RemoveDependentEq_.c) */
