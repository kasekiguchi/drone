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
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "L_HL_MPCfunc_types.h"

/* Function Declarations */
void b_xcopy(const emlrtStack *sp, int32_T n, const real_T x[305], real_T y[305]);
void c_xcopy(const emlrtStack *sp, int32_T n, real_T y[305]);
void d_xcopy(const emlrtStack *sp, int32_T n, const real_T x[93635], int32_T ix0,
             real_T y[94249], int32_T iy0);
void e_xcopy(const emlrtStack *sp, int32_T n, const real_T x[110], real_T y[307]);
void f_xcopy(const emlrtStack *sp, int32_T n, const real_T x[307], real_T y[307]);
void g_xcopy(const emlrtStack *sp, int32_T n, real_T y[12100], int32_T iy0);
void xcopy(const emlrtStack *sp, int32_T n, const real_T x[6140], int32_T ix0,
           real_T y[93635], int32_T iy0);

/* End of code generation (xcopy.h) */
