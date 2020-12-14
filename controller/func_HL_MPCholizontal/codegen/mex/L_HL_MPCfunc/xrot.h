/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xrot.h
 *
 * Code generation for function 'xrot'
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
void b_xrot(const emlrtStack *sp, int32_T n, real_T x[94249], int32_T ix0,
            int32_T iy0, real_T c, real_T s);
void xrot(const emlrtStack *sp, int32_T n, real_T x[94249], int32_T ix0, int32_T
          iy0, real_T c, real_T s);

/* End of code generation (xrot.h) */
