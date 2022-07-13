/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeLinearResiduals.h
 *
 * Code generation for function 'computeLinearResiduals'
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
void computeLinearResiduals(const real_T x[66], int32_T nVar, emxArray_real_T
  *workspaceIneq, int32_T mLinIneq, const emxArray_real_T *AineqT, int32_T ldAi,
  emxArray_real_T *workspaceEq, int32_T mLinEq, const emxArray_real_T *AeqT,
  int32_T ldAe);

/* End of code generation (computeLinearResiduals.h) */
