/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factoryConstruct3.c
 *
 * Code generation for function 'factoryConstruct3'
 *
 */

/* Include files */
#include "factoryConstruct3.h"
#include "L_HL_MPCfunc.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void d_factoryConstruct(g_struct_T *obj)
{
  int32_T i;
  static const int8_T obj_tmp[5] = { 0, 88, 20, 0, 0 };

  int32_T b_obj_tmp[6];
  static const int8_T iv[6] = { 1, 0, 88, 20, 0, 0 };

  static const int8_T iv1[5] = { 0, 88, 20, 1, 0 };

  static const uint8_T uv[5] = { 0U, 88U, 20U, 196U, 0U };

  static const uint8_T uv1[5] = { 0U, 88U, 20U, 197U, 0U };

  static const int8_T iv2[6] = { 1, 0, 88, 20, 1, 0 };

  static const uint8_T uv2[6] = { 1U, 0U, 88U, 20U, 196U, 0U };

  static const uint8_T uv3[6] = { 1U, 0U, 88U, 20U, 197U, 0U };

  obj->mConstr = 108;
  obj->mConstrOrig = 108;
  obj->mConstrMax = 305;
  obj->nVar = 110;
  obj->nVarOrig = 110;
  obj->nVarMax = 307;
  obj->ldA = 307;
  obj->mEqRemoved = 0;
  obj->nActiveConstr = 0;
  for (i = 0; i < 5; i++) {
    obj->sizes[i] = obj_tmp[i];
    obj->sizesNormal[i] = obj_tmp[i];
    obj->sizesPhaseOne[i] = iv1[i];
    obj->sizesRegularized[i] = uv[i];
    obj->sizesRegPhaseOne[i] = uv1[i];
  }

  for (i = 0; i < 6; i++) {
    b_obj_tmp[i] = iv[i];
  }

  for (i = 0; i < 5; i++) {
    b_obj_tmp[i + 1] += b_obj_tmp[i];
  }

  for (i = 0; i < 6; i++) {
    obj->isActiveIdx[i] = b_obj_tmp[i];
    obj->isActiveIdxNormal[i] = b_obj_tmp[i];
    b_obj_tmp[i] = iv2[i];
  }

  for (i = 0; i < 5; i++) {
    b_obj_tmp[i + 1] += b_obj_tmp[i];
  }

  for (i = 0; i < 6; i++) {
    obj->isActiveIdxPhaseOne[i] = b_obj_tmp[i];
    b_obj_tmp[i] = uv2[i];
  }

  for (i = 0; i < 5; i++) {
    b_obj_tmp[i + 1] += b_obj_tmp[i];
  }

  for (i = 0; i < 6; i++) {
    obj->isActiveIdxRegularized[i] = b_obj_tmp[i];
    b_obj_tmp[i] = uv3[i];
  }

  for (i = 0; i < 5; i++) {
    b_obj_tmp[i + 1] += b_obj_tmp[i];
  }

  for (i = 0; i < 6; i++) {
    obj->isActiveIdxRegPhaseOne[i] = b_obj_tmp[i];
  }

  for (i = 0; i < 5; i++) {
    obj->nWConstr[i] = 0;
  }

  obj->probType = 3;
  obj->SLACK0 = 1.0E-5;
}

/* End of code generation (factoryConstruct3.c) */
