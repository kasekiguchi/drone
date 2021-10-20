/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factoryConstruct2.h
 *
 * Code generation for function 'factoryConstruct2'
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
void c_factoryConstruct(const emlrtStack *sp, real_T fval, const emxArray_real_T
  *Cineq_workspace, int32_T mNonlinIneq, const emxArray_real_T *Ceq_workspace,
  int32_T mNonlinEq, k_struct_T *obj);

/* End of code generation (factoryConstruct2.h) */
