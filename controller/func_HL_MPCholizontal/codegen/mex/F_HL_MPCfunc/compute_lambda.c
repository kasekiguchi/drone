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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xgemv.h"
#include "xtrsv.h"

/* Variable Definitions */
static emlrtRSInfo rj_emlrtRSI = { 1,  /* lineNo */
  "compute_lambda",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_lambda.p"/* pathName */
};

static emlrtBCInfo ge_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "isNonDegenerate",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\isNonDegenerate.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo he_emlrtBCI = { 1,  /* iFirst */
  299245,                              /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "compute_lambda",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_lambda.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ie_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "compute_lambda",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_lambda.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void compute_lambda(const emlrtStack *sp, real_T workspace[299245], e_struct_T
                    *solution, const j_struct_T *objective, const k_struct_T
                    *qrmanager)
{
  int32_T nActiveConstr;
  real_T tol;
  boolean_T nonDegenerate;
  int32_T idx;
  boolean_T guard1 = false;
  boolean_T exitg3;
  int32_T exitg2;
  int32_T b_idx;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nActiveConstr = qrmanager->ncols;
  if (qrmanager->ncols > 0) {
    tol = 100.0 * (real_T)qrmanager->mrows * 2.2204460492503131E-16;
    st.site = &rj_emlrtRSI;
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
          if ((qrmanager->mrows < 1) || (qrmanager->mrows > 617)) {
            emlrtDynamicBoundsCheckR2012b(qrmanager->mrows, 1, 617, &ge_emlrtBCI,
              &st);
          }

          if ((idx < 1) || (idx > 617)) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &ge_emlrtBCI, &st);
          }

          if (muDoubleScalarAbs(qrmanager->QR[(qrmanager->mrows + 617 * (idx - 1))
                                - 1]) >= tol) {
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
            if (idx > 617) {
              emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &ge_emlrtBCI, &st);
            }

            if (muDoubleScalarAbs(qrmanager->QR[(idx + 617 * (idx - 1)) - 1]) >=
                tol) {
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
      st.site = &rj_emlrtRSI;
      xgemv(qrmanager->mrows, qrmanager->ncols, qrmanager->Q, objective->grad,
            workspace);
      st.site = &rj_emlrtRSI;
      xtrsv(qrmanager->ncols, qrmanager->QR, workspace);
      st.site = &rj_emlrtRSI;
      if ((1 <= qrmanager->ncols) && (qrmanager->ncols > 2147483646)) {
        b_st.site = &t_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idx = 0; idx < nActiveConstr; idx++) {
        b_idx = idx + 1;
        if ((b_idx < 1) || (b_idx > 299245)) {
          emlrtDynamicBoundsCheckR2012b(b_idx, 1, 299245, &he_emlrtBCI, sp);
        }

        if (b_idx > 617) {
          emlrtDynamicBoundsCheckR2012b(b_idx, 1, 617, &ie_emlrtBCI, sp);
        }

        solution->lambda[b_idx - 1] = -workspace[b_idx - 1];
      }
    }
  }
}

/* End of code generation (compute_lambda.c) */
