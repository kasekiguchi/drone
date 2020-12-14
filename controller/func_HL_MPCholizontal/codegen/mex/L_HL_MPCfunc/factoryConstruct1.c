/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factoryConstruct1.c
 *
 * Code generation for function 'factoryConstruct1'
 *
 */

/* Include files */
#include "factoryConstruct1.h"
#include "L_HL_MPCfunc.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
void b_factoryConstruct(k_struct_T *obj)
{
  obj->ldq = 307;
  memset(&obj->Q[0], 0, 94249U * sizeof(real_T));
  memset(&obj->jpvt[0], 0, 307U * sizeof(int32_T));
  obj->mrows = 0;
  obj->ncols = 0;
  obj->minRowCol = 0;
  obj->usedPivoting = false;
}

/* End of code generation (factoryConstruct1.c) */
