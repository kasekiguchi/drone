/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * iterate.c
 *
 * Code generation for function 'iterate'
 *
 */

/* Include files */
#include "iterate.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "addBoundToActiveSetMatrix_.h"
#include "blas.h"
#include "checkStoppingAndUpdateFval.h"
#include "computeFval_ReuseHx.h"
#include "computeGrad_StoreHx.h"
#include "computeQ_.h"
#include "compute_deltax.h"
#include "compute_lambda.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQR.h"
#include "feasibleratiotest.h"
#include "moveConstraint_.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "squareQ_appendCol.h"
#include "xaxpy.h"
#include "xcopy.h"
#include "xnrm2.h"
#include "xrot.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo wi_emlrtRSI = { 1,  /* lineNo */
  "iterate",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\iterate.p"/* pathName */
};

static emlrtRSInfo bj_emlrtRSI = { 28, /* lineNo */
  "xrotg",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xrotg.m"/* pathName */
};

static emlrtRSInfo cj_emlrtRSI = { 27, /* lineNo */
  "xrotg",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xrotg.m"/* pathName */
};

static emlrtRSInfo fj_emlrtRSI = { 1,  /* lineNo */
  "deleteColMoveEnd",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\deleteColMoveEnd.p"/* pathName */
};

static emlrtRSInfo sj_emlrtRSI = { 1,  /* lineNo */
  "find_neg_lambda",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\find_neg_lambda.p"/* pathName */
};

static emlrtRSInfo yj_emlrtRSI = { 1,  /* lineNo */
  "checkUnboundedOrIllPosed",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+stopping\\checkUnboundedOrIllPosed.p"/* pathName */
};

