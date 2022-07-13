/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * squareQ_appendCol.c
 *
 * Code generation for function 'squareQ_appendCol'
 *
 */

/* Include files */
#include "squareQ_appendCol.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xgemv.h"
#include "xrot.h"
#include "blas.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo me_emlrtRSI = { 1,  /* lineNo */
  "squareQ_appendCol",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\squareQ_appendCol.p"/* pathName */
};

static emlrtBCInfo ad_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "squareQ_appendCol",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\squareQ_appendCol.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void squareQ_appendCol(const emlrtStack *sp, g_struct_T *obj, const
  emxArray_real_T *vec, int32_T iv0)
{
  emlrtStack st;
  real_T c;
  real_T d;
  real_T d1;
  real_T s;
  int32_T Qk0;
  int32_T idx;
  st.prev = sp;
  st.tls = sp->tls;
  Qk0 = obj->ncols + 1;
  obj->minRowCol = muIntScalarMin_sint32(obj->mrows, Qk0);
  h_xgemv(obj->mrows, obj->mrows, obj->Q, obj->ldq, vec, iv0, obj->QR, obj->ldq *
          obj->ncols + 1);
  obj->ncols++;
  Qk0 = obj->jpvt->size[0];
  if ((obj->ncols < 1) || (obj->ncols > Qk0)) {
    emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, Qk0, &ad_emlrtBCI, sp);
  }

  obj->jpvt->data[obj->ncols - 1] = obj->ncols;
  for (idx = obj->mrows; idx > obj->ncols; idx--) {
    st.site = &me_emlrtRSI;
    Qk0 = obj->QR->size[0];
    if ((idx - 1 < 1) || (idx - 1 > Qk0)) {
      emlrtDynamicBoundsCheckR2012b(idx - 1, 1, Qk0, &ad_emlrtBCI, &st);
    }

    Qk0 = obj->QR->size[1];
    if ((obj->ncols < 1) || (obj->ncols > Qk0)) {
      emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, Qk0, &ad_emlrtBCI, &st);
    }

    d = obj->QR->data[(idx + obj->QR->size[0] * (obj->ncols - 1)) - 2];
    Qk0 = obj->QR->size[0];
    if ((idx < 1) || (idx > Qk0)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, Qk0, &ad_emlrtBCI, &st);
    }

    Qk0 = obj->QR->size[1];
    if ((obj->ncols < 1) || (obj->ncols > Qk0)) {
      emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, Qk0, &ad_emlrtBCI, &st);
    }

    d1 = obj->QR->data[(idx + obj->QR->size[0] * (obj->ncols - 1)) - 1];
    c = 0.0;
    s = 0.0;
    drotg(&d, &d1, &c, &s);
    Qk0 = obj->QR->size[0];
    if ((idx - 1 < 1) || (idx - 1 > Qk0)) {
      emlrtDynamicBoundsCheckR2012b(idx - 1, 1, Qk0, &ad_emlrtBCI, sp);
    }

    Qk0 = obj->QR->size[1];
    if ((obj->ncols < 1) || (obj->ncols > Qk0)) {
      emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, Qk0, &ad_emlrtBCI, sp);
    }

    obj->QR->data[(idx + obj->QR->size[0] * (obj->ncols - 1)) - 2] = d;
    Qk0 = obj->QR->size[0];
    if (idx > Qk0) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, Qk0, &ad_emlrtBCI, sp);
    }

    Qk0 = obj->QR->size[1];
    if ((obj->ncols < 1) || (obj->ncols > Qk0)) {
      emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, Qk0, &ad_emlrtBCI, sp);
    }

    obj->QR->data[(idx + obj->QR->size[0] * (obj->ncols - 1)) - 1] = d1;
    Qk0 = obj->ldq * (idx - 2) + 1;
    xrot(obj->mrows, obj->Q, Qk0, obj->ldq + Qk0, c, s);
  }
}

/* End of code generation (squareQ_appendCol.c) */
