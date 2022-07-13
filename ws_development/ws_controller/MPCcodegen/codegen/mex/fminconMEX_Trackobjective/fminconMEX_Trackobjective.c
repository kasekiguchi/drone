/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * fminconMEX_Trackobjective.c
 *
 * Code generation for function 'fminconMEX_Trackobjective'
 *
 */

/* Include files */
#include "fminconMEX_Trackobjective.h"
#include "TrackobjectiveMEX.h"
#include "eml_int_forloop_overflow_check.h"
#include "fmincon.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 36,    /* lineNo */
  "fminconMEX_Trackobjective",         /* fcnName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 35,  /* lineNo */
  "@(x)constraintsMEX(x,param)",       /* fcnName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pathName */
};

static emlrtRSInfo g_emlrtRSI = { 11,  /* lineNo */
  "constraintsMEX",                    /* fcnName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pathName */
};

static emlrtRSInfo j_emlrtRSI = { 34,  /* lineNo */
  "@(x)TrackobjectiveMEX(x,param)",    /* fcnName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pathName */
};

static emlrtRSInfo k_emlrtRSI = { 11,  /* lineNo */
  "TrackobjectiveMEX",                 /* fcnName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pathName */
};

static emlrtRSInfo l_emlrtRSI = { 12,  /* lineNo */
  "TrackobjectiveMEX",                 /* fcnName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 16,  /* lineNo */
  "TrackobjectiveMEX",                 /* fcnName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pathName */
};

static emlrtRSInfo n_emlrtRSI = { 40,  /* lineNo */
  "arrayfun",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pathName */
};

static emlrtRSInfo o_emlrtRSI = { 49,  /* lineNo */
  "applyArrayFunction",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pathName */
};

static emlrtRSInfo p_emlrtRSI = { 63,  /* lineNo */
  "applyArrayFunction",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pathName */
};

static emlrtRSInfo q_emlrtRSI = { 69,  /* lineNo */
  "applyArrayFunction",                /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pathName */
};

static emlrtRSInfo r_emlrtRSI = { 31,  /* lineNo */
  "outputScalarEg",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\eml\\+coder\\+internal\\outputScalarEg.m"/* pathName */
};

static emlrtRSInfo v_emlrtRSI = { 20,  /* lineNo */
  "sum",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m"/* pathName */
};

static emlrtRSInfo w_emlrtRSI = { 99,  /* lineNo */
  "sumprod",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pathName */
};

