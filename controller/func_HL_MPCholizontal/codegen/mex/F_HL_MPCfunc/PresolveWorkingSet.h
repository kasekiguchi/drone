/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * PresolveWorkingSet.h
 *
 * Code generation for function 'PresolveWorkingSet'
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
void PresolveWorkingSet(F_HL_MPCfuncStackData *SD, const emlrtStack *sp,
  e_struct_T *solution, b_struct_T *memspace, g_struct_T *workingset, k_struct_T
  *qrmanager);

/* End of code generation (PresolveWorkingSet.h) */
