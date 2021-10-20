/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminconMEX_Trackobjective_emxutil.h
 *
 * Code generation for function 'fminconMEX_Trackobjective_emxutil'
 *
 */

#pragma once

/* Include files */
#include "fminconMEX_Trackobjective_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void c_emxInitStruct_anonymous_funct(anonymous_function *pStruct);
void emxEnsureCapacity_boolean_T(const emlrtStack *sp, emxArray_boolean_T
  *emxArray, int32_T oldNumel, const emlrtRTEInfo *srcLocation);
void emxEnsureCapacity_int32_T(const emlrtStack *sp, emxArray_int32_T *emxArray,
  int32_T oldNumel, const emlrtRTEInfo *srcLocation);
void emxEnsureCapacity_ptrdiff_t(const emlrtStack *sp, emxArray_ptrdiff_t
  *emxArray, int32_T oldNumel, const emlrtRTEInfo *srcLocation);
void emxEnsureCapacity_real_T(const emlrtStack *sp, emxArray_real_T *emxArray,
  int32_T oldNumel, const emlrtRTEInfo *srcLocation);
void emxFreeStruct_struct3_T(struct3_T *pStruct);
void emxFreeStruct_struct_T(d_struct_T *pStruct);
void emxFreeStruct_struct_T1(e_struct_T *pStruct);
void emxFreeStruct_struct_T2(g_struct_T *pStruct);
void emxFreeStruct_struct_T3(h_struct_T *pStruct);
void emxFreeStruct_struct_T4(i_struct_T *pStruct);
void emxFreeStruct_struct_T5(c_struct_T *pStruct);
void emxFreeStruct_struct_T6(j_struct_T *pStruct);
void emxFree_boolean_T(emxArray_boolean_T **pEmxArray);
void emxFree_int32_T(emxArray_int32_T **pEmxArray);
void emxFree_ptrdiff_t(emxArray_ptrdiff_t **pEmxArray);
void emxFree_real_T(emxArray_real_T **pEmxArray);
void emxInitMatrix_struct0_T(struct0_T pMatrix[1]);
void emxInitStruct_struct0_T(struct0_T *pStruct);
void emxInitStruct_struct3_T(const emlrtStack *sp, struct3_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInitStruct_struct_T(const emlrtStack *sp, d_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInitStruct_struct_T1(const emlrtStack *sp, e_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInitStruct_struct_T2(const emlrtStack *sp, g_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInitStruct_struct_T3(const emlrtStack *sp, h_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInitStruct_struct_T4(const emlrtStack *sp, i_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInitStruct_struct_T5(const emlrtStack *sp, c_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInitStruct_struct_T6(const emlrtStack *sp, j_struct_T *pStruct, const
  emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInit_boolean_T(const emlrtStack *sp, emxArray_boolean_T **pEmxArray,
  int32_T numDimensions, const emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInit_int32_T(const emlrtStack *sp, emxArray_int32_T **pEmxArray, int32_T
                     numDimensions, const emlrtRTEInfo *srcLocation, boolean_T
                     doPush);
void emxInit_ptrdiff_t(const emlrtStack *sp, emxArray_ptrdiff_t **pEmxArray,
  int32_T numDimensions, const emlrtRTEInfo *srcLocation, boolean_T doPush);
void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray, int32_T
                    numDimensions, const emlrtRTEInfo *srcLocation, boolean_T
                    doPush);

/* End of code generation (fminconMEX_Trackobjective_emxutil.h) */
