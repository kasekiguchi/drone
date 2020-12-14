/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * checkLinearInputs.c
 *
 * Code generation for function 'checkLinearInputs'
 *
 */

/* Include files */
#include "checkLinearInputs.h"
#include "F_HL_MPCfunc.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo b_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "checkLinearInputs",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+validate\\checkLinearInputs.p"/* pName */
};

/* Function Definitions */
void checkLinearInputs(const emlrtStack *sp, const real_T x0[132])
{
  int32_T k;
  boolean_T y;
  boolean_T b[132];
  boolean_T b_b[132];
  boolean_T exitg1;
  for (k = 0; k < 132; k++) {
    b[k] = muDoubleScalarIsInf(x0[k]);
    b_b[k] = muDoubleScalarIsNaN(x0[k]);
  }

  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 132)) {
    if (b[k] || b_b[k]) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2018a(sp, &b_emlrtRTEI,
      "optim_codegen:common:InfNaNComplexDetected",
      "optim_codegen:common:InfNaNComplexDetected", 3, 4, 2, "X0");
  }
}

/* End of code generation (checkLinearInputs.c) */
