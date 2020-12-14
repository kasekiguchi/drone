/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factorQR.h
 *
 * Code generation for function 'factorQR'
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
void factorQR(const emlrtStack *sp, k_struct_T *obj, const real_T A[93635],
              int32_T mrows, int32_T ncols);

/* End of code generation (factorQR.h) */
