/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * feasibleX0ForWorkingSet.c
 *
 * Code generation for function 'feasibleX0ForWorkingSet'
 *
 */

/* Include files */
#include "feasibleX0ForWorkingSet.h"
#include "computeQ_.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQR.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "maxConstraintViolation.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgemm.h"
#include "xgemv.h"
#include "xgeqrf.h"
#include "xtrsm.h"
#include "blas.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo fb_emlrtRSI = { 44, /* lineNo */
  "xcopy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xcopy.m"/* pathName */
};

static emlrtRSInfo hb_emlrtRSI = { 55, /* lineNo */
  "xcopy_blas",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xcopy.m"/* pathName */
};

static emlrtRSInfo ld_emlrtRSI = { 1,  /* lineNo */
  "feasibleX0ForWorkingSet",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\feasibleX0ForWorkingSet.p"/* pathName */
};

static emlrtRSInfo xd_emlrtRSI = { 1,  /* lineNo */
  "computeTallQ",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\computeTallQ.p"/* pathName */
};

static emlrtRSInfo yd_emlrtRSI = { 53, /* lineNo */
  "xaxpy",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xaxpy.m"/* pathName */
};

static emlrtRSInfo ae_emlrtRSI = { 65, /* lineNo */
  "xaxpy_blas",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xaxpy.m"/* pathName */
};

static emlrtBCInfo lc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "feasibleX0ForWorkingSet",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\feasibleX0ForWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo rb_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "feasibleX0ForWorkingSet",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\feasibleX0ForWorkingSet.p"/* pName */
};

