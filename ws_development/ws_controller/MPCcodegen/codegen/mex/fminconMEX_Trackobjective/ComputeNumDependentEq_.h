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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
int32_T ComputeNumDependentEq_(const emlrtStack *sp, g_struct_T *qrmanager,
  const emxArray_real_T *beqf, int32_T mConstr, int32_T nVar);

/* End of code generation (ComputeNumDependentEq_.h) */
