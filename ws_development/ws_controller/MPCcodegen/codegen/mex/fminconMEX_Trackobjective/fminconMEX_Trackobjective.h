/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminconMEX_Trackobjective.h
 *
 * Code generation for function 'fminconMEX_Trackobjective'
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
void anon(const emlrtStack *sp, real_T param_H, real_T param_dt, real_T
          param_state_size, real_T param_Num, const real_T param_X0[4], real_T
          param_model_param_K, const real_T x[66], emxArray_real_T *varargout_1,
          emxArray_real_T *varargout_2);
real_T b_anon(const emlrtStack *sp, real_T param_H, real_T param_state_size,
              const real_T param_Q[16], const real_T param_R[4], const real_T
              param_Qf[16], const real_T param_Xr[44], const real_T x[66]);
void fminconMEX_Trackobjective(const emlrtStack *sp, const real_T x0[66], const
  struct0_T *param, real_T x[66], real_T *fval, real_T *exitflag, struct2_T
  *output, struct3_T *lambda, real_T grad[66], real_T hessian[4356]);

/* End of code generation (fminconMEX_Trackobjective.h) */
