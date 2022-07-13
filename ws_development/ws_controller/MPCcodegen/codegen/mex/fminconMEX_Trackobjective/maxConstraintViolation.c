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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgemv.h"
#include "mwmathutil.h"

/* Function Definitions */
real_T b_maxConstraintViolation(const emlrtStack *sp, j_struct_T *obj, const
  emxArray_real_T *x)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T v;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T idx;
  int32_T mEq;
  int32_T mIneq;
  int32_T mLB;
  int32_T offsetEq2;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  mLB = obj->sizes[3];
  switch (obj->probType) {
   case 2:
    st.site = &be_emlrtRSI;
    v = 0.0;
    mIneq = obj->sizes[2];
    mEq = obj->sizes[1];
    if ((obj->Aineq->size[0] != 0) && (obj->Aineq->size[1] != 0)) {
      b_st.site = &ce_emlrtRSI;
      b_xcopy(obj->sizes[2], obj->bineq, obj->maxConstrWorkspace);
      b_st.site = &ce_emlrtRSI;
      d_xgemv(obj->sizes[2], obj->Aineq, obj->ldA, x, obj->maxConstrWorkspace);
      b_st.site = &ce_emlrtRSI;
      if ((1 <= obj->sizes[2]) && (obj->sizes[2] > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < mIneq; idx++) {
        i = obj->maxConstrWorkspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
        }

        if ((idx + 67 < 1) || (idx + 67 > x->size[0])) {
          emlrtDynamicBoundsCheckR2012b(idx + 67, 1, x->size[0], &kc_emlrtBCI,
            &st);
        }

        i = obj->maxConstrWorkspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
        }

        obj->maxConstrWorkspace->data[idx] -= x->data[idx + 66];
        i = obj->maxConstrWorkspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
        }

        v = muDoubleScalarMax(v, obj->maxConstrWorkspace->data[idx]);
      }
    }

    b_st.site = &ce_emlrtRSI;
    b_xcopy(obj->sizes[1], obj->beq, obj->maxConstrWorkspace);
    b_st.site = &ce_emlrtRSI;
    d_xgemv(obj->sizes[1], obj->Aeq, obj->ldA, x, obj->maxConstrWorkspace);
    offsetEq2 = (obj->sizes[2] + obj->sizes[1]) + 66;
    b_st.site = &ce_emlrtRSI;
    if ((1 <= obj->sizes[1]) && (obj->sizes[1] > 2147483646)) {
      c_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < mEq; idx++) {
      i = obj->maxConstrWorkspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
      }

      i = (mIneq + idx) + 67;
      if ((i < 1) || (i > x->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, x->size[0], &kc_emlrtBCI, &st);
      }

      i1 = (offsetEq2 + idx) + 1;
      if ((i1 < 1) || (i1 > x->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, x->size[0], &kc_emlrtBCI, &st);
      }

      i2 = obj->maxConstrWorkspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i2)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i2, &kc_emlrtBCI, &st);
      }

      obj->maxConstrWorkspace->data[idx] = (obj->maxConstrWorkspace->data[idx] -
        x->data[i - 1]) + x->data[i1 - 1];
      i = obj->maxConstrWorkspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
      }

      v = muDoubleScalarMax(v, muDoubleScalarAbs(obj->maxConstrWorkspace->
        data[idx]));
    }
    break;

   default:
    st.site = &be_emlrtRSI;
    v = 0.0;
    mIneq = obj->sizes[2];
    mEq = obj->sizes[1];
    if ((obj->Aineq->size[0] != 0) && (obj->Aineq->size[1] != 0)) {
      b_st.site = &de_emlrtRSI;
      b_xcopy(obj->sizes[2], obj->bineq, obj->maxConstrWorkspace);
      b_st.site = &de_emlrtRSI;
      e_xgemv(obj->nVar, obj->sizes[2], obj->Aineq, obj->ldA, x,
              obj->maxConstrWorkspace);
      b_st.site = &de_emlrtRSI;
      if ((1 <= obj->sizes[2]) && (obj->sizes[2] > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < mIneq; idx++) {
        i = obj->maxConstrWorkspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &jc_emlrtBCI, &st);
        }

        v = muDoubleScalarMax(v, obj->maxConstrWorkspace->data[idx]);
      }
    }

    b_st.site = &de_emlrtRSI;
    b_xcopy(obj->sizes[1], obj->beq, obj->maxConstrWorkspace);
    b_st.site = &de_emlrtRSI;
    e_xgemv(obj->nVar, obj->sizes[1], obj->Aeq, obj->ldA, x,
            obj->maxConstrWorkspace);
    b_st.site = &de_emlrtRSI;
    if ((1 <= obj->sizes[1]) && (obj->sizes[1] > 2147483646)) {
      c_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < mEq; idx++) {
      i = obj->maxConstrWorkspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &jc_emlrtBCI, &st);
      }

      v = muDoubleScalarMax(v, muDoubleScalarAbs(obj->maxConstrWorkspace->
        data[idx]));
    }
    break;
  }

  if (obj->sizes[3] > 0) {
    st.site = &be_emlrtRSI;
    if ((1 <= obj->sizes[3]) && (obj->sizes[3] > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mLB; idx++) {
      i = obj->indexLB->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &ic_emlrtBCI, sp);
      }

      mIneq = obj->indexLB->data[idx] - 1;
      if ((obj->indexLB->data[idx] < 1) || (obj->indexLB->data[idx] > x->size[0]))
      {
        emlrtDynamicBoundsCheckR2012b(obj->indexLB->data[idx], 1, x->size[0],
          &ic_emlrtBCI, sp);
      }

      i = obj->lb->size[0];
      if ((obj->indexLB->data[idx] < 1) || (obj->indexLB->data[idx] > i)) {
        emlrtDynamicBoundsCheckR2012b(obj->indexLB->data[idx], 1, i,
          &ic_emlrtBCI, sp);
      }

      v = muDoubleScalarMax(v, -x->data[mIneq] - obj->lb->data[mIneq]);
    }
  }

  return v;
}

