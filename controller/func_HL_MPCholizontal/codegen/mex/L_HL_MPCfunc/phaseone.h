/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * phaseone.h
 *
 * Code generation for function 'phaseone'
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
void phaseone(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T H
              [12100], const real_T f[307], e_struct_T *solution, b_struct_T
              *memspace, g_struct_T *workingset, k_struct_T *qrmanager,
              l_struct_T *cholmanager, j_struct_T *objective, c_struct_T
              *options, const c_struct_T *runTimeOptions);

/* End of code generation (phaseone.h) */
