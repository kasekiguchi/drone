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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
boolean_T finDiffEvalAndChkErr(const emlrtStack *sp, const struct0_T
  obj_objfun_tunableEnvironment[1], const struct0_T
  obj_nonlin_tunableEnvironment[1], int32_T obj_mIneq, int32_T obj_mEq, real_T
  *fplus, emxArray_real_T *cIneqPlus, emxArray_real_T *cEqPlus, int32_T dim,
  real_T delta, real_T xk[77]);

/* End of code generation (finDiffEvalAndChkErr.h) */
