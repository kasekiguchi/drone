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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void saveJacobian(const emlrtStack *sp, d_struct_T *obj, int32_T nVar, int32_T
                  mIneq, const emxArray_real_T *JacCineqTrans, int32_T ineqCol0,
                  int32_T mEq, const emxArray_real_T *JacCeqTrans, int32_T
                  eqCol0, int32_T ldJ);

/* End of code generation (saveJacobian.h) */
