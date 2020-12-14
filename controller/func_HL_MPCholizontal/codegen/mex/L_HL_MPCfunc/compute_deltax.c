/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * compute_deltax.c
 *
 * Code generation for function 'compute_deltax'
 *
 */

/* Include files */
#include "compute_deltax.h"
#include "L_HL_MPCfunc.h"
#include "L_HL_MPCfunc_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "factor.h"
#include "rt_nonfinite.h"
#include "solve.h"
#include "xgemm.h"
#include "xgemv.h"
#include "xpotrf.h"

/* Variable Definitions */
static emlrtRSInfo pe_emlrtRSI = { 1,  /* lineNo */
  "compute_deltax",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_deltax.p"/* pathName */
};

static emlrtRSInfo ye_emlrtRSI = { 1,  /* lineNo */
  "computeProjectedHessian",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\computeProjectedHessian.p"/* pathName */
};

static emlrtRSInfo af_emlrtRSI = { 1,  /* lineNo */
  "computeProjectedHessian_regularized",/* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\computeProjectedHessian_regularized.p"/* pathName */
};

static emlrtBCInfo dd_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "compute_deltax",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_deltax.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo ed_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "compute_deltax",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_deltax.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fd_emlrtBCI = { 1,  /* iFirst */
  94249,                               /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "compute_deltax",                    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\compute_deltax.p",/* pName */
  3                                    /* checkKind */
};

static emlrtBCInfo gd_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeProjectedHessian_regularized",/* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\computeProjectedHessian_regularized.p",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hd_emlrtBCI = { 1,  /* iFirst */
  307,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeProjectedHessian_regularized",/* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+fminconsqp\\+step\\+relaxed\\computeProjectedHessian_regularized.p",/* pName */
  3                                    /* checkKind */
};

