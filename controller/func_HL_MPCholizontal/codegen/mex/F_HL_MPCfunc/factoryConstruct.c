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
#include "F_HL_MPCfunc.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
void factoryConstruct(const struct0_T objfun_tunableEnvironment[1], const
                      struct0_T nonlin_tunableEnvironment[1], h_struct_T *obj)
{
  obj->objfun.tunableEnvironment[0] = objfun_tunableEnvironment[0];
  obj->nonlin.tunableEnvironment[0] = nonlin_tunableEnvironment[0];
  obj->f_1 = 0.0;
  obj->f_2 = 0.0;
  obj->nVar = 132;
  obj->mIneq = 176;
  obj->mEq = 88;
  obj->numEvals = 0;
  obj->SpecifyObjectiveGradient = false;
  obj->SpecifyConstraintGradient = false;
  obj->FiniteDifferenceType = 0;
  memset(&obj->hasLB[0], 0, 132U * sizeof(boolean_T));
  memset(&obj->hasUB[0], 0, 132U * sizeof(boolean_T));
  obj->hasBounds = false;
}

/* End of code generation (factoryConstruct.c) */
