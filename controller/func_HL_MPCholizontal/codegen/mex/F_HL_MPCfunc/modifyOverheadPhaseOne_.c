/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * modifyOverheadPhaseOne_.c
 *
 * Code generation for function 'modifyOverheadPhaseOne_'
 *
 */

/* Include files */
#include "modifyOverheadPhaseOne_.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo cf_emlrtRSI = { 1,  /* lineNo */
  "modifyOverheadPhaseOne_",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadPhaseOne_.p"/* pathName */
};

static emlrtBCInfo kb_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "modifyOverheadPhaseOne_",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadPhaseOne_.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void modifyOverheadPhaseOne_(const emlrtStack *sp, g_struct_T *obj)
{
  int32_T idx;
  int32_T idxStartIneq;
  int32_T b;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &cf_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  st.site = &cf_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    obj->Aeq[(obj->nVar + 485 * idx) - 1] = 0.0;
    idxStartIneq = obj->isActiveIdx[1] + idx;
    if ((idxStartIneq < 1) || (idxStartIneq > 617)) {
      emlrtDynamicBoundsCheckR2012b(idxStartIneq, 1, 617, &kb_emlrtBCI, sp);
    }

    obj->ATwset[(obj->nVar + 485 * (idxStartIneq - 1)) - 1] = 0.0;
  }

  st.site = &cf_emlrtRSI;
  for (idx = 0; idx < 176; idx++) {
    obj->Aineq[(obj->nVar + 485 * idx) - 1] = -1.0;
  }

  obj->indexLB[obj->sizes[3] - 1] = obj->nVar;
  obj->lb[obj->nVar - 1] = 1.0E-5;
  idxStartIneq = obj->isActiveIdx[2];
  b = obj->nActiveConstr;
  st.site = &cf_emlrtRSI;
  if ((obj->isActiveIdx[2] <= obj->nActiveConstr) && (obj->nActiveConstr >
       2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = idxStartIneq; idx <= b; idx++) {
    if ((idx < 1) || (idx > 617)) {
      emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &kb_emlrtBCI, sp);
    }

    obj->ATwset[(obj->nVar + 485 * (idx - 1)) - 1] = -1.0;
  }
}

/* End of code generation (modifyOverheadPhaseOne_.c) */
