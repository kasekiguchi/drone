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
#include "computeQ_.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQRE.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgemv.h"
#include "xtrsv.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo yb_emlrtRSI = { 1,  /* lineNo */
  "computeLambdaLSQ",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeLambdaLSQ.p"/* pathName */
};

static emlrtBCInfo pb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeLambdaLSQ",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+stopping\\computeLambdaLSQ.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void computeLambdaLSQ(const emlrtStack *sp, int32_T nVar, int32_T mConstr,
                      g_struct_T *QRManager, const emxArray_real_T *ATwset,
                      const emxArray_real_T *grad, emxArray_real_T *lambdaLSQ,
                      emxArray_real_T *workspace)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T tol;
  int32_T fullRank_R;
  int32_T i;
  int32_T iQR_diag;
  int32_T rankR;
  boolean_T exitg1;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &yb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_xcopy(&st, mConstr, lambdaLSQ);
  st.site = &yb_emlrtRSI;
  factorQRE(&st, QRManager, ATwset, nVar, mConstr);
  st.site = &yb_emlrtRSI;
  b_st.site = &oc_emlrtRSI;
  computeQ_(&b_st, QRManager, QRManager->mrows);
  st.site = &yb_emlrtRSI;
  b_xgemv(nVar, nVar, QRManager->Q, QRManager->ldq, grad, workspace);
  tol = muDoubleScalarAbs(QRManager->QR->data[0]) * muDoubleScalarMin
    (1.4901161193847656E-8, (real_T)muIntScalarMax_sint32(nVar, mConstr) *
     2.2204460492503131E-16);
  fullRank_R = muIntScalarMin_sint32(nVar, mConstr);
  rankR = 0;
  iQR_diag = 1;
  exitg1 = false;
  while ((!exitg1) && (rankR < fullRank_R)) {
    i = QRManager->QR->size[0] * QRManager->QR->size[1];
    if ((iQR_diag < 1) || (iQR_diag > i)) {
      emlrtDynamicBoundsCheckR2012b(iQR_diag, 1, i, &pb_emlrtBCI, sp);
    }

    if (muDoubleScalarAbs(QRManager->QR->data[iQR_diag - 1]) > tol) {
      rankR++;
      iQR_diag = (iQR_diag + QRManager->ldq) + 1;
    } else {
      exitg1 = true;
    }
  }

  st.site = &yb_emlrtRSI;
  xtrsv(rankR, QRManager->QR, QRManager->ldq, workspace);
  fullRank_R = muIntScalarMin_sint32(mConstr, fullRank_R);
  st.site = &yb_emlrtRSI;
  if ((1 <= fullRank_R) && (fullRank_R > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (iQR_diag = 0; iQR_diag < fullRank_R; iQR_diag++) {
    i = QRManager->jpvt->size[0];
    if ((iQR_diag + 1 < 1) || (iQR_diag + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(iQR_diag + 1, 1, i, &pb_emlrtBCI, sp);
    }

    i = workspace->size[0] * workspace->size[1];
    if ((iQR_diag + 1 < 1) || (iQR_diag + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(iQR_diag + 1, 1, i, &pb_emlrtBCI, sp);
    }

    i = lambdaLSQ->size[0];
    rankR = QRManager->jpvt->data[iQR_diag];
    if ((rankR < 1) || (rankR > i)) {
      emlrtDynamicBoundsCheckR2012b(rankR, 1, i, &pb_emlrtBCI, sp);
    }

    lambdaLSQ->data[rankR - 1] = workspace->data[iQR_diag];
  }
}

/* End of code generation (computeLambdaLSQ.c) */
