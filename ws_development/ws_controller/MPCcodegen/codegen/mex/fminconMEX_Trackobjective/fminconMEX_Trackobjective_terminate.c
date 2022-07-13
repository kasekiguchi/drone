/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminconMEX_Trackobjective_terminate.c
 *
 * Code generation for function 'fminconMEX_Trackobjective_terminate'
 *
 */

/* Include files */
#include "fminconMEX_Trackobjective_terminate.h"
#include "_coder_fminconMEX_Trackobjective_mex.h"
#include "fminconMEX_Trackobjective_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void fminconMEX_Trackobjective_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void fminconMEX_Trackobjective_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (fminconMEX_Trackobjective_terminate.c) */
