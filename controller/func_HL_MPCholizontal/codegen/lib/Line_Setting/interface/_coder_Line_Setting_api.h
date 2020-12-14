/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_Line_Setting_api.h
 *
 * MATLAB Coder version            : 5.0
 * C/C++ source code generated on  : 04-Nov-2020 16:27:23
 */

#ifndef _CODER_LINE_SETTING_API_H
#define _CODER_LINE_SETTING_API_H

/* Include Files */
#include <stddef.h>
#include <stdlib.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void Line_Setting(real_T Sectionnumber, real_T Sectionpoint_data[],
  int32_T Sectionpoint_size[2], real_T bfjudge, real_T S_limit, real_T p_return
  [38]);
extern void Line_Setting_api(const mxArray * const prhs[4], int32_T nlhs, const
  mxArray *plhs[1]);
extern void Line_Setting_atexit(void);
extern void Line_Setting_initialize(void);
extern void Line_Setting_terminate(void);
extern void Line_Setting_xil_shutdown(void);
extern void Line_Setting_xil_terminate(void);

#endif

/*
 * File trailer for _coder_Line_Setting_api.h
 *
 * [EOF]
 */
