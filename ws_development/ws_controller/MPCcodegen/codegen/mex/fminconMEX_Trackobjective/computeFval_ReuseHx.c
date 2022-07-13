/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeFval_ReuseHx.c
 *
 * Code generation for function 'computeFval_ReuseHx'
 *
 */

/* Include files */
#include "computeFval_ReuseHx.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xdot.h"
#include "blas.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo le_emlrtRSI = { 1,  /* lineNo */
  "computeFval_ReuseHx",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeFval_ReuseHx.p"/* pathName */
};

static emlrtBCInfo yc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeFval_ReuseHx",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeFval_ReuseHx.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
real_T computeFval_ReuseHx(const emlrtStack *sp, const i_struct_T *obj,
  emxArray_real_T *workspace, const emxArray_real_T *f, const emxArray_real_T *x)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  emlrtStack b_st;
  emlrtStack st;
  real_T val;
  int32_T b;
  int32_T b_i;
  int32_T i;
  int32_T idx;
  int32_T maxRegVar;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  val = 0.0;
  switch (obj->objtype) {
   case 5:
    if ((obj->nvar < 1) || (obj->nvar > x->size[0])) {
      emlrtDynamicBoundsCheckR2012b(obj->nvar, 1, x->size[0], &yc_emlrtBCI, sp);
    }

    val = obj->gammaScalar * x->data[obj->nvar - 1];
    break;

   case 3:
    if (obj->hasLinear) {
      b = obj->nvar;
      st.site = &le_emlrtRSI;
      if ((1 <= obj->nvar) && (obj->nvar > 2147483646)) {
        b_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (i = 0; i < b; i++) {
        idx = obj->Hx->size[0];
        if ((i + 1 < 1) || (i + 1 > idx)) {
          emlrtDynamicBoundsCheckR2012b(i + 1, 1, idx, &yc_emlrtBCI, sp);
        }

        if ((i + 1 < 1) || (i + 1 > f->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i + 1, 1, f->size[0], &yc_emlrtBCI, sp);
        }

        idx = workspace->size[0] * workspace->size[1];
        if ((i + 1 < 1) || (i + 1 > idx)) {
          emlrtDynamicBoundsCheckR2012b(i + 1, 1, idx, &yc_emlrtBCI, sp);
        }

        workspace->data[i] = 0.5 * obj->Hx->data[i] + f->data[i];
      }

      if (obj->nvar >= 1) {
        n_t = (ptrdiff_t)obj->nvar;
        incx_t = (ptrdiff_t)1;
        incy_t = (ptrdiff_t)1;
        val = ddot(&n_t, &x->data[0], &incx_t, &workspace->data[0], &incy_t);
      }
    } else {
      val = 0.5 * b_xdot(obj->nvar, x, obj->Hx);
    }
    break;

   case 4:
    maxRegVar = obj->maxVar - 1;
    if (obj->hasLinear) {
      b = obj->nvar;
      st.site = &le_emlrtRSI;
      if ((1 <= obj->nvar) && (obj->nvar > 2147483646)) {
        b_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (i = 0; i < b; i++) {
        if ((i + 1 < 1) || (i + 1 > f->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i + 1, 1, f->size[0], &yc_emlrtBCI, sp);
        }

        idx = workspace->size[0] * workspace->size[1];
        if ((i + 1 < 1) || (i + 1 > idx)) {
          emlrtDynamicBoundsCheckR2012b(i + 1, 1, idx, &yc_emlrtBCI, sp);
        }

        workspace->data[i] = f->data[i];
      }

      b = (obj->maxVar - obj->nvar) - 1;
      st.site = &le_emlrtRSI;
      if ((1 <= b) && (b > 2147483646)) {
        b_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (i = 0; i < b; i++) {
        idx = workspace->size[0] * workspace->size[1];
        b_i = (obj->nvar + i) + 1;
        if ((b_i < 1) || (b_i > idx)) {
          emlrtDynamicBoundsCheckR2012b(b_i, 1, idx, &yc_emlrtBCI, sp);
        }

        workspace->data[b_i - 1] = obj->rho;
      }

      st.site = &le_emlrtRSI;
      if ((1 <= obj->maxVar - 1) && (obj->maxVar - 1 > 2147483646)) {
        b_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (i = 0; i < maxRegVar; i++) {
        idx = workspace->size[0] * workspace->size[1];
        if ((i + 1 < 1) || (i + 1 > idx)) {
          emlrtDynamicBoundsCheckR2012b(i + 1, 1, idx, &yc_emlrtBCI, sp);
        }

        idx = obj->Hx->size[0];
        if ((i + 1 < 1) || (i + 1 > idx)) {
          emlrtDynamicBoundsCheckR2012b(i + 1, 1, idx, &yc_emlrtBCI, sp);
        }

        idx = workspace->size[0] * workspace->size[1];
        if ((i + 1 < 1) || (i + 1 > idx)) {
          emlrtDynamicBoundsCheckR2012b(i + 1, 1, idx, &yc_emlrtBCI, sp);
        }

        workspace->data[i] += 0.5 * obj->Hx->data[i];
      }

      if (obj->maxVar - 1 >= 1) {
        n_t = (ptrdiff_t)(obj->maxVar - 1);
        incx_t = (ptrdiff_t)1;
        incy_t = (ptrdiff_t)1;
        val = ddot(&n_t, &x->data[0], &incx_t, &workspace->data[0], &incy_t);
      }
    } else {
      val = 0.5 * b_xdot(obj->maxVar - 1, x, obj->Hx);
      b = obj->nvar + 1;
      st.site = &le_emlrtRSI;
      if ((obj->nvar + 1 <= obj->maxVar - 1) && (obj->maxVar - 1 > 2147483646))
      {
        b_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idx = b; idx <= maxRegVar; idx++) {
        if ((idx < 1) || (idx > x->size[0])) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, x->size[0], &yc_emlrtBCI, sp);
        }

        val += x->data[idx - 1] * obj->rho;
      }
    }
    break;
  }

  return val;
}

/* End of code generation (computeFval_ReuseHx.c) */
