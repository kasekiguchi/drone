/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * finDiffEvalAndChkErr.h
 *
 * Code generation for function 'finDiffEvalAndChkErr'
 *
 */

#pragma once

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
boolean_T finDiffEvalAndChkErr(F_HL_MPCfuncStackData *SD, const emlrtStack *sp,
  const struct0_T obj_objfun_tunableEnvironment[1], const struct0_T
  obj_nonlin_tunableEnvironment[1], real_T *fplus, real_T cIneqPlus[176], real_T
  cEqPlus[88], int32_T dim, real_T delta, real_T xk[132]);

/* End of code generation (finDiffEvalAndChkErr.h) */
