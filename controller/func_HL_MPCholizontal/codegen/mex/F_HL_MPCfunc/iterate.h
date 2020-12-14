/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * iterate.h
 *
 * Code generation for function 'iterate'
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
void iterate(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T H
             [17424], const real_T f[485], e_struct_T *solution, b_struct_T
             *memspace, g_struct_T *workingset, k_struct_T *qrmanager,
             l_struct_T *cholmanager, j_struct_T *objective, real_T
             options_StepTolerance, real_T options_ObjectiveLimit, int32_T
             runTimeOptions_MaxIterations);

/* End of code generation (iterate.h) */
