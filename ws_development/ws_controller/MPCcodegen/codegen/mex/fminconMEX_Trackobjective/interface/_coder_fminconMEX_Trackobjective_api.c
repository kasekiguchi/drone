/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_fminconMEX_Trackobjective_api.c
 *
 * Code generation for function '_coder_fminconMEX_Trackobjective_api'
 *
 */

/* Include files */
#include "_coder_fminconMEX_Trackobjective_api.h"
#include "fminconMEX_Trackobjective.h"
#include "fminconMEX_Trackobjective_data.h"
#include "fminconMEX_Trackobjective_emxutil.h"
#include "fminconMEX_Trackobjective_types.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo ib_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "_coder_fminconMEX_Trackobjective_api",/* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *x0,
  const char_T *identifier))[66];
static const mxArray *b_emlrt_marshallOut(const real_T u[66]);
static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[66];
static const mxArray *c_emlrt_marshallOut(const emlrtStack *sp, const struct2_T
  u);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *param, const
  char_T *identifier, struct0_T *y);
static const mxArray *d_emlrt_marshallOut(const struct3_T *u);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct0_T *y);
static const mxArray *e_emlrt_marshallOut(const real_T u[66]);
static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static const mxArray *emlrt_marshallOut(const real_T u);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[16]);
static const mxArray *f_emlrt_marshallOut(const real_T u[4356]);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[4]);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[100]);
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[44]);
static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2]);
static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[4]);
static struct1_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId);
static real_T m_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static real_T (*n_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[66];
static void o_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[16]);
static void p_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[4]);
static void q_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[100]);
static void r_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[44]);
static void s_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2]);
static void t_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[4]);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *x0,
  const char_T *identifier))[66]
{
  emlrtMsgIdentifier thisId;
  real_T (*y)[66];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = c_emlrt_marshallIn(sp, emlrtAlias(x0), &thisId);
  emlrtDestroyArray(&x0);
  return y;
}
  static const mxArray *b_emlrt_marshallOut(const real_T u[66])
{
  static const int32_T iv[2] = { 0, 0 };

  static const int32_T iv1[2] = { 6, 11 };

  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, iv1, 2);
  emlrtAssign(&y, m);
  return y;
}

