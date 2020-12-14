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
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
void linesearch(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, boolean_T
                *evalWellDefined, int32_T WorkingSet_nVar, e_struct_T
                *TrialState, real_T MeritFunction_penaltyParam, real_T
                MeritFunction_phi, real_T MeritFunction_phiPrimePlus, real_T
                MeritFunction_phiFullStep, const struct0_T
                c_FcnEvaluator_objfun_tunableEn[1], const struct0_T
                c_FcnEvaluator_nonlcon_tunableE[1], boolean_T socTaken, real_T
                *alpha, int32_T *exitflag);

/* End of code generation (linesearch.h) */
