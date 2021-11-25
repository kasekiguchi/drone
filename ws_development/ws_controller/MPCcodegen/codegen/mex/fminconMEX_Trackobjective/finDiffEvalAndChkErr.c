/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * finDiffEvalAndChkErr.c
 *
 * Code generation for function 'finDiffEvalAndChkErr'
 *
 */

/* Include files */
#include "finDiffEvalAndChkErr.h"
#include "fminconMEX_Trackobjective.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo db_emlrtRSI = { 1,  /* lineNo */
  "finDiffEvalAndChkErr",              /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\finDiffEvalAndChkErr.p"/* pathName */
};

static emlrtBCInfo fb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "finDiffEvalAndChkErr",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\finDiffEvalAndChkErr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo g_emlrtECI = { -1,  /* nDims */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "finDiffEvalAndChkErr",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\finDiffEvalAndChkErr.p"/* pName */
};

static emlrtRTEInfo kb_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "finDiffEvalAndChkErr",              /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+FiniteDifferences\\+internal\\finDiffEvalAndChkErr.p"/* pName */
};

/* Function Definitions */
boolean_T finDiffEvalAndChkErr(const emlrtStack *sp, const struct0_T
  obj_objfun_tunableEnvironment[1], const struct0_T
  obj_nonlin_tunableEnvironment[1], int32_T obj_mIneq, int32_T obj_mEq, real_T
  *fplus, emxArray_real_T *cIneqPlus, emxArray_real_T *cEqPlus, int32_T dim,
  real_T delta, real_T xk[66])
{
  emlrtStack b_st;
  emlrtStack st;
  emxArray_real_T *varargout_1;
  emxArray_real_T *varargout_2;
  real_T evalOK_tmp;
  real_T temp_tmp;
  int32_T i;
  int32_T idx;
  boolean_T evalOK;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  temp_tmp = xk[dim - 1];
  xk[dim - 1] = temp_tmp + delta;
  st.site = &db_emlrtRSI;
  b_st.site = &e_emlrtRSI;
  *fplus = b_anon(&b_st, obj_objfun_tunableEnvironment[0].H,
                  obj_objfun_tunableEnvironment[0].state_size,
                  obj_objfun_tunableEnvironment[0].Q,
                  obj_objfun_tunableEnvironment[0].R,
                  obj_objfun_tunableEnvironment[0].Qf,
                  obj_objfun_tunableEnvironment[0].Xr, xk);
  evalOK = ((!muDoubleScalarIsInf(*fplus)) && (!muDoubleScalarIsNaN(*fplus)));
  if (evalOK) {
    emxInit_real_T(sp, &varargout_2, 2, &kb_emlrtRTEI, true);
    emxInit_real_T(sp, &varargout_1, 2, &kb_emlrtRTEI, true);
    st.site = &db_emlrtRSI;
    b_st.site = &e_emlrtRSI;
    anon(&b_st, obj_nonlin_tunableEnvironment[0].H,
         obj_nonlin_tunableEnvironment[0].dt, obj_nonlin_tunableEnvironment[0].
         state_size, obj_nonlin_tunableEnvironment[0].Num,
         obj_nonlin_tunableEnvironment[0].X0, obj_nonlin_tunableEnvironment[0].
         model_param.K, xk, varargout_1, varargout_2);
    i = cIneqPlus->size[0];
    idx = varargout_1->size[0] * varargout_1->size[1];
    if (i != idx) {
      emlrtSubAssignSizeCheck1dR2017a(i, idx, &g_emlrtECI, sp);
    }

    idx = cIneqPlus->size[0];
    i = cIneqPlus->size[0];
    cIneqPlus->size[0] = idx;
    emxEnsureCapacity_real_T(sp, cIneqPlus, i, &kb_emlrtRTEI);
    for (i = 0; i < idx; i++) {
      cIneqPlus->data[i] = varargout_1->data[i];
    }

    emxFree_real_T(&varargout_1);
    i = cEqPlus->size[0];
    idx = varargout_2->size[1] << 2;
    if (i != idx) {
      emlrtSubAssignSizeCheck1dR2017a(i, idx, &g_emlrtECI, sp);
    }

    idx = cEqPlus->size[0];
    i = cEqPlus->size[0];
    cEqPlus->size[0] = idx;
    emxEnsureCapacity_real_T(sp, cEqPlus, i, &kb_emlrtRTEI);
    for (i = 0; i < idx; i++) {
      cEqPlus->data[i] = varargout_2->data[i];
    }

    emxFree_real_T(&varargout_2);
    for (idx = 1; idx <= obj_mIneq; idx++) {
      i = cIneqPlus->size[0];
      if ((idx < 1) || (idx > i)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &fb_emlrtBCI, sp);
      }
    }

    idx = 1;
    while (evalOK && (idx <= obj_mEq)) {
      i = cEqPlus->size[0];
      if ((idx < 1) || (idx > i)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &fb_emlrtBCI, sp);
      }

      evalOK_tmp = cEqPlus->data[idx - 1];
      evalOK = ((!muDoubleScalarIsInf(evalOK_tmp)) && (!muDoubleScalarIsNaN
                 (evalOK_tmp)));
      idx++;
    }

    xk[dim - 1] = temp_tmp;
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
  return evalOK;
}

/* End of code generation (finDiffEvalAndChkErr.c) */
