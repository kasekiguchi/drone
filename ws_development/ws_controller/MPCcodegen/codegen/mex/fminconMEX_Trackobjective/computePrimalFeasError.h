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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
real_T computePrimalFeasError(const emlrtStack *sp, int32_T mLinIneq, int32_T
  mNonlinIneq, const emxArray_real_T *cIneq, int32_T mLinEq, int32_T mNonlinEq,
  const emxArray_real_T *cEq, const emxArray_int32_T *finiteLB, int32_T mLB);

/* End of code generation (computePrimalFeasError.h) */
