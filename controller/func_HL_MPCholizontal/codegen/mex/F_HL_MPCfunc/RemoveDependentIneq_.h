/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * RemoveDependentIneq_.h
 *
 * Code generation for function 'RemoveDependentIneq_'
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
void RemoveDependentIneq_(const emlrtStack *sp, g_struct_T *workingset,
  k_struct_T *qrmanager, b_struct_T *memspace, real_T tolfactor);

/* End of code generation (RemoveDependentIneq_.h) */
