/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * feasibleX0ForWorkingSet.h
 *
 * Code generation for function 'feasibleX0ForWorkingSet'
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
boolean_T feasibleX0ForWorkingSet(const emlrtStack *sp, emxArray_real_T
  *workspace, emxArray_real_T *xCurrent, j_struct_T *workingset, g_struct_T
  *qrmanager);

/* End of code generation (feasibleX0ForWorkingSet.h) */
