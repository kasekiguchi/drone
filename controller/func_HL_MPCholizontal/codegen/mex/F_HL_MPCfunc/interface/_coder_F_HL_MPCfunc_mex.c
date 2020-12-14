/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_F_HL_MPCfunc_mex.c
 *
 * Code generation for function '_coder_F_HL_MPCfunc_mex'
 *
 */

/* Include files */
#include "_coder_F_HL_MPCfunc_mex.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "F_HL_MPCfunc_initialize.h"
#include "F_HL_MPCfunc_terminate.h"
#include "_coder_F_HL_MPCfunc_api.h"

/* Function Declarations */
MEXFUNCTION_LINKAGE void F_HL_MPCfunc_mexFunction(F_HL_MPCfuncStackData *SD,
  int32_T nlhs, mxArray *plhs[1], int32_T nrhs, const mxArray *prhs[3]);

/* Function Definitions */
void F_HL_MPCfunc_mexFunction(F_HL_MPCfuncStackData *SD, int32_T nlhs, mxArray
  *plhs[1], int32_T nrhs, const mxArray *prhs[3])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 3, 4,
                        12, "F_HL_MPCfunc");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 12,
                        "F_HL_MPCfunc");
  }

  /* Call the function. */
  F_HL_MPCfunc_api(SD, prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  F_HL_MPCfuncStackData *F_HL_MPCfuncStackDataGlobal = NULL;
  F_HL_MPCfuncStackDataGlobal = (F_HL_MPCfuncStackData *)emlrtMxCalloc(1,
    (size_t)1U * sizeof(F_HL_MPCfuncStackData));
  mexAtExit(&F_HL_MPCfunc_atexit);

  /* Module initialization. */
  F_HL_MPCfunc_initialize();

  /* Dispatch the entry-point. */
  F_HL_MPCfunc_mexFunction(F_HL_MPCfuncStackDataGlobal, nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  F_HL_MPCfunc_terminate();
  emlrtMxFree(F_HL_MPCfuncStackDataGlobal);
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_F_HL_MPCfunc_mex.c) */
