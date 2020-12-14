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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "addAeqConstr.h"
#include "addBoundToActiveSetMatrix_.h"
#include "driver1.h"
#include "eml_int_forloop_overflow_check.h"
#include "removeAllIneqConstr.h"
#include "rt_nonfinite.h"
#include "sortLambdaQP.h"
#include "xcopy.h"
#include "xgemv.h"
#include "xnrm2.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo lk_emlrtRSI = { 1,  /* lineNo */
  "soc",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\soc.p"/* pathName */
};

static emlrtRSInfo mk_emlrtRSI = { 1,  /* lineNo */
  "updateWorkingSet",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p"/* pathName */
};

static emlrtRSInfo nk_emlrtRSI = { 1,  /* lineNo */
  "restoreWorkingSet",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\restoreWorkingSet.p"/* pathName */
};

static emlrtBCInfo we_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSet",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xe_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "restoreWorkingSet",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\restoreWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ye_emlrtBCI = { 1,  /* iFirst */
  176,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSet",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo af_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSet",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo bf_emlrtBCI = { 1,  /* iFirst */
  88,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "soc",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\soc.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
boolean_T soc(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T
              Hessian[17424], const real_T grad[485], e_struct_T *TrialState,
              b_struct_T *memspace, g_struct_T *WorkingSet, k_struct_T
              *QRManager, l_struct_T *CholManager, j_struct_T *QPObjective,
              const c_struct_T *qpoptions)
{
  boolean_T success;
  int32_T nWIneq_old;
  int32_T nWLower_old;
  int32_T nWUpper_old;
  int32_T nVar;
  int32_T iv[617];
  int32_T idxIneqOffset;
  int32_T idx;
  int32_T idx_Aineq;
  int32_T idx_lower;
  int32_T idx_upper;
  int32_T b;
  c_struct_T b_qpoptions;
  int32_T idx_Partition;
  c_struct_T c_qpoptions;
  int32_T i;
  boolean_T exitg1;
  real_T oldDirIdx;
  real_T lenQPNormal;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  nWIneq_old = WorkingSet->nWConstr[2];
  nWLower_old = WorkingSet->nWConstr[3];
  nWUpper_old = WorkingSet->nWConstr[4];
  nVar = WorkingSet->nVar;
  st.site = &lk_emlrtRSI;
  b_st.site = &xe_emlrtRSI;
  c_st.site = &ye_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    d_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&TrialState->xstarsqp[0], &TrialState->xstarsqp_old[0], nVar * sizeof
           (real_T));
  }

  st.site = &lk_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&TrialState->socDirection[0], &TrialState->xstar[0], nVar * sizeof
           (real_T));
  }

  st.site = &lk_emlrtRSI;
  b_xcopy(617, TrialState->lambda, TrialState->lambda_old);
  st.site = &lk_emlrtRSI;
  memcpy(&iv[0], &TrialState->workingset_old[0], 617U * sizeof(int32_T));
  idxIneqOffset = WorkingSet->isActiveIdx[2];
  b_st.site = &mk_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    WorkingSet->beq[idx] = -TrialState->cEq[idx];
  }

  b_st.site = &mk_emlrtRSI;
  s_xgemv(WorkingSet->nVar, WorkingSet->Aeq, TrialState->searchDir,
          WorkingSet->beq);
  b_st.site = &mk_emlrtRSI;
  c_st.site = &xe_emlrtRSI;
  memcpy(&WorkingSet->bwset[0], &WorkingSet->beq[0], 88U * sizeof(real_T));
  b_st.site = &mk_emlrtRSI;
  for (idx = 0; idx < 176; idx++) {
    WorkingSet->bineq[idx] = -TrialState->cIneq[idx];
  }

  b_st.site = &mk_emlrtRSI;
  t_xgemv(WorkingSet->nVar, WorkingSet->Aineq, TrialState->searchDir,
          WorkingSet->bineq);
  idx_Aineq = 1;
  idx_lower = 177;
  idx_upper = WorkingSet->sizes[3] + 177;
  b = WorkingSet->nActiveConstr;
  b_st.site = &mk_emlrtRSI;
  if ((WorkingSet->isActiveIdx[2] <= WorkingSet->nActiveConstr) &&
      (WorkingSet->nActiveConstr > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = idxIneqOffset; idx <= b; idx++) {
    if ((idx < 1) || (idx > 617)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &we_emlrtBCI, &st);
    }

    switch (WorkingSet->Wid[idx - 1]) {
     case 3:
      idx_Partition = idx_Aineq;
      idx_Aineq++;
      i = WorkingSet->Wlocalidx[idx - 1];
      if ((i < 1) || (i > 176)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx[idx - 1], 1, 176,
          &ye_emlrtBCI, &st);
      }

      WorkingSet->bwset[idx - 1] = WorkingSet->bineq[i - 1];
      break;

     case 4:
      idx_Partition = idx_lower;
      idx_lower++;
      break;

     default:
      idx_Partition = idx_upper;
      idx_upper++;
      break;
    }

    if ((idx_Partition < 1) || (idx_Partition > 617)) {
      emlrtDynamicBoundsCheckR2012b(idx_Partition, 1, 617, &af_emlrtBCI, &st);
    }

    iv[idx_Partition - 1] = WorkingSet->Wlocalidx[idx - 1];
  }

  memcpy(&TrialState->workingset_old[0], &iv[0], 617U * sizeof(int32_T));
  st.site = &lk_emlrtRSI;
  f_xcopy(&st, WorkingSet->nVar, TrialState->xstarsqp, TrialState->xstar);
  b_qpoptions = *qpoptions;
  c_qpoptions = *qpoptions;
  st.site = &lk_emlrtRSI;
  b_driver(SD, &st, Hessian, grad, TrialState, memspace, WorkingSet, QRManager,
           CholManager, QPObjective, &b_qpoptions, &c_qpoptions);
  exitg1 = false;
  while ((!exitg1) && (WorkingSet->mEqRemoved > 0)) {
    if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > 88)) {
      emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, 88, &bf_emlrtBCI,
        sp);
    }

    i = WorkingSet->mEqRemoved - 1;
    if (WorkingSet->indexEqRemoved[i] >= 1) {
      if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > 88)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, 88,
          &bf_emlrtBCI, sp);
      }

      st.site = &lk_emlrtRSI;
      addAeqConstr(&st, WorkingSet, WorkingSet->indexEqRemoved[i]);
      WorkingSet->mEqRemoved--;
    } else {
      exitg1 = true;
    }
  }

  st.site = &lk_emlrtRSI;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nVar; idx++) {
    oldDirIdx = TrialState->socDirection[idx];
    TrialState->socDirection[idx] = TrialState->xstar[idx] -
      TrialState->socDirection[idx];
    TrialState->xstar[idx] = oldDirIdx;
  }

  st.site = &lk_emlrtRSI;
  oldDirIdx = xnrm2(&st, nVar, TrialState->socDirection);
  st.site = &lk_emlrtRSI;
  lenQPNormal = xnrm2(&st, nVar, TrialState->xstar);
  success = (oldDirIdx <= 2.0 * lenQPNormal);
  st.site = &lk_emlrtRSI;
  nVar = WorkingSet->sizes[3];
  b_st.site = &nk_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    WorkingSet->beq[idx] = -TrialState->cEq[idx];
  }

  b_st.site = &nk_emlrtRSI;
  c_st.site = &xe_emlrtRSI;
  memcpy(&WorkingSet->bwset[0], &WorkingSet->beq[0], 88U * sizeof(real_T));
  b_st.site = &nk_emlrtRSI;
  for (idx = 0; idx < 176; idx++) {
    WorkingSet->bineq[idx] = -TrialState->cIneq[idx];
  }

  if (!success) {
    b_st.site = &nk_emlrtRSI;
    removeAllIneqConstr(&b_st, WorkingSet);
    b_st.site = &nk_emlrtRSI;
    if ((1 <= nWIneq_old) && (nWIneq_old > 2147483646)) {
      c_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < nWIneq_old; idx++) {
      b_st.site = &nk_emlrtRSI;
      i = idx + 1;
      if ((i < 1) || (i > 617)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 617, &xe_emlrtBCI, &b_st);
      }

      idxIneqOffset = TrialState->workingset_old[i - 1];
      c_st.site = &uj_emlrtRSI;
      WorkingSet->nWConstr[2]++;
      i = (WorkingSet->isActiveIdx[2] + idxIneqOffset) - 1;
      if ((i < 1) || (i > 617)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 617, &od_emlrtBCI, &c_st);
      }

      WorkingSet->isActiveConstr[i - 1] = true;
      WorkingSet->nActiveConstr++;
      if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > 617))
      {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, 617,
          &od_emlrtBCI, &c_st);
      }

      WorkingSet->Wid[WorkingSet->nActiveConstr - 1] = 3;
      WorkingSet->Wlocalidx[WorkingSet->nActiveConstr - 1] = idxIneqOffset;
      c_st.site = &uj_emlrtRSI;
      xcopy(&c_st, WorkingSet->nVar, WorkingSet->Aineq, 485 * (idxIneqOffset - 1)
            + 1, WorkingSet->ATwset, 485 * (WorkingSet->nActiveConstr - 1) + 1);
      if ((idxIneqOffset < 1) || (idxIneqOffset > 176)) {
        emlrtDynamicBoundsCheckR2012b(idxIneqOffset, 1, 176, &qd_emlrtBCI, &b_st);
      }

      if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > 617))
      {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, 617,
          &rd_emlrtBCI, &b_st);
      }

      WorkingSet->bwset[WorkingSet->nActiveConstr - 1] = WorkingSet->
        bineq[idxIneqOffset - 1];
    }

    b_st.site = &nk_emlrtRSI;
    if ((1 <= nWLower_old) && (nWLower_old > 2147483646)) {
      c_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < nWLower_old; idx++) {
      b_st.site = &nk_emlrtRSI;
      i = idx + 177;
      if ((i < 1) || (i > 617)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 617, &xe_emlrtBCI, &b_st);
      }

      c_st.site = &vj_emlrtRSI;
      addBoundToActiveSetMatrix_(&c_st, WorkingSet, 4,
        TrialState->workingset_old[idx + 176]);
    }

    b_st.site = &nk_emlrtRSI;
    if ((1 <= nWUpper_old) && (nWUpper_old > 2147483646)) {
      c_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < nWUpper_old; idx++) {
      b_st.site = &nk_emlrtRSI;
      i = (idx + nVar) + 177;
      if ((i < 1) || (i > 617)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 617, &xe_emlrtBCI, &b_st);
      }

      c_st.site = &xj_emlrtRSI;
      addBoundToActiveSetMatrix_(&c_st, WorkingSet, 5,
        TrialState->workingset_old[i - 1]);
    }
  }

  if (!success) {
    st.site = &lk_emlrtRSI;
    b_xcopy(617, TrialState->lambda_old, TrialState->lambda);
  } else {
    st.site = &lk_emlrtRSI;
    sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
                 WorkingSet->sizes, WorkingSet->isActiveIdx, WorkingSet->Wid,
                 WorkingSet->Wlocalidx, memspace->workspace_double);
  }

  return success;
}

/* End of code generation (soc.c) */
