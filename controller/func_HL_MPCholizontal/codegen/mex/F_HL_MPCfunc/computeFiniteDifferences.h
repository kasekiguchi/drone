/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeFiniteDifferences.h
 *
 * Code generation for function 'computeFiniteDifferences'
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
boolean_T computeFiniteDifferences(F_HL_MPCfuncStackData *SD, const emlrtStack
  *sp, h_struct_T *obj, real_T fCurrent, const real_T cIneqCurrent[176], const
  real_T cEqCurrent[88], real_T xk[132], real_T gradf[485], real_T
  JacCineqTrans[85360], real_T JacCeqTrans[42680]);

/* End of code generation (computeFiniteDifferences.h) */
