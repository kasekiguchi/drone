/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeFval.h
 *
 * Code generation for function 'computeFval'
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
real_T computeFval(const emlrtStack *sp, const i_struct_T *obj, emxArray_real_T *
                   workspace, const real_T H[4356], const emxArray_real_T *f,
                   const emxArray_real_T *x);

/* End of code generation (computeFval.h) */
