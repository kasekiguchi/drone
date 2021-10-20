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
#include "addBoundToActiveSetMatrix_.h"
#include "computeFval_ReuseHx.h"
#include "computeGrad_StoreHx.h"
#include "computeQ_.h"
#include "compute_deltax.h"
#include "compute_lambda.h"
#include "deleteColMoveEnd.h"
#include "eml_int_forloop_overflow_check.h"
#include "factorQR.h"
#include "feasibleX0ForWorkingSet.h"
#include "feasibleratiotest.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "maxConstraintViolation.h"
#include "moveConstraint_.h"
#include "rt_nonfinite.h"
#include "squareQ_appendCol.h"
#include "xaxpy.h"
#include "xcopy.h"
#include "xnrm2.h"

/* Variable Definitions */
static emlrtRSInfo je_emlrtRSI = { 1,  /* lineNo */
  "iterate",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\iterate.p"/* pathName */
};

static emlrtRSInfo bf_emlrtRSI = { 1,  /* lineNo */
  "find_neg_lambda",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\find_neg_lambda.p"/* pathName */
};

static emlrtRSInfo hf_emlrtRSI = { 1,  /* lineNo */
  "checkUnboundedOrIllPosed",          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+stopping\\checkUnboundedOrIllPosed.p"/* pathName */
};

static emlrtRSInfo if_emlrtRSI = { 1,  /* lineNo */
  "checkStoppingAndUpdateFval",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+stopping\\checkStoppingAndUpdateFval.p"/* pathName */
};

