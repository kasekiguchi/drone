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
#include "F_HL_MPCfunc.h"
#include "blas.h"
#include "rt_nonfinite.h"
#include "xcopy.h"

/* Variable Definitions */
static emlrtRSInfo ah_emlrtRSI = { 1,  /* lineNo */
  "sortLambdaQP",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p"/* pathName */
};

static emlrtBCInfo yb_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "sortLambdaQP",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ac_emlrtBCI = { 1,  /* iFirst */
  299245,                              /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "sortLambdaQP",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bc_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "sortLambdaQP",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void sortLambdaQP(const emlrtStack *sp, real_T lambda[617], int32_T
                  WorkingSet_nActiveConstr, const int32_T WorkingSet_sizes[5],
                  const int32_T WorkingSet_isActiveIdx[6], const int32_T
                  WorkingSet_Wid[617], const int32_T WorkingSet_Wlocalidx[617],
                  real_T workspace[299245])
{
  ptrdiff_t n_t;
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  int32_T currentMplier;
  int32_T idx;
  boolean_T exitg1;
  int32_T idxOffset;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  if (WorkingSet_nActiveConstr != 0) {
    n_t = (ptrdiff_t)(WorkingSet_sizes[3] + 264);
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dcopy(&n_t, &lambda[0], &incx_t, &workspace[0], &incy_t);
    st.site = &ah_emlrtRSI;
    c_xcopy(&st, WorkingSet_sizes[3] + 264, lambda);
    currentMplier = 1;
    idx = 1;
    exitg1 = false;
    while ((!exitg1) && (idx <= WorkingSet_nActiveConstr)) {
      if (idx > 617) {
        emlrtDynamicBoundsCheckR2012b(618, 1, 617, &yb_emlrtBCI, sp);
      }

      if (WorkingSet_Wid[idx - 1] <= 2) {
        switch (WorkingSet_Wid[idx - 1]) {
         case 1:
          idxOffset = 0;
          break;

         default:
          idxOffset = WorkingSet_isActiveIdx[1] - 1;
          break;
        }

        if (currentMplier > 299245) {
          emlrtDynamicBoundsCheckR2012b(299246, 1, 299245, &ac_emlrtBCI, sp);
        }

        idxOffset += WorkingSet_Wlocalidx[idx - 1];
        if ((idxOffset < 1) || (idxOffset > 617)) {
          emlrtDynamicBoundsCheckR2012b(idxOffset, 1, 617, &bc_emlrtBCI, sp);
        }

        lambda[idxOffset - 1] = workspace[currentMplier - 1];
        currentMplier++;
        idx++;
      } else {
        exitg1 = true;
      }
    }

    while (idx <= WorkingSet_nActiveConstr) {
      if (idx > 617) {
        emlrtDynamicBoundsCheckR2012b(618, 1, 617, &yb_emlrtBCI, sp);
      }

      switch (WorkingSet_Wid[idx - 1]) {
       case 3:
        idxOffset = WorkingSet_isActiveIdx[2];
        break;

       case 4:
        idxOffset = WorkingSet_isActiveIdx[3];
        break;

       default:
        idxOffset = WorkingSet_isActiveIdx[4];
        break;
      }

      if (currentMplier > 299245) {
        emlrtDynamicBoundsCheckR2012b(299246, 1, 299245, &ac_emlrtBCI, sp);
      }

      idxOffset = (idxOffset + WorkingSet_Wlocalidx[idx - 1]) - 1;
      if ((idxOffset < 1) || (idxOffset > 617)) {
        emlrtDynamicBoundsCheckR2012b(idxOffset, 1, 617, &bc_emlrtBCI, sp);
      }

      lambda[idxOffset - 1] = workspace[currentMplier - 1];
      currentMplier++;
      idx++;
    }
  }
}

/* End of code generation (sortLambdaQP.c) */