/* Function Definitions */
boolean_T feasibleX0ForWorkingSet(const emlrtStack *sp, emxArray_real_T
  *workspace, emxArray_real_T *xCurrent, j_struct_T *workingset, g_struct_T
  *qrmanager)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack st;
  emxArray_real_T *b_workspace;
  real_T a;
  real_T constrViolation_basicX;
  int32_T exitg1;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T idx;
  int32_T mIneq;
  int32_T mLB;
  int32_T mWConstr;
  int32_T nVar;
  int32_T offsetEq2;
  boolean_T nonDegenerateWset;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  mWConstr = workingset->nActiveConstr;
  nVar = workingset->nVar;
  nonDegenerateWset = true;
  if (workingset->nActiveConstr != 0) {
    st.site = &ld_emlrtRSI;
    if ((1 <= workingset->nActiveConstr) && (workingset->nActiveConstr >
         2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mWConstr; idx++) {
      i = workingset->bwset->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &lc_emlrtBCI, sp);
      }

      i = workspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &lc_emlrtBCI, sp);
      }

      a = workingset->bwset->data[idx];
      workspace->data[idx] = a;
      i = workingset->bwset->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &lc_emlrtBCI, sp);
      }

      i = workspace->size[0];
      if ((idx + 1 < 1) || (idx + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &lc_emlrtBCI, sp);
      }

      workspace->data[idx + workspace->size[0]] = a;
    }

    st.site = &ld_emlrtRSI;
    c_xgemv(workingset->nVar, workingset->nActiveConstr, workingset->ATwset,
            workingset->ATwset->size[0], xCurrent, workspace);
    emxInit_real_T(sp, &b_workspace, 2, &rb_emlrtRTEI, true);
    if (workingset->nActiveConstr >= workingset->nVar) {
      st.site = &ld_emlrtRSI;
      if ((1 <= workingset->nVar) && (workingset->nVar > 2147483646)) {
        b_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (mIneq = 0; mIneq < nVar; mIneq++) {
        st.site = &ld_emlrtRSI;
        if ((1 <= mWConstr) && (mWConstr > 2147483646)) {
          b_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&b_st);
        }

        for (offsetEq2 = 0; offsetEq2 < mWConstr; offsetEq2++) {
          i = workingset->ATwset->size[0];
          if ((mIneq + 1 < 1) || (mIneq + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(mIneq + 1, 1, i, &lc_emlrtBCI, sp);
          }

          i = workingset->ATwset->size[1];
          if ((offsetEq2 + 1 < 1) || (offsetEq2 + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(offsetEq2 + 1, 1, i, &lc_emlrtBCI, sp);
          }

          i = qrmanager->QR->size[0];
          if ((offsetEq2 + 1 < 1) || (offsetEq2 + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(offsetEq2 + 1, 1, i, &lc_emlrtBCI, sp);
          }

          i = qrmanager->QR->size[1];
          if ((mIneq + 1 < 1) || (mIneq + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(mIneq + 1, 1, i, &lc_emlrtBCI, sp);
          }

          qrmanager->QR->data[offsetEq2 + qrmanager->QR->size[0] * mIneq] =
            workingset->ATwset->data[mIneq + workingset->ATwset->size[0] *
            offsetEq2];
        }
      }

      st.site = &ld_emlrtRSI;
      qrmanager->usedPivoting = false;
      qrmanager->mrows = workingset->nActiveConstr;
      qrmanager->ncols = workingset->nVar;
      mWConstr = workingset->nVar;
      b_st.site = &md_emlrtRSI;
      if ((1 <= workingset->nVar) && (workingset->nVar > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < mWConstr; idx++) {
        i = qrmanager->jpvt->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &mc_emlrtBCI, &st);
        }

        qrmanager->jpvt->data[idx] = idx + 1;
      }

      qrmanager->minRowCol = muIntScalarMin_sint32(workingset->nActiveConstr,
        workingset->nVar);
      b_st.site = &md_emlrtRSI;
      xgeqrf(&b_st, qrmanager->QR, workingset->nActiveConstr, workingset->nVar,
             qrmanager->tau);
      st.site = &ld_emlrtRSI;
      b_st.site = &oc_emlrtRSI;
      computeQ_(&b_st, qrmanager, workingset->nActiveConstr);
      mWConstr = workspace->size[0];
      i = b_workspace->size[0] * b_workspace->size[1];
      b_workspace->size[0] = workspace->size[0];
      b_workspace->size[1] = workspace->size[1];
      emxEnsureCapacity_real_T(sp, b_workspace, i, &rb_emlrtRTEI);
      mIneq = workspace->size[0] * workspace->size[1] - 1;
      for (i = 0; i <= mIneq; i++) {
        b_workspace->data[i] = workspace->data[i];
      }

      st.site = &ld_emlrtRSI;
      xgemm(workingset->nVar, workingset->nActiveConstr, qrmanager->Q,
            qrmanager->ldq, b_workspace, workspace->size[0], workspace,
            workspace->size[0]);
      st.site = &ld_emlrtRSI;
      xtrsm(workingset->nVar, qrmanager->QR, qrmanager->ldq, workspace, mWConstr);
    } else {
      st.site = &ld_emlrtRSI;
      factorQR(&st, qrmanager, workingset->ATwset, workingset->nVar,
               workingset->nActiveConstr);
      st.site = &ld_emlrtRSI;
      b_st.site = &xd_emlrtRSI;
      computeQ_(&b_st, qrmanager, qrmanager->minRowCol);
      mWConstr = workspace->size[0];
      st.site = &ld_emlrtRSI;
      b_xtrsm(workingset->nActiveConstr, qrmanager->QR, qrmanager->ldq,
              workspace, workspace->size[0]);
      i = b_workspace->size[0] * b_workspace->size[1];
      b_workspace->size[0] = workspace->size[0];
      b_workspace->size[1] = workspace->size[1];
      emxEnsureCapacity_real_T(sp, b_workspace, i, &rb_emlrtRTEI);
      mIneq = workspace->size[0] * workspace->size[1] - 1;
      for (i = 0; i <= mIneq; i++) {
        b_workspace->data[i] = workspace->data[i];
      }

      st.site = &ld_emlrtRSI;
      b_xgemm(workingset->nVar, workingset->nActiveConstr, qrmanager->Q,
              qrmanager->ldq, b_workspace, mWConstr, workspace, mWConstr);
    }

    emxFree_real_T(&b_workspace);
    st.site = &ld_emlrtRSI;
    if ((1 <= workingset->nVar) && (workingset->nVar > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    idx = 0;
    do {
      exitg1 = 0;
      if (idx <= nVar - 1) {
        i = workspace->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &lc_emlrtBCI, sp);
        }

        a = workspace->data[idx];
        if (muDoubleScalarIsInf(a) || muDoubleScalarIsNaN(a)) {
          nonDegenerateWset = false;
          exitg1 = 1;
        } else {
          i = workspace->size[0];
          if ((idx + 1 < 1) || (idx + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &lc_emlrtBCI, sp);
          }

          a = workspace->data[idx + workspace->size[0]];
          if (muDoubleScalarIsInf(a) || muDoubleScalarIsNaN(a)) {
            nonDegenerateWset = false;
            exitg1 = 1;
          } else {
            idx++;
          }
        }
      } else {
        st.site = &ld_emlrtRSI;
        b_st.site = &yd_emlrtRSI;
        c_st.site = &ae_emlrtRSI;
        a = 1.0;
        n_t = (ptrdiff_t)nVar;
        incx_t = (ptrdiff_t)1;
        incy_t = (ptrdiff_t)1;
        daxpy(&n_t, &a, &xCurrent->data[0], &incx_t, &workspace->data[0],
              &incy_t);
        st.site = &ld_emlrtRSI;
        mLB = workingset->sizes[3];
        switch (workingset->probType) {
         case 2:
          b_st.site = &be_emlrtRSI;
          a = 0.0;
          mIneq = workingset->sizes[2];
          mWConstr = workingset->sizes[1];
          if ((workingset->Aineq->size[0] != 0) && (workingset->Aineq->size[1]
               != 0)) {
            c_st.site = &ce_emlrtRSI;
            b_xcopy(workingset->sizes[2], workingset->bineq,
                    workingset->maxConstrWorkspace);
            c_st.site = &ce_emlrtRSI;
            d_xgemv(workingset->sizes[2], workingset->Aineq, workingset->ldA,
                    workspace, workingset->maxConstrWorkspace);
            c_st.site = &ce_emlrtRSI;
            if ((1 <= workingset->sizes[2]) && (workingset->sizes[2] >
                 2147483646)) {
              d_st.site = &s_emlrtRSI;
              check_forloop_overflow_error(&d_st);
            }

            for (idx = 0; idx < mIneq; idx++) {
              i = workingset->maxConstrWorkspace->size[0];
              if ((idx + 1 < 1) || (idx + 1 > i)) {
                emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &b_st);
              }

              i = workspace->size[0] * workspace->size[1];
              if ((idx + 67 < 1) || (idx + 67 > i)) {
                emlrtDynamicBoundsCheckR2012b(idx + 67, 1, i, &kc_emlrtBCI,
                  &b_st);
              }

              i = workingset->maxConstrWorkspace->size[0];
              if ((idx + 1 < 1) || (idx + 1 > i)) {
                emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &b_st);
              }

              workingset->maxConstrWorkspace->data[idx] -= workspace->data[idx +
                66];
              i = workingset->maxConstrWorkspace->size[0];
              if ((idx + 1 < 1) || (idx + 1 > i)) {
                emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &b_st);
              }

              a = muDoubleScalarMax(a, workingset->maxConstrWorkspace->data[idx]);
            }
          }

          c_st.site = &ce_emlrtRSI;
          b_xcopy(workingset->sizes[1], workingset->beq,
                  workingset->maxConstrWorkspace);
          c_st.site = &ce_emlrtRSI;
          d_xgemv(workingset->sizes[1], workingset->Aeq, workingset->ldA,
                  workspace, workingset->maxConstrWorkspace);
          offsetEq2 = (workingset->sizes[2] + workingset->sizes[1]) + 66;
          c_st.site = &ce_emlrtRSI;
          if ((1 <= workingset->sizes[1]) && (workingset->sizes[1] > 2147483646))
          {
            d_st.site = &s_emlrtRSI;
            check_forloop_overflow_error(&d_st);
          }

          for (idx = 0; idx < mWConstr; idx++) {
            i = workingset->maxConstrWorkspace->size[0];
            if ((idx + 1 < 1) || (idx + 1 > i)) {
              emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &b_st);
            }

            i = workspace->size[0] * workspace->size[1];
            i1 = (mIneq + idx) + 67;
            if ((i1 < 1) || (i1 > i)) {
              emlrtDynamicBoundsCheckR2012b(i1, 1, i, &kc_emlrtBCI, &b_st);
            }

            i = workspace->size[0] * workspace->size[1];
            i2 = (offsetEq2 + idx) + 1;
            if ((i2 < 1) || (i2 > i)) {
              emlrtDynamicBoundsCheckR2012b(i2, 1, i, &kc_emlrtBCI, &b_st);
            }

            i = workingset->maxConstrWorkspace->size[0];
            if ((idx + 1 < 1) || (idx + 1 > i)) {
              emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &b_st);
            }

            workingset->maxConstrWorkspace->data[idx] =
              (workingset->maxConstrWorkspace->data[idx] - workspace->data[i1 -
               1]) + workspace->data[i2 - 1];
            i = workingset->maxConstrWorkspace->size[0];
            if ((idx + 1 < 1) || (idx + 1 > i)) {
              emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &kc_emlrtBCI, &b_st);
            }

            a = muDoubleScalarMax(a, muDoubleScalarAbs
                                  (workingset->maxConstrWorkspace->data[idx]));
          }
          break;

         default:
          b_st.site = &be_emlrtRSI;
          a = 0.0;
          mIneq = workingset->sizes[2];
          mWConstr = workingset->sizes[1];
          if ((workingset->Aineq->size[0] != 0) && (workingset->Aineq->size[1]
               != 0)) {
            c_st.site = &de_emlrtRSI;
            b_xcopy(workingset->sizes[2], workingset->bineq,
                    workingset->maxConstrWorkspace);
            c_st.site = &de_emlrtRSI;
            e_xgemv(workingset->nVar, workingset->sizes[2], workingset->Aineq,
                    workingset->ldA, workspace, workingset->maxConstrWorkspace);
            c_st.site = &de_emlrtRSI;
            if ((1 <= workingset->sizes[2]) && (workingset->sizes[2] >
                 2147483646)) {
              d_st.site = &s_emlrtRSI;
              check_forloop_overflow_error(&d_st);
            }

            for (idx = 0; idx < mIneq; idx++) {
              i = workingset->maxConstrWorkspace->size[0];
              if ((idx + 1 < 1) || (idx + 1 > i)) {
                emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &jc_emlrtBCI, &b_st);
              }

              a = muDoubleScalarMax(a, workingset->maxConstrWorkspace->data[idx]);
            }
          }

          c_st.site = &de_emlrtRSI;
          b_xcopy(workingset->sizes[1], workingset->beq,
                  workingset->maxConstrWorkspace);
          c_st.site = &de_emlrtRSI;
          e_xgemv(workingset->nVar, workingset->sizes[1], workingset->Aeq,
                  workingset->ldA, workspace, workingset->maxConstrWorkspace);
          c_st.site = &de_emlrtRSI;
          if ((1 <= workingset->sizes[1]) && (workingset->sizes[1] > 2147483646))
          {
            d_st.site = &s_emlrtRSI;
            check_forloop_overflow_error(&d_st);
          }

          for (idx = 0; idx < mWConstr; idx++) {
            i = workingset->maxConstrWorkspace->size[0];
            if ((idx + 1 < 1) || (idx + 1 > i)) {
              emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &jc_emlrtBCI, &b_st);
            }

            a = muDoubleScalarMax(a, muDoubleScalarAbs
                                  (workingset->maxConstrWorkspace->data[idx]));
          }
          break;
        }

        if (workingset->sizes[3] > 0) {
          b_st.site = &be_emlrtRSI;
          if ((1 <= workingset->sizes[3]) && (workingset->sizes[3] > 2147483646))
          {
            c_st.site = &s_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (idx = 0; idx < mLB; idx++) {
            i = workingset->indexLB->size[0];
            if ((idx + 1 < 1) || (idx + 1 > i)) {
              emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &ic_emlrtBCI, &st);
            }

            mWConstr = workingset->indexLB->data[idx] - 1;
            i = workspace->size[0] * workspace->size[1];
            if ((workingset->indexLB->data[idx] < 1) || (workingset->
                 indexLB->data[idx] > i)) {
              emlrtDynamicBoundsCheckR2012b(workingset->indexLB->data[idx], 1, i,
                &ic_emlrtBCI, &st);
            }

            i = workingset->lb->size[0];
            if ((workingset->indexLB->data[idx] < 1) || (workingset->
                 indexLB->data[idx] > i)) {
              emlrtDynamicBoundsCheckR2012b(workingset->indexLB->data[idx], 1, i,
                &ic_emlrtBCI, &st);
            }

            a = muDoubleScalarMax(a, -workspace->data[mWConstr] - workingset->
                                  lb->data[mWConstr]);
          }
        }

        st.site = &ld_emlrtRSI;
        constrViolation_basicX = maxConstraintViolation(&st, workingset,
          workspace, workspace->size[0] + 1);
        if ((a <= 2.2204460492503131E-16) || (a < constrViolation_basicX)) {
          st.site = &ld_emlrtRSI;
          if (nVar >= 1) {
            b_st.site = &fb_emlrtRSI;
            c_st.site = &hb_emlrtRSI;
            n_t = (ptrdiff_t)nVar;
            incx_t = (ptrdiff_t)1;
            incy_t = (ptrdiff_t)1;
            dcopy(&n_t, &workspace->data[0], &incx_t, &xCurrent->data[0],
                  &incy_t);
          }
        } else {
          st.site = &ld_emlrtRSI;
          b_st.site = &fb_emlrtRSI;
          c_st.site = &hb_emlrtRSI;
          n_t = (ptrdiff_t)nVar;
          incx_t = (ptrdiff_t)1;
          incy_t = (ptrdiff_t)1;
          dcopy(&n_t, &workspace->data[workspace->size[0]], &incx_t,
                &xCurrent->data[0], &incy_t);
        }

        exitg1 = 1;
      }
    } while (exitg1 == 0);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
  return nonDegenerateWset;
}

/* End of code generation (feasibleX0ForWorkingSet.c) */