static emlrtRSInfo x_emlrtRSI = { 133, /* lineNo */
  "combineVectorElements",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRSInfo y_emlrtRSI = { 194, /* lineNo */
  "colMajorFlatIter",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRTEInfo emlrtRTEI = { 18,  /* lineNo */
  33,                                  /* colNo */
  "fminconMEX_Trackobjective",         /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pName */
};

static emlrtRTEInfo b_emlrtRTEI = { 18,/* lineNo */
  70,                                  /* colNo */
  "fminconMEX_Trackobjective",         /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pName */
};

static emlrtRTEInfo c_emlrtRTEI = { 19,/* lineNo */
  35,                                  /* colNo */
  "fminconMEX_Trackobjective",         /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pName */
};

static emlrtRTEInfo d_emlrtRTEI = { 19,/* lineNo */
  73,                                  /* colNo */
  "fminconMEX_Trackobjective",         /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pName */
};

static emlrtRTEInfo e_emlrtRTEI = { 20,/* lineNo */
  33,                                  /* colNo */
  "fminconMEX_Trackobjective",         /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pName */
};

static emlrtRTEInfo f_emlrtRTEI = { 20,/* lineNo */
  70,                                  /* colNo */
  "fminconMEX_Trackobjective",         /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\fminconMEX_Trackobjective.m"/* pName */
};

static emlrtBCInfo b_emlrtBCI = { 1,   /* iFirst */
  6,                                   /* iLast */
  6,                                   /* lineNo */
  9,                                   /* colNo */
  "x",                                 /* aName */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { 1,   /* iFirst */
  6,                                   /* iLast */
  7,                                   /* lineNo */
  7,                                   /* colNo */
  "x",                                 /* aName */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo i_emlrtRTEI = { 10,/* lineNo */
  9,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtBCInfo d_emlrtBCI = { 1,   /* iFirst */
  11,                                  /* iLast */
  11,                                  /* lineNo */
  25,                                  /* colNo */
  "X",                                 /* aName */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo emlrtECI = { -1,    /* nDims */
  11,                                  /* lineNo */
  21,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtRTEInfo j_emlrtRTEI = { 15,/* lineNo */
  9,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtBCInfo e_emlrtBCI = { 1,   /* iFirst */
  11,                                  /* iLast */
  16,                                  /* lineNo */
  26,                                  /* colNo */
  "X",                                 /* aName */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  11,                                  /* lineNo */
  16,                                  /* colNo */
  "PredictX",                          /* aName */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  16,                                  /* lineNo */
  44,                                  /* colNo */
  "PredictX",                          /* aName */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo b_emlrtECI = { -1,  /* nDims */
  16,                                  /* lineNo */
  21,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtECInfo c_emlrtECI = { -1,  /* nDims */
  18,                                  /* lineNo */
  8,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  16,                                  /* lineNo */
  14,                                  /* colNo */
  "tmpceq",                            /* aName */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  27,                                  /* lineNo */
  7,                                   /* colNo */
  "u",                                 /* aName */
  "Model",                             /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  43,                                  /* colNo */
  "u",                                 /* aName */
  "Model",                             /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  48,                                  /* colNo */
  "u",                                 /* aName */
  "Model",                             /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo emlrtDCI = { 4,     /* lineNo */
  16,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 4,   /* lineNo */
  16,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo c_emlrtDCI = { 4,   /* lineNo */
  35,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = { 4,   /* lineNo */
  35,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo e_emlrtDCI = { 9,   /* lineNo */
  20,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo f_emlrtDCI = { 9,   /* lineNo */
  20,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo g_emlrtDCI = { 14,  /* lineNo */
  18,                                  /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo h_emlrtDCI = { 4,   /* lineNo */
  1,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo i_emlrtDCI = { 9,   /* lineNo */
  1,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo j_emlrtDCI = { 14,  /* lineNo */
  1,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { 1,   /* iFirst */
  11,                                  /* iLast */
  11,                                  /* lineNo */
  38,                                  /* colNo */
  "tildeX",                            /* aName */
  "@(L) tildeX(:, L)\' * params.Q * tildeX(:, L)",/* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo k_emlrtDCI = { 11,  /* lineNo */
  38,                                  /* colNo */
  "@(L) tildeX(:, L)\' * params.Q * tildeX(:, L)",/* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtECInfo d_emlrtECI = { 2,   /* nDims */
  16,                                  /* lineNo */
  12,                                  /* colNo */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pName */
};

static emlrtECInfo e_emlrtECI = { 2,   /* nDims */
  7,                                   /* lineNo */
  10,                                  /* colNo */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pName */
};

static emlrtBCInfo m_emlrtBCI = { 1,   /* iFirst */
  6,                                   /* iLast */
  5,                                   /* lineNo */
  7,                                   /* colNo */
  "x",                                 /* aName */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo l_emlrtDCI = { 5,   /* lineNo */
  7,                                   /* colNo */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { 1,   /* iFirst */
  6,                                   /* iLast */
  4,                                   /* lineNo */
  9,                                   /* colNo */
  "x",                                 /* aName */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo m_emlrtDCI = { 4,   /* lineNo */
  9,                                   /* colNo */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtRTEInfo u_emlrtRTEI = { 4, /* lineNo */
  1,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtRTEInfo v_emlrtRTEI = { 9, /* lineNo */
  1,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtRTEInfo w_emlrtRTEI = { 14,/* lineNo */
  1,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtRTEInfo x_emlrtRTEI = { 18,/* lineNo */
  1,                                   /* colNo */
  "constraintsMEX",                    /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\constraintsMEX.m"/* pName */
};

static emlrtRTEInfo bb_emlrtRTEI = { 28,/* lineNo */
  9,                                   /* colNo */
  "colon",                             /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\ops\\colon.m"/* pName */
};

static emlrtRTEInfo cb_emlrtRTEI = { 52,/* lineNo */
  35,                                  /* colNo */
  "arrayfun",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\datatypes\\arrayfun.m"/* pName */
};

static emlrtRTEInfo db_emlrtRTEI = { 16,/* lineNo */
  12,                                  /* colNo */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pName */
};

static emlrtRTEInfo eb_emlrtRTEI = { 11,/* lineNo */
  1,                                   /* colNo */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pName */
};

static emlrtRTEInfo fb_emlrtRTEI = { 12,/* lineNo */
  1,                                   /* colNo */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pName */
};

static emlrtRTEInfo gb_emlrtRTEI = { 11,/* lineNo */
  69,                                  /* colNo */
  "TrackobjectiveMEX",                 /* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pName */
};

/* Function Definitions */
void anon(const emlrtStack *sp, real_T param_H, real_T param_dt, real_T
          param_state_size, real_T param_Num, const real_T param_X0[4], real_T
          param_model_param_K, const real_T x[66], emxArray_real_T *varargout_1,
          emxArray_real_T *varargout_2)
{
  emlrtStack b_st;
  emlrtStack st;
  emxArray_real_T *PredictX;
  emxArray_real_T *tmpceq;
  real_T x_data[6];
  real_T b_param_dt_idx_0_tmp;
  real_T d;
  real_T param_dt_idx_0_tmp;
  int32_T L;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T i3;
  int32_T i4;
  int32_T i5;
  int32_T loop_ub;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &f_emlrtRSI;

  /*  ���f���\������̐���������v�Z����v���O���� */
  /* constraints only model */
  if (!(param_state_size >= 0.0)) {
    emlrtNonNegativeCheckR2012b(param_state_size, &b_emlrtDCI, &st);
  }

  param_dt_idx_0_tmp = (int32_T)muDoubleScalarFloor(param_state_size);
  if (param_state_size != param_dt_idx_0_tmp) {
    emlrtIntegerCheckR2012b(param_state_size, &emlrtDCI, &st);
  }

  i = varargout_1->size[0] * varargout_1->size[1];
  varargout_1->size[0] = (int32_T)param_state_size;
  emxEnsureCapacity_real_T(&st, varargout_1, i, &u_emlrtRTEI);
  b_param_dt_idx_0_tmp = 4.0 * param_H;
  if (!(b_param_dt_idx_0_tmp >= 0.0)) {
    emlrtNonNegativeCheckR2012b(b_param_dt_idx_0_tmp, &d_emlrtDCI, &st);
  }

  d = (int32_T)muDoubleScalarFloor(b_param_dt_idx_0_tmp);
  if (b_param_dt_idx_0_tmp != d) {
    emlrtIntegerCheckR2012b(b_param_dt_idx_0_tmp, &c_emlrtDCI, &st);
  }

  i = varargout_1->size[0] * varargout_1->size[1];
  varargout_1->size[1] = (int32_T)b_param_dt_idx_0_tmp;
  emxEnsureCapacity_real_T(&st, varargout_1, i, &u_emlrtRTEI);
  if (param_state_size != param_dt_idx_0_tmp) {
    emlrtIntegerCheckR2012b(param_state_size, &h_emlrtDCI, &st);
  }

  if (b_param_dt_idx_0_tmp != d) {
    emlrtIntegerCheckR2012b(b_param_dt_idx_0_tmp, &h_emlrtDCI, &st);
  }

  loop_ub = (int32_T)param_state_size * (int32_T)b_param_dt_idx_0_tmp;
  for (i = 0; i < loop_ub; i++) {
    varargout_1->data[i] = 0.0;
  }

  /* -- MPC�ŗp����\����� X�Ɨ\������ U��ݒ� */
  if (1.0 > param_state_size) {
    i = 0;
  } else {
    if (((int32_T)param_state_size < 1) || ((int32_T)param_state_size > 6)) {
      emlrtDynamicBoundsCheckR2012b((int32_T)param_state_size, 1, 6, &b_emlrtBCI,
        &st);
    }

    i = (int32_T)param_state_size;
  }

  if (param_state_size + 1.0 > 6.0) {
    i1 = 0;
    i2 = -1;
  } else {
    if (((int32_T)param_state_size + 1 < 1) || ((int32_T)param_state_size + 1 >
         6)) {
      emlrtDynamicBoundsCheckR2012b((int32_T)param_state_size + 1, 1, 6,
        &c_emlrtBCI, &st);
    }

    i1 = (int32_T)param_state_size;
    i2 = 5;
  }

  emxInit_real_T(&st, &PredictX, 2, &v_emlrtRTEI, true);

  /* -- ������Ԃ����ݎ����ƈ�v���邱�ƂƏ�ԕ������ɏ]�����Ƃ�ݒ� */
  i3 = PredictX->size[0] * PredictX->size[1];
  PredictX->size[0] = 4;
  emxEnsureCapacity_real_T(&st, PredictX, i3, &v_emlrtRTEI);
  if (!(param_H >= 0.0)) {
    emlrtNonNegativeCheckR2012b(param_H, &f_emlrtDCI, &st);
  }

  i3 = (int32_T)muDoubleScalarFloor(param_H);
  if (param_H != i3) {
    emlrtIntegerCheckR2012b(param_H, &e_emlrtDCI, &st);
  }

  i4 = PredictX->size[0] * PredictX->size[1];
  PredictX->size[1] = (int32_T)param_H;
  emxEnsureCapacity_real_T(&st, PredictX, i4, &v_emlrtRTEI);
  if (param_H != i3) {
    emlrtIntegerCheckR2012b(param_H, &i_emlrtDCI, &st);
  }

  loop_ub = (int32_T)param_H << 2;
  for (i4 = 0; i4 < loop_ub; i4++) {
    PredictX->data[i4] = 0.0;
  }

  i4 = (int32_T)param_H;
  emlrtForLoopVectorCheckR2012b(1.0, 1.0, param_H, mxDOUBLE_CLASS, (int32_T)
    param_H, &i_emlrtRTEI, &st);
  for (L = 0; L < i4; L++) {
    i5 = L + 1;
    if ((i5 < 1) || (i5 > 11)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, 11, &d_emlrtBCI, &st);
    }

    if (i != 4) {
      emlrtSizeEqCheck1DR2012b(i, 4, &emlrtECI, &st);
    }

    b_st.site = &g_emlrtRSI;
    i5 = (i2 - i1) + 1;
    if (1 > i5) {
      emlrtDynamicBoundsCheckR2012b(1, 1, i5, &i_emlrtBCI, &b_st);
    }

    loop_ub = i1 + 6 * L;
    if (2 > i5) {
      emlrtDynamicBoundsCheckR2012b(2, 1, i5, &j_emlrtBCI, &b_st);
    }

    if (1 > i5) {
      emlrtDynamicBoundsCheckR2012b(1, 1, i5, &k_emlrtBCI, &b_st);
    }

    for (i5 = 0; i5 < 4; i5++) {
      x_data[i5] = x[i5 + 6 * L];
    }

    param_dt_idx_0_tmp = x[6 * L + 2];
    b_param_dt_idx_0_tmp = x[6 * L + 3];
    if (((int32_T)(L + 1U) < 1) || ((int32_T)(L + 1U) > PredictX->size[1])) {
      emlrtDynamicBoundsCheckR2012b((int32_T)(L + 1U), 1, PredictX->size[1],
        &f_emlrtBCI, &st);
    }

    PredictX->data[4 * L] = x_data[0] + param_dt * (b_param_dt_idx_0_tmp *
      muDoubleScalarCos(param_dt_idx_0_tmp));
    PredictX->data[4 * L + 1] = x_data[1] + param_dt * (b_param_dt_idx_0_tmp *
      muDoubleScalarSin(param_dt_idx_0_tmp));
    PredictX->data[4 * L + 2] = x_data[2] + param_dt * x[loop_ub + 1];
    PredictX->data[4 * L + 3] = x_data[3] + param_dt * (param_model_param_K *
      x[loop_ub]);
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }

  emxInit_real_T(&st, &tmpceq, 2, &w_emlrtRTEI, true);

  /*  PredictX = cell2mat(arrayfun(@(L) X(:,L) +params.dt*Model(X(:,L),U(:,L),params.model_param) , 1:params.H,'UniformOutput' , false)); */
  i1 = tmpceq->size[0] * tmpceq->size[1];
  tmpceq->size[0] = 4;
  emxEnsureCapacity_real_T(&st, tmpceq, i1, &w_emlrtRTEI);
  if (param_H != i3) {
    emlrtIntegerCheckR2012b(param_H, &g_emlrtDCI, &st);
  }

  i1 = tmpceq->size[0] * tmpceq->size[1];
  i2 = (int32_T)param_H;
  tmpceq->size[1] = i2;
  emxEnsureCapacity_real_T(&st, tmpceq, i1, &w_emlrtRTEI);
  if (i2 != i3) {
    emlrtIntegerCheckR2012b(param_H, &j_emlrtDCI, &st);
  }

  loop_ub = (int32_T)param_H << 2;
  for (i1 = 0; i1 < loop_ub; i1++) {
    tmpceq->data[i1] = 0.0;
  }

  i1 = (int32_T)(param_Num + -1.0);
  emlrtForLoopVectorCheckR2012b(2.0, 1.0, param_Num, mxDOUBLE_CLASS, (int32_T)
    (param_Num + -1.0), &j_emlrtRTEI, &st);
  for (L = 0; L < i1; L++) {
    if ((L + 2 < 1) || (L + 2 > 11)) {
      emlrtDynamicBoundsCheckR2012b(L + 2, 1, 11, &e_emlrtBCI, &st);
    }

    if (i != 4) {
      emlrtSizeEqCheck1DR2012b(i, 4, &b_emlrtECI, &st);
    }

    for (i2 = 0; i2 < 4; i2++) {
      x_data[i2] = x[i2 + 6 * (L + 1)];
    }

    if (((int32_T)(L + 1U) < 1) || ((int32_T)(L + 1U) > PredictX->size[1])) {
      emlrtDynamicBoundsCheckR2012b((int32_T)(L + 1U), 1, PredictX->size[1],
        &g_emlrtBCI, &st);
    }

    if (((int32_T)(L + 1U) < 1) || ((int32_T)(L + 1U) > tmpceq->size[1])) {
      emlrtDynamicBoundsCheckR2012b((int32_T)(L + 1U), 1, tmpceq->size[1],
        &h_emlrtBCI, &st);
    }

    tmpceq->data[4 * L] = x_data[0] - PredictX->data[4 * L];
    i2 = 4 * L + 1;
    tmpceq->data[i2] = x_data[1] - PredictX->data[i2];
    i2 = 4 * L + 2;
    tmpceq->data[i2] = x_data[2] - PredictX->data[i2];
    i2 = 4 * L + 3;
    tmpceq->data[i2] = x_data[3] - PredictX->data[i2];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }

  emxFree_real_T(&PredictX);
  if (i != 4) {
    emlrtSizeEqCheck1DR2012b(i, 4, &c_emlrtECI, &st);
  }

  for (i = 0; i < 4; i++) {
    x_data[i] = x[i];
  }

  i = varargout_2->size[0] * varargout_2->size[1];
  varargout_2->size[0] = 4;
  varargout_2->size[1] = tmpceq->size[1] + 1;
  emxEnsureCapacity_real_T(&st, varargout_2, i, &x_emlrtRTEI);
  varargout_2->data[0] = x_data[0] - param_X0[0];
  varargout_2->data[1] = x_data[1] - param_X0[1];
  varargout_2->data[2] = x_data[2] - param_X0[2];
  varargout_2->data[3] = x_data[3] - param_X0[3];
  loop_ub = tmpceq->size[1];
  for (i = 0; i < loop_ub; i++) {
    i1 = 4 * (i + 1);
    varargout_2->data[i1] = tmpceq->data[4 * i];
    varargout_2->data[i1 + 1] = tmpceq->data[4 * i + 1];
    varargout_2->data[i1 + 2] = tmpceq->data[4 * i + 2];
    varargout_2->data[i1 + 3] = tmpceq->data[4 * i + 3];
  }

  emxFree_real_T(&tmpceq);

  /* -- �\�����͂����͂̏㉺������ɏ]�����Ƃ�ݒ� */
  /*      cineq(:, 1: params.H)	        = cell2mat(arrayfun(@(L) params.U(:, 1) - U(:, L), 1:params.H, 'UniformOutput', false)); */
  /*      cineq(:, params.H+1: 2*params.H)= cell2mat(arrayfun(@(L) U(:, L) - params.U(:, 2), 1:params.H, 'UniformOutput', false)); */
  /*      %-- �\�����͊Ԃł̕ω��ʂ��ω��ʐ���ȉ��ƂȂ邱�Ƃ�ݒ� */
  /*      cineq(:, 2*params.H+1: 3*params.H) = [cell2mat(arrayfun(@(L) -params.S - (U(:, L) - U(:, L-1)) , 2:params.H, 'UniformOutput', false)),  zeros(2,1)]; */
  /*      cineq(:, 3*params.H+1: 4*params.H) = [cell2mat(arrayfun(@(L) (U(:, L) - U(:, L-1)) - params.S  , 2:params.H, 'UniformOutput', false)),  zeros(2,1)]; */
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

real_T b_anon(const emlrtStack *sp, real_T param_H, real_T param_state_size,
              const real_T param_Q[16], const real_T param_R[4], const real_T
              param_Qf[16], const real_T param_Xr[44], const real_T x[66])
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack st;
  emxArray_real_T *stageInput;
  emxArray_real_T *stageState;
  emxArray_real_T *y;
  real_T x_data[66];
  real_T tildeX[44];
  real_T b_tildeX;
  real_T inputExamples_idx_0;
  real_T varargout_1;
  int32_T iv[2];
  int32_T iv1[2];
  int32_T x_size[2];
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T i3;
  int32_T k;
  int32_T loop_ub;
  int32_T n;
  int32_T vlen;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  g_st.prev = &f_st;
  g_st.tls = f_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &j_emlrtRSI;

  /*  ���f���\������̕]���l���v�Z����v���O���� */
  /* -- MPC�ŗp����\����� X�Ɨ\������ U��ݒ� */
  if (1.0 > param_state_size) {
    vlen = 0;
  } else {
    if (param_state_size != (int32_T)muDoubleScalarFloor(param_state_size)) {
      emlrtIntegerCheckR2012b(param_state_size, &m_emlrtDCI, &st);
    }

    if (((int32_T)param_state_size < 1) || ((int32_T)param_state_size > 6)) {
      emlrtDynamicBoundsCheckR2012b((int32_T)param_state_size, 1, 6, &n_emlrtBCI,
        &st);
    }

    vlen = (int32_T)param_state_size;
  }

  if (param_state_size + 1.0 > 6.0) {
    i = 0;
    i1 = 0;
  } else {
    if (param_state_size + 1.0 != (int32_T)muDoubleScalarFloor(param_state_size
         + 1.0)) {
      emlrtIntegerCheckR2012b(param_state_size + 1.0, &l_emlrtDCI, &st);
    }

    if (((int32_T)(param_state_size + 1.0) < 1) || ((int32_T)(param_state_size +
          1.0) > 6)) {
      emlrtDynamicBoundsCheckR2012b((int32_T)(param_state_size + 1.0), 1, 6,
        &m_emlrtBCI, &st);
    }

    i = (int32_T)(param_state_size + 1.0) - 1;
    i1 = 6;
  }

  /* -- ��ԋy�ѓ��͂ɑ΂���ڕW��Ԃ�ڕW���͂Ƃ̌덷���v�Z */
  iv[0] = vlen;
  iv[1] = 11;
  iv1[0] = 4;
  iv1[1] = 11;
  if (vlen != 4) {
    emlrtSizeEqCheckNDR2012b(&iv[0], &iv1[0], &e_emlrtECI, &st);
  }

  for (i2 = 0; i2 < 11; i2++) {
    for (i3 = 0; i3 < 4; i3++) {
      x_data[i3 + 4 * i2] = x[i3 + 6 * i2];
    }
  }

  for (i2 = 0; i2 < 44; i2++) {
    tildeX[i2] = x_data[i2] - param_Xr[i2];
  }

  /*      tildeU = U - params.Ur; */
  /* -- ��ԋy�ѓ��͂̃X�e�[�W�R�X�g���v�Z */
  emxInit_real_T(&st, &y, 2, &gb_emlrtRTEI, true);
  if (muDoubleScalarIsNaN(param_H)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &bb_emlrtRTEI);
    y->data[0] = rtNaN;
  } else if (param_H < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (muDoubleScalarIsInf(param_H) && (1.0 == param_H)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &bb_emlrtRTEI);
    y->data[0] = rtNaN;
  } else {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    vlen = (int32_T)muDoubleScalarFloor(param_H - 1.0);
    y->size[1] = vlen + 1;
    emxEnsureCapacity_real_T(&st, y, i2, &bb_emlrtRTEI);
    for (i2 = 0; i2 <= vlen; i2++) {
      y->data[i2] = (real_T)i2 + 1.0;
    }
  }

  b_st.site = &k_emlrtRSI;
  c_st.site = &n_emlrtRSI;
  d_st.site = &o_emlrtRSI;
  if (y->size[1] == 0) {
    inputExamples_idx_0 = 0.0;
  } else {
    inputExamples_idx_0 = y->data[0];
  }

  e_st.site = &r_emlrtRSI;
  f_st.site = &e_emlrtRSI;
  if (inputExamples_idx_0 != (int32_T)muDoubleScalarFloor(inputExamples_idx_0))
  {
    emlrtIntegerCheckR2012b(inputExamples_idx_0, &k_emlrtDCI, &f_st);
  }

  if (((int32_T)inputExamples_idx_0 < 1) || ((int32_T)inputExamples_idx_0 > 11))
  {
    emlrtDynamicBoundsCheckR2012b((int32_T)inputExamples_idx_0, 1, 11,
      &l_emlrtBCI, &f_st);
  }

  emxInit_real_T(&f_st, &stageState, 2, &eb_emlrtRTEI, true);
  i2 = stageState->size[0] * stageState->size[1];
  stageState->size[0] = 1;
  stageState->size[1] = y->size[1];
  emxEnsureCapacity_real_T(&c_st, stageState, i2, &cb_emlrtRTEI);
  n = y->size[1];
  d_st.site = &p_emlrtRSI;
  if ((1 <= y->size[1]) && (y->size[1] > 2147483646)) {
    e_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&e_st);
  }

  for (k = 0; k < n; k++) {
    d_st.site = &q_emlrtRSI;
    e_st.site = &e_emlrtRSI;
    inputExamples_idx_0 = y->data[k];
    if (inputExamples_idx_0 != (int32_T)muDoubleScalarFloor(inputExamples_idx_0))
    {
      emlrtIntegerCheckR2012b(inputExamples_idx_0, &k_emlrtDCI, &e_st);
    }

    if (((int32_T)inputExamples_idx_0 < 1) || ((int32_T)inputExamples_idx_0 > 11))
    {
      emlrtDynamicBoundsCheckR2012b((int32_T)inputExamples_idx_0, 1, 11,
        &l_emlrtBCI, &e_st);
    }

    b_tildeX = 0.0;
    i2 = ((int32_T)inputExamples_idx_0 - 1) << 2;
    for (i3 = 0; i3 < 4; i3++) {
      vlen = i3 << 2;
      b_tildeX += (((tildeX[i2] * param_Q[vlen] + tildeX[i2 + 1] * param_Q[vlen
                     + 1]) + tildeX[i2 + 2] * param_Q[vlen + 2]) + tildeX[i2 + 3]
                   * param_Q[vlen + 3]) * tildeX[i3 + i2];
    }

    stageState->data[k] = b_tildeX;
  }

  if (muDoubleScalarIsNaN(param_H)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &bb_emlrtRTEI);
    y->data[0] = rtNaN;
  } else if (param_H < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (muDoubleScalarIsInf(param_H) && (1.0 == param_H)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &bb_emlrtRTEI);
    y->data[0] = rtNaN;
  } else {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)muDoubleScalarFloor(param_H - 1.0) + 1;
    emxEnsureCapacity_real_T(&st, y, i2, &bb_emlrtRTEI);
    vlen = (int32_T)muDoubleScalarFloor(param_H - 1.0);
    for (i2 = 0; i2 <= vlen; i2++) {
      y->data[i2] = (real_T)i2 + 1.0;
    }
  }

  b_st.site = &l_emlrtRSI;
  c_st.site = &n_emlrtRSI;
  d_st.site = &o_emlrtRSI;
  if (y->size[1] == 0) {
    inputExamples_idx_0 = 0.0;
  } else {
    inputExamples_idx_0 = y->data[0];
  }

  e_st.site = &r_emlrtRSI;
  vlen = i1 - i;
  x_size[0] = vlen;
  x_size[1] = 11;
  for (i1 = 0; i1 < 11; i1++) {
    for (i2 = 0; i2 < vlen; i2++) {
      x_data[i2 + vlen * i1] = x[(i + i2) + 6 * i1];
    }
  }

  emxInit_real_T(&e_st, &stageInput, 2, &fb_emlrtRTEI, true);
  f_st.site = &e_emlrtRSI;
  c_anon(&f_st, x_data, x_size, param_R, inputExamples_idx_0);
  i1 = stageInput->size[0] * stageInput->size[1];
  stageInput->size[0] = 1;
  stageInput->size[1] = y->size[1];
  emxEnsureCapacity_real_T(&c_st, stageInput, i1, &cb_emlrtRTEI);
  n = y->size[1];
  d_st.site = &p_emlrtRSI;
  if ((1 <= y->size[1]) && (y->size[1] > 2147483646)) {
    e_st.site = &s_emlrtRSI;
    check_forloop_overflow_error(&e_st);
  }

  if (0 <= y->size[1] - 1) {
    loop_ub = vlen;
  }

  if (0 <= n - 1) {
    x_size[0] = vlen;
    x_size[1] = 11;
    for (i1 = 0; i1 < 11; i1++) {
      for (i2 = 0; i2 < loop_ub; i2++) {
        x_data[i2 + vlen * i1] = x[(i + i2) + 6 * i1];
      }
    }
  }

  for (k = 0; k < n; k++) {
    d_st.site = &q_emlrtRSI;
    e_st.site = &e_emlrtRSI;
    inputExamples_idx_0 = c_anon(&e_st, x_data, x_size, param_R, y->data[k]);
    stageInput->data[k] = inputExamples_idx_0;
  }

  emxFree_real_T(&y);

  /* -- ��Ԃ̏I�[�R�X�g���v�Z */
  /* -- �]���l�v�Z */
  emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])stageState->size, *(int32_T (*)[2])
    stageInput->size, &d_emlrtECI, &st);
  b_st.site = &m_emlrtRSI;
  i = stageState->size[0] * stageState->size[1];
  i1 = stageState->size[0] * stageState->size[1];
  stageState->size[0] = 1;
  emxEnsureCapacity_real_T(&b_st, stageState, i1, &db_emlrtRTEI);
  vlen = i - 1;
  for (i = 0; i <= vlen; i++) {
    stageState->data[i] += stageInput->data[i];
  }

  emxFree_real_T(&stageInput);
  c_st.site = &v_emlrtRSI;
  d_st.site = &w_emlrtRSI;
  vlen = stageState->size[1];
  if (stageState->size[1] == 0) {
    inputExamples_idx_0 = 0.0;
  } else {
    e_st.site = &x_emlrtRSI;
    inputExamples_idx_0 = stageState->data[0];
    f_st.site = &y_emlrtRSI;
    if ((2 <= stageState->size[1]) && (stageState->size[1] > 2147483646)) {
      g_st.site = &s_emlrtRSI;
      check_forloop_overflow_error(&g_st);
    }

    for (k = 2; k <= vlen; k++) {
      inputExamples_idx_0 += stageState->data[k - 1];
    }
  }

  emxFree_real_T(&stageState);
  b_tildeX = 0.0;
  for (i = 0; i < 4; i++) {
    i1 = i << 2;
    b_tildeX += (((tildeX[40] * param_Qf[i1] + tildeX[41] * param_Qf[i1 + 1]) +
                  tildeX[42] * param_Qf[i1 + 2]) + tildeX[43] * param_Qf[i1 + 3])
      * tildeX[i + 40];
  }

  varargout_1 = inputExamples_idx_0 + b_tildeX;
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
  return varargout_1;
}

void fminconMEX_Trackobjective(const emlrtStack *sp, const real_T x0[66], const
  struct0_T *param, real_T x[66], real_T *fval, real_T *exitflag, struct2_T
  *output, struct3_T *lambda, real_T grad[66], real_T hessian[4356])
{
  emlrtStack st;
  struct0_T evalfunc_tunableEnvironment[1];
  int32_T k;
  boolean_T b_x[2];
  boolean_T exitg1;
  boolean_T y;
  st.prev = sp;
  st.tls = sp->tls;

  /*  ------------------------------------------------------------------------- */
  /* Author Sota Wada; Date 2021_10_19 */
  /*  ------------------------------------------------------------------------- */
  b_x[0] = (param->dis.size[0] >= 1);
  b_x[1] = (param->dis.size[1] >= 1);
  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!b_x[k]) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2018a(sp, &emlrtRTEI,
      "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
  }

  b_x[0] = (param->dis.size[0] <= 1);
  b_x[1] = (param->dis.size[1] <= 629);
  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!b_x[k]) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2018a(sp, &b_emlrtRTEI,
      "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
  }

  b_x[0] = (param->alpha.size[0] >= 1);
  b_x[1] = (param->alpha.size[1] >= 1);
  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!b_x[k]) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2018a(sp, &c_emlrtRTEI,
      "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
  }

  b_x[0] = (param->alpha.size[0] <= 1);
  b_x[1] = (param->alpha.size[1] <= 629);
  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!b_x[k]) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2018a(sp, &d_emlrtRTEI,
      "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
  }

  b_x[0] = (param->phi.size[0] >= 1);
  b_x[1] = (param->phi.size[1] >= 1);
  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!b_x[k]) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2018a(sp, &e_emlrtRTEI,
      "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
  }

  b_x[0] = (param->phi.size[0] <= 1);
  b_x[1] = (param->phi.size[1] <= 629);
  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 2)) {
    if (!b_x[k]) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2018a(sp, &f_emlrtRTEI,
      "Coder:builtins:AssertionFailed", "Coder:builtins:AssertionFailed", 0);
  }

  /*  �ő唽����, �]���֐��̍ő�l, ����̋��e�덷, �œK���̋��e�덷, �X�e�b�v�T�C�Y�̉���, �]���֐��̌��z�ݒ�, ��������̌��z�ݒ�, SQP�A���S���Y���̎w�� */
  evalfunc_tunableEnvironment[0] = *param;
  st.site = &emlrtRSI;
  fmincon(&st, evalfunc_tunableEnvironment, x0, evalfunc_tunableEnvironment, x,
          fval, exitflag, &output->iterations, &output->funcCount,
          output->algorithm, &output->constrviolation, &output->stepsize,
          &output->lssteplength, &output->firstorderopt, lambda, grad, hessian);
}

/* End of code generation (fminconMEX_Trackobjective.c) */
