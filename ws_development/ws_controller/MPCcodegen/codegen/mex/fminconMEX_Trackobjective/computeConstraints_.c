/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * computeConstraints_.c
 *
 * Code generation for function 'computeConstraints_'
 *
 */

/* Include files */
#include "computeConstraints_.h"
#include "checkVectorNonFinite.h"
#include "fminconMEX_Trackobjective.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo ab_emlrtRSI = { 1,  /* lineNo */
  "computeConstraints_",               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\computeConstraints_.p"/* pathName */
};

static emlrtECInfo f_emlrtECI = { -1,  /* nDims */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "computeConstraints_",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\computeConstraints_.p"/* pName */
};

static emlrtBCInfo db_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  1,                                   /* lineNo */
  1,                                   /* colNo */
  "",                                  /* aName */
  "computeConstraints_",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\computeConstraints_.p",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo jb_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "computeConstraints_",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\optim\\+optim\\+coder\\+utils\\+ObjNonlinEvaluator\\computeConstraints_.p"/* pName */
};

/* Function Definitions */
int32_T computeConstraints_(const emlrtStack *sp, const struct0_T
  obj_nonlcon_tunableEnvironment[1], int32_T obj_mCineq, int32_T obj_mCeq, const
  real_T x[66], emxArray_real_T *Cineq_workspace, int32_T ineq0, emxArray_real_T
  *Ceq_workspace, int32_T eq0)
{
  emlrtStack b_st;
  emlrtStack st;
  emxArray_real_T *varargout_1;
  emxArray_real_T *varargout_2;
  int32_T eqEnd;
  int32_T i;
  int32_T i1;
  int32_T ineqEnd;
  int32_T status;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &varargout_2, 2, &jb_emlrtRTEI, true);
  emxInit_real_T(sp, &varargout_1, 2, &jb_emlrtRTEI, true);
  ineqEnd = (ineq0 + obj_mCineq) - 1;
  eqEnd = (eq0 + obj_mCeq) - 1;
  st.site = &ab_emlrtRSI;
  b_st.site = &e_emlrtRSI;
  anon(&b_st, obj_nonlcon_tunableEnvironment[0].H,
       obj_nonlcon_tunableEnvironment[0].dt, obj_nonlcon_tunableEnvironment[0].
       state_size, obj_nonlcon_tunableEnvironment[0].Num,
       obj_nonlcon_tunableEnvironment[0].X0, obj_nonlcon_tunableEnvironment[0].
       model_param.K, x, varargout_1, varargout_2);
  if (ineq0 > ineqEnd) {
    i = -1;
    i1 = -1;
  } else {
    i = Cineq_workspace->size[0];
    if ((ineq0 < 1) || (ineq0 > i)) {
      emlrtDynamicBoundsCheckR2012b(ineq0, 1, i, &db_emlrtBCI, sp);
    }

    i = ineq0 - 2;
    i1 = Cineq_workspace->size[0];
    if ((ineqEnd < 1) || (ineqEnd > i1)) {
      emlrtDynamicBoundsCheckR2012b(ineqEnd, 1, i1, &db_emlrtBCI, sp);
    }

    i1 = ineqEnd - 1;
  }

  ineqEnd = i1 - i;
  i1 = varargout_1->size[0] * varargout_1->size[1];
  if (ineqEnd != i1) {
    emlrtSubAssignSizeCheck1dR2017a(ineqEnd, i1, &f_emlrtECI, sp);
  }

  for (i1 = 0; i1 < ineqEnd; i1++) {
    Cineq_workspace->data[(i + i1) + 1] = varargout_1->data[i1];
  }

  emxFree_real_T(&varargout_1);
  if (eq0 > eqEnd) {
    i = -1;
    i1 = -1;
  } else {
    i = Ceq_workspace->size[0];
    if ((eq0 < 1) || (eq0 > i)) {
      emlrtDynamicBoundsCheckR2012b(eq0, 1, i, &db_emlrtBCI, sp);
    }

    i = eq0 - 2;
    i1 = Ceq_workspace->size[0];
    if ((eqEnd < 1) || (eqEnd > i1)) {
      emlrtDynamicBoundsCheckR2012b(eqEnd, 1, i1, &db_emlrtBCI, sp);
    }

    i1 = eqEnd - 1;
  }

  ineqEnd = i1 - i;
  i1 = varargout_2->size[1] << 2;
  if (ineqEnd != i1) {
    emlrtSubAssignSizeCheck1dR2017a(ineqEnd, i1, &f_emlrtECI, sp);
  }

  for (i1 = 0; i1 < ineqEnd; i1++) {
    Ceq_workspace->data[(i + i1) + 1] = varargout_2->data[i1];
  }

  emxFree_real_T(&varargout_2);
  st.site = &ab_emlrtRSI;
  status = checkVectorNonFinite(&st, obj_mCineq, Cineq_workspace, ineq0);
  if (status == 1) {
    st.site = &ab_emlrtRSI;
    status = checkVectorNonFinite(&st, obj_mCeq, Ceq_workspace, eq0);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
  return status;
}

/* End of code generation (computeConstraints_.c) */