/* Function Definitions */
void compute_deltax(const emlrtStack *sp, const real_T H[12100], e_struct_T
                    *solution, b_struct_T *memspace, const k_struct_T *qrmanager,
                    l_struct_T *cholmanager, const j_struct_T *objective)
{
  int32_T nVar;
  int32_T mNull_tmp;
  int32_T idx;
  int32_T nVars;
  int32_T i;
  int32_T nullStartIdx_tmp;
  int32_T nVarOrig;
  real_T a;
  int32_T idx_row;
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
  nVar = qrmanager->mrows;
  mNull_tmp = qrmanager->mrows - qrmanager->ncols;
  if (mNull_tmp <= 0) {
    st.site = &pe_emlrtRSI;
    if ((1 <= qrmanager->mrows) && (qrmanager->mrows > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < nVar; idx++) {
      i = idx + 1;
      if ((i < 1) || (i > 307)) {
        emlrtDynamicBoundsCheckR2012b(i, 1, 307, &dd_emlrtBCI, sp);
      }

      solution->searchDir[i - 1] = 0.0;
    }
  } else {
    st.site = &pe_emlrtRSI;
    if ((1 <= qrmanager->mrows) && (qrmanager->mrows > 2147483646)) {
      b_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (idx = 0; idx < nVar; idx++) {
      nVars = idx + 1;
      if ((nVars < 1) || (nVars > 307)) {
        emlrtDynamicBoundsCheckR2012b(nVars, 1, 307, &ed_emlrtBCI, sp);
      }

      solution->searchDir[nVars - 1] = -objective->grad[nVars - 1];
    }

    if (qrmanager->ncols <= 0) {
      switch (objective->objtype) {
       case 5:
        break;

       case 3:
        st.site = &pe_emlrtRSI;
        factor(&st, cholmanager, H, qrmanager->mrows, qrmanager->mrows);
        if (cholmanager->info != 0) {
          solution->state = -6;
        } else {
          st.site = &pe_emlrtRSI;
          solve(cholmanager, solution->searchDir);
        }
        break;

       case 4:
        st.site = &pe_emlrtRSI;
        factor(&st, cholmanager, H, objective->nvar, objective->nvar);
        if (cholmanager->info != 0) {
          solution->state = -6;
        } else {
          st.site = &pe_emlrtRSI;
          solve(cholmanager, solution->searchDir);
          st.site = &pe_emlrtRSI;
          a = 1.0 / objective->beta;
          nVars = objective->nvar + 1;
          b_st.site = &sb_emlrtRSI;
          nVarOrig = qrmanager->mrows;
          c_st.site = &tb_emlrtRSI;
          if ((nVars <= nVarOrig) && (nVarOrig > 2147483646)) {
            d_st.site = &e_emlrtRSI;
            check_forloop_overflow_error(&d_st);
          }

          for (nVar = nVars; nVar <= nVarOrig; nVar++) {
            solution->searchDir[nVar - 1] *= a;
          }
        }
        break;
      }
    } else {
      nullStartIdx_tmp = 307 * qrmanager->ncols + 1;
      switch (objective->objtype) {
       case 5:
        st.site = &pe_emlrtRSI;
        if (mNull_tmp > 2147483646) {
          b_st.site = &e_emlrtRSI;
          check_forloop_overflow_error(&b_st);
        }

        for (idx = 0; idx < mNull_tmp; idx++) {
          if ((nVar < 1) || (nVar > 307)) {
            emlrtDynamicBoundsCheckR2012b(nVar, 1, 307, &ed_emlrtBCI, sp);
          }

          i = (qrmanager->ncols + idx) + 1;
          if ((i < 1) || (i > 307)) {
            emlrtDynamicBoundsCheckR2012b(i, 1, 307, &ed_emlrtBCI, sp);
          }

          nVarOrig = idx + 1;
          if (nVarOrig > 94249) {
            emlrtDynamicBoundsCheckR2012b(nVarOrig, 1, 94249, &fd_emlrtBCI, sp);
          }

          memspace->workspace_double[nVarOrig - 1] = -qrmanager->Q[(nVar + 307 *
            (i - 1)) - 1];
        }

        st.site = &pe_emlrtRSI;
        n_xgemv(qrmanager->mrows, mNull_tmp, qrmanager->Q, nullStartIdx_tmp,
                memspace->workspace_double, solution->searchDir);
        break;

       default:
        switch (objective->objtype) {
         case 3:
          st.site = &pe_emlrtRSI;
          b_st.site = &ye_emlrtRSI;
          c_xgemm(qrmanager->mrows, mNull_tmp, qrmanager->mrows, H,
                  qrmanager->mrows, qrmanager->Q, nullStartIdx_tmp,
                  memspace->workspace_double);
          b_st.site = &ye_emlrtRSI;
          d_xgemm(mNull_tmp, mNull_tmp, qrmanager->mrows, qrmanager->Q,
                  nullStartIdx_tmp, memspace->workspace_double,
                  cholmanager->FMat);
          break;

         default:
          nVarOrig = objective->nvar + 1;
          st.site = &pe_emlrtRSI;
          nVars = qrmanager->mrows;
          b_st.site = &af_emlrtRSI;
          c_xgemm(objective->nvar, mNull_tmp, objective->nvar, H,
                  objective->nvar, qrmanager->Q, nullStartIdx_tmp,
                  memspace->workspace_double);
          b_st.site = &af_emlrtRSI;
          if (mNull_tmp > 2147483646) {
            c_st.site = &e_emlrtRSI;
            check_forloop_overflow_error(&c_st);
          }

          for (idx = 0; idx < mNull_tmp; idx++) {
            nVar = idx + 1;
            b_st.site = &af_emlrtRSI;
            if ((nVarOrig <= nVars) && (nVars > 2147483646)) {
              c_st.site = &e_emlrtRSI;
              check_forloop_overflow_error(&c_st);
            }

            for (idx_row = nVarOrig; idx_row <= nVars; idx_row++) {
              if ((idx_row < 1) || (idx_row > 307)) {
                emlrtDynamicBoundsCheckR2012b(idx_row, 1, 307, &gd_emlrtBCI, &st);
              }

              i = nVar + qrmanager->ncols;
              if ((i < 1) || (i > 307)) {
                emlrtDynamicBoundsCheckR2012b(i, 1, 307, &gd_emlrtBCI, &st);
              }

              if (nVar > 307) {
                emlrtDynamicBoundsCheckR2012b(nVar, 1, 307, &hd_emlrtBCI, &st);
              }

              memspace->workspace_double[(idx_row + 307 * (nVar - 1)) - 1] =
                objective->beta * qrmanager->Q[(idx_row + 307 * (i - 1)) - 1];
            }
          }

          b_st.site = &af_emlrtRSI;
          d_xgemm(mNull_tmp, mNull_tmp, qrmanager->mrows, qrmanager->Q,
                  nullStartIdx_tmp, memspace->workspace_double,
                  cholmanager->FMat);
          break;
        }

        st.site = &pe_emlrtRSI;
        cholmanager->ndims = mNull_tmp;
        b_st.site = &qe_emlrtRSI;
        cholmanager->info = xpotrf(&b_st, mNull_tmp, cholmanager->FMat);
        if (cholmanager->info != 0) {
          solution->state = -6;
        } else {
          st.site = &pe_emlrtRSI;
          o_xgemv(qrmanager->mrows, mNull_tmp, qrmanager->Q, nullStartIdx_tmp,
                  objective->grad, memspace->workspace_double);
          st.site = &pe_emlrtRSI;
          b_solve(cholmanager, memspace->workspace_double);
          st.site = &pe_emlrtRSI;
          n_xgemv(qrmanager->mrows, mNull_tmp, qrmanager->Q, nullStartIdx_tmp,
                  memspace->workspace_double, solution->searchDir);
        }
        break;
      }
    }
  }
}

/* End of code generation (compute_deltax.c) */
