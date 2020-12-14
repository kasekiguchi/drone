/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factoryConstruct.c
 *
 * Code generation for function 'factoryConstruct'
 *
 */

/* Include files */
#include "factoryConstruct.h"
#include "L_HL_MPCfunc.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
void factoryConstruct(const struct0_T objfun_tunableEnvironment[1], const real_T
                      nonlin_tunableEnvironment_f1_Q[64], const real_T
                      nonlin_tunableEnvironment_f1_Qf[64], const real_T
                      nonlin_tunableEnvironment_f1_R[4], const real_T
                      nonlin_tunableEnvironment_f1_Xr[88], const real_T
                      nonlin_tunableEnvironment_f1_X0[8], real_T
                      c_nonlin_tunableEnvironment_f1_, const real_T
                      nonlin_tunableEnvironment_f2_A[64], const real_T
                      nonlin_tunableEnvironment_f2_B[16], h_struct_T *obj)
{
  obj->objfun.tunableEnvironment[0] = objfun_tunableEnvironment[0];
  memcpy(&obj->nonlin.tunableEnvironment.f1.Q[0],
         &nonlin_tunableEnvironment_f1_Q[0], 64U * sizeof(real_T));
  memcpy(&obj->nonlin.tunableEnvironment.f1.Qf[0],
         &nonlin_tunableEnvironment_f1_Qf[0], 64U * sizeof(real_T));
  obj->nonlin.tunableEnvironment.f1.R[0] = nonlin_tunableEnvironment_f1_R[0];
  obj->nonlin.tunableEnvironment.f1.R[1] = nonlin_tunableEnvironment_f1_R[1];
  obj->nonlin.tunableEnvironment.f1.R[2] = nonlin_tunableEnvironment_f1_R[2];
  obj->nonlin.tunableEnvironment.f1.R[3] = nonlin_tunableEnvironment_f1_R[3];
  memcpy(&obj->nonlin.tunableEnvironment.f1.Xr[0],
         &nonlin_tunableEnvironment_f1_Xr[0], 88U * sizeof(real_T));
  memcpy(&obj->nonlin.tunableEnvironment.f1.X0[0],
         &nonlin_tunableEnvironment_f1_X0[0], 8U * sizeof(real_T));
  obj->nonlin.tunableEnvironment.f1.Slew = c_nonlin_tunableEnvironment_f1_;
  memcpy(&obj->nonlin.tunableEnvironment.f2.A[0],
         &nonlin_tunableEnvironment_f2_A[0], 64U * sizeof(real_T));
  memcpy(&obj->nonlin.tunableEnvironment.f2.B[0],
         &nonlin_tunableEnvironment_f2_B[0], 16U * sizeof(real_T));
  obj->f_1 = 0.0;
  obj->f_2 = 0.0;
  obj->nVar = 110;
  obj->mIneq = 20;
  obj->mEq = 88;
  obj->numEvals = 0;
  obj->SpecifyObjectiveGradient = false;
  obj->SpecifyConstraintGradient = false;
  obj->FiniteDifferenceType = 0;
  memset(&obj->hasLB[0], 0, 110U * sizeof(boolean_T));
  memset(&obj->hasUB[0], 0, 110U * sizeof(boolean_T));
  obj->hasBounds = false;
}

/* End of code generation (factoryConstruct.c) */
