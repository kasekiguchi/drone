/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * evalObjAndConstrAndDerivatives.h
 *
 * Code generation for function 'evalObjAndConstrAndDerivatives'
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
void evalObjAndConstrAndDerivatives(F_HL_MPCfuncStackData *SD, const emlrtStack *
  sp, const struct0_T obj_objfun_tunableEnvironment[1], const struct0_T
  obj_nonlcon_tunableEnvironment[1], const real_T x[132], real_T
  Cineq_workspace[176], real_T Ceq_workspace[88], real_T *fval, int32_T *status);

/* End of code generation (evalObjAndConstrAndDerivatives.h) */
