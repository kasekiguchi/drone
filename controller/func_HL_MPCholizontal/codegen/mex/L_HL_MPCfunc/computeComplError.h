/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeComplError.h
 *
 * Code generation for function 'computeComplError'
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
real_T computeComplError(const emlrtStack *sp, const real_T cIneq[20], const
  int32_T finiteLB[307], int32_T mLB, const real_T lambda[305], int32_T iL0);

/* End of code generation (computeComplError.h) */
