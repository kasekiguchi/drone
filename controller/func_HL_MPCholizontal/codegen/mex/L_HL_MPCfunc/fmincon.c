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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "checkLinearInputs.h"
#include "computeFiniteDifferences.h"
#include "driver.h"
#include "eml_int_forloop_overflow_check.h"
#include "evalObjAndConstrAndDerivatives.h"
#include "factoryConstruct.h"
#include "factoryConstruct1.h"
#include "factoryConstruct2.h"
#include "factoryConstruct3.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "setProblemType.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo b_emlrtRSI = { 1,   /* lineNo */
  "fmincon",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\eml\\fmincon.p"/* pathName */
};

static emlrtRSInfo k_emlrtRSI = { 1,   /* lineNo */
  "initActiveSet",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\initActiveSet.p"/* pathName */
};

static emlrtRSInfo fg_emlrtRSI = { 1,  /* lineNo */
  "fillLambdaStruct",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p"/* pathName */
};

static emlrtBCInfo emlrtBCI = { 1,     /* iFirst */
  110,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "fillLambdaStruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseoutput\\fillLambdaStruct.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { 1,   /* iFirst */
  305,                                 /* iLast */
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
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "initActiveSet",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\initActiveSet.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void fmincon(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const struct0_T
             fun_tunableEnvironment[1], const real_T x0[110], const real_T
             nonlcon_tunableEnvironment_f1_Q[64], const real_T
             b_nonlcon_tunableEnvironment_f1[64], const real_T
             nonlcon_tunableEnvironment_f1_R[4], const real_T
             c_nonlcon_tunableEnvironment_f1[88], const real_T
             d_nonlcon_tunableEnvironment_f1[8], real_T
             e_nonlcon_tunableEnvironment_f1, const real_T
             nonlcon_tunableEnvironment_f2_A[64], const real_T
             nonlcon_tunableEnvironment_f2_B[16], real_T x[110], real_T *fval,
             real_T *exitflag, real_T *output_iterations, real_T
             *output_funcCount, char_T output_algorithm[3], real_T
             *output_constrviolation, real_T *output_stepsize, real_T
             *output_lssteplength, real_T *output_firstorderopt, d_struct_T
             *lambda, real_T grad[110], real_T Hessian[12100])
{
  f_struct_T FcnEvaluator;
  real_T TrialState[110];
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
  SD->f2.TrialState.nVarMax = 307;
  SD->f2.TrialState.mNonlinIneq = 20;
  SD->f2.TrialState.mNonlinEq = 88;
  SD->f2.TrialState.mIneq = 20;
  SD->f2.TrialState.mEq = 88;
  SD->f2.TrialState.iNonIneq0 = 1;
  SD->f2.TrialState.iNonEq0 = 1;
  SD->f2.TrialState.sqpFval = 0.0;
  SD->f2.TrialState.sqpFval_old = 0.0;
  memset(&SD->f2.TrialState.xstarsqp_old[0], 0, 110U * sizeof(real_T));
  memset(&SD->f2.TrialState.cIneq[0], 0, 20U * sizeof(real_T));
  memset(&SD->f2.TrialState.cIneq_old[0], 0, 20U * sizeof(real_T));
  memset(&SD->f2.TrialState.cEq[0], 0, 88U * sizeof(real_T));
  memset(&SD->f2.TrialState.cEq_old[0], 0, 88U * sizeof(real_T));
  memset(&SD->f2.TrialState.grad[0], 0, 307U * sizeof(real_T));
  memset(&SD->f2.TrialState.grad_old[0], 0, 307U * sizeof(real_T));
  SD->f2.TrialState.FunctionEvaluations = 0;
  SD->f2.TrialState.sqpIterations = 0;
  SD->f2.TrialState.sqpExitFlag = 0;
  memset(&SD->f2.TrialState.lambdasqp[0], 0, 305U * sizeof(real_T));
  memset(&SD->f2.TrialState.lambdasqp_old[0], 0, 305U * sizeof(real_T));
  SD->f2.TrialState.steplength = 1.0;
  memset(&SD->f2.TrialState.delta_x[0], 0, 307U * sizeof(real_T));
  memset(&SD->f2.TrialState.socDirection[0], 0, 307U * sizeof(real_T));
  memset(&SD->f2.TrialState.lambda_old[0], 0, 305U * sizeof(real_T));
  memset(&SD->f2.TrialState.workingset_old[0], 0, 305U * sizeof(int32_T));
  memset(&SD->f2.TrialState.JacCineqTrans_old[0], 0, 6140U * sizeof(real_T));
  memset(&SD->f2.TrialState.JacCeqTrans_old[0], 0, 27016U * sizeof(real_T));
  memset(&SD->f2.TrialState.gradLag[0], 0, 307U * sizeof(real_T));
  memset(&SD->f2.TrialState.delta_gradLag[0], 0, 307U * sizeof(real_T));
  memset(&SD->f2.TrialState.xstar[0], 0, 307U * sizeof(real_T));
  SD->f2.TrialState.fstar = 0.0;
  SD->f2.TrialState.firstorderopt = 0.0;
  memset(&SD->f2.TrialState.lambda[0], 0, 305U * sizeof(real_T));
  SD->f2.TrialState.state = 0;
  SD->f2.TrialState.maxConstr = 0.0;
  SD->f2.TrialState.iterations = 0;
  memset(&SD->f2.TrialState.searchDir[0], 0, 307U * sizeof(real_T));
  memcpy(&SD->f2.TrialState.xstarsqp[0], &x0[0], 110U * sizeof(real_T));
  FcnEvaluator.objfun.tunableEnvironment[0] = fun_tunableEnvironment[0];
  memcpy(&FcnEvaluator.nonlcon.tunableEnvironment.f1.Q[0],
         &nonlcon_tunableEnvironment_f1_Q[0], 64U * sizeof(real_T));
  memcpy(&FcnEvaluator.nonlcon.tunableEnvironment.f1.Qf[0],
         &b_nonlcon_tunableEnvironment_f1[0], 64U * sizeof(real_T));
  FcnEvaluator.nonlcon.tunableEnvironment.f1.R[0] =
    nonlcon_tunableEnvironment_f1_R[0];
  FcnEvaluator.nonlcon.tunableEnvironment.f1.R[1] =
    nonlcon_tunableEnvironment_f1_R[1];
  FcnEvaluator.nonlcon.tunableEnvironment.f1.R[2] =
    nonlcon_tunableEnvironment_f1_R[2];
  FcnEvaluator.nonlcon.tunableEnvironment.f1.R[3] =
    nonlcon_tunableEnvironment_f1_R[3];
  memcpy(&FcnEvaluator.nonlcon.tunableEnvironment.f1.Xr[0],
         &c_nonlcon_tunableEnvironment_f1[0], 88U * sizeof(real_T));
  memcpy(&FcnEvaluator.nonlcon.tunableEnvironment.f1.X0[0],
         &d_nonlcon_tunableEnvironment_f1[0], 8U * sizeof(real_T));
  FcnEvaluator.nonlcon.tunableEnvironment.f1.Slew =
    e_nonlcon_tunableEnvironment_f1;
  memcpy(&FcnEvaluator.nonlcon.tunableEnvironment.f2.A[0],
         &nonlcon_tunableEnvironment_f2_A[0], 64U * sizeof(real_T));
  memcpy(&FcnEvaluator.nonlcon.tunableEnvironment.f2.B[0],
         &nonlcon_tunableEnvironment_f2_B[0], 16U * sizeof(real_T));
  FcnEvaluator.nVar = 110;
  FcnEvaluator.mCineq = 20;
  FcnEvaluator.mCeq = 88;
  FcnEvaluator.NonFiniteSupport = true;
  FcnEvaluator.SpecifyObjectiveGradient = false;
  FcnEvaluator.SpecifyConstraintGradient = false;
  FcnEvaluator.ScaleProblem = false;
  d_factoryConstruct(&SD->f2.WorkingSet);
  memcpy(&TrialState[0], &SD->f2.TrialState.xstarsqp[0], 110U * sizeof(real_T));
  st.site = &b_emlrtRSI;
  evalObjAndConstrAndDerivatives(&st, FcnEvaluator.objfun.tunableEnvironment,
    FcnEvaluator.nonlcon.tunableEnvironment.f1.X0,
    e_nonlcon_tunableEnvironment_f1,
    FcnEvaluator.nonlcon.tunableEnvironment.f2.A,
    FcnEvaluator.nonlcon.tunableEnvironment.f2.B, TrialState,
    SD->f2.TrialState.cIneq, SD->f2.TrialState.cEq, &SD->f2.TrialState.sqpFval,
    &iw0);
  if (iw0 != 1) {
    emlrtErrorWithMessageIdR2018a(sp, &emlrtRTEI,
      "optim_codegen:fmincon:UndefAtX0", "optim_codegen:fmincon:UndefAtX0", 0);
  }

  factoryConstruct(fun_tunableEnvironment, nonlcon_tunableEnvironment_f1_Q,
                   b_nonlcon_tunableEnvironment_f1,
                   nonlcon_tunableEnvironment_f1_R,
                   c_nonlcon_tunableEnvironment_f1,
                   d_nonlcon_tunableEnvironment_f1,
                   e_nonlcon_tunableEnvironment_f1,
                   nonlcon_tunableEnvironment_f2_A,
                   nonlcon_tunableEnvironment_f2_B, &FiniteDifferences);
  st.site = &b_emlrtRSI;
  computeFiniteDifferences(&FiniteDifferences, SD->f2.TrialState.sqpFval,
    SD->f2.TrialState.cIneq, SD->f2.TrialState.cEq, SD->f2.TrialState.xstarsqp,
    SD->f2.TrialState.grad, SD->f2.WorkingSet.Aineq, SD->f2.WorkingSet.Aeq);
  SD->f2.TrialState.FunctionEvaluations = FiniteDifferences.numEvals + 1;
  st.site = &b_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    SD->f2.WorkingSet.beq[idx] = -SD->f2.TrialState.cEq[idx];
    SD->f2.WorkingSet.bwset[idx] = SD->f2.WorkingSet.beq[idx];
  }

  iw0 = 1;
  iEq0 = 1;
  b_st.site = &h_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    for (i = 0; i < 110; i++) {
      b_i = iw0 + i;
      if ((b_i < 1) || (b_i > 93635)) {
        emlrtDynamicBoundsCheckR2012b(b_i, 1, 93635, &c_emlrtBCI, &st);
      }

      idx_local = iEq0 + i;
      if ((idx_local < 1) || (idx_local > 27016)) {
        emlrtDynamicBoundsCheckR2012b(idx_local, 1, 27016, &d_emlrtBCI, &st);
      }

      SD->f2.WorkingSet.ATwset[b_i - 1] = SD->f2.WorkingSet.Aeq[idx_local - 1];
    }

    iw0 += 307;
    iEq0 += 307;
  }

  for (idx = 0; idx < 20; idx++) {
    SD->f2.WorkingSet.bineq[idx] = -SD->f2.TrialState.cIneq[idx];
  }

  st.site = &b_emlrtRSI;
  b_st.site = &k_emlrtRSI;
  setProblemType(&b_st, &SD->f2.WorkingSet, 3);
  iw0 = SD->f2.WorkingSet.isActiveIdx[2];
  b_st.site = &k_emlrtRSI;
  for (idx = iw0; idx < 306; idx++) {
    if (idx < 1) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, 305, &e_emlrtBCI, &st);
    }

    SD->f2.WorkingSet.isActiveConstr[idx - 1] = false;
  }

  SD->f2.WorkingSet.nWConstr[0] = 0;
  SD->f2.WorkingSet.nWConstr[1] = 88;
  SD->f2.WorkingSet.nWConstr[2] = 0;
  SD->f2.WorkingSet.nWConstr[3] = 0;
  SD->f2.WorkingSet.nWConstr[4] = 0;
  SD->f2.WorkingSet.nActiveConstr = 88;
  b_st.site = &k_emlrtRSI;
  b_st.site = &k_emlrtRSI;
  b_i = SD->f2.WorkingSet.nVar - 1;
  for (idx_local = 0; idx_local < 88; idx_local++) {
    SD->f2.WorkingSet.Wid[idx_local] = 2;
    SD->f2.WorkingSet.Wlocalidx[idx_local] = idx_local + 1;
    SD->f2.WorkingSet.isActiveConstr[idx_local] = true;
    iw0 = 307 * idx_local;
    iEq0 = 307 * idx_local;
    for (i = 0; i <= b_i; i++) {
      SD->f2.WorkingSet.ATwset[iEq0 + i] = SD->f2.WorkingSet.Aeq[iw0 + i];
    }

    SD->f2.WorkingSet.bwset[idx_local] = SD->f2.WorkingSet.beq[idx_local];
  }

  MeritFunction.initFval = SD->f2.TrialState.sqpFval;
  MeritFunction.penaltyParam = 1.0;
  MeritFunction.threshold = 0.0001;
  MeritFunction.nPenaltyDecreases = 0;
  MeritFunction.linearizedConstrViol = 0.0;
  normResid = 0.0;
  for (iw0 = 0; iw0 < 88; iw0++) {
    normResid += muDoubleScalarAbs(SD->f2.TrialState.cEq[iw0]);
  }

  MeritFunction.initConstrViolationEq = normResid;
  normResid = 0.0;
  for (idx = 0; idx < 20; idx++) {
    if (SD->f2.TrialState.cIneq[idx] > 0.0) {
      normResid += SD->f2.TrialState.cIneq[idx];
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
  memset(&s.grad[0], 0, 307U * sizeof(real_T));
  memset(&s.Hx[0], 0, 306U * sizeof(real_T));
  s.hasLinear = true;
  s.nvar = 110;
  s.maxVar = 307;
  s.beta = 0.0;
  s.rho = 0.0;
  s.objtype = 3;
  s.prev_objtype = 3;
  s.prev_nvar = 0;
  s.prev_hasLinear = false;
  s.gammaScalar = 0.0;
  b_factoryConstruct(&SD->f2.QRManager);
  c_factoryConstruct(&SD->f2.CholManager);
  st.site = &b_emlrtRSI;
  driver(SD, &st, &SD->f2.TrialState, &MeritFunction, &FcnEvaluator,
         &FiniteDifferences, &SD->f2.memspace, &SD->f2.WorkingSet,
         &SD->f2.QRManager, &SD->f2.CholManager, &s, Hessian);
  *fval = SD->f2.TrialState.sqpFval;
  *exitflag = SD->f2.TrialState.sqpExitFlag;
  *output_iterations = SD->f2.TrialState.sqpIterations;
  *output_funcCount = SD->f2.TrialState.FunctionEvaluations;
  *output_constrviolation = MeritFunction.nlpPrimalFeasError;
  normResid = 0.0;
  scale = 3.3121686421112381E-170;
  for (iw0 = 0; iw0 < 110; iw0++) {
    x[iw0] = SD->f2.TrialState.xstarsqp[iw0];
    absxk = muDoubleScalarAbs(SD->f2.TrialState.delta_x[iw0]);
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
  *output_lssteplength = SD->f2.TrialState.steplength;
  *output_firstorderopt = MeritFunction.firstOrderOpt;
  st.site = &b_emlrtRSI;
  iw0 = SD->f2.WorkingSet.sizes[3];
  memset(&lambda->eqnonlin[0], 0, 88U * sizeof(real_T));
  memset(&lambda->ineqnonlin[0], 0, 20U * sizeof(real_T));
  memset(&lambda->lower[0], 0, 110U * sizeof(real_T));
  memset(&lambda->upper[0], 0, 110U * sizeof(real_T));
  iEq0 = 1;
  b_st.site = &fg_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    if (iEq0 > 305) {
      emlrtDynamicBoundsCheckR2012b(306, 1, 305, &b_emlrtBCI, &st);
    }

    lambda->eqnonlin[idx] = SD->f2.TrialState.lambdasqp[iEq0 - 1];
    iEq0++;
  }

  for (idx = 0; idx < 20; idx++) {
    if (iEq0 > 305) {
      emlrtDynamicBoundsCheckR2012b(306, 1, 305, &b_emlrtBCI, &st);
    }

    lambda->ineqnonlin[idx] = SD->f2.TrialState.lambdasqp[iEq0 - 1];
    iEq0++;
  }

  b_st.site = &fg_emlrtRSI;
  b_st.site = &fg_emlrtRSI;
  if ((1 <= SD->f2.WorkingSet.sizes[3]) && (SD->f2.WorkingSet.sizes[3] >
       2147483646)) {
    c_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < iw0; idx++) {
    if ((SD->f2.WorkingSet.indexLB[idx] < 1) || (SD->f2.WorkingSet.indexLB[idx] >
         110)) {
      emlrtDynamicBoundsCheckR2012b(SD->f2.WorkingSet.indexLB[idx], 1, 110,
        &emlrtBCI, &st);
    }

    if (iEq0 > 305) {
      emlrtDynamicBoundsCheckR2012b(306, 1, 305, &b_emlrtBCI, &st);
    }

    lambda->lower[SD->f2.WorkingSet.indexLB[idx] - 1] =
      SD->f2.TrialState.lambdasqp[iEq0 - 1];
    iEq0++;
  }

  b_st.site = &fg_emlrtRSI;
  memcpy(&grad[0], &SD->f2.TrialState.grad[0], 110U * sizeof(real_T));
}

/* End of code generation (fmincon.c) */
