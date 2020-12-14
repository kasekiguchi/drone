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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include "xaxpy.h"
#include "xgemv.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo xi_emlrtRSI = { 1,  /* lineNo */
  "computeGrad_StoreHx",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeGrad_StoreHx.p"/* pathName */
};

static emlrtBCInfo td_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGrad_StoreHx",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeGrad_StoreHx.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo ud_emlrtBCI = { 1,  /* iFirst */
  484,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGrad_StoreHx",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeGrad_StoreHx.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void computeGrad_StoreHx(const emlrtStack *sp, j_struct_T *obj, const real_T H
  [17424], const real_T f[485], const real_T x[485])
{
  int32_T iy;
  int32_T i;
  int32_T b_i;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  switch (obj->objtype) {
   case 5:
    iy = obj->nvar;
    st.site = &xi_emlrtRSI;
    i = obj->nvar - 1;
    if ((1 <= i) && (i > 2147483646)) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    if (0 <= iy - 2) {
      memset(&obj->grad[0], 0, (iy + -1) * sizeof(real_T));
    }

    if ((obj->nvar < 1) || (obj->nvar > 485)) {
      emlrtDynamicBoundsCheckR2012b(obj->nvar, 1, 485, &td_emlrtBCI, sp);
    }

    obj->grad[obj->nvar - 1] = obj->gammaScalar;
    break;

   case 3:
    st.site = &xi_emlrtRSI;
    l_xgemv(obj->nvar, obj->nvar, H, obj->nvar, x, obj->Hx);
    iy = obj->nvar;
    st.site = &xi_emlrtRSI;
    if ((1 <= obj->nvar) && (obj->nvar > 2147483646)) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (b_i = 0; b_i < iy; b_i++) {
      i = b_i + 1;
      if ((i < 1) || (i > 484)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 484, &ud_emlrtBCI, sp);
      }

      obj->grad[b_i] = obj->Hx[i - 1];
    }

    if (obj->hasLinear) {
      st.site = &xi_emlrtRSI;
      b_xaxpy(obj->nvar, 1.0, f, obj->grad);
    }
    break;

   case 4:
    st.site = &xi_emlrtRSI;
    l_xgemv(obj->nvar, obj->nvar, H, obj->nvar, x, obj->Hx);
    i = obj->nvar + 1;
    st.site = &xi_emlrtRSI;
    for (iy = i; iy < 485; iy++) {
      obj->Hx[iy - 1] = obj->beta * x[iy - 1];
    }

    st.site = &xi_emlrtRSI;
    memcpy(&obj->grad[0], &obj->Hx[0], 484U * sizeof(real_T));
    if (obj->hasLinear) {
      st.site = &xi_emlrtRSI;
      b_xaxpy(obj->nvar, 1.0, f, obj->grad);
    }

    if (484 - obj->nvar >= 1) {
      iy = obj->nvar;
      i = 483 - obj->nvar;
      for (b_i = 0; b_i <= i; b_i++) {
        obj->grad[iy] += obj->rho;
        iy++;
      }
    }
    break;
  }
}

/* End of code generation (computeGrad_StoreHx.c) */
