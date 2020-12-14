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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
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
static emlrtRSInfo ub_emlrtRSI = { 64, /* lineNo */
  "xgemv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xgemv.m"/* pathName */
};

static emlrtRSInfo vb_emlrtRSI = { 71, /* lineNo */
  "xgemv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xgemv.m"/* pathName */
};

static emlrtRSInfo wb_emlrtRSI = { 74, /* lineNo */
  "xgemv",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xgemv.m"/* pathName */
};

static emlrtRSInfo uf_emlrtRSI = { 1,  /* lineNo */
  "soc",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\soc.p"/* pathName */
};

static emlrtRSInfo vf_emlrtRSI = { 1,  /* lineNo */
  "updateWorkingSet",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p"/* pathName */
};

static emlrtRSInfo wf_emlrtRSI = { 1,  /* lineNo */
  "restoreWorkingSet",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\restoreWorkingSet.p"/* pathName */
};

static emlrtBCInfo yd_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSet",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ae_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "restoreWorkingSet",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\restoreWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo be_emlrtBCI = { 1,  /* iFirst */
  20,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSet",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ce_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSet",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+soc\\updateWorkingSet.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo de_emlrtBCI = { 1,  /* iFirst */
  88,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "soc",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\soc.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
boolean_T soc(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T
              Hessian[12100], const real_T grad[307], e_struct_T *TrialState,
              b_struct_T *memspace, g_struct_T *WorkingSet, k_struct_T
              *QRManager, l_struct_T *CholManager, j_struct_T *QPObjective,
              const c_struct_T *qpoptions)
{
  boolean_T success;
  int32_T nWIneq_old;
  int32_T nWLower_old;
  int32_T nWUpper_old;
  int32_T nVar;
  int32_T iv[305];
  int32_T idxIneqOffset;
  int32_T idx;
  int32_T iy;
  int32_T idx_upper;
  int32_T ix;
  real_T c;
  int32_T b;
  int32_T idx_Partition;
  c_struct_T b_qpoptions;
  c_struct_T c_qpoptions;
  int32_T i;
  boolean_T exitg1;
  real_T lenQPNormal;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  nWIneq_old = WorkingSet->nWConstr[2];
  nWLower_old = WorkingSet->nWConstr[3];
  nWUpper_old = WorkingSet->nWConstr[4];
  nVar = WorkingSet->nVar;
  st.site = &uf_emlrtRSI;
  b_st.site = &i_emlrtRSI;
  c_st.site = &j_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    d_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&TrialState->xstarsqp[0], &TrialState->xstarsqp_old[0], nVar * sizeof
           (real_T));
  }

  st.site = &uf_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  if (0 <= nVar - 1) {
    memcpy(&TrialState->socDirection[0], &TrialState->xstar[0], nVar * sizeof
           (real_T));
  }

  st.site = &uf_emlrtRSI;
  b_xcopy(&st, 305, TrialState->lambda, TrialState->lambda_old);
  st.site = &uf_emlrtRSI;
  memcpy(&iv[0], &TrialState->workingset_old[0], 305U * sizeof(int32_T));
  idxIneqOffset = WorkingSet->isActiveIdx[2];
  b_st.site = &vf_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    WorkingSet->beq[idx] = -TrialState->cEq[idx];
  }

  b_st.site = &vf_emlrtRSI;
  s_xgemv(WorkingSet->nVar, WorkingSet->Aeq, TrialState->searchDir,
          WorkingSet->beq);
  b_st.site = &vf_emlrtRSI;
  c_st.site = &i_emlrtRSI;
  d_st.site = &j_emlrtRSI;
  memcpy(&WorkingSet->bwset[0], &WorkingSet->beq[0], 88U * sizeof(real_T));
  b_st.site = &vf_emlrtRSI;
  for (idx = 0; idx < 20; idx++) {
    WorkingSet->bineq[idx] = -TrialState->cIneq[idx];
  }

  b_st.site = &vf_emlrtRSI;
  c_st.site = &ub_emlrtRSI;
  iy = 0;
  d_st.site = &vb_emlrtRSI;
  for (idx_upper = 0; idx_upper <= 5833; idx_upper += 307) {
    ix = 0;
    c = 0.0;
    b = idx_upper + WorkingSet->nVar;
    d_st.site = &wb_emlrtRSI;
    if ((idx_upper + 1 <= b) && (b > 2147483646)) {
      e_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&e_st);
    }

    for (idx_Partition = idx_upper + 1; idx_Partition <= b; idx_Partition++) {
      c += WorkingSet->Aineq[idx_Partition - 1] * TrialState->searchDir[ix];
      ix++;
    }

    WorkingSet->bineq[iy] += c;
    iy++;
  }

  iy = 1;
  ix = 21;
  idx_upper = WorkingSet->sizes[3] + 21;
  b = WorkingSet->nActiveConstr;
  b_st.site = &vf_emlrtRSI;
  if ((WorkingSet->isActiveIdx[2] <= WorkingSet->nActiveConstr) &&
      (WorkingSet->nActiveConstr > 2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = idxIneqOffset; idx <= b; idx++) {
    if ((idx < 1) || (idx > 305)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, 305, &yd_emlrtBCI, &st);
    }

    switch (WorkingSet->Wid[idx - 1]) {
     case 3:
      idx_Partition = iy;
      iy++;
      i = WorkingSet->Wlocalidx[idx - 1];
      if ((i < 1) || (i > 20)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx[idx - 1], 1, 20,
          &be_emlrtBCI, &st);
      }

      WorkingSet->bwset[idx - 1] = WorkingSet->bineq[i - 1];
      break;

     case 4:
      idx_Partition = ix;
      ix++;
      break;

     default:
      idx_Partition = idx_upper;
      idx_upper++;
      break;
    }

    if ((idx_Partition < 1) || (idx_Partition > 305)) {
      emlrtDynamicBoundsCheckR2012b(idx_Partition, 1, 305, &ce_emlrtBCI, &st);
    }

    iv[idx_Partition - 1] = WorkingSet->Wlocalidx[idx - 1];
  }

  memcpy(&TrialState->workingset_old[0], &iv[0], 305U * sizeof(int32_T));
  st.site = &uf_emlrtRSI;
  e_xcopy(&st, WorkingSet->nVar, TrialState->xstarsqp, TrialState->xstar);
  b_qpoptions = *qpoptions;
  c_qpoptions = *qpoptions;
  st.site = &uf_emlrtRSI;
  b_driver(SD, &st, Hessian, grad, TrialState, memspace, WorkingSet, QRManager,
           CholManager, QPObjective, &b_qpoptions, &c_qpoptions);
  exitg1 = false;
  while ((!exitg1) && (WorkingSet->mEqRemoved > 0)) {
    if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > 88)) {
      emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, 88, &de_emlrtBCI,
        sp);
    }

    i = WorkingSet->mEqRemoved - 1;
    if (WorkingSet->indexEqRemoved[i] >= 1) {
      if ((WorkingSet->mEqRemoved < 1) || (WorkingSet->mEqRemoved > 88)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->mEqRemoved, 1, 88,
          &de_emlrtBCI, sp);
      }

      st.site = &uf_emlrtRSI;
      addAeqConstr(&st, WorkingSet, WorkingSet->indexEqRemoved[i]);
      WorkingSet->mEqRemoved--;
    } else {
      exitg1 = true;
    }
  }

  st.site = &uf_emlrtRSI;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nVar; idx++) {
    c = TrialState->socDirection[idx];
    TrialState->socDirection[idx] = TrialState->xstar[idx] -
      TrialState->socDirection[idx];
    TrialState->xstar[idx] = c;
  }

  st.site = &uf_emlrtRSI;
  c = xnrm2(&st, nVar, TrialState->socDirection);
  st.site = &uf_emlrtRSI;
  lenQPNormal = xnrm2(&st, nVar, TrialState->xstar);
  success = (c <= 2.0 * lenQPNormal);
  st.site = &uf_emlrtRSI;
  iy = WorkingSet->sizes[3];
  b_st.site = &wf_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    WorkingSet->beq[idx] = -TrialState->cEq[idx];
  }

  b_st.site = &wf_emlrtRSI;
  c_st.site = &i_emlrtRSI;
  d_st.site = &j_emlrtRSI;
  memcpy(&WorkingSet->bwset[0], &WorkingSet->beq[0], 88U * sizeof(real_T));
  b_st.site = &wf_emlrtRSI;
  for (idx = 0; idx < 20; idx++) {
    WorkingSet->bineq[idx] = -TrialState->cIneq[idx];
  }

  if (!success) {
    b_st.site = &wf_emlrtRSI;
    removeAllIneqConstr(&b_st, WorkingSet);
    b_st.site = &wf_emlrtRSI;
    if ((1 <= nWIneq_old) && (nWIneq_old > 2147483646)) {
      c_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < nWIneq_old; idx++) {
      b_st.site = &wf_emlrtRSI;
      i = idx + 1;
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 305, &ae_emlrtBCI, &b_st);
      }

      ix = TrialState->workingset_old[i - 1];
      c_st.site = &ef_emlrtRSI;
      WorkingSet->nWConstr[2]++;
      i = (WorkingSet->isActiveIdx[2] + ix) - 1;
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 305, &rc_emlrtBCI, &c_st);
      }

      WorkingSet->isActiveConstr[i - 1] = true;
      WorkingSet->nActiveConstr++;
      if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > 305))
      {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, 305,
          &rc_emlrtBCI, &c_st);
      }

      WorkingSet->Wid[WorkingSet->nActiveConstr - 1] = 3;
      WorkingSet->Wlocalidx[WorkingSet->nActiveConstr - 1] = ix;
      c_st.site = &ef_emlrtRSI;
      xcopy(&c_st, WorkingSet->nVar, WorkingSet->Aineq, 307 * (ix - 1) + 1,
            WorkingSet->ATwset, 307 * (WorkingSet->nActiveConstr - 1) + 1);
      if ((ix < 1) || (ix > 20)) {
        emlrtDynamicBoundsCheckR2012b(ix, 1, 20, &tc_emlrtBCI, &b_st);
      }

      if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > 305))
      {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, 305,
          &uc_emlrtBCI, &b_st);
      }

      WorkingSet->bwset[WorkingSet->nActiveConstr - 1] = WorkingSet->bineq[ix -
        1];
    }

    b_st.site = &wf_emlrtRSI;
    if ((1 <= nWLower_old) && (nWLower_old > 2147483646)) {
      c_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < nWLower_old; idx++) {
      b_st.site = &wf_emlrtRSI;
      i = idx + 21;
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 305, &ae_emlrtBCI, &b_st);
      }

      c_st.site = &ff_emlrtRSI;
      addBoundToActiveSetMatrix_(&c_st, WorkingSet, 4,
        TrialState->workingset_old[idx + 20]);
    }

    b_st.site = &wf_emlrtRSI;
    if ((1 <= nWUpper_old) && (nWUpper_old > 2147483646)) {
      c_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < nWUpper_old; idx++) {
      b_st.site = &wf_emlrtRSI;
      i = (idx + iy) + 21;
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 305, &ae_emlrtBCI, &b_st);
      }

      c_st.site = &hf_emlrtRSI;
      addBoundToActiveSetMatrix_(&c_st, WorkingSet, 5,
        TrialState->workingset_old[i - 1]);
    }
  }

  if (!success) {
    st.site = &uf_emlrtRSI;
    b_xcopy(&st, 305, TrialState->lambda_old, TrialState->lambda);
  } else {
    st.site = &uf_emlrtRSI;
    sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
                 WorkingSet->sizes, WorkingSet->isActiveIdx, WorkingSet->Wid,
                 WorkingSet->Wlocalidx, memspace->workspace_double);
  }

  return success;
}

/* End of code generation (soc.c) */
