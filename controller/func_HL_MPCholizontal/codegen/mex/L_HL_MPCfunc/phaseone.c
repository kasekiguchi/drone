/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * phaseone.c
 *
 * Code generation for function 'phaseone'
 *
 */

/* Include files */
#include "phaseone.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "computeFval.h"
#include "eml_int_forloop_overflow_check.h"
#include "iterate.h"
#include "moveConstraint_.h"
#include "removeAllIneqConstr.h"
#include "rt_nonfinite.h"
#include "setProblemType.h"

/* Variable Definitions */
static emlrtRSInfo be_emlrtRSI = { 1,  /* lineNo */
  "phaseone",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\phaseone.p"/* pathName */
};

static emlrtBCInfo lc_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "phaseone",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\phaseone.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo nc_emlrtBCI = { 1,  /* iFirst */
  305,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "phaseone",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\phaseone.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void phaseone(L_HL_MPCfuncStackData *SD, const emlrtStack *sp, const real_T H
              [12100], const real_T f[307], e_struct_T *solution, b_struct_T
              *memspace, g_struct_T *workingset, k_struct_T *qrmanager,
              l_struct_T *cholmanager, j_struct_T *objective, c_struct_T
              *options, const c_struct_T *runTimeOptions)
{
  int32_T PROBTYPE_ORIG;
  int32_T nVar;
  int32_T nVarP1;
  int32_T i;
  int32_T PHASEONE;
  boolean_T exitg1;
  int32_T TYPE;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  PROBTYPE_ORIG = workingset->probType;
  nVar = workingset->nVar;
  nVarP1 = workingset->nVar;
  i = workingset->nVar + 1;
  if ((i < 1) || (i > 307)) {
    emlrtDynamicBoundsCheckR2012b(i, 1, 307, &lc_emlrtBCI, sp);
  }

  solution->xstar[i - 1] = solution->maxConstr + 1.0;
  if (workingset->probType == 3) {
    PHASEONE = 1;
  } else {
    PHASEONE = 4;
  }

  st.site = &be_emlrtRSI;
  removeAllIneqConstr(&st, workingset);
  st.site = &be_emlrtRSI;
  setProblemType(&st, workingset, PHASEONE);
  objective->prev_objtype = objective->objtype;
  objective->prev_nvar = objective->nvar;
  objective->prev_hasLinear = objective->hasLinear;
  objective->objtype = 5;
  objective->nvar = nVarP1 + 1;
  objective->gammaScalar = 1.0;
  objective->hasLinear = true;
  options->ObjectiveLimit = 1.0E-6;
  options->StepTolerance = 1.4901161193847657E-10;
  st.site = &be_emlrtRSI;
  solution->fstar = computeFval(&st, objective, memspace->workspace_double, H, f,
    solution->xstar);
  solution->state = 5;
  st.site = &be_emlrtRSI;
  iterate(SD, &st, H, f, solution, memspace, workingset, qrmanager, cholmanager,
          objective, options->StepTolerance, options->ObjectiveLimit,
          runTimeOptions->MaxIterations);
  st.site = &be_emlrtRSI;
  i = workingset->isActiveIdx[3] + workingset->sizes[3];
  PHASEONE = i - 1;
  if ((PHASEONE < 1) || (PHASEONE > 305)) {
    emlrtDynamicBoundsCheckR2012b(PHASEONE, 1, 305, &mc_emlrtBCI, &st);
  }

  if (workingset->isActiveConstr[i - 2]) {
    st.site = &be_emlrtRSI;
    if ((89 <= workingset->nActiveConstr) && (workingset->nActiveConstr >
         2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    PHASEONE = 88;
    exitg1 = false;
    while ((!exitg1) && (PHASEONE + 1 <= workingset->nActiveConstr)) {
      i = PHASEONE + 1;
      if ((i < 1) || (i > 305)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 305, &nc_emlrtBCI, sp);
      }

      if ((workingset->Wid[i - 1] == 4) && (workingset->Wlocalidx[PHASEONE] ==
           workingset->sizes[3])) {
        st.site = &be_emlrtRSI;
        TYPE = workingset->Wid[PHASEONE];
        if ((workingset->Wid[PHASEONE] < 1) || (workingset->Wid[PHASEONE] > 6))
        {
          emlrtDynamicBoundsCheckR2012b(workingset->Wid[PHASEONE], 1, 6,
            &eb_emlrtBCI, &st);
        }

        i = (workingset->isActiveIdx[workingset->Wid[PHASEONE] - 1] +
             workingset->Wlocalidx[PHASEONE]) - 1;
        if ((i < 1) || (i > 305)) {
          emlrtDynamicBoundsCheckR2012b(i, 1, 305, &pb_emlrtBCI, &st);
        }

        workingset->isActiveConstr[i - 1] = false;
        b_st.site = &wc_emlrtRSI;
        moveConstraint_(&b_st, workingset, workingset->nActiveConstr, PHASEONE +
                        1);
        workingset->nActiveConstr--;
        if ((TYPE < 1) || (TYPE > 5)) {
          emlrtDynamicBoundsCheckR2012b(TYPE, 1, 5, &rb_emlrtBCI, &st);
        }

        workingset->nWConstr[TYPE - 1]--;
        exitg1 = true;
      } else {
        PHASEONE++;
      }
    }
  }

  PHASEONE = workingset->nActiveConstr;
  while ((PHASEONE > 88) && (PHASEONE > nVar)) {
    st.site = &be_emlrtRSI;
    if (PHASEONE > 305) {
      emlrtDynamicBoundsCheckR2012b(PHASEONE, 1, 305, &nb_emlrtBCI, &st);
    }

    TYPE = workingset->Wid[PHASEONE - 1];
    if ((TYPE < 1) || (TYPE > 6)) {
      emlrtDynamicBoundsCheckR2012b(workingset->Wid[PHASEONE - 1], 1, 6,
        &eb_emlrtBCI, &st);
    }

    i = (workingset->isActiveIdx[TYPE - 1] + workingset->Wlocalidx[PHASEONE - 1])
      - 1;
    if ((i < 1) || (i > 305)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 305, &pb_emlrtBCI, &st);
    }

    workingset->isActiveConstr[i - 1] = false;
    b_st.site = &wc_emlrtRSI;
    moveConstraint_(&b_st, workingset, workingset->nActiveConstr, PHASEONE);
    workingset->nActiveConstr--;
    if (TYPE > 5) {
      emlrtDynamicBoundsCheckR2012b(6, 1, 5, &rb_emlrtBCI, &st);
    }

    workingset->nWConstr[TYPE - 1]--;
    PHASEONE--;
  }

  solution->maxConstr = solution->xstar[nVarP1];
  st.site = &be_emlrtRSI;
  setProblemType(&st, workingset, PROBTYPE_ORIG);
  objective->objtype = objective->prev_objtype;
  objective->nvar = objective->prev_nvar;
  objective->hasLinear = objective->prev_hasLinear;
  options->ObjectiveLimit = -1.0E+20;
  options->StepTolerance = 1.0E-6;
}

/* End of code generation (phaseone.c) */
