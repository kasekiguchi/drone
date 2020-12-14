/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factorQRE.h
 *
 * Code generation for function 'factorQRE'
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
void factorQRE(const emlrtStack *sp, k_struct_T *obj, const real_T A[299245],
               int32_T mrows, int32_T ncols);

/* End of code generation (factorQRE.h) */
