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
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
void b_xcopy(int32_T n, const real_T x[617], real_T y[617]);
void c_xcopy(const emlrtStack *sp, int32_T n, real_T y[617]);
void d_xcopy(int32_T n, const real_T x[299245], int32_T ix0, real_T y[380689],
             int32_T iy0);
void e_xcopy(int32_T n, const real_T x[380689], int32_T ix0, real_T y[380689],
             int32_T iy0);
void f_xcopy(const emlrtStack *sp, int32_T n, const real_T x[132], real_T y[485]);
void g_xcopy(const emlrtStack *sp, int32_T n, const real_T x[485], real_T y[485]);
void h_xcopy(const emlrtStack *sp, int32_T n, real_T y[17424], int32_T iy0);
void xcopy(const emlrtStack *sp, int32_T n, const real_T x[85360], int32_T ix0,
           real_T y[299245], int32_T iy0);

/* End of code generation (xcopy.h) */
