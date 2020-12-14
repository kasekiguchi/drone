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
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
void b_xrot(int32_T n, real_T x[380689], int32_T ix0, int32_T iy0, real_T c,
            real_T s);
void xrot(int32_T n, real_T x[380689], int32_T ix0, int32_T iy0, real_T c,
          real_T s);

/* End of code generation (xrot.h) */
