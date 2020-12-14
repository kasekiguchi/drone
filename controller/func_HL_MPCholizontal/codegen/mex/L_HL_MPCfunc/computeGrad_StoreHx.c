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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include "xaxpy.h"
#include "xgemv.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo he_emlrtRSI = { 1,  /* lineNo */
  "computeGrad_StoreHx",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeGrad_StoreHx.p"/* pathName */
};

static emlrtBCInfo wc_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGrad_StoreHx",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeGrad_StoreHx.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo xc_emlrtBCI = { 1,  /* iFirst */
  306,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGrad_StoreHx",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeGrad_StoreHx.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void computeGrad_StoreHx(const emlrtStack *sp, j_struct_T *obj, const real_T H
  [12100], const real_T f[307], const real_T x[307])
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
    st.site = &he_emlrtRSI;
    i = obj->nvar - 1;
    if ((1 <= i) && (i > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    if (0 <= iy - 2) {
      memset(&obj->grad[0], 0, (iy + -1) * sizeof(real_T));
    }

    if ((obj->nvar < 1) || (obj->nvar > 307)) {
      emlrtDynamicBoundsCheckR2012b(obj->nvar, 1, 307, &wc_emlrtBCI, sp);
    }

    obj->grad[obj->nvar - 1] = obj->gammaScalar;
    break;

   case 3:
    st.site = &he_emlrtRSI;
    l_xgemv(obj->nvar, obj->nvar, H, obj->nvar, x, obj->Hx);
    iy = obj->nvar;
    st.site = &he_emlrtRSI;
    if ((1 <= obj->nvar) && (obj->nvar > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (b_i = 0; b_i < iy; b_i++) {
      i = b_i + 1;
      if ((i < 1) || (i > 306)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 306, &xc_emlrtBCI, sp);
      }

      obj->grad[b_i] = obj->Hx[i - 1];
    }

    if (obj->hasLinear) {
      st.site = &he_emlrtRSI;
      b_xaxpy(obj->nvar, 1.0, f, obj->grad);
    }
    break;

   case 4:
    st.site = &he_emlrtRSI;
    l_xgemv(obj->nvar, obj->nvar, H, obj->nvar, x, obj->Hx);
    i = obj->nvar + 1;
    st.site = &he_emlrtRSI;
    for (iy = i; iy < 307; iy++) {
      obj->Hx[iy - 1] = obj->beta * x[iy - 1];
    }

    st.site = &he_emlrtRSI;
    memcpy(&obj->grad[0], &obj->Hx[0], 306U * sizeof(real_T));
    if (obj->hasLinear) {
      st.site = &he_emlrtRSI;
      b_xaxpy(obj->nvar, 1.0, f, obj->grad);
    }

    if (306 - obj->nvar >= 1) {
      iy = obj->nvar;
      i = 305 - obj->nvar;
      for (b_i = 0; b_i <= i; b_i++) {
        obj->grad[iy] += obj->rho;
        iy++;
      }
    }
    break;
  }
}

/* End of code generation (computeGrad_StoreHx.c) */
