/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * updatePenaltyParam.h
 *
 * Code generation for function 'updatePenaltyParam'
 *
 */

#pragma once

/* Include files */
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void b_updatePenaltyParam(const emlrtStack *sp, k_struct_T *obj, real_T fval,
  const emxArray_real_T *ineq_workspace, int32_T mIneq, const emxArray_real_T
  *eq_workspace, int32_T mEq, int32_T sqpiter, real_T qpval, const
  emxArray_real_T *x, int32_T iReg0, int32_T nRegularized);
void updatePenaltyParam(const emlrtStack *sp, k_struct_T *obj, real_T fval,
  const emxArray_real_T *ineq_workspace, int32_T mIneq, const emxArray_real_T
  *eq_workspace, int32_T mEq, int32_T sqpiter, real_T qpval);

/* End of code generation (updatePenaltyParam.h) */
