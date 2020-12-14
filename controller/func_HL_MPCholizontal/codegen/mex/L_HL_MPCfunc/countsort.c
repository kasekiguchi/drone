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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo uc_emlrtRSI = { 1,  /* lineNo */
  "countsort",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\countsort.p"/* pathName */
};

static emlrtBCInfo sb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "countsort",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\countsort.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo tb_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "countsort",                         /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+utils\\countsort.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void countsort(const emlrtStack *sp, int32_T x[307], int32_T xLen, int32_T
               workspace[307], int32_T xMin, int32_T xMax)
{
  int32_T b_tmp;
  int32_T idx;
  int32_T idxFill;
  int32_T idxStart;
  int32_T idxEnd;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((xLen > 1) && (xMax > xMin)) {
    b_tmp = (xMax - xMin) + 1;
    st.site = &uc_emlrtRSI;
    if ((1 <= b_tmp) && (b_tmp > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b_tmp; idx++) {
      idxFill = idx + 1;
      if ((idxFill < 1) || (idxFill > 307)) {
        emlrtDynamicBoundsCheckR2012b(idxFill, 1, 307, &sb_emlrtBCI, sp);
      }

      workspace[idxFill - 1] = 0;
    }

    st.site = &uc_emlrtRSI;
    if (xLen > 2147483646) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < xLen; idx++) {
      idxFill = idx + 1;
      if (idxFill > 307) {
        emlrtDynamicBoundsCheckR2012b(idxFill, 1, 307, &tb_emlrtBCI, sp);
      }

      idxFill = (x[idxFill - 1] - xMin) + 1;
      if ((idxFill < 1) || (idxFill > 307)) {
        emlrtDynamicBoundsCheckR2012b(idxFill, 1, 307, &tb_emlrtBCI, sp);
      }

      idxEnd = idx + 1;
      if (idxEnd > 307) {
        emlrtDynamicBoundsCheckR2012b(idxEnd, 1, 307, &tb_emlrtBCI, sp);
      }

      idxEnd = (x[idxEnd - 1] - xMin) + 1;
      if ((idxEnd < 1) || (idxEnd > 307)) {
        emlrtDynamicBoundsCheckR2012b(idxEnd, 1, 307, &sb_emlrtBCI, sp);
      }

      workspace[idxEnd - 1] = workspace[idxFill - 1] + 1;
    }

    st.site = &uc_emlrtRSI;
    for (idx = 2; idx <= b_tmp; idx++) {
      if (idx > 307) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, 307, &tb_emlrtBCI, sp);
      }

      workspace[idx - 1] += workspace[idx - 2];
    }

    idxStart = 1;
    idxEnd = workspace[0];
    st.site = &uc_emlrtRSI;
    if ((1 <= b_tmp - 1) && (b_tmp - 1 > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx <= b_tmp - 2; idx++) {
      st.site = &uc_emlrtRSI;
      if ((idxStart <= idxEnd) && (idxEnd > 2147483646)) {
        b_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idxFill = idxStart; idxFill <= idxEnd; idxFill++) {
        if ((idxFill < 1) || (idxFill > 307)) {
          emlrtDynamicBoundsCheckR2012b(idxFill, 1, 307, &sb_emlrtBCI, sp);
        }

        x[idxFill - 1] = idx + xMin;
      }

      idxFill = idx + 1;
      if ((idxFill < 1) || (idxFill > 307)) {
        emlrtDynamicBoundsCheckR2012b(idxFill, 1, 307, &tb_emlrtBCI, sp);
      }

      idxStart = workspace[idxFill - 1] + 1;
      idxFill = idx + 2;
      if ((idxFill < 1) || (idxFill > 307)) {
        emlrtDynamicBoundsCheckR2012b(idxFill, 1, 307, &tb_emlrtBCI, sp);
      }

      idxEnd = workspace[idxFill - 1];
    }

    st.site = &uc_emlrtRSI;
    if ((idxStart <= idxEnd) && (idxEnd > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = idxStart; idx <= idxEnd; idx++) {
      if ((idx < 1) || (idx > 307)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, 307, &sb_emlrtBCI, sp);
      }

      x[idx - 1] = xMax;
    }
  }
}

/* End of code generation (countsort.c) */
