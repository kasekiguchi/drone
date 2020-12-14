/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * maxConstraintViolation.c
 *
 * Code generation for function 'maxConstraintViolation'
 *
 */

/* Include files */
#include "maxConstraintViolation.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xgemv.h"
#include <string.h>

/* Function Definitions */
real_T b_maxConstraintViolation(const emlrtStack *sp, g_struct_T *obj, const
  real_T x[307])
{
  real_T v;
  int32_T mLB;
  int32_T idx;
  int32_T idxLB;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  mLB = obj->sizes[3];
  switch (obj->probType) {
   case 2:
    st.site = &wd_emlrtRSI;
    v = 0.0;
    memcpy(&obj->maxConstrWorkspace[0], &obj->bineq[0], 20U * sizeof(real_T));
    i_xgemv(obj->Aineq, x, obj->maxConstrWorkspace);
    for (idx = 0; idx < 20; idx++) {
      obj->maxConstrWorkspace[idx] -= x[idx + 110];
      v = muDoubleScalarMax(v, obj->maxConstrWorkspace[idx]);
    }

    memcpy(&obj->maxConstrWorkspace[0], &obj->beq[0], 88U * sizeof(real_T));
    j_xgemv(110, obj->Aeq, x, obj->maxConstrWorkspace);
    for (idx = 0; idx < 88; idx++) {
      obj->maxConstrWorkspace[idx] = (obj->maxConstrWorkspace[idx] - x[idx + 130])
        + x[idx + 218];
      v = muDoubleScalarMax(v, muDoubleScalarAbs(obj->maxConstrWorkspace[idx]));
    }
    break;

   default:
    st.site = &wd_emlrtRSI;
    v = 0.0;
    memcpy(&obj->maxConstrWorkspace[0], &obj->bineq[0], 20U * sizeof(real_T));
    k_xgemv(obj->nVar, obj->Aineq, x, obj->maxConstrWorkspace);
    for (idx = 0; idx < 20; idx++) {
      v = muDoubleScalarMax(v, obj->maxConstrWorkspace[idx]);
    }

    memcpy(&obj->maxConstrWorkspace[0], &obj->beq[0], 88U * sizeof(real_T));
    j_xgemv(obj->nVar, obj->Aeq, x, obj->maxConstrWorkspace);
    for (idx = 0; idx < 88; idx++) {
      v = muDoubleScalarMax(v, muDoubleScalarAbs(obj->maxConstrWorkspace[idx]));
    }
    break;
  }

  if (obj->sizes[3] > 0) {
    st.site = &wd_emlrtRSI;
    if ((1 <= obj->sizes[3]) && (obj->sizes[3] > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mLB; idx++) {
      idxLB = obj->indexLB[idx] - 1;
      if ((obj->indexLB[idx] < 1) || (obj->indexLB[idx] > 307)) {
        emlrtDynamicBoundsCheckR2012b(obj->indexLB[idx], 1, 307, &ec_emlrtBCI,
          sp);
      }

      if ((obj->indexLB[idx] < 1) || (obj->indexLB[idx] > 307)) {
        emlrtDynamicBoundsCheckR2012b(obj->indexLB[idx], 1, 307, &ec_emlrtBCI,
          sp);
      }

      v = muDoubleScalarMax(v, -x[idxLB] - obj->lb[idxLB]);
    }
  }

  return v;
}

real_T maxConstraintViolation(const emlrtStack *sp, g_struct_T *obj, const
  real_T x[94249])
{
  real_T v;
  int32_T mLB;
  int32_T idx;
  int32_T idxLB;
  int32_T i;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  mLB = obj->sizes[3];
  switch (obj->probType) {
   case 2:
    st.site = &wd_emlrtRSI;
    v = 0.0;
    memcpy(&obj->maxConstrWorkspace[0], &obj->bineq[0], 20U * sizeof(real_T));
    f_xgemv(obj->Aineq, x, obj->maxConstrWorkspace);
    for (idx = 0; idx < 20; idx++) {
      obj->maxConstrWorkspace[idx] -= x[idx + 417];
      v = muDoubleScalarMax(v, obj->maxConstrWorkspace[idx]);
    }

    memcpy(&obj->maxConstrWorkspace[0], &obj->beq[0], 88U * sizeof(real_T));
    g_xgemv(110, obj->Aeq, x, obj->maxConstrWorkspace);
    for (idx = 0; idx < 88; idx++) {
      obj->maxConstrWorkspace[idx] = (obj->maxConstrWorkspace[idx] - x[idx + 437])
        + x[idx + 525];
      v = muDoubleScalarMax(v, muDoubleScalarAbs(obj->maxConstrWorkspace[idx]));
    }
    break;

   default:
    st.site = &wd_emlrtRSI;
    v = 0.0;
    memcpy(&obj->maxConstrWorkspace[0], &obj->bineq[0], 20U * sizeof(real_T));
    h_xgemv(obj->nVar, obj->Aineq, x, obj->maxConstrWorkspace);
    for (idx = 0; idx < 20; idx++) {
      v = muDoubleScalarMax(v, obj->maxConstrWorkspace[idx]);
    }

    memcpy(&obj->maxConstrWorkspace[0], &obj->beq[0], 88U * sizeof(real_T));
    g_xgemv(obj->nVar, obj->Aeq, x, obj->maxConstrWorkspace);
    for (idx = 0; idx < 88; idx++) {
      v = muDoubleScalarMax(v, muDoubleScalarAbs(obj->maxConstrWorkspace[idx]));
    }
    break;
  }

  if (obj->sizes[3] > 0) {
    st.site = &wd_emlrtRSI;
    if ((1 <= obj->sizes[3]) && (obj->sizes[3] > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mLB; idx++) {
      idxLB = obj->indexLB[idx];
      i = obj->indexLB[idx] + 307;
      if ((i < 1) || (i > 94249)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 94249, &fc_emlrtBCI, sp);
      }

      if ((obj->indexLB[idx] < 1) || (obj->indexLB[idx] > 307)) {
        emlrtDynamicBoundsCheckR2012b(obj->indexLB[idx], 1, 307, &ec_emlrtBCI,
          sp);
      }

      v = muDoubleScalarMax(v, -x[idxLB + 306] - obj->lb[idxLB - 1]);
    }
  }

  return v;
}

/* End of code generation (maxConstraintViolation.c) */
