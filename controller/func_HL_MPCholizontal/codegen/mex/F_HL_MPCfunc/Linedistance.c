/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Linedistance.c
 *
 * Code generation for function 'Linedistance'
 *
 */

/* Include files */
#include "Linedistance.h"
#include "F_HL_MPCfunc.h"
#include "F_HL_MPCfunc_data.h"
#include "F_HL_MPCfunc_emxutil.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T_4
#define struct_emxArray_real_T_4

struct emxArray_real_T_4
{
  real_T data[4];
  int32_T size[1];
};

#endif                                 /*struct_emxArray_real_T_4*/

#ifndef typedef_emxArray_real_T_4
#define typedef_emxArray_real_T_4

typedef struct emxArray_real_T_4 emxArray_real_T_4;

#endif                                 /*typedef_emxArray_real_T_4*/

#ifndef typedef_cell_wrap_18
#define typedef_cell_wrap_18

typedef struct {
  emxArray_real_T_4 f1;
} cell_wrap_18;

#endif                                 /*typedef_cell_wrap_18*/

/* Variable Definitions */
static emlrtRSInfo he_emlrtRSI = { 6,  /* lineNo */
  "Linedistance",                      /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\Linedistance.m"/* pathName */
};

static emlrtRSInfo ie_emlrtRSI = { 7,  /* lineNo */
  "Linedistance",                      /* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\Linedistance.m"/* pathName */
};

static emlrtRSInfo je_emlrtRSI = { 6,  /* lineNo */
  "@(N) realsqrt((calc_x(N,1)-calc_x(N+1,1))^2 + (calc_y(N,1)-calc_y(N+1,1))^2)",/* fcnName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\Linedistance.m"/* pathName */
};

static emlrtRSInfo le_emlrtRSI = { 20, /* lineNo */
  "sum",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m"/* pathName */
};

static emlrtRSInfo me_emlrtRSI = { 99, /* lineNo */
  "sumprod",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumprod.m"/* pathName */
};

