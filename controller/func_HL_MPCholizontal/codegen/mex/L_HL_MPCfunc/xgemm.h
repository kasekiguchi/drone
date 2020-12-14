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
#include "L_HL_MPCfunc_types.h"

/* Function Declarations */
void b_xgemm(int32_T m, int32_T k, const real_T A[94249], const real_T B[94249],
             real_T C[94249]);
void c_xgemm(int32_T m, int32_T n, int32_T k, const real_T A[12100], int32_T lda,
             const real_T B[94249], int32_T ib0, real_T C[94249]);
void d_xgemm(int32_T m, int32_T n, int32_T k, const real_T A[94249], int32_T ia0,
             const real_T B[94249], real_T C[94249]);
void xgemm(int32_T m, int32_T k, const real_T A[94249], const real_T B[94249],
           real_T C[94249]);

/* End of code generation (xgemm.h) */
