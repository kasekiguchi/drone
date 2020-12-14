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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
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
static emlrtRSInfo sc_emlrtRSI = { 42, /* lineNo */
  "xdotx",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+refblas\\xdotx.m"/* pathName */
};

static emlrtRSInfo kf_emlrtRSI = { 1,  /* lineNo */
  "updatePenaltyParam",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\updatePenaltyParam.p"/* pathName */
};

static emlrtRSInfo lf_emlrtRSI = { 1,  /* lineNo */
  "computeConstrViolationEq_",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeConstrViolationEq_.p"/* pathName */
};

static emlrtRSInfo of_emlrtRSI = { 1,  /* lineNo */
  "computeConstrViolationIneq_",       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+MeritFunction\\computeConstrViolationIneq_.p"/* pathName */
};

static emlrtRSInfo qf_emlrtRSI = { 1,  /* lineNo */
  "relaxed",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p"/* pathName */
};

static emlrtRSInfo sf_emlrtRSI = { 1,  /* lineNo */
  "findActiveSlackLowerBounds",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\findActiveSlackLowerBounds.p"/* pathName */
};

static emlrtRSInfo tf_emlrtRSI = { 1,  /* lineNo */
  "removeActiveSlackLowerBounds",      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\removeActiveSlackLowerBounds.p"/* pathName */
};

