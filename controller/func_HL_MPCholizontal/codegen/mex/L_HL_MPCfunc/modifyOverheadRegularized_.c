/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * modifyOverheadRegularized_.c
 *
 * Code generation for function 'modifyOverheadRegularized_'
 *
 */

/* Include files */
#include "modifyOverheadRegularized_.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo n_emlrtRSI = { 1,   /* lineNo */
  "modifyOverheadRegularized_",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p"/* pathName */
};

static emlrtBCInfo n_emlrtBCI = { 1,   /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "modifyOverheadRegularized_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { 1,   /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "modifyOverheadRegularized_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { 1,   /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "modifyOverheadRegularized_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void modifyOverheadRegularized_(const emlrtStack *sp, g_struct_T *obj)
{
  int32_T idx_col;
  int32_T idxGlobalColStart;
  int32_T b;
  int32_T idx_lb;
  int32_T i;
  int32_T idx_row;
  int32_T i1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &n_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  st.site = &n_emlrtRSI;
  for (idx_col = 0; idx_col < 20; idx_col++) {
    b = idx_col + 110;
    st.site = &n_emlrtRSI;
    if (111 <= b) {
      memset(&obj->Aineq[idx_col * 307 + 110], 0, (b + -110) * sizeof(real_T));
    }

    obj->Aineq[(idx_col + 307 * idx_col) + 110] = -1.0;
    i = idx_col + 112;
    st.site = &n_emlrtRSI;
    if (i <= 306) {
      memset(&obj->Aineq[(idx_col * 307 + i) + -1], 0, (307 - i) * sizeof(real_T));
    }
  }

  idxGlobalColStart = obj->isActiveIdx[1];
  st.site = &n_emlrtRSI;
  for (idx_col = 0; idx_col < 88; idx_col++) {
    st.site = &n_emlrtRSI;
    i = idxGlobalColStart + idx_col;
    for (idx_row = 0; idx_row < 20; idx_row++) {
      obj->Aeq[(idx_row + 307 * idx_col) + 110] = 0.0;
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 305, &o_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 307 * (i - 1)) + 110] = 0.0;
    }

    b = idx_col + 130;
    st.site = &n_emlrtRSI;
    for (idx_row = 131; idx_row <= b; idx_row++) {
      obj->Aeq[(idx_row + 307 * idx_col) - 1] = 0.0;
      i = idxGlobalColStart + idx_col;
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 305, &o_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 307 * (i - 1)) - 1] = 0.0;
    }

    i = idx_col + 307 * idx_col;
    obj->Aeq[i + 130] = -1.0;
    i1 = idxGlobalColStart + idx_col;
    if ((i1 < 1) || (i1 > 305)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, 305, &o_emlrtBCI, sp);
    }

    obj->ATwset[(idx_col + 307 * (i1 - 1)) + 130] = -1.0;
    i1 = idx_col + 132;
    st.site = &n_emlrtRSI;
    for (idx_row = i1; idx_row < 219; idx_row++) {
      obj->Aeq[(idx_row + 307 * idx_col) - 1] = 0.0;
      idx_lb = idxGlobalColStart + idx_col;
      if ((idx_lb < 1) || (idx_lb > 305)) {
        emlrtDynamicBoundsCheckR2012b(idx_lb, 1, 305, &o_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 307 * (idx_lb - 1)) - 1] = 0.0;
    }

    b = idx_col + 218;
    st.site = &n_emlrtRSI;
    for (idx_row = 219; idx_row <= b; idx_row++) {
      obj->Aeq[(idx_row + 307 * idx_col) - 1] = 0.0;
      i1 = idxGlobalColStart + idx_col;
      if ((i1 < 1) || (i1 > 305)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, 305, &o_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 307 * (i1 - 1)) - 1] = 0.0;
    }

    obj->Aeq[i + 218] = 1.0;
    i = idxGlobalColStart + idx_col;
    if ((i < 1) || (i > 305)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 305, &o_emlrtBCI, sp);
    }

    obj->ATwset[(idx_col + 307 * (i - 1)) + 218] = 1.0;
    i = idx_col + 220;
    st.site = &n_emlrtRSI;
    for (idx_row = i; idx_row < 307; idx_row++) {
      obj->Aeq[(idx_row + 307 * idx_col) - 1] = 0.0;
      i1 = idxGlobalColStart + idx_col;
      if ((i1 < 1) || (i1 > 305)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, 305, &o_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 307 * (i1 - 1)) - 1] = 0.0;
    }
  }

  idx_lb = 110;
  st.site = &n_emlrtRSI;
  for (idxGlobalColStart = 0; idxGlobalColStart < 196; idxGlobalColStart++) {
    idx_lb++;
    obj->indexLB[idxGlobalColStart] = idx_lb;
  }

  st.site = &n_emlrtRSI;
  memset(&obj->lb[110], 0, 196U * sizeof(real_T));
  idxGlobalColStart = obj->isActiveIdx[2];
  b = obj->nActiveConstr;
  st.site = &n_emlrtRSI;
  if ((obj->isActiveIdx[2] <= obj->nActiveConstr) && (obj->nActiveConstr >
       2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx_col = idxGlobalColStart; idx_col <= b; idx_col++) {
    if ((idx_col < 1) || (idx_col > 305)) {
      emlrtDynamicBoundsCheckR2012b(idx_col, 1, 305, &p_emlrtBCI, sp);
    }

    switch (obj->Wid[idx_col - 1]) {
     case 3:
      idx_lb = obj->Wlocalidx[idx_col - 1] + 109;
      st.site = &n_emlrtRSI;
      if ((111 <= idx_lb) && (idx_lb > 2147483646)) {
        b_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idx_row = 111; idx_row <= idx_lb; idx_row++) {
        if (idx_row > 307) {
          emlrtDynamicBoundsCheckR2012b(idx_row, 1, 307, &n_emlrtBCI, sp);
        }

        obj->ATwset[(idx_row + 307 * (idx_col - 1)) - 1] = 0.0;
      }

      i = obj->Wlocalidx[idx_col - 1] + 110;
      if ((i < 1) || (i > 307)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 307, &n_emlrtBCI, sp);
      }

      i1 = 307 * (idx_col - 1);
      obj->ATwset[(i + i1) - 1] = -1.0;
      i = obj->Wlocalidx[idx_col - 1] + 111;
      st.site = &n_emlrtRSI;
      for (idx_row = i; idx_row < 307; idx_row++) {
        if (idx_row < 1) {
          emlrtDynamicBoundsCheckR2012b(idx_row, 1, 307, &n_emlrtBCI, sp);
        }

        obj->ATwset[(idx_row + i1) - 1] = 0.0;
      }
      break;

     default:
      st.site = &n_emlrtRSI;
      memset(&obj->ATwset[idx_col * 307 + -197], 0, 196U * sizeof(real_T));
      break;
    }
  }
}

/* End of code generation (modifyOverheadRegularized_.c) */
