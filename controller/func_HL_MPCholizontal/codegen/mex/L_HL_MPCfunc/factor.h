/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factor.h
 *
 * Code generation for function 'factor'
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
void factor(const emlrtStack *sp, l_struct_T *obj, const real_T A[12100],
            int32_T ndims, int32_T ldA);

/* End of code generation (factor.h) */
