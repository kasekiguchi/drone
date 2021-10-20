/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminconMEX_Trackobjective_initialize.c
 *
 * Code generation for function 'fminconMEX_Trackobjective_initialize'
 *
 */

/* Include files */
#include "fminconMEX_Trackobjective_initialize.h"
#include "_coder_fminconMEX_Trackobjective_mex.h"
#include "fminconMEX_Trackobjective_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void fminconMEX_Trackobjective_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mex_InitInfAndNan();
  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtLicenseCheckR2012b(&st, "optimization_toolbox", 2);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (fminconMEX_Trackobjective_initialize.c) */
