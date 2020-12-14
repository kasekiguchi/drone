/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * soc.h
 *
 * Code generation for function 'soc'
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
boolean_T soc(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T
              Hessian[12100], const real_T grad[307], e_struct_T *TrialState,
              b_struct_T *memspace, g_struct_T *WorkingSet, k_struct_T
              *QRManager, l_struct_T *CholManager, j_struct_T *QPObjective,
              const c_struct_T *qpoptions);

/* End of code generation (soc.h) */
