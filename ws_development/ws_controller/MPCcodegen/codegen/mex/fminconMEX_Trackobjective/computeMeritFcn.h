/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeMeritFcn.h
 *
 * Code generation for function 'computeMeritFcn'
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
real_T computeMeritFcn(const emlrtStack *sp, real_T obj_penaltyParam, real_T
  fval, const emxArray_real_T *Cineq_workspace, int32_T mIneq, const
  emxArray_real_T *Ceq_workspace, int32_T mEq, boolean_T evalWellDefined);

/* End of code generation (computeMeritFcn.h) */
