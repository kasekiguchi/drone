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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void factorQRE(const emlrtStack *sp, g_struct_T *obj, const emxArray_real_T *A,
               int32_T mrows, int32_T ncols);

/* End of code generation (factorQRE.h) */
