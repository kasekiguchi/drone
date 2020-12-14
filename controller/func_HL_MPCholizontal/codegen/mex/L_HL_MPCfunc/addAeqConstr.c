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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "moveConstraint_.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo pf_emlrtRSI = { 1,  /* lineNo */
  "addAeqConstr",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p"/* pathName */
};

static emlrtBCInfo od_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAeqConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo pd_emlrtBCI = { 1,  /* iFirst */
  88,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAeqConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qd_emlrtBCI = { 1,  /* iFirst */
  27016,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "addAeqConstr",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\addAeqConstr.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rd_emlrtBCI = { 1,  /* iFirst */
  93635,                               /* iLast */
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
    st.site = &pf_emlrtRSI;
    obj->nWConstr[1]++;
    i = (obj->isActiveIdx[1] + idx_local) - 1;
    if ((i < 1) || (i > 305)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 305, &rc_emlrtBCI, &st);
    }

    obj->isActiveConstr[i - 1] = true;
    obj->nActiveConstr++;
    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > 305)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, 305, &rc_emlrtBCI,
        &st);
    }

    obj->Wid[obj->nActiveConstr - 1] = 2;
    obj->Wlocalidx[obj->nActiveConstr - 1] = idx_local;
    iAeq0 = 307 * (idx_local - 1);
    iAw0 = 307 * (obj->nActiveConstr - 1);
    b = obj->nVar;
    st.site = &pf_emlrtRSI;
    if ((1 <= obj->nVar) && (obj->nVar > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b; idx++) {
      b_idx = idx + 1;
      i = iAeq0 + b_idx;
      if ((i < 1) || (i > 27016)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 27016, &qd_emlrtBCI, sp);
      }

      b_idx += iAw0;
      if ((b_idx < 1) || (b_idx > 93635)) {
        emlrtDynamicBoundsCheckR2012b(b_idx, 1, 93635, &rd_emlrtBCI, sp);
      }

      obj->ATwset[b_idx - 1] = obj->Aeq[i - 1];
    }

    if ((idx_local < 1) || (idx_local > 88)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, 88, &pd_emlrtBCI, sp);
    }

    if ((obj->nActiveConstr < 1) || (obj->nActiveConstr > 305)) {
      emlrtDynamicBoundsCheckR2012b(obj->nActiveConstr, 1, 305, &od_emlrtBCI, sp);
    }

    obj->bwset[obj->nActiveConstr - 1] = obj->beq[idx_local - 1];
  } else {
    obj->nActiveConstr++;
    st.site = &pf_emlrtRSI;
    moveConstraint_(&st, obj, totalEq + 1, obj->nActiveConstr);
    obj->nWConstr[1]++;
    i = (obj->isActiveIdx[1] + idx_local) - 1;
    if ((i < 1) || (i > 305)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 305, &od_emlrtBCI, sp);
    }

    obj->isActiveConstr[i - 1] = true;
    i = totalEq + 1;
    if ((i < 1) || (i > 305)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 305, &od_emlrtBCI, sp);
    }

    obj->Wid[i - 1] = 2;
    obj->Wlocalidx[totalEq] = idx_local;
    iAeq0 = 307 * (idx_local - 1);
    iAw0 = 307 * totalEq;
    b = obj->nVar;
    st.site = &pf_emlrtRSI;
    if ((1 <= obj->nVar) && (obj->nVar > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < b; idx++) {
      b_idx = idx + 1;
      i = iAeq0 + b_idx;
      if ((i < 1) || (i > 27016)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 27016, &qd_emlrtBCI, sp);
      }

      b_idx += iAw0;
      if ((b_idx < 1) || (b_idx > 93635)) {
        emlrtDynamicBoundsCheckR2012b(b_idx, 1, 93635, &rd_emlrtBCI, sp);
      }

      obj->ATwset[b_idx - 1] = obj->Aeq[i - 1];
    }

    if ((idx_local < 1) || (idx_local > 88)) {
      emlrtDynamicBoundsCheckR2012b(idx_local, 1, 88, &pd_emlrtBCI, sp);
    }

    obj->bwset[totalEq] = obj->beq[idx_local - 1];
  }
}

/* End of code generation (addAeqConstr.c) */
