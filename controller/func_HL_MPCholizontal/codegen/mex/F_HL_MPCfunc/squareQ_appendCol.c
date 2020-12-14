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
#include "F_HL_MPCfunc.h"
#include "blas.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xgemv.h"
#include "xrot.h"

/* Variable Definitions */
static emlrtRSInfo aj_emlrtRSI = { 1,  /* lineNo */
  "squareQ_appendCol",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\squareQ_appendCol.p"/* pathName */
};

static emlrtBCInfo xd_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "squareQ_appendCol",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\squareQ_appendCol.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo yd_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "squareQ_appendCol",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\squareQ_appendCol.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void squareQ_appendCol(const emlrtStack *sp, k_struct_T *obj, const real_T vec
  [299245], int32_T iv0)
{
  int32_T Qk0;
  int32_T idx;
  int32_T a_tmp;
  real_T a;
  real_T b;
  real_T c;
  real_T s;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  Qk0 = obj->ncols + 1;
  obj->minRowCol = muIntScalarMin_sint32(obj->mrows, Qk0);
  m_xgemv(obj->mrows, obj->mrows, obj->Q, vec, iv0, obj->QR, 617 * obj->ncols +
          1);
  obj->ncols++;
  if ((obj->ncols < 1) || (obj->ncols > 617)) {
    emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, 617, &xd_emlrtBCI, sp);
  }

  obj->jpvt[obj->ncols - 1] = obj->ncols;
  for (idx = obj->mrows; idx > obj->ncols; idx--) {
    st.site = &aj_emlrtRSI;
    Qk0 = idx - 1;
    if ((Qk0 < 1) || (Qk0 > 617)) {
      emlrtDynamicBoundsCheckR2012b(Qk0, 1, 617, &yd_emlrtBCI, &st);
    }

    if ((obj->ncols < 1) || (obj->ncols > 617)) {
      emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, 617, &yd_emlrtBCI, &st);
    }

    a_tmp = 617 * (obj->ncols - 1);
    a = obj->QR[(Qk0 + a_tmp) - 1];
    if ((idx < 1) || (idx > 617)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &yd_emlrtBCI, &st);
    }

    if ((obj->ncols < 1) || (obj->ncols > 617)) {
      emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, 617, &yd_emlrtBCI, &st);
    }

    b = obj->QR[(idx + a_tmp) - 1];
    c = 0.0;
    s = 0.0;
    drotg(&a, &b, &c, &s);
    Qk0 = idx - 1;
    if (Qk0 < 1) {
      emlrtDynamicBoundsCheckR2012b(0, 1, 617, &xd_emlrtBCI, &st);
    }

    if ((obj->ncols < 1) || (obj->ncols > 617)) {
      emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, 617, &xd_emlrtBCI, &st);
    }

    obj->QR[(Qk0 + a_tmp) - 1] = a;
    if ((obj->ncols < 1) || (obj->ncols > 617)) {
      emlrtDynamicBoundsCheckR2012b(obj->ncols, 1, 617, &xd_emlrtBCI, &st);
    }

    obj->QR[(idx + 617 * (obj->ncols - 1)) - 1] = b;
    Qk0 = 617 * (idx - 2) + 1;
    xrot(obj->mrows, obj->Q, Qk0, Qk0 + 617, c, s);
  }
}

/* End of code generation (squareQ_appendCol.c) */
