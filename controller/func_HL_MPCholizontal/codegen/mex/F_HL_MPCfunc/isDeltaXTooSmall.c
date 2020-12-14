/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * isDeltaXTooSmall.c
 *
 * Code generation for function 'isDeltaXTooSmall'
 *
 */

/* Include files */
#include "isDeltaXTooSmall.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo qf_emlrtRSI = { 1,  /* lineNo */
  "isDeltaXTooSmall",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\isDeltaXTooSmall.p"/* pathName */
};

static emlrtBCInfo hb_emlrtBCI = { 1,  /* iFirst */
  132,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "isDeltaXTooSmall",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\isDeltaXTooSmall.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
boolean_T isDeltaXTooSmall(const emlrtStack *sp, const real_T xCurrent[132],
  const real_T delta_x[485], int32_T nVar)
{
  boolean_T tf;
  int32_T idx;
  boolean_T exitg1;
  int32_T i;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  tf = true;
  st.site = &qf_emlrtRSI;
  if ((1 <= nVar) && (nVar > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  idx = 0;
  exitg1 = false;
  while ((!exitg1) && (idx <= nVar - 1)) {
    i = idx + 1;
    if ((i < 1) || (i > 132)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 132, &hb_emlrtBCI, sp);
    }

    if (1.0E-6 * muDoubleScalarMax(1.0, muDoubleScalarAbs(xCurrent[idx])) <=
        muDoubleScalarAbs(delta_x[idx])) {
      tf = false;
      exitg1 = true;
    } else {
      idx++;
    }
  }

  return tf;
}

/* End of code generation (isDeltaXTooSmall.c) */
