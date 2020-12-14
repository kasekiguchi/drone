/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeLambdaLSQ.c
 *
 * Code generation for function 'computeLambdaLSQ'
 *
 */

/* Include files */
#include "computeLambdaLSQ.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "computeQ_.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQRE.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgemv.h"
#include "xtrsv.h"

/* Variable Definitions */
static emlrtRSInfo tg_emlrtRSI = { 1,  /* lineNo */
  "computeLambdaLSQ",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeLambdaLSQ.p"/* pathName */
};

static emlrtBCInfo wb_emlrtBCI = { 1,  /* iFirst */
  380689,                              /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeLambdaLSQ",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeLambdaLSQ.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xb_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeLambdaLSQ",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeLambdaLSQ.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void computeLambdaLSQ(const emlrtStack *sp, int32_T nVar, int32_T mConstr,
                      k_struct_T *QRManager, const real_T ATwset[299245], const
                      real_T grad[485], real_T lambdaLSQ[617], real_T workspace
                      [299245])
{
  real_T tol;
  int32_T fullRank_R;
  int32_T rankR;
  int32_T iQR_diag;
  boolean_T exitg1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &tg_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_xcopy(&st, mConstr, lambdaLSQ);
  st.site = &tg_emlrtRSI;
  factorQRE(&st, QRManager, ATwset, nVar, mConstr);
  st.site = &tg_emlrtRSI;
  b_st.site = &ug_emlrtRSI;
  computeQ_(&b_st, QRManager, QRManager->mrows);
  st.site = &tg_emlrtRSI;
  xgemv(nVar, nVar, QRManager->Q, grad, workspace);
  tol = muDoubleScalarAbs(QRManager->QR[0]) * muDoubleScalarMin
    (1.4901161193847656E-8, (real_T)muIntScalarMax_sint32(nVar, mConstr) *
     2.2204460492503131E-16);
  fullRank_R = muIntScalarMin_sint32(nVar, mConstr);
  rankR = 0;
  iQR_diag = 1;
  exitg1 = false;
  while ((!exitg1) && (rankR < fullRank_R)) {
    if (iQR_diag > 380689) {
      emlrtDynamicBoundsCheckR2012b(iQR_diag, 1, 380689, &wb_emlrtBCI, sp);
    }

    if (muDoubleScalarAbs(QRManager->QR[iQR_diag - 1]) > tol) {
      rankR++;
      iQR_diag += 618;
    } else {
      exitg1 = true;
    }
  }

  st.site = &tg_emlrtRSI;
  xtrsv(rankR, QRManager->QR, workspace);
  fullRank_R = muIntScalarMin_sint32(mConstr, fullRank_R);
  st.site = &tg_emlrtRSI;
  if ((1 <= fullRank_R) && (fullRank_R > 2147483646)) {
    b_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (rankR = 0; rankR < fullRank_R; rankR++) {
    if ((QRManager->jpvt[rankR] < 1) || (QRManager->jpvt[rankR] > 617)) {
      emlrtDynamicBoundsCheckR2012b(QRManager->jpvt[rankR], 1, 617, &xb_emlrtBCI,
        sp);
    }

    lambdaLSQ[QRManager->jpvt[rankR] - 1] = workspace[rankR];
  }
}

/* End of code generation (computeLambdaLSQ.c) */
