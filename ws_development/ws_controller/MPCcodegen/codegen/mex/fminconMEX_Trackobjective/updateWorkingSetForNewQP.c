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
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xcopy.h"

/* Function Definitions */
void updateWorkingSetForNewQP(const emlrtStack *sp, j_struct_T *WorkingSet,
  int32_T mIneq, int32_T mNonlinIneq, const emxArray_real_T *cIneq, int32_T mEq,
  int32_T mNonlinEq, const emxArray_real_T *cEq)
{
  emlrtStack b_st;
  emlrtStack st;
  int32_T b_i;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T iEq0;
  int32_T idx;
  int32_T idx_local_tmp;
  int32_T iw0;
  int32_T nVar;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  nVar = WorkingSet->nVar;
  st.site = &eb_emlrtRSI;
  if ((1 <= mEq) && (mEq > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mEq; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > cEq->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, cEq->size[0], &emlrtBCI, sp);
    }

    i = WorkingSet->beq->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &emlrtBCI, sp);
    }

    WorkingSet->beq->data[idx] = -cEq->data[idx];
    i = WorkingSet->beq->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &emlrtBCI, sp);
    }

    i = WorkingSet->bwset->size[0];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &emlrtBCI, sp);
    }

    WorkingSet->bwset->data[idx] = WorkingSet->beq->data[idx];
  }

  iw0 = WorkingSet->ldA * (mEq - mNonlinEq) + 1;
  iEq0 = iw0;
  st.site = &eb_emlrtRSI;
  if ((1 <= mNonlinEq) && (mNonlinEq > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mNonlinEq; idx++) {
    i = nVar - 1;
    for (b_i = 0; b_i <= i; b_i++) {
      idx_local_tmp = WorkingSet->Aeq->size[0] * WorkingSet->Aeq->size[1];
      i1 = iEq0 + b_i;
      if ((i1 < 1) || (i1 > idx_local_tmp)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, idx_local_tmp, &emlrtBCI, sp);
      }

      idx_local_tmp = WorkingSet->ATwset->size[0] * WorkingSet->ATwset->size[1];
      i2 = iw0 + b_i;
      if ((i2 < 1) || (i2 > idx_local_tmp)) {
        emlrtDynamicBoundsCheckR2012b(i2, 1, idx_local_tmp, &emlrtBCI, sp);
      }

      WorkingSet->ATwset->data[i2 - 1] = WorkingSet->Aeq->data[i1 - 1];
    }

    iw0 += WorkingSet->ldA;
    iEq0 += WorkingSet->ldA;
  }

  st.site = &eb_emlrtRSI;
  if ((1 <= mIneq) && (mIneq > 2147483646)) {
    b_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&b_st);
  }

  for (idx = 0; idx < mIneq; idx++) {
    if ((idx + 1 < 1) || (idx + 1 > cIneq->size[0])) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, cIneq->size[0], &emlrtBCI, sp);
    }

    i = WorkingSet->bineq->size[0] * WorkingSet->bineq->size[1];
    if ((idx + 1 < 1) || (idx + 1 > i)) {
      emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &emlrtBCI, sp);
    }

    WorkingSet->bineq->data[idx] = -cIneq->data[idx];
  }

  if (WorkingSet->nActiveConstr > mEq) {
    iw0 = mEq + 1;
    iEq0 = WorkingSet->nActiveConstr;
    st.site = &eb_emlrtRSI;
    if ((mEq + 1 <= WorkingSet->nActiveConstr) && (WorkingSet->nActiveConstr >
         2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = iw0; idx <= iEq0; idx++) {
      i = WorkingSet->Wlocalidx->size[0];
      if ((idx < 1) || (idx > i)) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &emlrtBCI, sp);
      }

      idx_local_tmp = WorkingSet->Wlocalidx->data[idx - 1];
      i = WorkingSet->Wid->size[0];
      if (idx > i) {
        emlrtDynamicBoundsCheckR2012b(idx, 1, i, &emlrtBCI, sp);
      }

      switch (WorkingSet->Wid->data[idx - 1]) {
       case 4:
        i = WorkingSet->lb->size[0];
        if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx->data[idx - 1], 1,
            i, &emlrtBCI, sp);
        }

        i = WorkingSet->bwset->size[0];
        if (idx > i) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i, &emlrtBCI, sp);
        }

        WorkingSet->bwset->data[idx - 1] = WorkingSet->lb->data
          [WorkingSet->Wlocalidx->data[idx - 1] - 1];
        break;

       case 5:
        i = WorkingSet->ub->size[0];
        if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx->data[idx - 1], 1,
            i, &emlrtBCI, sp);
        }

        i = WorkingSet->bwset->size[0];
        if (idx > i) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i, &emlrtBCI, sp);
        }

        WorkingSet->bwset->data[idx - 1] = WorkingSet->ub->data
          [WorkingSet->Wlocalidx->data[idx - 1] - 1];
        break;

       default:
        i = WorkingSet->bineq->size[0] * WorkingSet->bineq->size[1];
        if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
          emlrtDynamicBoundsCheckR2012b(WorkingSet->Wlocalidx->data[idx - 1], 1,
            i, &emlrtBCI, sp);
        }

        i = WorkingSet->bwset->size[0];
        if (idx > i) {
          emlrtDynamicBoundsCheckR2012b(idx, 1, i, &emlrtBCI, sp);
        }

        WorkingSet->bwset->data[idx - 1] = WorkingSet->bineq->data[idx_local_tmp
          - 1];
        if (idx_local_tmp >= mNonlinIneq) {
          st.site = &eb_emlrtRSI;
          xcopy(nVar, WorkingSet->Aineq, WorkingSet->ldA * (idx_local_tmp - 1) +
                1, WorkingSet->ATwset, WorkingSet->ldA * (idx - 1) + 1);
        }
        break;
      }
    }
  }
}

/* End of code generation (updateWorkingSetForNewQP.c) */
