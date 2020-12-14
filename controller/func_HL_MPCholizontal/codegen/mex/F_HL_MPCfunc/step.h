/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * step.h
 *
 * Code generation for function 'step'
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
boolean_T step(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, int32_T
               *STEP_TYPE, real_T Hessian[17424], e_struct_T *TrialState,
               i_struct_T *MeritFunction, b_struct_T *memspace, g_struct_T
               *WorkingSet, k_struct_T *QRManager, l_struct_T *CholManager,
               j_struct_T *QPObjective, c_struct_T *qpoptions);

/* End of code generation (step.h) */
