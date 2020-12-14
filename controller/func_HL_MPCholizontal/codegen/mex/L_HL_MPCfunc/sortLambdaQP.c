/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sortLambdaQP.c
 *
 * Code generation for function 'sortLambdaQP'
 *
 */

/* Include files */
#include "sortLambdaQP.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo kc_emlrtRSI = { 1,  /* lineNo */
  "sortLambdaQP",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p"/* pathName */
};

static emlrtBCInfo bb_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "sortLambdaQP",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cb_emlrtBCI = { 1,  /* iFirst */
  94249,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "sortLambdaQP",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo db_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "sortLambdaQP",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void sortLambdaQP(const emlrtStack *sp, real_T lambda[305], int32_T
                  WorkingSet_nActiveConstr, const int32_T WorkingSet_sizes[5],
                  const int32_T WorkingSet_isActiveIdx[6], const int32_T
                  WorkingSet_Wid[305], const int32_T WorkingSet_Wlocalidx[305],
                  real_T workspace[94249])
{
  int32_T mAll;
  int32_T currentMplier;
  int32_T idx;
  boolean_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  if (WorkingSet_nActiveConstr != 0) {
    mAll = WorkingSet_sizes[3] + 107;
    st.site = &kc_emlrtRSI;
    b_st.site = &i_emlrtRSI;
    c_st.site = &j_emlrtRSI;
    if ((1 <= WorkingSet_sizes[3] + 108) && (WorkingSet_sizes[3] + 108 >
         2147483646)) {
      d_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    if (0 <= mAll) {
      memcpy(&workspace[0], &lambda[0], (mAll + 1) * sizeof(real_T));
    }

    st.site = &kc_emlrtRSI;
    c_xcopy(&st, WorkingSet_sizes[3] + 108, lambda);
    currentMplier = 1;
    idx = 1;
    exitg1 = false;
    while ((!exitg1) && (idx <= WorkingSet_nActiveConstr)) {
      if (idx > 305) {
        emlrtDynamicBoundsCheckR2012b(306, 1, 305, &bb_emlrtBCI, sp);
      }

      if (WorkingSet_Wid[idx - 1] <= 2) {
        switch (WorkingSet_Wid[idx - 1]) {
         case 1:
          mAll = 0;
          break;

         default:
          mAll = WorkingSet_isActiveIdx[1] - 1;
          break;
        }

        if (currentMplier > 94249) {
          emlrtDynamicBoundsCheckR2012b(94250, 1, 94249, &cb_emlrtBCI, sp);
        }

        mAll += WorkingSet_Wlocalidx[idx - 1];
        if ((mAll < 1) || (mAll > 305)) {
          emlrtDynamicBoundsCheckR2012b(mAll, 1, 305, &db_emlrtBCI, sp);
        }

        lambda[mAll - 1] = workspace[currentMplier - 1];
        currentMplier++;
        idx++;
      } else {
        exitg1 = true;
      }
    }

    while (idx <= WorkingSet_nActiveConstr) {
      if (idx > 305) {
        emlrtDynamicBoundsCheckR2012b(306, 1, 305, &bb_emlrtBCI, sp);
      }

      switch (WorkingSet_Wid[idx - 1]) {
       case 3:
        mAll = WorkingSet_isActiveIdx[2];
        break;

       case 4:
        mAll = WorkingSet_isActiveIdx[3];
        break;

       default:
        mAll = WorkingSet_isActiveIdx[4];
        break;
      }

      if (currentMplier > 94249) {
        emlrtDynamicBoundsCheckR2012b(94250, 1, 94249, &cb_emlrtBCI, sp);
      }

      mAll = (mAll + WorkingSet_Wlocalidx[idx - 1]) - 1;
      if ((mAll < 1) || (mAll > 305)) {
        emlrtDynamicBoundsCheckR2012b(mAll, 1, 305, &db_emlrtBCI, sp);
      }

      lambda[mAll - 1] = workspace[currentMplier - 1];
      currentMplier++;
      idx++;
    }
  }
}

/* End of code generation (sortLambdaQP.c) */
