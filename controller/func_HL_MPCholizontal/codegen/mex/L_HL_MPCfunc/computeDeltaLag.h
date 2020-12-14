/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeDeltaLag.h
 *
 * Code generation for function 'computeDeltaLag'
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
void computeDeltaLag(const emlrtStack *sp, int32_T nVar, real_T workspace[307],
                     const real_T grad[307], const real_T JacIneqTrans[6140],
                     const real_T JacEqTrans[27016], const real_T grad_old[307],
                     const real_T JacIneqTrans_old[6140], const real_T
                     JacEqTrans_old[27016], const real_T lambda[305]);

/* End of code generation (computeDeltaLag.h) */
