/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * L_HL_MPCfunc.h
 *
 * Code generation for function 'L_HL_MPCfunc'
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
void L_HL_MPCfunc(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const
                  struct0_T *MPCparam, const struct1_T *linear_model, const
                  real_T MPCprevious_variables[110], real_T funcresult[110]);
real_T __anon_fcn(const real_T MPCparam_Q[64], const real_T MPCparam_Qf[64],
                  const real_T MPCparam_R[4], const real_T MPCparam_Xr[88],
                  const real_T x[110]);

/* End of code generation (L_HL_MPCfunc.h) */
