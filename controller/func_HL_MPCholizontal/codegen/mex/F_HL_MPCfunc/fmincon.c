/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fmincon.c
 *
 * Code generation for function 'fmincon'
 *
 */

/* Include files */
#include "fmincon.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "checkLinearInputs.h"
#include "checkNonlinearInputs.h"
#include "computeFiniteDifferences.h"
#include "driver.h"
#include "eml_int_forloop_overflow_check.h"
#include "evalObjAndConstrAndDerivatives.h"
#include "factoryConstruct.h"
#include "factoryConstruct1.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "setProblemType.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo b_emlrtRSI = { 1,   /* lineNo */
  "fmincon",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\eml\\fmincon.p"/* pathName */
};

static emlrtRSInfo af_emlrtRSI = { 1,  /* lineNo */
  "initActiveSet",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\initActiveSet.p"/* pathName */
};

static emlrtRSInfo vk_emlrtRSI = { 1,  /* lineNo */
  "fillLambdaStruct",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p"/* pathName */
};

static emlrtBCInfo emlrtBCI = { 1,     /* iFirst */
  132,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "fillLambdaStruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { 1,   /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "fillLambdaStruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo emlrtRTEI = { 1,   /* lineNo */
  1,                                   /* colNo */
  "fmincon",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\eml\\fmincon.p"/* pName */
};

static emlrtBCInfo e_emlrtBCI = { 1,   /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "initActiveSet",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\initActiveSet.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void fmincon(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const struct0_T
             fun_tunableEnvironment[1], const real_T x0[132], const struct0_T
             nonlcon_tunableEnvironment[1], real_T x[132], real_T *fval, real_T *
             exitflag, real_T *output_iterations, real_T *output_funcCount,
             char_T output_algorithm[3], real_T *output_constrviolation, real_T *
             output_stepsize, real_T *output_lssteplength, real_T
             *output_firstorderopt, d_struct_T *lambda, real_T grad[132], real_T
             Hessian[17424])
{
  f_struct_T FcnEvaluator;
  real_T TrialState[132];
  int32_T iw0;
  h_struct_T FiniteDifferences;
  int32_T idx;
  int32_T iEq0;
  int32_T i;
  int32_T b_i;
  int32_T idx_local;
  i_struct_T MeritFunction;
  real_T normResid;
  j_struct_T s;
  real_T scale;
  real_T absxk;
  real_T t;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  output_algorithm[0] = 's';
  output_algorithm[1] = 'q';
  output_algorithm[2] = 'p';
  st.site = &b_emlrtRSI;
  checkLinearInputs(&st, x0);
  st.site = &b_emlrtRSI;
  checkNonlinearInputs(SD, &st, x0, nonlcon_tunableEnvironment);
  SD->f3.TrialState.nVarMax = 485;
  SD->f3.TrialState.mNonlinIneq = 176;
  SD->f3.TrialState.mNonlinEq = 88;
  SD->f3.TrialState.mIneq = 176;
  SD->f3.TrialState.mEq = 88;
  SD->f3.TrialState.iNonIneq0 = 1;
  SD->f3.TrialState.iNonEq0 = 1;
  SD->f3.TrialState.sqpFval = 0.0;
  SD->f3.TrialState.sqpFval_old = 0.0;
  memset(&SD->f3.TrialState.xstarsqp_old[0], 0, 132U * sizeof(real_T));
  memset(&SD->f3.TrialState.cIneq[0], 0, 176U * sizeof(real_T));
  memset(&SD->f3.TrialState.cIneq_old[0], 0, 176U * sizeof(real_T));
  memset(&SD->f3.TrialState.cEq[0], 0, 88U * sizeof(real_T));
  memset(&SD->f3.TrialState.cEq_old[0], 0, 88U * sizeof(real_T));
  memset(&SD->f3.TrialState.grad[0], 0, 485U * sizeof(real_T));
  memset(&SD->f3.TrialState.grad_old[0], 0, 485U * sizeof(real_T));
  SD->f3.TrialState.FunctionEvaluations = 0;
  SD->f3.TrialState.sqpIterations = 0;
  SD->f3.TrialState.sqpExitFlag = 0;
  memset(&SD->f3.TrialState.lambdasqp[0], 0, 617U * sizeof(real_T));
  memset(&SD->f3.TrialState.lambdasqp_old[0], 0, 617U * sizeof(real_T));
  SD->f3.TrialState.steplength = 1.0;
  memset(&SD->f3.TrialState.delta_x[0], 0, 485U * sizeof(real_T));
  memset(&SD->f3.TrialState.socDirection[0], 0, 485U * sizeof(real_T));
  memset(&SD->f3.TrialState.lambda_old[0], 0, 617U * sizeof(real_T));
  memset(&SD->f3.TrialState.workingset_old[0], 0, 617U * sizeof(int32_T));
  memset(&SD->f3.TrialState.JacCineqTrans_old[0], 0, 85360U * sizeof(real_T));
  memset(&SD->f3.TrialState.JacCeqTrans_old[0], 0, 42680U * sizeof(real_T));
  memset(&SD->f3.TrialState.gradLag[0], 0, 485U * sizeof(real_T));
  memset(&SD->f3.TrialState.delta_gradLag[0], 0, 485U * sizeof(real_T));
  memset(&SD->f3.TrialState.xstar[0], 0, 485U * sizeof(real_T));
  SD->f3.TrialState.fstar = 0.0;
  SD->f3.TrialState.firstorderopt = 0.0;
  memset(&SD->f3.TrialState.lambda[0], 0, 617U * sizeof(real_T));
  SD->f3.TrialState.state = 0;
  SD->f3.TrialState.maxConstr = 0.0;
  SD->f3.TrialState.iterations = 0;
  memset(&SD->f3.TrialState.searchDir[0], 0, 485U * sizeof(real_T));
  memcpy(&SD->f3.TrialState.xstarsqp[0], &x0[0], 132U * sizeof(real_T));
  FcnEvaluator.objfun.tunableEnvironment[0] = fun_tunableEnvironment[0];
  FcnEvaluator.nonlcon.tunableEnvironment[0] = nonlcon_tunableEnvironment[0];
  FcnEvaluator.nVar = 132;
  FcnEvaluator.mCineq = 176;
  FcnEvaluator.mCeq = 88;
  FcnEvaluator.NonFiniteSupport = true;
  FcnEvaluator.SpecifyObjectiveGradient = false;
  FcnEvaluator.SpecifyConstraintGradient = false;
  FcnEvaluator.ScaleProblem = false;
  b_factoryConstruct(&SD->f3.WorkingSet);
  memcpy(&TrialState[0], &SD->f3.TrialState.xstarsqp[0], 132U * sizeof(real_T));
  st.site = &b_emlrtRSI;
  evalObjAndConstrAndDerivatives(SD, &st, FcnEvaluator.objfun.tunableEnvironment,
    FcnEvaluator.nonlcon.tunableEnvironment, TrialState, SD->f3.TrialState.cIneq,
    SD->f3.TrialState.cEq, &SD->f3.TrialState.sqpFval, &iw0);
  if (iw0 != 1) {
    emlrtErrorWithMessageIdR2018a(sp, &emlrtRTEI,
      "optim_codegen:fmincon:UndefAtX0", "optim_codegen:fmincon:UndefAtX0", 0);
  }

  factoryConstruct(fun_tunableEnvironment, nonlcon_tunableEnvironment,
                   &FiniteDifferences);
  st.site = &b_emlrtRSI;
  computeFiniteDifferences(SD, &st, &FiniteDifferences,
    SD->f3.TrialState.sqpFval, SD->f3.TrialState.cIneq, SD->f3.TrialState.cEq,
    SD->f3.TrialState.xstarsqp, SD->f3.TrialState.grad, SD->f3.WorkingSet.Aineq,
    SD->f3.WorkingSet.Aeq);
  SD->f3.TrialState.FunctionEvaluations = FiniteDifferences.numEvals + 1;
  st.site = &b_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    SD->f3.WorkingSet.beq[idx] = -SD->f3.TrialState.cEq[idx];
    SD->f3.WorkingSet.bwset[idx] = SD->f3.WorkingSet.beq[idx];
  }

  iw0 = 1;
  iEq0 = 1;
  b_st.site = &we_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    for (i = 0; i < 132; i++) {
      b_i = iw0 + i;
      if ((b_i < 1) || (b_i > 299245)) {
        emlrtDynamicBoundsCheckR2012b(b_i, 1, 299245, &c_emlrtBCI, &st);
      }

      idx_local = iEq0 + i;
      if ((idx_local < 1) || (idx_local > 42680)) {
        emlrtDynamicBoundsCheckR2012b(idx_local, 1, 42680, &d_emlrtBCI, &st);
      }

      SD->f3.WorkingSet.ATwset[b_i - 1] = SD->f3.WorkingSet.Aeq[idx_local - 1];
    }

    iw0 += 485;
    iEq0 += 485;
  }

  for (idx = 0; idx < 176; idx++) {
    SD->f3.WorkingSet.bineq[idx] = -SD->f3.TrialState.cIneq[idx];
  }

  st.site = &b_emlrtRSI;
  b_st.site = &af_emlrtRSI;
  setProblemType(&b_st, &SD->f3.WorkingSet, 3);
  iw0 = SD->f3.WorkingSet.isActiveIdx[2];
  b_st.site = &af_emlrtRSI;
  for (idx = iw0; idx < 618; idx++) {
    if (idx < 1) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &e_emlrtBCI, &st);
    }

    SD->f3.WorkingSet.isActiveConstr[idx - 1] = false;
  }

  SD->f3.WorkingSet.nWConstr[0] = 0;
  SD->f3.WorkingSet.nWConstr[1] = 88;
  SD->f3.WorkingSet.nWConstr[2] = 0;
  SD->f3.WorkingSet.nWConstr[3] = 0;
  SD->f3.WorkingSet.nWConstr[4] = 0;
  SD->f3.WorkingSet.nActiveConstr = 88;
  b_st.site = &af_emlrtRSI;
  b_st.site = &af_emlrtRSI;
  b_i = SD->f3.WorkingSet.nVar - 1;
  for (idx_local = 0; idx_local < 88; idx_local++) {
    SD->f3.WorkingSet.Wid[idx_local] = 2;
    SD->f3.WorkingSet.Wlocalidx[idx_local] = idx_local + 1;
    SD->f3.WorkingSet.isActiveConstr[idx_local] = true;
    iw0 = 485 * idx_local;
    iEq0 = 485 * idx_local;
    for (i = 0; i <= b_i; i++) {
      SD->f3.WorkingSet.ATwset[iEq0 + i] = SD->f3.WorkingSet.Aeq[iw0 + i];
    }

    SD->f3.WorkingSet.bwset[idx_local] = SD->f3.WorkingSet.beq[idx_local];
  }

  MeritFunction.initFval = SD->f3.TrialState.sqpFval;
  MeritFunction.penaltyParam = 1.0;
  MeritFunction.threshold = 0.0001;
  MeritFunction.nPenaltyDecreases = 0;
  MeritFunction.linearizedConstrViol = 0.0;
  normResid = 0.0;
  for (iw0 = 0; iw0 < 88; iw0++) {
    normResid += muDoubleScalarAbs(SD->f3.TrialState.cEq[iw0]);
  }

  MeritFunction.initConstrViolationEq = normResid;
  normResid = 0.0;
  for (idx = 0; idx < 176; idx++) {
    if (SD->f3.TrialState.cIneq[idx] > 0.0) {
      normResid += SD->f3.TrialState.cIneq[idx];
    }
  }

  MeritFunction.initConstrViolationIneq = normResid;
  MeritFunction.phi = 0.0;
  MeritFunction.phiPrimePlus = 0.0;
  MeritFunction.phiFullStep = 0.0;
  MeritFunction.feasRelativeFactor = 0.0;
  MeritFunction.nlpPrimalFeasError = 0.0;
  MeritFunction.nlpDualFeasError = 0.0;
  MeritFunction.nlpComplError = 0.0;
  MeritFunction.firstOrderOpt = 0.0;
  MeritFunction.hasObjective = true;
  memset(&s.grad[0], 0, 485U * sizeof(real_T));
  memset(&s.Hx[0], 0, 484U * sizeof(real_T));
  s.hasLinear = true;
  s.nvar = 132;
  s.maxVar = 485;
  s.beta = 0.0;
  s.rho = 0.0;
  s.objtype = 3;
  s.prev_objtype = 3;
  s.prev_nvar = 0;
  s.prev_hasLinear = false;
  s.gammaScalar = 0.0;
  SD->f3.QRManager.ldq = 617;
  memset(&SD->f3.QRManager.Q[0], 0, 380689U * sizeof(real_T));
  memset(&SD->f3.QRManager.jpvt[0], 0, 617U * sizeof(int32_T));
  SD->f3.QRManager.mrows = 0;
  SD->f3.QRManager.ncols = 0;
  SD->f3.QRManager.minRowCol = 0;
  SD->f3.QRManager.usedPivoting = false;
  SD->f3.CholManager.ldm = 617;
  SD->f3.CholManager.ndims = 0;
  SD->f3.CholManager.info = 0;
  st.site = &b_emlrtRSI;
  driver(SD, &st, &SD->f3.TrialState, &MeritFunction, &FcnEvaluator,
         &FiniteDifferences, &SD->f3.memspace, &SD->f3.WorkingSet,
         &SD->f3.QRManager, &SD->f3.CholManager, &s, Hessian);
  *fval = SD->f3.TrialState.sqpFval;
  *exitflag = SD->f3.TrialState.sqpExitFlag;
  *output_iterations = SD->f3.TrialState.sqpIterations;
  *output_funcCount = SD->f3.TrialState.FunctionEvaluations;
  *output_constrviolation = MeritFunction.nlpPrimalFeasError;
  normResid = 0.0;
  scale = 3.3121686421112381E-170;
  for (iw0 = 0; iw0 < 132; iw0++) {
    x[iw0] = SD->f3.TrialState.xstarsqp[iw0];
    absxk = muDoubleScalarAbs(SD->f3.TrialState.delta_x[iw0]);
    if (absxk > scale) {
      t = scale / absxk;
      normResid = normResid * t * t + 1.0;
      scale = absxk;
    } else {
      t = absxk / scale;
      normResid += t * t;
    }
  }

  *output_stepsize = scale * muDoubleScalarSqrt(normResid);
  *output_lssteplength = SD->f3.TrialState.steplength;
  *output_firstorderopt = MeritFunction.firstOrderOpt;
  st.site = &b_emlrtRSI;
  iw0 = SD->f3.WorkingSet.sizes[3];
  memset(&lambda->eqnonlin[0], 0, 88U * sizeof(real_T));
  memset(&lambda->ineqnonlin[0], 0, 176U * sizeof(real_T));
  memset(&lambda->lower[0], 0, 132U * sizeof(real_T));
  memset(&lambda->upper[0], 0, 132U * sizeof(real_T));
  iEq0 = 1;
  b_st.site = &vk_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    if (iEq0 > 617) {
      emlrtDynamicBoundsCheckR2012b(618, 1, 617, &b_emlrtBCI, &st);
    }

    lambda->eqnonlin[idx] = SD->f3.TrialState.lambdasqp[iEq0 - 1];
    iEq0++;
  }

  for (idx = 0; idx < 176; idx++) {
    if (iEq0 > 617) {
      emlrtDynamicBoundsCheckR2012b(618, 1, 617, &b_emlrtBCI, &st);
    }

    lambda->ineqnonlin[idx] = SD->f3.TrialState.lambdasqp[iEq0 - 1];
    iEq0++;
  }

  b_st.site = &vk_emlrtRSI;
  b_st.site = &vk_emlrtRSI;
  if ((1 <= SD->f3.WorkingSet.sizes[3]) && (SD->f3.WorkingSet.sizes[3] >
       2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < iw0; idx++) {
    if ((SD->f3.WorkingSet.indexLB[idx] < 1) || (SD->f3.WorkingSet.indexLB[idx] >
         132)) {
      emlrtDynamicBoundsCheckR2012b(SD->f3.WorkingSet.indexLB[idx], 1, 132,
        &emlrtBCI, &st);
    }

    if (iEq0 > 617) {
      emlrtDynamicBoundsCheckR2012b(618, 1, 617, &b_emlrtBCI, &st);
    }

    lambda->lower[SD->f3.WorkingSet.indexLB[idx] - 1] =
      SD->f3.TrialState.lambdasqp[iEq0 - 1];
    iEq0++;
  }

  b_st.site = &vk_emlrtRSI;
  memcpy(&grad[0], &SD->f3.TrialState.grad[0], 132U * sizeof(real_T));
}

/* End of code generation (fmincon.c) */