static emlrtBCInfo sc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "iterate",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\iterate.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "find_neg_lambda",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\find_neg_lambda.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "checkStoppingAndUpdateFval",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+stopping\\checkStoppingAndUpdateFval.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void iterate(const emlrtStack *sp, const real_T H[5929], const emxArray_real_T
             *f, d_struct_T *solution, c_struct_T *memspace, j_struct_T
             *workingset, g_struct_T *qrmanager, h_struct_T *cholmanager,
             i_struct_T *objective, real_T options_StepTolerance, real_T
             options_ObjectiveLimit, int32_T runTimeOptions_MaxIterations)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T d;
  real_T normDelta;
  int32_T TYPE;
  int32_T TYPE_tmp;
  int32_T activeSetChangeID;
  int32_T b_nVar;
  int32_T exitg1;
  int32_T globalActiveConstrIdx;
  int32_T i;
  int32_T idx;
  int32_T idxMinLambda;
  int32_T nVar;
  boolean_T guard1 = false;
  boolean_T guard2 = false;
  boolean_T nonDegenerateWset;
  boolean_T subProblemChanged;
  boolean_T updateFval;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  subProblemChanged = true;
  updateFval = true;
  activeSetChangeID = 0;
  TYPE = objective->objtype;
  nVar = workingset->nVar;
  globalActiveConstrIdx = 0;
  st.site = &je_emlrtRSI;
  computeGrad_StoreHx(&st, objective, H, f, solution->xstar);
  st.site = &je_emlrtRSI;
  solution->fstar = computeFval_ReuseHx(&st, objective,
    memspace->workspace_double, f, solution->xstar);
  if (solution->iterations < runTimeOptions_MaxIterations) {
    solution->state = -5;
  } else {
    solution->state = 0;
  }

  st.site = &je_emlrtRSI;
  c_xcopy(&st, workingset->mConstrMax, solution->lambda);
  do {
    exitg1 = 0;
    if (solution->state == -5) {
      guard1 = false;
      guard2 = false;
      if (subProblemChanged) {
        switch (activeSetChangeID) {
         case 1:
          st.site = &je_emlrtRSI;
          squareQ_appendCol(&st, qrmanager, workingset->ATwset, workingset->ldA *
                            (workingset->nActiveConstr - 1) + 1);
          break;

         case -1:
          st.site = &je_emlrtRSI;
          deleteColMoveEnd(&st, qrmanager, globalActiveConstrIdx);
          break;

         default:
          st.site = &je_emlrtRSI;
          factorQR(&st, qrmanager, workingset->ATwset, nVar,
                   workingset->nActiveConstr);
          st.site = &je_emlrtRSI;
          b_st.site = &oc_emlrtRSI;
          computeQ_(&b_st, qrmanager, qrmanager->mrows);
          break;
        }

        st.site = &je_emlrtRSI;
        compute_deltax(&st, H, solution, memspace, qrmanager, cholmanager,
                       objective);
        if (solution->state != -5) {
          exitg1 = 1;
        } else {
          normDelta = xnrm2(nVar, solution->searchDir);
          if ((normDelta < options_StepTolerance) || (workingset->nActiveConstr >=
               nVar)) {
            guard2 = true;
          } else {
            st.site = &je_emlrtRSI;
            feasibleratiotest(&st, solution->xstar, solution->searchDir,
                              memspace->workspace_double, workingset->nVar,
                              workingset->ldA, workingset->Aineq,
                              workingset->bineq, workingset->lb,
                              workingset->indexLB, workingset->sizes,
                              workingset->isActiveIdx,
                              workingset->isActiveConstr, workingset->nWConstr,
                              TYPE == 5, &normDelta, &updateFval, &i, &b_nVar);
            if (updateFval) {
              switch (i) {
               case 3:
                st.site = &je_emlrtRSI;
                b_st.site = &df_emlrtRSI;
                workingset->nWConstr[2]++;
                i = workingset->isActiveConstr->size[0];
                idx = (workingset->isActiveIdx[2] + b_nVar) - 1;
                if ((idx < 1) || (idx > i)) {
                  emlrtDynamicBoundsCheckR2012b(idx, 1, i, &tc_emlrtBCI, &b_st);
                }

                workingset->isActiveConstr->data[idx - 1] = true;
                workingset->nActiveConstr++;
                i = workingset->Wid->size[0];
                if ((workingset->nActiveConstr < 1) ||
                    (workingset->nActiveConstr > i)) {
                  emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, i,
                    &tc_emlrtBCI, &b_st);
                }

                workingset->Wid->data[workingset->nActiveConstr - 1] = 3;
                i = workingset->Wlocalidx->size[0];
                if ((workingset->nActiveConstr < 1) ||
                    (workingset->nActiveConstr > i)) {
                  emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, i,
                    &tc_emlrtBCI, &b_st);
                }

                workingset->Wlocalidx->data[workingset->nActiveConstr - 1] =
                  b_nVar;
                b_st.site = &df_emlrtRSI;
                xcopy(workingset->nVar, workingset->Aineq, workingset->ldA *
                      (b_nVar - 1) + 1, workingset->ATwset, workingset->ldA *
                      (workingset->nActiveConstr - 1) + 1);
                i = workingset->bineq->size[0] * workingset->bineq->size[1];
                if ((b_nVar < 1) || (b_nVar > i)) {
                  emlrtDynamicBoundsCheckR2012b(b_nVar, 1, i, &uc_emlrtBCI, &st);
                }

                i = workingset->bwset->size[0];
                if ((workingset->nActiveConstr < 1) ||
                    (workingset->nActiveConstr > i)) {
                  emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, i,
                    &uc_emlrtBCI, &st);
                }

                workingset->bwset->data[workingset->nActiveConstr - 1] =
                  workingset->bineq->data[b_nVar - 1];
                break;

               case 4:
                st.site = &je_emlrtRSI;
                b_st.site = &ef_emlrtRSI;
                addBoundToActiveSetMatrix_(&b_st, workingset, 4, b_nVar);
                break;

               default:
                st.site = &je_emlrtRSI;
                b_st.site = &gf_emlrtRSI;
                addBoundToActiveSetMatrix_(&b_st, workingset, 5, b_nVar);
                break;
              }

              activeSetChangeID = 1;
            } else {
              st.site = &je_emlrtRSI;
              if (objective->objtype == 5) {
                b_st.site = &hf_emlrtRSI;
                if (xnrm2(objective->nvar, solution->searchDir) > 100.0 *
                    (real_T)objective->nvar * 1.4901161193847656E-8) {
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

            st.site = &je_emlrtRSI;
            xaxpy(nVar, normDelta, solution->searchDir, solution->xstar);
            st.site = &je_emlrtRSI;
            computeGrad_StoreHx(&st, objective, H, f, solution->xstar);
            updateFval = true;
            guard1 = true;
          }
        }
      } else {
        st.site = &je_emlrtRSI;
        c_xcopy(&st, nVar, solution->searchDir);
        guard2 = true;
      }

      if (guard2) {
        st.site = &je_emlrtRSI;
        compute_lambda(&st, memspace->workspace_double, solution, objective,
                       qrmanager);
        if (solution->state != -7) {
          st.site = &je_emlrtRSI;
          idxMinLambda = 0;
          normDelta = 0.0;
          b_nVar = (workingset->nWConstr[0] + workingset->nWConstr[1]) + 1;
          TYPE_tmp = workingset->nActiveConstr;
          b_st.site = &bf_emlrtRSI;
          if ((b_nVar <= workingset->nActiveConstr) &&
              (workingset->nActiveConstr > 2147483646)) {
            c_st.site = &s_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (idx = b_nVar; idx <= TYPE_tmp; idx++) {
            i = solution->lambda->size[0];
            if ((idx < 1) || (idx > i)) {
              emlrtDynamicBoundsCheckR2012b(idx, 1, i, &vc_emlrtBCI, &st);
            }

            d = solution->lambda->data[idx - 1];
            if (d < normDelta) {
              i = solution->lambda->size[0];
              if (idx > i) {
                emlrtDynamicBoundsCheckR2012b(idx, 1, i, &vc_emlrtBCI, &st);
              }

              normDelta = d;
              idxMinLambda = idx;
            }
          }

          if (idxMinLambda == 0) {
            solution->state = 1;
          } else {
            activeSetChangeID = -1;
            globalActiveConstrIdx = idxMinLambda;
            subProblemChanged = true;
            i = workingset->Wid->size[0];
            if (idxMinLambda > i) {
              emlrtDynamicBoundsCheckR2012b(idxMinLambda, 1, i, &sc_emlrtBCI, sp);
            }

            i = workingset->Wlocalidx->size[0];
            if (idxMinLambda > i) {
              emlrtDynamicBoundsCheckR2012b(idxMinLambda, 1, i, &sc_emlrtBCI, sp);
            }

            st.site = &je_emlrtRSI;
            i = workingset->Wid->size[0];
            if (idxMinLambda > i) {
              emlrtDynamicBoundsCheckR2012b(idxMinLambda, 1, i, &ub_emlrtBCI,
                &st);
            }

            b_nVar = workingset->Wid->data[idxMinLambda - 1];
            i = workingset->Wlocalidx->size[0];
            if (idxMinLambda > i) {
              emlrtDynamicBoundsCheckR2012b(idxMinLambda, 1, i, &ub_emlrtBCI,
                &st);
            }

            if ((b_nVar < 1) || (b_nVar > 6)) {
              emlrtDynamicBoundsCheckR2012b(workingset->Wid->data[idxMinLambda -
                1], 1, 6, &vb_emlrtBCI, &st);
            }

            i = workingset->isActiveConstr->size[0];
            idx = (workingset->isActiveIdx[b_nVar - 1] + workingset->
                   Wlocalidx->data[idxMinLambda - 1]) - 1;
            if ((idx < 1) || (idx > i)) {
              emlrtDynamicBoundsCheckR2012b(idx, 1, i, &ub_emlrtBCI, &st);
            }

            workingset->isActiveConstr->data[idx - 1] = false;
            b_st.site = &id_emlrtRSI;
            moveConstraint_(&b_st, workingset, workingset->nActiveConstr,
                            idxMinLambda);
            workingset->nActiveConstr--;
            if (b_nVar > 5) {
              emlrtDynamicBoundsCheckR2012b(6, 1, 5, &xb_emlrtBCI, &st);
            }

            workingset->nWConstr[b_nVar - 1]--;
            i = solution->lambda->size[0];
            if (idxMinLambda > i) {
              emlrtDynamicBoundsCheckR2012b(idxMinLambda, 1, i, &sc_emlrtBCI, sp);
            }

            solution->lambda->data[idxMinLambda - 1] = 0.0;
          }
        } else {
          idxMinLambda = workingset->nActiveConstr;
          activeSetChangeID = 0;
          globalActiveConstrIdx = workingset->nActiveConstr;
          subProblemChanged = true;
          i = workingset->Wid->size[0];
          if ((workingset->nActiveConstr < 1) || (workingset->nActiveConstr > i))
          {
            emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, i,
              &sc_emlrtBCI, sp);
          }

          i = workingset->Wlocalidx->size[0];
          if ((workingset->nActiveConstr < 1) || (workingset->nActiveConstr > i))
          {
            emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, i,
              &sc_emlrtBCI, sp);
          }

          st.site = &je_emlrtRSI;
          i = workingset->Wid->size[0];
          if ((workingset->nActiveConstr < 1) || (workingset->nActiveConstr > i))
          {
            emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, i,
              &ub_emlrtBCI, &st);
          }

          b_nVar = workingset->nActiveConstr - 1;
          TYPE_tmp = workingset->Wid->data[b_nVar];
          i = workingset->Wlocalidx->size[0];
          if ((workingset->nActiveConstr < 1) || (workingset->nActiveConstr > i))
          {
            emlrtDynamicBoundsCheckR2012b(workingset->nActiveConstr, 1, i,
              &ub_emlrtBCI, &st);
          }

          if ((TYPE_tmp < 1) || (TYPE_tmp > 6)) {
            emlrtDynamicBoundsCheckR2012b(workingset->Wid->data
              [workingset->nActiveConstr - 1], 1, 6, &vb_emlrtBCI, &st);
          }

          i = workingset->isActiveConstr->size[0];
          idx = (workingset->isActiveIdx[TYPE_tmp - 1] + workingset->
                 Wlocalidx->data[b_nVar]) - 1;
          if ((idx < 1) || (idx > i)) {
            emlrtDynamicBoundsCheckR2012b(idx, 1, i, &ub_emlrtBCI, &st);
          }

          workingset->isActiveConstr->data[idx - 1] = false;
          b_st.site = &id_emlrtRSI;
          moveConstraint_(&b_st, workingset, workingset->nActiveConstr,
                          workingset->nActiveConstr);
          workingset->nActiveConstr--;
          if (TYPE_tmp > 5) {
            emlrtDynamicBoundsCheckR2012b(6, 1, 5, &xb_emlrtBCI, &st);
          }

          workingset->nWConstr[TYPE_tmp - 1]--;
          i = solution->lambda->size[0];
          if ((idxMinLambda < 1) || (idxMinLambda > i)) {
            emlrtDynamicBoundsCheckR2012b(idxMinLambda, 1, i, &sc_emlrtBCI, sp);
          }

          solution->lambda->data[idxMinLambda - 1] = 0.0;
        }

        updateFval = false;
        guard1 = true;
      }

      if (guard1) {
        st.site = &je_emlrtRSI;
        solution->iterations++;
        b_nVar = objective->nvar;
        if ((solution->iterations >= runTimeOptions_MaxIterations) &&
            ((solution->state != 1) || (objective->objtype == 5))) {
          solution->state = 0;
        }

        if (solution->iterations - solution->iterations / 50 * 50 == 0) {
          b_st.site = &if_emlrtRSI;
          solution->maxConstr = b_maxConstraintViolation(&b_st, workingset,
            solution->xstar);
          if (solution->maxConstr > 1.0E-6) {
            b_st.site = &if_emlrtRSI;
            b_xcopy(objective->nvar, solution->xstar, solution->searchDir);
            b_st.site = &if_emlrtRSI;
            nonDegenerateWset = feasibleX0ForWorkingSet(&b_st,
              memspace->workspace_double, solution->searchDir, workingset,
              qrmanager);
            if ((!nonDegenerateWset) && (solution->state != 0)) {
              solution->state = -2;
            }

            activeSetChangeID = 0;
            b_st.site = &if_emlrtRSI;
            normDelta = b_maxConstraintViolation(&b_st, workingset,
              solution->searchDir);
            if (normDelta < solution->maxConstr) {
              b_st.site = &if_emlrtRSI;
              if ((1 <= objective->nvar) && (objective->nvar > 2147483646)) {
                c_st.site = &s_emlrtRSI;
                check_forloop_overflow_error(&c_st);
              }

              for (idx = 0; idx < b_nVar; idx++) {
                i = solution->searchDir->size[0];
                if ((idx + 1 < 1) || (idx + 1 > i)) {
                  emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &wc_emlrtBCI, &st);
                }

                i = solution->xstar->size[0];
                if ((idx + 1 < 1) || (idx + 1 > i)) {
                  emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &wc_emlrtBCI, &st);
                }

                solution->xstar->data[idx] = solution->searchDir->data[idx];
              }

              solution->maxConstr = normDelta;
            }
          }
        }

        if ((options_ObjectiveLimit > rtMinusInf) && updateFval) {
          b_st.site = &if_emlrtRSI;
          solution->fstar = computeFval_ReuseHx(&b_st, objective,
            memspace->workspace_double, f, solution->xstar);
          if ((solution->fstar < options_ObjectiveLimit) && ((solution->state !=
                0) || (objective->objtype != 5))) {
            solution->state = 2;
          }
        }
      }
    } else {
      if (!updateFval) {
        st.site = &je_emlrtRSI;
        solution->fstar = computeFval_ReuseHx(&st, objective,
          memspace->workspace_double, f, solution->xstar);
      }

      exitg1 = 1;
    }
  } while (exitg1 == 0);
}

/* End of code generation (iterate.c) */
