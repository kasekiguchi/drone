/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * factoryConstruct1.c
 *
 * Code generation for function 'factoryConstruct1'
 *
 */

/* Include files */
#include "factoryConstruct1.h"
#include "F_HL_MPCfunc.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void b_factoryConstruct(g_struct_T *obj)
{
  int32_T i;
  static const uint8_T obj_tmp[5] = { 0U, 88U, 176U, 0U, 0U };

  int32_T b_obj_tmp[6];
  static const uint8_T uv[6] = { 1U, 0U, 88U, 176U, 0U, 0U };

  static const uint8_T uv1[5] = { 0U, 88U, 176U, 1U, 0U };

  static const int16_T iv[5] = { 0, 88, 176, 352, 0 };

  static const int16_T iv1[5] = { 0, 88, 176, 353, 0 };

  static const uint8_T uv2[6] = { 1U, 0U, 88U, 176U, 1U, 0U };

  static const int16_T iv2[6] = { 1, 0, 88, 176, 352, 0 };

  static const int16_T iv3[6] = { 1, 0, 88, 176, 353, 0 };

  obj->mConstr = 264;
  obj->mConstrOrig = 264;
  obj->mConstrMax = 617;
  obj->nVar = 132;
  obj->nVarOrig = 132;
  obj->nVarMax = 485;
  obj->ldA = 485;
  obj->mEqRemoved = 0;
  obj->nActiveConstr = 0;
  for (i = 0; i < 5; i++) {
    obj->sizes[i] = obj_tmp[i];
    obj->sizesNormal[i] = obj_tmp[i];
    obj->sizesPhaseOne[i] = uv1[i];
    obj->sizesRegularized[i] = iv[i];
    obj->sizesRegPhaseOne[i] = iv1[i];
  }

  for (i = 0; i < 6; i++) {
    b_obj_tmp[i] = uv[i];
  }

  for (i = 0; i < 5; i++) {
    b_obj_tmp[i + 1] += b_obj_tmp[i];
  }

  for (i = 0; i < 6; i++) {
    obj->isActiveIdx[i] = b_obj_tmp[i];
    obj->isActiveIdxNormal[i] = b_obj_tmp[i];
    b_obj_tmp[i] = uv2[i];
  }

  for (i = 0; i < 5; i++) {
    b_obj_tmp[i + 1] += b_obj_tmp[i];
  }

  for (i = 0; i < 6; i++) {
    obj->isActiveIdxPhaseOne[i] = b_obj_tmp[i];
    b_obj_tmp[i] = iv2[i];
  }

  for (i = 0; i < 5; i++) {
    b_obj_tmp[i + 1] += b_obj_tmp[i];
  }

  for (i = 0; i < 6; i++) {
    obj->isActiveIdxRegularized[i] = b_obj_tmp[i];
    b_obj_tmp[i] = iv3[i];
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

/* End of code generation (factoryConstruct1.c) */
