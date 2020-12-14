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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "computeQ_.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQR.h"
#include "maxConstraintViolation.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xaxpy.h"
#include "xgemm.h"
#include "xgemv.h"
#include "xgeqrf.h"
#include "xtrsm.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo od_emlrtRSI = { 1,  /* lineNo */
  "computeTallQ",                      /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\computeTallQ.p"/* pathName */
};

static emlrtRSInfo vd_emlrtRSI = { 1,  /* lineNo */
  "feasibleX0ForWorkingSet",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\feasibleX0ForWorkingSet.p"/* pathName */
};

static emlrtRSInfo xd_emlrtRSI = { 1,  /* lineNo */
  "maxConstraintViolation_AMats_regularized_",/* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation_AMats_regularized_.p"/* pathName */
};

static emlrtRSInfo yd_emlrtRSI = { 1,  /* lineNo */
  "maxConstraintViolation_AMats_nonregularized_",/* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\maxConstraintViolation_AMats_nonregularized_"
  ".p"                                 /* pathName */
};

static emlrtBCInfo gc_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "feasibleX0ForWorkingSet",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\feasibleX0ForWorkingSet.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hc_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "feasibleX0ForWorkingSet",           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+initialize\\feasibleX0ForWorkingSet.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
boolean_T feasibleX0ForWorkingSet(L_HL_MPCfuncStackData *SD, const emlrtStack
  *sp, real_T workspace[94249], real_T xCurrent[307], g_struct_T *workingset,
  k_struct_T *qrmanager)
{
  boolean_T nonDegenerateWset;
  int32_T mWConstr;
  int32_T nVar;
  int32_T idx;
  int32_T mLB;
  int32_T idxLB;
  int32_T exitg1;
  real_T v;
  real_T constrViolation_basicX;
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
  mWConstr = workingset->nActiveConstr;
  nVar = workingset->nVar;
  nonDegenerateWset = true;
  if (workingset->nActiveConstr != 0) {
    st.site = &vd_emlrtRSI;
    if ((1 <= workingset->nActiveConstr) && (workingset->nActiveConstr >
         2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < mWConstr; idx++) {
      mLB = idx + 1;
      if ((mLB < 1) || (mLB > 305)) {
        emlrtDynamicBoundsCheckR2012b(mLB, 1, 305, &gc_emlrtBCI, sp);
      }

      idxLB = idx + 1;
      if ((idxLB < 1) || (idxLB > 307)) {
        emlrtDynamicBoundsCheckR2012b(idxLB, 1, 307, &hc_emlrtBCI, sp);
      }

      workspace[idxLB - 1] = workingset->bwset[mLB - 1];
      workspace[idx + 307] = workingset->bwset[idx];
    }

    st.site = &vd_emlrtRSI;
    b_xgemv(workingset->nVar, workingset->nActiveConstr, workingset->ATwset,
            xCurrent, workspace);
    if (workingset->nActiveConstr >= workingset->nVar) {
      st.site = &vd_emlrtRSI;
      if ((1 <= workingset->nVar) && (workingset->nVar > 2147483646)) {
        b_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&b_st);
      }

      for (idxLB = 0; idxLB < nVar; idxLB++) {
        st.site = &vd_emlrtRSI;
        if ((1 <= mWConstr) && (mWConstr > 2147483646)) {
          b_st.site = &e_emlrtRSI;
          check_forloop_overflow_error(&b_st);
        }

        for (idx = 0; idx < mWConstr; idx++) {
          mLB = idx + 1;
          if ((mLB < 1) || (mLB > 305)) {
            emlrtDynamicBoundsCheckR2012b(mLB, 1, 305, &gc_emlrtBCI, sp);
          }

          qrmanager->QR[(mLB + 307 * idxLB) - 1] = workingset->ATwset[idxLB +
            307 * (mLB - 1)];
        }
      }

      st.site = &vd_emlrtRSI;
      mLB = workingset->nVar;
      qrmanager->usedPivoting = false;
      qrmanager->mrows = workingset->nActiveConstr;
      qrmanager->ncols = workingset->nVar;
      b_st.site = &ad_emlrtRSI;
      if ((1 <= workingset->nVar) && (workingset->nVar > 2147483646)) {
        c_st.site = &e_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx = 0; idx < mLB; idx++) {
        qrmanager->jpvt[idx] = idx + 1;
      }

      qrmanager->minRowCol = muIntScalarMin_sint32(workingset->nActiveConstr,
        workingset->nVar);
      b_st.site = &ad_emlrtRSI;
      xgeqrf(&b_st, qrmanager->QR, workingset->nActiveConstr, workingset->nVar,
             qrmanager->tau);
      st.site = &vd_emlrtRSI;
      b_st.site = &fc_emlrtRSI;
      computeQ_(&b_st, qrmanager, workingset->nActiveConstr);
      memcpy(&SD->f0.dv[0], &workspace[0], 94249U * sizeof(real_T));
      st.site = &vd_emlrtRSI;
      xgemm(workingset->nVar, workingset->nActiveConstr, qrmanager->Q, SD->f0.dv,
            workspace);
      st.site = &vd_emlrtRSI;
      xtrsm(workingset->nVar, qrmanager->QR, workspace);
    } else {
      st.site = &vd_emlrtRSI;
      factorQR(&st, qrmanager, workingset->ATwset, workingset->nVar,
               workingset->nActiveConstr);
      st.site = &vd_emlrtRSI;
      b_st.site = &od_emlrtRSI;
      computeQ_(&b_st, qrmanager, qrmanager->minRowCol);
      st.site = &vd_emlrtRSI;
      b_xtrsm(workingset->nActiveConstr, qrmanager->QR, workspace);
      memcpy(&SD->f0.dv[0], &workspace[0], 94249U * sizeof(real_T));
      st.site = &vd_emlrtRSI;
      b_xgemm(workingset->nVar, workingset->nActiveConstr, qrmanager->Q,
              SD->f0.dv, workspace);
    }

    st.site = &vd_emlrtRSI;
    if ((1 <= workingset->nVar) && (workingset->nVar > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    idx = 0;
    do {
      exitg1 = 0;
      if (idx <= nVar - 1) {
        if (muDoubleScalarIsInf(workspace[idx]) || muDoubleScalarIsNaN
            (workspace[idx])) {
          nonDegenerateWset = false;
          exitg1 = 1;
        } else {
          v = workspace[idx + 307];
          if (muDoubleScalarIsInf(v) || muDoubleScalarIsNaN(v)) {
            nonDegenerateWset = false;
            exitg1 = 1;
          } else {
            idx++;
          }
        }
      } else {
        st.site = &vd_emlrtRSI;
        xaxpy(nVar, xCurrent, workspace);
        st.site = &vd_emlrtRSI;
        mLB = workingset->sizes[3];
        switch (workingset->probType) {
         case 2:
          b_st.site = &wd_emlrtRSI;
          v = 0.0;
          c_st.site = &xd_emlrtRSI;
          memcpy(&workingset->maxConstrWorkspace[0], &workingset->bineq[0], 20U *
                 sizeof(real_T));
          c_st.site = &xd_emlrtRSI;
          c_xgemv(workingset->Aineq, workspace, workingset->maxConstrWorkspace);
          c_st.site = &xd_emlrtRSI;
          for (idx = 0; idx < 20; idx++) {
            workingset->maxConstrWorkspace[idx] -= workspace[idx + 110];
            v = muDoubleScalarMax(v, workingset->maxConstrWorkspace[idx]);
          }

          c_st.site = &xd_emlrtRSI;
          memcpy(&workingset->maxConstrWorkspace[0], &workingset->beq[0], 88U *
                 sizeof(real_T));
          c_st.site = &xd_emlrtRSI;
          d_xgemv(110, workingset->Aeq, workspace,
                  workingset->maxConstrWorkspace);
          c_st.site = &xd_emlrtRSI;
          for (idx = 0; idx < 88; idx++) {
            workingset->maxConstrWorkspace[idx] =
              (workingset->maxConstrWorkspace[idx] - workspace[idx + 130]) +
              workspace[idx + 218];
            v = muDoubleScalarMax(v, muDoubleScalarAbs
                                  (workingset->maxConstrWorkspace[idx]));
          }
          break;

         default:
          b_st.site = &wd_emlrtRSI;
          v = 0.0;
          c_st.site = &yd_emlrtRSI;
          memcpy(&workingset->maxConstrWorkspace[0], &workingset->bineq[0], 20U *
                 sizeof(real_T));
          c_st.site = &yd_emlrtRSI;
          e_xgemv(workingset->nVar, workingset->Aineq, workspace,
                  workingset->maxConstrWorkspace);
          c_st.site = &yd_emlrtRSI;
          for (idx = 0; idx < 20; idx++) {
            v = muDoubleScalarMax(v, workingset->maxConstrWorkspace[idx]);
          }

          c_st.site = &yd_emlrtRSI;
          memcpy(&workingset->maxConstrWorkspace[0], &workingset->beq[0], 88U *
                 sizeof(real_T));
          c_st.site = &yd_emlrtRSI;
          d_xgemv(workingset->nVar, workingset->Aeq, workspace,
                  workingset->maxConstrWorkspace);
          c_st.site = &yd_emlrtRSI;
          for (idx = 0; idx < 88; idx++) {
            v = muDoubleScalarMax(v, muDoubleScalarAbs
                                  (workingset->maxConstrWorkspace[idx]));
          }
          break;
        }

        if (workingset->sizes[3] > 0) {
          b_st.site = &wd_emlrtRSI;
          if ((1 <= workingset->sizes[3]) && (workingset->sizes[3] > 2147483646))
          {
            c_st.site = &e_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (idx = 0; idx < mLB; idx++) {
            idxLB = workingset->indexLB[idx] - 1;
            if ((workingset->indexLB[idx] < 1) || (workingset->indexLB[idx] >
                 94249)) {
              emlrtDynamicBoundsCheckR2012b(workingset->indexLB[idx], 1, 94249,
                &fc_emlrtBCI, &st);
            }

            if ((workingset->indexLB[idx] < 1) || (workingset->indexLB[idx] >
                 307)) {
              emlrtDynamicBoundsCheckR2012b(workingset->indexLB[idx], 1, 307,
                &ec_emlrtBCI, &st);
            }

            v = muDoubleScalarMax(v, -workspace[idxLB] - workingset->lb[idxLB]);
          }
        }

        st.site = &vd_emlrtRSI;
        constrViolation_basicX = maxConstraintViolation(&st, workingset,
          workspace);
        if ((v <= 2.2204460492503131E-16) || (v < constrViolation_basicX)) {
          st.site = &vd_emlrtRSI;
          b_st.site = &i_emlrtRSI;
          c_st.site = &j_emlrtRSI;
          if ((1 <= nVar) && (nVar > 2147483646)) {
            d_st.site = &e_emlrtRSI;
            check_forloop_overflow_error(&d_st);
          }

          if (0 <= nVar - 1) {
            memcpy(&xCurrent[0], &workspace[0], nVar * sizeof(real_T));
          }
        } else {
          st.site = &vd_emlrtRSI;
          b_st.site = &i_emlrtRSI;
          c_st.site = &j_emlrtRSI;
          if ((1 <= nVar) && (nVar > 2147483646)) {
            d_st.site = &e_emlrtRSI;
            check_forloop_overflow_error(&d_st);
          }

          if (0 <= nVar - 1) {
            memcpy(&xCurrent[0], &workspace[307], nVar * sizeof(real_T));
          }
        }

        exitg1 = 1;
      }
    } while (exitg1 == 0);
  }

  return nonDegenerateWset;
}

/* End of code generation (feasibleX0ForWorkingSet.c) */
