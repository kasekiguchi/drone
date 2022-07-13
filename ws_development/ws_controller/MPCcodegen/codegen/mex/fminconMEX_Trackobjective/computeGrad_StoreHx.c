/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeGrad_StoreHx.c
 *
 * Code generation for function 'computeGrad_StoreHx'
 *
 */

/* Include files */
#include "computeGrad_StoreHx.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xaxpy.h"
#include "xgemv.h"

/* Variable Definitions */
static emlrtRSInfo ke_emlrtRSI = { 1,  /* lineNo */
  "computeGrad_StoreHx",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeGrad_StoreHx.p"/* pathName */
};

static emlrtBCInfo xc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGrad_StoreHx",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeGrad_StoreHx.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void computeGrad_StoreHx(const emlrtStack *sp, i_struct_T *obj, const real_T H
  [4356], const emxArray_real_T *f, const emxArray_real_T *x)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T b;
  int32_T b_i;
  int32_T i;
  int32_T maxRegVar;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  switch (obj->objtype) {
   case 5:
    b = obj->nvar;
    st.site = &ke_emlrtRSI;
    if ((1 <= obj->nvar - 1) && (obj->nvar - 1 > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (i = 0; i <= b - 2; i++) {
      b_i = obj->grad->size[0];
      if ((i + 1 < 1) || (i + 1 > b_i)) {
        emlrtDynamicBoundsCheckR2012b(i + 1, 1, b_i, &xc_emlrtBCI, sp);
      }

      obj->grad->data[i] = 0.0;
    }

    b_i = obj->grad->size[0];
    if ((obj->nvar < 1) || (obj->nvar > b_i)) {
      emlrtDynamicBoundsCheckR2012b(obj->nvar, 1, b_i, &xc_emlrtBCI, sp);
    }

    obj->grad->data[obj->nvar - 1] = obj->gammaScalar;
    break;

   case 3:
    st.site = &ke_emlrtRSI;
    g_xgemv(obj->nvar, obj->nvar, H, obj->nvar, x, obj->Hx);
    b = obj->nvar;
    st.site = &ke_emlrtRSI;
    if ((1 <= obj->nvar) && (obj->nvar > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (i = 0; i < b; i++) {
      b_i = obj->Hx->size[0];
      if ((i + 1 < 1) || (i + 1 > b_i)) {
        emlrtDynamicBoundsCheckR2012b(i + 1, 1, b_i, &xc_emlrtBCI, sp);
      }

      b_i = obj->grad->size[0];
      if ((i + 1 < 1) || (i + 1 > b_i)) {
        emlrtDynamicBoundsCheckR2012b(i + 1, 1, b_i, &xc_emlrtBCI, sp);
      }

      obj->grad->data[i] = obj->Hx->data[i];
    }

    if (obj->hasLinear) {
      st.site = &ke_emlrtRSI;
      xaxpy(obj->nvar, 1.0, f, obj->grad);
    }
    break;

   case 4:
    maxRegVar = obj->maxVar - 1;
    st.site = &ke_emlrtRSI;
    g_xgemv(obj->nvar, obj->nvar, H, obj->nvar, x, obj->Hx);
    b = obj->nvar + 1;
    st.site = &ke_emlrtRSI;
    if ((obj->nvar + 1 <= obj->maxVar - 1) && (obj->maxVar - 1 > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (i = b; i <= maxRegVar; i++) {
      if ((i < 1) || (i > x->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i, 1, x->size[0], &xc_emlrtBCI, sp);
      }

      b_i = obj->Hx->size[0];
      if (i > b_i) {
        emlrtDynamicBoundsCheckR2012b(i, 1, b_i, &xc_emlrtBCI, sp);
      }

      obj->Hx->data[i - 1] = obj->beta * x->data[i - 1];
    }

    st.site = &ke_emlrtRSI;
    if ((1 <= obj->maxVar - 1) && (obj->maxVar - 1 > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (i = 0; i < maxRegVar; i++) {
      b_i = obj->Hx->size[0];
      if ((i + 1 < 1) || (i + 1 > b_i)) {
        emlrtDynamicBoundsCheckR2012b(i + 1, 1, b_i, &xc_emlrtBCI, sp);
      }

      b_i = obj->grad->size[0];
      if ((i + 1 < 1) || (i + 1 > b_i)) {
        emlrtDynamicBoundsCheckR2012b(i + 1, 1, b_i, &xc_emlrtBCI, sp);
      }

      obj->grad->data[i] = obj->Hx->data[i];
    }

    if (obj->hasLinear) {
      st.site = &ke_emlrtRSI;
      xaxpy(obj->nvar, 1.0, f, obj->grad);
    }

    b = (obj->maxVar - obj->nvar) - 1;
    if (b >= 1) {
      maxRegVar = obj->nvar;
      b_i = b - 1;
      for (b = 0; b <= b_i; b++) {
        obj->grad->data[maxRegVar] += obj->rho;
        maxRegVar++;
      }
    }
    break;
  }
}

/* End of code generation (computeGrad_StoreHx.c) */
