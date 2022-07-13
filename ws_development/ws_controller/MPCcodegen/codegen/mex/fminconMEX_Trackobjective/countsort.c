/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * countsort.c
 *
 * Code generation for function 'countsort'
 *
 */

/* Include files */
#include "countsort.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo gd_emlrtRSI = { 1,  /* lineNo */
  "countsort",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\countsort.p"/* pathName */
};

static emlrtBCInfo gc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "countsort",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\countsort.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void countsort(const emlrtStack *sp, emxArray_int32_T *x, int32_T xLen,
               emxArray_int32_T *workspace, int32_T xMin, int32_T xMax)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T b_tmp;
  int32_T i;
  int32_T idx;
  int32_T idxEnd;
  int32_T idxFill;
  int32_T idxStart;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((xLen > 1) && (xMax > xMin)) {
    b_tmp = (xMax - xMin) + 1;
    st.site = &gd_emlrtRSI;
    if ((1 <= b_tmp) && (b_tmp > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b_tmp; idx++) {
      i = workspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &gc_emlrtBCI, sp);
      }

      workspace->data[idx] = 0;
    }

    st.site = &gd_emlrtRSI;
    if (xLen > 2147483646) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < xLen; idx++) {
      i = workspace->size[0];
      idxStart = x->size[0];
      if (idx + 1 > idxStart) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, idxStart, &gc_emlrtBCI, sp);
      }

      idxStart = (x->data[idx] - xMin) + 1;
      if ((idxStart < 1) || (idxStart > i)) {
        emlrtDynamicBoundsCheckR2012b(idxStart, 1, i, &gc_emlrtBCI, sp);
      }

      i = workspace->size[0];
      idxEnd = x->size[0];
      if (idx + 1 > idxEnd) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, idxEnd, &gc_emlrtBCI, sp);
      }

      idxEnd = (x->data[idx] - xMin) + 1;
      if ((idxEnd < 1) || (idxEnd > i)) {
        emlrtDynamicBoundsCheckR2012b(idxEnd, 1, i, &gc_emlrtBCI, sp);
      }

      workspace->data[idxEnd - 1] = workspace->data[idxStart - 1] + 1;
    }

    st.site = &gd_emlrtRSI;
    for (idx = 2; idx <= b_tmp; idx++) {
      i = workspace->size[0];
      if (idx > i) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &gc_emlrtBCI, sp);
      }

      i = workspace->size[0];
      if (idx - 1 > i) {
        emlrtDynamicBoundsCheckR2012b(idx - 1, 1, i, &gc_emlrtBCI, sp);
      }

      i = workspace->size[0];
      if (idx > i) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &gc_emlrtBCI, sp);
      }

      workspace->data[idx - 1] += workspace->data[idx - 2];
    }

    idxStart = 1;
    idxEnd = workspace->data[0];
    st.site = &gd_emlrtRSI;
    if ((1 <= b_tmp - 1) && (b_tmp - 1 > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx <= b_tmp - 2; idx++) {
      st.site = &gd_emlrtRSI;
      if ((idxStart <= idxEnd) && (idxEnd > 2147483646)) {
        b_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idxFill = idxStart; idxFill <= idxEnd; idxFill++) {
        i = x->size[0];
        if ((idxFill < 1) || (idxFill > i)) {
          emlrtDynamicBoundsCheckR2012b(idxFill, 1, i, &gc_emlrtBCI, sp);
        }

        x->data[idxFill - 1] = idx + xMin;
      }

      i = workspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &gc_emlrtBCI, sp);
      }

      idxStart = workspace->data[idx] + 1;
      i = workspace->size[0];
      if ((idx + 2 < 1) || (idx + 2 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 2, 1, i, &gc_emlrtBCI, sp);
      }

      idxEnd = workspace->data[idx + 1];
    }

    st.site = &gd_emlrtRSI;
    if ((idxStart <= idxEnd) && (idxEnd > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = idxStart; idx <= idxEnd; idx++) {
      i = x->size[0];
      if ((idx < 1) || (idx > i)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &gc_emlrtBCI, sp);
      }

      x->data[idx - 1] = xMax;
    }
  }
}

/* End of code generation (countsort.c) */
