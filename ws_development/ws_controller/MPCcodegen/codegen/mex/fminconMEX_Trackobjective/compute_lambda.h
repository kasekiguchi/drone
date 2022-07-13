/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * compute_lambda.h
 *
 * Code generation for function 'compute_lambda'
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
void compute_lambda(const emlrtStack *sp, emxArray_real_T *workspace, d_struct_T
                    *solution, const i_struct_T *objective, const g_struct_T
                    *qrmanager);

/* End of code generation (compute_lambda.h) */
