/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminconMEX_Trackobjective_types.h
 *
 * Code generation for function 'fminconMEX_Trackobjective'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"
#include <stddef.h>

/* Type Definitions */
#ifndef typedef_struct1_T
#define typedef_struct1_T

typedef struct {
  real_T K;
} struct1_T;

#endif                                 /*typedef_struct1_T*/

#ifndef typedef_struct2_T
#define typedef_struct2_T

typedef struct {
  real_T iterations;
  real_T funcCount;
  char_T algorithm[3];
  real_T constrviolation;
  real_T stepsize;
  real_T lssteplength;
  real_T firstorderopt;
} struct2_T;

#endif                                 /*typedef_struct2_T*/

#ifndef struct_emxArray_real_T_1x629
#define struct_emxArray_real_T_1x629

struct emxArray_real_T_1x629
{
  real_T data[629];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_real_T_1x629*/

#ifndef typedef_emxArray_real_T_1x629
#define typedef_emxArray_real_T_1x629

typedef struct emxArray_real_T_1x629 emxArray_real_T_1x629;

#endif                                 /*typedef_emxArray_real_T_1x629*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  real_T H;
  real_T dt;
  real_T input_size;
  real_T state_size;
  real_T total_size;
  real_T Num;
  real_T Q[16];
  real_T R[4];
  real_T Qf[16];
  real_T T[100];
  real_T Xr[44];
  emxArray_real_T_1x629 dis;
  emxArray_real_T_1x629 alpha;
  emxArray_real_T_1x629 phi;
  real_T X0[4];
  struct1_T model_param;
} struct0_T;

#endif                                 /*typedef_struct0_T*/

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

#ifndef struct_emxArray_int32_T
#define struct_emxArray_int32_T

