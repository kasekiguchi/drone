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
#include "L_HL_MPCfunc_types.h"

/* Function Declarations */
void b_computeGradLag(const emlrtStack *sp, real_T workspace[94249], int32_T
                      nVar, const real_T grad[307], const real_T AineqTrans[6140],
                      const real_T AeqTrans[27016], const int32_T finiteLB[307],
                      int32_T mLB, const real_T lambda[305]);
void computeGradLag(const emlrtStack *sp, real_T workspace[307], int32_T nVar,
                    const real_T grad[307], const real_T AineqTrans[6140], const
                    real_T AeqTrans[27016], const int32_T finiteLB[307], int32_T
                    mLB, const real_T lambda[305]);

/* End of code generation (computeGradLag.h) */
