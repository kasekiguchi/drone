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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo df_emlrtRSI = { 1,  /* lineNo */
  "modifyOverheadRegularized_",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p"/* pathName */
};

static emlrtBCInfo lb_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "modifyOverheadRegularized_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo mb_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "modifyOverheadRegularized_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo nb_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
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
  st.site = &df_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  st.site = &df_emlrtRSI;
  for (idx_col = 0; idx_col < 176; idx_col++) {
    b = idx_col + 132;
    st.site = &df_emlrtRSI;
    if (133 <= b) {
      memset(&obj->Aineq[idx_col * 485 + 132], 0, (b + -132) * sizeof(real_T));
    }

    obj->Aineq[(idx_col + 485 * idx_col) + 132] = -1.0;
    i = idx_col + 134;
    st.site = &df_emlrtRSI;
    if (i <= 484) {
      memset(&obj->Aineq[(idx_col * 485 + i) + -1], 0, (485 - i) * sizeof(real_T));
    }
  }

  idxGlobalColStart = obj->isActiveIdx[1];
  st.site = &df_emlrtRSI;
  for (idx_col = 0; idx_col < 88; idx_col++) {
    st.site = &df_emlrtRSI;
    i = idxGlobalColStart + idx_col;
    for (idx_row = 0; idx_row < 176; idx_row++) {
      obj->Aeq[(idx_row + 485 * idx_col) + 132] = 0.0;
      if ((i < 1) || (i > 617)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 617, &mb_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 485 * (i - 1)) + 132] = 0.0;
    }

    b = idx_col + 308;
    st.site = &df_emlrtRSI;
    for (idx_row = 309; idx_row <= b; idx_row++) {
      obj->Aeq[(idx_row + 485 * idx_col) - 1] = 0.0;
      i = idxGlobalColStart + idx_col;
      if ((i < 1) || (i > 617)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 617, &mb_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 485 * (i - 1)) - 1] = 0.0;
    }

    i = idx_col + 485 * idx_col;
    obj->Aeq[i + 308] = -1.0;
    i1 = idxGlobalColStart + idx_col;
    if ((i1 < 1) || (i1 > 617)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, 617, &mb_emlrtBCI, sp);
    }

    obj->ATwset[(idx_col + 485 * (i1 - 1)) + 308] = -1.0;
    i1 = idx_col + 310;
    st.site = &df_emlrtRSI;
    for (idx_row = i1; idx_row < 397; idx_row++) {
      obj->Aeq[(idx_row + 485 * idx_col) - 1] = 0.0;
      idx_lb = idxGlobalColStart + idx_col;
      if ((idx_lb < 1) || (idx_lb > 617)) {
        emlrtDynamicBoundsCheckR2012b(idx_lb, 1, 617, &mb_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 485 * (idx_lb - 1)) - 1] = 0.0;
    }

    b = idx_col + 396;
    st.site = &df_emlrtRSI;
    for (idx_row = 397; idx_row <= b; idx_row++) {
      obj->Aeq[(idx_row + 485 * idx_col) - 1] = 0.0;
      i1 = idxGlobalColStart + idx_col;
      if ((i1 < 1) || (i1 > 617)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, 617, &mb_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 485 * (i1 - 1)) - 1] = 0.0;
    }

    obj->Aeq[i + 396] = 1.0;
    i = idxGlobalColStart + idx_col;
    if ((i < 1) || (i > 617)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 617, &mb_emlrtBCI, sp);
    }

    obj->ATwset[(idx_col + 485 * (i - 1)) + 396] = 1.0;
    i = idx_col + 398;
    st.site = &df_emlrtRSI;
    for (idx_row = i; idx_row < 485; idx_row++) {
      obj->Aeq[(idx_row + 485 * idx_col) - 1] = 0.0;
      i1 = idxGlobalColStart + idx_col;
      if ((i1 < 1) || (i1 > 617)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, 617, &mb_emlrtBCI, sp);
      }

      obj->ATwset[(idx_row + 485 * (i1 - 1)) - 1] = 0.0;
    }
  }

  idx_lb = 132;
  st.site = &df_emlrtRSI;
  for (idxGlobalColStart = 0; idxGlobalColStart < 352; idxGlobalColStart++) {
    idx_lb++;
    obj->indexLB[idxGlobalColStart] = idx_lb;
  }

  st.site = &df_emlrtRSI;
  memset(&obj->lb[132], 0, 352U * sizeof(real_T));
  idxGlobalColStart = obj->isActiveIdx[2];
  b = obj->nActiveConstr;
  st.site = &df_emlrtRSI;
  if ((obj->isActiveIdx[2] <= obj->nActiveConstr) && (obj->nActiveConstr >
       2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx_col = idxGlobalColStart; idx_col <= b; idx_col++) {
    if ((idx_col < 1) || (idx_col > 617)) {
      emlrtDynamicBoundsCheckR2012b(idx_col, 1, 617, &nb_emlrtBCI, sp);
    }

    switch (obj->Wid[idx_col - 1]) {
     case 3:
      idx_lb = obj->Wlocalidx[idx_col - 1] + 131;
      st.site = &df_emlrtRSI;
      if ((133 <= idx_lb) && (idx_lb > 2147483646)) {
        b_st.site = &t_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idx_row = 133; idx_row <= idx_lb; idx_row++) {
        if (idx_row > 485) {
          emlrtDynamicBoundsCheckR2012b(idx_row, 1, 485, &lb_emlrtBCI, sp);
        }

        obj->ATwset[(idx_row + 485 * (idx_col - 1)) - 1] = 0.0;
      }

      i = obj->Wlocalidx[idx_col - 1] + 132;
      if ((i < 1) || (i > 485)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 485, &lb_emlrtBCI, sp);
      }

      i1 = 485 * (idx_col - 1);
      obj->ATwset[(i + i1) - 1] = -1.0;
      i = obj->Wlocalidx[idx_col - 1] + 133;
      st.site = &df_emlrtRSI;
      for (idx_row = i; idx_row < 485; idx_row++) {
        if (idx_row < 1) {
          emlrtDynamicBoundsCheckR2012b(idx_row, 1, 485, &lb_emlrtBCI, sp);
        }

        obj->ATwset[(idx_row + i1) - 1] = 0.0;
      }
      break;

     default:
      st.site = &df_emlrtRSI;
      memset(&obj->ATwset[idx_col * 485 + -353], 0, 352U * sizeof(real_T));
      break;
    }
  }
}

/* End of code generation (modifyOverheadRegularized_.c) */
