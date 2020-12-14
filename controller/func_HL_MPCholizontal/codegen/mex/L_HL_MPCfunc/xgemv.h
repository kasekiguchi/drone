/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * xgemv.h
 *
 * Code generation for function 'xgemv'
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
void b_xgemv(int32_T m, int32_T n, const real_T A[93635], const real_T x[307],
             real_T y[94249]);
void c_xgemv(const real_T A[6140], const real_T x[94249], real_T y[305]);
void d_xgemv(int32_T m, const real_T A[27016], const real_T x[94249], real_T y
             [305]);
void e_xgemv(int32_T m, const real_T A[6140], const real_T x[94249], real_T y
             [305]);
void f_xgemv(const real_T A[6140], const real_T x[94249], real_T y[305]);
void g_xgemv(int32_T m, const real_T A[27016], const real_T x[94249], real_T y
             [305]);
void h_xgemv(int32_T m, const real_T A[6140], const real_T x[94249], real_T y
             [305]);
void i_xgemv(const real_T A[6140], const real_T x[307], real_T y[305]);
void j_xgemv(int32_T m, const real_T A[27016], const real_T x[307], real_T y[305]);
void k_xgemv(int32_T m, const real_T A[6140], const real_T x[307], real_T y[305]);
void l_xgemv(int32_T m, int32_T n, const real_T A[12100], int32_T lda, const
             real_T x[307], real_T y[306]);
void m_xgemv(int32_T m, int32_T n, const real_T A[94249], const real_T x[93635],
             int32_T ix0, real_T y[94249], int32_T iy0);
void n_xgemv(int32_T m, int32_T n, const real_T A[94249], int32_T ia0, const
             real_T x[94249], real_T y[307]);
void o_xgemv(int32_T m, int32_T n, const real_T A[94249], int32_T ia0, const
             real_T x[307], real_T y[94249]);
void p_xgemv(int32_T m, const real_T A[6140], const real_T x[307], real_T y
             [94249]);
void q_xgemv(int32_T m, const real_T A[6140], const real_T x[307], real_T y
             [94249]);
void r_xgemv(int32_T m, const real_T A[27016], const real_T x[307], real_T y
             [94249]);
void s_xgemv(int32_T m, const real_T A[27016], const real_T x[307], real_T y[88]);
void xgemv(int32_T m, int32_T n, const real_T A[94249], const real_T x[307],
           real_T y[94249]);

/* End of code generation (xgemv.h) */
