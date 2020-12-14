/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * linearForm_.h
 *
 * Code generation for function 'linearForm_'
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
void linearForm_(const emlrtStack *sp, boolean_T obj_hasLinear, int32_T obj_nvar,
                 real_T workspace[299245], const real_T H[17424], const real_T
                 f[485], const real_T x[485]);

/* End of code generation (linearForm_.h) */
