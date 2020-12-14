/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * IndexOfDependentEq_.h
 *
 * Code generation for function 'IndexOfDependentEq_'
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
void IndexOfDependentEq_(const emlrtStack *sp, int32_T depIdx[617], int32_T
  mFixed, int32_T nDep, k_struct_T *qrmanager, const real_T AeqfPrime[299245],
  int32_T mRows, int32_T nCols);

/* End of code generation (IndexOfDependentEq_.h) */
