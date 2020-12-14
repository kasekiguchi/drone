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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
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
static emlrtRSInfo ge_emlrtRSI = { 1,  /* lineNo */
  "iterate",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\iterate.p"/* pathName */
};

static emlrtRSInfo ke_emlrtRSI = { 28, /* lineNo */
  "xrotg",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xrotg.m"/* pathName */
};

static emlrtRSInfo le_emlrtRSI = { 27, /* lineNo */
  "xrotg",                             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\+blas\\xrotg.m"/* pathName */
};

static emlrtRSInfo oe_emlrtRSI = { 1,  /* lineNo */
  "deleteColMoveEnd",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\deleteColMoveEnd.p"/* pathName */
};

static emlrtRSInfo cf_emlrtRSI = { 1,  /* lineNo */
  "find_neg_lambda",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\find_neg_lambda.p"/* pathName */
};

static emlrtRSInfo if_emlrtRSI = { 1,  /* lineNo */
  "checkUnboundedOrIllPosed",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+stopping\\checkUnboundedOrIllPosed.p"/* pathName */
};

static emlrtBCInfo pc_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "iterate",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\iterate.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qc_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "deleteColMoveEnd",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\deleteColMoveEnd.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo sc_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "deleteColMoveEnd",                  /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+QRManager\\deleteColMoveEnd.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vc_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "find_neg_lambda",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\find_neg_lambda.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void iterate(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T H
             [12100], const real_T f[307], e_struct_T *solution, b_struct_T
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
  st.site = &ge_emlrtRSI;
  computeGrad_StoreHx(&st, objective, H, f, solution->xstar);
  st.site = &ge_emlrtRSI;
  solution->fstar = computeFval_ReuseHx(&st, objective,
    memspace->workspace_double, f, solution->xstar);
  if (solution->iterations < runTimeOptions_MaxIterations) {
    solution->state = -5;
  } else {
    solution->state = 0;
  }

  st.site = &ge_emlrtRSI;
  c_xcopy(&st, 305, solution->lambda);
  do {
    exitg1 = 0;
    if (solution->state == -5) {
      guard1 = false;
      if (subProblemChanged) {
        switch (activeSetChangeID) {
         case 1:
          st.site = &ge_emlrtRSI;
          squareQ_appendCol(&st, qrmanager, workingset->ATwset, 307 *
                            (workingset->nActiveConstr - 1) + 1);
          break;

         case -1:
          st.site = &ge_emlrtRSI;
          i = globalActiveConstrIdx;
          if (qrmanager->usedPivoting) {
            i = 1;
            exitg2 = false;
            while ((!exitg2) && (i <= qrmanager->ncols)) {
              if (i > 307) {
                emlrtDynamicBoundsCheckR2012b(308, 1, 307, &sc_emlrtBCI, &st);
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
            if ((qrmanager->ncols < 1) || (qrmanager->ncols > 307)) {
              emlrtDynamicBoundsCheckR2012b(qrmanager->ncols, 1, 307,
                &sc_emlrtBCI, &st);
            }

            if ((i < 1) || (i > 307)) {
              emlrtDynamicBoundsCheckR2012b(i, 1, 307, &qc_emlrtBCI, &st);
            }

            qrmanager->jpvt[i - 1] = qrmanager->jpvt[qrmanager->ncols - 1];
            b_TYPE = qrmanager->minRowCol;
            b_st.site = &oe_emlrtRSI;
            if ((1 <= qrmanager->minRowCol) && (qrmanager->minRowCol >
                 2147483646)) {
              c_st.site = &e_emlrtRSI;
              check_forloop_overflow_error(&c_st);
            }

            for (b_k = 0; b_k < b_TYPE; b_k++) {
              k = b_k + 1;
              if ((k < 1) || (k > 307)) {
                emlrtDynamicBoundsCheckR2012b(k, 1, 307, &sc_emlrtBCI, &st);
              }

              if ((qrmanager->ncols < 1) || (qrmanager->ncols > 307)) {
                emlrtDynamicBoundsCheckR2012b(qrmanager->ncols, 1, 307,
                  &sc_emlrtBCI, &st);
              }

              qrmanager->QR[(k + 307 * (i - 1)) - 1] = qrmanager->QR[(k + 307 *
                (qrmanager->ncols - 1)) - 1];
            }

            qrmanager->ncols--;
            qrmanager->minRowCol = muIntScalarMin_sint32(qrmanager->mrows,
              qrmanager->ncols);
            if (i < qrmanager->mrows) {
              QRk0 = qrmanager->mrows - 1;
              endIdx = muIntScalarMin_sint32(QRk0, qrmanager->ncols);
              for (k = endIdx; k >= i; k--) {
                b_st.site = &oe_emlrtRSI;
                if (k > 307) {
                  emlrtDynamicBoundsCheckR2012b(k, 1, 307, &sc_emlrtBCI, &b_st);
                }

                idxMinLambda = (k + 307 * (i - 1)) - 1;
                normDelta = qrmanager->QR[idxMinLambda];
                b_i = k + 1;
                if (b_i > 307) {
                  emlrtDynamicBoundsCheckR2012b(308, 1, 307, &sc_emlrtBCI, &b_st);
                }

                b_TYPE = 307 * (i - 1);
                b = qrmanager->QR[(b_i + b_TYPE) - 1];
                c_st.site = &le_emlrtRSI;
                c_st.site = &ke_emlrtRSI;
                c = 0.0;
                s = 0.0;
                drotg(&normDelta, &b, &c, &s);
                qrmanager->QR[idxMinLambda] = normDelta;
                b_i = k + 1;
                if (b_i > 307) {
                  emlrtDynamicBoundsCheckR2012b(308, 1, 307, &qc_emlrtBCI, &b_st);
                }

                qrmanager->QR[(b_i + b_TYPE) - 1] = b;
                b_i = k + 1;
                if (b_i > 307) {
                  emlrtDynamicBoundsCheckR2012b(308, 1, 307, &qc_emlrtBCI, &st);
                }

                b_TYPE = 307 * (k - 1);
                qrmanager->QR[(b_i + b_TYPE) - 1] = 0.0;
                QRk0 = k + 307 * i;
                b_st.site = &oe_emlrtRSI;
                b_xrot(&b_st, qrmanager->ncols - i, qrmanager->QR, QRk0, QRk0 +
                       1, c, s);
                QRk0 = b_TYPE + 1;
                b_st.site = &oe_emlrtRSI;
                xrot(&b_st, qrmanager->mrows, qrmanager->Q, QRk0, QRk0 + 307, c,
                     s);
              }

              k = i + 1;
              b_st.site = &oe_emlrtRSI;
              if ((i + 1 <= endIdx) && (endIdx > 2147483646)) {
                c_st.site = &e_emlrtRSI;
                check_forloop_overflow_error(&c_st);
              }

              for (b_k = k; b_k <= endIdx; b_k++) {
                b_st.site = &oe_emlrtRSI;
                if (b_k > 307) {
                  emlrtDynamicBoundsCheckR2012b(b_k, 1, 307, &sc_emlrtBCI, &b_st);
                }

                idxMinLambda = 307 * (b_k - 1);
                QRk0 = (b_k + idxMinLambda) - 1;
                normDelta = qrmanager->QR[QRk0];
                b_i = b_k + 1;
                if (b_i > 307) {
                  emlrtDynamicBoundsCheckR2012b(308, 1, 307, &sc_emlrtBCI, &b_st);
                }

                b = qrmanager->QR[(b_i + idxMinLambda) - 1];
                c_st.site = &le_emlrtRSI;
                c_st.site = &ke_emlrtRSI;
                c = 0.0;
                s = 0.0;
                drotg(&normDelta, &b, &c, &s);
                qrmanager->QR[QRk0] = normDelta;
                b_i = b_k + 1;
                if (b_i > 307) {
                  emlrtDynamicBoundsCheckR2012b(308, 1, 307, &qc_emlrtBCI, &b_st);
                }

                qrmanager->QR[(b_i + idxMinLambda) - 1] = b;
                QRk0 = b_k * 308;
                b_st.site = &oe_emlrtRSI;
                b_xrot(&b_st, qrmanager->ncols - b_k, qrmanager->QR, QRk0, QRk0
                       + 1, c, s);
                QRk0 = idxMinLambda + 1;
                b_st.site = &oe_emlrtRSI;
                xrot(&b_st, qrmanager->mrows, qrmanager->Q, QRk0, QRk0 + 307, c,
                     s);
              }
            }
          }
          break;

         default:
          st.site = &ge_emlrtRSI;
          factorQR(&st, qrmanager, workingset->ATwset, nVar,
                   workingset->nActiveConstr);
          st.site = &ge_emlrtRSI;
          b_st.site = &fc_emlrtRSI;
          computeQ_(&b_st, qrmanager, qrmanager->mrows);
          break;
        }

        st.site = &ge_emlrtRSI;
        compute_deltax(&st, H, solution, memspace, qrmanager, cholmanager,
                       objective);
        if (solution->state != -5) {
          exitg1 = 1;
        } else {
          st.site = &ge_emlrtRSI;
          normDelta = xnrm2(&st, nVar, solution->searchDir);
          if ((normDelta < options_StepTolerance) || (workingset->nActiveConstr >=
               nVar)) {
            guard1 = true;
          } else {
            st.site = &ge_emlrtRSI;
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
                st.site = &ge_emlrtRSI;
                b_st.site = &ef_emlrtRSI;
                workingset->nWConstr[2]++;
                b_i = (workingset->isActiveIdx[2] + QRk0) - 1;
                if ((b_i < 1) || (b_i > 305)) {
                  emlrtDynamicBoundsCheckR2012b(b_i, 1, 305, &rc_emlrtBCI, &b_st);
                }

                workingset->isActiveConstr[b_i - 1] = true;
                workingset->nActiveConstr++;
                if ((workingset->nActiveConstr < 1) ||
                    (workingset->nActiveConstr > 305)) {
                  emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1,
                    305, &rc_emlrtBCI, &b_st);
                }

                workingset->Wid[workingset->nActiveConstr - 1] = 3;
                workingset->Wlocalidx[workingset->nActiveConstr - 1] = QRk0;
                b_st.site = &ef_emlrtRSI;
                xcopy(&b_st, workingset->nVar, workingset->Aineq, 307 * (QRk0 -
                       1) + 1, workingset->ATwset, 307 *
                      (workingset->nActiveConstr - 1) + 1);
                if ((QRk0 < 1) || (QRk0 > 20)) {
                  emlrtDynamicBoundsCheckR2012b(QRk0, 1, 20, &tc_emlrtBCI, &st);
                }

                if ((workingset->nActiveConstr < 1) ||
                    (workingset->nActiveConstr > 305)) {
                  emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1,
                    305, &uc_emlrtBCI, &st);
                }

                workingset->bwset[workingset->nActiveConstr - 1] =
                  workingset->bineq[QRk0 - 1];
                break;

               case 4:
                st.site = &ge_emlrtRSI;
                b_st.site = &ff_emlrtRSI;
                addBoundToActiveSetMatrix_(&b_st, workingset, 4, QRk0);
                break;

               default:
                st.site = &ge_emlrtRSI;
                b_st.site = &hf_emlrtRSI;
                addBoundToActiveSetMatrix_(&b_st, workingset, 5, QRk0);
                break;
              }

              activeSetChangeID = 1;
            } else {
              st.site = &ge_emlrtRSI;
              if (objective->objtype == 5) {
                b_st.site = &if_emlrtRSI;
                normDelta = xnrm2(&b_st, objective->nvar, solution->searchDir);
                b_st.site = &if_emlrtRSI;
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

            st.site = &ge_emlrtRSI;
            b_xaxpy(nVar, b, solution->searchDir, solution->xstar);
            st.site = &ge_emlrtRSI;
            computeGrad_StoreHx(&st, objective, H, f, solution->xstar);
            updateFval = true;
            st.site = &ge_emlrtRSI;
            checkStoppingAndUpdateFval(SD, &st, &activeSetChangeID, f, solution,
              memspace, objective, workingset, qrmanager, options_ObjectiveLimit,
              runTimeOptions_MaxIterations, updateFval);
          }
        }
      } else {
        st.site = &ge_emlrtRSI;
        b_st.site = &i_emlrtRSI;
        c_st.site = &j_emlrtRSI;
        if ((1 <= nVar) && (nVar > 2147483646)) {
          d_st.site = &e_emlrtRSI;
          check_forloop_overflow_error(&d_st);
        }

        if (0 <= nVar - 1) {
          memset(&solution->searchDir[0], 0, nVar * sizeof(real_T));
        }

        guard1 = true;
      }

      if (guard1) {
        st.site = &ge_emlrtRSI;
        compute_lambda(&st, memspace->workspace_double, solution, objective,
                       qrmanager);
        if (solution->state != -7) {
          st.site = &ge_emlrtRSI;
          idxMinLambda = -1;
          normDelta = 0.0;
          k = (workingset->nWConstr[0] + workingset->nWConstr[1]) + 1;
          b_TYPE = workingset->nActiveConstr;
          b_st.site = &cf_emlrtRSI;
          if ((k <= workingset->nActiveConstr) && (workingset->nActiveConstr >
               2147483646)) {
            c_st.site = &e_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (QRk0 = k; QRk0 <= b_TYPE; QRk0++) {
            if ((QRk0 < 1) || (QRk0 > 305)) {
              emlrtDynamicBoundsCheckR2012b(QRk0, 1, 305, &vc_emlrtBCI, &st);
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
            st.site = &ge_emlrtRSI;
            b_TYPE = workingset->Wid[idxMinLambda];
            if ((workingset->Wid[idxMinLambda] < 1) || (workingset->
                 Wid[idxMinLambda] > 6)) {
              emlrtDynamicBoundsCheckR2012b(workingset->Wid[idxMinLambda], 1, 6,
                &eb_emlrtBCI, &st);
            }

            b_i = (workingset->isActiveIdx[workingset->Wid[idxMinLambda] - 1] +
                   workingset->Wlocalidx[idxMinLambda]) - 1;
            if ((b_i < 1) || (b_i > 305)) {
              emlrtDynamicBoundsCheckR2012b(b_i, 1, 305, &pb_emlrtBCI, &st);
            }

            workingset->isActiveConstr[b_i - 1] = false;
            b_st.site = &wc_emlrtRSI;
            moveConstraint_(&b_st, workingset, workingset->nActiveConstr,
                            idxMinLambda + 1);
            workingset->nActiveConstr--;
            if ((b_TYPE < 1) || (b_TYPE > 5)) {
              emlrtDynamicBoundsCheckR2012b(b_TYPE, 1, 5, &rb_emlrtBCI, &st);
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
               305)) {
            emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, 305,
              &pc_emlrtBCI, sp);
          }

          st.site = &ge_emlrtRSI;
          if ((workingset->nActiveConstr < 1) || (workingset->nActiveConstr >
               305)) {
            emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, 305,
              &nb_emlrtBCI, &st);
          }

          QRk0 = workingset->nActiveConstr - 1;
          b_TYPE = workingset->Wid[QRk0];
          if ((workingset->Wid[QRk0] < 1) || (workingset->Wid[QRk0] > 6)) {
            emlrtDynamicBoundsCheckR2012b(workingset->Wid
              [workingset->nActiveConstr - 1], 1, 6, &eb_emlrtBCI, &st);
          }

          b_i = (workingset->isActiveIdx[workingset->Wid[QRk0] - 1] +
                 workingset->Wlocalidx[QRk0]) - 1;
          if ((b_i < 1) || (b_i > 305)) {
            emlrtDynamicBoundsCheckR2012b(b_i, 1, 305, &pb_emlrtBCI, &st);
          }

          workingset->isActiveConstr[b_i - 1] = false;
          b_st.site = &wc_emlrtRSI;
          moveConstraint_(&b_st, workingset, workingset->nActiveConstr,
                          workingset->nActiveConstr);
          workingset->nActiveConstr--;
          if ((b_TYPE < 1) || (b_TYPE > 5)) {
            emlrtDynamicBoundsCheckR2012b(b_TYPE, 1, 5, &rb_emlrtBCI, &st);
          }

          workingset->nWConstr[b_TYPE - 1]--;
          solution->lambda[idxMinLambda - 1] = 0.0;
        }

        updateFval = false;
        st.site = &ge_emlrtRSI;
        checkStoppingAndUpdateFval(SD, &st, &activeSetChangeID, f, solution,
          memspace, objective, workingset, qrmanager, options_ObjectiveLimit,
          runTimeOptions_MaxIterations, updateFval);
      }
    } else {
      if (!updateFval) {
        st.site = &ge_emlrtRSI;
        solution->fstar = computeFval_ReuseHx(&st, objective,
          memspace->workspace_double, f, solution->xstar);
      }

      exitg1 = 1;
    }
  } while (exitg1 == 0);
}

/* End of code generation (iterate.c) */
