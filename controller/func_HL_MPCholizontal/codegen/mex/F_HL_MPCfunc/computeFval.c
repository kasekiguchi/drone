/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeFval.c
 *
 * Code generation for function 'computeFval'
 *
 */

/* Include files */
#include "computeFval.h"
#include "F_HL_MPCfunc.h"
#include "linearForm_.h"
#include "rt_nonfinite.h"
#include "xdot.h"

/* Variable Definitions */
static emlrtRSInfo ri_emlrtRSI = { 1,  /* lineNo */
  "computeFval",                       /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeFval.p"/* pathName */
};

static emlrtBCInfo ld_emlrtBCI = { 1,  /* iFirst */
  485,                                 /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeFval",                       /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\optim\\+optim\\+coder\\+qpactiveset\\+Objective\\computeFval.p",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
real_T computeFval(const emlrtStack *sp, const j_struct_T *obj, real_T
                   workspace[299245], const real_T H[17424], const real_T f[485],
                   const real_T x[485])
{
  real_T val;
  int32_T i;
  int32_T idx;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  val = 0.0;
  switch (obj->objtype) {
   case 5:
    if ((obj->nvar < 1) || (obj->nvar > 485)) {
      emlrtDynamicBoundsCheckR2012b(obj->nvar, 1, 485, &ld_emlrtBCI, sp);
    }

    val = obj->gammaScalar * x[obj->nvar - 1];
    break;

   case 3:
    st.site = &ri_emlrtRSI;
    linearForm_(&st, obj->hasLinear, obj->nvar, workspace, H, f, x);
    st.site = &ri_emlrtRSI;
    val = b_xdot(&st, obj->nvar, x, workspace);
    break;

   case 4:
    st.site = &ri_emlrtRSI;
    linearForm_(&st, obj->hasLinear, obj->nvar, workspace, H, f, x);
    i = obj->nvar + 1;
    for (idx = i; idx < 485; idx++) {
      workspace[idx - 1] = 0.5 * obj->beta * x[idx - 1] + obj->rho;
    }

    st.site = &ri_emlrtRSI;
    val = b_xdot(&st, 484, x, workspace);
    break;
  }

  return val;
}

/* End of code generation (computeFval.c) */
