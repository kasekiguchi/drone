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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void b_xtrsv(int32_T n, const emxArray_real_T *A, int32_T lda, emxArray_real_T
             *x);
void c_xtrsv(int32_T n, const emxArray_real_T *A, int32_T lda, emxArray_real_T
             *x);
void xtrsv(int32_T n, const emxArray_real_T *A, int32_T lda, emxArray_real_T *x);

/* End of code generation (xtrsv.h) */
