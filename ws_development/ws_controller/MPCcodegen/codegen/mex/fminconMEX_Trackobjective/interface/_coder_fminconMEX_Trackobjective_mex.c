/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_fminconMEX_Trackobjective_mex.c
 *
 * Code generation for function '_coder_fminconMEX_Trackobjective_mex'
 *
 */

/* Include files */
#include "_coder_fminconMEX_Trackobjective_mex.h"
#include "_coder_fminconMEX_Trackobjective_api.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_initialize.h"
#include "fminconMEX_Trackobjective_terminate.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void fminconMEX_Trackobjective_mexFunction(int32_T nlhs, mxArray *plhs[7],
  int32_T nrhs, const mxArray *prhs[2])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  const mxArray *outputs[7];
  int32_T b_nlhs;
  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4,
                        25, "fminconMEX_Trackobjective");
  }

  if (nlhs > 7) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 25,
                        "fminconMEX_Trackobjective");
  }

  /* Call the function. */
  fminconMEX_Trackobjective_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(&fminconMEX_Trackobjective_atexit);

  /* Module initialization. */
  fminconMEX_Trackobjective_initialize();

  /* Dispatch the entry-point. */
  fminconMEX_Trackobjective_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  fminconMEX_Trackobjective_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_fminconMEX_Trackobjective_mex.c) */
