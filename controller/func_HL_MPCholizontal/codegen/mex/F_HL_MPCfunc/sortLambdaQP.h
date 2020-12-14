/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sortLambdaQP.h
 *
 * Code generation for function 'sortLambdaQP'
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
void sortLambdaQP(const emlrtStack *sp, real_T lambda[617], int32_T
                  WorkingSet_nActiveConstr, const int32_T WorkingSet_sizes[5],
                  const int32_T WorkingSet_isActiveIdx[6], const int32_T
                  WorkingSet_Wid[617], const int32_T WorkingSet_Wlocalidx[617],
                  real_T workspace[299245]);

/* End of code generation (sortLambdaQP.h) */
