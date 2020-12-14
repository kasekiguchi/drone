/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * assignResidualsToXSlack.h
 *
 * Code generation for function 'assignResidualsToXSlack'
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
void assignResidualsToXSlack(const emlrtStack *sp, int32_T nVarOrig, g_struct_T *
  WorkingSet, e_struct_T *TrialState, b_struct_T *memspace);

/* End of code generation (assignResidualsToXSlack.h) */
