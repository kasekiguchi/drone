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
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xtrsv.h"

/* Function Definitions */
void b_solve(const h_struct_T *obj, emxArray_real_T *rhs)
{
  c_xtrsv(obj->ndims, obj->FMat, obj->ldm, rhs);
  xtrsv(obj->ndims, obj->FMat, obj->ldm, rhs);
}

void solve(const h_struct_T *obj, emxArray_real_T *rhs)
{
  b_xtrsv(obj->ndims, obj->FMat, obj->ldm, rhs);
  xtrsv(obj->ndims, obj->FMat, obj->ldm, rhs);
}

/* End of code generation (solve.c) */
