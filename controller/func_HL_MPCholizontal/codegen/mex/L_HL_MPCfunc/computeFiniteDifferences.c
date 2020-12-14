/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeFiniteDifferences.c
 *
 * Code generation for function 'computeFiniteDifferences'
 *
 */

/* Include files */
#include "computeFiniteDifferences.h"
#include "L_HL_MPCfunc.h"
#include "finDiffEvalAndChkErr.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
boolean_T computeFiniteDifferences(h_struct_T *obj, real_T fCurrent, const
  real_T cIneqCurrent[20], const real_T cEqCurrent[88], real_T xk[110], real_T
  gradf[307], real_T JacCineqTrans[6140], real_T JacCeqTrans[27016])
{
  boolean_T evalOK;
  int32_T idx;
  boolean_T exitg1;
  real_T deltaX;
  struct0_T t0_objfun_tunableEnvironment[1];
  real_T c_t0_nonlin_tunableEnvironment_[8];
  real_T d_t0_nonlin_tunableEnvironment_[64];
  real_T e_t0_nonlin_tunableEnvironment_[16];
  boolean_T guard1 = false;
  int32_T idx_row;
  evalOK = true;
  obj->numEvals = 0;
  idx = 0;
  exitg1 = false;
  while ((!exitg1) && (idx < 110)) {
    deltaX = 1.4901161193847656E-8 * (1.0 - 2.0 * (real_T)(xk[idx] < 0.0)) *
      muDoubleScalarMax(muDoubleScalarAbs(xk[idx]), 1.0);
    t0_objfun_tunableEnvironment[0] = obj->objfun.tunableEnvironment[0];
    memcpy(&c_t0_nonlin_tunableEnvironment_[0],
           &obj->nonlin.tunableEnvironment.f1.X0[0], 8U * sizeof(real_T));
    memcpy(&d_t0_nonlin_tunableEnvironment_[0],
           &obj->nonlin.tunableEnvironment.f2.A[0], 64U * sizeof(real_T));
    memcpy(&e_t0_nonlin_tunableEnvironment_[0],
           &obj->nonlin.tunableEnvironment.f2.B[0], 16U * sizeof(real_T));
    evalOK = finDiffEvalAndChkErr(t0_objfun_tunableEnvironment,
      c_t0_nonlin_tunableEnvironment_, obj->nonlin.tunableEnvironment.f1.Slew,
      d_t0_nonlin_tunableEnvironment_, e_t0_nonlin_tunableEnvironment_,
      &obj->f_1, obj->cIneq_1, obj->cEq_1, idx + 1, deltaX, xk);
    obj->numEvals++;
    guard1 = false;
    if (!evalOK) {
      deltaX = -deltaX;
      t0_objfun_tunableEnvironment[0] = obj->objfun.tunableEnvironment[0];
      memcpy(&c_t0_nonlin_tunableEnvironment_[0],
             &obj->nonlin.tunableEnvironment.f1.X0[0], 8U * sizeof(real_T));
      memcpy(&d_t0_nonlin_tunableEnvironment_[0],
             &obj->nonlin.tunableEnvironment.f2.A[0], 64U * sizeof(real_T));
      memcpy(&e_t0_nonlin_tunableEnvironment_[0],
             &obj->nonlin.tunableEnvironment.f2.B[0], 16U * sizeof(real_T));
      evalOK = finDiffEvalAndChkErr(t0_objfun_tunableEnvironment,
        c_t0_nonlin_tunableEnvironment_, obj->nonlin.tunableEnvironment.f1.Slew,
        d_t0_nonlin_tunableEnvironment_, e_t0_nonlin_tunableEnvironment_,
        &obj->f_1, obj->cIneq_1, obj->cEq_1, idx + 1, deltaX, xk);
      obj->numEvals++;
      if (!evalOK) {
        exitg1 = true;
      } else {
        guard1 = true;
      }
    } else {
      guard1 = true;
    }

    if (guard1) {
      gradf[idx] = (obj->f_1 - fCurrent) / deltaX;
      for (idx_row = 0; idx_row < 20; idx_row++) {
        JacCineqTrans[idx + 307 * idx_row] = (obj->cIneq_1[idx_row] -
          cIneqCurrent[idx_row]) / deltaX;
      }

      for (idx_row = 0; idx_row < 88; idx_row++) {
        JacCeqTrans[idx + 307 * idx_row] = (obj->cEq_1[idx_row] -
          cEqCurrent[idx_row]) / deltaX;
      }

      idx++;
    }
  }

  return evalOK;
}

/* End of code generation (computeFiniteDifferences.c) */
