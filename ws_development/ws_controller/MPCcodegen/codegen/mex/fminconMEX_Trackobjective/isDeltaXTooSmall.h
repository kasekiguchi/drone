/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * isDeltaXTooSmall.h
 *
 * Code generation for function 'isDeltaXTooSmall'
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
boolean_T isDeltaXTooSmall(const emlrtStack *sp, const real_T xCurrent[77],
  const emxArray_real_T *delta_x, int32_T nVar);

/* End of code generation (isDeltaXTooSmall.h) */