real_T maxConstraintViolation(const emlrtStack *sp, j_struct_T *obj, const
  emxArray_real_T *x, int32_T ix0)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T v;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T idx;
  int32_T mEq;
  int32_T mIneq;
  int32_T mLB;
  int32_T offsetEq2;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  mLB = obj->sizes[3];
  switch (obj->probType) {
   case 2:
    st.site = &be_emlrtRSI;
    v = 0.0;
    mIneq = obj->sizes[2];
    mEq = obj->sizes[1];
    if ((obj->Aineq->size[0] != 0) && (obj->Aineq->size[1] != 0)) {
      b_st.site = &ce_emlrtRSI;
      b_xcopy(obj->sizes[2], obj->bineq, obj->maxConstrWorkspace);
      b_st.site = &ce_emlrtRSI;
      f_xgemv(66, obj->sizes[2], obj->Aineq, obj->ldA, x, ix0,
              obj->maxConstrWorkspace);
      b_st.site = &ce_emlrtRSI;
      if ((1 <= obj->sizes[2]) && (obj->sizes[2] > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < mIneq; idx++) {
        i = obj->maxConstrWorkspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
        }

        i = x->size[0] * x->size[1];
        i1 = (ix0 + idx) + 66;
        if ((i1 < 1) || (i1 > i)) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, i, &kc_emlrtBCI, &st);
        }

        i = obj->maxConstrWorkspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
        }

        obj->maxConstrWorkspace->data[idx] -= x->data[i1 - 1];
        i = obj->maxConstrWorkspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
        }

        v = muDoubleScalarMax(v, obj->maxConstrWorkspace->data[idx]);
      }
    }

    b_st.site = &ce_emlrtRSI;
    b_xcopy(obj->sizes[1], obj->beq, obj->maxConstrWorkspace);
    b_st.site = &ce_emlrtRSI;
    f_xgemv(66, obj->sizes[1], obj->Aeq, obj->ldA, x, ix0,
            obj->maxConstrWorkspace);
    offsetEq2 = (obj->sizes[2] + obj->sizes[1]) + 65;
    b_st.site = &ce_emlrtRSI;
    if ((1 <= obj->sizes[1]) && (obj->sizes[1] > 2147483646)) {
      c_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < mEq; idx++) {
      i = obj->maxConstrWorkspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
      }

      i = x->size[0] * x->size[1];
      i1 = ((ix0 + mIneq) + idx) + 66;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &kc_emlrtBCI, &st);
      }

      i = x->size[0] * x->size[1];
      i2 = ((ix0 + offsetEq2) + idx) + 1;
      if ((i2 < 1) || (i2 > i)) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, i, &kc_emlrtBCI, &st);
      }

      i = obj->maxConstrWorkspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
      }

      obj->maxConstrWorkspace->data[idx] = (obj->maxConstrWorkspace->data[idx] -
        x->data[i1 - 1]) + x->data[i2 - 1];
      i = obj->maxConstrWorkspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &st);
      }

      v = muDoubleScalarMax(v, muDoubleScalarAbs(obj->maxConstrWorkspace->
        data[idx]));
    }
    break;

   default:
    st.site = &be_emlrtRSI;
    v = 0.0;
    mIneq = obj->sizes[2];
    mEq = obj->sizes[1];
    if ((obj->Aineq->size[0] != 0) && (obj->Aineq->size[1] != 0)) {
      b_st.site = &de_emlrtRSI;
      b_xcopy(obj->sizes[2], obj->bineq, obj->maxConstrWorkspace);
      b_st.site = &de_emlrtRSI;
      f_xgemv(obj->nVar, obj->sizes[2], obj->Aineq, obj->ldA, x, ix0,
              obj->maxConstrWorkspace);
      b_st.site = &de_emlrtRSI;
      if ((1 <= obj->sizes[2]) && (obj->sizes[2] > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < mIneq; idx++) {
        i = obj->maxConstrWorkspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &jc_emlrtBCI, &st);
        }

        v = muDoubleScalarMax(v, obj->maxConstrWorkspace->data[idx]);
      }
    }

    b_st.site = &de_emlrtRSI;
    b_xcopy(obj->sizes[1], obj->beq, obj->maxConstrWorkspace);
    b_st.site = &de_emlrtRSI;
    f_xgemv(obj->nVar, obj->sizes[1], obj->Aeq, obj->ldA, x, ix0,
            obj->maxConstrWorkspace);
    b_st.site = &de_emlrtRSI;
    if ((1 <= obj->sizes[1]) && (obj->sizes[1] > 2147483646)) {
      c_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&c_st);
    }

    for (idx = 0; idx < mEq; idx++) {
      i = obj->maxConstrWorkspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &jc_emlrtBCI, &st);
      }

      v = muDoubleScalarMax(v, muDoubleScalarAbs(obj->maxConstrWorkspace->
        data[idx]));
    }
    break;
  }

  if (obj->sizes[3] > 0) {
    st.site = &be_emlrtRSI;
    if ((1 <= obj->sizes[3]) && (obj->sizes[3] > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mLB; idx++) {
      i = obj->indexLB->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &ic_emlrtBCI, sp);
      }

      i = x->size[0] * x->size[1];
      i1 = (ix0 + obj->indexLB->data[idx]) - 1;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &ic_emlrtBCI, sp);
      }

      i = obj->lb->size[0];
      if ((obj->indexLB->data[idx] < 1) || (obj->indexLB->data[idx] > i)) {
        emlrtDynamicBoundsCheckR2012b(obj->indexLB->data[idx], 1, i,
          &ic_emlrtBCI, sp);
      }

      v = muDoubleScalarMax(v, -x->data[i1 - 1] - obj->lb->data[obj->
                            indexLB->data[idx] - 1]);
    }
  }

  return v;
}

/* End of code generation (maxConstraintViolation.c) */
