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
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
void compute_lambda(const emlrtStack *sp, real_T workspace[299245], e_struct_T
                    *solution, const j_struct_T *objective, const k_struct_T
                    *qrmanager);

/* End of code generation (compute_lambda.h) */
