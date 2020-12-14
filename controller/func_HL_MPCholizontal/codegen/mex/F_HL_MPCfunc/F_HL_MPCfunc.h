/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * F_HL_MPCfunc.h
 *
 * Code generation for function 'F_HL_MPCfunc'
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
void F_HL_MPCfunc(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const
                  struct0_T *MPCparam, const real_T MPCprevious_variables[110],
                  const real_T MPCslack[22], real_T funcresult[132]);
void __anon_fcn(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, real_T
                MPCparam_state_size, real_T MPCparam_Num, real_T MPCparam_Slew,
                const real_T MPCparam_D_lim[2], const real_T MPCparam_r_limit[2],
                const real_T MPCparam_A[64], const real_T MPCparam_B[16], const
                real_T MPCparam_wall_width_y[4], const real_T
                MPCparam_wall_width_x[4], const real_T MPCparam_sectionpoint[6],
                const real_T MPCparam_Section_change[4], const real_T
                MPCparam_S_front[4], const real_T MPCparam_front[22], const
                real_T MPCparam_behind[22], const real_T MPCparam_X0[8], const
                real_T x[132], real_T varargout_1[176], real_T varargout_2[88]);
real_T b___anon_fcn(const emlrtStack *sp, const real_T f_prev_sp[2], const
                    real_T f_now_sp[2], const real_T param_front[22], real_T L);
real_T c___anon_fcn(const emlrtStack *sp, const real_T prev_sp[2], const real_T
                    now_sp[2], const real_T X_data[], const int32_T X_size[2],
                    real_T L);
real_T d___anon_fcn(const emlrtStack *sp, const struct0_T *MPCparam, const
                    real_T x[132]);

/* End of code generation (F_HL_MPCfunc.h) */