static emlrtRSInfo ne_emlrtRSI = { 125,/* lineNo */
  "combineVectorElements",             /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtRSInfo oe_emlrtRSI = { 185,/* lineNo */
  "colMajorFlatIter",                  /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVectorElements.m"/* pathName */
};

static emlrtDCInfo p_emlrtDCI = { 39,  /* lineNo */
  38,                                  /* colNo */
  "function_handle/parenReference",    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\function_handle.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo y_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  39,                                  /* lineNo */
  38,                                  /* colNo */
  "calc_y",                            /* aName */
  "function_handle/parenReference",    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\function_handle.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ab_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  39,                                  /* lineNo */
  38,                                  /* colNo */
  "calc_x",                            /* aName */
  "function_handle/parenReference",    /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\eml\\+coder\\+internal\\function_handle.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo e_emlrtRTEI = { 12,/* lineNo */
  5,                                   /* colNo */
  "realsqrt",                          /* fName */
  "C:\\Program Files\\MATLAB\\R2020a\\toolbox\\eml\\lib\\matlab\\elfun\\realsqrt.m"/* pName */
};

static emlrtDCInfo q_emlrtDCI = { 5,   /* lineNo */
  26,                                  /* colNo */
  "Linedistance",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\Linedistance.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo bb_emlrtBCI = { 1,  /* iFirst */
  3,                                   /* iLast */
  4,                                   /* lineNo */
  26,                                  /* colNo */
  "Sectionpoint",                      /* aName */
  "Linedistance",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\Linedistance.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo r_emlrtDCI = { 4,   /* lineNo */
  26,                                  /* colNo */
  "Linedistance",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\Linedistance.m",/* pName */
  1                                    /* checkKind */
};

static emlrtRTEInfo w_emlrtRTEI = { 6, /* lineNo */
  1,                                   /* colNo */
  "Linedistance",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\Linedistance.m"/* pName */
};

static emlrtRTEInfo x_emlrtRTEI = { 6, /* lineNo */
  94,                                  /* colNo */
  "Linedistance",                      /* fName */
  "C:\\Users\\taku7\\Documents\\drone-master\\controller\\func_HL_MPCholizontal\\Linedistance.m"/* pName */
};

/* Function Definitions */
real_T Linedistance(const emlrtStack *sp, real_T x1, real_T b_y1, const real_T
                    Sectionpoint[6], real_T Sectionnumber)
{
  real_T Dis;
  int32_T vlen;
  cell_wrap_18 this_tunableEnvironment[2];
  int32_T i;
  emxArray_real_T *y;
  real_T inputExamples_idx_0;
  real_T a;
  emxArray_real_T *Diss;
  int32_T n;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
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
  emlrtHeapReferenceStackEnterFcnR2012b(sp);

  /* LINE_CALCULATOR  */
  /* 2点を与えると，その2点を結ぶ直線と，2点間の距離を算出して返す． */
  if (1.0 > Sectionnumber) {
    vlen = 0;
  } else {
    if (Sectionnumber != (int32_T)muDoubleScalarFloor(Sectionnumber)) {
      emlrtIntegerCheckR2012b(Sectionnumber, &r_emlrtDCI, sp);
    }

    vlen = (int32_T)Sectionnumber;
    if ((vlen < 1) || (vlen > 3)) {
      emlrtDynamicBoundsCheckR2012b(vlen, 1, 3, &bb_emlrtBCI, sp);
    }
  }

  this_tunableEnvironment[0].f1.size[0] = vlen + 1;
  for (i = 0; i < vlen; i++) {
    this_tunableEnvironment[0].f1.data[i] = Sectionpoint[i];
  }

  this_tunableEnvironment[0].f1.data[vlen] = x1;
  if (1.0 > Sectionnumber) {
    vlen = 0;
  } else {
    if (Sectionnumber != (int32_T)muDoubleScalarFloor(Sectionnumber)) {
      emlrtIntegerCheckR2012b(Sectionnumber, &q_emlrtDCI, sp);
    }

    vlen = (int32_T)Sectionnumber;
  }

  this_tunableEnvironment[1].f1.size[0] = vlen + 1;
  for (i = 0; i < vlen; i++) {
    this_tunableEnvironment[1].f1.data[i] = Sectionpoint[i + 3];
  }

  emxInit_real_T(sp, &y, 2, &x_emlrtRTEI, true);
  this_tunableEnvironment[1].f1.data[vlen] = b_y1;
  if (Sectionnumber < 1.0) {
    y->size[0] = 1;
    y->size[1] = 0;
  } else {
    i = y->size[0] * y->size[1];
    y->size[0] = 1;
    vlen = (int32_T)muDoubleScalarFloor(Sectionnumber - 1.0);
    y->size[1] = vlen + 1;
    emxEnsureCapacity_real_T(sp, y, i, &l_emlrtRTEI);
    for (i = 0; i <= vlen; i++) {
      y->data[i] = (real_T)i + 1.0;
    }
  }

  st.site = &he_emlrtRSI;
  b_st.site = &p_emlrtRSI;
  c_st.site = &q_emlrtRSI;
  if (y->size[1] == 0) {
    inputExamples_idx_0 = 0.0;
  } else {
    inputExamples_idx_0 = y->data[0];
  }

  d_st.site = &o_emlrtRSI;
  e_st.site = &d_emlrtRSI;
  f_st.site = &je_emlrtRSI;
  if (inputExamples_idx_0 + 1.0 != (int32_T)muDoubleScalarFloor
      (inputExamples_idx_0 + 1.0)) {
    emlrtIntegerCheckR2012b(inputExamples_idx_0 + 1.0, &p_emlrtDCI, &f_st);
  }

  i = (int32_T)(inputExamples_idx_0 + 1.0);
  if ((i < 1) || (i > this_tunableEnvironment[0].f1.size[0])) {
    emlrtDynamicBoundsCheckR2012b(i, 1, this_tunableEnvironment[0].f1.size[0],
      &ab_emlrtBCI, &f_st);
  }

  vlen = (int32_T)muDoubleScalarFloor(inputExamples_idx_0);
  if (inputExamples_idx_0 != vlen) {
    emlrtIntegerCheckR2012b(inputExamples_idx_0, &p_emlrtDCI, &f_st);
  }

  if (((int32_T)inputExamples_idx_0 < 1) || ((int32_T)inputExamples_idx_0 >
       this_tunableEnvironment[0].f1.size[0])) {
    emlrtDynamicBoundsCheckR2012b((int32_T)inputExamples_idx_0, 1,
      this_tunableEnvironment[0].f1.size[0], &ab_emlrtBCI, &f_st);
  }

  a = this_tunableEnvironment[0].f1.data[(int32_T)inputExamples_idx_0 - 1] -
    this_tunableEnvironment[0].f1.data[i - 1];
  f_st.site = &je_emlrtRSI;
  if (inputExamples_idx_0 + 1.0 != i) {
    emlrtIntegerCheckR2012b(inputExamples_idx_0 + 1.0, &p_emlrtDCI, &f_st);
  }

  i = (int32_T)inputExamples_idx_0 + 1;
  if ((i < 1) || (i > this_tunableEnvironment[1].f1.size[0])) {
    emlrtDynamicBoundsCheckR2012b(i, 1, this_tunableEnvironment[1].f1.size[0],
      &y_emlrtBCI, &f_st);
  }

  if ((int32_T)inputExamples_idx_0 != vlen) {
    emlrtIntegerCheckR2012b(inputExamples_idx_0, &p_emlrtDCI, &f_st);
  }

  if ((int32_T)inputExamples_idx_0 > this_tunableEnvironment[1].f1.size[0]) {
    emlrtDynamicBoundsCheckR2012b((int32_T)inputExamples_idx_0, 1,
      this_tunableEnvironment[1].f1.size[0], &y_emlrtBCI, &f_st);
  }

  inputExamples_idx_0 = this_tunableEnvironment[1].f1.data[(int32_T)
    inputExamples_idx_0 - 1] - this_tunableEnvironment[1].f1.data[i - 1];
  f_st.site = &je_emlrtRSI;
  if (a * a + inputExamples_idx_0 * inputExamples_idx_0 < 0.0) {
    emlrtErrorWithMessageIdR2018a(&f_st, &e_emlrtRTEI,
      "MATLAB:realsqrt:complexResult", "MATLAB:realsqrt:complexResult", 0);
  }

  emxInit_real_T(&f_st, &Diss, 2, &w_emlrtRTEI, true);
  i = Diss->size[0] * Diss->size[1];
  Diss->size[0] = 1;
  Diss->size[1] = (int8_T)y->size[1];
  emxEnsureCapacity_real_T(&b_st, Diss, i, &v_emlrtRTEI);
  n = y->size[1];
  c_st.site = &r_emlrtRSI;
  for (k = 0; k < n; k++) {
    c_st.site = &s_emlrtRSI;
    d_st.site = &d_emlrtRSI;
    e_st.site = &je_emlrtRSI;
    inputExamples_idx_0 = y->data[k];
    if (inputExamples_idx_0 + 1.0 != (int32_T)muDoubleScalarFloor
        (inputExamples_idx_0 + 1.0)) {
      emlrtIntegerCheckR2012b(inputExamples_idx_0 + 1.0, &p_emlrtDCI, &e_st);
    }

    i = (int32_T)(inputExamples_idx_0 + 1.0);
    if ((i < 1) || (i > this_tunableEnvironment[0].f1.size[0])) {
      emlrtDynamicBoundsCheckR2012b(i, 1, this_tunableEnvironment[0].f1.size[0],
        &ab_emlrtBCI, &e_st);
    }

    vlen = (int32_T)muDoubleScalarFloor(inputExamples_idx_0);
    if (inputExamples_idx_0 != vlen) {
      emlrtIntegerCheckR2012b(inputExamples_idx_0, &p_emlrtDCI, &e_st);
    }

    if (((int32_T)inputExamples_idx_0 < 1) || ((int32_T)inputExamples_idx_0 >
         this_tunableEnvironment[0].f1.size[0])) {
      emlrtDynamicBoundsCheckR2012b((int32_T)inputExamples_idx_0, 1,
        this_tunableEnvironment[0].f1.size[0], &ab_emlrtBCI, &e_st);
    }

    a = this_tunableEnvironment[0].f1.data[(int32_T)inputExamples_idx_0 - 1] -
      this_tunableEnvironment[0].f1.data[i - 1];
    e_st.site = &je_emlrtRSI;
    if (inputExamples_idx_0 + 1.0 != i) {
      emlrtIntegerCheckR2012b(inputExamples_idx_0 + 1.0, &p_emlrtDCI, &e_st);
    }

    i = (int32_T)inputExamples_idx_0 + 1;
    if ((i < 1) || (i > this_tunableEnvironment[1].f1.size[0])) {
      emlrtDynamicBoundsCheckR2012b(i, 1, this_tunableEnvironment[1].f1.size[0],
        &y_emlrtBCI, &e_st);
    }

    if ((int32_T)inputExamples_idx_0 != vlen) {
      emlrtIntegerCheckR2012b(inputExamples_idx_0, &p_emlrtDCI, &e_st);
    }

    if ((int32_T)inputExamples_idx_0 > this_tunableEnvironment[1].f1.size[0]) {
      emlrtDynamicBoundsCheckR2012b((int32_T)inputExamples_idx_0, 1,
        this_tunableEnvironment[1].f1.size[0], &y_emlrtBCI, &e_st);
    }

    inputExamples_idx_0 = this_tunableEnvironment[1].f1.data[(int32_T)
      inputExamples_idx_0 - 1] - this_tunableEnvironment[1].f1.data[i - 1];
    e_st.site = &je_emlrtRSI;
    inputExamples_idx_0 = a * a + inputExamples_idx_0 * inputExamples_idx_0;
    if (inputExamples_idx_0 < 0.0) {
      emlrtErrorWithMessageIdR2018a(&e_st, &e_emlrtRTEI,
        "MATLAB:realsqrt:complexResult", "MATLAB:realsqrt:complexResult", 0);
    }

    Diss->data[k] = muDoubleScalarSqrt(inputExamples_idx_0);
  }

  emxFree_real_T(&y);
  st.site = &ie_emlrtRSI;
  b_st.site = &le_emlrtRSI;
  c_st.site = &me_emlrtRSI;
  vlen = Diss->size[1];
  if (Diss->size[1] == 0) {
    Dis = 0.0;
  } else {
    d_st.site = &ne_emlrtRSI;
    Dis = Diss->data[0];
    e_st.site = &oe_emlrtRSI;
    for (k = 2; k <= vlen; k++) {
      Dis += Diss->data[k - 1];
    }
  }

  emxFree_real_T(&Diss);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
  return Dis;
}

/* End of code generation (Linedistance.c) */
