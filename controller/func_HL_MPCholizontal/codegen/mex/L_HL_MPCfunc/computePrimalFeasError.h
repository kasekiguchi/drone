/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computePrimalFeasError.h
 *
 * Code generation for function 'computePrimalFeasError'
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
real_T computePrimalFeasError(const emlrtStack *sp, const real_T cIneq[20],
  const real_T cEq[88], const int32_T finiteLB[307], int32_T mLB);

/* End of code generation (computePrimalFeasError.h) */
