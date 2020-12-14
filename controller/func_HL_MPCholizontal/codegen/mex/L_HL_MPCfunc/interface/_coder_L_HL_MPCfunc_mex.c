/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_L_HL_MPCfunc_mex.c
 *
 * Code generation for function '_coder_L_HL_MPCfunc_mex'
 *
 */

/* Include files */
#include "_coder_L_HL_MPCfunc_mex.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "L_HL_MPCfunc_initialize.h"
#include "L_HL_MPCfunc_terminate.h"
#include "_coder_L_HL_MPCfunc_api.h"

/* Function Declarations */
MEXFUNCTION_LINKAGE void L_HL_MPCfunc_mexFunction(L_HL_MPCfuncStackData *SD,
  int32_T nlhs, mxArray *plhs[1], int32_T nrhs, const mxArray *prhs[3]);

/* Function Definitions */
void L_HL_MPCfunc_mexFunction(L_HL_MPCfuncStackData *SD, int32_T nlhs, mxArray
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
                        12, "L_HL_MPCfunc");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 12,
                        "L_HL_MPCfunc");
  }

  /* Call the function. */
  L_HL_MPCfunc_api(SD, prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  L_HL_MPCfuncStackData *L_HL_MPCfuncStackDataGlobal = NULL;
  L_HL_MPCfuncStackDataGlobal = (L_HL_MPCfuncStackData *)emlrtMxCalloc(1,
    (size_t)1U * sizeof(L_HL_MPCfuncStackData));
  mexAtExit(&L_HL_MPCfunc_atexit);

  /* Module initialization. */
  L_HL_MPCfunc_initialize();

  /* Dispatch the entry-point. */
  L_HL_MPCfunc_mexFunction(L_HL_MPCfuncStackDataGlobal, nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  L_HL_MPCfunc_terminate();
  emlrtMxFree(L_HL_MPCfuncStackDataGlobal);
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_L_HL_MPCfunc_mex.c) */
