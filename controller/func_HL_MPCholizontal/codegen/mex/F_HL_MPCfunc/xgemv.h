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
#include "F_HL_MPCfunc_types.h"

/* Function Declarations */
void b_xgemv(int32_T m, int32_T n, const real_T A[299245], const real_T x[485],
             real_T y[299245]);
void c_xgemv(const real_T A[85360], const real_T x[299245], real_T y[617]);
void d_xgemv(int32_T m, const real_T A[42680], const real_T x[299245], real_T y
             [617]);
void e_xgemv(int32_T m, const real_T A[85360], const real_T x[299245], real_T y
             [617]);
void f_xgemv(const real_T A[85360], const real_T x[299245], real_T y[617]);
void g_xgemv(int32_T m, const real_T A[42680], const real_T x[299245], real_T y
             [617]);
void h_xgemv(int32_T m, const real_T A[85360], const real_T x[299245], real_T y
             [617]);
void i_xgemv(const real_T A[85360], const real_T x[485], real_T y[617]);
void j_xgemv(int32_T m, const real_T A[42680], const real_T x[485], real_T y[617]);
void k_xgemv(int32_T m, const real_T A[85360], const real_T x[485], real_T y[617]);
void l_xgemv(int32_T m, int32_T n, const real_T A[17424], int32_T lda, const
             real_T x[485], real_T y[484]);
void m_xgemv(int32_T m, int32_T n, const real_T A[380689], const real_T x[299245],
             int32_T ix0, real_T y[380689], int32_T iy0);
void n_xgemv(int32_T m, int32_T n, const real_T A[380689], int32_T ia0, const
             real_T x[299245], real_T y[485]);
void o_xgemv(int32_T m, int32_T n, const real_T A[380689], int32_T ia0, const
             real_T x[485], real_T y[299245]);
void p_xgemv(int32_T m, const real_T A[85360], const real_T x[485], real_T y
             [299245]);
void q_xgemv(int32_T m, const real_T A[85360], const real_T x[485], real_T y
             [299245]);
void r_xgemv(int32_T m, const real_T A[42680], const real_T x[485], real_T y
             [299245]);
void s_xgemv(int32_T m, const real_T A[42680], const real_T x[485], real_T y[88]);
void t_xgemv(int32_T m, const real_T A[85360], const real_T x[485], real_T y[176]);
void xgemv(int32_T m, int32_T n, const real_T A[380689], const real_T x[485],
           real_T y[299245]);

/* End of code generation (xgemv.h) */
