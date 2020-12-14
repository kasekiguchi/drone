/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * removeAllIneqConstr.c
 *
 * Code generation for function 'removeAllIneqConstr'
 *
 */

/* Include files */
#include "removeAllIneqConstr.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo ae_emlrtRSI = { 1,  /* lineNo */
  "removeAllIneqConstr",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeAllIneqConstr.p"/* pathName */
};

static emlrtBCInfo ic_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeAllIneqConstr",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeAllIneqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jc_emlrtBCI = { 1,  /* iFirst */
  6,                                   /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeAllIneqConstr",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeAllIneqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kc_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "removeAllIneqConstr",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\removeAllIneqConstr.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void removeAllIneqConstr(const emlrtStack *sp, g_struct_T *obj)
{
  int32_T idxStartIneq;
  int32_T idxEndIneq;
  int32_T idx_global;
  int32_T i;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  idxStartIneq = (obj->nWConstr[0] + obj->nWConstr[1]) + 1;
  idxEndIneq = obj->nActiveConstr;
  st.site = &ae_emlrtRSI;
  if ((idxStartIneq <= obj->nActiveConstr) && (obj->nActiveConstr > 2147483646))
  {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx_global = idxStartIneq; idx_global <= idxEndIneq; idx_global++) {
    if ((idx_global < 1) || (idx_global > 305)) {
      emlrtDynamicBoundsCheckR2012b(idx_global, 1, 305, &ic_emlrtBCI, sp);
    }

    i = obj->Wid[idx_global - 1];
    if ((i < 1) || (i > 6)) {
      emlrtDynamicBoundsCheckR2012b(obj->Wid[idx_global - 1], 1, 6, &jc_emlrtBCI,
        sp);
    }

    i = (obj->isActiveIdx[i - 1] + obj->Wlocalidx[idx_global - 1]) - 1;
    if ((i < 1) || (i > 305)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 305, &kc_emlrtBCI, sp);
    }

    obj->isActiveConstr[i - 1] = false;
  }

  obj->nWConstr[2] = 0;
  obj->nWConstr[3] = 0;
  obj->nWConstr[4] = 0;
  obj->nActiveConstr = obj->nWConstr[0] + obj->nWConstr[1];
}

/* End of code generation (removeAllIneqConstr.c) */
