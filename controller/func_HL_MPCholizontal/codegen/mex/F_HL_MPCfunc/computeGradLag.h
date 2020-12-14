/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeGradLag.h
 *
 * Code generation for function 'computeGradLag'
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
void b_computeGradLag(const emlrtStack *sp, real_T workspace[299245], int32_T
                      nVar, const real_T grad[485], const real_T AineqTrans
                      [85360], const real_T AeqTrans[42680], const int32_T
                      finiteLB[485], int32_T mLB, const real_T lambda[617]);
void computeGradLag(const emlrtStack *sp, real_T workspace[485], int32_T nVar,
                    const real_T grad[485], const real_T AineqTrans[85360],
                    const real_T AeqTrans[42680], const int32_T finiteLB[485],
                    int32_T mLB, const real_T lambda[617]);

/* End of code generation (computeGradLag.h) */
