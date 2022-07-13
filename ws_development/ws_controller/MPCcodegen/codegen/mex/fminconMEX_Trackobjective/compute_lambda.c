/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * compute_lambda.c
 *
 * Code generation for function 'compute_lambda'
 *
 */

/* Include files */
#include "compute_lambda.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xgemv.h"
#include "xtrsv.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo af_emlrtRSI = { 1,  /* lineNo */
  "compute_lambda",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_lambda.p"/* pathName */
};

static emlrtBCInfo ed_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "isNonDegenerate",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+QRManager\\isNonDegenerate.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "compute_lambda",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_lambda.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void compute_lambda(const emlrtStack *sp, emxArray_real_T *workspace, d_struct_T
                    *solution, const i_struct_T *objective, const g_struct_T
                    *qrmanager)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T tol;
  int32_T exitg2;
  int32_T i;
  int32_T idx;
  int32_T nActiveConstr;
  boolean_T exitg3;
  boolean_T guard1 = false;
  boolean_T nonDegenerate;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nActiveConstr = qrmanager->ncols;
  if (qrmanager->ncols > 0) {
    tol = 100.0 * (real_T)qrmanager->mrows * 2.2204460492503131E-16;
    st.site = &af_emlrtRSI;
    if ((qrmanager->mrows > 0) && (qrmanager->ncols > 0)) {
      nonDegenerate = true;
    } else {
      nonDegenerate = false;
    }

    if (nonDegenerate) {
      idx = qrmanager->ncols;
      guard1 = false;
      if (qrmanager->mrows < qrmanager->ncols) {
        exitg3 = false;
        while ((!exitg3) && (idx > qrmanager->mrows)) {
          i = qrmanager->QR->size[0];
          if ((qrmanager->mrows < 1) || (qrmanager->mrows > i)) {
            emlrtDynamicBoundsCheckR2012b(qrmanager->mrows, 1, i, &ed_emlrtBCI,
              &st);
          }

          i = qrmanager->QR->size[1];
          if ((idx < 1) || (idx > i)) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, i, &ed_emlrtBCI, &st);
          }

          if (muDoubleScalarAbs(qrmanager->QR->data[(qrmanager->mrows +
                qrmanager->QR->size[0] * (idx - 1)) - 1]) >= tol) {
            idx--;
          } else {
            exitg3 = true;
          }
        }

        nonDegenerate = (idx == qrmanager->mrows);
        if (nonDegenerate) {
          guard1 = true;
        }
      } else {
        guard1 = true;
      }

      if (guard1) {
        do {
          exitg2 = 0;
          if (idx >= 1) {
            i = qrmanager->QR->size[0];
            if (idx > i) {
              emlrtDynamicBoundsCheckR2012b(idx, 1, i, &ed_emlrtBCI, &st);
            }

            i = qrmanager->QR->size[1];
            if (idx > i) {
              emlrtDynamicBoundsCheckR2012b(idx, 1, i, &ed_emlrtBCI, &st);
            }

            if (muDoubleScalarAbs(qrmanager->QR->data[(idx + qrmanager->QR->
                  size[0] * (idx - 1)) - 1]) >= tol) {
              idx--;
            } else {
              nonDegenerate = (idx == 0);
              exitg2 = 1;
            }
          } else {
            nonDegenerate = (idx == 0);
            exitg2 = 1;
          }
        } while (exitg2 == 0);
      }
    }

    if (!nonDegenerate) {
      solution->state = -7;
    } else {
      st.site = &af_emlrtRSI;
      b_xgemv(qrmanager->mrows, qrmanager->ncols, qrmanager->Q, qrmanager->ldq,
              objective->grad, workspace);
      st.site = &af_emlrtRSI;
      xtrsv(qrmanager->ncols, qrmanager->QR, qrmanager->ldq, workspace);
      st.site = &af_emlrtRSI;
      if ((1 <= qrmanager->ncols) && (qrmanager->ncols > 2147483646)) {
        b_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idx = 0; idx < nActiveConstr; idx++) {
        i = workspace->size[0] * workspace->size[1];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &fd_emlrtBCI, sp);
        }

        i = solution->lambda->size[0];
        if ((idx + 1 < 1) || (idx + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &fd_emlrtBCI, sp);
        }

        solution->lambda->data[idx] = -workspace->data[idx];
      }
    }
  }
}

/* End of code generation (compute_lambda.c) */
