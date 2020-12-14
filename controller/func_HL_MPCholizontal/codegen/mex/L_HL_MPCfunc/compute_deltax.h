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
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "L_HL_MPCfunc_types.h"

/* Function Declarations */
void compute_deltax(const emlrtStack *sp, const real_T H[12100], e_struct_T
                    *solution, b_struct_T *memspace, const k_struct_T *qrmanager,
                    l_struct_T *cholmanager, const j_struct_T *objective);

/* End of code generation (compute_deltax.h) */
