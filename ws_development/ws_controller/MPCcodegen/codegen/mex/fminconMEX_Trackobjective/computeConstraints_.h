/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeConstraints_.h
 *
 * Code generation for function 'computeConstraints_'
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
int32_T computeConstraints_(const emlrtStack *sp, const struct0_T
  obj_nonlcon_tunableEnvironment[1], int32_T obj_mCineq, int32_T obj_mCeq, const
  real_T x[77], emxArray_real_T *Cineq_workspace, int32_T ineq0, emxArray_real_T
  *Ceq_workspace, int32_T eq0);

/* End of code generation (computeConstraints_.h) */
