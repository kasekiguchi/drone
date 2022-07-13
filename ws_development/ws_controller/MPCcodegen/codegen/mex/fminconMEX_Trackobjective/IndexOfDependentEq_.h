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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void IndexOfDependentEq_(const emlrtStack *sp, emxArray_int32_T *depIdx, int32_T
  mFixed, int32_T nDep, g_struct_T *qrmanager, const emxArray_real_T *AeqfPrime,
  int32_T mRows, int32_T nCols);

/* End of code generation (IndexOfDependentEq_.h) */
