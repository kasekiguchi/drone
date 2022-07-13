/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * linesearch.h
 *
 * Code generation for function 'linesearch'
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
void linesearch(const emlrtStack *sp, boolean_T *evalWellDefined, int32_T
                WorkingSet_nVar, int32_T WorkingSet_ldA, const emxArray_real_T
                *WorkingSet_Aineq, const emxArray_real_T *WorkingSet_Aeq,
                d_struct_T *TrialState, real_T MeritFunction_penaltyParam,
                real_T MeritFunction_phi, real_T MeritFunction_phiPrimePlus,
                real_T MeritFunction_phiFullStep, const struct0_T
                c_FcnEvaluator_objfun_tunableEn[1], const struct0_T
                c_FcnEvaluator_nonlcon_tunableE[1], int32_T FcnEvaluator_mCineq,
                int32_T FcnEvaluator_mCeq, boolean_T socTaken, real_T *alpha,
                int32_T *exitflag);

/* End of code generation (linesearch.h) */
