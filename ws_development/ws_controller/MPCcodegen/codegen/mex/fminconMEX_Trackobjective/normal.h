/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * normal.h
 *
 * Code generation for function 'normal'
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
void normal(const emlrtStack *sp, const real_T Hessian[5929], const
            emxArray_real_T *grad, d_struct_T *TrialState, k_struct_T
            *MeritFunction, c_struct_T *memspace, j_struct_T *WorkingSet,
            g_struct_T *QRManager, h_struct_T *CholManager, i_struct_T
            *QPObjective, const b_struct_T *qpoptions);

/* End of code generation (normal.h) */
