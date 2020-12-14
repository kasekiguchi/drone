/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * BFGSUpdate.h
 *
 * Code generation for function 'BFGSUpdate'
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
boolean_T BFGSUpdate(const emlrtStack *sp, int32_T nvar, real_T Bk[17424], const
                     real_T sk[485], real_T yk[485], real_T workspace[299245]);

/* End of code generation (BFGSUpdate.h) */
