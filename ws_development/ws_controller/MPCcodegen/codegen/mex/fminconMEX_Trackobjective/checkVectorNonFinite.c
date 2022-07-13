/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * checkVectorNonFinite.c
 *
 * Code generation for function 'checkVectorNonFinite'
 *
 */

/* Include files */
#include "checkVectorNonFinite.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtBCInfo p_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "checkVectorNonFinite",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\+internal\\checkVectorNonFinite.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
int32_T checkVectorNonFinite(const emlrtStack *sp, int32_T N, const
  emxArray_real_T *vec, int32_T iv0)
{
  real_T d;
  int32_T idx_current;
  int32_T idx_end;
  int32_T status;
  boolean_T allFinite;
  status = 1;
  allFinite = true;
  idx_current = iv0 - 1;
  idx_end = (iv0 + N) - 1;
  while (allFinite && (idx_current + 1 <= idx_end)) {
    if ((idx_current + 1 < 1) || (idx_current + 1 > vec->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx_current + 1, 1, vec->size[0],
        &p_emlrtBCI, sp);
    }

    allFinite = ((!muDoubleScalarIsInf(vec->data[idx_current])) &&
                 (!muDoubleScalarIsNaN(vec->data[idx_current])));
    idx_current++;
  }

  if (!allFinite) {
    if ((idx_current < 1) || (idx_current > vec->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx_current, 1, vec->size[0], &p_emlrtBCI,
        sp);
    }

    d = vec->data[idx_current - 1];
    if (muDoubleScalarIsNaN(d)) {
      status = -3;
    } else {
      if (idx_current > vec->size[0]) {
        emlrtDynamicBoundsCheckR2012b(idx_current, 1, vec->size[0], &p_emlrtBCI,
          sp);
      }

      if (d < 0.0) {
        status = -1;
      } else {
        status = -2;
      }
    }
  }

  return status;
}

/* End of code generation (checkVectorNonFinite.c) */
