/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * solve.c
 *
 * Code generation for function 'solve'
 *
 */

/* Include files */
#include "solve.h"
#include "F_HL_MPCfunc.h"
#include "rt_nonfinite.h"
#include "xtrsv.h"

/* Function Definitions */
void b_solve(const l_struct_T *obj, real_T rhs[299245])
{
  d_xtrsv(obj->ndims, obj->FMat, rhs);
  xtrsv(obj->ndims, obj->FMat, rhs);
}

void solve(const l_struct_T *obj, real_T rhs[485])
{
  b_xtrsv(obj->ndims, obj->FMat, rhs);
  c_xtrsv(obj->ndims, obj->FMat, rhs);
}

/* End of code generation (solve.c) */
