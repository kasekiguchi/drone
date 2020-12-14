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
#include "L_HL_MPCfunc_types.h"

/* Function Declarations */
boolean_T finDiffEvalAndChkErr(const struct0_T obj_objfun_tunableEnvironment[1],
  const real_T c_obj_nonlin_tunableEnvironment[8], real_T
  d_obj_nonlin_tunableEnvironment, const real_T e_obj_nonlin_tunableEnvironment
  [64], const real_T f_obj_nonlin_tunableEnvironment[16], real_T *fplus, real_T
  cIneqPlus[20], real_T cEqPlus[88], int32_T dim, real_T delta, real_T xk[110]);

/* End of code generation (finDiffEvalAndChkErr.h) */
