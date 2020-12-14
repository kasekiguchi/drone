/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeConstraints_.h
 *
 * Code generation for function 'computeConstraints_'
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
int32_T computeConstraints_(F_HL_MPCfuncStackData *SD, const emlrtStack *sp,
  const struct0_T obj_nonlcon_tunableEnvironment[1], const real_T x[132], real_T
  Cineq_workspace[176], real_T Ceq_workspace[88]);

/* End of code generation (computeConstraints_.h) */
