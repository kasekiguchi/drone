/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * saveJacobian.h
 *
 * Code generation for function 'saveJacobian'
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
void saveJacobian(const emlrtStack *sp, e_struct_T *obj, int32_T nVar, const
                  real_T JacCineqTrans[85360], const real_T JacCeqTrans[42680]);

/* End of code generation (saveJacobian.h) */
