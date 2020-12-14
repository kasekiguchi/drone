/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * feasibleratiotest.h
 *
 * Code generation for function 'feasibleratiotest'
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
void feasibleratiotest(const emlrtStack *sp, const real_T solution_xstar[307],
  const real_T solution_searchDir[307], real_T workspace[94249], int32_T
  workingset_nVar, const real_T workingset_Aineq[6140], const real_T
  workingset_bineq[20], const real_T workingset_lb[307], const int32_T
  workingset_indexLB[307], const int32_T workingset_sizes[5], const int32_T
  workingset_isActiveIdx[6], const boolean_T workingset_isActiveConstr[305],
  const int32_T workingset_nWConstr[5], boolean_T isPhaseOne, real_T *alpha,
  boolean_T *newBlocking, int32_T *constrType, int32_T *constrIdx);

/* End of code generation (feasibleratiotest.h) */
