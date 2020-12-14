/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * updateWorkingSetForNewQP.h
 *
 * Code generation for function 'updateWorkingSetForNewQP'
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
void updateWorkingSetForNewQP(const emlrtStack *sp, g_struct_T *WorkingSet,
  const real_T cIneq[20], const real_T cEq[88]);

/* End of code generation (updateWorkingSetForNewQP.h) */
