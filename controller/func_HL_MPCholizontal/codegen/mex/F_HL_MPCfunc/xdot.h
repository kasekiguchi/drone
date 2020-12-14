/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xdot.h
 *
 * Code generation for function 'xdot'
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
real_T b_xdot(const emlrtStack *sp, int32_T n, const real_T x[485], const real_T
              y[299245]);
real_T c_xdot(const emlrtStack *sp, int32_T n, const real_T x[485], const real_T
              y[484]);
real_T d_xdot(const emlrtStack *sp, int32_T n, const real_T x[485], const real_T
              y[485]);
real_T xdot(int32_T n, const real_T x[380689], int32_T ix0, const real_T y[617]);

/* End of code generation (xdot.h) */
