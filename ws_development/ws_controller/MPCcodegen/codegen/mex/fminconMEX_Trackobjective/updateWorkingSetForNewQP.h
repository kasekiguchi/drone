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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void updateWorkingSetForNewQP(const emlrtStack *sp, j_struct_T *WorkingSet,
  int32_T mIneq, int32_T mNonlinIneq, const emxArray_real_T *cIneq, int32_T mEq,
  int32_T mNonlinEq, const emxArray_real_T *cEq);

/* End of code generation (updateWorkingSetForNewQP.h) */