static emlrtBCInfo sd_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "relaxed",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo td_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "relaxed",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ud_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeActiveSlackLowerBounds",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\removeActiveSlackLowerBounds.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo vd_emlrtBCI = { 1,  /* iFirst */
  110,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "relaxed",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\relaxed.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wd_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeActiveSlackLowerBounds",      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\removeActiveSlackLowerBounds.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void relaxed(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T
             Hessian[12100], const real_T grad[307], e_struct_T *TrialState,
             i_struct_T *MeritFunction, b_struct_T *memspace, g_struct_T
             *WorkingSet, k_struct_T *QRManager, l_struct_T *CholManager,
             j_struct_T *QPObjective, c_struct_T *qpoptions)
{
  int32_T nVarOrig;
  real_T beta;
  int32_T idx;
  int32_T temp;
  int32_T idx_max;
  real_T smax;
  int32_T ix;
  int32_T k;
  real_T s;
  c_struct_T b_qpoptions;
  c_struct_T c_qpoptions;
  int32_T nActiveLBArtificial;
  real_T qpfvalQuadExcess;
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
  st.site = &qf_emlrtRSI;
  if ((1 <= WorkingSet->nVar) && (WorkingSet->nVar > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < nVarOrig; idx++) {
    temp = idx + 1;
    if ((temp < 1) || (temp > 110)) {
      emlrtDynamicBoundsCheckR2012b(temp, 1, 110, &vd_emlrtBCI, sp);
    }

    beta += Hessian[(temp + 110 * (temp - 1)) - 1];
  }

  beta /= (real_T)WorkingSet->nVar;
  if (TrialState->sqpIterations <= 1) {
    st.site = &qf_emlrtRSI;
    idx_max = ixamax(&st, QPObjective->nvar, grad);
    if ((idx_max < 1) || (idx_max > 307)) {
      emlrtDynamicBoundsCheckR2012b(idx_max, 1, 307, &sd_emlrtBCI, sp);
    }

    smax = 100.0 * muDoubleScalarMax(1.0, muDoubleScalarAbs(grad[idx_max - 1]));
  } else {
    st.site = &qf_emlrtRSI;
    temp = WorkingSet->mConstr;
    b_st.site = &t_emlrtRSI;
    idx_max = 1;
    ix = 0;
    smax = muDoubleScalarAbs(TrialState->lambdasqp[0]);
    c_st.site = &u_emlrtRSI;
    if ((2 <= WorkingSet->mConstr) && (WorkingSet->mConstr > 2147483646)) {
      d_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (k = 2; k <= temp; k++) {
      ix++;
      s = muDoubleScalarAbs(TrialState->lambdasqp[ix]);
      if (s > smax) {
        idx_max = k;
        smax = s;
      }
    }

    smax = muDoubleScalarAbs(TrialState->lambdasqp[idx_max - 1]);
  }

  QPObjective->nvar = WorkingSet->nVar;
  QPObjective->beta = beta;
  QPObjective->rho = smax;
  QPObjective->hasLinear = true;
  QPObjective->objtype = 4;
  st.site = &qf_emlrtRSI;
  setProblemType(&st, WorkingSet, 2);
  st.site = &qf_emlrtRSI;
  assignResidualsToXSlack(&st, nVarOrig, WorkingSet, TrialState, memspace);
  temp = qpoptions->MaxIterations;
  qpoptions->MaxIterations = (qpoptions->MaxIterations + WorkingSet->nVar) -
    nVarOrig;
  b_qpoptions = *qpoptions;
  c_qpoptions = *qpoptions;
  st.site = &qf_emlrtRSI;
  b_driver(SD, &st, Hessian, grad, TrialState, memspace, WorkingSet, QRManager,
           CholManager, QPObjective, &b_qpoptions, &c_qpoptions);
  qpoptions->MaxIterations = temp;
  st.site = &qf_emlrtRSI;
  temp = WorkingSet->sizes[3] - 196;
  nActiveLBArtificial = 0;
  b_st.site = &sf_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    b_st.site = &sf_emlrtRSI;
    k = (WorkingSet->isActiveIdx[3] + temp) + idx;
    ix = k + 20;
    if ((ix < 1) || (ix > 305)) {
      emlrtDynamicBoundsCheckR2012b(ix, 1, 305, &mc_emlrtBCI, &b_st);
    }

    b_st.site = &sf_emlrtRSI;
    k += 108;
    if ((k < 1) || (k > 305)) {
      emlrtDynamicBoundsCheckR2012b(k, 1, 305, &mc_emlrtBCI, &b_st);
    }

    ix = WorkingSet->isActiveConstr[ix - 1];
    memspace->workspace_int[idx] = ix;
    k = WorkingSet->isActiveConstr[k - 1];
    memspace->workspace_int[idx + 88] = k;
    nActiveLBArtificial = (nActiveLBArtificial + ix) + k;
  }

  b_st.site = &sf_emlrtRSI;
  for (idx = 0; idx < 20; idx++) {
    b_st.site = &sf_emlrtRSI;
    k = (WorkingSet->isActiveIdx[3] + temp) + idx;
    if ((k < 1) || (k > 305)) {
      emlrtDynamicBoundsCheckR2012b(k, 1, 305, &mc_emlrtBCI, &b_st);
    }

    k = WorkingSet->isActiveConstr[k - 1];
    memspace->workspace_int[idx + 176] = k;
    nActiveLBArtificial += k;
  }

  if (TrialState->state != -6) {
    temp = 305 - nVarOrig;
    st.site = &qf_emlrtRSI;
    s = xasum(&st, 306 - nVarOrig, TrialState->xstar, nVarOrig + 1);
    st.site = &qf_emlrtRSI;
    b_st.site = &qc_emlrtRSI;
    c_st.site = &rc_emlrtRSI;
    qpfvalQuadExcess = 0.0;
    if (306 - nVarOrig >= 1) {
      ix = nVarOrig;
      idx_max = nVarOrig;
      d_st.site = &sc_emlrtRSI;
      if ((1 <= 306 - nVarOrig) && (306 - nVarOrig > 2147483646)) {
        e_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&e_st);
      }

      for (k = 0; k <= temp; k++) {
        qpfvalQuadExcess += TrialState->xstar[ix] * TrialState->xstar[idx_max];
        ix++;
        idx_max++;
      }
    }

    qpfvalQuadExcess = (TrialState->fstar - smax * s) - beta / 2.0 *
      qpfvalQuadExcess;
    st.site = &qf_emlrtRSI;
    beta = MeritFunction->penaltyParam;
    b_st.site = &kf_emlrtRSI;
    c_st.site = &lf_emlrtRSI;
    d_st.site = &mf_emlrtRSI;
    smax = 0.0;
    for (k = 0; k < 88; k++) {
      smax += muDoubleScalarAbs(TrialState->cEq[k]);
    }

    b_st.site = &kf_emlrtRSI;
    s = 0.0;
    c_st.site = &of_emlrtRSI;
    for (idx = 0; idx < 20; idx++) {
      if (TrialState->cIneq[idx] > 0.0) {
        s += TrialState->cIneq[idx];
      }
    }

    s += smax;
    smax = MeritFunction->linearizedConstrViol;
    b_st.site = &kf_emlrtRSI;
    MeritFunction->linearizedConstrViol = xasum(&b_st, 306 - nVarOrig,
      TrialState->xstar, nVarOrig + 1);
    smax = (s + smax) - MeritFunction->linearizedConstrViol;
    if ((smax > 2.2204460492503131E-16) && (qpfvalQuadExcess > 0.0)) {
      if (TrialState->sqpFval == 0.0) {
        beta = 1.0;
      } else {
        beta = 1.5;
      }

      beta = beta * qpfvalQuadExcess / smax;
    }

    if (beta < MeritFunction->penaltyParam) {
      MeritFunction->phi = TrialState->sqpFval + beta * s;
      if ((MeritFunction->initFval + beta *
           (MeritFunction->initConstrViolationEq +
            MeritFunction->initConstrViolationIneq)) - MeritFunction->phi >
          (real_T)MeritFunction->nPenaltyDecreases * MeritFunction->threshold) {
        MeritFunction->nPenaltyDecreases++;
        if ((MeritFunction->nPenaltyDecreases << 1) > TrialState->sqpIterations)
        {
          MeritFunction->threshold *= 10.0;
        }

        MeritFunction->penaltyParam = muDoubleScalarMax(beta, 1.0E-10);
      } else {
        MeritFunction->phi = TrialState->sqpFval + MeritFunction->penaltyParam *
          s;
      }
    } else {
      MeritFunction->penaltyParam = muDoubleScalarMax(beta, 1.0E-10);
      MeritFunction->phi = TrialState->sqpFval + MeritFunction->penaltyParam * s;
    }

    MeritFunction->phiPrimePlus = muDoubleScalarMin(qpfvalQuadExcess -
      MeritFunction->penaltyParam * s, 0.0);
    temp = WorkingSet->isActiveIdx[1];
    st.site = &qf_emlrtRSI;
    for (idx = 0; idx < 88; idx++) {
      if ((memspace->workspace_int[idx] != 0) && (memspace->workspace_int[idx +
           88] != 0)) {
        isAeqActive = true;
      } else {
        isAeqActive = false;
      }

      k = temp + idx;
      if ((k < 1) || (k > 305)) {
        emlrtDynamicBoundsCheckR2012b(k, 1, 305, &td_emlrtBCI, sp);
      }

      TrialState->lambda[k - 1] *= (real_T)isAeqActive;
    }

    temp = WorkingSet->isActiveIdx[2];
    idx_max = WorkingSet->nActiveConstr;
    st.site = &qf_emlrtRSI;
    if ((WorkingSet->isActiveIdx[2] <= WorkingSet->nActiveConstr) &&
        (WorkingSet->nActiveConstr > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = temp; idx <= idx_max; idx++) {
      if ((idx < 1) || (idx > 305)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, 305, &td_emlrtBCI, sp);
      }

      if (WorkingSet->Wid[idx - 1] == 3) {
        k = WorkingSet->Wlocalidx[idx - 1];
        ix = k + 176;
        if ((ix < 1) || (ix > 307)) {
          emlrtDynamicBoundsCheckR2012b(ix, 1, 307, &sd_emlrtBCI, sp);
        }

        TrialState->lambda[idx - 1] *= (real_T)memspace->workspace_int[k + 175];
      }
    }
  }

  st.site = &qf_emlrtRSI;
  temp = WorkingSet->sizes[3] - 196;
  idx = WorkingSet->nActiveConstr - 1;
  while ((idx + 1 > 88) && (nActiveLBArtificial > 0)) {
    k = idx + 1;
    if ((k < 1) || (k > 305)) {
      emlrtDynamicBoundsCheckR2012b(k, 1, 305, &wd_emlrtBCI, &st);
    }

    if ((WorkingSet->Wid[k - 1] == 4) && (WorkingSet->Wlocalidx[idx] > temp)) {
      if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > 305))
      {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, 305,
          &wd_emlrtBCI, &st);
      }

      smax = TrialState->lambda[WorkingSet->nActiveConstr - 1];
      if ((WorkingSet->nActiveConstr < 1) || (WorkingSet->nActiveConstr > 305))
      {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->nActiveConstr, 1, 305,
          &ud_emlrtBCI, &st);
      }

      TrialState->lambda[WorkingSet->nActiveConstr - 1] = 0.0;
      TrialState->lambda[idx] = smax;
      b_st.site = &tf_emlrtRSI;
      idx_max = WorkingSet->Wid[idx];
      if ((WorkingSet->Wid[idx] < 1) || (WorkingSet->Wid[idx] > 6)) {
        emlrtDynamicBoundsCheckR2012b(WorkingSet->Wid[idx], 1, 6, &eb_emlrtBCI,
          &b_st);
      }

      k = (WorkingSet->isActiveIdx[WorkingSet->Wid[idx] - 1] +
           WorkingSet->Wlocalidx[idx]) - 1;
      if ((k < 1) || (k > 305)) {
        emlrtDynamicBoundsCheckR2012b(k, 1, 305, &pb_emlrtBCI, &b_st);
      }

      WorkingSet->isActiveConstr[k - 1] = false;
      c_st.site = &wc_emlrtRSI;
      moveConstraint_(&c_st, WorkingSet, WorkingSet->nActiveConstr, idx + 1);
      WorkingSet->nActiveConstr--;
      if ((idx_max < 1) || (idx_max > 5)) {
        emlrtDynamicBoundsCheckR2012b(idx_max, 1, 5, &rb_emlrtBCI, &b_st);
      }

      WorkingSet->nWConstr[idx_max - 1]--;
      nActiveLBArtificial--;
    }

    idx--;
  }

  QPObjective->nvar = nVarOrig;
  QPObjective->hasLinear = true;
  QPObjective->objtype = 3;
  st.site = &qf_emlrtRSI;
  setProblemType(&st, WorkingSet, 3);
  st.site = &qf_emlrtRSI;
  sortLambdaQP(&st, TrialState->lambda, WorkingSet->nActiveConstr,
               WorkingSet->sizes, WorkingSet->isActiveIdx, WorkingSet->Wid,
               WorkingSet->Wlocalidx, memspace->workspace_double);
}

/* End of code generation (relaxed.c) */
