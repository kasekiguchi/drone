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
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "xgemv.h"
#include "xnrm2.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo df_emlrtRSI = { 1,  /* lineNo */
  "feasibleratiotest",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\feasibleratiotest.p"/* pathName */
};

static emlrtBCInfo ld_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "feasibleratiotest",                 /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\feasibleratiotest.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void feasibleratiotest(const emlrtStack *sp, const real_T solution_xstar[307],
  const real_T solution_searchDir[307], real_T workspace[94249], int32_T
  workingset_nVar, const real_T workingset_Aineq[6140], const real_T
  workingset_bineq[20], const real_T workingset_lb[307], const int32_T
  workingset_indexLB[307], const int32_T workingset_sizes[5], const int32_T
  workingset_isActiveIdx[6], const boolean_T workingset_isActiveConstr[305],
  const int32_T workingset_nWConstr[5], boolean_T isPhaseOne, real_T *alpha,
  boolean_T *newBlocking, int32_T *constrType, int32_T *constrIdx)
{
  real_T denomTol;
  real_T phaseOneCorrectionX;
  real_T phaseOneCorrectionP;
  int32_T b;
  int32_T idx;
  int32_T i;
  real_T alphaTemp;
  real_T ratio;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  *alpha = 1.0E+30;
  *newBlocking = false;
  *constrType = 0;
  *constrIdx = 0;
  st.site = &df_emlrtRSI;
  denomTol = 2.2204460492503131E-13 * xnrm2(&st, workingset_nVar,
    solution_searchDir);
  if (workingset_nWConstr[2] < 20) {
    memcpy(&workspace[0], &workingset_bineq[0], 20U * sizeof(real_T));
    p_xgemv(workingset_nVar, workingset_Aineq, solution_xstar, workspace);
    q_xgemv(workingset_nVar, workingset_Aineq, solution_searchDir, workspace);
    for (idx = 0; idx < 20; idx++) {
      alphaTemp = workspace[idx + 307];
      if (alphaTemp > denomTol) {
        st.site = &df_emlrtRSI;
        i = workingset_isActiveIdx[2] + idx;
        if ((i < 1) || (i > 305)) {
          emlrtDynamicBoundsCheckR2012b(i, 1, 305, &mc_emlrtBCI, &st);
        }

        if (!workingset_isActiveConstr[i - 1]) {
          alphaTemp = muDoubleScalarMin(muDoubleScalarAbs(workspace[idx]),
            1.0E-6 - workspace[idx]) / alphaTemp;
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
    phaseOneCorrectionX = (real_T)isPhaseOne * solution_xstar[workingset_nVar -
      1];
    phaseOneCorrectionP = (real_T)isPhaseOne *
      solution_searchDir[workingset_nVar - 1];
    b = workingset_sizes[3];
    for (idx = 0; idx <= b - 2; idx++) {
      if ((workingset_indexLB[idx] < 1) || (workingset_indexLB[idx] > 307)) {
        emlrtDynamicBoundsCheckR2012b(workingset_indexLB[idx], 1, 307,
          &ld_emlrtBCI, sp);
      }

      alphaTemp = -solution_searchDir[workingset_indexLB[idx] - 1] -
        phaseOneCorrectionP;
      if (alphaTemp > denomTol) {
        st.site = &df_emlrtRSI;
        i = workingset_isActiveIdx[3] + idx;
        if ((i < 1) || (i > 305)) {
          emlrtDynamicBoundsCheckR2012b(i, 1, 305, &mc_emlrtBCI, &st);
        }

        if (!workingset_isActiveConstr[i - 1]) {
          ratio = (-solution_xstar[workingset_indexLB[idx] - 1] -
                   workingset_lb[workingset_indexLB[idx] - 1]) -
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

    if ((workingset_sizes[3] < 1) || (workingset_sizes[3] > 307)) {
      emlrtDynamicBoundsCheckR2012b(workingset_sizes[3], 1, 307, &ld_emlrtBCI,
        sp);
    }

    i = workingset_indexLB[workingset_sizes[3] - 1];
    if ((i < 1) || (i > 307)) {
      emlrtDynamicBoundsCheckR2012b(i, 1, 307, &ld_emlrtBCI, sp);
    }

    if (-solution_searchDir[i - 1] > denomTol) {
      st.site = &df_emlrtRSI;
      i = workingset_isActiveIdx[3] + workingset_sizes[3];
      b = i - 1;
      if ((b < 1) || (b > 305)) {
        emlrtDynamicBoundsCheckR2012b(b, 1, 305, &mc_emlrtBCI, &st);
      }

      if (!workingset_isActiveConstr[i - 2]) {
        ratio = -solution_xstar[workingset_indexLB[workingset_sizes[3] - 1] - 1]
          - workingset_lb[workingset_indexLB[workingset_sizes[3] - 1] - 1];
        alphaTemp = muDoubleScalarMin(muDoubleScalarAbs(ratio), 1.0E-6 - ratio) /
          -solution_searchDir[workingset_indexLB[workingset_sizes[3] - 1] - 1];
        if (alphaTemp < *alpha) {
          *alpha = alphaTemp;
          *constrType = 4;
          *constrIdx = workingset_sizes[3];
          *newBlocking = true;
        }
      }
    }
  }

  if (!isPhaseOne) {
    if ((*newBlocking) && (*alpha > 1.0)) {
      *newBlocking = false;
    }

    *alpha = muDoubleScalarMin(*alpha, 1.0);
  }
}

/* End of code generation (feasibleratiotest.c) */
