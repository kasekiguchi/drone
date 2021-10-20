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
#include "computeConstraints_.h"
#include "computeFiniteDifferences.h"
#include "computeObjective_.h"
#include "driver.h"
#include "eml_int_forloop_overflow_check.h"
#include "factoryConstruct.h"
#include "factoryConstruct1.h"
#include "factoryConstruct2.h"
#include "fillLambdaStruct.h"
#include "fminconMEX_Trackobjective.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "initActiveSet.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo b_emlrtRSI = { 1,   /* lineNo */
  "fmincon",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\eml\\fmincon.p"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 1,   /* lineNo */
  "checkLinearInputs",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+validate\\checkLinearInputs.p"/* pathName */
};

static emlrtRSInfo d_emlrtRSI = { 1,   /* lineNo */
  "checkNonlinearInputs",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+parseinput\\checkNonlinearInputs.p"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 1,   /* lineNo */
  "evalObjAndConstrAndDerivatives",    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\evalObjAndConstrAndDerivatives.p"/* pathName */
};

static emlrtRTEInfo g_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "fmincon",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\eml\\fmincon.p"/* pName */
};

static emlrtRTEInfo h_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "checkX0",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+validate\\checkX0.p"/* pName */
};

static emlrtRTEInfo q_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "factoryConstruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\factoryConstruct.p"/* pName */
};

static emlrtRTEInfo r_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "factoryConstruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\factoryConstruct.p"/* pName */
};

static emlrtRTEInfo s_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "factoryConstruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+CholManager\\factoryConstruct.p"/* pName */
};

static emlrtRTEInfo t_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "factoryConstruct",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\factoryConstruct.p"/* pName */
};

