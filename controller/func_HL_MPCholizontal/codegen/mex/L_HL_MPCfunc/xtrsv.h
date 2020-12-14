/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xtrsv.h
 *
 * Code generation for function 'xtrsv'
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
void b_xtrsv(int32_T n, const real_T A[94249], real_T x[307]);
void c_xtrsv(int32_T n, const real_T A[94249], real_T x[307]);
void d_xtrsv(int32_T n, const real_T A[94249], real_T x[94249]);
void xtrsv(int32_T n, const real_T A[94249], real_T x[94249]);

/* End of code generation (xtrsv.h) */
