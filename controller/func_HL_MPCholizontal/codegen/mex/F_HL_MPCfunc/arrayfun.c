/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * arrayfun.c
 *
 * Code generation for function 'arrayfun'
 *
 */

/* Include files */
#include "arrayfun.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "F_HL_MPCfunc_emxutil.h"
#include "Linedistance.h"
#include "eml_int_forloop_overflow_check.h"
#include "pchip.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo ge_emlrtRSI = { 42, /* lineNo */
  "@(L) Linedistance(X(1,L),X(5,L),param.sectionpoint,param.Section_change(2))",/* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo pe_emlrtRSI = { 47, /* lineNo */
  "@(L) pchip(param.P_chips(1,:),param.P_chips(2,:),X(1,L))",/* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtBCInfo w_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  42,                                  /* lineNo */
  55,                                  /* colNo */
  "X",                                 /* aName */
  "@(L) Linedistance(X(1,L),X(5,L),param.sectionpoint,param.Section_change(2))",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo x_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  42,                                  /* lineNo */
  62,                                  /* colNo */
  "X",                                 /* aName */
  "@(L) Linedistance(X(1,L),X(5,L),param.sectionpoint,param.Section_change(2))",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  47,                                  /* lineNo */
  88,                                  /* colNo */
  "X",                                 /* aName */
  "@(L) pchip(param.P_chips(1,:),param.P_chips(2,:),X(1,L))",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void arrayfun(const emlrtStack *sp, const real_T fun_tunableEnvironment_f1[2],
              const real_T fun_tunableEnvironment_f2[2], const real_T
              fun_tunableEnvironment_f3_front[22], const emxArray_real_T
              *varargin_1, emxArray_real_T *varargout_1)
{
  real_T inputExamples_idx_0;
  int32_T n;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &p_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  b_st.site = &q_emlrtRSI;
  if (varargin_1->size[1] == 0) {
    inputExamples_idx_0 = 0.0;
  } else {
    inputExamples_idx_0 = varargin_1->data[0];
  }

  c_st.site = &o_emlrtRSI;
  d_st.site = &d_emlrtRSI;
  b___anon_fcn(&d_st, fun_tunableEnvironment_f1, fun_tunableEnvironment_f2,
               fun_tunableEnvironment_f3_front, inputExamples_idx_0);
  n = varargout_1->size[0] * varargout_1->size[1];
  varargout_1->size[0] = 1;
  varargout_1->size[1] = varargin_1->size[1];
  emxEnsureCapacity_real_T(&st, varargout_1, n, &v_emlrtRTEI);
  n = varargin_1->size[1];
  b_st.site = &r_emlrtRSI;
  if ((1 <= varargin_1->size[1]) && (varargin_1->size[1] > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < n; k++) {
    b_st.site = &s_emlrtRSI;
    c_st.site = &d_emlrtRSI;
    inputExamples_idx_0 = b___anon_fcn(&c_st, fun_tunableEnvironment_f1,
      fun_tunableEnvironment_f2, fun_tunableEnvironment_f3_front,
      varargin_1->data[k]);
    varargout_1->data[k] = inputExamples_idx_0;
  }
}

void b_arrayfun(const emlrtStack *sp, const real_T fun_tunableEnvironment_f1[2],
                const real_T fun_tunableEnvironment_f2[2], const real_T
                fun_tunableEnvironment_f3_data[], const int32_T
                fun_tunableEnvironment_f3_size[2], const emxArray_real_T
                *varargin_1, emxArray_real_T *varargout_1)
{
  real_T inputExamples_idx_0;
  int32_T n;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &p_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  b_st.site = &q_emlrtRSI;
  if (varargin_1->size[1] == 0) {
    inputExamples_idx_0 = 0.0;
  } else {
    inputExamples_idx_0 = varargin_1->data[0];
  }

  c_st.site = &o_emlrtRSI;
  d_st.site = &d_emlrtRSI;
  c___anon_fcn(&d_st, fun_tunableEnvironment_f1, fun_tunableEnvironment_f2,
               fun_tunableEnvironment_f3_data, fun_tunableEnvironment_f3_size,
               inputExamples_idx_0);
  n = varargout_1->size[0] * varargout_1->size[1];
  varargout_1->size[0] = 1;
  varargout_1->size[1] = varargin_1->size[1];
  emxEnsureCapacity_real_T(&st, varargout_1, n, &v_emlrtRTEI);
  n = varargin_1->size[1];
  b_st.site = &r_emlrtRSI;
  if ((1 <= varargin_1->size[1]) && (varargin_1->size[1] > 2147483646)) {
    c_st.site = &t_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < n; k++) {
    b_st.site = &s_emlrtRSI;
    c_st.site = &d_emlrtRSI;
    inputExamples_idx_0 = c___anon_fcn(&c_st, fun_tunableEnvironment_f1,
      fun_tunableEnvironment_f2, fun_tunableEnvironment_f3_data,
      fun_tunableEnvironment_f3_size, varargin_1->data[k]);
    varargout_1->data[k] = inputExamples_idx_0;
  }
}

void c_arrayfun(const emlrtStack *sp, const real_T
                fun_tunableEnvironment_f1_data[], const int32_T
                fun_tunableEnvironment_f1_size[2], const real_T
                c_fun_tunableEnvironment_f2_sec[6], const real_T
                c_fun_tunableEnvironment_f2_Sec[4], real_T varargout_1[11])
{
  int32_T i;
  int32_T k;
  real_T outputs_idx_0;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &p_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  b_st.site = &q_emlrtRSI;
  c_st.site = &o_emlrtRSI;
  d_st.site = &d_emlrtRSI;
  if (1 > fun_tunableEnvironment_f1_size[0]) {
    emlrtDynamicBoundsCheckR2012b(1, 1, fun_tunableEnvironment_f1_size[0],
      &w_emlrtBCI, &d_st);
  }

  if (5 > fun_tunableEnvironment_f1_size[0]) {
    emlrtDynamicBoundsCheckR2012b(5, 1, fun_tunableEnvironment_f1_size[0],
      &x_emlrtBCI, &d_st);
  }

  e_st.site = &ge_emlrtRSI;
  Linedistance(&e_st, fun_tunableEnvironment_f1_data[0],
               fun_tunableEnvironment_f1_data[4],
               c_fun_tunableEnvironment_f2_sec, c_fun_tunableEnvironment_f2_Sec
               [1]);
  i = fun_tunableEnvironment_f1_size[0];
  for (k = 0; k < 11; k++) {
    b_st.site = &s_emlrtRSI;
    c_st.site = &d_emlrtRSI;
    d_st.site = &ge_emlrtRSI;
    outputs_idx_0 = Linedistance(&d_st, fun_tunableEnvironment_f1_data[i * k],
      fun_tunableEnvironment_f1_data[i * k + 4], c_fun_tunableEnvironment_f2_sec,
      c_fun_tunableEnvironment_f2_Sec[1]);
    varargout_1[k] = outputs_idx_0;
  }
}

void d_arrayfun(const emlrtStack *sp, const real_T
                c_fun_tunableEnvironment_f1_P_c[38], const real_T
                fun_tunableEnvironment_f2_data[], const int32_T
                fun_tunableEnvironment_f2_size[2], real_T varargout_1[11])
{
  int32_T i;
  real_T d_fun_tunableEnvironment_f1_P_c[19];
  real_T e_fun_tunableEnvironment_f1_P_c[19];
  int32_T f_fun_tunableEnvironment_f1_P_c;
  real_T outputs_idx_0;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &p_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  b_st.site = &q_emlrtRSI;
  c_st.site = &o_emlrtRSI;
  d_st.site = &d_emlrtRSI;
  if (1 > fun_tunableEnvironment_f2_size[0]) {
    emlrtDynamicBoundsCheckR2012b(1, 1, fun_tunableEnvironment_f2_size[0],
      &cb_emlrtBCI, &d_st);
  }

  for (i = 0; i < 19; i++) {
    f_fun_tunableEnvironment_f1_P_c = i << 1;
    d_fun_tunableEnvironment_f1_P_c[i] =
      c_fun_tunableEnvironment_f1_P_c[f_fun_tunableEnvironment_f1_P_c];
    e_fun_tunableEnvironment_f1_P_c[i] =
      c_fun_tunableEnvironment_f1_P_c[f_fun_tunableEnvironment_f1_P_c + 1];
  }

  e_st.site = &pe_emlrtRSI;
  pchip(&e_st, d_fun_tunableEnvironment_f1_P_c, e_fun_tunableEnvironment_f1_P_c,
        fun_tunableEnvironment_f2_data[0]);
  for (i = 0; i < 19; i++) {
    f_fun_tunableEnvironment_f1_P_c = i << 1;
    d_fun_tunableEnvironment_f1_P_c[i] =
      c_fun_tunableEnvironment_f1_P_c[f_fun_tunableEnvironment_f1_P_c];
    e_fun_tunableEnvironment_f1_P_c[i] =
      c_fun_tunableEnvironment_f1_P_c[f_fun_tunableEnvironment_f1_P_c + 1];
  }

  for (f_fun_tunableEnvironment_f1_P_c = 0; f_fun_tunableEnvironment_f1_P_c < 11;
       f_fun_tunableEnvironment_f1_P_c++) {
    b_st.site = &s_emlrtRSI;
    c_st.site = &d_emlrtRSI;
    d_st.site = &pe_emlrtRSI;
    outputs_idx_0 = pchip(&d_st, d_fun_tunableEnvironment_f1_P_c,
                          e_fun_tunableEnvironment_f1_P_c,
                          fun_tunableEnvironment_f2_data[fun_tunableEnvironment_f2_size
                          [0] * f_fun_tunableEnvironment_f1_P_c]);
    varargout_1[f_fun_tunableEnvironment_f1_P_c] = outputs_idx_0;
  }
}

/* End of code generation (arrayfun.c) */
