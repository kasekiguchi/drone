/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * F_HL_MPCfunc_types.h
 *
 * Code generation for function 'F_HL_MPCfunc_types'
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
  real_T xstarsqp[132];
  real_T xstarsqp_old[132];
  real_T cIneq[176];
  real_T cIneq_old[176];
  real_T cEq[88];
  real_T cEq_old[88];
  real_T grad[485];
  real_T grad_old[485];
  int32_T FunctionEvaluations;
  int32_T sqpIterations;
  int32_T sqpExitFlag;
  real_T lambdasqp[617];
  real_T lambdasqp_old[617];
  real_T steplength;
  real_T delta_x[485];
  real_T socDirection[485];
  real_T lambda_old[617];
  int32_T workingset_old[617];
  real_T JacCineqTrans_old[85360];
  real_T JacCeqTrans_old[42680];
  real_T gradLag[485];
  real_T delta_gradLag[485];
  real_T xstar[485];
  real_T fstar;
  real_T firstorderopt;
  real_T lambda[617];
  int32_T state;
  real_T maxConstr;
  int32_T iterations;
  real_T searchDir[485];
} e_struct_T;

#endif                                 /*typedef_e_struct_T*/

#ifndef typedef_b_struct_T
#define typedef_b_struct_T

typedef struct {
  real_T workspace_double[299245];
  int32_T workspace_int[617];
  int32_T workspace_sort[617];
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
  real_T Aineq[85360];
  real_T bineq[176];
  real_T Aeq[42680];
  real_T beq[88];
  real_T lb[485];
  real_T ub[485];
  int32_T indexLB[485];
  int32_T indexUB[485];
  int32_T indexFixed[485];
  int32_T mEqRemoved;
  int32_T indexEqRemoved[88];
  real_T ATwset[299245];
  real_T bwset[617];
  int32_T nActiveConstr;
  real_T maxConstrWorkspace[617];
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
  boolean_T isActiveConstr[617];
  int32_T Wid[617];
  int32_T Wlocalidx[617];
  int32_T nWConstr[5];
  int32_T probType;
  real_T SLACK0;
} g_struct_T;

#endif                                 /*typedef_g_struct_T*/

#ifndef typedef_k_struct_T
#define typedef_k_struct_T

typedef struct {
  int32_T ldq;
  real_T QR[380689];
  real_T Q[380689];
  int32_T jpvt[617];
  int32_T mrows;
  int32_T ncols;
  real_T tau[617];
  int32_T minRowCol;
  boolean_T usedPivoting;
} k_struct_T;

#endif                                 /*typedef_k_struct_T*/

#ifndef typedef_l_struct_T
#define typedef_l_struct_T

typedef struct {
  real_T FMat[380689];
  int32_T ldm;
  int32_T ndims;
  int32_T info;
} l_struct_T;

#endif                                 /*typedef_l_struct_T*/

#ifndef typedef_F_HL_MPCfuncStackData
#define typedef_F_HL_MPCfuncStackData

typedef struct {
  union
  {
    struct {
      real_T gcineq[23232];
    } f0;

    struct {
      real_T dv[299245];
    } f1;
  } u1;

  struct {
    e_struct_T TrialState;
  } f2;

  struct {
    k_struct_T QRManager;
    g_struct_T WorkingSet;
    l_struct_T CholManager;
    b_struct_T memspace;
    e_struct_T TrialState;
  } f3;

  struct {
    real_T unusedU4[17424];
  } f4;
} F_HL_MPCfuncStackData;

#endif                                 /*typedef_F_HL_MPCfuncStackData*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  real_T H;
  real_T dt;
  real_T N;
  real_T P[14];
  real_T F1[2];
  real_T F2[4];
  real_T F3[4];
  real_T F4[2];
  real_T input_size;
  real_T state_size;
  real_T total_size;
  real_T Num;
  real_T V[4];
  real_T Qm;
  real_T Qmf;
  real_T Qt;
  real_T Qtf;
  real_T R[4];
  real_T W_s;
  real_T W_r;
  real_T Slew;
  real_T D_lim[2];
  real_T r_limit[2];
  real_T A[64];
  real_T B[16];
  real_T P_chips[38];
  real_T wall_width_y[4];
  real_T wall_width_x[4];
  real_T sectionpoint[6];
  real_T sectionnumber;
  real_T Section_change[4];
  real_T Sectionconect[22];
  real_T wall_width_xx[22];
  real_T wall_width_yy[22];
  real_T Cdis[11];
  real_T Line_Y[11];
  real_T S_front[4];
  real_T front[22];
  real_T behind[22];
  real_T X0[8];
  real_T Xd[20];
  real_T frontSN;
  real_T behindSN;
  real_T FLD[11];
  real_T BLD;
  real_T agent;
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

#ifndef typedef_d_struct_T
#define typedef_d_struct_T

typedef struct {
  real_T eqnonlin[88];
  real_T ineqnonlin[176];
  real_T lower[132];
  real_T upper[132];
} d_struct_T;

#endif                                 /*typedef_d_struct_T*/

#ifndef struct_emxArray_int8_T
#define struct_emxArray_int8_T

struct emxArray_int8_T
{
  int8_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_int8_T*/

#ifndef typedef_emxArray_int8_T
#define typedef_emxArray_int8_T

typedef struct emxArray_int8_T emxArray_int8_T;

#endif                                 /*typedef_emxArray_int8_T*/

#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

#ifndef typedef_f_struct_T
#define typedef_f_struct_T

typedef struct {
  c_coder_internal_anonymous_func objfun;
  c_coder_internal_anonymous_func nonlcon;
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
  c_coder_internal_anonymous_func nonlin;
  real_T f_1;
  real_T cIneq_1[176];
  real_T cEq_1[88];
  real_T f_2;
  real_T cIneq_2[176];
  real_T cEq_2[88];
  int32_T nVar;
  int32_T mIneq;
  int32_T mEq;
  int32_T numEvals;
  boolean_T SpecifyObjectiveGradient;
  boolean_T SpecifyConstraintGradient;
  boolean_T hasLB[132];
  boolean_T hasUB[132];
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
  real_T grad[485];
  real_T Hx[484];
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

/* End of code generation (F_HL_MPCfunc_types.h) */
