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
#include "L_HL_MPCfunc_types.h"

/* Function Declarations */
void fmincon(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const struct0_T
             fun_tunableEnvironment[1], const real_T x0[110], const real_T
             nonlcon_tunableEnvironment_f1_Q[64], const real_T
             b_nonlcon_tunableEnvironment_f1[64], const real_T
             nonlcon_tunableEnvironment_f1_R[4], const real_T
             c_nonlcon_tunableEnvironment_f1[88], const real_T
             d_nonlcon_tunableEnvironment_f1[8], real_T
             e_nonlcon_tunableEnvironment_f1, const real_T
             nonlcon_tunableEnvironment_f2_A[64], const real_T
             nonlcon_tunableEnvironment_f2_B[16], real_T x[110], real_T *fval,
             real_T *exitflag, real_T *output_iterations, real_T
             *output_funcCount, char_T output_algorithm[3], real_T
             *output_constrviolation, real_T *output_stepsize, real_T
             *output_lssteplength, real_T *output_firstorderopt, d_struct_T
             *lambda, real_T grad[110], real_T Hessian[12100]);

/* End of code generation (fmincon.h) */
