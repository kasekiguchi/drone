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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "assignResidualsToXSlack.h"
#include "driver1.h"
#include "eml_int_forloop_overflow_check.h"
#include "ixamax.h"
#include "moveConstraint_.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "setProblemType.h"
#include "sortLambdaQP.h"
#include "xasum.h"

/* Variable Definitions */
static emlrtRSInfo ih_emlrtRSI = { 42, /* lineNo */
  "xdotx",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xdotx.m"/* pathName */
};

static emlrtRSInfo bk_emlrtRSI = { 1,  /* lineNo */
  "updatePenaltyParam",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\updatePenaltyParam.p"/* pathName */
};

static emlrtRSInfo ck_emlrtRSI = { 1,  /* lineNo */
  "computeConstrViolationEq_",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeConstrViolationEq_.p"/* pathName */
};

static emlrtRSInfo fk_emlrtRSI = { 1,  /* lineNo */
  "computeConstrViolationIneq_",       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeConstrViolationIneq_.p"/* pathName */
};

static emlrtRSInfo hk_emlrtRSI = { 1,  /* lineNo */
  "relaxed",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p"/* pathName */
};

static emlrtRSInfo jk_emlrtRSI = { 1,  /* lineNo */
  "findActiveSlackLowerBounds",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\findActiveSlackLowerBounds.p"/* pathName */
};

static emlrtRSInfo kk_emlrtRSI = { 1,  /* lineNo */
  "removeActiveSlackLowerBounds",      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\removeActiveSlackLowerBounds.p"/* pathName */
};