struct emxArray_int32_T
{
  int32_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_int32_T*/

#ifndef typedef_emxArray_int32_T
#define typedef_emxArray_int32_T

typedef struct emxArray_int32_T emxArray_int32_T;

#endif                                 /*typedef_emxArray_int32_T*/

#ifndef typedef_anonymous_function
#define typedef_anonymous_function

typedef struct {
  struct0_T tunableEnvironment[1];
} anonymous_function;

#endif                                 /*typedef_anonymous_function*/

#ifndef typedef_c_struct_T
#define typedef_c_struct_T

typedef struct {
  emxArray_real_T *workspace_double;
  emxArray_int32_T *workspace_int;
  emxArray_int32_T *workspace_sort;
} c_struct_T;

#endif                                 /*typedef_c_struct_T*/

#ifndef struct_emxArray_boolean_T
#define struct_emxArray_boolean_T

struct emxArray_boolean_T
{
  boolean_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_boolean_T*/

#ifndef typedef_emxArray_boolean_T
#define typedef_emxArray_boolean_T

typedef struct emxArray_boolean_T emxArray_boolean_T;

#endif                                 /*typedef_emxArray_boolean_T*/

#ifndef struct_emxArray_ptrdiff_t
#define struct_emxArray_ptrdiff_t

struct emxArray_ptrdiff_t
{
  ptrdiff_t *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_ptrdiff_t*/

#ifndef typedef_emxArray_ptrdiff_t
#define typedef_emxArray_ptrdiff_t

typedef struct emxArray_ptrdiff_t emxArray_ptrdiff_t;

#endif                                 /*typedef_emxArray_ptrdiff_t*/

#ifndef typedef_struct3_T
#define typedef_struct3_T

typedef struct {
  emxArray_real_T *eqnonlin;
  emxArray_real_T *ineqnonlin;
  real_T lower[66];
  real_T upper[66];
} struct3_T;

#endif                                 /*typedef_struct3_T*/

#ifndef typedef_d_struct_T
#define typedef_d_struct_T

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
  real_T xstarsqp[66];
  real_T xstarsqp_old[66];
  emxArray_real_T *cIneq;
  emxArray_real_T *cIneq_old;
  emxArray_real_T *cEq;
  emxArray_real_T *cEq_old;
  emxArray_real_T *grad;
  emxArray_real_T *grad_old;
  int32_T FunctionEvaluations;
  int32_T sqpIterations;
  int32_T sqpExitFlag;
  emxArray_real_T *lambdasqp;
  emxArray_real_T *lambdasqp_old;
  real_T steplength;
  emxArray_real_T *delta_x;
  emxArray_real_T *socDirection;
  emxArray_real_T *lambda_old;
  emxArray_int32_T *workingset_old;
  emxArray_real_T *JacCineqTrans_old;
  emxArray_real_T *JacCeqTrans_old;
  emxArray_real_T *gradLag;
  emxArray_real_T *delta_gradLag;
  emxArray_real_T *xstar;
  real_T fstar;
  real_T firstorderopt;
  emxArray_real_T *lambda;
  int32_T state;
  real_T maxConstr;
  int32_T iterations;
  emxArray_real_T *searchDir;
} d_struct_T;

#endif                                 /*typedef_d_struct_T*/

#ifndef typedef_e_struct_T
#define typedef_e_struct_T

typedef struct {
  anonymous_function objfun;
  anonymous_function nonlin;
  real_T f_1;
  emxArray_real_T *cIneq_1;
  emxArray_real_T *cEq_1;
  real_T f_2;
  emxArray_real_T *cIneq_2;
  emxArray_real_T *cEq_2;
  int32_T nVar;
  int32_T mIneq;
  int32_T mEq;
  int32_T numEvals;
  boolean_T SpecifyObjectiveGradient;
  boolean_T SpecifyConstraintGradient;
  boolean_T hasLB[66];
  boolean_T hasUB[66];
  boolean_T hasBounds;
  int32_T FiniteDifferenceType;
} e_struct_T;

#endif                                 /*typedef_e_struct_T*/

#ifndef typedef_g_struct_T
#define typedef_g_struct_T

typedef struct {
  int32_T ldq;
  emxArray_real_T *QR;
  emxArray_real_T *Q;
  emxArray_int32_T *jpvt;
  int32_T mrows;
  int32_T ncols;
  emxArray_real_T *tau;
  int32_T minRowCol;
  boolean_T usedPivoting;
} g_struct_T;

#endif                                 /*typedef_g_struct_T*/

#ifndef typedef_h_struct_T
#define typedef_h_struct_T

typedef struct {
  emxArray_real_T *FMat;
  int32_T ldm;
  int32_T ndims;
  int32_T info;
} h_struct_T;

#endif                                 /*typedef_h_struct_T*/

#ifndef typedef_i_struct_T
#define typedef_i_struct_T

typedef struct {
  emxArray_real_T *grad;
  emxArray_real_T *Hx;
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
} i_struct_T;

#endif                                 /*typedef_i_struct_T*/

#ifndef typedef_j_struct_T
#define typedef_j_struct_T

typedef struct {
  int32_T mConstr;
  int32_T mConstrOrig;
  int32_T mConstrMax;
  int32_T nVar;
  int32_T nVarOrig;
  int32_T nVarMax;
  int32_T ldA;
  emxArray_real_T *Aineq;
  emxArray_real_T *bineq;
  emxArray_real_T *Aeq;
  emxArray_real_T *beq;
  emxArray_real_T *lb;
  emxArray_real_T *ub;
  emxArray_int32_T *indexLB;
  emxArray_int32_T *indexUB;
  emxArray_int32_T *indexFixed;
  int32_T mEqRemoved;
  emxArray_int32_T *indexEqRemoved;
  emxArray_real_T *ATwset;
  emxArray_real_T *bwset;
  int32_T nActiveConstr;
  emxArray_real_T *maxConstrWorkspace;
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
  emxArray_boolean_T *isActiveConstr;
  emxArray_int32_T *Wid;
  emxArray_int32_T *Wlocalidx;
  int32_T nWConstr[5];
  int32_T probType;
  real_T SLACK0;
} j_struct_T;

#endif                                 /*typedef_j_struct_T*/

/* End of code generation (fminconMEX_Trackobjective_types.h) */
