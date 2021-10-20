/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fillLambdaStruct.h
 *
 * Code generation for function 'fillLambdaStruct'
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
void fillLambdaStruct(const emlrtStack *sp, int32_T mNonlinIneq, int32_T
                      mNonlinEq, const emxArray_real_T *TrialState_lambdasqp,
                      const emxArray_int32_T *WorkingSet_indexLB, const int32_T
                      WorkingSet_sizes[5], emxArray_real_T *lambda_eqnonlin,
                      emxArray_real_T *lambda_ineqnonlin, real_T lambda_lower[77],
                      real_T lambda_upper[77]);

/* End of code generation (fillLambdaStruct.h) */
