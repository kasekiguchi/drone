/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeGradLag.c
 *
 * Code generation for function 'computeGradLag'
 *
 */

/* Include files */
#include "computeGradLag.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xgemv.h"

/* Variable Definitions */
static emlrtRSInfo qb_emlrtRSI = { 1,  /* lineNo */
  "computeGradLag",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p"/* pathName */
};

static emlrtBCInfo ob_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeGradLag",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeGradLag.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void b_computeGradLag(const emlrtStack *sp, emxArray_real_T *workspace, int32_T
                      ldA, int32_T nVar, const emxArray_real_T *grad, int32_T
                      mIneq, const emxArray_real_T *AineqTrans, int32_T mEq,
                      const emxArray_real_T *AeqTrans, const emxArray_int32_T
                      *finiteLB, int32_T mLB, const emxArray_real_T *lambda)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T i;
  int32_T iL0;
  int32_T idx;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &qb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (iL0 = 0; iL0 < nVar; iL0++) {
    if ((iL0 + 1 < 1) || (iL0 + 1 > grad->size[0])) {
      emlrtDynamicBoundsCheckR2012b(iL0 + 1, 1, grad->size[0], &ob_emlrtBCI, sp);
    }

    i = workspace->size[0] * workspace->size[1];
    if ((iL0 + 1 < 1) || (iL0 + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(iL0 + 1, 1, i, &ob_emlrtBCI, sp);
    }

    workspace->data[iL0] = grad->data[iL0];
  }

  st.site = &qb_emlrtRSI;
  st.site = &qb_emlrtRSI;
  xgemv(nVar, mEq, AeqTrans, ldA, lambda, 1, workspace);
  st.site = &qb_emlrtRSI;
  xgemv(nVar, mIneq, AineqTrans, ldA, lambda, mEq + 1, workspace);
  iL0 = (mEq + mIneq) + 1;
  st.site = &qb_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > finiteLB->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, finiteLB->size[0], &ob_emlrtBCI,
        sp);
    }

    i = workspace->size[0] * workspace->size[1];
    if ((finiteLB->data[idx] < 1) || (finiteLB->data[idx] > i)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB->data[idx], 1, i, &ob_emlrtBCI, sp);
    }

    if ((iL0 < 1) || (iL0 > lambda->size[0])) {
      emlrtDynamicBoundsCheckR2012b(iL0, 1, lambda->size[0], &ob_emlrtBCI, sp);
    }

    i = workspace->size[0] * workspace->size[1];
    if ((finiteLB->data[idx] < 1) || (finiteLB->data[idx] > i)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB->data[idx], 1, i, &ob_emlrtBCI, sp);
    }

    workspace->data[finiteLB->data[idx] - 1] -= lambda->data[iL0 - 1];
    iL0++;
  }

  st.site = &qb_emlrtRSI;
}

void computeGradLag(const emlrtStack *sp, emxArray_real_T *workspace, int32_T
                    ldA, int32_T nVar, const emxArray_real_T *grad, int32_T
                    mIneq, const emxArray_real_T *AineqTrans, int32_T mEq, const
                    emxArray_real_T *AeqTrans, const emxArray_int32_T *finiteLB,
                    int32_T mLB, const emxArray_real_T *lambda)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T i;
  int32_T iL0;
  int32_T idx;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &qb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (iL0 = 0; iL0 < nVar; iL0++) {
    if ((iL0 + 1 < 1) || (iL0 + 1 > grad->size[0])) {
      emlrtDynamicBoundsCheckR2012b(iL0 + 1, 1, grad->size[0], &ob_emlrtBCI, sp);
    }

    i = workspace->size[0];
    if ((iL0 + 1 < 1) || (iL0 + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(iL0 + 1, 1, i, &ob_emlrtBCI, sp);
    }

    workspace->data[iL0] = grad->data[iL0];
  }

  st.site = &qb_emlrtRSI;
  st.site = &qb_emlrtRSI;
  xgemv(nVar, mEq, AeqTrans, ldA, lambda, 1, workspace);
  st.site = &qb_emlrtRSI;
  xgemv(nVar, mIneq, AineqTrans, ldA, lambda, mEq + 1, workspace);
  iL0 = (mEq + mIneq) + 1;
  st.site = &qb_emlrtRSI;
  if ((1 <= mLB) && (mLB > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mLB; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > finiteLB->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, finiteLB->size[0], &ob_emlrtBCI,
        sp);
    }

    i = workspace->size[0];
    if ((finiteLB->data[idx] < 1) || (finiteLB->data[idx] > i)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB->data[idx], 1, i, &ob_emlrtBCI, sp);
    }

    if ((iL0 < 1) || (iL0 > lambda->size[0])) {
      emlrtDynamicBoundsCheckR2012b(iL0, 1, lambda->size[0], &ob_emlrtBCI, sp);
    }

    i = workspace->size[0];
    if ((finiteLB->data[idx] < 1) || (finiteLB->data[idx] > i)) {
      emlrtDynamicBoundsCheckR2012b(finiteLB->data[idx], 1, i, &ob_emlrtBCI, sp);
    }

    workspace->data[finiteLB->data[idx] - 1] -= lambda->data[iL0 - 1];
    iL0++;
  }

  st.site = &qb_emlrtRSI;
}

/* End of code generation (computeGradLag.c) */
