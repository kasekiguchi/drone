/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * relaxed.c
 *
 * Code generation for function 'relaxed'
 *
 */

/* Include files */
#include "relaxed.h"
#include "addBoundToActiveSetMatrix_.h"
#include "driver1.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "ixamax.h"
#include "moveConstraint_.h"
#include "rt_nonfinite.h"
#include "setProblemType.h"
#include "sortLambdaQP.h"
#include "updatePenaltyParam.h"
#include "xasum.h"
#include "xcopy.h"
#include "xdot.h"
#include "xgemv.h"
#include "blas.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo lf_emlrtRSI = { 1,  /* lineNo */
  "assignResidualsToXSlack",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\assignResidualsToXSlack.p"/* pathName */
};

static emlrtRSInfo mf_emlrtRSI = { 1,  /* lineNo */
  "relaxed",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p"/* pathName */
};

static emlrtRSInfo nf_emlrtRSI = { 1,  /* lineNo */
  "findActiveSlackLowerBounds",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\findActiveSlackLowerBounds.p"/* pathName */
};

static emlrtRSInfo of_emlrtRSI = { 1,  /* lineNo */
  "removeActiveSlackLowerBounds",      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\removeActiveSlackLowerBounds.p"/* pathName */
};

static emlrtBCInfo jd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "relaxed",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "assignResidualsToXSlack",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\assignResidualsToXSlack.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ld_emlrtBCI = { 1,  /* iFirst */
  66,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "relaxed",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo md_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "findActiveSlackLowerBounds",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\findActiveSlackLowerBounds.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeActiveSlackLowerBounds",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\removeActiveSlackLowerBounds.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void relaxed(const emlrtStack *sp, const real_T Hessian[4356], const
             emxArray_real_T *grad, d_struct_T *TrialState, k_struct_T
             *MeritFunction, c_struct_T *memspace, j_struct_T *WorkingSet,
             g_struct_T *QRManager, h_struct_T *CholManager, i_struct_T
             *QPObjective, b_struct_T *qpoptions)
{
  ptrdiff_t incx_t;
  ptrdiff_t n_t;
  b_struct_T b_qpoptions;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T beta;
  real_T rho;
  int32_T b_mEq;
  int32_T b_mIneq;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T idx;
  int32_T idx_max;
  int32_T idx_negative;
  int32_T idx_positive;
  int32_T mEq;
  int32_T mIneq;
  int32_T nActiveLBArtificial;
  int32_T nVarMax;
  int32_T nVarOrig;
  boolean_T b_tf;
  boolean_T tf;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  nVarOrig = WorkingSet->nVar;
  nVarMax = WorkingSet->nVarMax;
  mIneq = WorkingSet->sizes[2];
  mEq = WorkingSet->sizes[1];
  beta = 0.0;
  st.site = &mf_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nVarOrig; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > 66)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, 66, &ld_emlrtBCI, sp);
    }

    beta += Hessian[idx + 66 * idx];
  }

  beta /= (real_T)WorkingSet->nVar;
  if (TrialState->sqpIterations <= 1) {
    if (QPObjective->nvar < 1) {
      idx_max = 0;
    } else {
      n_t = (ptrdiff_t)QPObjective->nvar;
      incx_t = (ptrdiff_t)1;
      n_t = idamax(&n_t, &grad->data[0], &incx_t);
      idx_max = (int32_T)n_t;
    }

    if ((idx_max < 1) || (idx_max > grad->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx_max, 1, grad->size[0], &jd_emlrtBCI, sp);
    }

    rho = 100.0 * muDoubleScalarMax(1.0, muDoubleScalarAbs(grad->data[idx_max -
      1]));
  } else {
    i = TrialState->lambdasqp->size[0];
    i1 = ixamax(WorkingSet->mConstr, TrialState->lambdasqp);
    if ((i1 < 1) || (i1 > i)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i, &jd_emlrtBCI, sp);
    }

    rho = muDoubleScalarAbs(TrialState->lambdasqp->data[i1 - 1]);
  }

  QPObjective->nvar = WorkingSet->nVar;
  QPObjective->beta = beta;
  QPObjective->rho = rho;
  QPObjective->hasLinear = true;
  QPObjective->objtype = 4;
  st.site = &mf_emlrtRSI;
  setProblemType(&st, WorkingSet, 2);
  st.site = &mf_emlrtRSI;
  b_mIneq = WorkingSet->sizes[2];
  b_mEq = WorkingSet->sizes[1];
  idx_max = (WorkingSet->sizes[3] - (WorkingSet->sizes[1] << 1)) -
    WorkingSet->sizes[2];
  b_st.site = &lf_emlrtRSI;
  b_xcopy(WorkingSet->sizes[2], WorkingSet->bineq, memspace->workspace_double);
  b_st.site = &lf_emlrtRSI;
  e_xgemv(nVarOrig, WorkingSet->sizes[2], WorkingSet->Aineq, WorkingSet->ldA,
          TrialState->xstar, memspace->workspace_double);
  b_st.site = &lf_emlrtRSI;
  if ((1 <= WorkingSet->sizes[2]) && (WorkingSet->sizes[2] > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < b_mIneq; idx++) {
    i = memspace->workspace_double->size[0] * memspace->workspace_double->size[1];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kd_emlrtBCI, &st);
    }

    i = memspace->workspace_double->size[0] * memspace->workspace_double->size[1];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kd_emlrtBCI, &st);
    }

    i = TrialState->xstar->size[0];
    i1 = (nVarOrig + idx) + 1;
    if ((i1 < 1) || (i1 > i)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i, &kd_emlrtBCI, &st);
    }

    TrialState->xstar->data[i1 - 1] = (real_T)(memspace->workspace_double->
      data[idx] > 0.0) * memspace->workspace_double->data[idx];
    i = memspace->workspace_double->size[0] * memspace->workspace_double->size[1];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kd_emlrtBCI, &st);
    }

    if (memspace->workspace_double->data[idx] <= 1.0E-6) {
      b_st.site = &lf_emlrtRSI;
      c_st.site = &ef_emlrtRSI;
      addBoundToActiveSetMatrix_(&c_st, WorkingSet, 4, (idx_max + idx) + 1);
    }
  }

  b_st.site = &lf_emlrtRSI;
  b_xcopy(b_mEq, WorkingSet->beq, memspace->workspace_double);
  b_st.site = &lf_emlrtRSI;
  e_xgemv(nVarOrig, b_mEq, WorkingSet->Aeq, WorkingSet->ldA, TrialState->xstar,
          memspace->workspace_double);
  b_st.site = &lf_emlrtRSI;
  if ((1 <= b_mEq) && (b_mEq > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < b_mEq; idx++) {
    idx_positive = (b_mIneq + idx) + 1;
    idx_negative = ((b_mIneq + b_mEq) + idx) + 1;
    i = memspace->workspace_double->size[0] * memspace->workspace_double->size[1];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kd_emlrtBCI, &st);
    }

    if (memspace->workspace_double->data[idx] <= 0.0) {
      i = TrialState->xstar->size[0];
      i1 = nVarOrig + idx_positive;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &kd_emlrtBCI, &st);
      }

      TrialState->xstar->data[i1 - 1] = 0.0;
      i = memspace->workspace_double->size[0] * memspace->workspace_double->
        size[1];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kd_emlrtBCI, &st);
      }

      i = TrialState->xstar->size[0];
      i1 = nVarOrig + idx_negative;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &kd_emlrtBCI, &st);
      }

      TrialState->xstar->data[i1 - 1] = -memspace->workspace_double->data[idx];
      b_st.site = &lf_emlrtRSI;
      c_st.site = &ef_emlrtRSI;
      addBoundToActiveSetMatrix_(&c_st, WorkingSet, 4, idx_max + idx_positive);
      i = memspace->workspace_double->size[0] * memspace->workspace_double->
        size[1];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kd_emlrtBCI, &st);
      }

      if (memspace->workspace_double->data[idx] >= -1.0E-6) {
        b_st.site = &lf_emlrtRSI;
        c_st.site = &ef_emlrtRSI;
        addBoundToActiveSetMatrix_(&c_st, WorkingSet, 4, idx_max + idx_negative);
      }
    } else {
      i = memspace->workspace_double->size[0] * memspace->workspace_double->
        size[1];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kd_emlrtBCI, &st);
      }

      i = TrialState->xstar->size[0];
      i1 = nVarOrig + idx_positive;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &kd_emlrtBCI, &st);
      }

      TrialState->xstar->data[i1 - 1] = memspace->workspace_double->data[idx];
      i = TrialState->xstar->size[0];
      i1 = nVarOrig + idx_negative;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &kd_emlrtBCI, &st);
      }

      TrialState->xstar->data[i1 - 1] = 0.0;
      b_st.site = &lf_emlrtRSI;
      c_st.site = &ef_emlrtRSI;
      addBoundToActiveSetMatrix_(&c_st, WorkingSet, 4, idx_max + idx_negative);
      i = memspace->workspace_double->size[0] * memspace->workspace_double->
        size[1];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kd_emlrtBCI, &st);
      }

      if (memspace->workspace_double->data[idx] <= 1.0E-6) {
        b_st.site = &lf_emlrtRSI;
        c_st.site = &ef_emlrtRSI;
        addBoundToActiveSetMatrix_(&c_st, WorkingSet, 4, idx_max + idx_positive);
      }
    }
  }

  idx_max = qpoptions->MaxIterations;
  qpoptions->MaxIterations = (qpoptions->MaxIterations + WorkingSet->nVar) -
    nVarOrig;
  b_qpoptions = *qpoptions;
  st.site = &mf_emlrtRSI;
  b_driver(&st, Hessian, grad, TrialState, memspace, WorkingSet, QRManager,
           CholManager, QPObjective, &b_qpoptions, qpoptions->MaxIterations);
  qpoptions->MaxIterations = idx_max;
  st.site = &mf_emlrtRSI;
  b_mIneq = WorkingSet->sizes[2];
  b_mEq = WorkingSet->sizes[1];
  i = WorkingSet->sizes[1] << 1;
  idx_max = (i + WorkingSet->sizes[2]) - 1;
  idx_positive = WorkingSet->sizes[3] - 1;
  nActiveLBArtificial = 0;
  b_st.site = &nf_emlrtRSI;
  if ((1 <= WorkingSet->sizes[1]) && (WorkingSet->sizes[1] > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < b_mEq; idx++) {
    b_st.site = &nf_emlrtRSI;
    i1 = WorkingSet->isActiveConstr->size[0];
    i2 = WorkingSet->isActiveIdx[3] + idx_positive;
    idx_negative = ((i2 - (b_mEq << 1)) + idx) + 1;
    if ((idx_negative < 1) || (idx_negative > i1)) {
      emlrtDynamicBoundsCheckR2012b(idx_negative, 1, i1, &tb_emlrtBCI, &b_st);
    }

    tf = WorkingSet->isActiveConstr->data[idx_negative - 1];
    b_st.site = &nf_emlrtRSI;
    i1 = WorkingSet->isActiveConstr->size[0];
    i2 = ((i2 - b_mEq) + idx) + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &tb_emlrtBCI, &b_st);
    }

    b_tf = WorkingSet->isActiveConstr->data[i2 - 1];
    i1 = memspace->workspace_int->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i1)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i1, &md_emlrtBCI, &st);
    }

    memspace->workspace_int->data[idx] = tf;
    i1 = memspace->workspace_int->size[0];
    i2 = (idx + b_mEq) + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &md_emlrtBCI, &st);
    }

    memspace->workspace_int->data[i2 - 1] = b_tf;
    nActiveLBArtificial = (nActiveLBArtificial + tf) + b_tf;
  }

  b_st.site = &nf_emlrtRSI;
  if ((1 <= WorkingSet->sizes[2]) && (WorkingSet->sizes[2] > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < b_mIneq; idx++) {
    b_st.site = &nf_emlrtRSI;
    i1 = WorkingSet->isActiveConstr->size[0];
    i2 = ((WorkingSet->isActiveIdx[3] + idx_positive) - idx_max) + idx;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &tb_emlrtBCI, &b_st);
    }

    tf = WorkingSet->isActiveConstr->data[i2 - 1];
    i1 = memspace->workspace_int->size[0];
    i2 = (idx + i) + 1;
    if ((i2 < 1) || (i2 > i1)) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &md_emlrtBCI, &st);
    }

    memspace->workspace_int->data[i2 - 1] = tf;
    nActiveLBArtificial += tf;
  }

  if (TrialState->state != -6) {
    idx_max = (WorkingSet->nVarMax - nVarOrig) - 1;
    st.site = &mf_emlrtRSI;
    b_updatePenaltyParam(&st, MeritFunction, TrialState->sqpFval,
                         TrialState->cIneq, mIneq, TrialState->cEq, mEq,
                         TrialState->sqpIterations, (TrialState->fstar - rho *
      xasum(idx_max, TrialState->xstar, nVarOrig + 1)) - beta / 2.0 * c_xdot
                         (idx_max, TrialState->xstar, nVarOrig + 1,
                          TrialState->xstar, nVarOrig + 1), TrialState->xstar,
                         nVarOrig + 1, (nVarMax - nVarOrig) - 1);
    idx_max = WorkingSet->isActiveIdx[1] - 1;
    st.site = &mf_emlrtRSI;
    if ((1 <= mEq) && (mEq > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mEq; idx++) {
      i = memspace->workspace_int->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &jd_emlrtBCI, sp);
      }

      if (memspace->workspace_int->data[idx] != 0) {
        i = memspace->workspace_int->size[0];
        i1 = (idx + mEq) + 1;
        if ((i1 < 1) || (i1 > i)) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, i, &jd_emlrtBCI, sp);
        }

        if (memspace->workspace_int->data[i1 - 1] != 0) {
          tf = true;
        } else {
          tf = false;
        }
      } else {
        tf = false;
      }

      i = TrialState->lambda->size[0];
      i1 = (idx_max + idx) + 1;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &jd_emlrtBCI, sp);
      }

      i = TrialState->lambda->size[0];
      if (i1 > i) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &jd_emlrtBCI, sp);
      }

      TrialState->lambda->data[i1 - 1] *= (real_T)tf;
    }

    idx_max = WorkingSet->isActiveIdx[2];
    idx_positive = WorkingSet->nActiveConstr;
    st.site = &mf_emlrtRSI;
    if ((WorkingSet->isActiveIdx[2] <= WorkingSet->nActiveConstr) &&
        (WorkingSet->nActiveConstr > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = idx_max; idx <= idx_positive; idx++) {
      i = WorkingSet->Wlocalidx->size[0];
      if ((idx < 1) || (idx > i)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &jd_emlrtBCI, sp);
      }

      i = WorkingSet->Wid->size[0];
      if (idx > i) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &jd_emlrtBCI, sp);
      }

      if (WorkingSet->Wid->data[idx - 1] == 3) {
        i = memspace->workspace_int->size[0];
        i1 = WorkingSet->Wlocalidx->data[idx - 1] + (mEq << 1);
        if ((i1 < 1) || (i1 > i)) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, i, &jd_emlrtBCI, sp);
        }

        i = TrialState->lambda->size[0];
        if (idx > i) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i, &jd_emlrtBCI, sp);
        }

        i = TrialState->lambda->size[0];
        if (idx > i) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i, &jd_emlrtBCI, sp);
        }

        TrialState->lambda->data[idx - 1] *= (real_T)memspace->
          workspace_int->data[i1 - 1];
      }
    }
  }

  st.site = &mf_emlrtRSI;
  mEq = WorkingSet->sizes[1];
  i = (WorkingSet->sizes[3] - (WorkingSet->sizes[1] << 1)) - WorkingSet->sizes[2];
  idx = WorkingSet->nActiveConstr;
  while ((idx > mEq) && (nActiveLBArtificial > 0)) {
    i1 = WorkingSet->Wid->size[0];
    if ((idx < 1) || (idx > i1)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, i1, &nd_emlrtBCI, &st);
    }

    i1 = WorkingSet->Wid->data[idx - 1];
    if (i1 == 4) {
      i1 = WorkingSet->Wlocalidx->size[0];
      if (idx > i1) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i1, &nd_emlrtBCI, &st);
      }

      i1 = WorkingSet->Wlocalidx->data[idx - 1];
      if (i1 > i) {
        i2 = TrialState->lambda->size[0];
        if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > i2))
        {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, i2,
            &nd_emlrtBCI, &st);
        }

        idx_max = WorkingSet->nActiveConstr - 1;
        beta = TrialState->lambda->data[idx_max];
        i2 = TrialState->lambda->size[0];
        if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > i2))
        {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, i2,
            &nd_emlrtBCI, &st);
        }

        TrialState->lambda->data[idx_max] = 0.0;
        i2 = TrialState->lambda->size[0];
        if (idx > i2) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i2, &nd_emlrtBCI, &st);
        }

        TrialState->lambda->data[idx - 1] = beta;
        b_st.site = &of_emlrtRSI;
        i2 = WorkingSet->Wid->size[0];
        if (idx > i2) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i2, &ub_emlrtBCI, &b_st);
        }

        i2 = WorkingSet->Wlocalidx->size[0];
        if (idx > i2) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i2, &ub_emlrtBCI, &b_st);
        }

        i2 = WorkingSet->isActiveConstr->size[0];
        i1 = (WorkingSet->isActiveIdx[3] + i1) - 1;
        if ((i1 < 1) || (i1 > i2)) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, i2, &ub_emlrtBCI, &b_st);
        }

        WorkingSet->isActiveConstr->data[i1 - 1] = false;
        c_st.site = &id_emlrtRSI;
        moveConstraint_(&c_st, WorkingSet, WorkingSet->nActiveConstr, idx);
        WorkingSet->nActiveConstr--;
        WorkingSet->nWConstr[3]--;
        nActiveLBArtificial--;
      }
    }

    idx--;
  }

  QPObjective->nvar = nVarOrig;
  QPObjective->hasLinear = true;
  QPObjective->objtype = 3;
  st.site = &mf_emlrtRSI;
  setProblemType(&st, WorkingSet, 3);
  st.site = &mf_emlrtRSI;
  sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
               WorkingSet->sizes, WorkingSet->isActiveIdx, WorkingSet->Wid,
               WorkingSet->Wlocalidx, memspace->workspace_double);
}

/* End of code generation (relaxed.c) */
