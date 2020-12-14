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
#include "L_HL_MPCfunc_types.h"

/* Function Declarations */
int32_T computeConstraints_(const emlrtStack *sp, const real_T
  c_obj_nonlcon_tunableEnvironmen[8], real_T d_obj_nonlcon_tunableEnvironmen,
  const real_T e_obj_nonlcon_tunableEnvironmen[64], const real_T
  f_obj_nonlcon_tunableEnvironmen[16], const real_T x[110], real_T
  Cineq_workspace[20], real_T Ceq_workspace[88]);

/* End of code generation (computeConstraints_.h) */
