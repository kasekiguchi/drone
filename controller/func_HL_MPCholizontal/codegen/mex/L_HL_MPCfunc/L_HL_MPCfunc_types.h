/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * L_HL_MPCfunc_types.h
 *
 * Code generation for function 'L_HL_MPCfunc_types'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_e_struct_T
#define typedef_e_struct_T

typedef struct {
  int32_T nVarMax;
  int32_T mNonlinIneq;
  int32_T mNonlinEq;
  int32_T mIneq;
  int32_T mEq;
  int32_T iNonIneq0;
  int32_T iNonEq0;
  real_T sqpFval;
  real_T sqpFval_old;
  real_T xstarsqp[110];
  real_T xstarsqp_old[110];
  real_T cIneq[20];
  real_T cIneq_old[20];
  real_T cEq[88];
  real_T cEq_old[88];
  real_T grad[307];
  real_T grad_old[307];
  int32_T FunctionEvaluations;
  int32_T sqpIterations;
  int32_T sqpExitFlag;
  real_T lambdasqp[305];
  real_T lambdasqp_old[305];
  real_T steplength;
  real_T delta_x[307];
  real_T socDirection[307];
  real_T lambda_old[305];
  int32_T workingset_old[305];
  real_T JacCineqTrans_old[6140];
  real_T JacCeqTrans_old[27016];
  real_T gradLag[307];
  real_T delta_gradLag[307];
  real_T xstar[307];
  real_T fstar;
  real_T firstorderopt;
  real_T lambda[305];
  int32_T state;
  real_T maxConstr;
  int32_T iterations;
  real_T searchDir[307];
} e_struct_T;

#endif                                 /*typedef_e_struct_T*/

#ifndef typedef_b_struct_T
#define typedef_b_struct_T

typedef struct {
  real_T workspace_double[94249];
  int32_T workspace_int[307];
  int32_T workspace_sort[307];
} b_struct_T;

#endif                                 /*typedef_b_struct_T*/

#ifndef typedef_g_struct_T
#define typedef_g_struct_T

typedef struct {
  int32_T mConstr;
  int32_T mConstrOrig;
  int32_T mConstrMax;
  int32_T nVar;
  int32_T nVarOrig;
  int32_T nVarMax;
  int32_T ldA;
  real_T Aineq[6140];
  real_T bineq[20];
  real_T Aeq[27016];
  real_T beq[88];
  real_T lb[307];
  real_T ub[307];
  int32_T indexLB[307];
  int32_T indexUB[307];
  int32_T indexFixed[307];
  int32_T mEqRemoved;
  int32_T indexEqRemoved[88];
  real_T ATwset[93635];
  real_T bwset[305];
  int32_T nActiveConstr;
  real_T maxConstrWorkspace[305];
  int32_T sizes[5];
  int32_T sizesNormal[5];
  int32_T sizesPhaseOne[5];
  int32_T sizesRegularized[5];
  int32_T sizesRegPhaseOne[5];
  int32_T isActiveIdx[6];
  int32_T isActiveIdxNormal[6];
  int32_T isActiveIdxPhaseOne[6];
  int32_T isActiveIdxRegularized[6];
  int32_T isActiveIdxRegPhaseOne[6];
  boolean_T isActiveConstr[305];
  int32_T Wid[305];
  int32_T Wlocalidx[305];
  int32_T nWConstr[5];
  int32_T probType;
  real_T SLACK0;
} g_struct_T;

#endif                                 /*typedef_g_struct_T*/

#ifndef typedef_k_struct_T
#define typedef_k_struct_T

typedef struct {
  int32_T ldq;
  real_T QR[94249];
  real_T Q[94249];
  int32_T jpvt[307];
  int32_T mrows;
  int32_T ncols;
  real_T tau[307];
  int32_T minRowCol;
  boolean_T usedPivoting;
} k_struct_T;

#endif                                 /*typedef_k_struct_T*/

#ifndef typedef_l_struct_T
#define typedef_l_struct_T

typedef struct {
  real_T FMat[94249];
  int32_T ldm;
  int32_T ndims;
  int32_T info;
} l_struct_T;

#endif                                 /*typedef_l_struct_T*/

#ifndef typedef_L_HL_MPCfuncStackData
#define typedef_L_HL_MPCfuncStackData

typedef struct {
  struct {
    real_T dv[94249];
  } f0;

  struct {
    e_struct_T TrialState;
  } f1;

  struct {
    k_struct_T QRManager;
    g_struct_T WorkingSet;
    b_struct_T memspace;
    l_struct_T CholManager;
    e_struct_T TrialState;
  } f2;
} L_HL_MPCfuncStackData;

#endif                                 /*typedef_L_HL_MPCfuncStackData*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  real_T Q[64];
  real_T Qf[64];
  real_T R[4];
  real_T Xr[88];
  real_T X0[8];
  real_T Slew;
} struct0_T;

