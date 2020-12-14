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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "computeQ_.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQRE.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgemv.h"
#include "xtrsv.h"

/* Variable Definitions */
static emlrtRSInfo ec_emlrtRSI = { 1,  /* lineNo */
  "computeLambdaLSQ",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeLambdaLSQ.p"/* pathName */
};

static emlrtBCInfo y_emlrtBCI = { 1,   /* iFirst */
  94249,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeLambdaLSQ",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeLambdaLSQ.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ab_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeLambdaLSQ",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeLambdaLSQ.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void computeLambdaLSQ(const emlrtStack *sp, int32_T nVar, int32_T mConstr,
                      k_struct_T *QRManager, const real_T ATwset[93635], const
                      real_T grad[307], real_T lambdaLSQ[305], real_T workspace
                      [94249])
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
  st.site = &ec_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_xcopy(&st, mConstr, lambdaLSQ);
  st.site = &ec_emlrtRSI;
  factorQRE(&st, QRManager, ATwset, nVar, mConstr);
  st.site = &ec_emlrtRSI;
  b_st.site = &fc_emlrtRSI;
  computeQ_(&b_st, QRManager, QRManager->mrows);
  st.site = &ec_emlrtRSI;
  xgemv(nVar, nVar, QRManager->Q, grad, workspace);
  tol = muDoubleScalarAbs(QRManager->QR[0]) * muDoubleScalarMin
    (1.4901161193847656E-8, (real_T)muIntScalarMax_sint32(nVar, mConstr) *
     2.2204460492503131E-16);
  fullRank_R = muIntScalarMin_sint32(nVar, mConstr);
  rankR = 0;
  iQR_diag = 1;
  exitg1 = false;
  while ((!exitg1) && (rankR < fullRank_R)) {
    if (iQR_diag > 94249) {
      emlrtDynamicBoundsCheckR2012b(iQR_diag, 1, 94249, &y_emlrtBCI, sp);
    }

    if (muDoubleScalarAbs(QRManager->QR[iQR_diag - 1]) > tol) {
      rankR++;
      iQR_diag += 308;
    } else {
      exitg1 = true;
    }
  }

  st.site = &ec_emlrtRSI;
  xtrsv(rankR, QRManager->QR, workspace);
  fullRank_R = muIntScalarMin_sint32(mConstr, fullRank_R);
  st.site = &ec_emlrtRSI;
  if ((1 <= fullRank_R) && (fullRank_R > 2147483646)) {
    b_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (rankR = 0; rankR < fullRank_R; rankR++) {
    if ((QRManager->jpvt[rankR] < 1) || (QRManager->jpvt[rankR] > 305)) {
      emlrtDynamicBoundsCheckR2012b(QRManager->jpvt[rankR], 1, 305, &ab_emlrtBCI,
        sp);
    }

    lambdaLSQ[QRManager->jpvt[rankR] - 1] = workspace[rankR];
  }
}

/* End of code generation (computeLambdaLSQ.c) */
