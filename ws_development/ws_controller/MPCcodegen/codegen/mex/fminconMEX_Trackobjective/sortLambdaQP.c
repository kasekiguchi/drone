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
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "blas.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo uc_emlrtRSI = { 1,  /* lineNo */
  "sortLambdaQP",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p"/* pathName */
};

static emlrtBCInfo qb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "sortLambdaQP",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+parseoutput\\sortLambdaQP.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void sortLambdaQP(const emlrtStack *sp, emxArray_real_T *lambda, int32_T
                  WorkingSet_nActiveConstr, const int32_T WorkingSet_sizes[5],
                  const int32_T WorkingSet_isActiveIdx[6], const
                  emxArray_int32_T *WorkingSet_Wid, const emxArray_int32_T
                  *WorkingSet_Wlocalidx, emxArray_real_T *workspace)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  emlrtStack st;
  int32_T currentMplier;
  int32_T i;
  int32_T idx;
  int32_T mAll;
  boolean_T exitg1;
  st.prev = sp;
  st.tls = sp->tls;
  if (WorkingSet_nActiveConstr != 0) {
    mAll = (WorkingSet_sizes[1] + WorkingSet_sizes[3]) + WorkingSet_sizes[2];
    n_t = (ptrdiff_t)mAll;
    incx_t = (ptrdiff_t)1;
    incy_t = (ptrdiff_t)1;
    dcopy(&n_t, &lambda->data[0], &incx_t, &workspace->data[0], &incy_t);
    st.site = &uc_emlrtRSI;
    c_xcopy(&st, mAll, lambda);
    currentMplier = 1;
    idx = 1;
    exitg1 = false;
    while ((!exitg1) && (idx <= WorkingSet_nActiveConstr)) {
      if ((idx < 1) || (idx > WorkingSet_Wid->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, WorkingSet_Wid->size[0],
          &qb_emlrtBCI, sp);
      }

      if (WorkingSet_Wid->data[idx - 1] <= 2) {
        if (idx > WorkingSet_Wlocalidx->size[0]) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, WorkingSet_Wlocalidx->size[0],
            &qb_emlrtBCI, sp);
        }

        if (idx > WorkingSet_Wid->size[0]) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, WorkingSet_Wid->size[0],
            &qb_emlrtBCI, sp);
        }

        switch (WorkingSet_Wid->data[idx - 1]) {
         case 1:
          mAll = 0;
          break;

         default:
          mAll = WorkingSet_isActiveIdx[1] - 1;
          break;
        }

        i = workspace->size[0] * workspace->size[1];
        if ((currentMplier < 1) || (currentMplier > i)) {
          emlrtDynamicBoundsCheckR2012b(currentMplier, 1, i, &qb_emlrtBCI, sp);
        }

        i = lambda->size[0];
        mAll += WorkingSet_Wlocalidx->data[idx - 1];
        if ((mAll < 1) || (mAll > i)) {
          emlrtDynamicBoundsCheckR2012b(mAll, 1, i, &qb_emlrtBCI, sp);
        }

        lambda->data[mAll - 1] = workspace->data[currentMplier - 1];
        currentMplier++;
        idx++;
      } else {
        exitg1 = true;
      }
    }

    while (idx <= WorkingSet_nActiveConstr) {
      if ((idx < 1) || (idx > WorkingSet_Wlocalidx->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, WorkingSet_Wlocalidx->size[0],
          &qb_emlrtBCI, sp);
      }

      if (idx > WorkingSet_Wid->size[0]) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, WorkingSet_Wid->size[0],
          &qb_emlrtBCI, sp);
      }

      switch (WorkingSet_Wid->data[idx - 1]) {
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

      i = workspace->size[0] * workspace->size[1];
      if ((currentMplier < 1) || (currentMplier > i)) {
        emlrtDynamicBoundsCheckR2012b(currentMplier, 1, i, &qb_emlrtBCI, sp);
      }

      i = lambda->size[0];
      mAll = (mAll + WorkingSet_Wlocalidx->data[idx - 1]) - 1;
      if ((mAll < 1) || (mAll > i)) {
        emlrtDynamicBoundsCheckR2012b(mAll, 1, i, &qb_emlrtBCI, sp);
      }

      lambda->data[mAll - 1] = workspace->data[currentMplier - 1];
      currentMplier++;
      idx++;
    }
  }
}

/* End of code generation (sortLambdaQP.c) */
