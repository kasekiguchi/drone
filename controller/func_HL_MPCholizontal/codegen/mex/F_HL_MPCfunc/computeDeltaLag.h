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
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
void computeDeltaLag(const emlrtStack *sp, int32_T nVar, real_T workspace[485],
                     const real_T grad[485], const real_T JacIneqTrans[85360],
                     const real_T JacEqTrans[42680], const real_T grad_old[485],
                     const real_T JacIneqTrans_old[85360], const real_T
                     JacEqTrans_old[42680], const real_T lambda[617]);

/* End of code generation (computeDeltaLag.h) */
