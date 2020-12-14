/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * updateWorkingSetForNewQP.c
 *
 * Code generation for function 'updateWorkingSetForNewQP'
 *
 */

/* Include files */
#include "updateWorkingSetForNewQP.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"
#include "xcopy.h"

/* Variable Definitions */
static emlrtBCInfo tb_emlrtBCI = { 1,  /* iFirst */
  617,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSetForNewQP",          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ub_emlrtBCI = { 1,  /* iFirst */
  176,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSetForNewQP",          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vb_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "updateWorkingSetForNewQP",          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+internal\\updateWorkingSetForNewQP.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void updateWorkingSetForNewQP(const emlrtStack *sp, g_struct_T *WorkingSet,
  const real_T cIneq[176], const real_T cEq[88])
{
  int32_T nVar;
  int32_T idx;
  int32_T iw0;
  int32_T iEq0;
  int32_T i;
  int32_T b_i;
  int32_T i1;
  int32_T i2;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nVar = WorkingSet->nVar;
  st.site = &we_emlrtRSI;
  for (idx = 0; idx < 88; idx++) {
    WorkingSet->beq[idx] = -cEq[idx];
    WorkingSet->bwset[idx] = WorkingSet->beq[idx];
  }

  iw0 = 1;
  iEq0 = 1;
  st.site = &we_emlrtRSI;
  i = nVar - 1;
  for (idx = 0; idx < 88; idx++) {
    for (b_i = 0; b_i <= i; b_i++) {
      i1 = iEq0 + b_i;
      if ((i1 < 1) || (i1 > 42680)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, 42680, &d_emlrtBCI, sp);
      }

      i2 = iw0 + b_i;
      if ((i2 < 1) || (i2 > 299245)) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, 299245, &c_emlrtBCI, sp);
      }

      WorkingSet->ATwset[i2 - 1] = WorkingSet->Aeq[i1 - 1];
    }

    iw0 += 485;
    iEq0 += 485;
  }

  st.site = &we_emlrtRSI;
  for (idx = 0; idx < 176; idx++) {
    WorkingSet->bineq[idx] = -cIneq[idx];
  }

  if (WorkingSet->nActiveConstr > 88) {
    iw0 = WorkingSet->nActiveConstr;
    st.site = &we_emlrtRSI;
    if ((89 <= WorkingSet->nActiveConstr) && (WorkingSet->nActiveConstr >
         2147483646)) {
      b_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 89; idx <= iw0; idx++) {
      if (idx > 617) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, 617, &tb_emlrtBCI, sp);
      }

      switch (WorkingSet->Wid[idx - 1]) {
       case 4:
        i = WorkingSet->Wlocalidx[idx - 1];
        if ((i < 1) || (i > 485)) {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx[idx - 1], 1, 485,
            &vb_emlrtBCI, sp);
        }

        WorkingSet->bwset[idx - 1] = WorkingSet->lb[WorkingSet->Wlocalidx[idx -
          1] - 1];
        break;

       case 5:
        i = WorkingSet->Wlocalidx[idx - 1];
        if ((i < 1) || (i > 485)) {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx[idx - 1], 1, 485,
            &vb_emlrtBCI, sp);
        }

        WorkingSet->bwset[idx - 1] = WorkingSet->ub[WorkingSet->Wlocalidx[idx -
          1] - 1];
        break;

       default:
        i = WorkingSet->Wlocalidx[idx - 1];
        if ((i < 1) || (i > 176)) {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx[idx - 1], 1, 176,
            &ub_emlrtBCI, sp);
        }

        WorkingSet->bwset[idx - 1] = WorkingSet->bineq[i - 1];
        if (WorkingSet->Wlocalidx[idx - 1] >= 176) {
          st.site = &we_emlrtRSI;
          xcopy(&st, nVar, WorkingSet->Aineq, 84876, WorkingSet->ATwset, 485 *
                (idx - 1) + 1);
        }
        break;
      }
    }
  }
}

/* End of code generation (updateWorkingSetForNewQP.c) */