static emlrtBCInfo md_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "iterate",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\iterate.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nd_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "deleteColMoveEnd",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\deleteColMoveEnd.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo pd_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "deleteColMoveEnd",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\deleteColMoveEnd.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sd_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "find_neg_lambda",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\find_neg_lambda.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void iterate(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T H
             [17424], const real_T f[485], e_struct_T *solution, b_struct_T
             *memspace, g_struct_T *workingset, k_struct_T *qrmanager,
             l_struct_T *cholmanager, j_struct_T *objective, real_T
             options_StepTolerance, real_T options_ObjectiveLimit, int32_T
             runTimeOptions_MaxIterations)
{
  boolean_T subProblemChanged;
  boolean_T updateFval;
  int32_T activeSetChangeID;
  int32_T TYPE;
  int32_T nVar;
  int32_T globalActiveConstrIdx;
  int32_T exitg1;
  boolean_T guard1 = false;
  int32_T i;
  real_T normDelta;
  boolean_T exitg2;
  real_T b;
  int32_T b_i;
  int32_T QRk0;
  int32_T idxMinLambda;
  int32_T b_TYPE;
  int32_T k;
  int32_T b_k;
  int32_T endIdx;
  real_T c;
  real_T s;
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
  subProblemChanged = true;
  updateFval = true;
  activeSetChangeID = 0;
  TYPE = objective->objtype;
  nVar = workingset->nVar;
  globalActiveConstrIdx = 0;
  st.site = &wi_emlrtRSI;
  computeGrad_StoreHx(&st, objective, H, f, solution->xstar);
  st.site = &wi_emlrtRSI;
  solution->fstar = computeFval_ReuseHx(&st, objective,
    memspace->workspace_double, f, solution->xstar);
  if (solution->iterations < runTimeOptions_MaxIterations) {
    solution->state = -5;
  } else {
    solution->state = 0;
  }

  st.site = &wi_emlrtRSI;
  c_xcopy(&st, 617, solution->lambda);
  do {
    exitg1 = 0;
    if (solution->state == -5) {
      guard1 = false;
      if (subProblemChanged) {
        switch (activeSetChangeID) {
         case 1:
          st.site = &wi_emlrtRSI;
          squareQ_appendCol(&st, qrmanager, workingset->ATwset, 485 *
                            (workingset->nActiveConstr - 1) + 1);
          break;

         case -1:
          st.site = &wi_emlrtRSI;
          i = globalActiveConstrIdx;
          if (qrmanager->usedPivoting) {
            i = 1;
            exitg2 = false;
            while ((!exitg2) && (i <= qrmanager->ncols)) {
              if (i > 617) {
                emlrtDynamicBoundsCheckR2012b(618, 1, 617, &pd_emlrtBCI, &st);
              }

              if (qrmanager->jpvt[i - 1] != globalActiveConstrIdx) {
                i++;
              } else {
                exitg2 = true;
              }
            }
          }

          if (i >= qrmanager->ncols) {
            qrmanager->ncols--;
          } else {
            if ((qrmanager->ncols < 1) || (qrmanager->ncols > 617)) {
              emlrtDynamicBoundsCheckR2012b(qrmanager->ncols, 1, 617,
                &pd_emlrtBCI, &st);
            }

            if ((i < 1) || (i > 617)) {
              emlrtDynamicBoundsCheckR2012b(i, 1, 617, &nd_emlrtBCI, &st);
            }

            qrmanager->jpvt[i - 1] = qrmanager->jpvt[qrmanager->ncols - 1];
            b_TYPE = qrmanager->minRowCol;
            b_st.site = &fj_emlrtRSI;
            if ((1 <= qrmanager->minRowCol) && (qrmanager->minRowCol >
                 2147483646)) {
              c_st.site = &t_emlrtRSI;
              check_forloop_overflow_error(&c_st);
            }

            for (b_k = 0; b_k < b_TYPE; b_k++) {
              k = b_k + 1;
              if ((k < 1) || (k > 617)) {
                emlrtDynamicBoundsCheckR2012b(k, 1, 617, &pd_emlrtBCI, &st);
              }

              if ((qrmanager->ncols < 1) || (qrmanager->ncols > 617)) {
                emlrtDynamicBoundsCheckR2012b(qrmanager->ncols, 1, 617,
                  &pd_emlrtBCI, &st);
              }

              qrmanager->QR[(k + 617 * (i - 1)) - 1] = qrmanager->QR[(k + 617 *
                (qrmanager->ncols - 1)) - 1];
            }

            qrmanager->ncols--;
            qrmanager->minRowCol = muIntScalarMin_sint32(qrmanager->mrows,
              qrmanager->ncols);
            if (i < qrmanager->mrows) {
              QRk0 = qrmanager->mrows - 1;
              endIdx = muIntScalarMin_sint32(QRk0, qrmanager->ncols);
              for (k = endIdx; k >= i; k--) {
                b_st.site = &fj_emlrtRSI;
                if (k > 617) {
                  emlrtDynamicBoundsCheckR2012b(k, 1, 617, &pd_emlrtBCI, &b_st);
                }

                idxMinLambda = (k + 617 * (i - 1)) - 1;
                normDelta = qrmanager->QR[idxMinLambda];
                b_i = k + 1;
                if (b_i > 617) {
                  emlrtDynamicBoundsCheckR2012b(618, 1, 617, &pd_emlrtBCI, &b_st);
                }

                b_TYPE = 617 * (i - 1);
                b = qrmanager->QR[(b_i + b_TYPE) - 1];
                c_st.site = &cj_emlrtRSI;
                c_st.site = &bj_emlrtRSI;
                c = 0.0;
                s = 0.0;
                drotg(&normDelta, &b, &c, &s);
                qrmanager->QR[idxMinLambda] = normDelta;
                b_i = k + 1;
                if (b_i > 617) {
                  emlrtDynamicBoundsCheckR2012b(618, 1, 617, &nd_emlrtBCI, &b_st);
                }

                qrmanager->QR[(b_i + b_TYPE) - 1] = b;
                b_i = k + 1;
                if (b_i > 617) {
                  emlrtDynamicBoundsCheckR2012b(618, 1, 617, &nd_emlrtBCI, &st);
                }

                b_TYPE = 617 * (k - 1);
                qrmanager->QR[(b_i + b_TYPE) - 1] = 0.0;
                QRk0 = k + 617 * i;
                b_st.site = &fj_emlrtRSI;
                b_xrot(qrmanager->ncols - i, qrmanager->QR, QRk0, QRk0 + 1, c, s);
                QRk0 = b_TYPE + 1;
                b_st.site = &fj_emlrtRSI;
                xrot(qrmanager->mrows, qrmanager->Q, QRk0, QRk0 + 617, c, s);
              }

              k = i + 1;
              b_st.site = &fj_emlrtRSI;
              if ((i + 1 <= endIdx) && (endIdx > 2147483646)) {
                c_st.site = &t_emlrtRSI;
                check_forloop_overflow_error(&c_st);
              }

              for (b_k = k; b_k <= endIdx; b_k++) {
                b_st.site = &fj_emlrtRSI;
                if (b_k > 617) {
                  emlrtDynamicBoundsCheckR2012b(b_k, 1, 617, &pd_emlrtBCI, &b_st);
                }

                idxMinLambda = 617 * (b_k - 1);
                QRk0 = (b_k + idxMinLambda) - 1;
                normDelta = qrmanager->QR[QRk0];
                b_i = b_k + 1;
                if (b_i > 617) {
                  emlrtDynamicBoundsCheckR2012b(618, 1, 617, &pd_emlrtBCI, &b_st);
                }

                b = qrmanager->QR[(b_i + idxMinLambda) - 1];
                c_st.site = &cj_emlrtRSI;
                c_st.site = &bj_emlrtRSI;
                c = 0.0;
                s = 0.0;
                drotg(&normDelta, &b, &c, &s);
                qrmanager->QR[QRk0] = normDelta;
                b_i = b_k + 1;
                if (b_i > 617) {
                  emlrtDynamicBoundsCheckR2012b(618, 1, 617, &nd_emlrtBCI, &b_st);
                }

                qrmanager->QR[(b_i + idxMinLambda) - 1] = b;
                QRk0 = b_k * 618;
                b_st.site = &fj_emlrtRSI;
                b_xrot(qrmanager->ncols - b_k, qrmanager->QR, QRk0, QRk0 + 1, c,
                       s);
                QRk0 = idxMinLambda + 1;
                b_st.site = &fj_emlrtRSI;
                xrot(qrmanager->mrows, qrmanager->Q, QRk0, QRk0 + 617, c, s);
              }
            }
          }
          break;

         default:
          st.site = &wi_emlrtRSI;
          factorQR(&st, qrmanager, workingset->ATwset, nVar,
                   workingset->nActiveConstr);
          st.site = &wi_emlrtRSI;
          b_st.site = &ug_emlrtRSI;
          computeQ_(&b_st, qrmanager, qrmanager->mrows);
          break;
        }

        st.site = &wi_emlrtRSI;
        compute_deltax(&st, H, solution, memspace, qrmanager, cholmanager,
                       objective);
        if (solution->state != -5) {
          exitg1 = 1;
        } else {
          st.site = &wi_emlrtRSI;
          normDelta = xnrm2(&st, nVar, solution->searchDir);
          if ((normDelta < options_StepTolerance) || (workingset->nActiveConstr >=
               nVar)) {
            guard1 = true;
          } else {
            st.site = &wi_emlrtRSI;
            feasibleratiotest(&st, solution->xstar, solution->searchDir,
                              memspace->workspace_double, workingset->nVar,
                              workingset->Aineq, workingset->bineq,
                              workingset->lb, workingset->indexLB,
                              workingset->sizes, workingset->isActiveIdx,
                              workingset->isActiveConstr, workingset->nWConstr,
                              TYPE == 5, &b, &updateFval, &b_i, &QRk0);
            if (updateFval) {
              switch (b_i) {
               case 3:
                st.site = &wi_emlrtRSI;
                b_st.site = &uj_emlrtRSI;
                workingset->nWConstr[2]++;
                b_i = (workingset->isActiveIdx[2] + QRk0) - 1;
                if ((b_i < 1) || (b_i > 617)) {
                  emlrtDynamicBoundsCheckR2012b(b_i, 1, 617, &od_emlrtBCI, &b_st);
                }

                workingset->isActiveConstr[b_i - 1] = true;
                workingset->nActiveConstr++;
                if ((workingset->nActiveConstr < 1) ||
                    (workingset->nActiveConstr > 617)) {
                  emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1,
                    617, &od_emlrtBCI, &b_st);
                }

                workingset->Wid[workingset->nActiveConstr - 1] = 3;
                workingset->Wlocalidx[workingset->nActiveConstr - 1] = QRk0;
                b_st.site = &uj_emlrtRSI;
                xcopy(&b_st, workingset->nVar, workingset->Aineq, 485 * (QRk0 -
                       1) + 1, workingset->ATwset, 485 *
                      (workingset->nActiveConstr - 1) + 1);
                if ((QRk0 < 1) || (QRk0 > 176)) {
                  emlrtDynamicBoundsCheckR2012b(QRk0, 1, 176, &qd_emlrtBCI, &st);
                }

                if ((workingset->nActiveConstr < 1) ||
                    (workingset->nActiveConstr > 617)) {
                  emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1,
                    617, &rd_emlrtBCI, &st);
                }

                workingset->bwset[workingset->nActiveConstr - 1] =
                  workingset->bineq[QRk0 - 1];
                break;

               case 4:
                st.site = &wi_emlrtRSI;
                b_st.site = &vj_emlrtRSI;
                addBoundToActiveSetMatrix_(&b_st, workingset, 4, QRk0);
                break;

               default:
                st.site = &wi_emlrtRSI;
                b_st.site = &xj_emlrtRSI;
                addBoundToActiveSetMatrix_(&b_st, workingset, 5, QRk0);
                break;
              }

              activeSetChangeID = 1;
            } else {
              st.site = &wi_emlrtRSI;
              if (objective->objtype == 5) {
                b_st.site = &yj_emlrtRSI;
                normDelta = xnrm2(&b_st, objective->nvar, solution->searchDir);
                b_st.site = &yj_emlrtRSI;
                if (normDelta > 100.0 * (real_T)objective->nvar *
                    1.4901161193847656E-8) {
                  solution->state = 3;
                } else {
                  solution->state = 4;
                }
              }

              subProblemChanged = false;
              if (workingset->nActiveConstr == 0) {
                solution->state = 1;
              }
            }

            st.site = &wi_emlrtRSI;
            b_xaxpy(nVar, b, solution->searchDir, solution->xstar);
            st.site = &wi_emlrtRSI;
            computeGrad_StoreHx(&st, objective, H, f, solution->xstar);
            updateFval = true;
            st.site = &wi_emlrtRSI;
            checkStoppingAndUpdateFval(SD, &st, &activeSetChangeID, f, solution,
              memspace, objective, workingset, qrmanager, options_ObjectiveLimit,
              runTimeOptions_MaxIterations, updateFval);
          }
        }
      } else {
        st.site = &wi_emlrtRSI;
        b_st.site = &xe_emlrtRSI;
        c_st.site = &ye_emlrtRSI;
        if ((1 <= nVar) && (nVar > 2147483646)) {
          d_st.site = &t_emlrtRSI;
          check_forloop_overflow_error(&d_st);
        }

        if (0 <= nVar - 1) {
          memset(&solution->searchDir[0], 0, nVar * sizeof(real_T));
        }

        guard1 = true;
      }

      if (guard1) {
        st.site = &wi_emlrtRSI;
        compute_lambda(&st, memspace->workspace_double, solution, objective,
                       qrmanager);
        if (solution->state != -7) {
          st.site = &wi_emlrtRSI;
          idxMinLambda = -1;
          normDelta = 0.0;
          k = (workingset->nWConstr[0] + workingset->nWConstr[1]) + 1;
          b_TYPE = workingset->nActiveConstr;
          b_st.site = &sj_emlrtRSI;
          if ((k <= workingset->nActiveConstr) && (workingset->nActiveConstr >
               2147483646)) {
            c_st.site = &t_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (QRk0 = k; QRk0 <= b_TYPE; QRk0++) {
            if ((QRk0 < 1) || (QRk0 > 617)) {
              emlrtDynamicBoundsCheckR2012b(QRk0, 1, 617, &sd_emlrtBCI, &st);
            }

            b = solution->lambda[QRk0 - 1];
            if (b < normDelta) {
              normDelta = b;
              idxMinLambda = QRk0 - 1;
            }
          }

          if (idxMinLambda + 1 == 0) {
            solution->state = 1;
          } else {
            activeSetChangeID = -1;
            globalActiveConstrIdx = idxMinLambda + 1;
            subProblemChanged = true;
            st.site = &wi_emlrtRSI;
            b_TYPE = workingset->Wid[idxMinLambda];
            if ((workingset->Wid[idxMinLambda] < 1) || (workingset->
                 Wid[idxMinLambda] > 6)) {
              emlrtDynamicBoundsCheckR2012b(workingset->Wid[idxMinLambda], 1, 6,
                &cc_emlrtBCI, &st);
            }

            b_i = (workingset->isActiveIdx[workingset->Wid[idxMinLambda] - 1] +
                   workingset->Wlocalidx[idxMinLambda]) - 1;
            if ((b_i < 1) || (b_i > 617)) {
              emlrtDynamicBoundsCheckR2012b(b_i, 1, 617, &kc_emlrtBCI, &st);
            }

            workingset->isActiveConstr[b_i - 1] = false;
            b_st.site = &mh_emlrtRSI;
            moveConstraint_(&b_st, workingset, workingset->nActiveConstr,
                            idxMinLambda + 1);
            workingset->nActiveConstr--;
            if ((b_TYPE < 1) || (b_TYPE > 5)) {
              emlrtDynamicBoundsCheckR2012b(b_TYPE, 1, 5, &mc_emlrtBCI, &st);
            }

            workingset->nWConstr[b_TYPE - 1]--;
            solution->lambda[idxMinLambda] = 0.0;
          }
        } else {
          idxMinLambda = workingset->nActiveConstr;
          activeSetChangeID = 0;
          globalActiveConstrIdx = workingset->nActiveConstr;
          subProblemChanged = true;
          if ((workingset->nActiveConstr < 1) || (workingset->nActiveConstr >
               617)) {
            emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, 617,
              &md_emlrtBCI, sp);
          }

          st.site = &wi_emlrtRSI;
          if ((workingset->nActiveConstr < 1) || (workingset->nActiveConstr >
               617)) {
            emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, 617,
              &ic_emlrtBCI, &st);
          }

          QRk0 = workingset->nActiveConstr - 1;
          b_TYPE = workingset->Wid[QRk0];
          if ((workingset->Wid[QRk0] < 1) || (workingset->Wid[QRk0] > 6)) {
            emlrtDynamicBoundsCheckR2012b(workingset->Wid
              [workingset->nActiveConstr - 1], 1, 6, &cc_emlrtBCI, &st);
          }

          b_i = (workingset->isActiveIdx[workingset->Wid[QRk0] - 1] +
                 workingset->Wlocalidx[QRk0]) - 1;
          if ((b_i < 1) || (b_i > 617)) {
            emlrtDynamicBoundsCheckR2012b(b_i, 1, 617, &kc_emlrtBCI, &st);
          }

          workingset->isActiveConstr[b_i - 1] = false;
          b_st.site = &mh_emlrtRSI;
          moveConstraint_(&b_st, workingset, workingset->nActiveConstr,
                          workingset->nActiveConstr);
          workingset->nActiveConstr--;
          if ((b_TYPE < 1) || (b_TYPE > 5)) {
            emlrtDynamicBoundsCheckR2012b(b_TYPE, 1, 5, &mc_emlrtBCI, &st);
          }

          workingset->nWConstr[b_TYPE - 1]--;
          solution->lambda[idxMinLambda - 1] = 0.0;
        }

        updateFval = false;
        st.site = &wi_emlrtRSI;
        checkStoppingAndUpdateFval(SD, &st, &activeSetChangeID, f, solution,
          memspace, objective, workingset, qrmanager, options_ObjectiveLimit,
          runTimeOptions_MaxIterations, updateFval);
      }
    } else {
      if (!updateFval) {
        st.site = &wi_emlrtRSI;
        solution->fstar = computeFval_ReuseHx(&st, objective,
          memspace->workspace_double, f, solution->xstar);
      }

      exitg1 = 1;
    }
  } while (exitg1 == 0);
}

/* End of code generation (iterate.c) */
