/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * TrackobjectiveMEX.c
 *
 * Code generation for function 'TrackobjectiveMEX'
 *
 */

/* Include files */
#include "TrackobjectiveMEX.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo t_emlrtRSI = { 12,  /* lineNo */
  "@(L) tildeU(:, L)\' * params.R * tildeU(:, L)",/* fcnName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m"/* pathName */
};

static emlrtRSInfo u_emlrtRSI = { 48,  /* lineNo */
  "eml_mtimes_helper",                 /* fcnName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\ops\\eml_mtimes_helper.m"/* pathName */
};

static emlrtDCInfo n_emlrtDCI = { 12,  /* lineNo */
  38,                                  /* colNo */
  "@(L) tildeU(:, L)\' * params.R * tildeU(:, L)",/* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { 1,   /* iFirst */
  11,                                  /* iLast */
  12,                                  /* lineNo */
  38,                                  /* colNo */
  "tildeU",                            /* aName */
  "@(L) tildeU(:, L)\' * params.R * tildeU(:, L)",/* fName */
  "C:\\Users\\Rigil\\Desktop\\MyProject\\drone\\ws_development\\ws_controller\\MPCcodegen\\TrackobjectiveMEX.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRTEInfo m_emlrtRTEI = { 123,/* lineNo */
  23,                                  /* colNo */
  "dynamic_size_checks",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\ops\\eml_mtimes_helper.m"/* pName */
};

static emlrtRTEInfo n_emlrtRTEI = { 118,/* lineNo */
  23,                                  /* colNo */
  "dynamic_size_checks",               /* fName */
  "C:\\Program Files\\MATLAB\\R2020b\\toolbox\\eml\\lib\\matlab\\ops\\eml_mtimes_helper.m"/* pName */
};

/* Function Definitions */
real_T c_anon(const emlrtStack *sp, const real_T tildeU_data[], const int32_T
              tildeU_size[2], const real_T params_R[4], real_T L)
{
  emlrtStack b_st;
  emlrtStack st;
  real_T b_tildeU_data[6];
  real_T c_tildeU_data[6];
  int32_T i;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if (L != (int32_T)muDoubleScalarFloor(L)) {
    emlrtIntegerCheckR2012b(L, &n_emlrtDCI, sp);
  }

  if (((int32_T)L < 1) || ((int32_T)L > 11)) {
    emlrtDynamicBoundsCheckR2012b((int32_T)L, 1, 11, &o_emlrtBCI, sp);
  }

  st.site = &t_emlrtRSI;
  b_st.site = &u_emlrtRSI;
  if (tildeU_size[0] != 2) {
    if (tildeU_size[0] == 1) {
      emlrtErrorWithMessageIdR2018a(&b_st, &n_emlrtRTEI,
        "Coder:toolbox:mtimes_noDynamicScalarExpansion",
        "Coder:toolbox:mtimes_noDynamicScalarExpansion", 0);
    } else {
      emlrtErrorWithMessageIdR2018a(&b_st, &m_emlrtRTEI, "MATLAB:innerdim",
        "MATLAB:innerdim", 0);
    }
  }

  st.site = &t_emlrtRSI;
  for (i = 0; i < 2; i++) {
    b_tildeU_data[i] = tildeU_data[i + 2 * ((int32_T)L - 1)];
  }

  for (i = 0; i < 2; i++) {
    c_tildeU_data[i] = tildeU_data[i + 2 * ((int32_T)L - 1)];
  }

  return (b_tildeU_data[0] * params_R[0] + b_tildeU_data[1] * params_R[1]) *
    c_tildeU_data[0] + (b_tildeU_data[0] * params_R[2] + b_tildeU_data[1] *
                        params_R[3]) * c_tildeU_data[1];
}

/* End of code generation (TrackobjectiveMEX.c) */
