/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeLambdaLSQ.h
 *
 * Code generation for function 'computeLambdaLSQ'
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
void computeLambdaLSQ(const emlrtStack *sp, int32_T nVar, int32_T mConstr,
                      k_struct_T *QRManager, const real_T ATwset[93635], const
                      real_T grad[307], real_T lambdaLSQ[305], real_T workspace
                      [94249]);

/* End of code generation (computeLambdaLSQ.h) */
