/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgemv.h
 *
 * Code generation for function 'xgemv'
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
void b_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y);
void c_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y);
void d_xgemv(int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y);
void e_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y);
void f_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, int32_T ix0, emxArray_real_T *y);
void g_xgemv(int32_T m, int32_T n, const real_T A[4356], int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y);
void h_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, int32_T ix0, emxArray_real_T *y, int32_T iy0);
void i_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T ia0,
             int32_T lda, const emxArray_real_T *x, emxArray_real_T *y);
void j_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T ia0,
             int32_T lda, const emxArray_real_T *x, emxArray_real_T *y);
void k_xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
             emxArray_real_T *x, emxArray_real_T *y, int32_T iy0);
void l_xgemv(const emlrtStack *sp, int32_T m, int32_T n, const emxArray_real_T
             *A, int32_T lda, const emxArray_real_T *x, emxArray_real_T *y);
void xgemv(int32_T m, int32_T n, const emxArray_real_T *A, int32_T lda, const
           emxArray_real_T *x, int32_T ix0, emxArray_real_T *y);

/* End of code generation (xgemv.h) */
