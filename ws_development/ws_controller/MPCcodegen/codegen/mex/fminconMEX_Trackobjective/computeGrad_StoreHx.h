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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void computeGrad_StoreHx(const emlrtStack *sp, i_struct_T *obj, const real_T H
  [5929], const emxArray_real_T *f, const emxArray_real_T *x);

/* End of code generation (computeGrad_StoreHx.h) */
