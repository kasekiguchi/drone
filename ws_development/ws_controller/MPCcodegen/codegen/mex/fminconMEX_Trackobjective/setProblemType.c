/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * setProblemType.c
 *
 * Code generation for function 'setProblemType'
 *
 */

/* Include files */
#include "setProblemType.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "modifyOverheadPhaseOne_.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo jb_emlrtRSI = { 1,  /* lineNo */
  "setProblemType",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\setProblemType.p"/* pathName */
};

static emlrtRSInfo lb_emlrtRSI = { 1,  /* lineNo */
  "modifyOverheadRegularized_",        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p"/* pathName */
};

static emlrtBCInfo hb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "modifyOverheadRegularized_",        /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+WorkingSet\\modifyOverheadRegularized_.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void setProblemType(const emlrtStack *sp, j_struct_T *obj, int32_T PROBLEM_TYPE)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  int32_T b;
  int32_T i;
  int32_T idxGlobalColStart;
  int32_T idx_col;
  int32_T idx_lb;
  int32_T idx_local;
  int32_T idx_local_tmp;
  int32_T idx_row;
  int32_T mEq;
  int32_T mIneq;
  int32_T offsetEq1;
  int32_T offsetEq2;
  boolean_T overflow;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  switch (PROBLEM_TYPE) {
   case 3:
    obj->nVar = 66;
    obj->mConstr = obj->mConstrOrig;
    for (i = 0; i < 5; i++) {
      obj->sizes[i] = obj->sizesNormal[i];
    }

    for (i = 0; i < 6; i++) {
      obj->isActiveIdx[i] = obj->isActiveIdxNormal[i];
    }
    break;

   case 1:
    obj->nVar = 67;
    obj->mConstr = obj->mConstrOrig + 1;
    for (i = 0; i < 5; i++) {
      obj->sizes[i] = obj->sizesPhaseOne[i];
    }

    for (i = 0; i < 6; i++) {
      obj->isActiveIdx[i] = obj->isActiveIdxPhaseOne[i];
    }

    st.site = &jb_emlrtRSI;
    modifyOverheadPhaseOne_(&st, obj);
    break;

   case 2:
    obj->nVar = obj->nVarMax - 1;
    obj->mConstr = obj->mConstrMax - 1;
    for (i = 0; i < 5; i++) {
      obj->sizes[i] = obj->sizesRegularized[i];
    }

    for (i = 0; i < 6; i++) {
      obj->isActiveIdx[i] = obj->isActiveIdxRegularized[i];
    }

    if (obj->probType != 4) {
      st.site = &jb_emlrtRSI;
      mIneq = obj->sizes[2] + 66;
      mEq = obj->sizes[1];
      offsetEq1 = obj->sizes[2] + 66;
      offsetEq2 = (obj->sizes[2] + obj->sizes[1]) + 66;
      b_st.site = &lb_emlrtRSI;
      b_st.site = &lb_emlrtRSI;
      if ((1 <= obj->sizes[2]) && (obj->sizes[2] > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx_col = 0; idx_col <= mIneq - 67; idx_col++) {
        idx_lb = idx_col + 66;
        b_st.site = &lb_emlrtRSI;
        if ((67 <= idx_col + 66) && (idx_col + 66 > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx_row = 67; idx_row <= idx_lb; idx_row++) {
          i = obj->Aineq->size[0];
          if (idx_row > i) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->Aineq->size[1];
          if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
          }

          obj->Aineq->data[(idx_row + obj->Aineq->size[0] * idx_col) - 1] = 0.0;
        }

        i = obj->Aineq->size[0];
        if ((idx_col + 67 < 1) || (idx_col + 67 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_col + 67, 1, i, &hb_emlrtBCI, &st);
        }

        i = obj->Aineq->size[1];
        if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
        }

        obj->Aineq->data[(idx_col + obj->Aineq->size[0] * idx_col) + 66] = -1.0;
        idx_lb = idx_col + 68;
        b = obj->nVar;
        b_st.site = &lb_emlrtRSI;
        if ((idx_col + 68 <= obj->nVar) && (obj->nVar > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx_row = idx_lb; idx_row <= b; idx_row++) {
          i = obj->Aineq->size[0];
          if ((idx_row < 1) || (idx_row > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->Aineq->size[1];
          if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
          }

          obj->Aineq->data[(idx_row + obj->Aineq->size[0] * idx_col) - 1] = 0.0;
        }
      }

      idxGlobalColStart = obj->isActiveIdx[1] - 1;
      b_st.site = &lb_emlrtRSI;
      if ((1 <= obj->sizes[1]) && (obj->sizes[1] > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx_col = 0; idx_col < mEq; idx_col++) {
        b_st.site = &lb_emlrtRSI;
        if ((67 <= mIneq) && (mIneq > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx_row = 67; idx_row <= offsetEq1; idx_row++) {
          i = obj->Aeq->size[0];
          if (idx_row > i) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->Aeq->size[1];
          if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
          }

          obj->Aeq->data[(idx_row + obj->Aeq->size[0] * idx_col) - 1] = 0.0;
          i = obj->ATwset->size[0];
          if (idx_row > i) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->ATwset->size[1];
          idx_local_tmp = (idxGlobalColStart + idx_col) + 1;
          if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_local_tmp, 1, i, &hb_emlrtBCI, &st);
          }

          obj->ATwset->data[(idx_row + obj->ATwset->size[0] * (idx_local_tmp - 1))
            - 1] = 0.0;
        }

        idx_lb = mIneq + 1;
        idx_local = (mIneq + idx_col) + 1;
        b = idx_local - 1;
        b_st.site = &lb_emlrtRSI;
        if ((offsetEq1 + 1 <= idx_local - 1) && (idx_local - 1 > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx_row = idx_lb; idx_row <= b; idx_row++) {
          i = obj->Aeq->size[0];
          if ((idx_row < 1) || (idx_row > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->Aeq->size[1];
          if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
          }

          obj->Aeq->data[(idx_row + obj->Aeq->size[0] * idx_col) - 1] = 0.0;
          i = obj->ATwset->size[0];
          if (idx_row > i) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->ATwset->size[1];
          idx_local_tmp = (idxGlobalColStart + idx_col) + 1;
          if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_local_tmp, 1, i, &hb_emlrtBCI, &st);
          }

          obj->ATwset->data[(idx_row + obj->ATwset->size[0] * (idx_local_tmp - 1))
            - 1] = 0.0;
        }

        i = obj->Aeq->size[0];
        if ((idx_local < 1) || (idx_local > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_local, 1, i, &hb_emlrtBCI, &st);
        }

        i = obj->Aeq->size[1];
        if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
        }

        obj->Aeq->data[(idx_local + obj->Aeq->size[0] * idx_col) - 1] = -1.0;
        i = obj->ATwset->size[0];
        if (idx_local > i) {
          emlrtDynamicBoundsCheckR2012b(idx_local, 1, i, &hb_emlrtBCI, &st);
        }

        i = obj->ATwset->size[1];
        idx_local_tmp = (idxGlobalColStart + idx_col) + 1;
        if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_local_tmp, 1, i, &hb_emlrtBCI, &st);
        }

        obj->ATwset->data[(idx_local + obj->ATwset->size[0] * (idx_local_tmp - 1))
          - 1] = -1.0;
        idx_lb = idx_local + 1;
        b_st.site = &lb_emlrtRSI;
        if ((idx_local + 1 <= offsetEq2) && (offsetEq2 > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx_row = idx_lb; idx_row <= offsetEq2; idx_row++) {
          i = obj->Aeq->size[0];
          if ((idx_row < 1) || (idx_row > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->Aeq->size[1];
          if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
          }

          obj->Aeq->data[(idx_row + obj->Aeq->size[0] * idx_col) - 1] = 0.0;
          i = obj->ATwset->size[0];
          if (idx_row > i) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->ATwset->size[1];
          idx_local_tmp = (idxGlobalColStart + idx_col) + 1;
          if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_local_tmp, 1, i, &hb_emlrtBCI, &st);
          }

          obj->ATwset->data[(idx_row + obj->ATwset->size[0] * (idx_local_tmp - 1))
            - 1] = 0.0;
        }

        idx_lb = offsetEq2 + 1;
        idx_local = (offsetEq2 + idx_col) + 1;
        b = idx_local - 1;
        b_st.site = &lb_emlrtRSI;
        if ((offsetEq2 + 1 <= idx_local - 1) && (idx_local - 1 > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx_row = idx_lb; idx_row <= b; idx_row++) {
          i = obj->Aeq->size[0];
          if ((idx_row < 1) || (idx_row > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->Aeq->size[1];
          if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
          }

          obj->Aeq->data[(idx_row + obj->Aeq->size[0] * idx_col) - 1] = 0.0;
          i = obj->ATwset->size[0];
          if (idx_row > i) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->ATwset->size[1];
          idx_local_tmp = (idxGlobalColStart + idx_col) + 1;
          if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_local_tmp, 1, i, &hb_emlrtBCI, &st);
          }

          obj->ATwset->data[(idx_row + obj->ATwset->size[0] * (idx_local_tmp - 1))
            - 1] = 0.0;
        }

        i = obj->Aeq->size[0];
        if ((idx_local < 1) || (idx_local > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_local, 1, i, &hb_emlrtBCI, &st);
        }

        i = obj->Aeq->size[1];
        if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
        }

        obj->Aeq->data[(idx_local + obj->Aeq->size[0] * idx_col) - 1] = 1.0;
        i = obj->ATwset->size[0];
        if (idx_local > i) {
          emlrtDynamicBoundsCheckR2012b(idx_local, 1, i, &hb_emlrtBCI, &st);
        }

        i = obj->ATwset->size[1];
        idx_local_tmp = (idxGlobalColStart + idx_col) + 1;
        if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_local_tmp, 1, i, &hb_emlrtBCI, &st);
        }

        obj->ATwset->data[(idx_local + obj->ATwset->size[0] * (idx_local_tmp - 1))
          - 1] = 1.0;
        idx_lb = idx_local + 1;
        b = obj->nVar;
        b_st.site = &lb_emlrtRSI;
        if ((idx_local + 1 <= obj->nVar) && (obj->nVar > 2147483646)) {
          c_st.site = &s_emlrtRSI;
          check_forloop_overflow_error(&c_st);
        }

        for (idx_row = idx_lb; idx_row <= b; idx_row++) {
          i = obj->Aeq->size[0];
          if ((idx_row < 1) || (idx_row > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->Aeq->size[1];
          if ((idx_col + 1 < 1) || (idx_col + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_col + 1, 1, i, &hb_emlrtBCI, &st);
          }

          obj->Aeq->data[(idx_row + obj->Aeq->size[0] * idx_col) - 1] = 0.0;
          i = obj->ATwset->size[0];
          if (idx_row > i) {
            emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
          }

          i = obj->ATwset->size[1];
          idx_local_tmp = (idxGlobalColStart + idx_col) + 1;
          if ((idx_local_tmp < 1) || (idx_local_tmp > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_local_tmp, 1, i, &hb_emlrtBCI, &st);
          }

          obj->ATwset->data[(idx_row + obj->ATwset->size[0] * (idx_local_tmp - 1))
            - 1] = 0.0;
        }
      }

      idx_lb = 66;
      b = obj->sizesRegularized[3];
      b_st.site = &lb_emlrtRSI;
      if ((1 <= obj->sizesRegularized[3]) && (obj->sizesRegularized[3] >
           2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idxGlobalColStart = 1; idxGlobalColStart <= b; idxGlobalColStart++) {
        idx_lb++;
        i = obj->indexLB->size[0];
        if (idxGlobalColStart > i) {
          emlrtDynamicBoundsCheckR2012b(idxGlobalColStart, 1, i, &hb_emlrtBCI,
            &st);
        }

        obj->indexLB->data[idxGlobalColStart - 1] = idx_lb;
      }

      b = (obj->sizes[2] + (obj->sizes[1] << 1)) + 66;
      b_st.site = &lb_emlrtRSI;
      if ((67 <= b) && (b > 2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idxGlobalColStart = 67; idxGlobalColStart <= b; idxGlobalColStart++)
      {
        i = obj->lb->size[0];
        if (idxGlobalColStart > i) {
          emlrtDynamicBoundsCheckR2012b(idxGlobalColStart, 1, i, &hb_emlrtBCI,
            &st);
        }

        obj->lb->data[idxGlobalColStart - 1] = 0.0;
      }

      idx_lb = obj->isActiveIdx[2];
      b = obj->nActiveConstr;
      b_st.site = &lb_emlrtRSI;
      if ((obj->isActiveIdx[2] <= obj->nActiveConstr) && (obj->nActiveConstr >
           2147483646)) {
        c_st.site = &s_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (idx_col = idx_lb; idx_col <= b; idx_col++) {
        i = obj->Wid->size[0];
        if ((idx_col < 1) || (idx_col > i)) {
          emlrtDynamicBoundsCheckR2012b(idx_col, 1, i, &hb_emlrtBCI, &st);
        }

        switch (obj->Wid->data[idx_col - 1]) {
         case 3:
          i = obj->Wlocalidx->size[0];
          if (idx_col > i) {
            emlrtDynamicBoundsCheckR2012b(idx_col, 1, i, &hb_emlrtBCI, &st);
          }

          idx_local_tmp = obj->Wlocalidx->data[idx_col - 1];
          idx_local = idx_local_tmp + 67;
          idxGlobalColStart = idx_local_tmp + 65;
          b_st.site = &lb_emlrtRSI;
          if (67 > obj->Wlocalidx->data[idx_col - 1] + 65) {
            overflow = false;
          } else {
            overflow = (obj->Wlocalidx->data[idx_col - 1] + 65 > 2147483646);
          }

          if (overflow) {
            c_st.site = &s_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (idx_row = 67; idx_row <= idxGlobalColStart; idx_row++) {
            i = obj->ATwset->size[0];
            if (idx_row > i) {
              emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
            }

            i = obj->ATwset->size[1];
            if (idx_col > i) {
              emlrtDynamicBoundsCheckR2012b(idx_col, 1, i, &hb_emlrtBCI, &st);
            }

            obj->ATwset->data[(idx_row + obj->ATwset->size[0] * (idx_col - 1)) -
              1] = 0.0;
          }

          i = obj->ATwset->size[0];
          if ((idx_local_tmp + 66 < 1) || (idx_local_tmp + 66 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx_local_tmp + 66, 1, i, &hb_emlrtBCI,
              &st);
          }

          i = obj->ATwset->size[1];
          if (idx_col > i) {
            emlrtDynamicBoundsCheckR2012b(idx_col, 1, i, &hb_emlrtBCI, &st);
          }

          obj->ATwset->data[(idx_local_tmp + obj->ATwset->size[0] * (idx_col - 1))
            + 65] = -1.0;
          idxGlobalColStart = obj->nVar;
          b_st.site = &lb_emlrtRSI;
          if ((idx_local_tmp + 67 <= obj->nVar) && (obj->nVar > 2147483646)) {
            c_st.site = &s_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (idx_row = idx_local; idx_row <= idxGlobalColStart; idx_row++) {
            i = obj->ATwset->size[0];
            if ((idx_row < 1) || (idx_row > i)) {
              emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
            }

            i = obj->ATwset->size[1];
            if (idx_col > i) {
              emlrtDynamicBoundsCheckR2012b(idx_col, 1, i, &hb_emlrtBCI, &st);
            }

            obj->ATwset->data[(idx_row + obj->ATwset->size[0] * (idx_col - 1)) -
              1] = 0.0;
          }
          break;

         default:
          idxGlobalColStart = obj->nVar;
          b_st.site = &lb_emlrtRSI;
          if ((67 <= obj->nVar) && (obj->nVar > 2147483646)) {
            c_st.site = &s_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (idx_row = 67; idx_row <= idxGlobalColStart; idx_row++) {
            i = obj->ATwset->size[0];
            if (idx_row > i) {
              emlrtDynamicBoundsCheckR2012b(idx_row, 1, i, &hb_emlrtBCI, &st);
            }

            i = obj->ATwset->size[1];
            if (idx_col > i) {
              emlrtDynamicBoundsCheckR2012b(idx_col, 1, i, &hb_emlrtBCI, &st);
            }

            obj->ATwset->data[(idx_row + obj->ATwset->size[0] * (idx_col - 1)) -
              1] = 0.0;
          }
          break;
        }
      }
    }
    break;

   default:
    obj->nVar = obj->nVarMax;
    obj->mConstr = obj->mConstrMax;
    for (i = 0; i < 5; i++) {
      obj->sizes[i] = obj->sizesRegPhaseOne[i];
    }

    for (i = 0; i < 6; i++) {
      obj->isActiveIdx[i] = obj->isActiveIdxRegPhaseOne[i];
    }

    st.site = &jb_emlrtRSI;
    modifyOverheadPhaseOne_(&st, obj);
    break;
  }

  obj->probType = PROBLEM_TYPE;
}

/* End of code generation (setProblemType.c) */
