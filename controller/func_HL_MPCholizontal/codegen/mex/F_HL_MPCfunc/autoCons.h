/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * autoCons.h
 *
 * Code generation for function 'autoCons'
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
void autoCons(const emlrtStack *sp, const real_T in1[132], const real_T in2[8],
              const real_T in3[64], const real_T in4[16], real_T Sr, const
              real_T in6[2], const real_T in7[22], const real_T in8[22], const
              real_T in9[22], const real_T in10[22], const real_T in11[22],
              const real_T in12[2], real_T cineq[176], real_T ceq[88], real_T
              dcineq[23232], real_T dceq[11616]);

/* End of code generation (autoCons.h) */