/* Function Definitions */
void fmincon(const emlrtStack *sp, const struct0_T fun_tunableEnvironment[1],
             const real_T x0[77], const struct0_T nonlcon_tunableEnvironment[1],
             real_T x[77], real_T *fval, real_T *exitflag, real_T
             *output_iterations, real_T *output_funcCount, char_T
             output_algorithm[3], real_T *output_constrviolation, real_T
             *output_stepsize, real_T *output_lssteplength, real_T
             *output_firstorderopt, struct3_T *lambda, real_T grad[77], real_T
             Hessian[5929])
{
  c_struct_T memspace;
  d_struct_T TrialState;
  e_struct_T FiniteDifferences;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  emxArray_real_T *fscales_cineq_constraint;
  emxArray_real_T *varargout_1;
  emxArray_real_T *varargout_2;
  f_struct_T FcnEvaluator;
  g_struct_T QRManager;
  h_struct_T CholManager;
  i_struct_T QPObjective;
  j_struct_T WorkingSet;
  k_struct_T MeritFunction;
  real_T b_TrialState[77];
  real_T absxk;
  real_T b_y;
  real_T scale;
  real_T t;
  int32_T b_i;
  int32_T i;
  int32_T idx;
  int32_T k;
  int32_T mConstrMax;
  int32_T mConstrMax_tmp;
  int32_T mNonlinEq;
  int32_T mNonlinIneq;
  int32_T maxDims;
  int32_T nVarMax;
  boolean_T varargin_1[77];
  boolean_T exitg1;
  boolean_T y;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  output_algorithm[0] = 's';
  output_algorithm[1] = 'q';
  output_algorithm[2] = 'p';
  st.site = &b_emlrtRSI;
  b_st.site = &c_emlrtRSI;
  for (i = 0; i < 77; i++) {
    absxk = x0[i];
    varargin_1[i] = ((!muDoubleScalarIsInf(absxk)) && (!muDoubleScalarIsNaN
      (absxk)));
  }

  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 77)) {
    if (!varargin_1[k]) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2018a(&b_st, &h_emlrtRTEI,
      "optim_codegen:common:InfNaNComplexDetected",
      "optim_codegen:common:InfNaNComplexDetected", 3, 4, 2, "x0");
  }

  emxInitStruct_struct_T(&b_st, &TrialState, &g_emlrtRTEI, true);
  emxInitStruct_struct_T1(&b_st, &FiniteDifferences, &g_emlrtRTEI, true);
  emxInit_real_T(&b_st, &varargout_2, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&b_st, &varargout_1, 2, &g_emlrtRTEI, true);
  st.site = &b_emlrtRSI;
  b_st.site = &d_emlrtRSI;
  c_st.site = &e_emlrtRSI;
  anon(&c_st, nonlcon_tunableEnvironment[0].H, nonlcon_tunableEnvironment[0].dt,
       nonlcon_tunableEnvironment[0].state_size, nonlcon_tunableEnvironment[0].
       Num, nonlcon_tunableEnvironment[0].X0, nonlcon_tunableEnvironment[0].
       model_param.K, x0, varargout_1, varargout_2);
  mNonlinIneq = varargout_1->size[0] * varargout_1->size[1];
  mNonlinEq = 5 * varargout_2->size[1];
  mConstrMax_tmp = mNonlinEq << 1;
  mConstrMax = (((mNonlinIneq + mNonlinEq) + mConstrMax_tmp) + mNonlinIneq) + 1;
  nVarMax = (mConstrMax_tmp + mNonlinIneq) + 78;
  maxDims = muIntScalarMax_sint32(nVarMax, mConstrMax);
  st.site = &b_emlrtRSI;
  factoryConstruct(&st, nVarMax, mConstrMax, mNonlinIneq, mNonlinEq, mNonlinIneq,
                   mNonlinEq, &TrialState);
  FcnEvaluator.mCineq = mNonlinIneq;
  FcnEvaluator.mCeq = mNonlinEq;
  FcnEvaluator.objfun.tunableEnvironment[0] = fun_tunableEnvironment[0];
  FcnEvaluator.nonlcon.tunableEnvironment[0] = nonlcon_tunableEnvironment[0];
  FcnEvaluator.nVar = 77;
  FcnEvaluator.NonFiniteSupport = true;
  FcnEvaluator.SpecifyObjectiveGradient = false;
  FcnEvaluator.SpecifyConstraintGradient = false;
  FcnEvaluator.ScaleProblem = false;
  FiniteDifferences.objfun.tunableEnvironment[0] = fun_tunableEnvironment[0];
  FiniteDifferences.nonlin.tunableEnvironment[0] = nonlcon_tunableEnvironment[0];
  FiniteDifferences.f_1 = 0.0;
  i = FiniteDifferences.cIneq_1->size[0];
  FiniteDifferences.cIneq_1->size[0] = mNonlinIneq;
  emxEnsureCapacity_real_T(sp, FiniteDifferences.cIneq_1, i, &q_emlrtRTEI);
  i = FiniteDifferences.cEq_1->size[0];
  FiniteDifferences.cEq_1->size[0] = mNonlinEq;
  emxEnsureCapacity_real_T(sp, FiniteDifferences.cEq_1, i, &q_emlrtRTEI);
  FiniteDifferences.f_2 = 0.0;
  i = FiniteDifferences.cIneq_2->size[0];
  FiniteDifferences.cIneq_2->size[0] = mNonlinIneq;
  emxEnsureCapacity_real_T(sp, FiniteDifferences.cIneq_2, i, &q_emlrtRTEI);
  i = FiniteDifferences.cEq_2->size[0];
  FiniteDifferences.cEq_2->size[0] = mNonlinEq;
  emxEnsureCapacity_real_T(sp, FiniteDifferences.cEq_2, i, &q_emlrtRTEI);
  FiniteDifferences.nVar = 77;
  FiniteDifferences.mIneq = mNonlinIneq;
  FiniteDifferences.mEq = mNonlinEq;
  FiniteDifferences.numEvals = 0;
  FiniteDifferences.SpecifyObjectiveGradient = false;
  FiniteDifferences.SpecifyConstraintGradient = false;
  FiniteDifferences.FiniteDifferenceType = 0;
  emxFree_real_T(&varargout_1);
  emxFree_real_T(&varargout_2);
  for (k = 0; k < 77; k++) {
    TrialState.xstarsqp[k] = x0[k];
    FiniteDifferences.hasUB[k] = false;
    FiniteDifferences.hasLB[k] = false;
  }

  emxInitStruct_struct_T2(sp, &QRManager, &g_emlrtRTEI, true);
  FiniteDifferences.hasBounds = false;
  QRManager.ldq = maxDims;
  i = QRManager.QR->size[0] * QRManager.QR->size[1];
  QRManager.QR->size[0] = maxDims;
  QRManager.QR->size[1] = maxDims;
  emxEnsureCapacity_real_T(sp, QRManager.QR, i, &r_emlrtRTEI);
  i = QRManager.Q->size[0] * QRManager.Q->size[1];
  QRManager.Q->size[0] = maxDims;
  QRManager.Q->size[1] = maxDims;
  emxEnsureCapacity_real_T(sp, QRManager.Q, i, &r_emlrtRTEI);
  mConstrMax_tmp = maxDims * maxDims;
  for (i = 0; i < mConstrMax_tmp; i++) {
    QRManager.Q->data[i] = 0.0;
  }

  i = QRManager.jpvt->size[0];
  QRManager.jpvt->size[0] = maxDims;
  emxEnsureCapacity_int32_T(sp, QRManager.jpvt, i, &g_emlrtRTEI);
  for (i = 0; i < maxDims; i++) {
    QRManager.jpvt->data[i] = 0;
  }

  emxInitStruct_struct_T3(sp, &CholManager, &g_emlrtRTEI, true);
  emxInitStruct_struct_T4(sp, &QPObjective, &g_emlrtRTEI, true);
  emxInitStruct_struct_T5(sp, &memspace, &g_emlrtRTEI, true);
  emxInit_real_T(sp, &fscales_cineq_constraint, 1, &g_emlrtRTEI, true);
  QRManager.mrows = 0;
  QRManager.ncols = 0;
  i = QRManager.tau->size[0];
  QRManager.tau->size[0] = muIntScalarMin_sint32(maxDims, maxDims);
  emxEnsureCapacity_real_T(sp, QRManager.tau, i, &r_emlrtRTEI);
  QRManager.minRowCol = 0;
  QRManager.usedPivoting = false;
  i = CholManager.FMat->size[0] * CholManager.FMat->size[1];
  CholManager.FMat->size[0] = maxDims;
  CholManager.FMat->size[1] = maxDims;
  emxEnsureCapacity_real_T(sp, CholManager.FMat, i, &s_emlrtRTEI);
  CholManager.ldm = maxDims;
  CholManager.ndims = 0;
  CholManager.info = 0;
  i = QPObjective.grad->size[0];
  QPObjective.grad->size[0] = nVarMax;
  emxEnsureCapacity_real_T(sp, QPObjective.grad, i, &t_emlrtRTEI);
  i = QPObjective.Hx->size[0];
  QPObjective.Hx->size[0] = nVarMax - 1;
  emxEnsureCapacity_real_T(sp, QPObjective.Hx, i, &t_emlrtRTEI);
  QPObjective.maxVar = nVarMax;
  QPObjective.beta = 0.0;
  QPObjective.rho = 0.0;
  QPObjective.prev_objtype = 3;
  QPObjective.prev_nvar = 0;
  QPObjective.prev_hasLinear = false;
  QPObjective.gammaScalar = 0.0;
  QPObjective.hasLinear = true;
  QPObjective.nvar = 77;
  QPObjective.objtype = 3;
  i = memspace.workspace_double->size[0] * memspace.workspace_double->size[1];
  memspace.workspace_double->size[0] = maxDims;
  memspace.workspace_double->size[1] = nVarMax;
  emxEnsureCapacity_real_T(sp, memspace.workspace_double, i, &g_emlrtRTEI);
  i = memspace.workspace_int->size[0];
  memspace.workspace_int->size[0] = maxDims;
  emxEnsureCapacity_int32_T(sp, memspace.workspace_int, i, &g_emlrtRTEI);
  i = memspace.workspace_sort->size[0];
  memspace.workspace_sort->size[0] = maxDims;
  emxEnsureCapacity_int32_T(sp, memspace.workspace_sort, i, &g_emlrtRTEI);
  i = fscales_cineq_constraint->size[0];
  fscales_cineq_constraint->size[0] = mNonlinIneq;
  emxEnsureCapacity_real_T(sp, fscales_cineq_constraint, i, &g_emlrtRTEI);
  for (i = 0; i < mNonlinIneq; i++) {
    fscales_cineq_constraint->data[i] = 1.0;
  }

  emxInitStruct_struct_T6(sp, &WorkingSet, &g_emlrtRTEI, true);
  st.site = &b_emlrtRSI;
  b_factoryConstruct(&st, mNonlinIneq, mNonlinEq, nVarMax, mConstrMax,
                     &WorkingSet);
  st.site = &b_emlrtRSI;
  memcpy(&b_TrialState[0], &TrialState.xstarsqp[0], 77U * sizeof(real_T));
  b_st.site = &h_emlrtRSI;
  computeObjective_(&b_st, FcnEvaluator.objfun.tunableEnvironment, b_TrialState,
                    &TrialState.sqpFval, &mConstrMax_tmp);
  if (mConstrMax_tmp == 1) {
    b_st.site = &h_emlrtRSI;
    mConstrMax_tmp = computeConstraints_(&b_st,
      FcnEvaluator.nonlcon.tunableEnvironment, mNonlinIneq, mNonlinEq,
      TrialState.xstarsqp, TrialState.cIneq, TrialState.iNonIneq0,
      TrialState.cEq, TrialState.iNonEq0);
  }

  if (mConstrMax_tmp != 1) {
    emlrtErrorWithMessageIdR2018a(sp, &g_emlrtRTEI,
      "optim_codegen:fmincon:UndefAtX0", "optim_codegen:fmincon:UndefAtX0", 0);
  }

  st.site = &b_emlrtRSI;
  computeFiniteDifferences(&st, &FiniteDifferences, TrialState.sqpFval,
    TrialState.cIneq, TrialState.iNonIneq0, TrialState.cEq, TrialState.iNonEq0,
    TrialState.xstarsqp, TrialState.grad, WorkingSet.Aineq, TrialState.iNonIneq0,
    WorkingSet.Aeq, TrialState.iNonEq0);
  TrialState.FunctionEvaluations = FiniteDifferences.numEvals + 1;
  st.site = &b_emlrtRSI;
  mConstrMax_tmp = TrialState.mNonlinEq;
  b_st.site = &eb_emlrtRSI;
  if ((1 <= mNonlinEq) && (mNonlinEq > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < mNonlinEq; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > TrialState.cEq->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, TrialState.cEq->size[0],
        &emlrtBCI, &st);
    }

    if ((idx + 1 < 1) || (idx + 1 > WorkingSet.beq->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, WorkingSet.beq->size[0],
        &emlrtBCI, &st);
    }

    WorkingSet.beq->data[idx] = -TrialState.cEq->data[idx];
    if ((idx + 1 < 1) || (idx + 1 > WorkingSet.beq->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, WorkingSet.beq->size[0],
        &emlrtBCI, &st);
    }

    if ((idx + 1 < 1) || (idx + 1 > WorkingSet.bwset->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, WorkingSet.bwset->size[0],
        &emlrtBCI, &st);
    }

    WorkingSet.bwset->data[idx] = WorkingSet.beq->data[idx];
  }

  nVarMax = WorkingSet.ldA * (mNonlinEq - TrialState.mNonlinEq) + 1;
  maxDims = nVarMax;
  b_st.site = &eb_emlrtRSI;
  if ((1 <= TrialState.mNonlinEq) && (TrialState.mNonlinEq > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < mConstrMax_tmp; idx++) {
    for (b_i = 0; b_i < 77; b_i++) {
      i = WorkingSet.Aeq->size[0] * WorkingSet.Aeq->size[1];
      mConstrMax = maxDims + b_i;
      if ((mConstrMax < 1) || (mConstrMax > i)) {
        emlrtDynamicBoundsCheckR2012b(mConstrMax, 1, i, &emlrtBCI, &st);
      }

      i = WorkingSet.ATwset->size[0] * WorkingSet.ATwset->size[1];
      k = nVarMax + b_i;
      if ((k < 1) || (k > i)) {
        emlrtDynamicBoundsCheckR2012b(k, 1, i, &emlrtBCI, &st);
      }

      WorkingSet.ATwset->data[k - 1] = WorkingSet.Aeq->data[mConstrMax - 1];
    }

    nVarMax += WorkingSet.ldA;
    maxDims += WorkingSet.ldA;
  }

  b_st.site = &eb_emlrtRSI;
  if ((1 <= mNonlinIneq) && (mNonlinIneq > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < mNonlinIneq; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > TrialState.cIneq->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, TrialState.cIneq->size[0],
        &emlrtBCI, &st);
    }

    i = WorkingSet.bineq->size[0] * WorkingSet.bineq->size[1];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &emlrtBCI, &st);
    }

    WorkingSet.bineq->data[idx] = -0.0;
  }

  st.site = &b_emlrtRSI;
  initActiveSet(&st, &WorkingSet);
  st.site = &b_emlrtRSI;
  c_factoryConstruct(&st, TrialState.sqpFval, TrialState.cIneq, mNonlinIneq,
                     TrialState.cEq, mNonlinEq, &MeritFunction);
  st.site = &b_emlrtRSI;
  driver(&st, &TrialState, &MeritFunction, &FcnEvaluator, &FiniteDifferences,
         &memspace, &WorkingSet, &QRManager, &CholManager, &QPObjective,
         fscales_cineq_constraint, Hessian);
  *fval = TrialState.sqpFval;
  mConstrMax_tmp = TrialState.sqpExitFlag;
  nVarMax = TrialState.sqpIterations;
  maxDims = TrialState.FunctionEvaluations;
  b_y = 0.0;
  scale = 3.3121686421112381E-170;
  emxFree_real_T(&fscales_cineq_constraint);
  emxFreeStruct_struct_T5(&memspace);
  emxFreeStruct_struct_T4(&QPObjective);
  emxFreeStruct_struct_T3(&CholManager);
  emxFreeStruct_struct_T2(&QRManager);
  emxFreeStruct_struct_T1(&FiniteDifferences);
  for (k = 0; k < 77; k++) {
    x[k] = TrialState.xstarsqp[k];
    absxk = muDoubleScalarAbs(TrialState.delta_x->data[k]);
    if (absxk > scale) {
      t = scale / absxk;
      b_y = b_y * t * t + 1.0;
      scale = absxk;
    } else {
      t = absxk / scale;
      b_y += t * t;
    }
  }

  *output_lssteplength = TrialState.steplength;
  st.site = &b_emlrtRSI;
  fillLambdaStruct(&st, mNonlinIneq, mNonlinEq, TrialState.lambdasqp,
                   WorkingSet.indexLB, WorkingSet.sizes, lambda->eqnonlin,
                   lambda->ineqnonlin, lambda->lower, lambda->upper);
  emxFreeStruct_struct_T6(&WorkingSet);
  for (k = 0; k < 77; k++) {
    grad[k] = TrialState.grad->data[k];
  }

  emxFreeStruct_struct_T(&TrialState);
  *exitflag = mConstrMax_tmp;
  *output_iterations = nVarMax;
  *output_funcCount = maxDims;
  *output_constrviolation = MeritFunction.nlpPrimalFeasError;
  *output_stepsize = scale * muDoubleScalarSqrt(b_y);
  *output_firstorderopt = MeritFunction.firstOrderOpt;
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (fmincon.c) */