static emlrtBCInfo qe_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "relaxed",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo re_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "relaxed",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo se_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeActiveSlackLowerBounds",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\removeActiveSlackLowerBounds.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo te_emlrtBCI = { 1,  /* iFirst */
  132,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "relaxed",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ue_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeActiveSlackLowerBounds",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\removeActiveSlackLowerBounds.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void relaxed(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T
             Hessian[17424], const real_T grad[485], e_struct_T *TrialState,
             i_struct_T *MeritFunction, b_struct_T *memspace, g_struct_T
             *WorkingSet, k_struct_T *QRManager, l_struct_T *CholManager,
             j_struct_T *QPObjective, c_struct_T *qpoptions)
{
  int32_T nVarOrig;
  real_T beta;
  int32_T idx;
  int32_T idx_max;
  real_T rho;
  c_struct_T b_qpoptions;
  c_struct_T c_qpoptions;
  int32_T nActiveLBArtificial;
  int32_T k;
  int32_T iy;
  real_T qpfvalLinearExcess;
  real_T qpfvalQuadExcess;
  int32_T ix;
  boolean_T isAeqActive;
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
  nVarOrig = WorkingSet->nVar;
  beta = 0.0;
  st.site = &hk_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nVarOrig; idx++) {
    idx_max = idx + 1;
    if ((idx_max < 1) || (idx_max > 132)) {
      emlrtDynamicBoundsCheckR2012b(idx_max, 1, 132, &te_emlrtBCI, sp);
    }

    beta += Hessian[(idx_max + 132 * (idx_max - 1)) - 1];
  }

  beta /= (real_T)WorkingSet->nVar;
  if (TrialState->sqpIterations <= 1) {
    st.site = &hk_emlrtRSI;
    idx_max = ixamax(&st, QPObjective->nvar, grad);
    if ((idx_max < 1) || (idx_max > 485)) {
      emlrtDynamicBoundsCheckR2012b(idx_max, 1, 485, &qe_emlrtBCI, sp);
    }

    rho = 100.0 * muDoubleScalarMax(1.0, muDoubleScalarAbs(grad[idx_max - 1]));
  } else {
    st.site = &hk_emlrtRSI;
    idx_max = b_ixamax(WorkingSet->mConstr, TrialState->lambdasqp);
    if ((idx_max < 1) || (idx_max > 617)) {
      emlrtDynamicBoundsCheckR2012b(idx_max, 1, 617, &re_emlrtBCI, sp);
    }

    rho = muDoubleScalarAbs(TrialState->lambdasqp[idx_max - 1]);
  }

  QPObjective->nvar = WorkingSet->nVar;
  QPObjective->beta = beta;
  QPObjective->rho = rho;
  QPObjective->hasLinear = true;
  QPObjective->objtype = 4;
  st.site = &hk_emlrtRSI;
  setProblemType(&st, WorkingSet, 2);
  st.site = &hk_emlrtRSI;
  assignResidualsToXSlack(&st, nVarOrig, WorkingSet, TrialState, memspace);
  idx_max = qpoptions->MaxIterations;
  qpoptions->MaxIterations = (qpoptions->MaxIterations + WorkingSet->nVar) -
    nVarOrig;
  b_qpoptions = *qpoptions;
  c_qpoptions = *qpoptions;
  st.site = &hk_emlrtRSI;
  b_driver(SD, &st, Hessian, grad, TrialState, memspace, WorkingSet, QRManager,
           CholManager, QPObjective, &b_qpoptions, &c_qpoptions);
  qpoptions->MaxIterations = idx_max;
  st.site = &hk_emlrtRSI;
  idx_max = WorkingSet->sizes[3] - 352;
  nActiveLBArtificial = 0;
  b_st.site = &jk_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    b_st.site = &jk_emlrtRSI;
    k = (WorkingSet->isActiveIdx[3] + idx_max) + idx;
    iy = k + 176;
    if ((iy < 1) || (iy > 617)) {
      emlrtDynamicBoundsCheckR2012b(iy, 1, 617, &jd_emlrtBCI, &b_st);
    }

    b_st.site = &jk_emlrtRSI;
    k += 264;
    if ((k < 1) || (k > 617)) {
      emlrtDynamicBoundsCheckR2012b(k, 1, 617, &jd_emlrtBCI, &b_st);
    }

    iy = WorkingSet->isActiveConstr[iy - 1];
    memspace->workspace_int[idx] = iy;
    k = WorkingSet->isActiveConstr[k - 1];
    memspace->workspace_int[idx + 88] = k;
    nActiveLBArtificial = (nActiveLBArtificial + iy) + k;
  }

  b_st.site = &jk_emlrtRSI;
  for (idx = 0; idx < 176; idx++) {
    b_st.site = &jk_emlrtRSI;
    k = (WorkingSet->isActiveIdx[3] + idx_max) + idx;
    if ((k < 1) || (k > 617)) {
      emlrtDynamicBoundsCheckR2012b(k, 1, 617, &jd_emlrtBCI, &b_st);
    }

    k = WorkingSet->isActiveConstr[k - 1];
    memspace->workspace_int[idx + 176] = k;
    nActiveLBArtificial += k;
  }

  if (TrialState->state != -6) {
    idx_max = 483 - nVarOrig;
    st.site = &hk_emlrtRSI;
    qpfvalLinearExcess = xasum(&st, 484 - nVarOrig, TrialState->xstar, nVarOrig
      + 1);
    st.site = &hk_emlrtRSI;
    b_st.site = &ti_emlrtRSI;
    c_st.site = &hh_emlrtRSI;
    qpfvalQuadExcess = 0.0;
    if (484 - nVarOrig >= 1) {
      ix = nVarOrig;
      iy = nVarOrig;
      d_st.site = &ih_emlrtRSI;
      if ((1 <= 484 - nVarOrig) && (484 - nVarOrig > 2147483646)) {
        e_st.site = &t_emlrtRSI;
        check_forloop_overflow_error(&e_st);
      }

      for (k = 0; k <= idx_max; k++) {
        qpfvalQuadExcess += TrialState->xstar[ix] * TrialState->xstar[iy];
        ix++;
        iy++;
      }
    }

    qpfvalLinearExcess = (TrialState->fstar - rho * qpfvalLinearExcess) - beta /
      2.0 * qpfvalQuadExcess;
    st.site = &hk_emlrtRSI;
    qpfvalQuadExcess = MeritFunction->penaltyParam;
    b_st.site = &bk_emlrtRSI;
    c_st.site = &ck_emlrtRSI;
    d_st.site = &dk_emlrtRSI;
    beta = 0.0;
    for (k = 0; k < 88; k++) {
      beta += muDoubleScalarAbs(TrialState->cEq[k]);
    }

    b_st.site = &bk_emlrtRSI;
    rho = 0.0;
    c_st.site = &fk_emlrtRSI;
    for (idx = 0; idx < 176; idx++) {
      if (TrialState->cIneq[idx] > 0.0) {
        rho += TrialState->cIneq[idx];
      }
    }

    rho += beta;
    beta = MeritFunction->linearizedConstrViol;
    b_st.site = &bk_emlrtRSI;
    MeritFunction->linearizedConstrViol = xasum(&b_st, 484 - nVarOrig,
      TrialState->xstar, nVarOrig + 1);
    beta = (rho + beta) - MeritFunction->linearizedConstrViol;
    if ((beta > 2.2204460492503131E-16) && (qpfvalLinearExcess > 0.0)) {
      if (TrialState->sqpFval == 0.0) {
        qpfvalQuadExcess = 1.0;
      } else {
        qpfvalQuadExcess = 1.5;
      }

      qpfvalQuadExcess = qpfvalQuadExcess * qpfvalLinearExcess / beta;
    }

    if (qpfvalQuadExcess < MeritFunction->penaltyParam) {
      MeritFunction->phi = TrialState->sqpFval + qpfvalQuadExcess * rho;
      if ((MeritFunction->initFval + qpfvalQuadExcess *
           (MeritFunction->initConstrViolationEq +
            MeritFunction->initConstrViolationIneq)) - MeritFunction->phi >
          (real_T)MeritFunction->nPenaltyDecreases * MeritFunction->threshold) {
        MeritFunction->nPenaltyDecreases++;
        if ((MeritFunction->nPenaltyDecreases << 1) > TrialState->sqpIterations)
        {
          MeritFunction->threshold *= 10.0;
        }

        MeritFunction->penaltyParam = muDoubleScalarMax(qpfvalQuadExcess,
          1.0E-10);
      } else {
        MeritFunction->phi = TrialState->sqpFval + MeritFunction->penaltyParam *
          rho;
      }
    } else {
      MeritFunction->penaltyParam = muDoubleScalarMax(qpfvalQuadExcess, 1.0E-10);
      MeritFunction->phi = TrialState->sqpFval + MeritFunction->penaltyParam *
        rho;
    }

    MeritFunction->phiPrimePlus = muDoubleScalarMin(qpfvalLinearExcess -
      MeritFunction->penaltyParam * rho, 0.0);
    idx_max = WorkingSet->isActiveIdx[1];
    st.site = &hk_emlrtRSI;
    for (idx = 0; idx < 88; idx++) {
      if ((memspace->workspace_int[idx] != 0) && (memspace->workspace_int[idx +
           88] != 0)) {
        isAeqActive = true;
      } else {
        isAeqActive = false;
      }

      k = idx_max + idx;
      if ((k < 1) || (k > 617)) {
        emlrtDynamicBoundsCheckR2012b(k, 1, 617, &re_emlrtBCI, sp);
      }

      TrialState->lambda[k - 1] *= (real_T)isAeqActive;
    }

    idx_max = WorkingSet->isActiveIdx[2];
    ix = WorkingSet->nActiveConstr;
    st.site = &hk_emlrtRSI;
    if ((WorkingSet->isActiveIdx[2] <= WorkingSet->nActiveConstr) &&
        (WorkingSet->nActiveConstr > 2147483646)) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = idx_max; idx <= ix; idx++) {
      if ((idx < 1) || (idx > 617)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &re_emlrtBCI, sp);
      }

      if (WorkingSet->Wid[idx - 1] == 3) {
        k = WorkingSet->Wlocalidx[idx - 1];
        iy = k + 176;
        if ((iy < 1) || (iy > 617)) {
          emlrtDynamicBoundsCheckR2012b(iy, 1, 617, &re_emlrtBCI, sp);
        }

        TrialState->lambda[idx - 1] *= (real_T)memspace->workspace_int[k + 175];
      }
    }
  }

  st.site = &hk_emlrtRSI;
  idx_max = WorkingSet->sizes[3] - 352;
  idx = WorkingSet->nActiveConstr - 1;
  while ((idx + 1 > 88) && (nActiveLBArtificial > 0)) {
    k = idx + 1;
    if ((k < 1) || (k > 617)) {
      emlrtDynamicBoundsCheckR2012b(k, 1, 617, &ue_emlrtBCI, &st);
    }

    if ((WorkingSet->Wid[k - 1] == 4) && (WorkingSet->Wlocalidx[idx] > idx_max))
    {
      if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > 617))
      {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, 617,
          &ue_emlrtBCI, &st);
      }

      beta = TrialState->lambda[WorkingSet->nActiveConstr - 1];
      if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > 617))
      {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, 617,
          &se_emlrtBCI, &st);
      }

      TrialState->lambda[WorkingSet->nActiveConstr - 1] = 0.0;
      TrialState->lambda[idx] = beta;
      b_st.site = &kk_emlrtRSI;
      ix = WorkingSet->Wid[idx];
      if ((WorkingSet->Wid[idx] < 1) || (WorkingSet->Wid[idx] > 6)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->Wid[idx], 1, 6, &cc_emlrtBCI,
          &b_st);
      }

      k = (WorkingSet->isActiveIdx[WorkingSet->Wid[idx] - 1] +
           WorkingSet->Wlocalidx[idx]) - 1;
      if ((k < 1) || (k > 617)) {
        emlrtDynamicBoundsCheckR2012b(k, 1, 617, &kc_emlrtBCI, &b_st);
      }

      WorkingSet->isActiveConstr[k - 1] = false;
      c_st.site = &mh_emlrtRSI;
      moveConstraint_(&c_st, WorkingSet, WorkingSet->nActiveConstr, idx + 1);
      WorkingSet->nActiveConstr--;
      if ((ix < 1) || (ix > 5)) {
        emlrtDynamicBoundsCheckR2012b(ix, 1, 5, &mc_emlrtBCI, &b_st);
      }

      WorkingSet->nWConstr[ix - 1]--;
      nActiveLBArtificial--;
    }

    idx--;
  }

  QPObjective->nvar = nVarOrig;
  QPObjective->hasLinear = true;
  QPObjective->objtype = 3;
  st.site = &hk_emlrtRSI;
  setProblemType(&st, WorkingSet, 3);
  st.site = &hk_emlrtRSI;
  sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
               WorkingSet->sizes, WorkingSet->isActiveIdx, WorkingSet->Wid,
               WorkingSet->Wlocalidx, memspace->workspace_double);
}

/* End of code generation (relaxed.c) */
