/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * compute_deltax.h
 *
 * Code generation for function 'compute_deltax'
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
void compute_deltax(const emlrtStack *sp, const real_T H[4356], d_struct_T
                    *solution, c_struct_T *memspace, const g_struct_T *qrmanager,
                    h_struct_T *cholmanager, const i_struct_T *objective);

/* End of code generation (compute_deltax.h) */
