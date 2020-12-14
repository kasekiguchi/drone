/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * checkStoppingAndUpdateFval.h
 *
 * Code generation for function 'checkStoppingAndUpdateFval'
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
void checkStoppingAndUpdateFval(L_HL_MPCfuncStackData *SD, const emlrtStack *sp,
  int32_T *activeSetChangeID, const real_T f[307], e_struct_T *solution,
  b_struct_T *memspace, const j_struct_T *objective, g_struct_T *workingset,
  k_struct_T *qrmanager, real_T options_ObjectiveLimit, int32_T
  runTimeOptions_MaxIterations, boolean_T updateFval);

/* End of code generation (checkStoppingAndUpdateFval.h) */
