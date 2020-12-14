/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ComputeNumDependentEq_.h
 *
 * Code generation for function 'ComputeNumDependentEq_'
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
int32_T ComputeNumDependentEq_(const emlrtStack *sp, k_struct_T *qrmanager,
  const real_T beqf[617], int32_T mConstr, int32_T nVar);

/* End of code generation (ComputeNumDependentEq_.h) */
