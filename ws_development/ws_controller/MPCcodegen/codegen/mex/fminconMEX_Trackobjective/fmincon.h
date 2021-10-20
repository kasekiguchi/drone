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
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void fmincon(const emlrtStack *sp, const struct0_T fun_tunableEnvironment[1],
             const real_T x0[77], const struct0_T nonlcon_tunableEnvironment[1],
             real_T x[77], real_T *fval, real_T *exitflag, real_T
             *output_iterations, real_T *output_funcCount, char_T
             output_algorithm[3], real_T *output_constrviolation, real_T
             *output_stepsize, real_T *output_lssteplength, real_T
             *output_firstorderopt, struct3_T *lambda, real_T grad[77], real_T
             Hessian[5929]);

/* End of code generation (fmincon.h) */