#endif                                 /*typedef_struct0_T*/

#ifndef typedef_c_coder_internal_anonymous_func
#define typedef_c_coder_internal_anonymous_func

typedef struct {
  struct0_T tunableEnvironment[1];
} c_coder_internal_anonymous_func;

#endif                                 /*typedef_c_coder_internal_anonymous_func*/

#ifndef typedef_c_struct_T
#define typedef_c_struct_T

typedef struct {
  char_T SolverName[7];
  int32_T MaxIterations;
  real_T StepTolerance;
  real_T OptimalityTolerance;
  real_T ConstraintTolerance;
  real_T ObjectiveLimit;
  real_T PricingTolerance;
  real_T ConstrRelTolFactor;
  real_T ProbRelTolFactor;
  boolean_T RemainFeasible;
  boolean_T IterDisplayQP;
} c_struct_T;

#endif                                 /*typedef_c_struct_T*/

#ifndef typedef_struct1_T
#define typedef_struct1_T

typedef struct {
  real_T A[64];
  real_T B[16];
} struct1_T;

#endif                                 /*typedef_struct1_T*/

#ifndef typedef_cell_1
#define typedef_cell_1

typedef struct {
  struct0_T f1;
  struct1_T f2;
} cell_1;

#endif                                 /*typedef_cell_1*/

#ifndef typedef_d_coder_internal_anonymous_func
#define typedef_d_coder_internal_anonymous_func

typedef struct {
  cell_1 tunableEnvironment;
} d_coder_internal_anonymous_func;

#endif                                 /*typedef_d_coder_internal_anonymous_func*/

#ifndef typedef_d_struct_T
#define typedef_d_struct_T

typedef struct {
  real_T eqnonlin[88];
  real_T ineqnonlin[20];
  real_T lower[110];
  real_T upper[110];
} d_struct_T;

#endif                                 /*typedef_d_struct_T*/

#ifndef typedef_f_struct_T
#define typedef_f_struct_T

typedef struct {
  c_coder_internal_anonymous_func objfun;
  d_coder_internal_anonymous_func nonlcon;
  int32_T nVar;
  int32_T mCineq;
  int32_T mCeq;
  boolean_T NonFiniteSupport;
  boolean_T SpecifyObjectiveGradient;
  boolean_T SpecifyConstraintGradient;
  boolean_T ScaleProblem;
} f_struct_T;

#endif                                 /*typedef_f_struct_T*/

#ifndef typedef_h_struct_T
#define typedef_h_struct_T

typedef struct {
  c_coder_internal_anonymous_func objfun;
  d_coder_internal_anonymous_func nonlin;
  real_T f_1;
  real_T cIneq_1[20];
  real_T cEq_1[88];
  real_T f_2;
  real_T cIneq_2[20];
  real_T cEq_2[88];
  int32_T nVar;
  int32_T mIneq;
  int32_T mEq;
  int32_T numEvals;
  boolean_T SpecifyObjectiveGradient;
  boolean_T SpecifyConstraintGradient;
  boolean_T hasLB[110];
  boolean_T hasUB[110];
  boolean_T hasBounds;
  int32_T FiniteDifferenceType;
} h_struct_T;

#endif                                 /*typedef_h_struct_T*/

#ifndef typedef_i_struct_T
#define typedef_i_struct_T

typedef struct {
  real_T penaltyParam;
  real_T threshold;
  int32_T nPenaltyDecreases;
  real_T linearizedConstrViol;
  real_T initFval;
  real_T initConstrViolationEq;
  real_T initConstrViolationIneq;
  real_T phi;
  real_T phiPrimePlus;
  real_T phiFullStep;
  real_T feasRelativeFactor;
  real_T nlpPrimalFeasError;
  real_T nlpDualFeasError;
  real_T nlpComplError;
  real_T firstOrderOpt;
  boolean_T hasObjective;
} i_struct_T;

#endif                                 /*typedef_i_struct_T*/

#ifndef typedef_j_struct_T
#define typedef_j_struct_T

typedef struct {
  real_T grad[307];
  real_T Hx[306];
  boolean_T hasLinear;
  int32_T nvar;
  int32_T maxVar;
  real_T beta;
  real_T rho;
  int32_T objtype;
  int32_T prev_objtype;
  int32_T prev_nvar;
  boolean_T prev_hasLinear;
  real_T gammaScalar;
} j_struct_T;

#endif                                 /*typedef_j_struct_T*/

#ifndef typedef_struct_T
#define typedef_struct_T

typedef struct {
  boolean_T gradOK;
  boolean_T fevalOK;
  boolean_T done;
  boolean_T stepAccepted;
  boolean_T failedLineSearch;
  int32_T stepType;
} struct_T;

#endif                                 /*typedef_struct_T*/

/* End of code generation (L_HL_MPCfunc_types.h) */
