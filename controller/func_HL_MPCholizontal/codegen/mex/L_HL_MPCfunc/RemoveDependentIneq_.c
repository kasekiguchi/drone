/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * RemoveDependentIneq_.c
 *
 * Code generation for function 'RemoveDependentIneq_'
 *
 */

/* Include files */
#include "RemoveDependentIneq_.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "countsort.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQRE.h"
#include "moveConstraint_.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo yc_emlrtRSI = { 1,  /* lineNo */
  "RemoveDependentIneq_",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentIneq_.p"/* pathName */
};

static emlrtBCInfo wb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentIneq_",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentIneq_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo xb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "RemoveDependentIneq_",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\RemoveDependentIneq_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void RemoveDependentIneq_(const emlrtStack *sp, g_struct_T *workingset,
  k_struct_T *qrmanager, b_struct_T *memspace, real_T tolfactor)
{
  int32_T nActiveConstr;
  int32_T nFixedConstr;
  real_T tol;
  int32_T idx;
  int32_T a;
  int32_T i;
  int32_T nDepIneq;
  boolean_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nActiveConstr = workingset->nActiveConstr;
  nFixedConstr = workingset->nWConstr[1] + workingset->nWConstr[0];
  if ((workingset->nWConstr[2] + workingset->nWConstr[3]) + workingset->
      nWConstr[4] > 0) {
    tol = tolfactor * (real_T)workingset->nVar * 2.2204460492503131E-16;
    st.site = &yc_emlrtRSI;
    if ((1 <= nFixedConstr) && (nFixedConstr > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < nFixedConstr; idx++) {
      i = idx + 1;
      if ((i < 1) || (i > 307)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 307, &wb_emlrtBCI, sp);
      }

      qrmanager->jpvt[i - 1] = 1;
    }

    a = nFixedConstr + 1;
    st.site = &yc_emlrtRSI;
    if ((nFixedConstr + 1 <= workingset->nActiveConstr) &&
        (workingset->nActiveConstr > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = a; idx <= nActiveConstr; idx++) {
      if ((idx < 1) || (idx > 307)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, 307, &wb_emlrtBCI, sp);
      }

      qrmanager->jpvt[idx - 1] = 0;
    }

    st.site = &yc_emlrtRSI;
    factorQRE(&st, qrmanager, workingset->ATwset, workingset->nVar,
              workingset->nActiveConstr);
    nDepIneq = 0;
    for (idx = workingset->nActiveConstr; idx > workingset->nVar; idx--) {
      nDepIneq++;
      if ((idx < 1) || (idx > 307)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, 307, &xb_emlrtBCI, sp);
      }

      if (nDepIneq > 307) {
        emlrtDynamicBoundsCheckR2012b(308, 1, 307, &wb_emlrtBCI, sp);
      }

      memspace->workspace_int[nDepIneq - 1] = qrmanager->jpvt[idx - 1];
    }

    if (idx <= workingset->nVar) {
      exitg1 = false;
      while ((!exitg1) && (idx > nFixedConstr)) {
        if ((idx < 1) || (idx > 307)) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, 307, &xb_emlrtBCI, sp);
        }

        if (muDoubleScalarAbs(qrmanager->QR[(idx + 307 * (idx - 1)) - 1]) < tol)
        {
          nDepIneq++;
          if (nDepIneq > 307) {
            emlrtDynamicBoundsCheckR2012b(308, 1, 307, &wb_emlrtBCI, sp);
          }

          memspace->workspace_int[nDepIneq - 1] = qrmanager->jpvt[idx - 1];
          idx--;
        } else {
          exitg1 = true;
        }
      }
    }

    st.site = &yc_emlrtRSI;
    countsort(&st, memspace->workspace_int, nDepIneq, memspace->workspace_sort,
              nFixedConstr + 1, workingset->nActiveConstr);
    for (idx = nDepIneq; idx >= 1; idx--) {
      st.site = &yc_emlrtRSI;
      i = memspace->workspace_int[idx - 1];
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(memspace->workspace_int[idx - 1], 1, 305,
          &nb_emlrtBCI, &st);
      }

      a = i - 1;
      nActiveConstr = workingset->Wid[a];
      i = workingset->Wid[a];
      if ((i < 1) || (i > 6)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 6, &eb_emlrtBCI, &st);
      }

      i = (workingset->isActiveIdx[workingset->Wid[a] - 1] +
           workingset->Wlocalidx[a]) - 1;
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 305, &pb_emlrtBCI, &st);
      }

      workingset->isActiveConstr[i - 1] = false;
      b_st.site = &wc_emlrtRSI;
      moveConstraint_(&b_st, workingset, workingset->nActiveConstr,
                      memspace->workspace_int[idx - 1]);
      workingset->nActiveConstr--;
      if ((nActiveConstr < 1) || (nActiveConstr > 5)) {
        emlrtDynamicBoundsCheckR2012b(nActiveConstr, 1, 5, &rb_emlrtBCI, &st);
      }

      workingset->nWConstr[nActiveConstr - 1]--;
    }
  }
}

/* End of code generation (RemoveDependentIneq_.c) */
