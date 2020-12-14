/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fmincon.h
 *
 * Code generation for function 'fmincon'
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
void fmincon(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const struct0_T
             fun_tunableEnvironment[1], const real_T x0[132], const struct0_T
             nonlcon_tunableEnvironment[1], real_T x[132], real_T *fval, real_T *
             exitflag, real_T *output_iterations, real_T *output_funcCount,
             char_T output_algorithm[3], real_T *output_constrviolation, real_T *
             output_stepsize, real_T *output_lssteplength, real_T
             *output_firstorderopt, d_struct_T *lambda, real_T grad[132], real_T
             Hessian[17424]);

/* End of code generation (fmincon.h) */
