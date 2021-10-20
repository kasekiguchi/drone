/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * soc.c
 *
 * Code generation for function 'soc'
 *
 */

/* Include files */
#include "soc.h"
#include "addAeqConstr.h"
#include "addBoundToActiveSetMatrix_.h"
#include "driver1.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "removeAllIneqConstr.h"
#include "rt_nonfinite.h"
#include "sortLambdaQP.h"
#include "xcopy.h"
#include "xgemv.h"
#include "xnrm2.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo pf_emlrtRSI = { 1,  /* lineNo */
  "soc",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\soc.p"/* pathName */
};

static emlrtRSInfo qf_emlrtRSI = { 1,  /* lineNo */
  "updateWorkingSet",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p"/* pathName */
};

static emlrtRSInfo rf_emlrtRSI = { 1,  /* lineNo */
  "restoreWorkingSet",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\restoreWorkingSet.p"/* pathName */
};

static emlrtBCInfo od_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "soc",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\soc.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSet",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "restoreWorkingSet",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\restoreWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo ub_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "updateWorkingSet",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p"/* pName */
};

/* Function Definitions */
boolean_T soc(const emlrtStack *sp, const real_T Hessian[5929], const
              emxArray_real_T *grad, d_struct_T *TrialState, c_struct_T
              *memspace, j_struct_T *WorkingSet, g_struct_T *QRManager,
              h_struct_T *CholManager, i_struct_T *QPObjective, const b_struct_T
              *qpoptions)
{
  b_struct_T b_qpoptions;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack st;
  emxArray_real_T *r;
  real_T oldDirIdx_tmp;
  int32_T i;
  int32_T idx;
  int32_T idxIneqOffset;
  int32_T idx_Aineq;
  int32_T idx_IneqLocal_tmp;
  int32_T idx_Partition;
  int32_T idx_upper;
  int32_T mConstrMax;
  int32_T mEq;
  int32_T mIneq;
  int32_T nVar;
  int32_T nWIneq_old;
  int32_T nWLower_old;
  int32_T nWUpper_old;
  boolean_T exitg1;
  boolean_T success;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  nWIneq_old = WorkingSet->nWConstr[2];
  nWLower_old = WorkingSet->nWConstr[3];
  nWUpper_old = WorkingSet->nWConstr[4];
  nVar = WorkingSet->nVar;
  mConstrMax = WorkingSet->mConstrMax;
  st.site = &pf_emlrtRSI;
  b_st.site = &xb_emlrtRSI;
  c_st.site = &gb_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    d_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&TrialState->xstarsqp[0], &TrialState->xstarsqp_old[0], nVar * sizeof
           (real_T));
  }

  st.site = &pf_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (mEq = 0; mEq < nVar; mEq++) {
    i = TrialState->xstar->size[0];
    if ((mEq + 1 < 1) || (mEq + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(mEq + 1, 1, i, &od_emlrtBCI, sp);
    }

    i = TrialState->socDirection->size[0];
    if ((mEq + 1 < 1) || (mEq + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(mEq + 1, 1, i, &od_emlrtBCI, sp);
    }

    TrialState->socDirection->data[mEq] = TrialState->xstar->data[mEq];
  }

  st.site = &pf_emlrtRSI;
  b_xcopy(WorkingSet->mConstrMax, TrialState->lambda, TrialState->lambda_old);
  st.site = &pf_emlrtRSI;
  mEq = WorkingSet->sizes[1];
  mIneq = WorkingSet->sizes[2];
  idxIneqOffset = WorkingSet->isActiveIdx[2];
  b_st.site = &qf_emlrtRSI;
  if ((1 <= WorkingSet->sizes[1]) && (WorkingSet->sizes[1] > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < mEq; idx++) {
    i = TrialState->cEq->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &pd_emlrtBCI, &st);
    }

    i = WorkingSet->beq->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &pd_emlrtBCI, &st);
    }

    WorkingSet->beq->data[idx] = -TrialState->cEq->data[idx];
  }

  emxInit_real_T(&st, &r, 2, &ub_emlrtRTEI, true);
  i = r->size[0] * r->size[1];
  r->size[0] = WorkingSet->beq->size[0];
  r->size[1] = 1;
  emxEnsureCapacity_real_T(&st, r, i, &ub_emlrtRTEI);
  mEq = WorkingSet->beq->size[0] * WorkingSet->beq->size[1];
  for (i = 0; i < mEq; i++) {
    r->data[i] = WorkingSet->beq->data[i];
  }

  b_st.site = &qf_emlrtRSI;
  l_xgemv(&b_st, WorkingSet->nVar, WorkingSet->sizes[1], WorkingSet->Aeq,
          WorkingSet->ldA, TrialState->searchDir, r);
  i = WorkingSet->beq->size[0] * WorkingSet->beq->size[1];
  WorkingSet->beq->size[0] = r->size[0];
  WorkingSet->beq->size[1] = r->size[1];
  emxEnsureCapacity_real_T(&st, WorkingSet->beq, i, &ub_emlrtRTEI);
  mEq = r->size[0] * r->size[1];
  for (i = 0; i < mEq; i++) {
    WorkingSet->beq->data[i] = r->data[i];
  }

  emxFree_real_T(&r);
  b_st.site = &qf_emlrtRSI;
  e_xcopy(WorkingSet->sizes[1], WorkingSet->beq, WorkingSet->bwset);
  if (WorkingSet->sizes[2] > 0) {
    b_st.site = &qf_emlrtRSI;
    if ((1 <= WorkingSet->sizes[2]) && (WorkingSet->sizes[2] > 2147483646)) {
      c_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < mIneq; idx++) {
      i = TrialState->cIneq->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &pd_emlrtBCI, &st);
      }

      i = WorkingSet->bineq->size[0] * WorkingSet->bineq->size[1];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &pd_emlrtBCI, &st);
      }

      WorkingSet->bineq->data[idx] = -TrialState->cIneq->data[idx];
    }

    b_st.site = &qf_emlrtRSI;
    l_xgemv(&b_st, WorkingSet->nVar, WorkingSet->sizes[2], WorkingSet->Aineq,
            WorkingSet->ldA, TrialState->searchDir, WorkingSet->bineq);
    idx_Aineq = 1;
    mEq = WorkingSet->sizes[2] + 1;
    idx_upper = (WorkingSet->sizes[2] + WorkingSet->sizes[3]) + 1;
    mIneq = WorkingSet->nActiveConstr;
    b_st.site = &qf_emlrtRSI;
    if ((WorkingSet->isActiveIdx[2] <= WorkingSet->nActiveConstr) &&
        (WorkingSet->nActiveConstr > 2147483646)) {
      c_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = idxIneqOffset; idx <= mIneq; idx++) {
      i = WorkingSet->Wid->size[0];
      if ((idx < 1) || (idx > i)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &pd_emlrtBCI, &st);
      }

      i = WorkingSet->Wlocalidx->size[0];
      if (idx > i) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &pd_emlrtBCI, &st);
      }

      idx_IneqLocal_tmp = WorkingSet->Wlocalidx->data[idx - 1];
      switch (WorkingSet->Wid->data[idx - 1]) {
       case 3:
        idx_Partition = idx_Aineq;
        idx_Aineq++;
        i = WorkingSet->bineq->size[0] * WorkingSet->bineq->size[1];
        if ((idx_IneqLocal_tmp < 1) || (idx_IneqLocal_tmp > i)) {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx->data[idx - 1], 1,
            i, &pd_emlrtBCI, &st);
        }

        i = WorkingSet->bwset->size[0];
        if (idx > i) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i, &pd_emlrtBCI, &st);
        }

        WorkingSet->bwset->data[idx - 1] = WorkingSet->bineq->
          data[idx_IneqLocal_tmp - 1];
        break;

       case 4:
        idx_Partition = mEq;
        mEq++;
        break;

       default:
        idx_Partition = idx_upper;
        idx_upper++;
        break;
      }

      i = TrialState->workingset_old->size[0];
      if ((idx_Partition < 1) || (idx_Partition > i)) {
        emlrtDynamicBoundsCheckR2012b(idx_Partition, 1, i, &pd_emlrtBCI, &st);
      }

      TrialState->workingset_old->data[idx_Partition - 1] = idx_IneqLocal_tmp;
    }
  }

  st.site = &pf_emlrtRSI;
  d_xcopy(&st, WorkingSet->nVar, TrialState->xstarsqp, TrialState->xstar);
  b_qpoptions = *qpoptions;
  st.site = &pf_emlrtRSI;
  b_driver(&st, Hessian, grad, TrialState, memspace, WorkingSet, QRManager,
           CholManager, QPObjective, &b_qpoptions, qpoptions->MaxIterations);
  exitg1 = false;
  while ((!exitg1) && (WorkingSet->mEqRemoved > 0)) {
    i = WorkingSet->indexEqRemoved->size[0];
    if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > i)) {
      emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, i, &od_emlrtBCI,
        sp);
    }

    if (WorkingSet->indexEqRemoved->data[WorkingSet->mEqRemoved - 1] >=
        TrialState->iNonEq0) {
      i = WorkingSet->indexEqRemoved->size[0];
      if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > i)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, i, &od_emlrtBCI,
          sp);
      }

      st.site = &pf_emlrtRSI;
      addAeqConstr(&st, WorkingSet, WorkingSet->indexEqRemoved->data
                   [WorkingSet->mEqRemoved - 1]);
      WorkingSet->mEqRemoved--;
    } else {
      exitg1 = true;
    }
  }

  st.site = &pf_emlrtRSI;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nVar; idx++) {
    i = TrialState->socDirection->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &od_emlrtBCI, sp);
    }

    oldDirIdx_tmp = TrialState->socDirection->data[idx];
    i = TrialState->xstar->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &od_emlrtBCI, sp);
    }

    i = TrialState->socDirection->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &od_emlrtBCI, sp);
    }

    TrialState->socDirection->data[idx] = TrialState->xstar->data[idx] -
      oldDirIdx_tmp;
    i = TrialState->xstar->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &od_emlrtBCI, sp);
    }

    TrialState->xstar->data[idx] = oldDirIdx_tmp;
  }

  success = (xnrm2(nVar, TrialState->socDirection) <= 2.0 * xnrm2(nVar,
              TrialState->xstar));
  st.site = &pf_emlrtRSI;
  mEq = WorkingSet->sizes[1];
  mIneq = WorkingSet->sizes[2] + 1;
  idx_upper = WorkingSet->sizes[3];
  b_st.site = &rf_emlrtRSI;
  if ((1 <= WorkingSet->sizes[1]) && (WorkingSet->sizes[1] > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < mEq; idx++) {
    i = TrialState->cEq->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &qd_emlrtBCI, &st);
    }

    i = WorkingSet->beq->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &qd_emlrtBCI, &st);
    }

    WorkingSet->beq->data[idx] = -TrialState->cEq->data[idx];
  }

  b_st.site = &rf_emlrtRSI;
  e_xcopy(WorkingSet->sizes[1], WorkingSet->beq, WorkingSet->bwset);
  if (WorkingSet->sizes[2] > 0) {
    b_st.site = &rf_emlrtRSI;
    if ((1 <= WorkingSet->sizes[2]) && (WorkingSet->sizes[2] > 2147483646)) {
      c_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx <= mIneq - 2; idx++) {
      i = TrialState->cIneq->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &qd_emlrtBCI, &st);
      }

      i = WorkingSet->bineq->size[0] * WorkingSet->bineq->size[1];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &qd_emlrtBCI, &st);
      }

      WorkingSet->bineq->data[idx] = -TrialState->cIneq->data[idx];
    }

    if (!success) {
      b_st.site = &rf_emlrtRSI;
      removeAllIneqConstr(&b_st, WorkingSet);
      b_st.site = &rf_emlrtRSI;
      if ((1 <= nWIneq_old) && (nWIneq_old > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < nWIneq_old; idx++) {
        b_st.site = &rf_emlrtRSI;
        i = TrialState->workingset_old->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &qd_emlrtBCI, &b_st);
        }

        mEq = TrialState->workingset_old->data[idx];
        c_st.site = &df_emlrtRSI;
        WorkingSet->nWConstr[2]++;
        i = WorkingSet->isActiveConstr->size[0];
        idx_Aineq = (WorkingSet->isActiveIdx[2] + mEq) - 1;
        if ((idx_Aineq < 1) || (idx_Aineq > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_Aineq, 1, i, &tc_emlrtBCI, &c_st);
        }

        WorkingSet->isActiveConstr->data[idx_Aineq - 1] = true;
        WorkingSet->nActiveConstr++;
        i = WorkingSet->Wid->size[0];
        if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > i))
        {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, i,
            &tc_emlrtBCI, &c_st);
        }

        WorkingSet->Wid->data[WorkingSet->nActiveConstr - 1] = 3;
        i = WorkingSet->Wlocalidx->size[0];
        if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > i))
        {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, i,
            &tc_emlrtBCI, &c_st);
        }

        WorkingSet->Wlocalidx->data[WorkingSet->nActiveConstr - 1] = mEq;
        c_st.site = &df_emlrtRSI;
        xcopy(WorkingSet->nVar, WorkingSet->Aineq, WorkingSet->ldA * (mEq - 1) +
              1, WorkingSet->ATwset, WorkingSet->ldA *
              (WorkingSet->nActiveConstr - 1) + 1);
        i = WorkingSet->bineq->size[0] * WorkingSet->bineq->size[1];
        if ((mEq < 1) || (mEq > i)) {
          emlrtDynamicBoundsCheckR2012b(mEq, 1, i, &uc_emlrtBCI, &b_st);
        }

        i = WorkingSet->bwset->size[0];
        if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > i))
        {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, i,
            &uc_emlrtBCI, &b_st);
        }

        WorkingSet->bwset->data[WorkingSet->nActiveConstr - 1] =
          WorkingSet->bineq->data[mEq - 1];
      }

      b_st.site = &rf_emlrtRSI;
      if ((1 <= nWLower_old) && (nWLower_old > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < nWLower_old; idx++) {
        b_st.site = &rf_emlrtRSI;
        i = TrialState->workingset_old->size[0];
        idx_Aineq = idx + mIneq;
        if ((idx_Aineq < 1) || (idx_Aineq > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_Aineq, 1, i, &qd_emlrtBCI, &b_st);
        }

        c_st.site = &ef_emlrtRSI;
        addBoundToActiveSetMatrix_(&c_st, WorkingSet, 4,
          TrialState->workingset_old->data[idx_Aineq - 1]);
      }

      b_st.site = &rf_emlrtRSI;
      if ((1 <= nWUpper_old) && (nWUpper_old > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < nWUpper_old; idx++) {
        b_st.site = &rf_emlrtRSI;
        i = TrialState->workingset_old->size[0];
        idx_Aineq = (idx + mIneq) + idx_upper;
        if ((idx_Aineq < 1) || (idx_Aineq > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_Aineq, 1, i, &qd_emlrtBCI, &b_st);
        }

        c_st.site = &gf_emlrtRSI;
        addBoundToActiveSetMatrix_(&c_st, WorkingSet, 5,
          TrialState->workingset_old->data[idx_Aineq - 1]);
      }
    }
  }

  if (!success) {
    st.site = &pf_emlrtRSI;
    b_xcopy(mConstrMax, TrialState->lambda_old, TrialState->lambda);
  } else {
    st.site = &pf_emlrtRSI;
    sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
                 WorkingSet->sizes, WorkingSet->isActiveIdx, WorkingSet->Wid,
                 WorkingSet->Wlocalidx, memspace->workspace_double);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
  return success;
}

/* End of code generation (soc.c) */
