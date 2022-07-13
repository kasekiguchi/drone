/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xcopy.h
 *
 * Code generation for function 'xcopy'
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
void b_xcopy(int32_T n, const emxArray_real_T *x, emxArray_real_T *y);
void c_xcopy(const emlrtStack *sp, int32_T n, emxArray_real_T *y);
void d_xcopy(const emlrtStack *sp, int32_T n, const real_T x[66],
             emxArray_real_T *y);
void e_xcopy(int32_T n, const emxArray_real_T *x, emxArray_real_T *y);
void f_xcopy(const emlrtStack *sp, int32_T n, real_T y[4356], int32_T iy0);
void xcopy(int32_T n, const emxArray_real_T *x, int32_T ix0, emxArray_real_T *y,
           int32_T iy0);

/* End of code generation (xcopy.h) */
