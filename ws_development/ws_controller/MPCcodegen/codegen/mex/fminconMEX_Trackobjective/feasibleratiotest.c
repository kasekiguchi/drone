/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * feasibleratiotest.c
 *
 * Code generation for function 'feasibleratiotest'
 *
 */

/* Include files */
#include "feasibleratiotest.h"
#include "eml_int_forloop_overflow_check.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "xcopy.h"
#include "xgemv.h"
#include "xnrm2.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo cf_emlrtRSI = { 1,  /* lineNo */
  "feasibleratiotest",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\feasibleratiotest.p"/* pathName */
};

static emlrtBCInfo gd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "feasibleratiotest",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\feasibleratiotest.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void feasibleratiotest(const emlrtStack *sp, const emxArray_real_T
  *solution_xstar, const emxArray_real_T *solution_searchDir, emxArray_real_T
  *workspace, int32_T workingset_nVar, int32_T workingset_ldA, const
  emxArray_real_T *workingset_Aineq, const emxArray_real_T *workingset_bineq,
  const emxArray_real_T *workingset_lb, const emxArray_int32_T
  *workingset_indexLB, const int32_T workingset_sizes[5], const int32_T
  workingset_isActiveIdx[6], const emxArray_boolean_T *workingset_isActiveConstr,
  const int32_T workingset_nWConstr[5], boolean_T isPhaseOne, real_T *alpha,
  boolean_T *newBlocking, int32_T *constrType, int32_T *constrIdx)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T alphaTemp;
  real_T denomTol;
  real_T phaseOneCorrectionP;
  real_T phaseOneCorrectionX;
  real_T ratio;
  int32_T i;
  int32_T i1;
  int32_T idx;
  int32_T ldw;
  int32_T totalIneq;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  totalIneq = workingset_sizes[2];
  *alpha = 1.0E+30;
  *newBlocking = false;
  *constrType = 0;
  *constrIdx = 0;
  denomTol = 2.2204460492503131E-13 * xnrm2(workingset_nVar, solution_searchDir);
  if (workingset_nWConstr[2] < workingset_sizes[2]) {
    st.site = &cf_emlrtRSI;
    b_xcopy(workingset_sizes[2], workingset_bineq, workspace);
    st.site = &cf_emlrtRSI;
    e_xgemv(workingset_nVar, workingset_sizes[2], workingset_Aineq,
            workingset_ldA, solution_xstar, workspace);
    ldw = workspace->size[0];
    st.site = &cf_emlrtRSI;
    k_xgemv(workingset_nVar, workingset_sizes[2], workingset_Aineq,
            workingset_ldA, solution_searchDir, workspace, workspace->size[0] +
            1);
    st.site = &cf_emlrtRSI;
    if ((1 <= workingset_sizes[2]) && (workingset_sizes[2] > 2147483646)) {
      b_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < totalIneq; idx++) {
      i = workspace->size[0] * workspace->size[1];
      i1 = (ldw + idx) + 1;
      if ((i1 < 1) || (i1 > i)) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, i, &gd_emlrtBCI, sp);
      }

      if (workspace->data[i1 - 1] > denomTol) {
        st.site = &cf_emlrtRSI;
        i = (workingset_isActiveIdx[2] + idx) + 1;
        if ((i - 1 < 1) || (i - 1 > workingset_isActiveConstr->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i - 1, 1,
            workingset_isActiveConstr->size[0], &tb_emlrtBCI, &st);
        }

        if (!workingset_isActiveConstr->data[i - 2]) {
          i = workspace->size[0] * workspace->size[1];
          if ((idx + 1 < 1) || (idx + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &gd_emlrtBCI, sp);
          }

          i = workspace->size[0] * workspace->size[1];
          if ((idx + 1 < 1) || (idx + 1 > i)) {
            emlrtDynamicBoundsCheckR2012b(idx + 1, 1, i, &gd_emlrtBCI, sp);
          }

          i = workspace->size[0] * workspace->size[1];
          if (i1 > i) {
            emlrtDynamicBoundsCheckR2012b(i1, 1, i, &gd_emlrtBCI, sp);
          }

          alphaTemp = muDoubleScalarMin(muDoubleScalarAbs(workspace->data[idx]),
            1.0E-6 - workspace->data[idx]) / workspace->data[i1 - 1];
          if (alphaTemp < *alpha) {
            *alpha = alphaTemp;
            *constrType = 3;
            *constrIdx = idx + 1;
            *newBlocking = true;
          }
        }
      }
    }
  }

  if (workingset_nWConstr[3] < workingset_sizes[3]) {
    if ((workingset_nVar < 1) || (workingset_nVar > solution_xstar->size[0])) {
      emlrtDynamicBoundsCheckR2012b(workingset_nVar, 1, solution_xstar->size[0],
        &gd_emlrtBCI, sp);
    }

    phaseOneCorrectionX = (real_T)isPhaseOne * solution_xstar->
      data[workingset_nVar - 1];
    if (workingset_nVar > solution_searchDir->size[0]) {
      emlrtDynamicBoundsCheckR2012b(workingset_nVar, 1, solution_searchDir->
        size[0], &gd_emlrtBCI, sp);
    }

    phaseOneCorrectionP = (real_T)isPhaseOne * solution_searchDir->
      data[workingset_nVar - 1];
    totalIneq = workingset_sizes[3];
    st.site = &cf_emlrtRSI;
    for (idx = 0; idx <= totalIneq - 2; idx++) {
      if ((idx + 1 < 1) || (idx + 1 > workingset_indexLB->size[0])) {
        emlrtDynamicBoundsCheckR2012b(idx + 1, 1, workingset_indexLB->size[0],
          &gd_emlrtBCI, sp);
      }

      if ((workingset_indexLB->data[idx] < 1) || (workingset_indexLB->data[idx] >
           solution_searchDir->size[0])) {
        emlrtDynamicBoundsCheckR2012b(workingset_indexLB->data[idx], 1,
          solution_searchDir->size[0], &gd_emlrtBCI, sp);
      }

      alphaTemp = -solution_searchDir->data[workingset_indexLB->data[idx] - 1] -
        phaseOneCorrectionP;
      if (alphaTemp > denomTol) {
        st.site = &cf_emlrtRSI;
        i = workingset_isActiveIdx[3] + idx;
        if ((i < 1) || (i > workingset_isActiveConstr->size[0])) {
          emlrtDynamicBoundsCheckR2012b(i, 1, workingset_isActiveConstr->size[0],
            &tb_emlrtBCI, &st);
        }

        if (!workingset_isActiveConstr->data[i - 1]) {
          if ((workingset_indexLB->data[idx] < 1) || (workingset_indexLB->
               data[idx] > solution_xstar->size[0])) {
            emlrtDynamicBoundsCheckR2012b(workingset_indexLB->data[idx], 1,
              solution_xstar->size[0], &gd_emlrtBCI, sp);
          }

          if ((workingset_indexLB->data[idx] < 1) || (workingset_indexLB->
               data[idx] > workingset_lb->size[0])) {
            emlrtDynamicBoundsCheckR2012b(workingset_indexLB->data[idx], 1,
              workingset_lb->size[0], &gd_emlrtBCI, sp);
          }

          ratio = (-solution_xstar->data[workingset_indexLB->data[idx] - 1] -
                   workingset_lb->data[workingset_indexLB->data[idx] - 1]) -
            phaseOneCorrectionX;
          alphaTemp = muDoubleScalarMin(muDoubleScalarAbs(ratio), 1.0E-6 - ratio)
            / alphaTemp;
          if (alphaTemp < *alpha) {
            *alpha = alphaTemp;
            *constrType = 4;
            *constrIdx = idx + 1;
            *newBlocking = true;
          }
        }
      }
    }

    if ((workingset_sizes[3] < 1) || (workingset_sizes[3] >
         workingset_indexLB->size[0])) {
      emlrtDynamicBoundsCheckR2012b(workingset_sizes[3], 1,
        workingset_indexLB->size[0], &gd_emlrtBCI, sp);
    }

    i = workingset_indexLB->data[workingset_sizes[3] - 1];
    if ((i < 1) || (i > solution_searchDir->size[0])) {
      emlrtDynamicBoundsCheckR2012b(i, 1, solution_searchDir->size[0],
        &gd_emlrtBCI, sp);
    }

    if (-solution_searchDir->data[i - 1] > denomTol) {
      st.site = &cf_emlrtRSI;
      i1 = workingset_isActiveIdx[3] + workingset_sizes[3];
      if ((i1 - 1 < 1) || (i1 - 1 > workingset_isActiveConstr->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i1 - 1, 1, workingset_isActiveConstr->
          size[0], &tb_emlrtBCI, &st);
      }

      if (!workingset_isActiveConstr->data[i1 - 2]) {
        if (i > solution_xstar->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, solution_xstar->size[0],
            &gd_emlrtBCI, sp);
        }

        if (i > workingset_lb->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, workingset_lb->size[0],
            &gd_emlrtBCI, sp);
        }

        ratio = -solution_xstar->data[i - 1] - workingset_lb->data[i - 1];
        if (i > solution_searchDir->size[0]) {
          emlrtDynamicBoundsCheckR2012b(i, 1, solution_searchDir->size[0],
            &gd_emlrtBCI, sp);
        }

        alphaTemp = muDoubleScalarMin(muDoubleScalarAbs(ratio), 1.0E-6 - ratio) /
          -solution_searchDir->data[i - 1];
        if (alphaTemp < *alpha) {
          *alpha = alphaTemp;
          *constrType = 4;
          *constrIdx = workingset_sizes[3];
          *newBlocking = true;
        }
      }
    }
  }

  if (workingset_nWConstr[4] < 0) {
    if ((workingset_nVar < 1) || (workingset_nVar > solution_xstar->size[0])) {
      emlrtDynamicBoundsCheckR2012b(workingset_nVar, 1, solution_xstar->size[0],
        &gd_emlrtBCI, sp);
    }

    if (workingset_nVar > solution_searchDir->size[0]) {
      emlrtDynamicBoundsCheckR2012b(workingset_nVar, 1, solution_searchDir->
        size[0], &gd_emlrtBCI, sp);
    }

    st.site = &cf_emlrtRSI;
  }

  if (!isPhaseOne) {
    if ((*newBlocking) && (*alpha > 1.0)) {
      *newBlocking = false;
    }

    *alpha = muDoubleScalarMin(*alpha, 1.0);
  }
}

/* End of code generation (feasibleratiotest.c) */