static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[66]
{
  real_T (*y)[66];
  y = n_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static const mxArray *c_emlrt_marshallOut(const emlrtStack *sp, const
  struct2_T u)
{
  static const int32_T iv[2] = { 1, 3 };

  static const char_T *sv[7] = { "iterations", "funcCount", "algorithm",
    "constrviolation", "stepsize", "lssteplength", "firstorderopt" };

  const mxArray *b_y;
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  emlrtAssign(&y, emlrtCreateStructMatrix(1, 1, 7, sv));
  emlrtSetFieldR2017b(y, 0, "iterations", emlrt_marshallOut(u.iterations), 0);
  emlrtSetFieldR2017b(y, 0, "funcCount", emlrt_marshallOut(u.funcCount), 1);
  b_y = NULL;
  m = emlrtCreateCharArray(2, &iv[0]);
  emlrtInitCharArrayR2013a(sp, 3, m, &u.algorithm[0]);
  emlrtAssign(&b_y, m);
  emlrtSetFieldR2017b(y, 0, "algorithm", b_y, 2);
  emlrtSetFieldR2017b(y, 0, "constrviolation", emlrt_marshallOut
                      (u.constrviolation), 3);
  emlrtSetFieldR2017b(y, 0, "stepsize", emlrt_marshallOut(u.stepsize), 4);
  emlrtSetFieldR2017b(y, 0, "lssteplength", emlrt_marshallOut(u.lssteplength), 5);
  emlrtSetFieldR2017b(y, 0, "firstorderopt", emlrt_marshallOut(u.firstorderopt),
                      6);
  return y;
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *param, const
  char_T *identifier, struct0_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  e_emlrt_marshallIn(sp, emlrtAlias(param), &thisId, y);
  emlrtDestroyArray(&param);
}

static const mxArray *d_emlrt_marshallOut(const struct3_T *u)
{
  static const int32_T iv[1] = { 0 };

  static const int32_T iv1[1] = { 0 };

  static const int32_T iv2[1] = { 66 };

  static const int32_T iv3[1] = { 66 };

  static const char_T *sv[6] = { "eqlin", "eqnonlin", "ineqlin", "ineqnonlin",
    "lower", "upper" };

  const emxArray_real_T *b_u;
  const mxArray *b_y;
  const mxArray *c_y;
  const mxArray *d_y;
  const mxArray *e_y;
  const mxArray *f_y;
  const mxArray *g_y;
  const mxArray *m;
  const mxArray *y;
  real_T *pData;
  int32_T b_i;
  int32_T i;
  y = NULL;
  emlrtAssign(&y, emlrtCreateStructMatrix(1, 1, 6, sv));
  b_y = NULL;
  m = emlrtCreateNumericArray(1, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtAssign(&b_y, m);
  emlrtSetFieldR2017b(y, 0, "eqlin", b_y, 0);
  b_u = u->eqnonlin;
  c_y = NULL;
  m = emlrtCreateNumericArray(1, &u->eqnonlin->size[0], mxDOUBLE_CLASS, mxREAL);
  pData = emlrtMxGetPr(m);
  i = 0;
  for (b_i = 0; b_i < b_u->size[0]; b_i++) {
    pData[i] = b_u->data[b_i];
    i++;
  }

  emlrtAssign(&c_y, m);
  emlrtSetFieldR2017b(y, 0, "eqnonlin", c_y, 1);
  d_y = NULL;
  m = emlrtCreateNumericArray(1, &iv1[0], mxDOUBLE_CLASS, mxREAL);
  emlrtAssign(&d_y, m);
  emlrtSetFieldR2017b(y, 0, "ineqlin", d_y, 2);
  b_u = u->ineqnonlin;
  e_y = NULL;
  m = emlrtCreateNumericArray(1, &u->ineqnonlin->size[0], mxDOUBLE_CLASS, mxREAL);
  pData = emlrtMxGetPr(m);
  i = 0;
  for (b_i = 0; b_i < b_u->size[0]; b_i++) {
    pData[i] = b_u->data[b_i];
    i++;
  }

  emlrtAssign(&e_y, m);
  emlrtSetFieldR2017b(y, 0, "ineqnonlin", e_y, 3);
  f_y = NULL;
  m = emlrtCreateNumericArray(1, &iv2[0], mxDOUBLE_CLASS, mxREAL);
  pData = emlrtMxGetPr(m);
  i = 0;
  for (b_i = 0; b_i < 66; b_i++) {
    pData[i] = u->lower[b_i];
    i++;
  }

  emlrtAssign(&f_y, m);
  emlrtSetFieldR2017b(y, 0, "lower", f_y, 4);
  g_y = NULL;
  m = emlrtCreateNumericArray(1, &iv3[0], mxDOUBLE_CLASS, mxREAL);
  pData = emlrtMxGetPr(m);
  i = 0;
  for (b_i = 0; b_i < 66; b_i++) {
    pData[i] = u->upper[b_i];
    i++;
  }

  emlrtAssign(&g_y, m);
  emlrtSetFieldR2017b(y, 0, "upper", g_y, 5);
  return y;
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct0_T *y)
{
  static const int32_T dims = 0;
  static const char_T *fieldNames[16] = { "H", "dt", "input_size", "state_size",
    "total_size", "Num", "Q", "R", "Qf", "T", "Xr", "dis", "alpha", "phi", "X0",
    "model_param" };

  emlrtMsgIdentifier thisId;
  thisId.fParent = parentId;
  thisId.bParentIsCell = false;
  emlrtCheckStructR2012b(sp, parentId, u, 16, fieldNames, 0U, &dims);
  thisId.fIdentifier = "H";
  y->H = emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 0, "H")),
    &thisId);
  thisId.fIdentifier = "dt";
  y->dt = emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 1, "dt")),
    &thisId);
  thisId.fIdentifier = "input_size";
  y->input_size = emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0,
    2, "input_size")), &thisId);
  thisId.fIdentifier = "state_size";
  y->state_size = emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0,
    3, "state_size")), &thisId);
  thisId.fIdentifier = "total_size";
  y->total_size = emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0,
    4, "total_size")), &thisId);
  thisId.fIdentifier = "Num";
  y->Num = emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 5,
    "Num")), &thisId);
  thisId.fIdentifier = "Q";
  f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 6, "Q")),
                     &thisId, y->Q);
  thisId.fIdentifier = "R";
  g_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 7, "R")),
                     &thisId, y->R);
  thisId.fIdentifier = "Qf";
  f_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 8, "Qf")),
                     &thisId, y->Qf);
  thisId.fIdentifier = "T";
  h_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 9, "T")),
                     &thisId, y->T);
  thisId.fIdentifier = "Xr";
  i_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 10, "Xr")),
                     &thisId, y->Xr);
  thisId.fIdentifier = "dis";
  j_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 11, "dis")),
                     &thisId, y->dis.data, y->dis.size);
  thisId.fIdentifier = "alpha";
  j_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 12, "alpha")),
                     &thisId, y->alpha.data, y->alpha.size);
  thisId.fIdentifier = "phi";
  j_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 13, "phi")),
                     &thisId, y->phi.data, y->phi.size);
  thisId.fIdentifier = "X0";
  k_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 14, "X0")),
                     &thisId, y->X0);
  thisId.fIdentifier = "model_param";
  y->model_param = l_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u,
    0, 15, "model_param")), &thisId);
  emlrtDestroyArray(&u);
}

static const mxArray *e_emlrt_marshallOut(const real_T u[66])
{
  static const int32_T iv[1] = { 0 };

  static const int32_T iv1[1] = { 66 };

  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(1, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, iv1, 1);
  emlrtAssign(&y, m);
  return y;
}

