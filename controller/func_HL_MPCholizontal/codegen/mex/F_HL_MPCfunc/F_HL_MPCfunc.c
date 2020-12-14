/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * F_HL_MPCfunc.c
 *
 * Code generation for function 'F_HL_MPCfunc'
 *
 */

/* Include files */
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "F_HL_MPCfunc_emxutil.h"
#include "arrayfun.h"
#include "autoCons.h"
#include "autoEval.h"
#include "det.h"
#include "eml_int_forloop_overflow_check.h"
#include "fmincon.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 25,    /* lineNo */
  "F_HL_MPCfunc",                      /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 21,  /* lineNo */
  "@(x) constraints(x, MPCparam)",     /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 87,  /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo g_emlrtRSI = { 88,  /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 89,  /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo i_emlrtRSI = { 90,  /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo j_emlrtRSI = { 97,  /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo k_emlrtRSI = { 98,  /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo l_emlrtRSI = { 99,  /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 100, /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo n_emlrtRSI = { 111, /* lineNo */
  "constraints",                       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo u_emlrtRSI = { 22,  /* lineNo */
  "cat",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pathName */
};

static emlrtRSInfo v_emlrtRSI = { 102, /* lineNo */
  "cat_impl",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pathName */
};

static emlrtRSInfo w_emlrtRSI = { 16,  /* lineNo */
  "min",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\min.m"/* pathName */
};

static emlrtRSInfo x_emlrtRSI = { 40,  /* lineNo */
  "minOrMax",                          /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax.m"/* pathName */
};

static emlrtRSInfo y_emlrtRSI = { 90,  /* lineNo */
  "minimum",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\minOrMax.m"/* pathName */
};

static emlrtRSInfo ab_emlrtRSI = { 165,/* lineNo */
  "unaryMinOrMax",                     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo bb_emlrtRSI = { 324,/* lineNo */
  "unaryMinOrMaxDispatch",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo cb_emlrtRSI = { 392,/* lineNo */
  "minOrMax2D",                        /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo db_emlrtRSI = { 474,/* lineNo */
  "minOrMax2DColumnMajorDim1",         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pathName */
};

static emlrtRSInfo ce_emlrtRSI = { 20, /* lineNo */
  "@(x) objective(x, MPCparam)",       /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo de_emlrtRSI = { 42, /* lineNo */
  "objective",                         /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtRSInfo ee_emlrtRSI = { 47, /* lineNo */
  "objective",                         /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

static emlrtMCInfo emlrtMCI = { 26,    /* lineNo */
  13,                                  /* colNo */
  "F_HL_MPCfunc",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtDCInfo emlrtDCI = { 103,   /* lineNo */
  61,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { 1,   /* iFirst */
  2,                                   /* iLast */
  103,                                 /* lineNo */
  61,                                  /* colNo */
  "param.wall_width_x",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 103, /* lineNo */
  36,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { 1,   /* iFirst */
  2,                                   /* iLast */
  103,                                 /* lineNo */
  36,                                  /* colNo */
  "param.wall_width_x",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo c_emlrtDCI = { 94,  /* lineNo */
  54,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  94,                                  /* lineNo */
  54,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = { 75,  /* lineNo */
  21,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { 1,   /* iFirst */
  12,                                  /* iLast */
  75,                                  /* lineNo */
  21,                                  /* colNo */
  "x",                                 /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo e_emlrtDCI = { 78,  /* lineNo */
  42,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  78,                                  /* lineNo */
  42,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo f_emlrtDCI = { 79,  /* lineNo */
  41,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  79,                                  /* lineNo */
  41,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo g_emlrtDCI = { 80,  /* lineNo */
  42,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  80,                                  /* lineNo */
  42,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo h_emlrtDCI = { 81,  /* lineNo */
  44,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo m_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  81,                                  /* lineNo */
  44,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo i_emlrtDCI = { 82,  /* lineNo */
  44,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  82,                                  /* lineNo */
  44,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo j_emlrtDCI = { 83,  /* lineNo */
  43,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  83,                                  /* lineNo */
  43,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo k_emlrtDCI = { 84,  /* lineNo */
  44,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  84,                                  /* lineNo */
  44,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo l_emlrtDCI = { 85,  /* lineNo */
  46,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = { 1,   /* iFirst */
  3,                                   /* iLast */
  85,                                  /* lineNo */
  46,                                  /* colNo */
  "param.sectionpoint",                /* aName */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo emlrtECI = { 2,     /* nDims */
  94,                                  /* lineNo */
  54,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtECInfo b_emlrtECI = { 2,   /* nDims */
  102,                                 /* lineNo */
  18,                                  /* colNo */
  "constraints",                       /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtRTEInfo c_emlrtRTEI = { 283,/* lineNo */
  27,                                  /* colNo */
  "check_non_axis_size",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pName */
};

static emlrtDCInfo m_emlrtDCI = { 87,  /* lineNo */
  85,                                  /* colNo */
  "@(L) abs(det([[f_prev_sp]-[f_now_sp];[param.front(1,L),param.front(2,L)]-[f_now_sp]]))/norm([f_prev_sp]-[f_now_sp])",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = { 1,   /* iFirst */
  11,                                  /* iLast */
  87,                                  /* lineNo */
  85,                                  /* colNo */
  "param.front",                       /* aName */
  "@(L) abs(det([[f_prev_sp]-[f_now_sp];[param.front(1,L),param.front(2,L)]-[f_now_sp]]))/norm([f_prev_sp]-[f_now_sp])",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo s_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  97,                                  /* lineNo */
  67,                                  /* colNo */
  "X",                                 /* aName */
  "@(L) abs(det([[prev_sp]-[now_sp];[X(1,L),X(5,L)]-[now_sp]]))/norm([prev_sp]-[now_sp])",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo n_emlrtDCI = { 97,  /* lineNo */
  69,                                  /* colNo */
  "@(L) abs(det([[prev_sp]-[now_sp];[X(1,L),X(5,L)]-[now_sp]]))/norm([prev_sp]-[now_sp])",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo t_emlrtBCI = { 1,   /* iFirst */
  11,                                  /* iLast */
  97,                                  /* lineNo */
  69,                                  /* colNo */
  "X",                                 /* aName */
  "@(L) abs(det([[prev_sp]-[now_sp];[X(1,L),X(5,L)]-[now_sp]]))/norm([prev_sp]-[now_sp])",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo u_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  97,                                  /* lineNo */
  74,                                  /* colNo */
  "X",                                 /* aName */
  "@(L) abs(det([[prev_sp]-[now_sp];[X(1,L),X(5,L)]-[now_sp]]))/norm([prev_sp]-[now_sp])",/* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo o_emlrtDCI = { 39,  /* lineNo */
  21,                                  /* colNo */
  "objective",                         /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo v_emlrtBCI = { 1,   /* iFirst */
  12,                                  /* iLast */
  39,                                  /* lineNo */
  21,                                  /* colNo */
  "x",                                 /* aName */
  "objective",                         /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo m_emlrtRTEI = { 22,/* lineNo */
  5,                                   /* colNo */
  "cat",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\cat.m"/* pName */
};

static emlrtRTEInfo n_emlrtRTEI = { 468,/* lineNo */
  5,                                   /* colNo */
  "unaryMinOrMax",                     /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\unaryMinOrMax.m"/* pName */
};

static emlrtRTEInfo o_emlrtRTEI = { 17,/* lineNo */
  5,                                   /* colNo */
  "min",                               /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\min.m"/* pName */
};

static emlrtRTEInfo p_emlrtRTEI = { 87,/* lineNo */
  13,                                  /* colNo */
  "F_HL_MPCfunc",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtRTEInfo q_emlrtRTEI = { 88,/* lineNo */
  13,                                  /* colNo */
  "F_HL_MPCfunc",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtRTEInfo r_emlrtRTEI = { 89,/* lineNo */
  13,                                  /* colNo */
  "F_HL_MPCfunc",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtRTEInfo s_emlrtRTEI = { 87,/* lineNo */
  149,                                 /* colNo */
  "F_HL_MPCfunc",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtRTEInfo t_emlrtRTEI = { 90,/* lineNo */
  28,                                  /* colNo */
  "F_HL_MPCfunc",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtRTEInfo u_emlrtRTEI = { 21,/* lineNo */
  25,                                  /* colNo */
  "F_HL_MPCfunc",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pName */
};

static emlrtRSInfo wk_emlrtRSI = { 26, /* lineNo */
  "F_HL_MPCfunc",                      /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\F_HL_MPCfunc.m"/* pathName */
};

/* Function Declarations */
static void disp(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location);

/* Function Definitions */
static void disp(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(sp, 0, NULL, 1, &pArray, "disp", true, location);
}

void F_HL_MPCfunc(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, const
                  struct0_T *MPCparam, const real_T MPCprevious_variables[110],
                  const real_T MPCslack[22], real_T funcresult[132])
{
  struct0_T MPCobjective_tunableEnvironment[1];
  int32_T i;
  real_T b_MPCprevious_variables[132];
  real_T unusedU0;
  real_T exitflag;
  real_T expl_temp;
  real_T b_expl_temp;
  char_T c_expl_temp[3];
  real_T d_expl_temp;
  real_T e_expl_temp;
  real_T f_expl_temp;
  real_T g_expl_temp;
  d_struct_T unusedU2;
  real_T unusedU3[132];
  const mxArray *y;
  int32_T MPCprevious_variables_tmp;
  const mxArray *m;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;

  /* options_setting */
  /*  options.Display                = 'none'; */
  /*  評価関数の最大値 */
  /*  最大反復回数 */
  /*  options.StepTolerance          = optimoptions(options,'StepTolerance',1.e-12);%xに関する終了許容誤差 */
  /* 制約違反に対する許容誤差 */
  /*  options    = optimoptions(options,'OptimalityTolerance',1.e-12);%1 次の最適性に関する終了許容誤差。 */
  /*  options                = optimoptions(options,'PlotFcn',[]); */
  /*  SQPアルゴリズムの指定      これが一番最後にいないとcodegen時にエラーが吐かれる */
  /* MPC */
  MPCobjective_tunableEnvironment[0] = *MPCparam;

  /*  評価関数 */
  /*  制約条件 */
  /*      problem.x0		  = [previous_vurtualstate;previous_input{N}]; % 初期状態 */
  /* [var, fval, exitflag, output, lambda, grad, hessian] = fmincon(problem); */
  for (i = 0; i < 11; i++) {
    memcpy(&b_MPCprevious_variables[i * 12], &MPCprevious_variables[i * 10], 10U
           * sizeof(real_T));
    MPCprevious_variables_tmp = i << 1;
    b_MPCprevious_variables[12 * i + 10] = MPCslack[MPCprevious_variables_tmp];
    b_MPCprevious_variables[12 * i + 11] = MPCslack[MPCprevious_variables_tmp +
      1];
  }

  st.site = &emlrtRSI;
  fmincon(SD, &st, MPCobjective_tunableEnvironment, b_MPCprevious_variables,
          MPCobjective_tunableEnvironment, funcresult, &unusedU0, &exitflag,
          &expl_temp, &b_expl_temp, c_expl_temp, &d_expl_temp, &e_expl_temp,
          &f_expl_temp, &g_expl_temp, &unusedU2, unusedU3, SD->f4.unusedU4);
  y = NULL;
  m = emlrtCreateDoubleScalar(exitflag);
  emlrtAssign(&y, m);
  st.site = &wk_emlrtRSI;
  disp(&st, y, &emlrtMCI);

  /*              disp(output); */
}

void __anon_fcn(F_HL_MPCfuncStackData *SD, const emlrtStack *sp, real_T
                MPCparam_state_size, real_T MPCparam_Num, real_T MPCparam_Slew,
                const real_T MPCparam_D_lim[2], const real_T MPCparam_r_limit[2],
                const real_T MPCparam_A[64], const real_T MPCparam_B[16], const
                real_T MPCparam_wall_width_y[4], const real_T
                MPCparam_wall_width_x[4], const real_T MPCparam_sectionpoint[6],
                const real_T MPCparam_Section_change[4], const real_T
                MPCparam_S_front[4], const real_T MPCparam_front[22], const
                real_T MPCparam_behind[22], const real_T MPCparam_X0[8], const
                real_T x[132], real_T varargout_1[176], real_T varargout_2[88])
{
  int32_T loop_ub;
  int32_T i;
  real_T this_tunableEnvironment_f1[2];
  int32_T i1;
  int32_T i2;
  real_T this_tunableEnvironment_f2[2];
  real_T b_this_tunableEnvironment_f1[2];
  int32_T i3;
  int32_T n;
  real_T b_this_tunableEnvironment_f2[2];
  int32_T this_tunableEnvironment_f2_tmp;
  real_T c_this_tunableEnvironment_f2[2];
  emxArray_real_T *y;
  int32_T b_loop_ub;
  emxArray_real_T *f_prev_r;
  emxArray_real_T *f_now_r;
  emxArray_real_T *f_next_r;
  emxArray_real_T *result;
  boolean_T b;
  emxArray_int8_T *idx;
  real_T a;
  real_T b_b;
  int32_T iv[2];
  int32_T this_tunableEnvironment_f3_size[2];
  real_T param_Sectionconect[22];
  real_T this_tunableEnvironment_f3_data[132];
  real_T SN[11];
  real_T param_wall_width_xx[22];
  real_T param_wall_width_yy[22];
  real_T gceq[11616];
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack h_st;
  emlrtStack i_st;
  emlrtStack j_st;
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
  h_st.prev = &g_st;
  h_st.tls = g_st.tls;
  i_st.prev = &h_st;
  i_st.tls = h_st.tls;
  j_st.prev = &i_st;
  j_st.tls = i_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  st.site = &e_emlrtRSI;

  /* ceq等式制約，cineq不等式制約， */
  if (1.0 > MPCparam_state_size) {
    loop_ub = 0;
  } else {
    if (MPCparam_state_size != (int32_T)muDoubleScalarFloor(MPCparam_state_size))
    {
      emlrtIntegerCheckR2012b(MPCparam_state_size, &d_emlrtDCI, &st);
    }

    loop_ub = (int32_T)MPCparam_state_size;
    if ((loop_ub < 1) || (loop_ub > 12)) {
      emlrtDynamicBoundsCheckR2012b(loop_ub, 1, 12, &i_emlrtBCI, &st);
    }
  }

  /*  モデル予測制御の制約条件を計算するプログラム */
  /* セクション点の定義 */
  if (MPCparam_Section_change[0] != (int32_T)muDoubleScalarFloor
      (MPCparam_Section_change[0])) {
    emlrtIntegerCheckR2012b(MPCparam_Section_change[0], &e_emlrtDCI, &st);
  }

  i = (int32_T)MPCparam_Section_change[0];
  if ((i < 1) || (i > 3)) {
    emlrtDynamicBoundsCheckR2012b(i, 1, 3, &j_emlrtBCI, &st);
  }

  this_tunableEnvironment_f1[0] = MPCparam_sectionpoint[i - 1];
  this_tunableEnvironment_f1[1] = MPCparam_sectionpoint[i + 2];

  /* previous section */
  if (MPCparam_Section_change[1] != (int32_T)muDoubleScalarFloor
      (MPCparam_Section_change[1])) {
    emlrtIntegerCheckR2012b(MPCparam_Section_change[1], &f_emlrtDCI, &st);
  }

  i = (int32_T)MPCparam_Section_change[1];
  if ((i < 1) || (i > 3)) {
    emlrtDynamicBoundsCheckR2012b(i, 1, 3, &k_emlrtBCI, &st);
  }

  /* now section */
  if (MPCparam_Section_change[2] != (int32_T)muDoubleScalarFloor
      (MPCparam_Section_change[2])) {
    emlrtIntegerCheckR2012b(MPCparam_Section_change[2], &g_emlrtDCI, &st);
  }

  i1 = (int32_T)MPCparam_Section_change[2];
  if ((i1 < 1) || (i1 > 3)) {
    emlrtDynamicBoundsCheckR2012b(i1, 1, 3, &l_emlrtBCI, &st);
  }

  /* next section */
  if (MPCparam_Section_change[3] != (int32_T)muDoubleScalarFloor
      (MPCparam_Section_change[3])) {
    emlrtIntegerCheckR2012b(MPCparam_Section_change[3], &h_emlrtDCI, &st);
  }

  i2 = (int32_T)MPCparam_Section_change[3];
  if ((i2 < 1) || (i2 > 3)) {
    emlrtDynamicBoundsCheckR2012b(i2, 1, 3, &m_emlrtBCI, &st);
  }

  this_tunableEnvironment_f2[0] = MPCparam_sectionpoint[i2 - 1];
  this_tunableEnvironment_f2[1] = MPCparam_sectionpoint[i2 + 2];

  /* nextnext section　point */
  if (MPCparam_S_front[0] != (int32_T)muDoubleScalarFloor(MPCparam_S_front[0]))
  {
    emlrtIntegerCheckR2012b(MPCparam_S_front[0], &i_emlrtDCI, &st);
  }

  i2 = (int32_T)MPCparam_S_front[0];
  if ((i2 < 1) || (i2 > 3)) {
    emlrtDynamicBoundsCheckR2012b(i2, 1, 3, &n_emlrtBCI, &st);
  }

  b_this_tunableEnvironment_f1[0] = MPCparam_sectionpoint[i2 - 1];
  b_this_tunableEnvironment_f1[1] = MPCparam_sectionpoint[i2 + 2];

  /* previous section */
  if (MPCparam_S_front[1] != (int32_T)muDoubleScalarFloor(MPCparam_S_front[1]))
  {
    emlrtIntegerCheckR2012b(MPCparam_S_front[1], &j_emlrtDCI, &st);
  }

  i2 = (int32_T)MPCparam_S_front[1];
  if ((i2 < 1) || (i2 > 3)) {
    emlrtDynamicBoundsCheckR2012b(i2, 1, 3, &o_emlrtBCI, &st);
  }

  /* now section */
  if (MPCparam_S_front[2] != (int32_T)muDoubleScalarFloor(MPCparam_S_front[2]))
  {
    emlrtIntegerCheckR2012b(MPCparam_S_front[2], &k_emlrtDCI, &st);
  }

  i3 = (int32_T)MPCparam_S_front[2];
  if ((i3 < 1) || (i3 > 3)) {
    emlrtDynamicBoundsCheckR2012b(i3, 1, 3, &p_emlrtBCI, &st);
  }

  /* next section */
  if (MPCparam_S_front[3] != (int32_T)muDoubleScalarFloor(MPCparam_S_front[3]))
  {
    emlrtIntegerCheckR2012b(MPCparam_S_front[3], &l_emlrtDCI, &st);
  }

  n = (int32_T)MPCparam_S_front[3];
  if ((n < 1) || (n > 3)) {
    emlrtDynamicBoundsCheckR2012b(n, 1, 3, &q_emlrtBCI, &st);
  }

  /* nextnext section　point */
  /*      %前機体のセクション判別 */
  b_this_tunableEnvironment_f2[0] = MPCparam_sectionpoint[n - 1];
  this_tunableEnvironment_f2_tmp = i2 - 1;
  c_this_tunableEnvironment_f2[0] =
    MPCparam_sectionpoint[this_tunableEnvironment_f2_tmp];
  b_this_tunableEnvironment_f2[1] = MPCparam_sectionpoint[n + 2];
  n = i2 + 2;
  c_this_tunableEnvironment_f2[1] = MPCparam_sectionpoint[n];
  emxInit_real_T(&st, &y, 2, &s_emlrtRTEI, true);
  if (muDoubleScalarIsNaN(MPCparam_Num)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else if (MPCparam_Num < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (muDoubleScalarIsInf(MPCparam_Num) && (1.0 == MPCparam_Num)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    b_loop_ub = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0);
    y->size[1] = b_loop_ub + 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    for (i2 = 0; i2 <= b_loop_ub; i2++) {
      y->data[i2] = (real_T)i2 + 1.0;
    }
  }

  emxInit_real_T(&st, &f_prev_r, 2, &p_emlrtRTEI, true);
  b_st.site = &f_emlrtRSI;
  arrayfun(&b_st, b_this_tunableEnvironment_f1, c_this_tunableEnvironment_f2,
           MPCparam_front, y, f_prev_r);
  b_this_tunableEnvironment_f1[0] =
    MPCparam_sectionpoint[this_tunableEnvironment_f2_tmp];
  this_tunableEnvironment_f2_tmp = i3 - 1;
  c_this_tunableEnvironment_f2[0] =
    MPCparam_sectionpoint[this_tunableEnvironment_f2_tmp];
  b_this_tunableEnvironment_f1[1] = MPCparam_sectionpoint[n];
  n = i3 + 2;
  c_this_tunableEnvironment_f2[1] = MPCparam_sectionpoint[n];
  if (muDoubleScalarIsNaN(MPCparam_Num)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else if (MPCparam_Num < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (muDoubleScalarIsInf(MPCparam_Num) && (1.0 == MPCparam_Num)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0) + 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    b_loop_ub = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0);
    for (i2 = 0; i2 <= b_loop_ub; i2++) {
      y->data[i2] = (real_T)i2 + 1.0;
    }
  }

  emxInit_real_T(&st, &f_now_r, 2, &q_emlrtRTEI, true);
  b_st.site = &g_emlrtRSI;
  arrayfun(&b_st, b_this_tunableEnvironment_f1, c_this_tunableEnvironment_f2,
           MPCparam_front, y, f_now_r);
  b_this_tunableEnvironment_f1[0] =
    MPCparam_sectionpoint[this_tunableEnvironment_f2_tmp];
  b_this_tunableEnvironment_f1[1] = MPCparam_sectionpoint[n];
  if (muDoubleScalarIsNaN(MPCparam_Num)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else if (MPCparam_Num < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (muDoubleScalarIsInf(MPCparam_Num) && (1.0 == MPCparam_Num)) {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else {
    i2 = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0) + 1;
    emxEnsureCapacity_real_T(&st, y, i2, &l_emlrtRTEI);
    b_loop_ub = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0);
    for (i2 = 0; i2 <= b_loop_ub; i2++) {
      y->data[i2] = (real_T)i2 + 1.0;
    }
  }

  emxInit_real_T(&st, &f_next_r, 2, &r_emlrtRTEI, true);
  emxInit_real_T(&st, &result, 2, &t_emlrtRTEI, true);
  b_st.site = &h_emlrtRSI;
  arrayfun(&b_st, b_this_tunableEnvironment_f1, b_this_tunableEnvironment_f2,
           MPCparam_front, y, f_next_r);
  b_st.site = &i_emlrtRSI;
  c_st.site = &u_emlrtRSI;
  d_st.site = &v_emlrtRSI;
  b = (f_now_r->size[1] == f_prev_r->size[1]);
  if (!b) {
    emlrtErrorWithMessageIdR2018a(&d_st, &c_emlrtRTEI,
      "MATLAB:catenate:matrixDimensionMismatch",
      "MATLAB:catenate:matrixDimensionMismatch", 0);
  }

  b = ((f_next_r->size[1] == f_prev_r->size[1]) && b);
  if (!b) {
    emlrtErrorWithMessageIdR2018a(&d_st, &c_emlrtRTEI,
      "MATLAB:catenate:matrixDimensionMismatch",
      "MATLAB:catenate:matrixDimensionMismatch", 0);
  }

  i2 = result->size[0] * result->size[1];
  result->size[0] = 3;
  result->size[1] = f_prev_r->size[1];
  emxEnsureCapacity_real_T(&c_st, result, i2, &m_emlrtRTEI);
  b_loop_ub = f_prev_r->size[1];
  for (i2 = 0; i2 < b_loop_ub; i2++) {
    result->data[3 * i2] = f_prev_r->data[i2];
  }

  b_loop_ub = f_now_r->size[1];
  for (i2 = 0; i2 < b_loop_ub; i2++) {
    result->data[3 * i2 + 1] = f_now_r->data[i2];
  }

  b_loop_ub = f_next_r->size[1];
  for (i2 = 0; i2 < b_loop_ub; i2++) {
    result->data[3 * i2 + 2] = f_next_r->data[i2];
  }

  emxInit_int8_T(&c_st, &idx, 2, &u_emlrtRTEI, true);
  b_st.site = &i_emlrtRSI;
  c_st.site = &w_emlrtRSI;
  d_st.site = &x_emlrtRSI;
  e_st.site = &y_emlrtRSI;
  f_st.site = &ab_emlrtRSI;
  g_st.site = &bb_emlrtRSI;
  h_st.site = &cb_emlrtRSI;
  n = result->size[1];
  i2 = idx->size[0] * idx->size[1];
  idx->size[0] = 1;
  idx->size[1] = result->size[1];
  emxEnsureCapacity_int8_T(&h_st, idx, i2, &n_emlrtRTEI);
  b_loop_ub = result->size[1];
  for (i2 = 0; i2 < b_loop_ub; i2++) {
    idx->data[i2] = 1;
  }

  if (result->size[1] >= 1) {
    i_st.site = &db_emlrtRSI;
    if (result->size[1] > 2147483646) {
      j_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&j_st);
    }

    for (this_tunableEnvironment_f2_tmp = 0; this_tunableEnvironment_f2_tmp < n;
         this_tunableEnvironment_f2_tmp++) {
      a = result->data[3 * this_tunableEnvironment_f2_tmp];
      b_b = result->data[3 * this_tunableEnvironment_f2_tmp + 1];
      if ((!muDoubleScalarIsNaN(b_b)) && (muDoubleScalarIsNaN(a) || (a > b_b)))
      {
        a = b_b;
        idx->data[this_tunableEnvironment_f2_tmp] = 2;
      }

      b_b = result->data[3 * this_tunableEnvironment_f2_tmp + 2];
      if ((!muDoubleScalarIsNaN(b_b)) && (muDoubleScalarIsNaN(a) || (a > b_b)))
      {
        idx->data[this_tunableEnvironment_f2_tmp] = 3;
      }
    }
  }

  i2 = f_prev_r->size[0] * f_prev_r->size[1];
  f_prev_r->size[0] = 1;
  f_prev_r->size[1] = idx->size[1];
  emxEnsureCapacity_real_T(&b_st, f_prev_r, i2, &o_emlrtRTEI);
  b_loop_ub = idx->size[0] * idx->size[1];
  for (i2 = 0; i2 < b_loop_ub; i2++) {
    f_prev_r->data[i2] = idx->data[i2];
  }

  /*  %      ケーブルに対する制約 */
  /*  %      min([params.Sectionpoint(params.S_front(2),:);params.Sectionpoint(params.S_front(3),:)]); */
  /*              param.Sectionconect = param.sectionpoint(param.S_front(2) + FSCP-2,:); */
  iv[0] = 1;
  iv[1] = 11;
  emlrtSizeEqCheckNDR2012b(iv, *(int32_T (*)[2])f_prev_r->size, &emlrtECI, &st);
  for (i2 = 0; i2 < 2; i2++) {
    for (i3 = 0; i3 < 11; i3++) {
      a = (MPCparam_S_front[1] + f_prev_r->data[i3]) - 2.0;
      if (a != (int32_T)muDoubleScalarFloor(a)) {
        emlrtIntegerCheckR2012b(a, &c_emlrtDCI, &st);
      }

      n = (int32_T)a;
      if ((n < 1) || (n > 3)) {
        emlrtDynamicBoundsCheckR2012b(n, 1, 3, &h_emlrtBCI, &st);
      }

      param_Sectionconect[i3 + 11 * i2] = MPCparam_sectionpoint[(n + 3 * i2) - 1];
    }
  }

  /* MEX化するときに右辺が可変と認識されるのを防ぐためにめんどくさい記述方法を取る */
  /*      %自機体のセクション判別 */
  this_tunableEnvironment_f2_tmp = i - 1;
  b_this_tunableEnvironment_f2[0] =
    MPCparam_sectionpoint[this_tunableEnvironment_f2_tmp];
  n = i + 2;
  b_this_tunableEnvironment_f2[1] = MPCparam_sectionpoint[n];
  this_tunableEnvironment_f3_size[0] = loop_ub;
  this_tunableEnvironment_f3_size[1] = 11;
  for (i = 0; i < 11; i++) {
    for (i2 = 0; i2 < loop_ub; i2++) {
      this_tunableEnvironment_f3_data[i2 + loop_ub * i] = x[i2 + 12 * i];
    }
  }

  if (muDoubleScalarIsNaN(MPCparam_Num)) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else if (MPCparam_Num < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (muDoubleScalarIsInf(MPCparam_Num) && (1.0 == MPCparam_Num)) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0) + 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    b_loop_ub = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0);
    for (i = 0; i <= b_loop_ub; i++) {
      y->data[i] = (real_T)i + 1.0;
    }
  }

  b_st.site = &j_emlrtRSI;
  b_arrayfun(&b_st, this_tunableEnvironment_f1, b_this_tunableEnvironment_f2,
             this_tunableEnvironment_f3_data, this_tunableEnvironment_f3_size, y,
             f_prev_r);

  /*  前のセクションポイントとの距離 */
  this_tunableEnvironment_f1[0] =
    MPCparam_sectionpoint[this_tunableEnvironment_f2_tmp];
  this_tunableEnvironment_f2_tmp = i1 - 1;
  b_this_tunableEnvironment_f2[0] =
    MPCparam_sectionpoint[this_tunableEnvironment_f2_tmp];
  this_tunableEnvironment_f1[1] = MPCparam_sectionpoint[n];
  n = i1 + 2;
  b_this_tunableEnvironment_f2[1] = MPCparam_sectionpoint[n];
  this_tunableEnvironment_f3_size[0] = loop_ub;
  this_tunableEnvironment_f3_size[1] = 11;
  for (i = 0; i < 11; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      this_tunableEnvironment_f3_data[i1 + loop_ub * i] = x[i1 + 12 * i];
    }
  }

  if (muDoubleScalarIsNaN(MPCparam_Num)) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else if (MPCparam_Num < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (muDoubleScalarIsInf(MPCparam_Num) && (1.0 == MPCparam_Num)) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0) + 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    b_loop_ub = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0);
    for (i = 0; i <= b_loop_ub; i++) {
      y->data[i] = (real_T)i + 1.0;
    }
  }

  b_st.site = &k_emlrtRSI;
  b_arrayfun(&b_st, this_tunableEnvironment_f1, b_this_tunableEnvironment_f2,
             this_tunableEnvironment_f3_data, this_tunableEnvironment_f3_size, y,
             f_now_r);

  /*  今のセクションポイントとの距離 */
  this_tunableEnvironment_f1[0] =
    MPCparam_sectionpoint[this_tunableEnvironment_f2_tmp];
  this_tunableEnvironment_f1[1] = MPCparam_sectionpoint[n];
  this_tunableEnvironment_f3_size[0] = loop_ub;
  this_tunableEnvironment_f3_size[1] = 11;
  for (i = 0; i < 11; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      this_tunableEnvironment_f3_data[i1 + loop_ub * i] = x[i1 + 12 * i];
    }
  }

  if (muDoubleScalarIsNaN(MPCparam_Num)) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else if (MPCparam_Num < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else if (muDoubleScalarIsInf(MPCparam_Num) && (1.0 == MPCparam_Num)) {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    y->data[0] = rtNaN;
  } else {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0) + 1;
    emxEnsureCapacity_real_T(&st, y, i, &l_emlrtRTEI);
    loop_ub = (int32_T)muDoubleScalarFloor(MPCparam_Num - 1.0);
    for (i = 0; i <= loop_ub; i++) {
      y->data[i] = (real_T)i + 1.0;
    }
  }

  b_st.site = &l_emlrtRSI;
  b_arrayfun(&b_st, this_tunableEnvironment_f1, this_tunableEnvironment_f2,
             this_tunableEnvironment_f3_data, this_tunableEnvironment_f3_size, y,
             f_next_r);

  /*  次のセクションポイントとの距離 */
  b_st.site = &m_emlrtRSI;
  c_st.site = &u_emlrtRSI;
  d_st.site = &v_emlrtRSI;
  b = (f_now_r->size[1] == f_prev_r->size[1]);
  emxFree_real_T(&y);
  if (!b) {
    emlrtErrorWithMessageIdR2018a(&d_st, &c_emlrtRTEI,
      "MATLAB:catenate:matrixDimensionMismatch",
      "MATLAB:catenate:matrixDimensionMismatch", 0);
  }

  b = ((f_next_r->size[1] == f_prev_r->size[1]) && b);
  if (!b) {
    emlrtErrorWithMessageIdR2018a(&d_st, &c_emlrtRTEI,
      "MATLAB:catenate:matrixDimensionMismatch",
      "MATLAB:catenate:matrixDimensionMismatch", 0);
  }

  i = result->size[0] * result->size[1];
  result->size[0] = 3;
  result->size[1] = f_prev_r->size[1];
  emxEnsureCapacity_real_T(&c_st, result, i, &m_emlrtRTEI);
  loop_ub = f_prev_r->size[1];
  for (i = 0; i < loop_ub; i++) {
    result->data[3 * i] = f_prev_r->data[i];
  }

  loop_ub = f_now_r->size[1];
  for (i = 0; i < loop_ub; i++) {
    result->data[3 * i + 1] = f_now_r->data[i];
  }

  emxFree_real_T(&f_now_r);
  loop_ub = f_next_r->size[1];
  for (i = 0; i < loop_ub; i++) {
    result->data[3 * i + 2] = f_next_r->data[i];
  }

  emxFree_real_T(&f_next_r);
  b_st.site = &m_emlrtRSI;
  c_st.site = &w_emlrtRSI;
  d_st.site = &x_emlrtRSI;
  e_st.site = &y_emlrtRSI;
  f_st.site = &ab_emlrtRSI;
  g_st.site = &bb_emlrtRSI;
  h_st.site = &cb_emlrtRSI;
  n = result->size[1];
  i = idx->size[0] * idx->size[1];
  idx->size[0] = 1;
  idx->size[1] = result->size[1];
  emxEnsureCapacity_int8_T(&h_st, idx, i, &n_emlrtRTEI);
  loop_ub = result->size[1];
  for (i = 0; i < loop_ub; i++) {
    idx->data[i] = 1;
  }

  if (result->size[1] >= 1) {
    i_st.site = &db_emlrtRSI;
    if (result->size[1] > 2147483646) {
      j_st.site = &t_emlrtRSI;
      check_forloop_overflow_error(&j_st);
    }

    for (this_tunableEnvironment_f2_tmp = 0; this_tunableEnvironment_f2_tmp < n;
         this_tunableEnvironment_f2_tmp++) {
      a = result->data[3 * this_tunableEnvironment_f2_tmp];
      b_b = result->data[3 * this_tunableEnvironment_f2_tmp + 1];
      if ((!muDoubleScalarIsNaN(b_b)) && (muDoubleScalarIsNaN(a) || (a > b_b)))
      {
        a = b_b;
        idx->data[this_tunableEnvironment_f2_tmp] = 2;
      }

      b_b = result->data[3 * this_tunableEnvironment_f2_tmp + 2];
      if ((!muDoubleScalarIsNaN(b_b)) && (muDoubleScalarIsNaN(a) || (a > b_b)))
      {
        idx->data[this_tunableEnvironment_f2_tmp] = 3;
      }
    }
  }

  emxFree_real_T(&result);
  i = f_prev_r->size[0] * f_prev_r->size[1];
  f_prev_r->size[0] = 1;
  f_prev_r->size[1] = idx->size[1];
  emxEnsureCapacity_real_T(&b_st, f_prev_r, i, &o_emlrtRTEI);
  loop_ub = idx->size[0] * idx->size[1];
  for (i = 0; i < loop_ub; i++) {
    f_prev_r->data[i] = idx->data[i];
  }

  emxFree_int8_T(&idx);

  /*     %今の経路の番号を出す */
  iv[0] = 1;
  iv[1] = 11;
  emlrtSizeEqCheckNDR2012b(iv, *(int32_T (*)[2])f_prev_r->size, &b_emlrtECI, &st);
  for (i = 0; i < 11; i++) {
    SN[i] = (MPCparam_Section_change[1] + f_prev_r->data[i]) - 2.0;
  }

  emxFree_real_T(&f_prev_r);
  for (i = 0; i < 11; i++) {
    if (SN[i] != (int32_T)muDoubleScalarFloor(SN[i])) {
      emlrtIntegerCheckR2012b(SN[i], &b_emlrtDCI, &st);
    }

    i1 = (int32_T)SN[i];
    if ((i1 < 1) || (i1 > 2)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, 2, &g_emlrtBCI, &st);
    }

    param_wall_width_xx[i] = MPCparam_wall_width_x[i1 - 1];
  }

  for (i = 0; i < 11; i++) {
    if (SN[i] != (int32_T)muDoubleScalarFloor(SN[i])) {
      emlrtIntegerCheckR2012b(SN[i], &emlrtDCI, &st);
    }

    i1 = (int32_T)SN[i];
    if ((i1 < 1) || (i1 > 2)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, 2, &f_emlrtBCI, &st);
    }

    param_wall_width_xx[i + 11] = MPCparam_wall_width_x[i1 + 1];
  }

  for (i = 0; i < 11; i++) {
    n = (int32_T)SN[i];
    param_wall_width_yy[i] = MPCparam_wall_width_y[n - 1];
    param_wall_width_yy[i + 11] = MPCparam_wall_width_y[n + 1];
  }

  /* ---------------------------------------------------------------------------------------------%             */
  b_st.site = &n_emlrtRSI;
  autoCons(&b_st, x, MPCparam_X0, MPCparam_A, MPCparam_B, MPCparam_Slew,
           MPCparam_D_lim, MPCparam_front, MPCparam_behind, param_Sectionconect,
           param_wall_width_xx, param_wall_width_yy, MPCparam_r_limit,
           varargout_1, varargout_2, SD->u1.f0.gcineq, gceq);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

real_T b___anon_fcn(const emlrtStack *sp, const real_T f_prev_sp[2], const
                    real_T f_now_sp[2], const real_T param_front[22], real_T L)
{
  real_T varargout_1_tmp_idx_0;
  real_T varargout_1_tmp_idx_1;
  int32_T varargout_1_tmp_tmp;
  real_T scale;
  real_T absxk;
  real_T t;
  real_T y;
  real_T varargout_1_tmp[4];
  varargout_1_tmp_idx_0 = f_prev_sp[0] - f_now_sp[0];
  varargout_1_tmp_idx_1 = f_prev_sp[1] - f_now_sp[1];
  if (L != (int32_T)muDoubleScalarFloor(L)) {
    emlrtIntegerCheckR2012b(L, &m_emlrtDCI, sp);
  }

  varargout_1_tmp_tmp = (int32_T)L;
  if ((varargout_1_tmp_tmp < 1) || (varargout_1_tmp_tmp > 11)) {
    emlrtDynamicBoundsCheckR2012b(varargout_1_tmp_tmp, 1, 11, &r_emlrtBCI, sp);
  }

  scale = 3.3121686421112381E-170;
  absxk = muDoubleScalarAbs(varargout_1_tmp_idx_0);
  if (absxk > 3.3121686421112381E-170) {
    y = 1.0;
    scale = absxk;
  } else {
    t = absxk / 3.3121686421112381E-170;
    y = t * t;
  }

  varargout_1_tmp[0] = varargout_1_tmp_idx_0;
  absxk = muDoubleScalarAbs(varargout_1_tmp_idx_1);
  if (absxk > scale) {
    t = scale / absxk;
    y = y * t * t + 1.0;
    scale = absxk;
  } else {
    t = absxk / scale;
    y += t * t;
  }

  varargout_1_tmp[2] = varargout_1_tmp_idx_1;
  y = scale * muDoubleScalarSqrt(y);
  varargout_1_tmp_tmp = (varargout_1_tmp_tmp - 1) << 1;
  varargout_1_tmp[1] = param_front[varargout_1_tmp_tmp] - f_now_sp[0];
  varargout_1_tmp[3] = param_front[varargout_1_tmp_tmp + 1] - f_now_sp[1];
  return muDoubleScalarAbs(det(varargout_1_tmp)) / y;
}

real_T c___anon_fcn(const emlrtStack *sp, const real_T prev_sp[2], const real_T
                    now_sp[2], const real_T X_data[], const int32_T X_size[2],
                    real_T L)
{
  real_T varargout_1_tmp_idx_0;
  real_T varargout_1_tmp_idx_1;
  int32_T varargout_1_tmp_tmp;
  real_T scale;
  real_T absxk;
  real_T t;
  real_T y;
  real_T varargout_1_tmp[4];
  if (1 > X_size[0]) {
    emlrtDynamicBoundsCheckR2012b(1, 1, X_size[0], &s_emlrtBCI, sp);
  }

  if (5 > X_size[0]) {
    emlrtDynamicBoundsCheckR2012b(5, 1, X_size[0], &u_emlrtBCI, sp);
  }

  varargout_1_tmp_idx_0 = prev_sp[0] - now_sp[0];
  varargout_1_tmp_idx_1 = prev_sp[1] - now_sp[1];
  if (L != (int32_T)muDoubleScalarFloor(L)) {
    emlrtIntegerCheckR2012b(L, &n_emlrtDCI, sp);
  }

  varargout_1_tmp_tmp = (int32_T)L;
  if ((varargout_1_tmp_tmp < 1) || (varargout_1_tmp_tmp > 11)) {
    emlrtDynamicBoundsCheckR2012b(varargout_1_tmp_tmp, 1, 11, &t_emlrtBCI, sp);
  }

  scale = 3.3121686421112381E-170;
  absxk = muDoubleScalarAbs(varargout_1_tmp_idx_0);
  if (absxk > 3.3121686421112381E-170) {
    y = 1.0;
    scale = absxk;
  } else {
    t = absxk / 3.3121686421112381E-170;
    y = t * t;
  }

  varargout_1_tmp[0] = varargout_1_tmp_idx_0;
  absxk = muDoubleScalarAbs(varargout_1_tmp_idx_1);
  if (absxk > scale) {
    t = scale / absxk;
    y = y * t * t + 1.0;
    scale = absxk;
  } else {
    t = absxk / scale;
    y += t * t;
  }

  varargout_1_tmp[2] = varargout_1_tmp_idx_1;
  y = scale * muDoubleScalarSqrt(y);
  varargout_1_tmp_tmp = X_size[0] * (varargout_1_tmp_tmp - 1);
  varargout_1_tmp[1] = X_data[varargout_1_tmp_tmp] - now_sp[0];
  varargout_1_tmp[3] = X_data[varargout_1_tmp_tmp + 4] - now_sp[1];
  return muDoubleScalarAbs(det(varargout_1_tmp)) / y;
}

real_T d___anon_fcn(const emlrtStack *sp, const struct0_T *MPCparam, const
                    real_T x[132])
{
  real_T varargout_1;
  real_T param_V[4];
  real_T param_R[4];
  real_T param_P_chips[38];
  int32_T i;
  real_T param_Section_change[4];
  real_T param_sectionpoint[6];
  real_T param_FLD[11];
  int32_T loop_ub;
  int32_T this_tunableEnvironment_f1_size[2];
  real_T this_tunableEnvironment_f1_data[132];
  real_T param_Cdis[11];
  int32_T i1;
  real_T param_Line_Y[11];
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &ce_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  param_V[0] = MPCparam->V[0];
  param_R[0] = MPCparam->R[0];
  param_V[1] = MPCparam->V[1];
  param_R[1] = MPCparam->R[1];
  param_V[2] = MPCparam->V[2];
  param_R[2] = MPCparam->R[2];
  param_V[3] = MPCparam->V[3];
  param_R[3] = MPCparam->R[3];
  memcpy(&param_P_chips[0], &MPCparam->P_chips[0], 38U * sizeof(real_T));
  for (i = 0; i < 6; i++) {
    param_sectionpoint[i] = MPCparam->sectionpoint[i];
  }

  param_Section_change[0] = MPCparam->Section_change[0];
  param_Section_change[1] = MPCparam->Section_change[1];
  param_Section_change[2] = MPCparam->Section_change[2];
  param_Section_change[3] = MPCparam->Section_change[3];
  memcpy(&param_FLD[0], &MPCparam->FLD[0], 11U * sizeof(real_T));

  /*              % モデル予測制御の評価値を計算するプログラム */
  /*              total_size = param.state_size + param.input_size; */
  /*  %             %-- MPCで用いる予測状態 Xと予測入力 Uを設定 */
  if (1.0 > MPCparam->state_size) {
    loop_ub = 0;
  } else {
    if (MPCparam->state_size != (int32_T)muDoubleScalarFloor
        (MPCparam->state_size)) {
      emlrtIntegerCheckR2012b(MPCparam->state_size, &o_emlrtDCI, &st);
    }

    loop_ub = (int32_T)MPCparam->state_size;
    if ((loop_ub < 1) || (loop_ub > 12)) {
      emlrtDynamicBoundsCheckR2012b(loop_ub, 1, 12, &v_emlrtBCI, &st);
    }
  }

  /*              U = x(param.state_size+1:total_size, :); */
  /*              S = x(total_size+1:end,:);%スラック変数[slew;r] */
  this_tunableEnvironment_f1_size[0] = loop_ub;
  this_tunableEnvironment_f1_size[1] = 11;
  for (i = 0; i < 11; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      this_tunableEnvironment_f1_data[i1 + loop_ub * i] = x[i1 + 12 * i];
    }
  }

  b_st.site = &de_emlrtRSI;
  c_arrayfun(&b_st, this_tunableEnvironment_f1_data,
             this_tunableEnvironment_f1_size, param_sectionpoint,
             param_Section_change, param_Cdis);

  /* 1:11はホライゾン+1の値．Line_Yも同様 */
  /*              FCdis = param.FLD - Cdis;%一機前の機体との経路上距離 */
  /*              BCdis = Cdis- param.BLD;%後ろ機体との経路上の距離 */
  /*              MiddleDisF =  (FCdis - BCdis).^2; */
  /*              %参照軌道と自機体との距離　pchip区分多項式を生成　ホライゾン内における区分多項式のｙ座標 */
  this_tunableEnvironment_f1_size[0] = loop_ub;
  this_tunableEnvironment_f1_size[1] = 11;
  for (i = 0; i < 11; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      this_tunableEnvironment_f1_data[i1 + loop_ub * i] = x[i1 + 12 * i];
    }
  }

  b_st.site = &ee_emlrtRSI;
  d_arrayfun(&b_st, param_P_chips, this_tunableEnvironment_f1_data,
             this_tunableEnvironment_f1_size, param_Line_Y);

  /*               */
  /*               */
  /*              tildeT = sqrt((X(5,:) - Line_Y).^2); */
  /*              %入力と参照入力の差(目標0) */
  /*              tildeU = U; */
  /*              %自機体の速度 */
  /*              v = [X(2,:);X(6,:)]; */
  /*  %             -- 機体間距離及び参照軌道との偏差および入力のステージコストを計算 */
  /*              stageMidF =  arrayfun(@(L) MiddleDisF(:,L)' * param.Qm * MiddleDisF(:,L),1:param.H); */
  /*              stageTrajectry = arrayfun(@(L) tildeT(:,L)' * param.Qt * tildeT(:,L),1:param.H); */
  /*              stageInput = arrayfun(@(L) tildeU(:, L)' * param.R * tildeU(:, L), 1:param.H); */
  /*              stageSlack_s = arrayfun(@(L) S(1,L)' * param.W_s * S(1,L),1:param.H);%スルーレートのスラック変数 */
  /*              stageSlack_r = arrayfun(@(L) S(2,L)' * param.W_r * S(2,L),2:param.Num);%最終まで　ケーブルと壁 */
  /*              stagevelocity = arrayfun(@(L) v(:,L)' * param.V * v(:,L),1:param.H); */
  /*              %-- 状態の終端コストを計算 */
  /*              terminalMidF = MiddleDisF(:,end)' * param.Qmf * MiddleDisF(:,end); */
  /*              terminalTrajectry = tildeT(:,end)' * param.Qtf * tildeT(:,end); */
  /*              terminalvelocity = v(:,end)' * param.V * v(:,end); */
  /*              -- 評価値計算 */
  /*              eval = sum(stageMidF + stageTrajectry + stageInput + stageSlack_s + stageSlack_r + stagevelocity) + terminalTrajectry + terminalvelocity +  terminalMidF; */
  autoEval(x, param_V, MPCparam->Qm, MPCparam->Qmf, MPCparam->Qt, MPCparam->Qtf,
           param_R, MPCparam->W_s, MPCparam->W_r, param_Cdis, param_FLD,
           MPCparam->BLD, param_Line_Y, &varargout_1,
           this_tunableEnvironment_f1_data);
  return varargout_1;
}

/* End of code generation (F_HL_MPCfunc.c) */
