/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * setProblemType.c
 *
 * Code generation for function 'setProblemType'
 *
 */

/* Include files */
#include "setProblemType.h"
#include "L_HL_MPCfunc.h"
#include "modifyOverheadPhaseOne_.h"
#include "modifyOverheadRegularized_.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo l_emlrtRSI = { 1,   /* lineNo */
  "setProblemType",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\setProblemType.p"/* pathName */
};

/* Function Definitions */
void setProblemType(const emlrtStack *sp, g_struct_T *obj, int32_T PROBLEM_TYPE)
{
  int32_T i;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  switch (PROBLEM_TYPE) {
   case 3:
    obj->nVar = 110;
    obj->mConstr = 108;
    for (i = 0; i < 5; i++) {
      obj->sizes[i] = obj->sizesNormal[i];
    }

    for (i = 0; i < 6; i++) {
      obj->isActiveIdx[i] = obj->isActiveIdxNormal[i];
    }
    break;

   case 1:
    obj->nVar = 111;
    obj->mConstr = 109;
    for (i = 0; i < 5; i++) {
      obj->sizes[i] = obj->sizesPhaseOne[i];
    }

    for (i = 0; i < 6; i++) {
      obj->isActiveIdx[i] = obj->isActiveIdxPhaseOne[i];
    }

    st.site = &l_emlrtRSI;
    modifyOverheadPhaseOne_(&st, obj);
    break;

   case 2:
    obj->nVar = 306;
    obj->mConstr = 304;
    for (i = 0; i < 5; i++) {
      obj->sizes[i] = obj->sizesRegularized[i];
    }

    for (i = 0; i < 6; i++) {
      obj->isActiveIdx[i] = obj->isActiveIdxRegularized[i];
    }

    if (obj->probType != 4) {
      st.site = &l_emlrtRSI;
      modifyOverheadRegularized_(&st, obj);
    }
    break;

   default:
    obj->nVar = 307;
    obj->mConstr = 305;
    for (i = 0; i < 5; i++) {
      obj->sizes[i] = obj->sizesRegPhaseOne[i];
    }

    for (i = 0; i < 6; i++) {
      obj->isActiveIdx[i] = obj->isActiveIdxRegPhaseOne[i];
    }

    st.site = &l_emlrtRSI;
    modifyOverheadPhaseOne_(&st, obj);
    break;
  }

  obj->probType = PROBLEM_TYPE;
}

/* End of code generation (setProblemType.c) */
