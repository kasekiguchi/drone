/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * arrayfun.h
 *
 * Code generation for function 'arrayfun'
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
void arrayfun(const emlrtStack *sp, const real_T fun_tunableEnvironment_f1[2],
              const real_T fun_tunableEnvironment_f2[2], const real_T
              fun_tunableEnvironment_f3_front[22], const emxArray_real_T
              *varargin_1, emxArray_real_T *varargout_1);
void b_arrayfun(const emlrtStack *sp, const real_T fun_tunableEnvironment_f1[2],
                const real_T fun_tunableEnvironment_f2[2], const real_T
                fun_tunableEnvironment_f3_data[], const int32_T
                fun_tunableEnvironment_f3_size[2], const emxArray_real_T
                *varargin_1, emxArray_real_T *varargout_1);
void c_arrayfun(const emlrtStack *sp, const real_T
                fun_tunableEnvironment_f1_data[], const int32_T
                fun_tunableEnvironment_f1_size[2], const real_T
                c_fun_tunableEnvironment_f2_sec[6], const real_T
                c_fun_tunableEnvironment_f2_Sec[4], real_T varargout_1[11]);
void d_arrayfun(const emlrtStack *sp, const real_T
                c_fun_tunableEnvironment_f1_P_c[38], const real_T
                fun_tunableEnvironment_f2_data[], const int32_T
                fun_tunableEnvironment_f2_size[2], real_T varargout_1[11]);

/* End of code generation (arrayfun.h) */
