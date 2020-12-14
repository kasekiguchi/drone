/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeGrad_StoreHx.h
 *
 * Code generation for function 'computeGrad_StoreHx'
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
void computeGrad_StoreHx(const emlrtStack *sp, j_struct_T *obj, const real_T H
  [12100], const real_T f[307], const real_T x[307]);

/* End of code generation (computeGrad_StoreHx.h) */