static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = m_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u)
{
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m);
  return y;
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[16])
{
  o_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *f_emlrt_marshallOut(const real_T u[4356])
{
  static const int32_T iv[2] = { 0, 0 };

  static const int32_T iv1[2] = { 66, 66 };

  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, iv1, 2);
  emlrtAssign(&y, m);
  return y;
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[4])
{
  p_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[100])
{
  q_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[44])
{
  r_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y_data[], int32_T y_size[2])
{
  s_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y_data, y_size);
  emlrtDestroyArray(&u);
}

static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, real_T y[4])
{
  t_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static struct1_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId)
{
  static const int32_T dims = 0;
  static const char_T *fieldNames[1] = { "K" };

  emlrtMsgIdentifier thisId;
  struct1_T y;
  thisId.fParent = parentId;
  thisId.bParentIsCell = false;
  emlrtCheckStructR2012b(sp, parentId, u, 1, fieldNames, 0U, &dims);
  thisId.fIdentifier = "K";
  y.K = emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2017b(sp, u, 0, 0, "K")),
    &thisId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T m_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  static const int32_T dims = 0;
  real_T ret;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T (*n_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[66]
{
  static const int32_T dims[2] = { 6, 11 };

  real_T (*ret)[66];
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims);
  ret = (real_T (*)[66])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  static void o_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[16])
{
  static const int32_T dims[2] = { 4, 4 };

  real_T (*r)[16];
  int32_T i;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims);
  r = (real_T (*)[16])emlrtMxGetData(src);
  for (i = 0; i < 16; i++) {
    ret[i] = (*r)[i];
  }

  emlrtDestroyArray(&src);
}

static void p_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[4])
{
  static const int32_T dims[2] = { 2, 2 };

  real_T (*r)[4];
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims);
  r = (real_T (*)[4])emlrtMxGetData(src);
  ret[0] = (*r)[0];
  ret[1] = (*r)[1];
  ret[2] = (*r)[2];
  ret[3] = (*r)[3];
  emlrtDestroyArray(&src);
}

static void q_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[100])
{
  static const int32_T dims[2] = { 10, 10 };

  real_T (*r)[100];
  int32_T i;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims);
  r = (real_T (*)[100])emlrtMxGetData(src);
  for (i = 0; i < 100; i++) {
    ret[i] = (*r)[i];
  }

  emlrtDestroyArray(&src);
}

static void r_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[44])
{
  static const int32_T dims[2] = { 4, 11 };

  real_T (*r)[44];
  int32_T i;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims);
  r = (real_T (*)[44])emlrtMxGetData(src);
  for (i = 0; i < 44; i++) {
    ret[i] = (*r)[i];
  }

  emlrtDestroyArray(&src);
}

static void s_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret_data[], int32_T ret_size[2])
{
  static const int32_T dims[2] = { 1, 629 };

  int32_T iv[2];
  const boolean_T bv[2] = { false, true };

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv[0],
    iv);
  ret_size[0] = iv[0];
  ret_size[1] = iv[1];
  emlrtImportArrayR2015b(sp, src, (void *)ret_data, 8, false);
  emlrtDestroyArray(&src);
}

static void t_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, real_T ret[4])
{
  static const int32_T dims[1] = { 4 };

  real_T (*r)[4];
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims);
  r = (real_T (*)[4])emlrtMxGetData(src);
  ret[0] = (*r)[0];
  ret[1] = (*r)[1];
  ret[2] = (*r)[2];
  ret[3] = (*r)[3];
  emlrtDestroyArray(&src);
}

void fminconMEX_Trackobjective_api(const mxArray * const prhs[2], int32_T nlhs,
  const mxArray *plhs[7])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  struct0_T param;
  struct2_T output;
  struct3_T lambda;
  real_T (*hessian)[4356];
  real_T (*grad)[66];
  real_T (*x)[66];
  real_T (*x0)[66];
  real_T exitflag;
  real_T fval;
  st.tls = emlrtRootTLSGlobal;
  x = (real_T (*)[66])mxMalloc(sizeof(real_T [66]));
  grad = (real_T (*)[66])mxMalloc(sizeof(real_T [66]));
  hessian = (real_T (*)[4356])mxMalloc(sizeof(real_T [4356]));
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInitStruct_struct3_T(&st, &lambda, &ib_emlrtRTEI, true);

  /* Marshall function inputs */
  x0 = b_emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "x0");
  d_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "param", &param);

  /* Invoke the target function */
  fminconMEX_Trackobjective(&st, *x0, &param, *x, &fval, &exitflag, &output,
    &lambda, *grad, *hessian);

  /* Marshall function outputs */
  plhs[0] = b_emlrt_marshallOut(*x);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(fval);
  }

  if (nlhs > 2) {
    plhs[2] = emlrt_marshallOut(exitflag);
  }

  if (nlhs > 3) {
    plhs[3] = c_emlrt_marshallOut(&st, output);
  }

  if (nlhs > 4) {
    plhs[4] = d_emlrt_marshallOut(&lambda);
  }

  emxFreeStruct_struct3_T(&lambda);
  if (nlhs > 5) {
    plhs[5] = e_emlrt_marshallOut(*grad);
  }

  if (nlhs > 6) {
    plhs[6] = f_emlrt_marshallOut(*hessian);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_fminconMEX_Trackobjective_api.c) */
