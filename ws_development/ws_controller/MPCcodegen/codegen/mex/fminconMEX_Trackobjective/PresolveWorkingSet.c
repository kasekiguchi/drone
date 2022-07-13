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
#include "ComputeNumDependentEq_.h"
#include "IndexOfDependentEq_.h"
#include "countsort.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQRE.h"
#include "feasibleX0ForWorkingSet.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "maxConstraintViolation.h"
#include "moveConstraint_.h"
#include "removeAllIneqConstr.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo cd_emlrtRSI = { 1,  /* lineNo */
  "PresolveWorkingSet",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\PresolveWorkingSet.p"/* pathName */
};

static emlrtRSInfo dd_emlrtRSI = { 1,  /* lineNo */
  "RemoveDependentEq_",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p"/* pathName */
};

static emlrtRSInfo hd_emlrtRSI = { 1,  /* lineNo */
  "removeEqConstr",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p"/* pathName */
};

static emlrtRSInfo kd_emlrtRSI = { 1,  /* lineNo */
  "RemoveDependentIneq_",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentIneq_.p"/* pathName */
};

static emlrtBCInfo yb_emlrtBCI = { 1,  /* iFirst */
  6,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ac_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentIneq_",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentIneq_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentEq_",                /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentEq_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo dc_emlrtBCI = { 1,  /* iFirst */
  5,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeEqConstr",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeEqConstr.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void PresolveWorkingSet(const emlrtStack *sp, d_struct_T *solution, c_struct_T
  *memspace, j_struct_T *workingset, g_struct_T *qrmanager)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack st;
  real_T tol;
  int32_T TYPE;
  int32_T i;
  int32_T idx;
  int32_T idx_col;
  int32_T idx_row;
  int32_T nVar;
  boolean_T exitg1;
  boolean_T guard1 = false;
  boolean_T okWorkingSet;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  solution->state = 82;
  st.site = &cd_emlrtRSI;
  nVar = workingset->nVar;
  TYPE = workingset->nWConstr[1] + workingset->nWConstr[0];
  idx_row = 0;
  if (TYPE > 0) {
    b_st.site = &dd_emlrtRSI;
    if (TYPE > 2147483646) {
      c_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx_row = 0; idx_row < TYPE; idx_row++) {
      b_st.site = &dd_emlrtRSI;
      if ((1 <= nVar) && (nVar > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx_col = 0; idx_col < nVar; idx_col++) {
        i = workingset->ATwset->size[0];
        if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &bc_emlrtBCI, &st);
        }

        i = workingset->ATwset->size[1];
        if (idx_row + 1 > i) {
          emlrtDynamicBoundsCheckR2012b(idx_row + 1, 1, i, &bc_emlrtBCI, &st);
        }

        i = qrmanager->QR->size[0];
        if (idx_row + 1 > i) {
          emlrtDynamicBoundsCheckR2012b(idx_row + 1, 1, i, &bc_emlrtBCI, &st);
        }

        i = qrmanager->QR->size[1];
        if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &bc_emlrtBCI, &st);
        }

        qrmanager->QR->data[idx_row + qrmanager->QR->size[0] * idx_col] =
          workingset->ATwset->data[idx_col + workingset->ATwset->size[0] *
          idx_row];
      }
    }

    b_st.site = &dd_emlrtRSI;
    idx_row = ComputeNumDependentEq_(&b_st, qrmanager, workingset->bwset, TYPE,
      workingset->nVar);
    if (idx_row > 0) {
      b_st.site = &dd_emlrtRSI;
      IndexOfDependentEq_(&b_st, memspace->workspace_int, workingset->nWConstr[0],
                          idx_row, qrmanager, workingset->ATwset,
                          workingset->nVar, TYPE);
      b_st.site = &dd_emlrtRSI;
      countsort(&b_st, memspace->workspace_int, idx_row,
                memspace->workspace_sort, 1, TYPE);
      for (idx = idx_row; idx >= 1; idx--) {
        b_st.site = &dd_emlrtRSI;
        i = memspace->workspace_int->size[0];
        if (idx > i) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i, &bc_emlrtBCI, &b_st);
        }

        i = workingset->nWConstr[0] + workingset->nWConstr[1];
        if (i != 0) {
          idx_col = memspace->workspace_int->data[idx - 1];
          if (idx_col <= i) {
            if ((workingset->nActiveConstr == i) || (idx_col == i)) {
              workingset->mEqRemoved++;
              i = workingset->Wlocalidx->size[0];
              if ((idx_col < 1) || (idx_col > i)) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx
                  - 1], 1, i, &cc_emlrtBCI, &b_st);
              }

              i = workingset->indexEqRemoved->size[0];
              if ((workingset->mEqRemoved < 1) || (workingset->mEqRemoved > i))
              {
                emlrtDynamicBoundsCheckR2012b(workingset->mEqRemoved, 1, i,
                  &cc_emlrtBCI, &b_st);
              }

              i = memspace->workspace_int->data[idx - 1] - 1;
              workingset->indexEqRemoved->data[workingset->mEqRemoved - 1] =
                workingset->Wlocalidx->data[i];
              c_st.site = &hd_emlrtRSI;
              nVar = workingset->Wid->size[0];
              if (idx_col > nVar) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx
                  - 1], 1, nVar, &ub_emlrtBCI, &c_st);
              }

              TYPE = workingset->Wid->data[i];
              nVar = workingset->Wlocalidx->size[0];
              if (idx_col > nVar) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx
                  - 1], 1, nVar, &ub_emlrtBCI, &c_st);
              }

              if ((TYPE < 1) || (TYPE > 6)) {
                emlrtDynamicBoundsCheckR2012b(TYPE, 1, 6, &vb_emlrtBCI, &c_st);
              }

              idx_col = workingset->isActiveConstr->size[0];
              i = (workingset->isActiveIdx[workingset->Wid->data[i] - 1] +
                   workingset->Wlocalidx->data[i]) - 1;
              if ((i < 1) || (i > idx_col)) {
                emlrtDynamicBoundsCheckR2012b(i, 1, idx_col, &ub_emlrtBCI, &c_st);
              }

              workingset->isActiveConstr->data[i - 1] = false;
              d_st.site = &id_emlrtRSI;
              moveConstraint_(&d_st, workingset, workingset->nActiveConstr,
                              memspace->workspace_int->data[idx - 1]);
              workingset->nActiveConstr--;
              if (TYPE > 5) {
                emlrtDynamicBoundsCheckR2012b(6, 1, 5, &xb_emlrtBCI, &c_st);
              }

              workingset->nWConstr[TYPE - 1]--;
            } else {
              workingset->mEqRemoved++;
              nVar = workingset->Wid->size[0];
              if ((idx_col < 1) || (idx_col > nVar)) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx
                  - 1], 1, nVar, &cc_emlrtBCI, &b_st);
              }

              TYPE = workingset->Wid->data[idx_col - 1];
              nVar = workingset->Wlocalidx->size[0];
              if (idx_col > nVar) {
                emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx
                  - 1], 1, nVar, &cc_emlrtBCI, &b_st);
              }

              nVar = workingset->Wlocalidx->data[idx_col - 1];
              idx_col = workingset->indexEqRemoved->size[0];
              if ((workingset->mEqRemoved < 1) || (workingset->mEqRemoved >
                   idx_col)) {
                emlrtDynamicBoundsCheckR2012b(workingset->mEqRemoved, 1, idx_col,
                  &cc_emlrtBCI, &b_st);
              }

              workingset->indexEqRemoved->data[workingset->mEqRemoved - 1] =
                nVar;
              if ((TYPE < 1) || (TYPE > 6)) {
                emlrtDynamicBoundsCheckR2012b(TYPE, 1, 6, &yb_emlrtBCI, &b_st);
              }

              idx_col = workingset->isActiveConstr->size[0];
              nVar = (workingset->isActiveIdx[TYPE - 1] + nVar) - 1;
              if ((nVar < 1) || (nVar > idx_col)) {
                emlrtDynamicBoundsCheckR2012b(nVar, 1, idx_col, &cc_emlrtBCI,
                  &b_st);
              }

              workingset->isActiveConstr->data[nVar - 1] = false;
              c_st.site = &hd_emlrtRSI;
              moveConstraint_(&c_st, workingset, i, memspace->
                              workspace_int->data[idx - 1]);
              c_st.site = &hd_emlrtRSI;
              moveConstraint_(&c_st, workingset, workingset->nActiveConstr, i);
              workingset->nActiveConstr--;
              if (TYPE > 5) {
                emlrtDynamicBoundsCheckR2012b(6, 1, 5, &dc_emlrtBCI, &b_st);
              }

              workingset->nWConstr[TYPE - 1]--;
            }
          }
        }
      }
    }
  }

  if (idx_row != -1) {
    st.site = &cd_emlrtRSI;
    nVar = workingset->nActiveConstr;
    i = workingset->nWConstr[1] + workingset->nWConstr[0];
    if ((workingset->nWConstr[2] + workingset->nWConstr[3]) +
        workingset->nWConstr[4] > 0) {
      tol = 100.0 * (real_T)workingset->nVar * 2.2204460492503131E-16;
      b_st.site = &kd_emlrtRSI;
      if ((1 <= i) && (i > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < i; idx++) {
        idx_col = qrmanager->jpvt->size[0];
        if ((idx + 1 < 1) || (idx + 1 > idx_col)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, idx_col, &ac_emlrtBCI, &st);
        }

        qrmanager->jpvt->data[idx] = 1;
      }

      TYPE = i + 1;
      b_st.site = &kd_emlrtRSI;
      if ((i + 1 <= workingset->nActiveConstr) && (workingset->nActiveConstr >
           2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = TYPE; idx <= nVar; idx++) {
        idx_col = qrmanager->jpvt->size[0];
        if ((idx < 1) || (idx > idx_col)) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
        }

        qrmanager->jpvt->data[idx - 1] = 0;
      }

      b_st.site = &kd_emlrtRSI;
      factorQRE(&b_st, qrmanager, workingset->ATwset, workingset->nVar,
                workingset->nActiveConstr);
      nVar = 0;
      for (idx = workingset->nActiveConstr; idx > workingset->nVar; idx--) {
        nVar++;
        idx_col = qrmanager->jpvt->size[0];
        if ((idx < 1) || (idx > idx_col)) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
        }

        idx_col = memspace->workspace_int->size[0];
        if ((nVar < 1) || (nVar > idx_col)) {
          emlrtDynamicBoundsCheckR2012b(nVar, 1, idx_col, &ac_emlrtBCI, &st);
        }

        memspace->workspace_int->data[nVar - 1] = qrmanager->jpvt->data[idx - 1];
      }

      if (idx <= workingset->nVar) {
        exitg1 = false;
        while ((!exitg1) && (idx > i)) {
          idx_col = qrmanager->QR->size[0];
          if ((idx < 1) || (idx > idx_col)) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
          }

          idx_col = qrmanager->QR->size[1];
          if (idx > idx_col) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
          }

          if (muDoubleScalarAbs(qrmanager->QR->data[(idx + qrmanager->QR->size[0]
                * (idx - 1)) - 1]) < tol) {
            nVar++;
            idx_col = qrmanager->jpvt->size[0];
            if (idx > idx_col) {
              emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
            }

            idx_col = memspace->workspace_int->size[0];
            if ((nVar < 1) || (nVar > idx_col)) {
              emlrtDynamicBoundsCheckR2012b(nVar, 1, idx_col, &ac_emlrtBCI, &st);
            }

            memspace->workspace_int->data[nVar - 1] = qrmanager->jpvt->data[idx
              - 1];
            idx--;
          } else {
            exitg1 = true;
          }
        }
      }

      b_st.site = &kd_emlrtRSI;
      countsort(&b_st, memspace->workspace_int, nVar, memspace->workspace_sort,
                i + 1, workingset->nActiveConstr);
      for (idx = nVar; idx >= 1; idx--) {
        b_st.site = &kd_emlrtRSI;
        i = memspace->workspace_int->size[0];
        if (idx > i) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i, &ac_emlrtBCI, &b_st);
        }

        i = workingset->Wid->size[0];
        idx_col = memspace->workspace_int->data[idx - 1];
        if ((idx_col < 1) || (idx_col > i)) {
          emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx - 1],
            1, i, &ub_emlrtBCI, &b_st);
        }

        TYPE = workingset->Wid->data[idx_col - 1];
        i = workingset->Wlocalidx->size[0];
        if (idx_col > i) {
          emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx - 1],
            1, i, &ub_emlrtBCI, &b_st);
        }

        if ((TYPE < 1) || (TYPE > 6)) {
          emlrtDynamicBoundsCheckR2012b(TYPE, 1, 6, &vb_emlrtBCI, &b_st);
        }

        i = workingset->isActiveConstr->size[0];
        idx_col = (workingset->isActiveIdx[TYPE - 1] + workingset->
                   Wlocalidx->data[idx_col - 1]) - 1;
        if ((idx_col < 1) || (idx_col > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_col, 1, i, &ub_emlrtBCI, &b_st);
        }

        workingset->isActiveConstr->data[idx_col - 1] = false;
        c_st.site = &id_emlrtRSI;
        moveConstraint_(&c_st, workingset, workingset->nActiveConstr,
                        memspace->workspace_int->data[idx - 1]);
        workingset->nActiveConstr--;
        if (TYPE > 5) {
          emlrtDynamicBoundsCheckR2012b(6, 1, 5, &xb_emlrtBCI, &b_st);
        }

        workingset->nWConstr[TYPE - 1]--;
      }
    }

    st.site = &cd_emlrtRSI;
    okWorkingSet = feasibleX0ForWorkingSet(&st, memspace->workspace_double,
      solution->xstar, workingset, qrmanager);
    guard1 = false;
    if (!okWorkingSet) {
      st.site = &cd_emlrtRSI;
      nVar = workingset->nActiveConstr;
      i = workingset->nWConstr[1] + workingset->nWConstr[0];
      if ((workingset->nWConstr[2] + workingset->nWConstr[3]) +
          workingset->nWConstr[4] > 0) {
        tol = 1000.0 * (real_T)workingset->nVar * 2.2204460492503131E-16;
        b_st.site = &kd_emlrtRSI;
        if ((1 <= i) && (i > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx = 0; idx < i; idx++) {
          idx_col = qrmanager->jpvt->size[0];
          if ((idx + 1 < 1) || (idx + 1 > idx_col)) {
            emlrtDynamicBoundsCheckR2012b(idx + 1, 1, idx_col, &ac_emlrtBCI, &st);
          }

          qrmanager->jpvt->data[idx] = 1;
        }

        TYPE = i + 1;
        b_st.site = &kd_emlrtRSI;
        if ((i + 1 <= workingset->nActiveConstr) && (workingset->nActiveConstr >
             2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx = TYPE; idx <= nVar; idx++) {
          idx_col = qrmanager->jpvt->size[0];
          if ((idx < 1) || (idx > idx_col)) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
          }

          qrmanager->jpvt->data[idx - 1] = 0;
        }

        b_st.site = &kd_emlrtRSI;
        factorQRE(&b_st, qrmanager, workingset->ATwset, workingset->nVar,
                  workingset->nActiveConstr);
        nVar = 0;
        for (idx = workingset->nActiveConstr; idx > workingset->nVar; idx--) {
          nVar++;
          idx_col = qrmanager->jpvt->size[0];
          if ((idx < 1) || (idx > idx_col)) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
          }

          idx_col = memspace->workspace_int->size[0];
          if ((nVar < 1) || (nVar > idx_col)) {
            emlrtDynamicBoundsCheckR2012b(nVar, 1, idx_col, &ac_emlrtBCI, &st);
          }

          memspace->workspace_int->data[nVar - 1] = qrmanager->jpvt->data[idx -
            1];
        }

        if (idx <= workingset->nVar) {
          exitg1 = false;
          while ((!exitg1) && (idx > i)) {
            idx_col = qrmanager->QR->size[0];
            if ((idx < 1) || (idx > idx_col)) {
              emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
            }

            idx_col = qrmanager->QR->size[1];
            if (idx > idx_col) {
              emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
            }

            if (muDoubleScalarAbs(qrmanager->QR->data[(idx + qrmanager->QR->
                  size[0] * (idx - 1)) - 1]) < tol) {
              nVar++;
              idx_col = qrmanager->jpvt->size[0];
              if (idx > idx_col) {
                emlrtDynamicBoundsCheckR2012b(idx, 1, idx_col, &ac_emlrtBCI, &st);
              }

              idx_col = memspace->workspace_int->size[0];
              if ((nVar < 1) || (nVar > idx_col)) {
                emlrtDynamicBoundsCheckR2012b(nVar, 1, idx_col, &ac_emlrtBCI,
                  &st);
              }

              memspace->workspace_int->data[nVar - 1] = qrmanager->jpvt->
                data[idx - 1];
              idx--;
            } else {
              exitg1 = true;
            }
          }
        }

        b_st.site = &kd_emlrtRSI;
        countsort(&b_st, memspace->workspace_int, nVar, memspace->workspace_sort,
                  i + 1, workingset->nActiveConstr);
        for (idx = nVar; idx >= 1; idx--) {
          b_st.site = &kd_emlrtRSI;
          i = memspace->workspace_int->size[0];
          if (idx > i) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, i, &ac_emlrtBCI, &b_st);
          }

          i = workingset->Wid->size[0];
          idx_col = memspace->workspace_int->data[idx - 1];
          if ((idx_col < 1) || (idx_col > i)) {
            emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx - 1],
              1, i, &ub_emlrtBCI, &b_st);
          }

          TYPE = workingset->Wid->data[idx_col - 1];
          i = workingset->Wlocalidx->size[0];
          if (idx_col > i) {
            emlrtDynamicBoundsCheckR2012b(memspace->workspace_int->data[idx - 1],
              1, i, &ub_emlrtBCI, &b_st);
          }

          if ((TYPE < 1) || (TYPE > 6)) {
            emlrtDynamicBoundsCheckR2012b(TYPE, 1, 6, &vb_emlrtBCI, &b_st);
          }

          i = workingset->isActiveConstr->size[0];
          idx_col = (workingset->isActiveIdx[TYPE - 1] + workingset->
                     Wlocalidx->data[idx_col - 1]) - 1;
          if ((idx_col < 1) || (idx_col > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_col, 1, i, &ub_emlrtBCI, &b_st);
          }

          workingset->isActiveConstr->data[idx_col - 1] = false;
          c_st.site = &id_emlrtRSI;
          moveConstraint_(&c_st, workingset, workingset->nActiveConstr,
                          memspace->workspace_int->data[idx - 1]);
          workingset->nActiveConstr--;
          if (TYPE > 5) {
            emlrtDynamicBoundsCheckR2012b(6, 1, 5, &xb_emlrtBCI, &b_st);
          }

          workingset->nWConstr[TYPE - 1]--;
        }
      }

      st.site = &cd_emlrtRSI;
      okWorkingSet = feasibleX0ForWorkingSet(&st, memspace->workspace_double,
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
      st.site = &cd_emlrtRSI;
      tol = b_maxConstraintViolation(&st, workingset, solution->xstar);
      if (tol > 1.0E-6) {
        solution->state = -2;
      }
    }
  } else {
    solution->state = -3;
    st.site = &cd_emlrtRSI;
    removeAllIneqConstr(&st, workingset);
  }
}

/* End of code generation (PresolveWorkingSet.c) */
