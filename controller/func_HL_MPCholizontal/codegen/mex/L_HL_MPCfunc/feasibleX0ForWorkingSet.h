/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * feasibleX0ForWorkingSet.h
 *
 * Code generation for function 'feasibleX0ForWorkingSet'
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
boolean_T feasibleX0ForWorkingSet(L_HL_MPCfuncStackData *SD, const emlrtStack
  *sp, real_T workspace[94249], real_T xCurrent[307], g_struct_T *workingset,
  k_struct_T *qrmanager);

/* End of code generation (feasibleX0ForWorkingSet.h) */
