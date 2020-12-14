/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgemm.h
 *
 * Code generation for function 'xgemm'
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
void b_xgemm(int32_T m, int32_T k, const real_T A[380689], const real_T B[299245],
             real_T C[299245]);
void c_xgemm(int32_T m, int32_T n, int32_T k, const real_T A[17424], int32_T lda,
             const real_T B[380689], int32_T ib0, real_T C[299245]);
void d_xgemm(int32_T m, int32_T n, int32_T k, const real_T A[380689], int32_T
             ia0, const real_T B[299245], real_T C[380689]);
void xgemm(int32_T m, int32_T k, const real_T A[380689], const real_T B[299245],
           real_T C[299245]);

/* End of code generation (xgemm.h) */
