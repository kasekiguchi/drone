/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * addAeqConstr.c
 *
 * Code generation for function 'addAeqConstr'
 *
 */

/* Include files */
#include "addAeqConstr.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "moveConstraint_.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo gk_emlrtRSI = { 1,  /* lineNo */
  "addAeqConstr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p"/* pathName */
};

static emlrtBCInfo me_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAeqConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo ne_emlrtBCI = { 1,  /* iFirst */
  88,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAeqConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo oe_emlrtBCI = { 1,  /* iFirst */
  42680,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAeqConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pe_emlrtBCI = { 1,  /* iFirst */
  299245,                              /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAeqConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void addAeqConstr(const emlrtStack *sp, g_struct_T *obj, int32_T idx_local)
{
  int32_T totalEq;
  int32_T i;
  int32_T iAeq0;
  int32_T iAw0;
  int32_T b;
  int32_T idx;
  int32_T b_idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  totalEq = obj->nWConstr[0] + obj->nWConstr[1];
  if ((obj->nActiveConstr == totalEq) && (idx_local > obj->nWConstr[1])) {
    st.site = &gk_emlrtRSI;
    obj->nWConstr[1]++;
    i = (obj->isActiveIdx[1] + idx_local) - 1;
    if ((i < 1) || (i > 617)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 617, &od_emlrtBCI, &st);
    }

    obj->isActiveConstr[i - 1] = true;
    obj->nActiveConstr++;
    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > 617)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, 617, &od_emlrtBCI,
        &st);
    }

    obj->Wid[obj->nActiveConstr - 1] = 2;
    obj->Wlocalidx[obj->nActiveConstr - 1] = idx_local;
    iAeq0 = 485 * (idx_local - 1);
    iAw0 = 485 * (obj->nActiveConstr - 1);
    b = obj->nVar;
    st.site = &gk_emlrtRSI;
    if ((1 <= obj->nVar) && (obj->nVar > 2147483646)) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b; idx++) {
      b_idx = idx + 1;
      i = iAeq0 + b_idx;
      if ((i < 1) || (i > 42680)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 42680, &oe_emlrtBCI, sp);
      }

      b_idx += iAw0;
      if ((b_idx < 1) || (b_idx > 299245)) {
        emlrtDynamicBoundsCheckR2012b(b_idx, 1, 299245, &pe_emlrtBCI, sp);
      }

      obj->ATwset[b_idx - 1] = obj->Aeq[i - 1];
    }

    if ((idx_local < 1) || (idx_local > 88)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, 88, &ne_emlrtBCI, sp);
    }

    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > 617)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, 617, &me_emlrtBCI, sp);
    }

    obj->bwset[obj->nActiveConstr - 1] = obj->beq[idx_local - 1];
  } else {
    obj->nActiveConstr++;
    st.site = &gk_emlrtRSI;
    moveConstraint_(&st, obj, totalEq + 1, obj->nActiveConstr);
    obj->nWConstr[1]++;
    i = (obj->isActiveIdx[1] + idx_local) - 1;
    if ((i < 1) || (i > 617)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 617, &me_emlrtBCI, sp);
    }

    obj->isActiveConstr[i - 1] = true;
    i = totalEq + 1;
    if ((i < 1) || (i > 617)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 617, &me_emlrtBCI, sp);
    }

    obj->Wid[i - 1] = 2;
    obj->Wlocalidx[totalEq] = idx_local;
    iAeq0 = 485 * (idx_local - 1);
    iAw0 = 485 * totalEq;
    b = obj->nVar;
    st.site = &gk_emlrtRSI;
    if ((1 <= obj->nVar) && (obj->nVar > 2147483646)) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b; idx++) {
      b_idx = idx + 1;
      i = iAeq0 + b_idx;
      if ((i < 1) || (i > 42680)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 42680, &oe_emlrtBCI, sp);
      }

      b_idx += iAw0;
      if ((b_idx < 1) || (b_idx > 299245)) {
        emlrtDynamicBoundsCheckR2012b(b_idx, 1, 299245, &pe_emlrtBCI, sp);
      }

      obj->ATwset[b_idx - 1] = obj->Aeq[i - 1];
    }

    if ((idx_local < 1) || (idx_local > 88)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, 88, &ne_emlrtBCI, sp);
    }

    obj->bwset[totalEq] = obj->beq[idx_local - 1];
  }
}

/* End of code generation (addAeqConstr.c) */
