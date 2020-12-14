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
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "PresolveWorkingSet.h"
#include "computeFval.h"
#include "eml_int_forloop_overflow_check.h"
#include "iterate.h"
#include "maxConstraintViolation.h"
#include "phaseone.h"
#include "rt_nonfinite.h"
#include "xcopy.h"

/* Variable Definitions */
static emlrtRSInfo dh_emlrtRSI = { 1,  /* lineNo */
  "snap_bounds",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\snap_bounds.p"/* pathName */
};

static emlrtRSInfo ji_emlrtRSI = { 1,  /* lineNo */
  "driver",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\driver.p"/* pathName */
};

static emlrtBCInfo xc_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "snap_bounds",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\snap_bounds.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yc_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "snap_bounds",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\snap_bounds.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ad_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "snap_bounds",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\snap_bounds.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void b_driver(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T H
              [17424], const real_T f[485], e_struct_T *solution, b_struct_T
              *memspace, g_struct_T *workingset, k_struct_T *qrmanager,
              l_struct_T *cholmanager, j_struct_T *objective, c_struct_T
              *options, c_struct_T *runTimeOptions)
{
  int32_T nVar;
  int32_T b;
  int32_T idx;
  int32_T i;
  real_T maxConstr_new;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  solution->iterations = 0;
  runTimeOptions->RemainFeasible = true;
  nVar = workingset->nVar;
  st.site = &ji_emlrtRSI;
  b_st.site = &dh_emlrtRSI;
  b = workingset->sizes[3];
  b_st.site = &dh_emlrtRSI;
  if ((1 <= workingset->sizes[3]) && (workingset->sizes[3] > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (idx = 0; idx < b; idx++) {
    i = workingset->isActiveIdx[3] + idx;
    if ((i < 1) || (i > 617)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 617, &xc_emlrtBCI, &st);
    }

    if (workingset->isActiveConstr[i - 1]) {
      if ((workingset->indexLB[idx] < 1) || (workingset->indexLB[idx] > 485)) {
        emlrtDynamicBoundsCheckR2012b(workingset->indexLB[idx], 1, 485,
          &yc_emlrtBCI, &st);
      }

      if ((workingset->indexLB[idx] < 1) || (workingset->indexLB[idx] > 485)) {
        emlrtDynamicBoundsCheckR2012b(workingset->indexLB[idx], 1, 485,
          &ad_emlrtBCI, &st);
      }

      solution->xstar[workingset->indexLB[idx] - 1] = -workingset->lb
        [workingset->indexLB[idx] - 1];
    }
  }

  b_st.site = &dh_emlrtRSI;
  st.site = &ji_emlrtRSI;
  PresolveWorkingSet(SD, &st, solution, memspace, workingset, qrmanager);
  if (solution->state >= 0) {
    solution->iterations = 0;
    st.site = &ji_emlrtRSI;
    solution->maxConstr = b_maxConstraintViolation(&st, workingset,
      solution->xstar);
    if (solution->maxConstr > 1.0E-6) {
      st.site = &ji_emlrtRSI;
      phaseone(SD, &st, H, f, solution, memspace, workingset, qrmanager,
               cholmanager, objective, options, runTimeOptions);
      if (solution->state != 0) {
        st.site = &ji_emlrtRSI;
        solution->maxConstr = b_maxConstraintViolation(&st, workingset,
          solution->xstar);
        if (solution->maxConstr > 1.0E-6) {
          st.site = &ji_emlrtRSI;
          c_xcopy(&st, 617, solution->lambda);
          st.site = &ji_emlrtRSI;
          solution->fstar = computeFval(&st, objective,
            memspace->workspace_double, H, f, solution->xstar);
          solution->state = -2;
        } else {
          if (solution->maxConstr > 0.0) {
            st.site = &ji_emlrtRSI;
            g_xcopy(&st, nVar, solution->xstar, solution->searchDir);
            st.site = &ji_emlrtRSI;
            PresolveWorkingSet(SD, &st, solution, memspace, workingset,
                               qrmanager);
            st.site = &ji_emlrtRSI;
            maxConstr_new = b_maxConstraintViolation(&st, workingset,
              solution->xstar);
            if (maxConstr_new >= solution->maxConstr) {
              solution->maxConstr = maxConstr_new;
              st.site = &ji_emlrtRSI;
              g_xcopy(&st, nVar, solution->searchDir, solution->xstar);
            }
          }

          st.site = &ji_emlrtRSI;
          iterate(SD, &st, H, f, solution, memspace, workingset, qrmanager,
                  cholmanager, objective, options->StepTolerance,
                  options->ObjectiveLimit, runTimeOptions->MaxIterations);
        }
      }
    } else {
      st.site = &ji_emlrtRSI;
      iterate(SD, &st, H, f, solution, memspace, workingset, qrmanager,
              cholmanager, objective, options->StepTolerance,
              options->ObjectiveLimit, runTimeOptions->MaxIterations);
    }
  }
}

/* End of code generation (driver1.c) */
