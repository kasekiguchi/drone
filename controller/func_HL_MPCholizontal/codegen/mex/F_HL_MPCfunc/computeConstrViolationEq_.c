/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeConstrViolationEq_.c
 *
 * Code generation for function 'computeConstrViolationEq_'
 *
 */

/* Include files */
#include "computeConstrViolationEq_.h"
#include "F_HL_MPCfunc.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Function Definitions */
real_T computeConstrViolationEq_(const real_T eq_workspace[88])
{
  real_T normResid;
  int32_T k;
  normResid = 0.0;
  for (k = 0; k < 88; k++) {
    normResid += muDoubleScalarAbs(eq_workspace[k]);
  }

  return normResid;
}

/* End of code generation (computeConstrViolationEq_.c) */
