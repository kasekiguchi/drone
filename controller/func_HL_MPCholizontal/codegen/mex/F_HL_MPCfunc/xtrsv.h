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
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
void b_xtrsv(int32_T n, const real_T A[380689], real_T x[485]);
void c_xtrsv(int32_T n, const real_T A[380689], real_T x[485]);
void d_xtrsv(int32_T n, const real_T A[380689], real_T x[299245]);
void xtrsv(int32_T n, const real_T A[380689], real_T x[299245]);

/* End of code generation (xtrsv.h) */
