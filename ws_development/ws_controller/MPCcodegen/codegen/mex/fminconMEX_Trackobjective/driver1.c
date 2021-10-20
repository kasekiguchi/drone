/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * driver1.c
 *
 * Code generation for function 'driver1'
 *
 */

/* Include files */
#include "driver1.h"
#include "PresolveWorkingSet.h"
#include "computeFval.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_internal_types.h"
#include "fminconMEX_Trackobjective_types.h"
#include "iterate.h"
#include "maxConstraintViolation.h"
#include "moveConstraint_.h"
#include "removeAllIneqConstr.h"
#include "rt_nonfinite.h"
#include "setProblemType.h"
#include "xcopy.h"

/* Variable Definitions */
static emlrtRSInfo xc_emlrtRSI = { 1,  /* lineNo */
  "snap_bounds",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\snap_bounds.p"/* pathName */
};

static emlrtRSInfo bd_emlrtRSI = { 1,  /* lineNo */
  "driver",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\driver.p"/* pathName */
};

static emlrtRSInfo fe_emlrtRSI = { 1,  /* lineNo */
  "phaseone",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\phaseone.p"/* pathName */
};

static emlrtBCInfo sb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "snap_bounds",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\snap_bounds.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "phaseone",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\phaseone.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void b_driver(const emlrtStack *sp, const real_T H[5929], const emxArray_real_T *
              f, d_struct_T *solution, c_struct_T *memspace, j_struct_T
              *workingset, g_struct_T *qrmanager, h_struct_T *cholmanager,
              i_struct_T *objective, b_struct_T *options, int32_T
              runTimeOptions_MaxIterations)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T maxConstr_new;
  int32_T PHASEONE;
  int32_T PROBTYPE_ORIG;
  int32_T TYPE_tmp;
  int32_T b_nVar;
  int32_T i;
  int32_T i1;
  int32_T mEqFixed;
  int32_T nVar;
  int32_T nVarP1;
  boolean_T exitg1;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  solution->iterations = 0;
  nVar = workingset->nVar;
  st.site = &bd_emlrtRSI;
  b_st.site = &xc_emlrtRSI;
  PHASEONE = workingset->sizes[3];
  b_st.site = &xc_emlrtRSI;
  if ((1 <= workingset->sizes[3]) && (workingset->sizes[3] > 2147483646)) {
    c_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (mEqFixed = 0; mEqFixed < PHASEONE; mEqFixed++) {
    i = workingset->isActiveConstr->size[0];
    i1 = workingset->isActiveIdx[3] + mEqFixed;
    if ((i1 < 1) || (i1 > i)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i, &sb_emlrtBCI, &st);
    }

    if (workingset->isActiveConstr->data[i1 - 1]) {
      i = workingset->indexLB->size[0];
      if ((mEqFixed + 1 < 1) || (mEqFixed + 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(mEqFixed + 1, 1, i, &sb_emlrtBCI, &st);
      }

      i = workingset->lb->size[0];
      if ((workingset->indexLB->data[mEqFixed] < 1) || (workingset->
           indexLB->data[mEqFixed] > i)) {
        emlrtDynamicBoundsCheckR2012b(workingset->indexLB->data[mEqFixed], 1, i,
          &sb_emlrtBCI, &st);
      }

      i = solution->xstar->size[0];
      if ((workingset->indexLB->data[mEqFixed] < 1) || (workingset->
           indexLB->data[mEqFixed] > i)) {
        emlrtDynamicBoundsCheckR2012b(workingset->indexLB->data[mEqFixed], 1, i,
          &sb_emlrtBCI, &st);
      }

      solution->xstar->data[workingset->indexLB->data[mEqFixed] - 1] =
        -workingset->lb->data[workingset->indexLB->data[mEqFixed] - 1];
    }
  }

  b_st.site = &xc_emlrtRSI;
  st.site = &bd_emlrtRSI;
  PresolveWorkingSet(&st, solution, memspace, workingset, qrmanager);
  if (solution->state >= 0) {
    solution->iterations = 0;
    st.site = &bd_emlrtRSI;
    solution->maxConstr = b_maxConstraintViolation(&st, workingset,
      solution->xstar);
    if (solution->maxConstr > 1.0E-6) {
      st.site = &bd_emlrtRSI;
      PROBTYPE_ORIG = workingset->probType;
      b_nVar = workingset->nVar;
      nVarP1 = workingset->nVar + 1;
      i = solution->xstar->size[0];
      i1 = workingset->nVar + 1;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &wb_emlrtBCI, &st);
      }

      solution->xstar->data[i1 - 1] = solution->maxConstr + 1.0;
      if (workingset->probType == 3) {
        PHASEONE = 1;
      } else {
        PHASEONE = 4;
      }

      b_st.site = &fe_emlrtRSI;
      removeAllIneqConstr(&b_st, workingset);
      b_st.site = &fe_emlrtRSI;
      setProblemType(&b_st, workingset, PHASEONE);
      objective->prev_objtype = objective->objtype;
      objective->prev_nvar = objective->nvar;
      objective->prev_hasLinear = objective->hasLinear;
      objective->objtype = 5;
      objective->nvar = nVarP1;
      objective->gammaScalar = 1.0;
      objective->hasLinear = true;
      b_st.site = &fe_emlrtRSI;
      solution->fstar = computeFval(&b_st, objective, memspace->workspace_double,
        H, f, solution->xstar);
      solution->state = 5;
      b_st.site = &fe_emlrtRSI;
      iterate(&b_st, H, f, solution, memspace, workingset, qrmanager,
              cholmanager, objective, 1.4901161193847657E-10, 1.0E-6,
              runTimeOptions_MaxIterations);
      b_st.site = &fe_emlrtRSI;
      i = workingset->isActiveConstr->size[0];
      i1 = workingset->isActiveIdx[3] + workingset->sizes[3];
      if ((i1 - 1 < 1) || (i1 - 1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1 - 1, 1, i, &tb_emlrtBCI, &b_st);
      }

      if (workingset->isActiveConstr->data[i1 - 2]) {
        b_st.site = &fe_emlrtRSI;
        if ((workingset->sizes[1] + 1 <= workingset->nActiveConstr) &&
            (workingset->nActiveConstr > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        mEqFixed = workingset->sizes[1] + 1;
        exitg1 = false;
        while ((!exitg1) && (mEqFixed <= workingset->nActiveConstr)) {
          i = workingset->Wid->size[0];
          if ((mEqFixed < 1) || (mEqFixed > i)) {
            emlrtDynamicBoundsCheckR2012b(mEqFixed, 1, i, &wb_emlrtBCI, &st);
          }

          i = workingset->Wid->data[mEqFixed - 1];
          if (i == 4) {
            i = workingset->Wlocalidx->size[0];
            if (mEqFixed > i) {
              emlrtDynamicBoundsCheckR2012b(mEqFixed, 1, i, &wb_emlrtBCI, &st);
            }

            i = workingset->Wlocalidx->data[mEqFixed - 1];
            if (i == workingset->sizes[3]) {
              b_st.site = &fe_emlrtRSI;
              i1 = workingset->Wid->size[0];
              if (mEqFixed > i1) {
                emlrtDynamicBoundsCheckR2012b(mEqFixed, 1, i1, &ub_emlrtBCI,
                  &b_st);
              }

              i1 = workingset->Wlocalidx->size[0];
              if (mEqFixed > i1) {
                emlrtDynamicBoundsCheckR2012b(mEqFixed, 1, i1, &ub_emlrtBCI,
                  &b_st);
              }

              i1 = workingset->isActiveConstr->size[0];
              i = (workingset->isActiveIdx[3] + i) - 1;
              if ((i < 1) || (i > i1)) {
                emlrtDynamicBoundsCheckR2012b(i, 1, i1, &ub_emlrtBCI, &b_st);
              }

              workingset->isActiveConstr->data[i - 1] = false;
              c_st.site = &id_emlrtRSI;
              moveConstraint_(&c_st, workingset, workingset->nActiveConstr,
                              mEqFixed);
              workingset->nActiveConstr--;
              workingset->nWConstr[3]--;
              exitg1 = true;
            } else {
              mEqFixed++;
            }
          } else {
            mEqFixed++;
          }
        }
      }

      PHASEONE = workingset->nActiveConstr;
      mEqFixed = workingset->sizes[1];
      while ((PHASEONE > mEqFixed) && (PHASEONE > b_nVar)) {
        b_st.site = &fe_emlrtRSI;
        i = workingset->Wid->size[0];
        if ((PHASEONE < 1) || (PHASEONE > i)) {
          emlrtDynamicBoundsCheckR2012b(PHASEONE, 1, i, &ub_emlrtBCI, &b_st);
        }

        TYPE_tmp = workingset->Wid->data[PHASEONE - 1];
        i = workingset->Wlocalidx->size[0];
        if (PHASEONE > i) {
          emlrtDynamicBoundsCheckR2012b(PHASEONE, 1, i, &ub_emlrtBCI, &b_st);
        }

        if ((TYPE_tmp < 1) || (TYPE_tmp > 6)) {
          emlrtDynamicBoundsCheckR2012b(workingset->Wid->data[PHASEONE - 1], 1,
            6, &vb_emlrtBCI, &b_st);
        }

        i = workingset->isActiveConstr->size[0];
        i1 = (workingset->isActiveIdx[TYPE_tmp - 1] + workingset->
              Wlocalidx->data[PHASEONE - 1]) - 1;
        if ((i1 < 1) || (i1 > i)) {
          emlrtDynamicBoundsCheckR2012b(i1, 1, i, &ub_emlrtBCI, &b_st);
        }

        workingset->isActiveConstr->data[i1 - 1] = false;
        c_st.site = &id_emlrtRSI;
        moveConstraint_(&c_st, workingset, workingset->nActiveConstr, PHASEONE);
        workingset->nActiveConstr--;
        if (TYPE_tmp > 5) {
          emlrtDynamicBoundsCheckR2012b(6, 1, 5, &xb_emlrtBCI, &b_st);
        }

        workingset->nWConstr[TYPE_tmp - 1]--;
        PHASEONE--;
      }

      i = solution->xstar->size[0];
      if ((nVarP1 < 1) || (nVarP1 > i)) {
        emlrtDynamicBoundsCheckR2012b(nVarP1, 1, i, &wb_emlrtBCI, &st);
      }

      solution->maxConstr = solution->xstar->data[nVarP1 - 1];
      b_st.site = &fe_emlrtRSI;
      setProblemType(&b_st, workingset, PROBTYPE_ORIG);
      objective->objtype = objective->prev_objtype;
      objective->nvar = objective->prev_nvar;
      objective->hasLinear = objective->prev_hasLinear;
      options->ObjectiveLimit = rtMinusInf;
      options->StepTolerance = 1.0E-6;
      if (solution->state != 0) {
        st.site = &bd_emlrtRSI;
        solution->maxConstr = b_maxConstraintViolation(&st, workingset,
          solution->xstar);
        if (solution->maxConstr > 1.0E-6) {
          st.site = &bd_emlrtRSI;
          c_xcopy(&st, workingset->mConstrMax, solution->lambda);
          st.site = &bd_emlrtRSI;
          solution->fstar = computeFval(&st, objective,
            memspace->workspace_double, H, f, solution->xstar);
          solution->state = -2;
        } else {
          if (solution->maxConstr > 0.0) {
            st.site = &bd_emlrtRSI;
            b_xcopy(nVar, solution->xstar, solution->searchDir);
            st.site = &bd_emlrtRSI;
            PresolveWorkingSet(&st, solution, memspace, workingset, qrmanager);
            st.site = &bd_emlrtRSI;
            maxConstr_new = b_maxConstraintViolation(&st, workingset,
              solution->xstar);
            if (maxConstr_new >= solution->maxConstr) {
              solution->maxConstr = maxConstr_new;
              st.site = &bd_emlrtRSI;
              b_xcopy(nVar, solution->searchDir, solution->xstar);
            }
          }

          st.site = &bd_emlrtRSI;
          iterate(&st, H, f, solution, memspace, workingset, qrmanager,
                  cholmanager, objective, options->StepTolerance,
                  options->ObjectiveLimit, runTimeOptions_MaxIterations);
        }
      }
    } else {
      st.site = &bd_emlrtRSI;
      iterate(&st, H, f, solution, memspace, workingset, qrmanager, cholmanager,
              objective, options->StepTolerance, options->ObjectiveLimit,
              runTimeOptions_MaxIterations);
    }
  }
}

/* End of code generation (driver1.c) */
